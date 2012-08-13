Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:46993 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab2HMM7y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:59:54 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Stefan Macher <st_maker-lirc@yahoo.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 04/13] [media] iguanair: fix return value for transmit
Date: Mon, 13 Aug 2012 13:59:42 +0100
Message-Id: <1344862791-30352-4-git-send-email-sean@mess.org>
In-Reply-To: <1344862791-30352-1-git-send-email-sean@mess.org>
References: <1344862791-30352-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also fix error codes returned from open.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 7eeabdb..4525107 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -325,7 +325,7 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 {
 	struct iguanair *ir = dev->priv;
 	uint8_t space, *payload;
-	unsigned i, size, rc;
+	unsigned i, size, rc, bytes;
 	struct send_packet *packet;
 
 	mutex_lock(&ir->lock);
@@ -333,17 +333,22 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	/* convert from us to carrier periods */
 	for (i = size = 0; i < count; i++) {
 		txbuf[i] = DIV_ROUND_CLOSEST(txbuf[i] * ir->carrier, 1000000);
-		size += (txbuf[i] + 126) / 127;
+		bytes = (txbuf[i] + 126) / 127;
+		if (size + bytes > ir->bufsize) {
+			count = i;
+			break;
+		}
+		size += bytes;
 	}
 
-	packet = kmalloc(sizeof(*packet) + size, GFP_KERNEL);
-	if (!packet) {
-		rc = -ENOMEM;
+	if (count == 0) {
+		rc = -EINVAL;
 		goto out;
 	}
 
-	if (size > ir->bufsize) {
-		rc = -E2BIG;
+	packet = kmalloc(sizeof(*packet) + size, GFP_KERNEL);
+	if (!packet) {
+		rc = -ENOMEM;
 		goto out;
 	}
 
@@ -374,7 +379,7 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 		rc = iguanair_receiver(ir, false);
 		if (rc) {
 			dev_warn(ir->dev, "disable receiver before transmit failed\n");
-			goto out;
+			goto out_kfree;
 		}
 	}
 
@@ -390,11 +395,12 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 			dev_warn(ir->dev, "re-enable receiver after transmit failed\n");
 	}
 
+out_kfree:
+	kfree(packet);
 out:
 	mutex_unlock(&ir->lock);
-	kfree(packet);
 
-	return rc;
+	return rc ? rc : count;
 }
 
 static int iguanair_open(struct rc_dev *rdev)
@@ -442,7 +448,7 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	rc = rc_allocate_device();
 	if (!ir || !rc) {
-		ret = ENOMEM;
+		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -451,7 +457,7 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
 	ir->urb_in = usb_alloc_urb(0, GFP_KERNEL);
 
 	if (!ir->buf_in || !ir->urb_in) {
-		ret = ENOMEM;
+		ret = -ENOMEM;
 		goto out;
 	}
 
-- 
1.7.11.2

