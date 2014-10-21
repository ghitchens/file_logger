FileLogger
==========

Not really intended to be useful in general, this is a simple logger
configuration that provides a standard debug/system/error log, with rotation
for the debug and system logs, and persistent error log.

It also provides a helper to ensure the log files exist and rotate them as 
needed.

Feel free to use as an example for your own logging config

## Usage:

    FileLogger.prepare_and_rotate "/path/to/log/files/directory"
    
    
    
