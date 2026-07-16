if {[catch {restructure -target delay -slack_threshold -0.5} err]} {
    puts "INFO: restructure skipped: $err"
}
repair_timing -setup -setup_margin 0.0
