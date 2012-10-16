logger =    require 'mimosa-logger'

module.exports = class JSCompiler

  lifecycleRegistration: (config, register) ->
    register ['add','update','buildFile'], 'compile', @_compile, [@extensions...]

  _compile: (config, options, next) =>
    i = 0
    newFiles = []
    options.files.forEach (file) =>
      @compile file, (err, output) =>
        if err
          logger.error "File [[ #{file.inputFileName} ]] failed compile. Reason: #{err}"
        else
          if config.virgin
            logger.success "Compiled/copied [[ #{file.outputFileName} ]]", options
          file.outputFileText = output
          newFiles.push file

        if ++i is options.files.length
          options.files = newFiles
          next()