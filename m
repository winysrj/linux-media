Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51716 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316AbcGLMme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 15/20] [media] doc-rst: document LIRC_SET_REC_TIMEOUT
Date: Tue, 12 Jul 2016 09:42:09 -0300
Message-Id: <27afbae747423caa4138a8e516c7823aa78be5b3.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a separate page for this ioctl and adds the cross-references.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/rc/lirc-set-rec-timeout.rst         | 52 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         | 11 -----
 3 files changed, 53 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-timeout.rst

diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst b/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
new file mode 100644
index 000000000000..ffc88f9fcd52
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
@@ -0,0 +1,52 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_rec_timeout:
+
+**************************
+ioctl LIRC_SET_REC_TIMEOUT
+**************************
+
+Name
+====
+
+LIRC_SET_REC_TIMEOUT - sets the integer value for IR inactivity timeout.
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *timeout )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_SET_REC_TIMEOUT
+
+``timeout``
+    Timeout, in microseconds.
+
+
+Description
+===========
+
+Sets the integer value for IR inactivity timeout.
+
+If supported by the hardware, setting it to 0  disables all hardware timeouts
+and data should be reported as soon as possible. If the exact value
+cannot be set, then the next possible value _greater_ than the
+given value should be set.
+
+.. note::
+
+   The range of supported timeout is given by :ref:`LIRC_GET_MIN_TIMEOUT`.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index 96765eccaa69..df576d90c73a 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -18,6 +18,7 @@ LIRC Device Interface
     lirc-get-rec-resolution
     lirc-set-send-duty-cycle
     lirc-get-timeout
+    lirc-set-rec-timeout
     lirc-get-length
     lirc-set-rec-carrier
     lirc-set-rec-carrier-range
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index 86bd70dba290..26544a5fc946 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -54,17 +54,6 @@ device can rely on working with the default settings initially.
     Set send/receive mode. Largely obsolete for send, as only
     ``LIRC_MODE_PULSE`` is supported.
 
-.. _LIRC_SET_REC_TIMEOUT:
-
-``LIRC_SET_REC_TIMEOUT``
-
-    Sets the integer value for IR inactivity timeout (cf.
-    ``LIRC_GET_MIN_TIMEOUT`` and ``LIRC_GET_MAX_TIMEOUT).`` A value of 0
-    (if supported by the hardware) disables all hardware timeouts and
-    data should be reported as soon as possible. If the exact value
-    cannot be set, then the next possible value _greater_ than the
-    given value should be set.
-
 .. _LIRC_SET_REC_TIMEOUT_REPORTS:
 
 ``LIRC_SET_REC_TIMEOUT_REPORTS``
-- 
2.7.4


