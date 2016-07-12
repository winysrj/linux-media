Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300AbcGLMmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 19/20] [media] doc-rst: Document LIRC set mode ioctls
Date: Tue, 12 Jul 2016 09:42:13 -0300
Message-Id: <8b9e428c8afb86aaaf10edfa37714cc2b62dd604.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add LIRC_SET_[REC|SEND]_MODE ioctls to the corresponding
GET functions, and put all LIRC modes altogether.

As now everything is already documented on its own ioctl
pages, get rid of lirc_ioctl.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  | 32 +++--------
 Documentation/media/uapi/rc/lirc-get-send-mode.rst | 17 +++---
 Documentation/media/uapi/rc/lirc_dev_intro.rst     | 34 ++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 -
 Documentation/media/uapi/rc/lirc_ioctl.rst         | 64 ----------------------
 5 files changed, 50 insertions(+), 98 deletions(-)
 delete mode 100644 Documentation/media/uapi/rc/lirc_ioctl.rst

diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
index d46a488594c9..586860c36791 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -1,15 +1,16 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _lirc_get_rec_mode:
+.. _lirc_set_rec_mode:
 
-***********************
-ioctl LIRC_GET_REC_MODE
-***********************
+**********************************************
+ioctls LIRC_GET_REC_MODE and LIRC_SET_REC_MODE
+**********************************************
 
 Name
 ====
 
-LIRC_GET_REC_MODE - Get supported receive modes.
+LIRC_GET_REC_MODE/LIRC_GET_REC_MODE - Get/set supported receive modes.
 
 Synopsis
 ========
@@ -23,7 +24,7 @@ Arguments
     File descriptor returned by open().
 
 ``request``
-    LIRC_GET_REC_MODE
+    LIRC_GET_REC_MODE or LIRC_GET_REC_MODE
 
 ``rx_modes``
     Bitmask with the supported transmit modes.
@@ -31,24 +32,9 @@ Arguments
 Description
 ===========
 
-Get supported receive modes.
-
-Supported receive modes
-=======================
-
-.. _lirc-mode-mode2:
-
-``LIRC_MODE_MODE2``
-
-    The driver returns a sequence of pulse and space codes to userspace.
-
-.. _lirc-mode-lirccode:
-
-``LIRC_MODE_LIRCCODE``
-
-    The IR signal is decoded internally by the receiver. The LIRC interface
-    returns the scancode as an integer value. This is the usual mode used
-    by several TV media cards.
+Get/set supported receive modes. Only :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`
+and :ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` are supported for IR
+receive.
 
 
 Return Value
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index f3fd310a8d7c..3e1d96122ff2 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -1,15 +1,16 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _lirc_get_send_mode:
+.. _lirc_set_send_mode:
 
-************************
-ioctl LIRC_GET_SEND_MODE
-************************
+************************************************
+ioctls LIRC_GET_SEND_MODE and LIRC_SET_SEND_MODE
+************************************************
 
 Name
 ====
 
-LIRC_GET_SEND_MODE - Get supported transmit mode.
+LIRC_GET_SEND_MODE/LIRC_SET_SEND_MODE - Get/set supported transmit mode.
 
 Synopsis
 ========
@@ -32,13 +33,9 @@ Arguments
 Description
 ===========
 
-Get supported transmit mode.
+Get/set supported transmit mode.
 
-.. _lirc-mode-pulse:
-
-Currently, only ``LIRC_MODE_PULSE`` is supported by lircd on TX. On
-puse mode, a sequence of pulse/space integer values are written to the
-lirc device using :Ref:`lirc-write`.
+Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` is supported by for IR send.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc_dev_intro.rst b/Documentation/media/uapi/rc/lirc_dev_intro.rst
index 9a784c8fe4ea..ef97e40f2fd8 100644
--- a/Documentation/media/uapi/rc/lirc_dev_intro.rst
+++ b/Documentation/media/uapi/rc/lirc_dev_intro.rst
@@ -26,3 +26,37 @@ What you should see for a chardev:
 
     $ ls -l /dev/lirc*
     crw-rw---- 1 root root 248, 0 Jul 2 22:20 /dev/lirc0
+
+**********
+LIRC modes
+**********
+
+LIRC supports some modes of receiving and sending IR codes, as shown
+on the following table.
+
+.. _lirc-mode-mode2:
+
+``LIRC_MODE_MODE2``
+
+    The driver returns a sequence of pulse and space codes to userspace.
+
+    This mode is used only for IR receive.
+
+.. _lirc-mode-lirccode:
+
+``LIRC_MODE_LIRCCODE``
+
+    The IR signal is decoded internally by the receiver. The LIRC interface
+    returns the scancode as an integer value. This is the usual mode used
+    by several TV media cards.
+
+    This mode is used only for IR receive.
+
+.. _lirc-mode-pulse:
+
+``LIRC_MODE_PULSE``
+
+    On puse mode, a sequence of pulse/space integer values are written to the
+    lirc device using :Ref:`lirc-write`.
+
+    This mode is used only for IR send.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index e9cb510349a0..a2ad957c96ae 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -27,4 +27,3 @@ LIRC Device Interface
     lirc-set-rec-timeout-reports
     lirc-set-measure-carrier-mode
     lirc-set-wideband-receiver
-    lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
deleted file mode 100644
index fe5f2719ea77..000000000000
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ /dev/null
@@ -1,64 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _lirc_ioctl:
-
-************
-LIRC ioctl()
-************
-
-
-Name
-====
-
-LIRC ioctl - Sends a I/O control command to a LIRC device
-
-Synopsis
-========
-
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_capability *argp )
-
-
-Arguments
-=========
-
-``fd``
-    File descriptor returned by ``open()``.
-
-``request``
-    The type of I/O control that will be used. See table :ref:`lirc-request`
-    for details.
-
-``argp``
-    Arguments for the I/O control. They're specific to each request.
-
-
-The LIRC device's ioctl definition is bound by the ioctl function
-definition of struct file_operations, leaving us with an unsigned int
-for the ioctl command and an unsigned long for the arg. For the purposes
-of ioctl portability across 32-bit and 64-bit, these values are capped
-to their 32-bit sizes.
-
-The ioctls can be used to change specific hardware settings.
-In general each driver should have a default set of settings. The driver
-implementation is expected to re-apply the default settings when the
-device is closed by user-space, so that every application opening the
-device can rely on working with the default settings initially.
-
-.. _lirc-request:
-
-.. _LIRC_SET_SEND_MODE:
-.. _LIRC_SET_REC_MODE:
-
-``LIRC_SET_{SEND,REC}_MODE``
-
-    Set send/receive mode. Largely obsolete for send, as only
-    ``LIRC_MODE_PULSE`` is supported.
-
-.. _lirc_dev_errors:
-
-Return Value
-============
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-- 
2.7.4


