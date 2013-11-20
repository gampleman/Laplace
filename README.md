Laplace
=======


Laplace is meant to be a simple, but reusable in-place editor built in CoffeeScript.

It is controlled by a simple data api inspired by Bootstrap.

You can see a [quick demo](http://code.gampleman.eu/Laplace/) or read the [annotated source code](http://code.gampleman.eu/Laplace/docs/laplace.html).

### Usage

To make something editable, first give it the class `laplace`. Then set several data attributes either on the element itself, or on a parent element, or in the configuration object (in order of prefference).

`url` - Where to post updated data. 

`method` - Defaults to `POST`.

`name` - Use as the forms name value.

`type` - What kind of input is this supposed to be. Supports all values of the `type` attribute for the `input` tag (except file), plus the special values of `select` and `radio-buttons`. These require also the following to be set:

`values` - The possible values as a JSON array. Either `["value", "value", ...]` or `[["Label", "Value"], ["Label", "Value"]]` syntax is supported.

`edit-label` - The text to use for displaying the edit button. Defaults to `"Edit"`.

`save-label` - The text to use for displaying the save button. Defaults to `"Save"`.

`cancel-label` - The text to use for displaying the cancel button. Defaults to `"Cancel"`.

### Integration

Your webapp will be sent the updated value as if the user was editing a regular form and should return a response with the 200 status code and whatever the field should be displaying.

### License

Copyright 2013 by Jakub Hampl. MIT Licensed.