Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51737 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbeIRUCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 16:02:23 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] media: rc: imon: report mouse events using rc-core's input device
Date: Tue, 18 Sep 2018 15:29:28 +0100
Message-Id: <20180918142930.6686-2-sean@mess.org>
In-Reply-To: <20180918142930.6686-1-sean@mess.org>
References: <20180918142930.6686-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to create another input device.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-imon-decoder.c | 62 ++----------------------------
 drivers/media/rc/rc-core-priv.h    |  2 -
 drivers/media/rc/rc-main.c         |  6 +++
 3 files changed, 10 insertions(+), 60 deletions(-)

diff --git a/drivers/media/rc/ir-imon-decoder.c b/drivers/media/rc/ir-imon-decoder.c
index 67c1b0c15aae..a0efe2605393 100644
--- a/drivers/media/rc/ir-imon-decoder.c
+++ b/drivers/media/rc/ir-imon-decoder.c
@@ -70,24 +70,13 @@ static void ir_imon_decode_scancode(struct rc_dev *dev)
 		}
 
 		if (!imon->stick_keyboard) {
-			struct lirc_scancode lsc = {
-				.scancode = imon->bits,
-				.rc_proto = RC_PROTO_IMON,
-			};
+			input_report_rel(dev->input_dev, REL_X, rel_x);
+			input_report_rel(dev->input_dev, REL_Y, rel_y);
 
-			ir_lirc_scancode_event(dev, &lsc);
-
-			input_event(imon->idev, EV_MSC, MSC_SCAN, imon->bits);
-
-			input_report_rel(imon->idev, REL_X, rel_x);
-			input_report_rel(imon->idev, REL_Y, rel_y);
-
-			input_report_key(imon->idev, BTN_LEFT,
+			input_report_key(dev->input_dev, BTN_LEFT,
 					 (imon->bits & 0x00010000) != 0);
-			input_report_key(imon->idev, BTN_RIGHT,
+			input_report_key(dev->input_dev, BTN_RIGHT,
 					 (imon->bits & 0x00040000) != 0);
-			input_sync(imon->idev);
-			return;
 		}
 	}
 
@@ -243,62 +232,19 @@ static int ir_imon_encode(enum rc_proto protocol, u32 scancode,
 
 static int ir_imon_register(struct rc_dev *dev)
 {
-	struct input_dev *idev;
 	struct imon_dec *imon = &dev->raw->imon;
-	int ret;
-
-	idev = input_allocate_device();
-	if (!idev)
-		return -ENOMEM;
-
-	snprintf(imon->name, sizeof(imon->name),
-		 "iMON PAD Stick (%s)", dev->device_name);
-	idev->name = imon->name;
-	idev->phys = dev->input_phys;
-
-	/* Mouse bits */
-	set_bit(EV_REL, idev->evbit);
-	set_bit(EV_KEY, idev->evbit);
-	set_bit(REL_X, idev->relbit);
-	set_bit(REL_Y, idev->relbit);
-	set_bit(BTN_LEFT, idev->keybit);
-	set_bit(BTN_RIGHT, idev->keybit);
-
-	/* Report scancodes too */
-	set_bit(EV_MSC, idev->evbit);
-	set_bit(MSC_SCAN, idev->mscbit);
-
-	input_set_drvdata(idev, imon);
-
-	ret = input_register_device(idev);
-	if (ret < 0) {
-		input_free_device(idev);
-		return -EIO;
-	}
 
-	imon->idev = idev;
 	imon->stick_keyboard = false;
 
 	return 0;
 }
 
-static int ir_imon_unregister(struct rc_dev *dev)
-{
-	struct imon_dec *imon = &dev->raw->imon;
-
-	input_unregister_device(imon->idev);
-	imon->idev = NULL;
-
-	return 0;
-}
-
 static struct ir_raw_handler imon_handler = {
 	.protocols	= RC_PROTO_BIT_IMON,
 	.decode		= ir_imon_decode,
 	.encode		= ir_imon_encode,
 	.carrier	= 38000,
 	.raw_register	= ir_imon_register,
-	.raw_unregister	= ir_imon_unregister,
 	.min_timeout	= IMON_UNIT * IMON_BITS * 2,
 };
 
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index e847bdad5c51..c2a8084f0a13 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -133,8 +133,6 @@ struct ir_raw_event_ctrl {
 		int last_chk;
 		unsigned int bits;
 		bool stick_keyboard;
-		struct input_dev *idev;
-		char name[64];
 	} imon;
 };
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 97086fbbed41..821e36e320b7 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1744,12 +1744,18 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 		dev->enabled_protocols = rc_proto;
 	}
 
+	/* Keyboard events */
 	set_bit(EV_KEY, dev->input_dev->evbit);
 	set_bit(EV_REP, dev->input_dev->evbit);
 	set_bit(EV_MSC, dev->input_dev->evbit);
 	set_bit(MSC_SCAN, dev->input_dev->mscbit);
 	bitmap_fill(dev->input_dev->keybit, KEY_CNT);
 
+	/* Pointer/mouse events */
+	set_bit(EV_REL, dev->input_dev->evbit);
+	set_bit(REL_X, dev->input_dev->relbit);
+	set_bit(REL_Y, dev->input_dev->relbit);
+
 	if (dev->open)
 		dev->input_dev->open = ir_open;
 	if (dev->close)
-- 
2.17.1
