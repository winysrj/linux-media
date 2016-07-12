Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308AbcGLMmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 11/20] [media] doc-rst: document LIRC_GET_*_TIMEOUT ioctls
Date: Tue, 12 Jul 2016 09:42:05 -0300
Message-Id: <76e23479f9b772f1419df691c30e2f5e4ac92cb0.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve the documentation for those ioctls, adding them to
a separate file, in order to look like the rest of the
book, and to later allow to generate a man page for those
ioctls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc-get-timeout.rst   | 55 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         | 13 -----
 3 files changed, 56 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-get-timeout.rst

diff --git a/Documentation/media/uapi/rc/lirc-get-timeout.rst b/Documentation/media/uapi/rc/lirc-get-timeout.rst
new file mode 100644
index 000000000000..6b8238f1f30e
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-get-timeout.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_get_min_timeout:
+.. _lirc_get_max_timeout:
+
+****************************************************
+ioctls LIRC_GET_MIN_TIMEOUT and LIRC_GET_MAX_TIMEOUT
+****************************************************
+
+Name
+====
+
+LIRC_GET_MIN_TIMEOUT / LIRC_GET_MAX_TIMEOUT - Obtain the possible timeout
+range for IR receive.
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *timeout)
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_GET_MIN_TIMEOUT or LIRC_GET_MAX_TIMEOUT
+
+``timeout``
+    Timeout, in microseconds.
+
+
+Description
+===========
+
+Some devices have internal timers that can be used to detect when
+there's no IR activity for a long time. This can help lircd in
+detecting that a IR signal is finished and can speed up the decoding
+process. Returns an integer value with the minimum/maximum timeout
+that can be set.
+
+.. note::
+
+   Some devices have a fixed timeout, in that case
+   both ioctls will return the same value even though the timeout
+   cannot be changed via :ref:`LIRC_SET_REC_TIMEOUT`.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index 56f2d6122238..197173f9ece5 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -17,4 +17,5 @@ LIRC Device Interface
     lirc-get-rec-mode
     lirc-get-rec-resolution
     lirc-set-send-duty-cycle
+    lirc-get-timeout
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index c486703b95b8..0a16659e9dad 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -49,19 +49,6 @@ device can rely on working with the default settings initially.
 I/O control requests
 ====================
 
-.. _LIRC_GET_MIN_TIMEOUT:
-.. _LIRC_GET_MAX_TIMEOUT:
-
-``LIRC_GET_M{IN,AX}_TIMEOUT``
-
-    Some devices have internal timers that can be used to detect when
-    there's no IR activity for a long time. This can help lircd in
-    detecting that a IR signal is finished and can speed up the decoding
-    process. Returns an integer value with the minimum/maximum timeout
-    that can be set. Some devices have a fixed timeout, in that case
-    both ioctls will return the same value even though the timeout
-    cannot be changed.
-
 .. _LIRC_GET_LENGTH:
 
 ``LIRC_GET_LENGTH``
-- 
2.7.4


