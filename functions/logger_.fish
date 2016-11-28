set -g __logger_format_DEBUG "<fg:blue>%s</fg> <fg:purple>[%s]</fg> :: <fg:green>[%s]</fg>"
set -g __logger_format_INFO "<fg:blue>%s</fg> <fg:purple>[%s]</fg> :: <fg:green>[%s]</fg>"
set -g __logger_format_WARN "<fg:yellow>%s</fg> <fg:purple>[%s]</fg> :: <fg:blue>[%s]</fg>"
set -g __logger_format_ERROR "<fg:ffAA00>%s</fg> <fg:purple>[%s]</fg> :: <fg:yellow>[%s]</fg>"
set -g __logger_format_FATAL "<fg:red>%s</fg> <fg:purple>[%s]</fg> :: <fg:red>[%s]</fg>"
set -g __logger_format_CRITICAL "<bg:red><fg:white>%s</fg></bg> <fg:purple>[%s]</fg> :: <fg:red>[%s]</fg>"

set -g __logger_severities_labels "DEBUG" "INFO" "WARN" "ERROR" "FATAL" "CRITICAL"
set -g __logger_severities 1 2 3 4 5 6

set -g __logger_dir_preferred "~/log/fish"
set -g __logger_dir_alternate "/tmp/fish"

if test -d "$__logger_dir_preferred/logger_"
  set -g __logger_dir "$__logger_dir_preferred/logger_"
else if test -d "$__logger_dir_alternate/logger_"
  set -g __logger_dir "$__logger_dir_alternate/logger_"
else
  command mkdir -p "$__logger_dir_alternate/logger_"
  set -g __logger_dir "$__logger_dir_alternate/logger_"
end

# debug/ or for extraneous(on-call) use
set -g __logger_file_DEBUG	"$__logger_dir/logger_$__logger_severities[1]_$__logger_severities_labels[1]"
set -g __logger_file_INFO	"$__logger_dir/logger_$__logger_severities[2]_$__logger_severities_labels[2]"
set -g __logger_file_WARN	"$__logger_dir/logger_$__logger_severities[3]_$__logger_severities_labels[3]"
set -g __logger_file_ERROR	"$__logger_dir/logger_$__logger_severities[4]_$__logger_severities_labels[4]"
set -g __logger_file_FATAL	"$__logger_dir/logger_$__logger_severities[5]_$__logger_severities_labels[5]"
set -g __logger_file_CRITICAL	"$__logger_dir/logger_$__logger_severities[6]_$__logger_severities_labels[6]"


function logger_ -a message -a severity -a LOGGER_MODE -d "Empower your log capabilities to the maximum level"

# check for LOGGER_MODE
if test -z $LOGGER_MODE
	set LOGGER_MODE 0
else
	switch $LOGGER_MODE;
		case 'stdout' 'to-stdout' 0 'default' 'file' 'to-file' 'silent' 1 'loud' 'too-loud' 'to-both' '2'
			# do nothing
	  	case '*'
			set LOGGER_MODE 0
	end
end

  set -l label
  set -l format

  if test -z "$severity"
    set severity 1
  end
  set label $__logger_severities_labels[$severity]
  set format "__logger_format_"$label

  switch $LOGGER_MODE # default: stdout
    case 'stdout' 'to-stdout' 0 'default'
      cprintf $$format $label (date) $message

    case 'file' 'to-file' 'silent' 1 # to-file
      echo $label (date) $message | tee -a $__logger_dir/logger_$__logger_severities[$severity]_$__logger_severities_labels[$severity];

    case 'loud' 'too-loud' 'to-both' 2 # to-both
      cprintf $$format $label (date) $message;
      echo $label (date) $message | tee -a $__logger_dir/logger_$__logger_severities[$severity]_$__logger_severities_labels[$severity];

    case '*' # default: stdout
      cprintf $$format $label (date) $message
  end

 # //test: strip colour/s from tee -> file
  # cprintf $$format $label (date) $message | gsed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' | tee -a $__logger_dir/logger_$__logger_severities[$severity]_$__logger_severities_labels[$severity]
  # gstdbuf --input=0 --output=0 --error=0 cprintf $$format $label (date) $message | tee -a $__logger_file_$severity_$__logger_severities_labels[$severity]
  # gstdbuf --input=0 --output=0 --error=0 echo $$format $label (date) $message | tee -a $__logger_file_$severity_$__logger_severities_labels[$severity]
  # echo $$format $label (date) $message | gsed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' | tee -a $__logger_file_$severity_$__logger_severities_labels[$severity]
end


function logger_debug -a message -d "Alias of 'logger_ <msg>' or 'logger_ <msg> 1'"
  logger_ $message 1
end


function logger_info -a message -d "Alias of 'logger_ <msg> 2'"
  logger_ $message 2
end


function logger_warn -a message -d "Alias of 'logger_ <msg> 3'"
  logger_ $message 3
end


function logger_error -a message -d "Alias of 'logger_ <msg> 4'"
  logger_ $message 4
end


function logger_fatal -a message -d "Alias of 'logger_ <msg> 5'"
  logger_ $message 5
end


function logger_critical -a message -d "Alias of 'logger_ <msg> 6'"
  logger_ $message 6
end
