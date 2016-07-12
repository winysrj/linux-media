Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51668 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbcGLMmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/20] [media] doc-rst: document ioctl LIRC_GET_SEND_MODE
Date: Tue, 12 Jul 2016 09:42:00 -0300
Message-Id: <3f3427c46664cdf130b981aa833cf2ee3189b8d4.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the documentation of this ioctl from lirc_ioctl to its
own file, and add a short description about the pulse mode
used by IR TX.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc-get-send-mode.rst | 48 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         |  9 ----
 3 files changed, 49 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-get-send-mode.rst

diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
new file mode 100644
index 000000000000..f58f0953851c
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -0,0 +1,48 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_get_send_mode:
+
+************************
+ioctl LIRC_GET_SEND_MODE
+************************
+
+Name
+====
+
+LIRC_GET_SEND_MODE - Get supported transmit mode.
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *tx_modes )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_GET_SEND_MODE
+
+``tx_modes``
+    Bitmask with the supported transmit modes.
+
+
+Description
+===========
+
+Get supported transmit mode.
+
+.. _lirc-mode-pulse:
+
+Currently, only ``LIRC_MODE_PULSE`` is supported by lircd on TX. On
+puse mode, a sequence of pulse/space integer values are written to the
+lirc device using ``write()``.
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index fe13f7d65d30..f6ebf09cca60 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -13,4 +13,5 @@ LIRC Device Interface
     lirc_read
     lirc_write
     lirc-get-features
+    lirc-get-send-mode
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index 345e927e9d5d..8e9809a03b8f 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -49,15 +49,6 @@ device can rely on working with the default settings initially.
 I/O control requests
 ====================
 
-
-.. _LIRC_GET_SEND_MODE:
-.. _lirc-mode-pulse:
-
-``LIRC_GET_SEND_MODE``
-
-    Get supported transmit mode. Only ``LIRC_MODE_PULSE`` is supported by
-    lircd.
-
 .. _LIRC_GET_REC_MODE:
 .. _lirc-mode-mode2:
 .. _lirc-mode-lirccode:
-- 
2.7.4


