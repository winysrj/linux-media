Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:34654 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab2HYLBr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 07:01:47 -0400
From: Sean Young <sean@mess.org>
To: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: [PATCH] [media] iguanair: do not modify transmit buffer
Date: Sat, 25 Aug 2012 12:01:45 +0100
Message-Id: <1345892505-27049-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit "[media] rc-core: move timeout and checks to lirc", the
incoming buffer is used after the driver transmits.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 51 +++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 66ba237..1e4c68a 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -334,21 +334,34 @@ static int iguanair_set_tx_mask(struct rc_dev *dev, uint32_t mask)
 static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 {
 	struct iguanair *ir = dev->priv;
-	uint8_t space, *payload;
-	unsigned i, size, rc, bytes;
+	uint8_t space;
+	unsigned i, size, periods, bytes;
+	int rc;
 	struct send_packet *packet;
 
 	mutex_lock(&ir->lock);
 
+	packet = kmalloc(sizeof(*packet) + ir->bufsize, GFP_KERNEL);
+	if (!packet) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
 	/* convert from us to carrier periods */
-	for (i = size = 0; i < count; i++) {
-		txbuf[i] = DIV_ROUND_CLOSEST(txbuf[i] * ir->carrier, 1000000);
-		bytes = (txbuf[i] + 126) / 127;
+	for (i = space = size = 0; i < count; i++) {
+		periods = DIV_ROUND_CLOSEST(txbuf[i] * ir->carrier, 1000000);
+		bytes = DIV_ROUND_UP(periods, 127);
 		if (size + bytes > ir->bufsize) {
 			count = i;
 			break;
 		}
-		size += bytes;
+		while (periods > 127) {
+			packet->payload[size++] = 127 | space;
+			periods -= 127;
+		}
+
+		packet->payload[size++] = periods | space;
+		space ^= 0x80;
 	}
 
 	if (count == 0) {
@@ -356,12 +369,6 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 		goto out;
 	}
 
-	packet = kmalloc(sizeof(*packet) + size, GFP_KERNEL);
-	if (!packet) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	packet->header.start = 0;
 	packet->header.direction = DIR_OUT;
 	packet->header.cmd = CMD_SEND;
@@ -370,26 +377,11 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	packet->busy7 = ir->busy7;
 	packet->busy4 = ir->busy4;
 
-	space = 0;
-	payload = packet->payload;
-
-	for (i = 0; i < count; i++) {
-		unsigned periods = txbuf[i];
-
-		while (periods > 127) {
-			*payload++ = 127 | space;
-			periods -= 127;
-		}
-
-		*payload++ = periods | space;
-		space ^= 0x80;
-	}
-
 	if (ir->receiver_on) {
 		rc = iguanair_receiver(ir, false);
 		if (rc) {
 			dev_warn(ir->dev, "disable receiver before transmit failed\n");
-			goto out_kfree;
+			goto out;
 		}
 	}
 
@@ -405,9 +397,8 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 			dev_warn(ir->dev, "re-enable receiver after transmit failed\n");
 	}
 
-out_kfree:
-	kfree(packet);
 out:
+	kfree(packet);
 	mutex_unlock(&ir->lock);
 
 	return rc ? rc : count;
-- 
1.7.11.4

