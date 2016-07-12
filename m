Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289AbcGLMmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/20] [media] doc-rst: document LIRC_GET_REC_RESOLUTION
Date: Tue, 12 Jul 2016 09:42:03 -0300
Message-Id: <6d9f4d799ba7f2618e3117fc09fb72aeeccb08fc.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve the documentation for this ioctl, adding it to
a separate file, in order to look like the rest of the
book, and to later allow to generate a man page for this
ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/rc/lirc-get-rec-resolution.rst      | 49 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         | 10 -----
 3 files changed, 50 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-get-rec-resolution.rst

diff --git a/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst b/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
new file mode 100644
index 000000000000..6ef1723878b4
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
@@ -0,0 +1,49 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_get_rec_resolution:
+
+*****************************
+ioctl LIRC_GET_REC_RESOLUTION
+*****************************
+
+Name
+====
+
+LIRC_GET_REC_RESOLUTION - Obtain the value of receive resolution, in microseconds.
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *microseconds)
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_GET_REC_RESOLUTION
+
+``microseconds``
+    Resolution, in microseconds.
+
+
+Description
+===========
+
+Some receivers have maximum resolution which is defined by internal
+sample rate or data format limitations. E.g. it's common that
+signals can only be reported in 50 microsecond steps.
+
+This ioctl returns the integer value with such resolution, with can be
+used by userspace applications like lircd to automatically adjust the
+tolerance value.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index 34044b0c8f9c..532f4e92d1e9 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -15,4 +15,5 @@ LIRC Device Interface
     lirc-get-features
     lirc-get-send-mode
     lirc-get-rec-mode
+    lirc-get-rec-resolution
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index 4656e30a5b5a..347b86d368b4 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -58,16 +58,6 @@ I/O control requests
     could be used to switch off carrier generation in the future, so
     these values should be reserved.
 
-.. _LIRC_GET_REC_RESOLUTION:
-
-``LIRC_GET_REC_RESOLUTION``
-
-    Some receiver have maximum resolution which is defined by internal
-    sample rate or data format limitations. E.g. it's common that
-    signals can only be reported in 50 microsecond steps. This integer
-    value is used by lircd to automatically adjust the aeps tolerance
-    value in the lircd config file.
-
 .. _LIRC_GET_MIN_TIMEOUT:
 .. _LIRC_GET_MAX_TIMEOUT:
 
-- 
2.7.4


