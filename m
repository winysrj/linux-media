Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51712 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbcGLMme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 14/20] [media] doc-rst: document LIRC_SET_TRANSMITTER_MASK
Date: Tue, 12 Jul 2016 09:42:08 -0300
Message-Id: <ce68c0dd13283e466bf7c9bc247164b58767d6d5.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add proper documentation for this ioctl, providing some
additional information about its usage.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/rc/lirc-set-transmitter-mask.rst    | 53 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         | 10 ----
 3 files changed, 54 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst

diff --git a/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst b/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
new file mode 100644
index 000000000000..2b35e21b9bb9
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
@@ -0,0 +1,53 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_transmitter_mask:
+
+*******************************
+ioctl LIRC_SET_TRANSMITTER_MASK
+*******************************
+
+Name
+====
+
+LIRC_SET_TRANSMITTER_MASK - Enables send codes on a given set of transmitters
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *mask )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_SET_TRANSMITTER_MASK
+
+``mask``
+    Mask with channels to enable tx. Channel 0 is the least significant bit.
+
+
+Description
+===========
+
+Some IR TX devices have multiple output channels, in such case,
+:ref:`LIRC_CAN_SET_TRANSMITTER_MASK <LIRC-CAN-SET-TRANSMITTER-MASK>` is
+returned via :ref:`LIRC_GET_FEATURES` and this ioctl sets what channels will
+send IR codes.
+
+This ioctl enables the given set of transmitters. The first transmitter is
+encoded by the least significant bit and so on.
+
+When an invalid bit mask is given, i.e. a bit is set, even though the device
+does not have so many transitters, then this ioctl returns the number of
+available transitters and does nothing otherwise.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index 06257caa82db..96765eccaa69 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -22,4 +22,5 @@ LIRC Device Interface
     lirc-set-rec-carrier
     lirc-set-rec-carrier-range
     lirc-set-send-carrier
+    lirc-set-transmitter-mask
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index b1cca1465997..86bd70dba290 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -54,16 +54,6 @@ device can rely on working with the default settings initially.
     Set send/receive mode. Largely obsolete for send, as only
     ``LIRC_MODE_PULSE`` is supported.
 
-.. _LIRC_SET_TRANSMITTER_MASK:
-
-``LIRC_SET_TRANSMITTER_MASK``
-
-    This enables the given set of transmitters. The first transmitter is
-    encoded by the least significant bit, etc. When an invalid bit mask
-    is given, i.e. a bit is set, even though the device does not have so
-    many transitters, then this ioctl returns the number of available
-    transitters and does nothing otherwise.
-
 .. _LIRC_SET_REC_TIMEOUT:
 
 ``LIRC_SET_REC_TIMEOUT``
-- 
2.7.4


