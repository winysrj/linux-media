Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56375 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbeABVBb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 16:01:31 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] media: lirc: lirc daemon fails to detect raw IR device
Date: Tue,  2 Jan 2018 21:01:28 +0000
Message-Id: <20180102210129.7608-2-sean@mess.org>
In-Reply-To: <20180102210129.7608-1-sean@mess.org>
References: <20180102210129.7608-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 9b6192589be7 ("media: lirc: implement scancode sending"),
and commit de142c324106 ("media: lirc: implement reading scancode")
the lirc features ioctl for raw IR devices advertises two modes for
sending and receiving.

The lirc daemon now fails to detect a raw IR device, both for transmit
and receive.

To fix this, do not advertise the scancode mode in the lirc features
for raw IR devices (however do keep it for scancode devices). The mode
can still be used via the LIRC_SET_{REC,SEND}_MODE ioctl.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-get-features.rst | 22 +++++++++++-----------
 drivers/media/rc/lirc_dev.c                       |  4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index 3ee44067de63..5b30921d0483 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -55,8 +55,11 @@ LIRC features
 
 ``LIRC_CAN_REC_MODE2``
 
-    The driver is capable of receiving using
-    :ref:`LIRC_MODE_MODE2 <lirc-mode-MODE2>`.
+    This is raw IR driver for receiving. This means that
+    :ref:`LIRC_MODE_MODE2 <lirc-mode-MODE2>` is used. This also implies
+    that :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>` is also supported,
+    as long as the kernel is recent enough. Use the
+    :ref:`lirc_set_rec_mode` to switch modes.
 
 .. _LIRC-CAN-REC-LIRCCODE:
 
@@ -68,9 +71,8 @@ LIRC features
 
 ``LIRC_CAN_REC_SCANCODE``
 
-    The driver is capable of receiving using
-    :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>`.
-
+    This is a scancode driver for receiving. This means that
+    :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>` is used.
 
 .. _LIRC-CAN-SET-SEND-CARRIER:
 
@@ -164,7 +166,10 @@ LIRC features
 ``LIRC_CAN_SEND_PULSE``
 
     The driver supports sending (also called as IR blasting or IR TX) using
-    :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`.
+    :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`. This implies that
+    :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>` is also supported for
+    transmit, as long as the kernel is recent enough. Use the
+    :ref:`lirc_set_send_mode` to switch modes.
 
 .. _LIRC-CAN-SEND-MODE2:
 
@@ -181,11 +186,6 @@ LIRC features
 
 .. _LIRC-CAN-SEND-SCANCODE:
 
-``LIRC_CAN_SEND_SCANCODE``
-
-    The driver supports sending (also called as IR blasting or IR TX) using
-    :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>`.
-
 
 Return Value
 ============
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index c96543812040..ba2028986c5c 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -402,13 +402,13 @@ static long ir_lirc_ioctl(struct file *file, unsigned int cmd,
 			val |= LIRC_CAN_REC_SCANCODE;
 
 		if (dev->driver_type == RC_DRIVER_IR_RAW) {
-			val |= LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE;
+			val |= LIRC_CAN_REC_MODE2;
 			if (dev->rx_resolution)
 				val |= LIRC_CAN_GET_REC_RESOLUTION;
 		}
 
 		if (dev->tx_ir) {
-			val |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
+			val |= LIRC_CAN_SEND_PULSE;
 			if (dev->s_tx_mask)
 				val |= LIRC_CAN_SET_TRANSMITTER_MASK;
 			if (dev->s_tx_carrier)
-- 
2.14.3
