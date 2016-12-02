Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:56101 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751033AbcLBRRJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:17:09 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/8] [media] lirc: LIRC_{G,S}ET_SEND_MODE fail if device cannot transmit
Date: Fri,  2 Dec 2016 17:16:09 +0000
Message-Id: <1480698974-9093-3-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These ioctls should not succeed if the device cannot send. Also make it
clear that these ioctls should return the lirc mode, although the actual
value does not change.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index c327730..9e41305 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -204,11 +204,17 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	/* legacy support */
 	case LIRC_GET_SEND_MODE:
-		val = LIRC_CAN_SEND_PULSE & LIRC_CAN_SEND_MASK;
+		if (!dev->tx_ir)
+			return -ENOTTY;
+
+		val = LIRC_MODE_PULSE;
 		break;
 
 	case LIRC_SET_SEND_MODE:
-		if (val != (LIRC_MODE_PULSE & LIRC_CAN_SEND_MASK))
+		if (!dev->tx_ir)
+			return -ENOTTY;
+
+		if (val != LIRC_MODE_PULSE)
 			return -EINVAL;
 		return 0;
 
-- 
2.9.3

