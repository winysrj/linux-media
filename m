Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51674 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296AbcGLMmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/20] [media] doc-rst: document ioctl LIRC_GET_REC_MODE
Date: Tue, 12 Jul 2016 09:42:02 -0300
Message-Id: <dbe678dd213ea1793ab72885e9ce1b1c8978ebf8.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the documentation of this ioctl from lirc_ioctl to its
own file, and add a short description about the pulse mode
used by IR RX.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  | 59 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         |  9 ----
 3 files changed, 60 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-get-rec-mode.rst

diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
new file mode 100644
index 000000000000..d46a488594c9
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -0,0 +1,59 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_get_rec_mode:
+
+***********************
+ioctl LIRC_GET_REC_MODE
+***********************
+
+Name
+====
+
+LIRC_GET_REC_MODE - Get supported receive modes.
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 rx_modes)
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_GET_REC_MODE
+
+``rx_modes``
+    Bitmask with the supported transmit modes.
+
+Description
+===========
+
+Get supported receive modes.
+
+Supported receive modes
+=======================
+
+.. _lirc-mode-mode2:
+
+``LIRC_MODE_MODE2``
+
+    The driver returns a sequence of pulse and space codes to userspace.
+
+.. _lirc-mode-lirccode:
+
+``LIRC_MODE_LIRCCODE``
+
+    The IR signal is decoded internally by the receiver. The LIRC interface
+    returns the scancode as an integer value. This is the usual mode used
+    by several TV media cards.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index f6ebf09cca60..34044b0c8f9c 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -14,4 +14,5 @@ LIRC Device Interface
     lirc_write
     lirc-get-features
     lirc-get-send-mode
+    lirc-get-rec-mode
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index 8e9809a03b8f..4656e30a5b5a 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -49,15 +49,6 @@ device can rely on working with the default settings initially.
 I/O control requests
 ====================
 
-.. _LIRC_GET_REC_MODE:
-.. _lirc-mode-mode2:
-.. _lirc-mode-lirccode:
-
-``LIRC_GET_REC_MODE``
-
-    Get supported receive modes. Only ``LIRC_MODE_MODE2`` and
-    ``LIRC_MODE_LIRCCODE`` are supported by lircd.
-
 .. _LIRC_SET_SEND_DUTY_CYCLE:
 
 ``LIRC_SET_SEND_DUTY_CYCLE``
-- 
2.7.4


