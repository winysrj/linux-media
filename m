Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbcGLMmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/20] [media] doc-rst: remove not used ioctls from documentation
Date: Tue, 12 Jul 2016 09:41:58 -0300
Message-Id: <76d816d83555242bd29ac737fc343ea15fc6583e.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we removed those ioctls from the header file, do the
same at the documentation side.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc-get-features.rst |  9 +--
 Documentation/media/uapi/rc/lirc_ioctl.rst        | 74 ++---------------------
 2 files changed, 9 insertions(+), 74 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index 6850f804a96c..04ba9567053a 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -91,8 +91,7 @@ LIRC features
 .. _LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE:
 
 ``LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE``
-    The driver supports
-    :ref:`LIRC_SET_REC_DUTY_CYCLE_RANGE.`
+    Unused. Kept just to avoid breaking uAPI.
 
 .. _LIRC_CAN_SET_REC_CARRIER_RANGE:
 
@@ -115,8 +114,7 @@ LIRC features
 .. _LIRC_CAN_SET_REC_FILTER:
 
 ``LIRC_CAN_SET_REC_FILTER``
-    The driver supports
-    :ref:`LIRC_SET_REC_FILTER.`
+    Unused. Kept just to avoid breaking uAPI.
 
 .. _LIRC_CAN_MEASURE_CARRIER:
 
@@ -133,8 +131,7 @@ LIRC features
 .. _LIRC_CAN_NOTIFY_DECODE:
 
 ``LIRC_CAN_NOTIFY_DECODE``
-    The driver supports
-    :ref:`LIRC_NOTIFY_DECODE.`
+    Unused. Kept just to avoid breaking uAPI.
 
 .. _LIRC_CAN_SEND_RAW:
 
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index b35c1953dc60..345e927e9d5d 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -67,26 +67,11 @@ I/O control requests
     Get supported receive modes. Only ``LIRC_MODE_MODE2`` and
     ``LIRC_MODE_LIRCCODE`` are supported by lircd.
 
-.. _LIRC_GET_SEND_CARRIER:
-
-``LIRC_GET_SEND_CARRIER``
-
-    Get carrier frequency (in Hz) currently used for transmit.
-
-.. _LIRC_GET_REC_CARRIER:
-
-``LIRC_GET_REC_CARRIER``
-
-    Get carrier frequency (in Hz) currently used for IR reception.
-
-.. _LIRC_GET_SEND_DUTY_CYCLE:
-.. _LIRC_GET_REC_DUTY_CYCLE:
 .. _LIRC_SET_SEND_DUTY_CYCLE:
-.. _LIRC_SET_REC_DUTY_CYCLE:
 
-``LIRC_{G,S}ET_{SEND,REC}_DUTY_CYCLE``
+``LIRC_SET_SEND_DUTY_CYCLE``
 
-    Get/set the duty cycle (from 0 to 100) of the carrier signal.
+    Set the duty cycle (from 0 to 100) of the carrier signal.
     Currently, no special meaning is defined for 0 or 100, but this
     could be used to switch off carrier generation in the future, so
     these values should be reserved.
@@ -114,20 +99,6 @@ I/O control requests
     both ioctls will return the same value even though the timeout
     cannot be changed.
 
-.. _LIRC_GET_MIN_FILTER_PULSE:
-.. _LIRC_GET_MAX_FILTER_PULSE:
-.. _LIRC_GET_MIN_FILTER_SPACE:
-.. _LIRC_GET_MAX_FILTER_SPACE:
-
-``LIRC_GET_M{IN,AX}_FILTER_{PULSE,SPACE}``
-
-    Some devices are able to filter out spikes in the incoming signal
-    using given filter rules. These ioctls return the hardware
-    capabilities that describe the bounds of the possible filters.
-    Filter settings depend on the IR protocols that are expected. lircd
-    derives the settings from all protocols definitions found in its
-    config file.
-
 .. _LIRC_GET_LENGTH:
 
 ``LIRC_GET_LENGTH``
@@ -179,16 +150,6 @@ I/O control requests
     Enable (1) or disable (0) timeout reports in ``LIRC_MODE_MODE2.`` By
     default, timeout reports should be turned off.
 
-.. _LIRC_SET_REC_FILTER_PULSE:
-.. _LIRC_SET_REC_FILTER_SPACE:
-.. _LIRC_SET_REC_FILTER:
-
-``LIRC_SET_REC_FILTER_{PULSE,SPACE}``
-
-    Pulses/spaces shorter than this are filtered out by hardware. If
-    filters cannot be set independently for pulse/space, the
-    corresponding ioctls must return an error and ``LIRC_SET_REC_FILTER``
-    shall be used instead.
 
 .. _LIRC_SET_MEASURE_CARRIER_MODE:
 .. _lirc-mode2-frequency:
@@ -199,40 +160,17 @@ I/O control requests
     press on, the driver will send ``LIRC_MODE2_FREQUENCY`` packets. By
     default this should be turned off.
 
-.. _LIRC_SET_REC_DUTY_CYCLE_RANGE:
+
 .. _LIRC_SET_REC_CARRIER_RANGE:
 
-``LIRC_SET_REC_{DUTY_CYCLE,CARRIER}_RANGE``
+``LIRC_SET_REC_CARRIER_RANGE``
 
     To set a range use
-    ``LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE``
+    ``LIRC_SET_REC_CARRIER_RANGE``
     with the lower bound first and later
-    ``LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER`` with the upper
+    ``LIRC_SET_REC_CARRIER`` with the upper
     bound.
 
-.. _LIRC_NOTIFY_DECODE:
-
-``LIRC_NOTIFY_DECODE``
-
-    This ioctl is called by lircd whenever a successful decoding of an
-    incoming IR signal could be done. This can be used by supporting
-    hardware to give visual feedback to the user e.g. by flashing a LED.
-
-.. _LIRC_SETUP_START:
-.. _LIRC_SETUP_END:
-
-``LIRC_SETUP_{START,END}``
-
-    Setting of several driver parameters can be optimized by
-    encapsulating the according ioctl calls with
-    ``LIRC_SETUP_START/LIRC_SETUP_END.`` When a driver receives a
-    ``LIRC_SETUP_START`` ioctl it can choose to not commit further setting
-    changes to the hardware until a ``LIRC_SETUP_END`` is received. But
-    this is open to the driver implementation and every driver must also
-    handle parameter changes which are not encapsulated by
-    ``LIRC_SETUP_START`` and ``LIRC_SETUP_END.`` Drivers can also choose to
-    ignore these ioctls.
-
 .. _LIRC_SET_WIDEBAND_RECEIVER:
 
 ``LIRC_SET_WIDEBAND_RECEIVER``
-- 
2.7.4


