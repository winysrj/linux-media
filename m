Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34919 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756464AbdJJRhc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 13:37:32 -0400
Date: Tue, 10 Oct 2017 12:36:16 -0500
From: Tom Saeger <tom.saeger@oracle.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Tom Saeger <tom.saeger@oracle.com>, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] Documentation: fix admin-guide doc refs
Message-ID: <cb36f708432be4da0f043f3fc7e910b2046ea4ad.1507653970.git.tom.saeger@oracle.com>
References: <cover.1507653969.git.tom.saeger@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1507653969.git.tom.saeger@oracle.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make admin-guide document refs valid.

Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 Documentation/ABI/stable/sysfs-devices             | 2 +-
 Documentation/ABI/testing/sysfs-devices-system-cpu | 6 ++++--
 Documentation/ABI/testing/sysfs-power              | 6 ++++--
 Documentation/admin-guide/README.rst               | 2 +-
 Documentation/admin-guide/kernel-parameters.txt    | 4 ++--
 Documentation/admin-guide/reporting-bugs.rst       | 4 ++--
 Documentation/laptops/laptop-mode.txt              | 6 +++---
 Documentation/media/v4l-drivers/bttv.rst           | 2 +-
 Documentation/power/interface.txt                  | 3 ++-
 9 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-devices b/Documentation/ABI/stable/sysfs-devices
index 35c457f8ce73..4404bd9b96c1 100644
--- a/Documentation/ABI/stable/sysfs-devices
+++ b/Documentation/ABI/stable/sysfs-devices
@@ -1,5 +1,5 @@
 # Note: This documents additional properties of any device beyond what
-# is documented in Documentation/sysfs-rules.txt
+# is documented in Documentation/admin-guide/sysfs-rules.rst
 
 What:		/sys/devices/*/of_node
 Date:		February 2015
diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index f3d5817c4ef0..d6d862db3b5d 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -187,7 +187,8 @@ Description:	Processor frequency boosting control
 		This switch controls the boost setting for the whole system.
 		Boosting allows the CPU and the firmware to run at a frequency
 		beyound it's nominal limit.
-		More details can be found in Documentation/cpu-freq/boost.txt
+		More details can be found in
+		Documentation/admin-guide/pm/cpufreq.rst
 
 
 What:		/sys/devices/system/cpu/cpu#/crash_notes
@@ -223,7 +224,8 @@ Description:	Parameters for the Intel P-state driver
 		no_turbo: limits the driver to selecting P states below the turbo
 		frequency range.
 
-		More details can be found in Documentation/cpu-freq/intel-pstate.txt
+		More details can be found in
+		Documentation/admin-guide/pm/intel_pstate.rst
 
 What:		/sys/devices/system/cpu/cpu*/cache/index*/<set_of_attributes_mentioned_below>
 Date:		July 2014(documented, existed before August 2008)
diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/testing/sysfs-power
index a1d1612f3651..1e0d1dac706b 100644
--- a/Documentation/ABI/testing/sysfs-power
+++ b/Documentation/ABI/testing/sysfs-power
@@ -18,7 +18,8 @@ Description:
 		Writing one of the above strings to this file causes the system
 		to transition into the corresponding state, if available.
 
-		See Documentation/power/states.txt for more information.
+		See Documentation/admin-guide/pm/sleep-states.rst for more
+		information.
 
 What:		/sys/power/mem_sleep
 Date:		November 2016
@@ -35,7 +36,8 @@ Description:
 		represented by it to be used on subsequent attempts to suspend
 		the system.
 
-		See Documentation/power/states.txt for more information.
+		See Documentation/admin-guide/pm/sleep-states.rst for more
+		information.
 
 What:		/sys/power/disk
 Date:		September 2006
diff --git a/Documentation/admin-guide/README.rst b/Documentation/admin-guide/README.rst
index b5343c5aa224..63066db39910 100644
--- a/Documentation/admin-guide/README.rst
+++ b/Documentation/admin-guide/README.rst
@@ -350,7 +350,7 @@ If something goes wrong
    help debugging the problem.  The text above the dump is also
    important: it tells something about why the kernel dumped code (in
    the above example, it's due to a bad kernel pointer). More information
-   on making sense of the dump is in Documentation/admin-guide/oops-tracing.rst
+   on making sense of the dump is in Documentation/admin-guide/bug-hunting.rst
 
  - If you compiled the kernel with CONFIG_KALLSYMS you can send the dump
    as is, otherwise you will have to use the ``ksymoops`` program to make
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 05496622b4ef..e857bbbc8575 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2248,7 +2248,7 @@
 			s2idle  - Suspend-To-Idle
 			shallow - Power-On Suspend or equivalent (if supported)
 			deep    - Suspend-To-RAM or equivalent (if supported)
-			See Documentation/power/states.txt.
+			See Documentation/admin-guide/pm/sleep-states.rst.
 
 	meye.*=		[HW] Set MotionEye Camera parameters
 			See Documentation/video4linux/meye.txt.
@@ -3134,7 +3134,7 @@
 
 	plip=		[PPT,NET] Parallel port network link
 			Format: { parport<nr> | timid | 0 }
-			See also Documentation/parport.txt.
+			See also Documentation/admin-guide/parport.rst.
 
 	pmtmr=		[X86] Manual setup of pmtmr I/O Port.
 			Override pmtimer IOPort with a hex value.
diff --git a/Documentation/admin-guide/reporting-bugs.rst b/Documentation/admin-guide/reporting-bugs.rst
index 26b60b419652..4650edb8840a 100644
--- a/Documentation/admin-guide/reporting-bugs.rst
+++ b/Documentation/admin-guide/reporting-bugs.rst
@@ -94,7 +94,7 @@ step-by-step instructions for how a user can trigger the bug.
 
 If the failure includes an "OOPS:", take a picture of the screen, capture
 a netconsole trace, or type the message from your screen into the bug
-report.  Please read "Documentation/admin-guide/oops-tracing.rst" before posting your
+report.  Please read "Documentation/admin-guide/bug-hunting.rst" before posting your
 bug report. This explains what you should do with the "Oops" information
 to make it useful to the recipient.
 
@@ -120,7 +120,7 @@ summary from [1.]>" for easy identification by the developers::
   [4.2.] Kernel .config file:
   [5.] Most recent kernel version which did not have the bug:
   [6.] Output of Oops.. message (if applicable) with symbolic information
-       resolved (see Documentation/admin-guide/oops-tracing.rst)
+       resolved (see Documentation/admin-guide/bug-hunting.rst)
   [7.] A small shell script or example program which triggers the
        problem (if possible)
   [8.] Environment
diff --git a/Documentation/laptops/laptop-mode.txt b/Documentation/laptops/laptop-mode.txt
index 19276f5d195c..1c707fc9b141 100644
--- a/Documentation/laptops/laptop-mode.txt
+++ b/Documentation/laptops/laptop-mode.txt
@@ -184,7 +184,7 @@ is done when dirty_ratio is reached.
 DO_CPU:
 
 Enable CPU frequency scaling when in laptop mode. (Requires CPUFreq to be setup.
-See Documentation/cpu-freq/user-guide.txt for more info. Disabled by default.)
+See Documentation/admin-guide/pm/cpufreq.rst for more info. Disabled by default.)
 
 CPU_MAXFREQ:
 
@@ -287,7 +287,7 @@ MINIMUM_BATTERY_MINUTES=10
 
 # Should the maximum CPU frequency be adjusted down while on battery?
 # Requires CPUFreq to be setup.
-# See Documentation/cpu-freq/user-guide.txt for more info
+# See Documentation/admin-guide/pm/cpufreq.rst for more info
 #DO_CPU=0
 
 # When on battery what is the maximum CPU speed that the system should
@@ -378,7 +378,7 @@ BATT_HD=${BATT_HD:-'4'}
 DIRTY_RATIO=${DIRTY_RATIO:-'40'}
 
 # cpu frequency scaling
-# See Documentation/cpu-freq/user-guide.txt for more info
+# See Documentation/admin-guide/pm/cpufreq.rst for more info
 DO_CPU=${CPU_MANAGE:-'0'}
 CPU_MAXFREQ=${CPU_MAXFREQ:-'slowest'}
 
diff --git a/Documentation/media/v4l-drivers/bttv.rst b/Documentation/media/v4l-drivers/bttv.rst
index 195ccaac2816..5f35e2fb5afa 100644
--- a/Documentation/media/v4l-drivers/bttv.rst
+++ b/Documentation/media/v4l-drivers/bttv.rst
@@ -307,7 +307,7 @@ console and let some terminal application log the messages.  /me uses
 screen.  See Documentation/admin-guide/serial-console.rst for details on setting
 up a serial console.
 
-Read Documentation/admin-guide/oops-tracing.rst to learn how to get any useful
+Read Documentation/admin-guide/bug-hunting.rst to learn how to get any useful
 information out of a register+stack dump printed by the kernel on
 protection faults (so-called "kernel oops").
 
diff --git a/Documentation/power/interface.txt b/Documentation/power/interface.txt
index 974916ff6608..7dc75f48e8bd 100644
--- a/Documentation/power/interface.txt
+++ b/Documentation/power/interface.txt
@@ -24,7 +24,8 @@ platform.
 
 If one of the strings listed in /sys/power/state is written to it, the system
 will attempt to transition into the corresponding sleep state.  Refer to
-Documentation/power/states.txt for a description of each of those states.
+Documentation/admin-guide/pm/sleep-states.rst for a description of each of
+those states.
 
 /sys/power/disk controls the operating mode of hibernation (Suspend-to-Disk).
 Specifically, it tells the kernel what to do after creating a hibernation image.
-- 
2.14.2
