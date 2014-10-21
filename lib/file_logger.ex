defmodule FileLogger do

  @moduledoc """
  Not intended for public consumption.  This hardcodes some log file names
  and behaviors that are useful across some projects I am working on.  It might
  get generalized later.
  """
  require Logger
  
  def prepare_and_rotate(log_dir) do
    
    Logger.debug "starting file logging - ensuring directory exists"
    File.mkdir_p log_dir

    debug_log  = Path.join log_dir, "debug.log"
    system_log = Path.join log_dir, "system.log"
    error_log  = Path.join log_dir, "error.log"

    Logger.debug "rotating the debug and system logs"
    rotate_log debug_log
    rotate_log system_log

    Logger.debug "starting up logger backends"
    backends = [ debug: [ path: debug_log,  level: :debug ],
                 info:  [ path: system_log, level: :info ],
                 error: [ path: error_log,  level: :error ] ]

    for {id, opts} <- backends do
      backend = {LoggerFileBackend, id}
      Logger.add_backend(backend)
      Logger.configure_backend(backend, opts)
    end

    Logger.debug "file logging should be active"

  end
  
  # given a base path, rotate the log file.  Keeps up to 10 previous logs
  defp rotate_log(f) do
    if File.exists?(f) do
      rotate_log(f, 0)
      file_move f, fdotn(f, 0)
    end
  end

  # don't rotate beyond .9 
  defp rotate_log(_f, 9) do
    nil
  end

  defp rotate_log(f, n) do
    if File.exists?(fdotn(f,n)) do
      rotate_log(f, n+1)
      file_move fdotn(f,n), fdotn(f,n+1)
    end
  end

  defp fdotn(f,n) do
    (f <> "." <> :erlang.integer_to_binary(n))
  end

  # not sure if/why I need to do this, couldn't find any File.mv or
  # File.rename in elixir, which seems broken.  I'm likely missing it
  defp file_move(old, new) do
    :file.rename :erlang.binary_to_list(old), :erlang.binary_to_list(new)
  end

end
