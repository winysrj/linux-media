Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207AbcGLMmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 17/20] [media] doc-rst: add documentation for LIRC_SET_MEASURE_CARRIER_MODE
Date: Tue, 12 Jul 2016 09:42:11 -0300
Message-Id: <f7262dd2d0f8fe3700d80d72af151cc3b0864bd6.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Place documentation for this ioctl on its own page.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../uapi/rc/lirc-set-measure-carrier-mode.rst      | 48 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         |  9 ----
 3 files changed, 49 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst

diff --git a/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst b/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
new file mode 100644
index 000000000000..e145d9d1902d
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
@@ -0,0 +1,48 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_measure_carrier_mode:
+
+***********************************
+ioctl LIRC_SET_MEASURE_CARRIER_MODE
+***********************************
+
+Name
+====
+
+LIRC_SET_MEASURE_CARRIER_MODE - enable or disable measure mode
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *enable )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_SET_MEASURE_CARRIER_MODE
+
+``enable``
+    enable = 1 means enable measure mode, enable = 0 means disable measure
+    mode.
+
+
+Description
+===========
+
+.. _lirc-mode2-frequency:
+
+Enable or disable measure mode. If enabled, from the next key
+press on, the driver will send ``LIRC_MODE2_FREQUENCY`` packets. By
+default this should be turned off.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index 9e57779ca2a6..2810253ba852 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -25,4 +25,5 @@ LIRC Device Interface
     lirc-set-send-carrier
     lirc-set-transmitter-mask
     lirc-set-rec-timeout-reports
+    lirc-set-measure-carrier-mode
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index d99fa0eeef4c..d220fc233e6d 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -54,15 +54,6 @@ device can rely on working with the default settings initially.
     Set send/receive mode. Largely obsolete for send, as only
     ``LIRC_MODE_PULSE`` is supported.
 
-.. _LIRC_SET_MEASURE_CARRIER_MODE:
-.. _lirc-mode2-frequency:
-
-``LIRC_SET_MEASURE_CARRIER_MODE``
-
-    Enable (1)/disable (0) measure mode. If enabled, from the next key
-    press on, the driver will send ``LIRC_MODE2_FREQUENCY`` packets. By
-    default this should be turned off.
-
 .. _LIRC_SET_WIDEBAND_RECEIVER:
 
 ``LIRC_SET_WIDEBAND_RECEIVER``
-- 
2.7.4


