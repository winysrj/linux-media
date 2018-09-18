Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59365 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729705AbeIRUCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 16:02:23 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] media: rc: mce_kbd: input events via rc-core's input device
Date: Tue, 18 Sep 2018 15:29:29 +0100
Message-Id: <20180918142930.6686-3-sean@mess.org>
In-Reply-To: <20180918142930.6686-1-sean@mess.org>
References: <20180918142930.6686-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to create another input device.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c | 77 +++++----------------------
 drivers/media/rc/rc-core-priv.h       |  3 --
 2 files changed, 14 insertions(+), 66 deletions(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 64ea42927669..67f1c179c713 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -129,13 +129,14 @@ static void mce_kbd_rx_timeout(struct timer_list *t)
 	if (time_is_before_eq_jiffies(raw->mce_kbd.rx_timeout.expires)) {
 		for (i = 0; i < 7; i++) {
 			maskcode = kbd_keycodes[MCIR2_MASK_KEYS_START + i];
-			input_report_key(raw->mce_kbd.idev, maskcode, 0);
+			input_report_key(raw->dev->input_dev, maskcode, 0);
 		}
 
 		for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
-			input_report_key(raw->mce_kbd.idev, kbd_keycodes[i], 0);
+			input_report_key(raw->dev->input_dev, kbd_keycodes[i],
+					 0);
 
-		input_sync(raw->mce_kbd.idev);
+		input_sync(raw->dev->input_dev);
 	}
 	spin_unlock_irqrestore(&raw->mce_kbd.keylock, flags);
 }
@@ -154,7 +155,6 @@ static enum mce_kbd_mode mce_kbd_mode(struct mce_kbd_dec *data)
 
 static void ir_mce_kbd_process_keyboard_data(struct rc_dev *dev, u32 scancode)
 {
-	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
 	u8 keydata1  = (scancode >> 8) & 0xff;
 	u8 keydata2  = (scancode >> 16) & 0xff;
 	u8 shiftmask = scancode & 0xff;
@@ -170,23 +170,22 @@ static void ir_mce_kbd_process_keyboard_data(struct rc_dev *dev, u32 scancode)
 			keystate = 1;
 		else
 			keystate = 0;
-		input_report_key(data->idev, maskcode, keystate);
+		input_report_key(dev->input_dev, maskcode, keystate);
 	}
 
 	if (keydata1)
-		input_report_key(data->idev, kbd_keycodes[keydata1], 1);
+		input_report_key(dev->input_dev, kbd_keycodes[keydata1], 1);
 	if (keydata2)
-		input_report_key(data->idev, kbd_keycodes[keydata2], 1);
+		input_report_key(dev->input_dev, kbd_keycodes[keydata2], 1);
 
 	if (!keydata1 && !keydata2) {
 		for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
-			input_report_key(data->idev, kbd_keycodes[i], 0);
+			input_report_key(dev->input_dev, kbd_keycodes[i], 0);
 	}
 }
 
 static void ir_mce_kbd_process_mouse_data(struct rc_dev *dev, u32 scancode)
 {
-	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
 	/* raw mouse coordinates */
 	u8 xdata = (scancode >> 7) & 0x7f;
 	u8 ydata = (scancode >> 14) & 0x7f;
@@ -208,11 +207,11 @@ static void ir_mce_kbd_process_mouse_data(struct rc_dev *dev, u32 scancode)
 	dev_dbg(&dev->dev, "mouse: x = %d, y = %d, btns = %s%s\n",
 		x, y, left ? "L" : "", right ? "R" : "");
 
-	input_report_rel(data->idev, REL_X, x);
-	input_report_rel(data->idev, REL_Y, y);
+	input_report_rel(dev->input_dev, REL_X, x);
+	input_report_rel(dev->input_dev, REL_Y, y);
 
-	input_report_key(data->idev, BTN_LEFT, left);
-	input_report_key(data->idev, BTN_RIGHT, right);
+	input_report_key(dev->input_dev, BTN_LEFT, left);
+	input_report_key(dev->input_dev, BTN_RIGHT, right);
 }
 
 /**
@@ -355,8 +354,8 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		lsc.scancode = scancode;
 		ir_lirc_scancode_event(dev, &lsc);
 		data->state = STATE_INACTIVE;
-		input_event(data->idev, EV_MSC, MSC_SCAN, scancode);
-		input_sync(data->idev);
+		input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
+		input_sync(dev->input_dev);
 		return 0;
 	}
 
@@ -370,66 +369,18 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 static int ir_mce_kbd_register(struct rc_dev *dev)
 {
 	struct mce_kbd_dec *mce_kbd = &dev->raw->mce_kbd;
-	struct input_dev *idev;
-	int i, ret;
-
-	idev = input_allocate_device();
-	if (!idev)
-		return -ENOMEM;
-
-	snprintf(mce_kbd->name, sizeof(mce_kbd->name),
-		 "MCE IR Keyboard/Mouse (%s)", dev->driver_name);
-	strlcat(mce_kbd->phys, "/input0", sizeof(mce_kbd->phys));
-
-	idev->name = mce_kbd->name;
-	idev->phys = mce_kbd->phys;
-
-	/* Keyboard bits */
-	set_bit(EV_KEY, idev->evbit);
-	set_bit(EV_REP, idev->evbit);
-	for (i = 0; i < sizeof(kbd_keycodes); i++)
-		set_bit(kbd_keycodes[i], idev->keybit);
-
-	/* Mouse bits */
-	set_bit(EV_REL, idev->evbit);
-	set_bit(REL_X, idev->relbit);
-	set_bit(REL_Y, idev->relbit);
-	set_bit(BTN_LEFT, idev->keybit);
-	set_bit(BTN_RIGHT, idev->keybit);
-
-	/* Report scancodes too */
-	set_bit(EV_MSC, idev->evbit);
-	set_bit(MSC_SCAN, idev->mscbit);
 
 	timer_setup(&mce_kbd->rx_timeout, mce_kbd_rx_timeout, 0);
 	spin_lock_init(&mce_kbd->keylock);
 
-	input_set_drvdata(idev, mce_kbd);
-
-#if 0
-	/* Adding this reference means two input devices are associated with
-	 * this rc-core device, which ir-keytable doesn't cope with yet */
-	idev->dev.parent = &dev->dev;
-#endif
-
-	ret = input_register_device(idev);
-	if (ret < 0) {
-		input_free_device(idev);
-		return -EIO;
-	}
-
-	mce_kbd->idev = idev;
-
 	return 0;
 }
 
 static int ir_mce_kbd_unregister(struct rc_dev *dev)
 {
 	struct mce_kbd_dec *mce_kbd = &dev->raw->mce_kbd;
-	struct input_dev *idev = mce_kbd->idev;
 
 	del_timer_sync(&mce_kbd->rx_timeout);
-	input_unregister_device(idev);
 
 	return 0;
 }
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index c2a8084f0a13..fe69788e6c37 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -110,12 +110,9 @@ struct ir_raw_event_ctrl {
 		unsigned int pulse_len;
 	} sharp;
 	struct mce_kbd_dec {
-		struct input_dev *idev;
 		/* locks key up timer */
 		spinlock_t keylock;
 		struct timer_list rx_timeout;
-		char name[64];
-		char phys[64];
 		int state;
 		u8 header;
 		u32 body;
-- 
2.17.1
