Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40143 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752123AbdKFKkX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 05:40:23 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] media: rc: iguanair: remove unnecessary locking
Date: Mon,  6 Nov 2017 10:40:20 +0000
Message-Id: <b56f810c16b109a0a7a5391771fccac638cfeb0d.1509964131.git.sean@mess.org>
In-Reply-To: <cover.1509964131.git.sean@mess.org>
References: <cover.1509964131.git.sean@mess.org>
In-Reply-To: <cover.1509964131.git.sean@mess.org>
References: <cover.1509964131.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since lirc now correctly locks the rcdev, this locking is no longer
needed.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 30e24da67226..64231efcc47a 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -36,8 +36,6 @@ struct iguanair {
 	uint8_t bufsize;
 	uint8_t cycle_overhead;
 
-	struct mutex lock;
-
 	/* receiver support */
 	bool receiver_on;
 	dma_addr_t dma_in, dma_out;
@@ -295,8 +293,6 @@ static int iguanair_set_tx_carrier(struct rc_dev *dev, uint32_t carrier)
 	if (carrier < 25000 || carrier > 150000)
 		return -EINVAL;
 
-	mutex_lock(&ir->lock);
-
 	if (carrier != ir->carrier) {
 		uint32_t cycles, fours, sevens;
 
@@ -325,8 +321,6 @@ static int iguanair_set_tx_carrier(struct rc_dev *dev, uint32_t carrier)
 		ir->packet->busy4 = 110 - fours;
 	}
 
-	mutex_unlock(&ir->lock);
-
 	return 0;
 }
 
@@ -337,9 +331,7 @@ static int iguanair_set_tx_mask(struct rc_dev *dev, uint32_t mask)
 	if (mask > 15)
 		return 4;
 
-	mutex_lock(&ir->lock);
 	ir->packet->channels = mask << 4;
-	mutex_unlock(&ir->lock);
 
 	return 0;
 }
@@ -351,7 +343,6 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	unsigned i, size, periods, bytes;
 	int rc;
 
-	mutex_lock(&ir->lock);
 
 	/* convert from us to carrier periods */
 	for (i = space = size = 0; i < count; i++) {
@@ -382,8 +373,6 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 		rc = -EOVERFLOW;
 
 out:
-	mutex_unlock(&ir->lock);
-
 	return rc ? rc : count;
 }
 
@@ -392,14 +381,10 @@ static int iguanair_open(struct rc_dev *rdev)
 	struct iguanair *ir = rdev->priv;
 	int rc;
 
-	mutex_lock(&ir->lock);
-
 	rc = iguanair_receiver(ir, true);
 	if (rc == 0)
 		ir->receiver_on = true;
 
-	mutex_unlock(&ir->lock);
-
 	return rc;
 }
 
@@ -408,14 +393,10 @@ static void iguanair_close(struct rc_dev *rdev)
 	struct iguanair *ir = rdev->priv;
 	int rc;
 
-	mutex_lock(&ir->lock);
-
 	rc = iguanair_receiver(ir, false);
 	ir->receiver_on = false;
 	if (rc && rc != -ENODEV)
 		dev_warn(ir->dev, "failed to disable receiver: %d\n", rc);
-
-	mutex_unlock(&ir->lock);
 }
 
 static int iguanair_probe(struct usb_interface *intf,
@@ -456,7 +437,6 @@ static int iguanair_probe(struct usb_interface *intf,
 	ir->rc = rc;
 	ir->dev = &intf->dev;
 	ir->udev = udev;
-	mutex_init(&ir->lock);
 
 	init_completion(&ir->completion);
 	pipeout = usb_sndintpipe(udev,
@@ -553,8 +533,6 @@ static int iguanair_suspend(struct usb_interface *intf, pm_message_t message)
 	struct iguanair *ir = usb_get_intfdata(intf);
 	int rc = 0;
 
-	mutex_lock(&ir->lock);
-
 	if (ir->receiver_on) {
 		rc = iguanair_receiver(ir, false);
 		if (rc)
@@ -564,8 +542,6 @@ static int iguanair_suspend(struct usb_interface *intf, pm_message_t message)
 	usb_kill_urb(ir->urb_in);
 	usb_kill_urb(ir->urb_out);
 
-	mutex_unlock(&ir->lock);
-
 	return rc;
 }
 
@@ -574,8 +550,6 @@ static int iguanair_resume(struct usb_interface *intf)
 	struct iguanair *ir = usb_get_intfdata(intf);
 	int rc = 0;
 
-	mutex_lock(&ir->lock);
-
 	rc = usb_submit_urb(ir->urb_in, GFP_KERNEL);
 	if (rc)
 		dev_warn(&intf->dev, "failed to submit urb: %d\n", rc);
@@ -586,8 +560,6 @@ static int iguanair_resume(struct usb_interface *intf)
 			dev_warn(ir->dev, "failed to enable receiver after resume\n");
 	}
 
-	mutex_unlock(&ir->lock);
-
 	return rc;
 }
 
-- 
2.13.6
