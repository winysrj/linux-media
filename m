Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:46994 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab2HMM7y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:59:54 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Stefan Macher <st_maker-lirc@yahoo.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 05/13] [media] iguanair: support suspend and resume
Date: Mon, 13 Aug 2012 13:59:43 +0100
Message-Id: <1344862791-30352-5-git-send-email-sean@mess.org>
In-Reply-To: <1344862791-30352-1-git-send-email-sean@mess.org>
References: <1344862791-30352-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now unbind also stops the receiver.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 4525107..a6a19eb 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -156,6 +156,7 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
 static void iguanair_rx(struct urb *urb)
 {
 	struct iguanair *ir;
+	int rc;
 
 	if (!urb)
 		return;
@@ -181,7 +182,9 @@ static void iguanair_rx(struct urb *urb)
 		break;
 	}
 
-	usb_submit_urb(urb, GFP_ATOMIC);
+	rc = usb_submit_urb(urb, GFP_ATOMIC);
+	if (rc && rc != -ENODEV)
+		dev_warn(ir->dev, "failed to resubmit urb: %d\n", rc);
 }
 
 static int iguanair_send(struct iguanair *ir, void *data, unsigned size)
@@ -430,7 +433,7 @@ static void iguanair_close(struct rc_dev *rdev)
 
 	rc = iguanair_receiver(ir, false);
 	ir->receiver_on = false;
-	if (rc)
+	if (rc && rc != -ENODEV)
 		dev_warn(ir->dev, "failed to disable receiver: %d\n", rc);
 
 	mutex_unlock(&ir->lock);
@@ -525,8 +528,6 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, ir);
 
-	dev_info(&intf->dev, "Registered %s", ir->name);
-
 	return 0;
 out2:
 	usb_kill_urb(ir->urb_in);
@@ -545,12 +546,11 @@ static void __devexit iguanair_disconnect(struct usb_interface *intf)
 {
 	struct iguanair *ir = usb_get_intfdata(intf);
 
+	rc_unregister_device(ir->rc);
 	usb_set_intfdata(intf, NULL);
-
 	usb_kill_urb(ir->urb_in);
 	usb_free_urb(ir->urb_in);
 	usb_free_coherent(ir->udev, MAX_PACKET_SIZE, ir->buf_in, ir->dma_in);
-	rc_unregister_device(ir->rc);
 	kfree(ir);
 }
 
@@ -567,6 +567,8 @@ static int iguanair_suspend(struct usb_interface *intf, pm_message_t message)
 			dev_warn(ir->dev, "failed to disable receiver for suspend\n");
 	}
 
+	usb_kill_urb(ir->urb_in);
+
 	mutex_unlock(&ir->lock);
 
 	return rc;
@@ -579,6 +581,10 @@ static int iguanair_resume(struct usb_interface *intf)
 
 	mutex_lock(&ir->lock);
 
+	rc = usb_submit_urb(ir->urb_in, GFP_KERNEL);
+	if (rc)
+		dev_warn(&intf->dev, "failed to submit urb: %d\n", rc);
+
 	if (ir->receiver_on) {
 		rc = iguanair_receiver(ir, true);
 		if (rc)
@@ -602,7 +608,8 @@ static struct usb_driver iguanair_driver = {
 	.suspend = iguanair_suspend,
 	.resume = iguanair_resume,
 	.reset_resume = iguanair_resume,
-	.id_table = iguanair_table
+	.id_table = iguanair_table,
+	.soft_unbind = 1	/* we want to disable receiver on unbind */
 };
 
 module_usb_driver(iguanair_driver);
-- 
1.7.11.2

