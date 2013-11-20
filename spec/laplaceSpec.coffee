describe "Laplace", ->
	it "should configure correctly", ->
		$('body').append("""
		<div data-save-label="save2" data-cancel-label='cancel2'>
		<span id='lap' data-url='url' data-cancel-label='cancel3'>Value</span>
		</div>
		""")
		$('#lap').laplace(
			'save-label': 'save1'
			'edit-label': 'edit1'
			'cancel-label': 'cancel1'
		)
		
		laplace = $('#lap')[0].laplace

		expect(laplace['save-label']).toBe('save2')     # inheriting from parent
		expect(laplace['cancel-label']).toBe('cancel3') # overriding all other things
		expect(laplace['edit-label']).toBe('edit1')     # configuation object
		expect(laplace['url']).toBe('url')              # not inherited value on element
		expect(laplace['type']).toBe('text')            # default value
		$('#lap').parent().remove()
	
	beforeEach ->
		$('body').append("""
		<div class="lcontainer">
		<span class="laplace" data-url='/api'>Value</span>
		</div>
		""")
		
	afterEach ->
		$('.lcontainer').remove()
	
	it "should display the edit button", ->
		$('.laplace').laplace()
		expect($('.laplace').parent().children().last().text()).toBe('Edit')
		
	it "should display a text editor", ->
		$('.laplace').laplace name: 'name', type: 'text'
		$parent = $('.laplace').parent()
		$parent.find('a').click()
		expect($parent.find("input[type=text]").length).toBe(1)
		expect($parent.find("input[type=text]").val()).toBe("Value")
		expect($parent.find("a").length).toBe(2)
	
	it "should display a select", ->
		$('.laplace').laplace name: "name", type: 'select', values: [["Label1", "Value1"], "Label and Value"]
		$parent = $('.laplace').parent()
		$parent.find('a').click()
		expect($parent.find('select').length).toBe(1)
		options = $parent.find('select>option')
		expect(options.length).toBe(2)
		expect($(options[0]).text()).toBe("Label1")
		expect($(options[0]).attr('value')).toBe("Value1")
		expect($(options[1]).text()).toBe("Label and Value")
		expect($(options[1]).attr('value')).toBe("Label and Value")
		
	it "should display radio buttons", ->
		$('.laplace').laplace name: "name", type: 'radio-buttons', values: [["Label1", "Value1"], "Label and Value"]
		$parent = $('.laplace').parent()
		$parent.find('a').click()
		expect($parent.find('input[type=radio]').length).toBe(2)
		expect($parent.find('label').length).toBe(2)
		
	it "should allow the user to cancel", ->
		$('.laplace').laplace name: 'name', type: 'text'
		$parent = $('.laplace').parent()
		$parent.find('a').click()
		$parent.find('a.laplace-cancel').click()
		expect($parent.children().length).toBe(2)
		expect($parent.children().first().text()).toBe("Value")
		
	it "should allow the user to save and immediately show the chosen value", ->
		$('.laplace').laplace name: 'name', type: 'text'
		$parent = $('.laplace').parent()
		$parent.find('a').click()
		$parent.find('input').val('Updated Value')
		$parent.find('a.laplace-save').click()
		expect($parent.children().length).toBe(2)
		expect($parent.children().first().text()).toBe("Updated Value")

	it "should after saving update with the server value", (done) ->
		$('.laplace').laplace name: 'name', type: 'text'
		$parent = $('.laplace').parent()
		$parent.find('a').click()
		$parent.find('input').val('Updated Value')
		$parent.find('a.laplace-save').click()
		expect($parent.children().length).toBe(2)
		expect($parent.children().first().text()).toBe("Updated Value")
		setTimeout ->
			expect($parent.children().first().text()).toBe("Sucessfuly saved")
			done()
		, 1100












		