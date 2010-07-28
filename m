Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab0G1CYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 22:24:03 -0400
Date: Tue, 27 Jul 2010 22:24:00 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH] IR/mceusb: remove bad ir_input_dev use
Message-ID: <20100728022400.GA5398@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ir_input_dev gets filled in by __ir_input_register, the one
allocated in mceusb_init_input_dev was being overwritten by the correct
one shortly after it was initialized (ultimately resulting in a memory
leak). This bug was inherited from imon.c, and was pointed out to me by
Maxim Levitsky.

CC: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index 78bf7f7..9a7da32 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -228,7 +228,6 @@ static struct usb_device_id std_tx_mask_list[] = {
 /* data structure for each usb transceiver */
 struct mceusb_dev {
 	/* ir-core bits */
-	struct ir_input_dev *irdev;
 	struct ir_dev_props *props;
 	struct ir_raw_event rawir;
 
@@ -739,7 +738,7 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 
 	if (ir->send_flags == RECV_FLAG_IN_PROGRESS) {
 		ir->send_flags = SEND_FLAG_COMPLETE;
-		dev_dbg(&ir->irdev->dev, "setup answer received %d bytes\n",
+		dev_dbg(&ir->dev, "setup answer received %d bytes\n",
 			buf_len);
 	}
 
@@ -861,7 +860,6 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 {
 	struct input_dev *idev;
 	struct ir_dev_props *props;
-	struct ir_input_dev *irdev;
 	struct device *dev = ir->dev;
 	int ret = -ENODEV;
 
@@ -878,12 +876,6 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 		goto props_alloc_failed;
 	}
 
-	irdev = kzalloc(sizeof(struct ir_input_dev), GFP_KERNEL);
-	if (!irdev) {
-		dev_err(dev, "remote ir input dev allocation failed\n");
-		goto ir_dev_alloc_failed;
-	}
-
 	snprintf(ir->name, sizeof(ir->name), "Media Center Ed. eHome "
 		 "Infrared Remote Transceiver (%04x:%04x)",
 		 le16_to_cpu(ir->usbdev->descriptor.idVendor),
@@ -902,9 +894,6 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 	props->tx_ir = mceusb_tx_ir;
 
 	ir->props = props;
-	ir->irdev = irdev;
-
-	input_set_drvdata(idev, irdev);
 
 	ret = ir_input_register(idev, RC_MAP_RC6_MCE, props, DRIVER_NAME);
 	if (ret < 0) {
@@ -915,8 +904,6 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 	return idev;
 
 irdev_failed:
-	kfree(irdev);
-ir_dev_alloc_failed:
 	kfree(props);
 props_alloc_failed:
 	input_free_device(idev);
-- 
1.7.1.1

-- 
Jarod Wilson
jarod@redhat.com

