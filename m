Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51672 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285AbcGLMmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 07/20] [media] doc-rst: fix some lirc cross-references
Date: Tue, 12 Jul 2016 09:42:01 -0300
Message-Id: <4ed030af4f1f163c1a61742ba0f8e749884de639.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some references were broken. It was also mentioning LIRC_MODE_RAW,
with it is not implemented on current LIRC drivers.

So, fix the references.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc-get-features.rst  | 5 ++---
 Documentation/media/uapi/rc/lirc-get-send-mode.rst | 2 +-
 Documentation/media/uapi/rc/lirc_read.rst          | 2 +-
 Documentation/media/uapi/rc/lirc_write.rst         | 4 ++--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index d89712190d43..e763ebfb2cb1 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -44,8 +44,7 @@ LIRC features
 
 ``LIRC_CAN_REC_RAW``
 
-    The driver is capable of receiving using
-    :ref:`LIRC_MODE_RAW <lirc-mode-raw>`.
+    Unused. Kept just to avoid breaking uAPI.
 
 .. _LIRC-CAN-REC-PULSE:
 
@@ -153,7 +152,7 @@ LIRC features
 
 ``LIRC_CAN_SEND_RAW``
 
-    The driver supports sending using :ref:`LIRC_MODE_RAW <lirc-mode-raw>`.
+    Unused. Kept just to avoid breaking uAPI.
 
 .. _LIRC-CAN-SEND-PULSE:
 
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index f58f0953851c..f3fd310a8d7c 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -38,7 +38,7 @@ Get supported transmit mode.
 
 Currently, only ``LIRC_MODE_PULSE`` is supported by lircd on TX. On
 puse mode, a sequence of pulse/space integer values are written to the
-lirc device using ``write()``.
+lirc device using :Ref:`lirc-write`.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc_read.rst b/Documentation/media/uapi/rc/lirc_read.rst
index 37f164f7526a..a8f1b446c294 100644
--- a/Documentation/media/uapi/rc/lirc_read.rst
+++ b/Documentation/media/uapi/rc/lirc_read.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _lirc_read:
+.. _lirc-read:
 
 ***********
 LIRC read()
diff --git a/Documentation/media/uapi/rc/lirc_write.rst b/Documentation/media/uapi/rc/lirc_write.rst
index e27bda30afcc..dcba3b1bee6e 100644
--- a/Documentation/media/uapi/rc/lirc_write.rst
+++ b/Documentation/media/uapi/rc/lirc_write.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _lirc_write:
+.. _lirc-write:
 
 ************
 LIRC write()
@@ -36,7 +36,7 @@ Arguments
 Description
 ===========
 
-:ref:`write() <func-write>` writes up to ``count`` bytes to the device
+:ref:`write() <lirc-write>` writes up to ``count`` bytes to the device
 referenced by the file descriptor ``fd`` from the buffer starting at
 ``buf``.
 
-- 
2.7.4


