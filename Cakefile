{exec} = require 'child_process'

# This task is aimed at making a release, it will make a full release level build and
# compile and commit to the dedicated git branch a new version of the documentation.
task "full", ->
  build ->
	  exec "git checkout gh-pages", (e) ->
	    console.log e if e
	    exec "git merge master -m 'update docs'", (e) ->
	      console.log e if e
	      exec "docco -o docs lib/laplace.coffee", (e) ->
	        console.log e if e
	        exec "git add docs", (e) ->
	          exec "git commit -m \"Updated docs\"", (e) ->
	            exec "git checkout master", (e) ->
	              exec "rm -r docs"


build = (cb) ->
  exec "coffee -cb lib/laplace.coffee", (e) ->
    console.log e if e
    exec "uglifyjs2 lib/laplace.js -o js/jquery.laplace.min.js -c -m", (e) ->
      console.log e if e
      exec "rm lib/laplace.js", (e) ->
        cb() if cb

task 'build', ->
	build()
	
fs  = require("fs")

# This will start a development server for making edits on this module.
# Principially, it gives two URLs for use:
#    - http://localhost:8888/ which servers as a page where you can play with ICUI objects.
#    - http://localhost:8888/spec/ which runs the projects test suite.
# Furthermore it compiles on the fly all coffeescript files and serves all the static files.
task 'develop', ->
  http = require("http")
  url = require("url")
  
  console.log "Listening on http://localhost:8888/ ..."
  http.createServer (request, response) ->
    uri = url.parse(request.url).pathname
    extension = uri.split('.').pop()
    if uri == '/'
      response.writeHead(200)
      response.write("""<html>
        <head>
          <title>Laplace Test</title>
          <script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
          <script src="/lib/laplace.js?nocache=#{Math.random()}"></script>
          <link rel="stylesheet" href="app.css" />
        </head>
        <body>
          <h1>Blank</h1>
          <div>Greeting: <span class="laplace" data-url="/api">Hello</span></div>
					<div>County: <span class="laplace" data-url="/api" data-name='country' data-type="select" data-values='["United Kingdom", "United States", "Bolivia"]'>Bolivia</span></div>
          <script>
          $(function(){
							$('.laplace').laplace();  
					});
          </script>
        </body>
      </html>""", "UTF-8")
      response.end()

    if uri == '/spec/'
      response.writeHead(200)
      scripts = ["jasmine-2.0.0-rc2/jasmine.js", "jasmine-2.0.0-rc2/jasmine-html.js", "jasmine-2.0.0-rc2/boot.js", "http://code.jquery.com/jquery-1.10.2.min.js", "../lib/laplace.js", "spec/SpecHelper.js"]
      scripts.push(f.replace(/.coffee$/, '.js')) for f in fs.readdirSync('./spec') when f.match(/Spec.coffee/)
      script_tags = ("<script type='text/javascript' src='#{f}'></script>" for f in scripts).join("\n")
      response.write("""<!DOCTYPE HTML>
      <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Jasmine Spec Runner v2.0.0-rc2</title>
        <link rel="shortcut icon" type="image/png" href="jasmine-2.0.0-rc2/jasmine_favicon.png">
        <link rel="stylesheet" type="text/css" href="jasmine-2.0.0-rc2/jasmine.css">
        #{script_tags}
      </head>
      <body></body>
      </html>""", "UTF-8")
      response.end()
    else if extension == 'js' && !uri.match(/jasmine/)
      comps = uri.split('.')
      comps.pop()
      sendCompiledFile(response, comps.join('.'))
    else if uri == '/api'
      setTimeout ->
        response.writeHead(200)
        response.write("Sucessfuly saved")
        response.end()
      , 1000
    else
      sendFile(response, uri[1..])
  .listen 8888


sendFile = (response, path, cb = ->) ->
  fs.readFile path, "binary", (err, file) ->
    if err
      console.log err
      response.writeHead 404
      response.end()
    else
      response.write(file, "binary")
      response.end()
      cb()

sendCompiledFile = (response, path, cb = ->) ->
  path = path[1..]
  console.log path
  exec "coffee -pb #{path}.coffee", (e, o) ->
    if e
      console.log e
      response.write("""$(function() {document.write("<h1>Compile Error</h1><pre>#{("" + e).replace(/\n/g, "\\n")}</pre>");});""", 'UTF-8')
      response.end()
    else
      response.write(o, "UTF-8")
      response.end()