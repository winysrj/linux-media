Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:38343 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753807AbdBUUnt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 15:43:49 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 07/19] [media] lirc: advertise LIRC_CAN_GET_REC_RESOLUTION and improve
Date: Tue, 21 Feb 2017 20:43:31 +0000
Message-Id: <aa31dc917bcce34cdb897b17d5f4092d06fccab6.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This feature was never set. The ioctl should fail if no resolution
is set.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 235d74a..de85f1d 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -263,6 +263,9 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		return 0;
 
 	case LIRC_GET_REC_RESOLUTION:
+		if (!dev->rx_resolution)
+			return -ENOTTY;
+
 		val = dev->rx_resolution;
 		break;
 
@@ -367,8 +370,11 @@ static int ir_lirc_register(struct rc_dev *dev)
 	if (rc)
 		goto rbuf_init_failed;
 
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
 		features |= LIRC_CAN_REC_MODE2;
+		if (dev->rx_resolution)
+			features |= LIRC_CAN_GET_REC_RESOLUTION;
+	}
 	if (dev->tx_ir) {
 		features |= LIRC_CAN_SEND_PULSE;
 		if (dev->s_tx_mask)
-- 
2.9.3
