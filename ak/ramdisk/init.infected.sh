#!/system/bin/sh

  echo 6 > /sys/module/cpu_boost/parameters/dynamic_stune_boost 
  echo "0:0" > /sys/module/cpu_boost/parameters/input_boost_freq 
  echo 500 > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms 
  echo 0 > /dev/stune/top-app/schedtune.sched_boost 
  echo 1 > /dev/stune/foreground/schedtune.sched_boost 
  echo 1 > /dev/stune/background/schedtune.sched_boost 
  echo 1 > /dev/stune/rt/schedtune.sched_boost 
  echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 
  echo 800 > /sys/module/cpu_boost/parameters/powerkey_input_boost_ms
  echo 10 > /sys/class/thermal/thermal_message/sconfig
