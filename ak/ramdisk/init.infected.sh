#!/system/bin/sh

  echo 10 > /sys/module/cpu_boost/parameters/dynamic_stune_boost 
  echo "0:0" > /sys/module/cpu_boost/parameters/input_boost_freq 
  echo 500 > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms 
  echo 0 > /dev/stune/top-app/schedtune.sched_boost 
  echo 1 > /dev/stune/foreground/schedtune.sched_boost 
  echo 1 > /dev/stune/background/schedtune.sched_boost 
  echo 1 > /dev/stune/rt/schedtune.sched_boost 
  echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 
  echo 1200 > /sys/module/cpu_boost/parameters/powerkey_input_boost_ms
  echo 10 > /sys/class/thermal/thermal_message/sconfig
  echo 2323200 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
  echo 1209600 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq
  echo 1612800 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq

