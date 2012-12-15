Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab2LOM3f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 07:29:35 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBFCTZZG002061
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 15 Dec 2012 07:29:35 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] em28xx: add support for RC6 mode 0 on devices that support it
Date: Sat, 15 Dec 2012 10:29:12 -0200
Message-Id: <1355574552-18472-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1355574552-18472-1-git-send-email-mchehab@redhat.com>
References: <1355574552-18472-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Newer em28xx chipsets (em2874 and upper) are capable of supporting
RC6 codes, on both mode 0 (command mode, 16 bits payload size, similar
to RC5, also called "Philips mode") and mode 6a (OEM command mode,
with offers a few alternatives with regards to the payload size).

I don't have any mode 6a control ATM to test it, so, I opted to add
support only to mode 0.

After this patch, adding support to mode 6a should not be hard.

Tested with a Philips television remote controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-input.c | 93 +++++++++++++++++++++++++++------
 1 file changed, 76 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 507370c..3899ea8 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -285,6 +285,9 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 		else					/* Normal NEC */
 			poll_result->scancode = msg[1] << 8 | msg[3];
 		break;
+	case RC_BIT_RC6_0:
+		poll_result->scancode = msg[1] << 8 | msg[2];
+		break;
 	default:
 		poll_result->scancode = (msg[1] << 24) | (msg[2] << 16) |
 					(msg[3] << 8)  | msg[4];
@@ -361,15 +364,42 @@ static void em28xx_ir_stop(struct rc_dev *rc)
 	cancel_delayed_work_sync(&ir->work);
 }
 
-static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
+static int em2860_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 {
-	int rc = 0;
 	struct em28xx_IR *ir = rc_dev->priv;
 	struct em28xx *dev = ir->dev;
-	u8 ir_config = EM2874_IR_RC5;
 
-	/* Adjust xclk based o IR table for RC5/NEC tables */
+	/* Adjust xclk based on IR table for RC5/NEC tables */
+	if (*rc_type & RC_BIT_RC5) {
+		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
+		ir->full_code = 1;
+		*rc_type = RC_BIT_RC5;
+	} else if (*rc_type & RC_BIT_NEC) {
+		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
+		ir->full_code = 1;
+		*rc_type = RC_BIT_NEC;
+	} else if (*rc_type & RC_BIT_UNKNOWN) {
+		*rc_type = RC_BIT_UNKNOWN;
+	} else {
+		*rc_type = ir->rc_type;
+		return -EINVAL;
+	}
+	ir->get_key = default_polling_getkey;
+	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
+			      EM28XX_XCLK_IR_RC5_MODE);
+
+	ir->rc_type = *rc_type;
 
+	return 0;
+}
+
+static int em2874_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
+{
+	struct em28xx_IR *ir = rc_dev->priv;
+	struct em28xx *dev = ir->dev;
+	u8 ir_config = EM2874_IR_RC5;
+
+	/* Adjust xclk and set type based on IR table for RC5/NEC/RC6 tables */
 	if (*rc_type & RC_BIT_RC5) {
 		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
 		ir->full_code = 1;
@@ -379,33 +409,47 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 		ir_config = EM2874_IR_NEC | EM2874_IR_NEC_NO_PARITY;
 		ir->full_code = 1;
 		*rc_type = RC_BIT_NEC;
-	} else if (*rc_type != RC_BIT_UNKNOWN)
-		rc = -EINVAL;
+	} else if (*rc_type & RC_BIT_RC6_0) {
+		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
+		ir_config = EM2874_IR_RC6_MODE_0;
+		ir->full_code = 1;
+		*rc_type = RC_BIT_RC6_0;
+	} else if (*rc_type & RC_BIT_UNKNOWN) {
+		*rc_type = RC_BIT_UNKNOWN;
+	} else {
+		*rc_type = ir->rc_type;
+		return -EINVAL;
+	}
 
-	ir->rc_type = *rc_type;
+	ir->get_key = em2874_polling_getkey;
+	em28xx_write_regs(dev, EM2874_R50_IR_CONFIG, &ir_config, 1);
 
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
 			      EM28XX_XCLK_IR_RC5_MODE);
 
+	ir->rc_type = *rc_type;
+
+	return 0;
+}
+static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
+{
+	struct em28xx_IR *ir = rc_dev->priv;
+	struct em28xx *dev = ir->dev;
+
 	/* Setup the proper handler based on the chip */
 	switch (dev->chip_id) {
 	case CHIP_ID_EM2860:
 	case CHIP_ID_EM2883:
-		ir->get_key = default_polling_getkey;
-		break;
+		return em2860_ir_change_protocol(rc_dev, rc_type);
 	case CHIP_ID_EM2884:
 	case CHIP_ID_EM2874:
 	case CHIP_ID_EM28174:
-		ir->get_key = em2874_polling_getkey;
-		em28xx_write_regs(dev, EM2874_R50_IR_CONFIG, &ir_config, 1);
-		break;
+		return em2874_ir_change_protocol(rc_dev, rc_type);
 	default:
 		printk("Unrecognized em28xx chip id 0x%02x: IR not supported\n",
 			dev->chip_id);
-		rc = -EINVAL;
+		return -EINVAL;
 	}
-
-	return rc;
 }
 
 static void em28xx_register_i2c_ir(struct em28xx *dev)
@@ -573,6 +617,21 @@ static int em28xx_ir_init(struct em28xx *dev)
 	rc->open = em28xx_ir_start;
 	rc->close = em28xx_ir_stop;
 
+	switch (dev->chip_id) {
+	case CHIP_ID_EM2860:
+	case CHIP_ID_EM2883:
+		rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
+		break;
+	case CHIP_ID_EM2884:
+	case CHIP_ID_EM2874:
+	case CHIP_ID_EM28174:
+		rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC | RC_BIT_RC6_0;
+		break;
+	default:
+		err = -ENODEV;
+		goto err_out_free;
+	}
+
 	/* By default, keep protocol field untouched */
 	rc_type = RC_BIT_UNKNOWN;
 	err = em28xx_ir_change_protocol(rc, &rc_type);
@@ -615,9 +674,9 @@ static int em28xx_ir_init(struct em28xx *dev)
 
 	return 0;
 
- err_out_stop:
+err_out_stop:
 	dev->ir = NULL;
- err_out_free:
+err_out_free:
 	rc_free_device(rc);
 	kfree(ir);
 	return err;
-- 
1.7.11.7

