Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:46435 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab2HJT2K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 15:28:10 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	Stefan Macher <st_maker-lirc@yahoo.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/6] [media] iguanair: Fix return value on transmit
Date: Fri, 10 Aug 2012 20:28:03 +0100
Message-Id: <1344626888-10536-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Transmit returned 0 after sending and failed to send anything if the amount
exceeded its buffer size. Also fix some minor errors.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index aa7f34f..437aa42 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -75,7 +75,7 @@ struct iguanair {
 
 #define MAX_PACKET_SIZE		8u
 #define TIMEOUT			1000
-#define RX_RESOLUTION		21330
+#define RX_RESOLUTION		21333
 
 struct packet {
 	uint16_t start;
@@ -349,7 +349,7 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 {
 	struct iguanair *ir = dev->priv;
 	uint8_t space, *payload;
-	unsigned i, size, rc;
+	unsigned i, size, rc, bytes;
 	struct send_packet *packet;
 
 	mutex_lock(&ir->lock);
@@ -357,17 +357,22 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
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
 
@@ -398,7 +403,7 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 		rc = iguanair_receiver(ir, false);
 		if (rc) {
 			dev_warn(ir->dev, "disable receiver before transmit failed\n");
-			goto out;
+			goto out_kfree;
 		}
 	}
 
@@ -414,11 +419,12 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
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
@@ -466,16 +472,16 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	rc = rc_allocate_device();
 	if (!ir || !rc) {
-		ret = ENOMEM;
+		ret = -ENOMEM;
 		goto out;
 	}
 
-	ir->buf_in = usb_alloc_coherent(udev, MAX_PACKET_SIZE, GFP_ATOMIC,
+	ir->buf_in = usb_alloc_coherent(udev, MAX_PACKET_SIZE, GFP_KERNEL,
 								&ir->dma_in);
 	ir->urb_in = usb_alloc_urb(0, GFP_KERNEL);
 
 	if (!ir->buf_in || !ir->urb_in) {
-		ret = ENOMEM;
+		ret = -ENOMEM;
 		goto out;
 	}
 
-- 
1.7.11.2

