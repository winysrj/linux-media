Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285AbcGLMmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/20] [media] doc-rst: document LIRC_SET_SEND_DUTY_CYCLE
Date: Tue, 12 Jul 2016 09:42:04 -0300
Message-Id: <978084b1939f5561a2e43cb49247485503ef4706.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a separate page for this ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/rc/lirc-set-send-duty-cycle.rst     | 49 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         |  9 ----
 3 files changed, 50 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst

diff --git a/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst b/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
new file mode 100644
index 000000000000..48e7bb15fb69
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
@@ -0,0 +1,49 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_send_duty_cycle:
+
+******************************
+ioctl LIRC_SET_SEND_DUTY_CYCLE
+******************************
+
+Name
+====
+
+LIRC_SET_SEND_DUTY_CYCLE - Set the duty cycle of the carrier signal for
+IR transmit.
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *duty_cycle)
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_SET_SEND_DUTY_CYCLE
+
+``duty_cycle``
+    Duty cicle, describing the pulse width in percent (from 1 to 99) of
+    the total cycle. Values 0 and 100 are reserved.
+
+
+Description
+===========
+
+Get/set the duty cycle of the carrier signal for IR transmit.
+
+Currently, no special meaning is defined for 0 or 100, but this
+could be used to switch off carrier generation in the future, so
+these values should be reserved.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index 532f4e92d1e9..56f2d6122238 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -16,4 +16,5 @@ LIRC Device Interface
     lirc-get-send-mode
     lirc-get-rec-mode
     lirc-get-rec-resolution
+    lirc-set-send-duty-cycle
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index 347b86d368b4..c486703b95b8 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -49,15 +49,6 @@ device can rely on working with the default settings initially.
 I/O control requests
 ====================
 
-.. _LIRC_SET_SEND_DUTY_CYCLE:
-
-``LIRC_SET_SEND_DUTY_CYCLE``
-
-    Set the duty cycle (from 0 to 100) of the carrier signal.
-    Currently, no special meaning is defined for 0 or 100, but this
-    could be used to switch off carrier generation in the future, so
-    these values should be reserved.
-
 .. _LIRC_GET_MIN_TIMEOUT:
 .. _LIRC_GET_MAX_TIMEOUT:
 
-- 
2.7.4


