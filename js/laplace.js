var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

(function($) {
  var Laplace;
  if ($ == null) $ = jQuery;
  Laplace = (function() {

    function Laplace(el, opts) {
      this.success = __bind(this.success, this);
      this.save = __bind(this.save, this);
      this.cancel = __bind(this.cancel, this);
      this.edit = __bind(this.edit, this);
      var $editLink, label, opt, value, _i, _len, _ref;
      this.el = $(el);
      _ref = ["type", "name", "values", "edit-label", "save-label", "cancel-label", "url", "method"];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        opt = _ref[_i];
        this.setOption(opt, opts[opt]);
      }
      this.values = (function() {
        var _j, _len2, _ref2, _ref3, _results;
        _ref2 = this.values;
        _results = [];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          value = _ref2[_j];
          if (Object.prototype.toString.call(value) === '[object Array]') {
            _ref3 = value, label = _ref3[0], value = _ref3[1];
          } else {
            label = value;
          }
          _results.push([label, value]);
        }
        return _results;
      }).call(this);
      $editLink = $("<a href='#' class='laplace-edit-label'>" + this['edit-label'] + "</a>");
      $editLink.click(this.edit);
      this.el.parent().append($editLink);
      $editLink.hide();
      this.el.parent().hover((function() {
        return $editLink.show();
      }), (function() {
        return $editLink.hide();
      }));
    }

    Laplace.prototype.setOption = function(name, defaultValue) {
      var dataValue;
      if (dataValue = this.el.closest("[data-" + name + "]").data(name)) {
        return this[name] = dataValue;
      } else {
        return this[name] = defaultValue;
      }
    };

    Laplace.prototype.edit = function() {
      var code, label, options, selected, value;
      this.el.parent().find('.laplace-edit-label').remove();
      code = (function() {
        switch (this.type) {
          case "select":
            options = (function() {
              var _i, _len, _ref, _ref2, _results;
              _ref = this.values;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                _ref2 = _ref[_i], label = _ref2[0], value = _ref2[1];
                _results.push("<option value=\"" + value + "\" " + (this.el.text() === label ? 'selected' : '') + ">" + label + "</option>");
              }
              return _results;
            }).call(this);
            return "<select name=\"" + this.name + "\">" + (options.join("\n")) + "</select>";
          case "radio-buttons":
            options = (function() {
              var _i, _len, _ref, _ref2, _results;
              _ref = this.values;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                _ref2 = _ref[_i], label = _ref2[0], value = _ref2[1];
                selected = this.el.text() === label ? 'selected' : '';
                _results.push("<label><input type=\"radio\" value=\"" + value + "\" " + selected + " name=\"" + this.name + "\" />" + label + "</label>");
              }
              return _results;
            }).call(this);
            return options.join("\n");
          default:
            return "<input type=\"" + this.type + "\" name=\"" + this.name + "\" value=\"" + (this.el.text()) + "\" />";
        }
      }).call(this);
      code += "<a href='#' class='laplace-save'>" + this["save-label"] + "</a> <a href='#' class='laplace-cancel'>" + this["cancel-label"] + "</a>";
      this.editor = $("<span>" + code + "</span>");
      this.editor.find('a.laplace-cancel').click(this.cancel);
      this.editor.find('a.laplace-save').click(this.save);
      this.el.replaceWith(this.editor);
      return false;
    };

    Laplace.prototype.cancel = function() {
      var $editLink;
      this.editor.replaceWith(this.el);
      $editLink = $("<a href='#' class='laplace-edit-label'>" + this['edit-label'] + "</a>");
      $editLink.click(this.edit);
      return this.el.parent().append($editLink);
    };

    Laplace.prototype.save = function() {
      var payload, val;
      payload = {};
      val = this.editor.find("[name=" + this.name + "]").val();
      payload[this.name] = val;
      $.ajax({
        type: this.method,
        url: this.url,
        data: payload,
        success: this.success
      });
      this.cancel();
      return this.el.text(val);
    };

    Laplace.prototype.success = function(data) {
      return this.el.html(data);
    };

    return Laplace;

  })();
  $.fn.laplace = function(options) {
    var opts;
    if (options == null) options = {};
    opts = $.extend({}, $.fn.laplace.defaults, options);
    return this.each(function() {
      var laplace;
      laplace = new Laplace(this, opts);
      return this.laplace = laplace;
    });
  };
  return $.fn.laplace.defaults = {
    "type": "text",
    "edit-label": "Edit",
    "save-label": "Save",
    "cancel-label": "Cancel",
    "method": "POST",
    "values": '[]'
  };
})($);
