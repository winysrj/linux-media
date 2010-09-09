Return-path: <mchehab@pedra>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:59301 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996Ab0IIRp0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 13:45:26 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: bugfix data handling
Date: Thu,  9 Sep 2010 19:45:22 +0200
Message-Id: <1284054322-6020-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-input.c |   61 +++++++++++++++++++++------------
 1 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index 7b07096..daca3a5 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -46,7 +46,7 @@ MODULE_PARM_DESC(enable_ir, "enable ir (default is enable)");
 	}
 
 struct tm6000_ir_poll_result {
-	u8 rc_data[4];
+	u16 rc_data;
 };
 
 struct tm6000_IR {
@@ -60,9 +60,9 @@ struct tm6000_IR {
 	int			polling;
 	struct delayed_work	work;
 	u8			wait:1;
+	u8			key:1;
 	struct urb		*int_urb;
 	u8			*urb_data;
-	u8			key:1;
 
 	int (*get_key) (struct tm6000_IR *, struct tm6000_ir_poll_result *);
 
@@ -122,13 +122,14 @@ static void tm6000_ir_urb_received(struct urb *urb)
 
 	if (urb->status != 0)
 		printk(KERN_INFO "not ready\n");
-	else if (urb->actual_length > 0)
+	else if (urb->actual_length > 0) {
 		memcpy(ir->urb_data, urb->transfer_buffer, urb->actual_length);
 
-	dprintk("data %02x %02x %02x %02x\n", ir->urb_data[0],
-	ir->urb_data[1], ir->urb_data[2], ir->urb_data[3]);
+		dprintk("data %02x %02x %02x %02x\n", ir->urb_data[0],
+			ir->urb_data[1], ir->urb_data[2], ir->urb_data[3]);
 
-	ir->key = 1;
+		ir->key = 1;
+	}
 
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 }
@@ -140,30 +141,47 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 	int rc;
 	u8 buf[2];
 
-	if (ir->wait && !&dev->int_in) {
-		poll_result->rc_data[0] = 0xff;
+	if (ir->wait && !&dev->int_in)
 		return 0;
-	}
 
 	if (&dev->int_in) {
-		poll_result->rc_data[0] = ir->urb_data[0];
-		poll_result->rc_data[1] = ir->urb_data[1];
+		if (ir->ir.ir_type == IR_TYPE_RC5)
+			poll_result->rc_data = ir->urb_data[0];
+		else
+			poll_result->rc_data = ir->urb_data[0] | ir->urb_data[1] << 8;
 	} else {
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 0);
 		msleep(10);
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 1);
 		msleep(10);
 
-		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
-		 USB_RECIP_DEVICE, REQ_02_GET_IR_CODE, 0, 0, buf, 1);
+		if (ir->ir.ir_type == IR_TYPE_RC5) {
+			rc = tm6000_read_write_usb(dev, USB_DIR_IN |
+				USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+				REQ_02_GET_IR_CODE, 0, 0, buf, 1);
 
-		msleep(10);
+			msleep(10);
 
-		dprintk("read data=%02x\n", buf[0]);
-		if (rc < 0)
-			return rc;
+			dprintk("read data=%02x\n", buf[0]);
+			if (rc < 0)
+				return rc;
 
-		poll_result->rc_data[0] = buf[0];
+			poll_result->rc_data = buf[0];
+		} else {
+			rc = tm6000_read_write_usb(dev, USB_DIR_IN |
+				USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+				REQ_02_GET_IR_CODE, 0, 0, buf, 2);
+
+			msleep(10);
+
+			dprintk("read data=%04x\n", buf[0] | buf[1] << 8);
+			if (rc < 0)
+				return rc;
+
+			poll_result->rc_data = buf[0] | buf[1] << 8;
+		}
+		if ((poll_result->rc_data & 0x00ff) != 0xff)
+			ir->key = 1;
 	}
 	return 0;
 }
@@ -180,12 +198,11 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 		return;
 	}
 
-	dprintk("ir->get_key result data=%02x %02x\n",
-		poll_result.rc_data[0], poll_result.rc_data[1]);
+	dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
 
-	if (poll_result.rc_data[0] != 0xff && ir->key == 1) {
+	if (ir->key) {
 		ir_input_keydown(ir->input->input_dev, &ir->ir,
-			poll_result.rc_data[0] | poll_result.rc_data[1] << 8);
+				(u32)poll_result.rc_data);
 
 		ir_input_nokey(ir->input->input_dev, &ir->ir);
 		ir->key = 0;
-- 
1.7.1

