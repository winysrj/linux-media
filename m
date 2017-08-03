Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40111 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751791AbdHCVmd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Aug 2017 17:42:33 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: "# v3 . 2" <stable@vger.kernel.org>
Subject: [PATCH] [media] lirc_zilog: driver only sends LIRCCODE
Date: Thu,  3 Aug 2017 22:42:28 +0100
Message-Id: <20170803214231.9334-2-sean@mess.org>
In-Reply-To: <20170803214231.9334-1-sean@mess.org>
References: <20170803214231.9334-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver cannot send pulse, it only accepts driver-dependent codes.

Cc: <stable@vger.kernel.org> # v3.2
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_zilog.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index c9f2bd324767..d138ca494176 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -290,7 +290,7 @@ static void release_ir_tx(struct kref *ref)
 	struct IR_tx *tx = container_of(ref, struct IR_tx, ref);
 	struct IR *ir = tx->ir;
 
-	ir->l->features &= ~LIRC_CAN_SEND_PULSE;
+	ir->l->features &= ~LIRC_CAN_SEND_LIRCCODE;
 	/* Don't put_ir_device(tx->ir) here, so our lock doesn't get freed */
 	ir->tx = NULL;
 	kfree(tx);
@@ -1269,14 +1269,14 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		if (!(features & LIRC_CAN_SEND_MASK))
 			return -ENOTTY;
 
-		result = put_user(LIRC_MODE_PULSE, uptr);
+		result = put_user(LIRC_MODE_LIRCCODE, uptr);
 		break;
 	case LIRC_SET_SEND_MODE:
 		if (!(features & LIRC_CAN_SEND_MASK))
 			return -ENOTTY;
 
 		result = get_user(mode, uptr);
-		if (!result && mode != LIRC_MODE_PULSE)
+		if (!result && mode != LIRC_MODE_LIRCCODE)
 			return -EINVAL;
 		break;
 	default:
@@ -1484,7 +1484,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		kref_init(&tx->ref);
 		ir->tx = tx;
 
-		ir->l->features |= LIRC_CAN_SEND_PULSE;
+		ir->l->features |= LIRC_CAN_SEND_LIRCCODE;
 		mutex_init(&tx->client_lock);
 		tx->c = client;
 		tx->need_boot = 1;
-- 
2.13.3
