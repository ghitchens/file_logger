defmodule FileLoggerTest do

  use ExUnit.Case

  require Logger

  test "lame test" do
    FileLogger.start "/tmp/file_logger_test"    
    Logger.error "hey to error log!!!"    
    Logger.debug "hey to debug log"
    Logger.info "hey to info log"
  end
  
end
