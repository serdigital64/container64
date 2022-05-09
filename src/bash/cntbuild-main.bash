#
# Main
#

declare cntbuild_status=1
declare cntbuild_command_tag=''
declare cntbuild_command=''
declare cntbuild_option=''
declare cntbuild_container=''
declare cntbuild_version='0.1.0'
declare cntbuild_context=''

cntbuild_setup_globals
(($# == 0)) && cntbuild_help && exit 1
while getopts ':buc:e:o:h' cntbuild_option; do
  case "$cntbuild_option" in
  b)
    cntbuild_command='cntbuild_build'
    cntbuild_command_tag='build container'
    ;;
  u)
    cntbuild_command='cntbuild_publish'
    cntbuild_command_tag='publish images to external registry'
    ;;
  c) cntbuild_container="$OPTARG" ;;
  e) cntbuild_version="$OPTARG" ;;
  o) cntbuild_context="$OPTARG" ;;
  h) cntbuild_help && exit 0 ;;
  *) cntbuild_help && exit 1 ;;
  esac
done
cntbuild_check_requirements || exit 1

bl64_msg_show_batch_start "$cntbuild_command_tag"
case "$cntbuild_command" in
'cntbuild_build') "$cntbuild_command" "$cntbuild_container" "$cntbuild_version" "$cntbuild_context" ;;
'cntbuild_publish') "$cntbuild_command" "$cntbuild_container" "$cntbuild_version" ;;
*) bl64_check_show_undefined "$cntbuild_command" ;;
esac
cntbuild_status=$?

bl64_msg_show_batch_finish $cntbuild_status "$cntbuild_command_tag"
exit $cntbuild_status
