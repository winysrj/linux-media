Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284AbcGLMmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/20] [media] doc-rst: Document ioctl LIRC_GET_FEATURES
Date: Tue, 12 Jul 2016 09:41:55 -0300
Message-Id: <2779afef9e93941f485152e6f3db983e80e2216b.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation for this ioctl was really crappy.

Add a better documentation, using the lirc.4 man pages as a
reference, plus what was written originally at the lirc-ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/lirc.h.rst.exceptions          |  35 -----
 Documentation/media/uapi/rc/lirc-get-features.rst  | 168 +++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |   1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         |   8 -
 4 files changed, 169 insertions(+), 43 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-get-features.rst

diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index 58439ef3b9d7..17f6e7e9550d 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -37,38 +37,3 @@ ignore define LIRC_VALUE_MASK
 ignore define LIRC_MODE2_MASK
 
 ignore define LIRC_MODE_RAW
-
-ignore define LIRC_CAN_SEND_RAW
-ignore define LIRC_CAN_SEND_PULSE
-ignore define LIRC_CAN_SEND_MODE2
-ignore define LIRC_CAN_SEND_LIRCCODE
-
-ignore define LIRC_CAN_SEND_MASK
-
-ignore define LIRC_CAN_SET_SEND_CARRIER
-ignore define LIRC_CAN_SET_SEND_DUTY_CYCLE
-ignore define LIRC_CAN_SET_TRANSMITTER_MASK
-
-ignore define LIRC_CAN_REC_RAW
-ignore define LIRC_CAN_REC_PULSE
-ignore define LIRC_CAN_REC_MODE2
-ignore define LIRC_CAN_REC_LIRCCODE
-
-ignore define LIRC_CAN_REC_MASK
-
-ignore define LIRC_CAN_SET_REC_CARRIER
-ignore define LIRC_CAN_SET_REC_DUTY_CYCLE
-
-ignore define LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE
-ignore define LIRC_CAN_SET_REC_CARRIER_RANGE
-ignore define LIRC_CAN_GET_REC_RESOLUTION
-ignore define LIRC_CAN_SET_REC_TIMEOUT
-ignore define LIRC_CAN_SET_REC_FILTER
-
-ignore define LIRC_CAN_MEASURE_CARRIER
-ignore define LIRC_CAN_USE_WIDEBAND_RECEIVER
-
-ignore define LIRC_CAN_SEND(x)
-ignore define LIRC_CAN_REC(x)
-
-ignore define LIRC_CAN_NOTIFY_DECODE
diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
new file mode 100644
index 000000000000..6850f804a96c
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -0,0 +1,168 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_get_features:
+
+***********************
+ioctl LIRC_GET_FEATURES
+***********************
+
+Name
+====
+
+LIRC_GET_FEATURES - Get the underlying hardware device's features
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *features)
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_GET_FEATURES
+
+``features``
+    Bitmask with the LIRC features.
+
+
+Description
+===========
+
+
+Get the underlying hardware device's features. If a driver does not
+announce support of certain features, calling of the corresponding ioctls
+is undefined.
+
+LIRC features
+=============
+
+.. _LIRC_CAN_REC_RAW:
+
+``LIRC_CAN_REC_RAW``
+    The driver is capable of receiving using
+    :ref:`LIRC_MODE_RAW.`
+
+.. _LIRC_CAN_REC_PULSE:
+
+``LIRC_CAN_REC_PULSE``
+    The driver is capable of receiving using
+    :ref:`LIRC_MODE_PULSE.`
+
+.. _LIRC_CAN_REC_MODE2:
+
+``LIRC_CAN_REC_MODE2``
+    The driver is capable of receiving using
+    :ref:`LIRC_MODE_MODE2.`
+
+.. _LIRC_CAN_REC_LIRCCODE:
+
+``LIRC_CAN_REC_LIRCCODE``
+    The driver is capable of receiving using
+    :ref:`LIRC_MODE_LIRCCODE.`
+
+.. _LIRC_CAN_SET_SEND_CARRIER:
+
+``LIRC_CAN_SET_SEND_CARRIER``
+    The driver supports changing the modulation frequency via
+    :ref:`LIRC_SET_SEND_CARRIER.`
+
+.. _LIRC_CAN_SET_SEND_DUTY_CYCLE:
+
+``LIRC_CAN_SET_SEND_DUTY_CYCLE``
+    The driver supports changing the duty cycle using
+    :ref:`LIRC_SET_SEND_DUTY_CYCLE`.
+
+.. _LIRC_CAN_SET_TRANSMITTER_MASK:
+
+``LIRC_CAN_SET_TRANSMITTER_MASK``
+    The driver supports changing the active transmitter(s) using
+    :ref:`LIRC_SET_TRANSMITTER_MASK.`
+
+.. _LIRC_CAN_SET_REC_CARRIER:
+
+``LIRC_CAN_SET_REC_CARRIER``
+    The driver supports setting the receive carrier frequency using
+    :ref:`LIRC_SET_REC_CARRIER.`
+
+.. _LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE:
+
+``LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE``
+    The driver supports
+    :ref:`LIRC_SET_REC_DUTY_CYCLE_RANGE.`
+
+.. _LIRC_CAN_SET_REC_CARRIER_RANGE:
+
+``LIRC_CAN_SET_REC_CARRIER_RANGE``
+    The driver supports
+    :ref:`LIRC_SET_REC_CARRIER_RANGE.`
+
+.. _LIRC_CAN_GET_REC_RESOLUTION:
+
+``LIRC_CAN_GET_REC_RESOLUTION``
+    The driver supports
+    :ref:`LIRC_GET_REC_RESOLUTION.`
+
+.. _LIRC_CAN_SET_REC_TIMEOUT:
+
+``LIRC_CAN_SET_REC_TIMEOUT``
+    The driver supports
+    :ref:`LIRC_SET_REC_TIMEOUT.`
+
+.. _LIRC_CAN_SET_REC_FILTER:
+
+``LIRC_CAN_SET_REC_FILTER``
+    The driver supports
+    :ref:`LIRC_SET_REC_FILTER.`
+
+.. _LIRC_CAN_MEASURE_CARRIER:
+
+``LIRC_CAN_MEASURE_CARRIER``
+    The driver supports measuring of the modulation frequency using
+    :ref:`LIRC_SET_MEASURE_CARRIER_MODE`.
+
+.. _LIRC_CAN_USE_WIDEBAND_RECEIVER:
+
+``LIRC_CAN_USE_WIDEBAND_RECEIVER``
+    The driver supports learning mode using
+    :ref:`LIRC_SET_WIDEBAND_RECEIVER.`
+
+.. _LIRC_CAN_NOTIFY_DECODE:
+
+``LIRC_CAN_NOTIFY_DECODE``
+    The driver supports
+    :ref:`LIRC_NOTIFY_DECODE.`
+
+.. _LIRC_CAN_SEND_RAW:
+
+``LIRC_CAN_SEND_RAW``
+    The driver supports sending using
+    :ref:`LIRC_MODE_RAW.`
+
+.. _LIRC_CAN_SEND_PULSE:
+
+``LIRC_CAN_SEND_PULSE``
+    The driver supports sending using
+    :ref:`LIRC_MODE_PULSE.`
+
+.. _LIRC_CAN_SEND_MODE2:
+
+``LIRC_CAN_SEND_MODE2``
+    The driver supports sending using
+    :ref:`LIRC_MODE_MODE2.`
+
+.. _LIRC_CAN_SEND_LIRCCODE:
+
+``LIRC_CAN_SEND_LIRCCODE``
+    The driver supports sending codes (also called as IR blasting or IR TX).
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index a0c27ed5ad73..fe13f7d65d30 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -12,4 +12,5 @@ LIRC Device Interface
     lirc_dev_intro
     lirc_read
     lirc_write
+    lirc-get-features
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index 77f39d11e226..b35c1953dc60 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -50,14 +50,6 @@ I/O control requests
 ====================
 
 
-.. _LIRC_GET_FEATURES:
-
-``LIRC_GET_FEATURES``
-
-    Obviously, get the underlying hardware device's features. If a
-    driver does not announce support of certain features, calling of the
-    corresponding ioctls is undefined.
-
 .. _LIRC_GET_SEND_MODE:
 .. _lirc-mode-pulse:
 
-- 
2.7.4


