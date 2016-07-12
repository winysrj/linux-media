Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312AbcGLMme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 12/20] [media] doc-rst: Document LIRC_GET_LENGTH ioctl
Date: Tue, 12 Jul 2016 09:42:06 -0300
Message-Id: <da186094e18c63e19dc5aff577eefcd18cfba45b.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put documentation for this ioctl on its own page.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc-get-length.rst    | 45 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         | 11 ------
 3 files changed, 46 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-get-length.rst

diff --git a/Documentation/media/uapi/rc/lirc-get-length.rst b/Documentation/media/uapi/rc/lirc-get-length.rst
new file mode 100644
index 000000000000..d11c3d3f2c06
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-get-length.rst
@@ -0,0 +1,45 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_get_length:
+
+*********************
+ioctl LIRC_GET_LENGTH
+*********************
+
+Name
+====
+
+LIRC_GET_LENGTH - Retrieves the code length in bits.
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *length )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_GET_LENGTH
+
+``length``
+    length, in bits
+
+
+Description
+===========
+
+Retrieves the code length in bits (only for ``LIRC-MODE-LIRCCODE``).
+Reads on the device must be done in blocks matching the bit count.
+The bit could should be rounded up so that it matches full bytes.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index 197173f9ece5..f8a619e233c0 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -18,4 +18,5 @@ LIRC Device Interface
     lirc-get-rec-resolution
     lirc-set-send-duty-cycle
     lirc-get-timeout
+    lirc-get-length
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index 0a16659e9dad..93531c37fd27 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -46,17 +46,6 @@ device can rely on working with the default settings initially.
 
 .. _lirc-request:
 
-I/O control requests
-====================
-
-.. _LIRC_GET_LENGTH:
-
-``LIRC_GET_LENGTH``
-
-    Retrieves the code length in bits (only for ``LIRC_MODE_LIRCCODE).``
-    Reads on the device must be done in blocks matching the bit count.
-    The bit could should be rounded up so that it matches full bytes.
-
 .. _LIRC_SET_SEND_MODE:
 .. _LIRC_SET_REC_MODE:
 
-- 
2.7.4


