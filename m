Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54439 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752176AbeDOJvy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 05:51:54 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Warren Sturm <warren.sturm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Andy Walls <awalls.cx18@gmail.com>, stable@vger.kernel.org,
        #@mess.org, v4.14-v4.15@mess.org
Subject: [PATCH stable v4.14 1/2] Revert "media: lirc_zilog: driver only sends LIRCCODE"
Date: Sun, 15 Apr 2018 10:51:50 +0100
Message-Id: <c2664b59ff88989b4d9a6c7722a56cd8878caf28.1523785758.git.sean@mess.org>
In-Reply-To: <cover.1523785758.git.sean@mess.org>
References: <cover.1523785758.git.sean@mess.org>
In-Reply-To: <cover.1523785758.git.sean@mess.org>
References: <cover.1523785758.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc config documented here
https://www.blushingpenguin.com/mark/blog/?p=24 uses raw_codes for sending
IR. Each key only has one pulse, which in fact is an index into the
haup-ir-blaster.bin file. Changing the driver to LIRCCODE (although more
accurate) breaks this configuration.

This code has been replaced completely in kernel v4.16 by a new driver,
see commit acaa34bf06e9 ("media: rc: implement zilog transmitter"), and
commit f95367a7b758 ("media: staging: remove lirc_zilog driver").

This reverts commit 89d8a2cc51d1f29ea24a0b44dde13253141190a0.

Fixes: 615cd3fe6ccc ("[media] media: lirc_dev: make better use of file->private_data")

Cc: stable@vger.kernel.org # v4.14-v4.15
Reported-by: Warren Sturm <warren.sturm@gmail.com>
Tested-by: Warren Sturm <warren.sturm@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_zilog.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 71af13bd0ebd..26dd32d5b5b2 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -288,7 +288,7 @@ static void release_ir_tx(struct kref *ref)
 	struct IR_tx *tx = container_of(ref, struct IR_tx, ref);
 	struct IR *ir = tx->ir;
 
-	ir->l.features &= ~LIRC_CAN_SEND_LIRCCODE;
+	ir->l.features &= ~LIRC_CAN_SEND_PULSE;
 	/* Don't put_ir_device(tx->ir) here, so our lock doesn't get freed */
 	ir->tx = NULL;
 	kfree(tx);
@@ -1267,14 +1267,14 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		if (!(features & LIRC_CAN_SEND_MASK))
 			return -ENOTTY;
 
-		result = put_user(LIRC_MODE_LIRCCODE, uptr);
+		result = put_user(LIRC_MODE_PULSE, uptr);
 		break;
 	case LIRC_SET_SEND_MODE:
 		if (!(features & LIRC_CAN_SEND_MASK))
 			return -ENOTTY;
 
 		result = get_user(mode, uptr);
-		if (!result && mode != LIRC_MODE_LIRCCODE)
+		if (!result && mode != LIRC_MODE_PULSE)
 			return -EINVAL;
 		break;
 	default:
@@ -1512,7 +1512,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		kref_init(&tx->ref);
 		ir->tx = tx;
 
-		ir->l.features |= LIRC_CAN_SEND_LIRCCODE;
+		ir->l.features |= LIRC_CAN_SEND_PULSE;
 		mutex_init(&tx->client_lock);
 		tx->c = client;
 		tx->need_boot = 1;
-- 
2.14.3
