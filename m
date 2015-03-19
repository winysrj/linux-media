Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:52377 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbbCSVuU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 17:50:20 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [RFC PATCH 1/6] [media] lirc: remove broken features
Date: Thu, 19 Mar 2015 21:50:12 +0000
Message-Id: <814dd6f912bbf1eac3ad037a9634c2797df0a699.1426801061.git.sean@mess.org>
In-Reply-To: <cover.1426801061.git.sean@mess.org>
References: <cover.1426801061.git.sean@mess.org>
In-Reply-To: <cover.1426801061.git.sean@mess.org>
References: <cover.1426801061.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The LIRC_GET_FEATURES ioctl returns an int which represents features as
bitwise flags. Two features use duplicate values so they are unusable.
These are also features which have never been implemented in drivers
according to kernel/lirc git history, so noone ever noticed that they're
half-baked.

LIRC_CAN_NOTIFY_DECODE has the same value as LIRC_CAN_SET_REC_CARRIER, so
this feature cannot be detected properly. The LIRC_NOTIFY_DECODE ioctl was
never implemented so remove it. The intent was that a led would be flashed
when the ioctl is called. IR receivers with a led have this handled via
the led interface and the rc-feedback led trigger.

LIRC_CAN_SET_REC_DUTY_CYCLE has the same value as LIRC_CAN_MEASURE_CARRIER,
so there is no way to detect it. The idea was that the
LIRC_SET_REC_DUTY_CYCLE and LIRC_SET_REC_DUTY_CYCLE_RANGE ioctls could be
used to setup a filter for a lower and upper bound of a duty cycle. No
hardware has implemented this; why would you.

Since there never was, or will be, an implementation of these, this is not
an ABI change.

Signed-off-by: Sean Young <sean@mess.org>
---
 .../DocBook/media/v4l/lirc_device_interface.xml    | 16 ++++------------
 include/media/lirc.h                               | 22 ++++------------------
 2 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/lirc_device_interface.xml b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
index 34cada2..25926bd 100644
--- a/Documentation/DocBook/media/v4l/lirc_device_interface.xml
+++ b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
@@ -101,7 +101,7 @@ on working with the default settings initially.</para>
     </listitem>
   </varlistentry>
   <varlistentry>
-    <term>LIRC_{G,S}ET_{SEND,REC}_DUTY_CYCLE</term>
+    <term>LIRC_{G,S}ET_SEND_DUTY_CYCLE</term>
     <listitem>
       <para>Get/set the duty cycle (from 0 to 100) of the carrier signal. Currently,
       no special meaning is defined for 0 or 100, but this could be used to switch
@@ -204,22 +204,14 @@ on working with the default settings initially.</para>
     </listitem>
   </varlistentry>
   <varlistentry>
-    <term>LIRC_SET_REC_{DUTY_CYCLE,CARRIER}_RANGE</term>
+    <term>LIRC_SET_REC_CARRIER_RANGE</term>
     <listitem>
-      <para>To set a range use LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE
-      with the lower bound first and later LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER
+      <para>To set a range use LIRC_SET_REC_CARRIER_RANGE
+      with the lower bound first and later LIRC_SET_REC_CARRIER
       with the upper bound.</para>
     </listitem>
   </varlistentry>
   <varlistentry>
-    <term>LIRC_NOTIFY_DECODE</term>
-    <listitem>
-      <para>This ioctl is called by lircd whenever a successful decoding of an
-      incoming IR signal could be done. This can be used by supporting hardware
-      to give visual feedback to the user e.g. by flashing a LED.</para>
-    </listitem>
-  </varlistentry>
-  <varlistentry>
     <term>LIRC_SETUP_{START,END}</term>
     <listitem>
       <para>Setting of several driver parameters can be optimized by encapsulating
diff --git a/include/media/lirc.h b/include/media/lirc.h
index 4b3ab29..7b845f8 100644
--- a/include/media/lirc.h
+++ b/include/media/lirc.h
@@ -67,23 +67,17 @@
 
 #define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
 
-#define LIRC_CAN_SET_REC_CARRIER       (LIRC_CAN_SET_SEND_CARRIER << 16)
-#define LIRC_CAN_SET_REC_DUTY_CYCLE    (LIRC_CAN_SET_SEND_DUTY_CYCLE << 16)
-
-#define LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE 0x40000000
 #define LIRC_CAN_SET_REC_CARRIER_RANGE    0x80000000
 #define LIRC_CAN_GET_REC_RESOLUTION       0x20000000
 #define LIRC_CAN_SET_REC_TIMEOUT          0x10000000
 #define LIRC_CAN_SET_REC_FILTER           0x08000000
-
-#define LIRC_CAN_MEASURE_CARRIER          0x02000000
 #define LIRC_CAN_USE_WIDEBAND_RECEIVER    0x04000000
+#define LIRC_CAN_MEASURE_CARRIER          0x02000000
+#define LIRC_CAN_SET_REC_CARRIER          0x01000000
 
 #define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
 #define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
 
-#define LIRC_CAN_NOTIFY_DECODE            0x01000000
-
 /*** IOCTL commands for lirc driver ***/
 
 #define LIRC_GET_FEATURES              _IOR('i', 0x00000000, __u32)
@@ -93,7 +87,6 @@
 #define LIRC_GET_SEND_CARRIER          _IOR('i', 0x00000003, __u32)
 #define LIRC_GET_REC_CARRIER           _IOR('i', 0x00000004, __u32)
 #define LIRC_GET_SEND_DUTY_CYCLE       _IOR('i', 0x00000005, __u32)
-#define LIRC_GET_REC_DUTY_CYCLE        _IOR('i', 0x00000006, __u32)
 #define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, __u32)
 
 #define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
@@ -113,7 +106,6 @@
 #define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, __u32)
 #define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, __u32)
 #define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, __u32)
-#define LIRC_SET_REC_DUTY_CYCLE        _IOW('i', 0x00000016, __u32)
 #define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, __u32)
 
 /*
@@ -149,17 +141,11 @@
 #define LIRC_SET_MEASURE_CARRIER_MODE	_IOW('i', 0x0000001d, __u32)
 
 /*
- * to set a range use
- * LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE with the
- * lower bound first and later
- * LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER with the upper bound
+ * to set a range use LIRC_SET_REC_CARRIER_RANGE with the
+ * lower bound first and later LIRC_SET_REC_CARRIER with the upper bound
  */
-
-#define LIRC_SET_REC_DUTY_CYCLE_RANGE  _IOW('i', 0x0000001e, __u32)
 #define LIRC_SET_REC_CARRIER_RANGE     _IOW('i', 0x0000001f, __u32)
 
-#define LIRC_NOTIFY_DECODE             _IO('i', 0x00000020)
-
 #define LIRC_SETUP_START               _IO('i', 0x00000021)
 #define LIRC_SETUP_END                 _IO('i', 0x00000022)
 
-- 
2.1.0

