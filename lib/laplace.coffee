# Laplace
# =======
#
# Laplace is a very simple in place editor written in object oriented CoffeeScript and
# distributed as a jQuery (or Zepto) plugin. This is the annotated source code.
do ($ = jQuery) ->
	# The Laplace class takes care of a single editable value in the page.
	class Laplace
		# The constructor function is responsible for initializing options and adding an edit link that
		# will display on hover. 
		constructor: (el, opts) ->
			@el = $ el
			for opt in ["type", "name", "values", "edit-label", "save-label", "cancel-label", "url", "method"]
				@setOption opt, opts[opt]
			# Laplace needs to accept two syntaxes for values for radio buttons and selects. One is of the form:
			#
			#     ["Value 1", "Value 2"]
			#
			# Which gets transformed into:
			#
			#     <select>
			#       <option value="Value 1">Value 1</option>
			#       <option value="Value 2">Value 2</option>
			#     </select>
			#
			# The other syntax:
			#
			#     [["Label 1", "Value 1"], ["Label 2", "Value 2"]]
			#
			# Gets transformed into:
			#
			#     <select>
			#       <option value="Value 1">Label 1</option>
			#       <option value="Value 2">Label 2</option>
			#     </select>
			@values = for value in @values
				if Object::toString.call(value) is '[object Array]'
					[label, value] = value
				else
					label = value
				[label, value]
			@makeEditLink()
		
		# Options are evaluated in a hierarchy of precedence:  
		# 1. data attribute on the element itself
		# 2. data attributes on parent elements in order of proximity
		# 3. an options object passed to the `laplace` call
		# 4. the `$.fn.laplace.defaults`
		setOption: (name, defaultValue) ->
			if dataValue = @el.closest("[data-#{name}]").data(name)
				@[name] = dataValue
			else
				@[name] = defaultValue
		
		# Creates a link next to the target element that shows on hover of the parent element.
		makeEditLink: ->
			$editLink = $ "<a href='#' class='laplace-edit-label'>#{@['edit-label']}</a>"
			$editLink.click(@edit)
			@el.parent().append($editLink)
			$editLink.hide()
			@el.parent().hover (-> $editLink.show()), (-> $editLink.hide())
		
		# When we need to edit a field we need to dynamically construct the HTML interface.
		edit: =>
			@el.parent().find('.laplace-edit-label').remove()
			code = switch @type
				when "select"
					options = for [label, value] in @values
						"""<option value="#{value}" #{if @el.text() is label then 'selected' else ''}>#{label}</option>"""
						
					"""<select name="#{@name}">#{options.join("\n")}</select>"""
				when "radio-buttons"
					options = for [label, value] in @values
						selected = if @el.text() is label then 'checked' else ''
						"""<label><input type="radio" value="#{value}" #{selected} name="#{@name}" />#{label}</label>"""
					options.join("\n")
				when "textarea"
					"""<textarea name="#{@name}">#{@el.text()}</textarea>"""
				else
					"""<input type="#{@type}" name="#{@name}" value="#{@el.text()}" />"""
					
			code += """<a href='#' class='laplace-save'>#{@["save-label"]}</a> <a href='#' class='laplace-cancel'>#{@["cancel-label"]}</a>"""	
			@editor = $ "<span>#{code}</span>"
			@editor.find('a.laplace-cancel').click @cancel
			@editor.find('a.laplace-save').click @save
			@el.replaceWith(@editor)
			return false
		
		# Canceling is just about restoring the original element and re-adding the edit link.
		cancel: =>
			@editor.replaceWith @el
			@makeEditLink()
		
		# When saving, the selected value is immediately displayed to the user so he has instant
		# feedback about what is going on. In the meantime we fire an AJAX call to the server.
		save: =>
			payload = {}
			if @type is 'radio-buttons'
				val = @editor.find("input:radio[name=#{@name}]:checked").val()
			else
				val = @editor.find("[name=#{@name}]").val()
			payload[@name] = val
			console.log payload
			$.ajax 
				type: @method
				url: @url
				data: payload
				success: @success
			@cancel()
			@el.text(val)
		
		# When the AJAX call completes we simply tell our element to display the new content.
		success: (data) =>
			@el.html(data)
	
	# Finally we package it all up as a jQuery plugin, allowing mass setting of options.
	$.fn.laplace = (options = {}) ->
		opts = $.extend({}, $.fn.laplace.defaults, options)
		@each ->
			@laplace = new Laplace @, opts
	
	# The default options are exposed like this so, perhaps for localization purposes,
	# they can be globally overrriden.	
	$.fn.laplace.defaults = {
		"type": "text"
		"edit-label": "Edit"
		"save-label": "Save"
		"cancel-label": "Cancel"
		"method": "POST"
		"values": []
	}
		