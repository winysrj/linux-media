Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39493 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbdJ2U6t (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:58:49 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 09/28] media: lirc: remove LIRCCODE and LIRC_GET_LENGTH
Date: Sun, 29 Oct 2017 20:58:48 +0000
Message-Id: <127575cfa5414af5fe4c67515698c660588d846a.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LIRCCODE is a lirc mode where a driver produces driver-dependent
codes for receive and transmit. No driver uses this any more. The
LIRC_GET_LENGTH ioctl was used for this mode only.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/lirc.h.rst.exceptions          |  5 +++
 Documentation/media/uapi/rc/lirc-dev-intro.rst     | 15 --------
 Documentation/media/uapi/rc/lirc-func.rst          |  1 -
 Documentation/media/uapi/rc/lirc-get-features.rst  |  7 +---
 Documentation/media/uapi/rc/lirc-get-length.rst    | 44 ----------------------
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |  4 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |  3 +-
 drivers/media/rc/ir-lirc-codec.c                   |  1 -
 drivers/media/rc/lirc_dev.c                        | 12 ------
 include/media/lirc_dev.h                           |  4 --
 10 files changed, 9 insertions(+), 87 deletions(-)
 delete mode 100644 Documentation/media/uapi/rc/lirc-get-length.rst

diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index c130617a9986..63ba1d341905 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -28,6 +28,10 @@ ignore define LIRC_CAN_SEND_MASK
 ignore define LIRC_CAN_REC_MASK
 ignore define LIRC_CAN_SET_REC_DUTY_CYCLE
 
+# Obsolete ioctls
+
+ignore ioctl LIRC_GET_LENGTH
+
 # Undocumented macros
 
 ignore define PULSE_BIT
@@ -40,3 +44,4 @@ ignore define LIRC_VALUE_MASK
 ignore define LIRC_MODE2_MASK
 
 ignore define LIRC_MODE_RAW
+ignore define LIRC_MODE_LIRCCODE
diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index d1936eeb9ce0..3cacf9aeac40 100644
--- a/Documentation/media/uapi/rc/lirc-dev-intro.rst
+++ b/Documentation/media/uapi/rc/lirc-dev-intro.rst
@@ -72,21 +72,6 @@ on the following table.
         this packet will be sent, with the number of microseconds with
         no IR.
 
-.. _lirc-mode-lirccode:
-
-``LIRC_MODE_LIRCCODE``
-
-    This mode can be used for IR receive and send.
-
-    The IR signal is decoded internally by the receiver, or encoded by the
-    transmitter. The LIRC interface represents the scancode as byte string,
-    which might not be a u32, it can be any length. The value is entirely
-    driver dependent. This mode is used by some older lirc drivers.
-
-    The length of each code depends on the driver, which can be retrieved
-    with :ref:`lirc_get_length`. This length is used both
-    for transmitting and receiving IR.
-
 .. _lirc-mode-pulse:
 
 ``LIRC_MODE_PULSE``
diff --git a/Documentation/media/uapi/rc/lirc-func.rst b/Documentation/media/uapi/rc/lirc-func.rst
index 9b5a772ec96c..ddb4620de294 100644
--- a/Documentation/media/uapi/rc/lirc-func.rst
+++ b/Documentation/media/uapi/rc/lirc-func.rst
@@ -18,7 +18,6 @@ LIRC Function Reference
     lirc-set-send-duty-cycle
     lirc-get-timeout
     lirc-set-rec-timeout
-    lirc-get-length
     lirc-set-rec-carrier
     lirc-set-rec-carrier-range
     lirc-set-send-carrier
diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index 64f89a4f9d9c..50c2c26d8e89 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -62,8 +62,7 @@ LIRC features
 
 ``LIRC_CAN_REC_LIRCCODE``
 
-    The driver is capable of receiving using
-    :ref:`LIRC_MODE_LIRCCODE <lirc-mode-LIRCCODE>`.
+    Unused. Kept just to avoid breaking uAPI.
 
 .. _LIRC-CAN-SET-SEND-CARRIER:
 
@@ -170,9 +169,7 @@ LIRC features
 
 ``LIRC_CAN_SEND_LIRCCODE``
 
-    The driver supports sending (also called as IR blasting or IR TX) using
-    :ref:`LIRC_MODE_LIRCCODE <lirc-mode-LIRCCODE>`.
-
+    Unused. Kept just to avoid breaking uAPI.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc-get-length.rst b/Documentation/media/uapi/rc/lirc-get-length.rst
deleted file mode 100644
index 3990af5de0e9..000000000000
--- a/Documentation/media/uapi/rc/lirc-get-length.rst
+++ /dev/null
@@ -1,44 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _lirc_get_length:
-
-*********************
-ioctl LIRC_GET_LENGTH
-*********************
-
-Name
-====
-
-LIRC_GET_LENGTH - Retrieves the code length in bits.
-
-Synopsis
-========
-
-.. c:function:: int ioctl( int fd, LIRC_GET_LENGTH, __u32 *length )
-    :name: LIRC_GET_LENGTH
-
-Arguments
-=========
-
-``fd``
-    File descriptor returned by open().
-
-``length``
-    length, in bits
-
-
-Description
-===========
-
-Retrieves the code length in bits (only for
-:ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>`).
-Reads on the device must be done in blocks matching the bit count.
-The bit could should be rounded up so that it matches full bytes.
-
-
-Return Value
-============
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
index a4eb6c0a26e9..b89de9add921 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -34,9 +34,7 @@ Description
 ===========
 
 Get/set supported receive modes. Only :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`
-and :ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` are supported for IR
-receive. Use :ref:`lirc_get_features` to find out which modes the driver
-supports.
+is supported for IR receive.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index a169b234290e..e686b21689a0 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -36,8 +36,7 @@ Description
 
 Get/set current transmit mode.
 
-Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` and
-:ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` is supported by for IR send,
+Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` is supported by for IR send,
 depending on the driver. Use :ref:`lirc_get_features` to find out which
 modes the driver supports.
 
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 8f2f37412fc5..6a68d9e4a36b 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -388,7 +388,6 @@ static int ir_lirc_register(struct rc_dev *dev)
 	ldev->features = features;
 	ldev->data = &dev->raw->lirc;
 	ldev->buf = NULL;
-	ldev->code_length = sizeof(struct ir_raw_event) * 8;
 	ldev->chunk_size = sizeof(int);
 	ldev->buffer_size = LIRCBUF_SIZE;
 	ldev->fops = &lirc_fops;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index e16d1138ca48..ef7e915dc9a2 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -137,12 +137,6 @@ int lirc_register_device(struct lirc_dev *d)
 		return -EINVAL;
 	}
 
-	if (d->code_length < 1 || d->code_length > (BUFLEN * 8)) {
-		dev_err(&d->dev, "code length must be less than %d bits\n",
-			BUFLEN * 8);
-		return -EBADRQC;
-	}
-
 	if (!d->buf && !(d->fops && d->fops->read &&
 			 d->fops->poll && d->fops->unlocked_ioctl)) {
 		dev_err(&d->dev, "undefined read, poll, ioctl\n");
@@ -152,9 +146,6 @@ int lirc_register_device(struct lirc_dev *d)
 	/* some safety check 8-) */
 	d->name[sizeof(d->name) - 1] = '\0';
 
-	if (d->features == 0)
-		d->features = LIRC_CAN_REC_LIRCCODE;
-
 	if (LIRC_CAN_REC(d->features)) {
 		err = lirc_allocate_buffer(d);
 		if (err)
@@ -343,9 +334,6 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		 * for now, lirc_serial doesn't support mode changing either
 		 */
 		break;
-	case LIRC_GET_LENGTH:
-		result = put_user(d->code_length, (__u32 __user *)arg);
-		break;
 	default:
 		result = -ENOTTY;
 	}
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 857da67bd931..0a03dd9e5a68 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -9,8 +9,6 @@
 #ifndef _LINUX_LIRC_DEV_H
 #define _LINUX_LIRC_DEV_H
 
-#define BUFLEN            16
-
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
@@ -117,7 +115,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  *
  * @name:		used for logging
  * @minor:		the minor device (/dev/lircX) number for the device
- * @code_length:	length of a remote control key code expressed in bits
  * @features:		lirc compatible hardware features, like LIRC_MODE_RAW,
  *			LIRC_CAN\_\*, as defined at include/media/lirc.h.
  * @buffer_size:	Number of FIFO buffers with @chunk_size size.
@@ -142,7 +139,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
 struct lirc_dev {
 	char name[40];
 	unsigned int minor;
-	__u32 code_length;
 	__u32 features;
 
 	unsigned int buffer_size; /* in chunks holding one code each */
-- 
2.13.6
