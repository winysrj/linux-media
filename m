Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:56265 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab0IGVwD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 17:52:03 -0400
Subject: [PATCH 3/5] imon: split mouse events to a separate input dev
To: mchehab@infradead.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, jarod@redhat.com
Date: Tue, 07 Sep 2010 23:51:54 +0200
Message-ID: <20100907215154.30935.12665.stgit@localhost.localdomain>
In-Reply-To: <20100907214943.30935.29895.stgit@localhost.localdomain>
References: <20100907214943.30935.29895.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This is a stab at separating the mouse (and front panel/knob) events
out to a separate input device. This is necessary in preparation for
the next patch which makes the rc-core input dev opaque to rc
drivers.

I can't verify the correctness of the patch beyond the fact that it
compiles without warnings. The driver has resisted most of my
attempts at understanding it properly...for example, the double calls
to le64_to_cpu() and be64_to_cpu() which are applied in
imon_incoming_packet() and imon_panel_key_lookup() would amount
to a bswab64() call, irregardless of the cpu endianness, and I think
the code wouldn't have worked on a big-endian machine...

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/imon.c |  261 +++++++++++++++++++++++++++--------------------
 1 files changed, 150 insertions(+), 111 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index c185422..e1e0ca1 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -121,21 +121,27 @@ struct imon_context {
 	u16 vendor;			/* usb vendor ID */
 	u16 product;			/* usb product ID */
 
-	struct input_dev *idev;		/* input device for remote */
+	struct input_dev *rdev;		/* input device for remote */
+	struct input_dev *idev;		/* input device for front panel/knob and
+					 * remote (fake) mouse
+					 */
 	struct input_dev *touch;	/* input device for touchscreen */
 
 	u32 kc;				/* current input keycode */
 	u32 last_keycode;		/* last reported input keycode */
+	u32 rc_scancode;		/* the computed remote scancode */
+	u8 rc_toggle;			/* the computed remote toggle */
 	u64 ir_type;			/* iMON or MCE (RC6) IR protocol? */
-	u8 mce_toggle_bit;		/* last mce toggle bit */
 	bool release_code;		/* some keys send a release code */
 
 	u8 display_type;		/* store the display type */
 	bool pad_mouse;			/* toggle kbd(0)/mouse(1) mode */
 
+	char name_rdev[128];		/* rc device name */
+	char phys_rdev[64];		/* rc device phys path */
+
 	char name_idev[128];		/* input device name */
 	char phys_idev[64];		/* input device phys path */
-	struct timer_list itimer;	/* input device timer, need for rc6 */
 
 	char name_touch[128];		/* touch screen name */
 	char phys_touch[64];		/* touch screen phys path */
@@ -956,17 +962,6 @@ static void usb_tx_callback(struct urb *urb)
 }
 
 /**
- * mce/rc6 keypresses have no distinct release code, use timer
- */
-static void imon_mce_timeout(unsigned long data)
-{
-	struct imon_context *ictx = (struct imon_context *)data;
-
-	input_report_key(ictx->idev, ictx->last_keycode, 0);
-	input_sync(ictx->idev);
-}
-
-/**
  * report touchscreen input
  */
 static void imon_touch_display_timeout(unsigned long data)
@@ -1006,9 +1001,6 @@ int imon_ir_change_protocol(void *priv, u64 ir_type)
 		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
 		ir_proto_packet[0] = 0x01;
 		pad_mouse = false;
-		init_timer(&ictx->itimer);
-		ictx->itimer.data = (unsigned long)ictx;
-		ictx->itimer.function = imon_mce_timeout;
 		break;
 	case IR_TYPE_UNKNOWN:
 	case IR_TYPE_OTHER:
@@ -1147,20 +1139,21 @@ static int stabilize(int a, int b, u16 timeout, u16 threshold)
 	return result;
 }
 
-static u32 imon_remote_key_lookup(struct imon_context *ictx, u32 hw_code)
+static u32 imon_remote_key_lookup(struct imon_context *ictx, u32 scancode)
 {
-	u32 scancode = be32_to_cpu(hw_code);
 	u32 keycode;
 	u32 release;
 	bool is_release_code = false;
 
 	/* Look for the initial press of a button */
-	keycode = ir_g_keycode_from_table(ictx->idev, scancode);
+	keycode = ir_g_keycode_from_table(ictx->rdev, scancode);
+	ictx->rc_toggle = 0x0;
+	ictx->rc_scancode = scancode;
 
 	/* Look for the release of a button */
 	if (keycode == KEY_RESERVED) {
 		release = scancode & ~0x4000;
-		keycode = ir_g_keycode_from_table(ictx->idev, release);
+		keycode = ir_g_keycode_from_table(ictx->rdev, release);
 		if (keycode != KEY_RESERVED)
 			is_release_code = true;
 	}
@@ -1170,9 +1163,8 @@ static u32 imon_remote_key_lookup(struct imon_context *ictx, u32 hw_code)
 	return keycode;
 }
 
-static u32 imon_mce_key_lookup(struct imon_context *ictx, u32 hw_code)
+static u32 imon_mce_key_lookup(struct imon_context *ictx, u32 scancode)
 {
-	u32 scancode = be32_to_cpu(hw_code);
 	u32 keycode;
 
 #define MCE_KEY_MASK 0x7000
@@ -1186,18 +1178,18 @@ static u32 imon_mce_key_lookup(struct imon_context *ictx, u32 hw_code)
 	 * but we can't or them into all codes, as some keys are decoded in
 	 * a different way w/o the same use of the toggle bit...
 	 */
-	if ((scancode >> 24) & 0x80)
+	if (scancode & 0x80000000)
 		scancode = scancode | MCE_KEY_MASK | MCE_TOGGLE_BIT;
 
-	keycode = ir_g_keycode_from_table(ictx->idev, scancode);
+	ictx->rc_scancode = scancode;
+	keycode = ir_g_keycode_from_table(ictx->rdev, scancode);
 
 	return keycode;
 }
 
-static u32 imon_panel_key_lookup(u64 hw_code)
+static u32 imon_panel_key_lookup(u64 code)
 {
 	int i;
-	u64 code = be64_to_cpu(hw_code);
 	u32 keycode = KEY_RESERVED;
 
 	for (i = 0; i < ARRAY_SIZE(imon_panel_key_table); i++) {
@@ -1284,8 +1276,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 	int dir = 0;
 	char rel_x = 0x00, rel_y = 0x00;
 	u16 timeout, threshold;
-	u64 temp_key;
-	u32 remote_key;
+	u32 scancode = 0;
 
 	/*
 	 * The imon directional pad functions more like a touchpad. Bytes 3 & 4
@@ -1314,21 +1305,26 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 				}
 				buf[2] = dir & 0xFF;
 				buf[3] = (dir >> 8) & 0xFF;
-				memcpy(&temp_key, buf, sizeof(temp_key));
-				remote_key = (u32) (le64_to_cpu(temp_key)
-						    & 0xffffffff);
-				ictx->kc = imon_remote_key_lookup(ictx,
-								  remote_key);
+				scancode = be32_to_cpu(*((u32 *)buf));
 			}
 		} else {
+			/* Hack alert: instead of using keycodes,
+			 * we have to use hardcoded scancodes
+			 */
 			if (abs(rel_y) > abs(rel_x)) {
 				buf[2] = (rel_y > 0) ? 0x7F : 0x80;
 				buf[3] = 0;
-				ictx->kc = (rel_y > 0) ? KEY_DOWN : KEY_UP;
+				if (rel_y > 0)
+					scancode = 0x01007f00; /* DOWN */
+				else
+					scancode = 0x01008000; /* UP */
 			} else {
 				buf[2] = 0;
 				buf[3] = (rel_x > 0) ? 0x7F : 0x80;
-				ictx->kc = (rel_x > 0) ? KEY_RIGHT : KEY_LEFT;
+				if (rel_x > 0)
+					scancode = 0x0100007f; /* RIGHT */
+				else
+					scancode = 0x01000080; /* LEFT */
 			}
 		}
 
@@ -1370,29 +1366,37 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 			}
 			buf[2] = dir & 0xFF;
 			buf[3] = (dir >> 8) & 0xFF;
-			memcpy(&temp_key, buf, sizeof(temp_key));
-			remote_key = (u32) (le64_to_cpu(temp_key) & 0xffffffff);
-			ictx->kc = imon_remote_key_lookup(ictx, remote_key);
+			scancode = be32_to_cpu(*((u32 *)buf));
 		} else {
+			/* Hack alert: instead of using keycodes,
+			 * we have to use hardcoded scancodes
+			 */
 			if (abs(rel_y) > abs(rel_x)) {
 				buf[2] = (rel_y > 0) ? 0x7F : 0x80;
 				buf[3] = 0;
-				ictx->kc = (rel_y > 0) ? KEY_DOWN : KEY_UP;
+				if (rel_y > 0)
+					scancode = 0x01007f00; /* DOWN */
+				else
+					scancode = 0x01008000; /* UP */
 			} else {
 				buf[2] = 0;
 				buf[3] = (rel_x > 0) ? 0x7F : 0x80;
-				ictx->kc = (rel_x > 0) ? KEY_RIGHT : KEY_LEFT;
+				if (rel_x > 0)
+					scancode = 0x0100007f; /* RIGHT */
+				else
+					scancode = 0x01000080; /* LEFT */
 			}
 		}
 	}
+
+	if (scancode)
+		ictx->kc = imon_remote_key_lookup(ictx, scancode);
 }
 
 static int imon_parse_press_type(struct imon_context *ictx,
 				 unsigned char *buf, u8 ktype)
 {
 	int press_type = 0;
-	int rep_delay = ictx->idev->rep[REP_DELAY];
-	int rep_period = ictx->idev->rep[REP_PERIOD];
 
 	/* key release of 0x02XXXXXX key */
 	if (ictx->kc == KEY_RESERVED && buf[0] == 0x02 && buf[3] == 0x00)
@@ -1408,22 +1412,10 @@ static int imon_parse_press_type(struct imon_context *ictx,
 		 buf[2] == 0x81 && buf[3] == 0xb7)
 		ictx->kc = ictx->last_keycode;
 
-	/* mce-specific button handling */
+	/* mce-specific button handling, no keyup events */
 	else if (ktype == IMON_KEY_MCE) {
-		/* initial press */
-		if (ictx->kc != ictx->last_keycode
-		    || buf[2] != ictx->mce_toggle_bit) {
-			ictx->last_keycode = ictx->kc;
-			ictx->mce_toggle_bit = buf[2];
-			press_type = 1;
-			mod_timer(&ictx->itimer,
-				  jiffies + msecs_to_jiffies(rep_delay));
-		/* repeat */
-		} else {
-			press_type = 2;
-			mod_timer(&ictx->itimer,
-				  jiffies + msecs_to_jiffies(rep_period));
-		}
+		ictx->rc_toggle = buf[2];
+		press_type = 1;
 
 	/* incoherent or irrelevant data */
 	} else if (ictx->kc == KEY_RESERVED)
@@ -1452,15 +1444,13 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	u32 kc;
 	bool norelease = false;
 	int i;
-	u64 temp_key;
-	u64 panel_key = 0;
-	u32 remote_key = 0;
+	u64 scancode;
 	struct input_dev *idev = NULL;
 	int press_type = 0;
 	int msec;
 	struct timeval t;
 	static struct timeval prev_time = { 0, 0 };
-	u8 ktype = IMON_KEY_IMON;
+	u8 ktype;
 
 	idev = ictx->idev;
 
@@ -1469,19 +1459,21 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		return;
 
 	/* Figure out what key was pressed */
-	memcpy(&temp_key, buf, sizeof(temp_key));
 	if (len == 8 && buf[7] == 0xee) {
+		scancode = be64_to_cpu(*((u64 *)buf));
 		ktype = IMON_KEY_PANEL;
-		panel_key = le64_to_cpu(temp_key);
-		kc = imon_panel_key_lookup(panel_key);
+		kc = imon_panel_key_lookup(scancode);
 	} else {
-		remote_key = (u32) (le64_to_cpu(temp_key) & 0xffffffff);
+		scancode = be32_to_cpu(*((u32 *)buf));
 		if (ictx->ir_type == IR_TYPE_RC6) {
+			ktype = IMON_KEY_IMON;
 			if (buf[0] == 0x80)
 				ktype = IMON_KEY_MCE;
-			kc = imon_mce_key_lookup(ictx, remote_key);
-		} else
-			kc = imon_remote_key_lookup(ictx, remote_key);
+			kc = imon_mce_key_lookup(ictx, scancode);
+		} else {
+			ktype = IMON_KEY_IMON;
+			kc = imon_remote_key_lookup(ictx, scancode);
+		}
 	}
 
 	/* keyboard/mouse mode toggle button */
@@ -1504,7 +1496,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	if (ictx->display_type == IMON_DISPLAY_TYPE_VGA && len == 8 &&
 	    buf[7] == 0x86) {
 		imon_touch_event(ictx, buf);
-
+		return;
 	/* look for mouse events with pad in mouse mode */
 	} else if (ictx->pad_mouse) {
 		if (imon_mouse_event(ictx, buf, len))
@@ -1531,12 +1523,25 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	if (press_type < 0)
 		goto not_input_data;
 
+	if (ktype == IMON_KEY_MCE) {
+		ir_keydown(ictx->rdev, ictx->rc_scancode, ictx->rc_toggle);
+		ictx->last_keycode = ictx->kc;
+		return;
+	} else if (ktype == IMON_KEY_IMON) {
+		if (press_type == 0)
+			ir_keyup(ictx->rdev);
+		else
+			ir_keydown_notimeout(ictx->rdev, ictx->rc_scancode, 0);
+		ictx->last_keycode = ictx->kc;
+		return;
+	}
+
+	/* Only panel type events left to process */
 	if (ictx->kc == KEY_UNKNOWN)
 		goto unknown_key;
 
-	/* KEY_MUTE repeats from MCE and knob need to be suppressed */
-	if ((ictx->kc == KEY_MUTE && ictx->kc == ictx->last_keycode)
-	    && (buf[7] == 0xee || ktype == IMON_KEY_MCE)) {
+	/* KEY_MUTE repeats from knob need to be suppressed */
+	if (ictx->kc == KEY_MUTE && ictx->kc == ictx->last_keycode) {
 		do_gettimeofday(&t);
 		msec = tv2int(&t, &prev_time);
 		prev_time = t;
@@ -1547,11 +1552,9 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	input_report_key(idev, ictx->kc, press_type);
 	input_sync(idev);
 
-	/* panel keys and some remote keys don't generate a release */
-	if (panel_key || norelease) {
-		input_report_key(idev, ictx->kc, 0);
-		input_sync(idev);
-	}
+	/* panel keys don't generate a release */
+	input_report_key(idev, ictx->kc, 0);
+	input_sync(idev);
 
 	ictx->last_keycode = ictx->kc;
 
@@ -1559,8 +1562,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 
 unknown_key:
 	dev_info(dev, "%s: unknown keypress, code 0x%llx\n", __func__,
-		 (panel_key ? be64_to_cpu(panel_key) :
-			      be32_to_cpu(remote_key)));
+		 (long long)scancode);
 	return;
 
 not_input_data:
@@ -1651,31 +1653,71 @@ static void usb_rx_callback_intf1(struct urb *urb)
 	usb_submit_urb(ictx->rx_urb_intf1, GFP_ATOMIC);
 }
 
+static struct input_dev *imon_init_rdev(struct imon_context *ictx)
+{
+	struct input_dev *rdev;
+	struct ir_dev_props *props;
+	int ret;
+
+	rdev = input_allocate_device();
+	props = kzalloc(sizeof(*props), GFP_KERNEL);
+	if (!rdev || !props) {
+		dev_err(ictx->dev, "remote control dev allocation failed\n");
+		goto out;
+	}
+
+	snprintf(ictx->name_rdev, sizeof(ictx->name_rdev),
+		 "iMON Remote (%04x:%04x)", ictx->vendor, ictx->product);
+	usb_make_path(ictx->usbdev_intf0, ictx->phys_rdev,
+		      sizeof(ictx->phys_rdev));
+	strlcat(ictx->phys_rdev, "/input0", sizeof(ictx->phys_rdev));
+
+	rdev->name = ictx->name_rdev;
+	rdev->phys = ictx->phys_rdev;
+	usb_to_input_id(ictx->usbdev_intf0, &rdev->id);
+	rdev->dev.parent = ictx->dev;
+	rdev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	input_set_drvdata(rdev, ictx);
+
+	props->priv = ictx;
+	props->driver_type = RC_DRIVER_SCANCODE;
+	props->allowed_protos = IR_TYPE_OTHER | IR_TYPE_RC6; /* iMON PAD or MCE */
+	props->change_protocol = imon_ir_change_protocol;
+	ictx->props = props;
+
+	ret = ir_input_register(rdev, RC_MAP_IMON_PAD, props, MOD_NAME);
+	if (ret < 0) {
+		dev_err(ictx->dev, "remote input dev register failed\n");
+		goto out;
+	}
+
+	return rdev;
+
+out:
+	kfree(props);
+	input_free_device(rdev);
+	return NULL;
+}
+
 static struct input_dev *imon_init_idev(struct imon_context *ictx)
 {
 	struct input_dev *idev;
-	struct ir_dev_props *props;
 	int ret, i;
 
 	idev = input_allocate_device();
 	if (!idev) {
-		dev_err(ictx->dev, "remote input dev allocation failed\n");
-		goto idev_alloc_failed;
-	}
-
-	props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
-	if (!props) {
-		dev_err(ictx->dev, "remote ir dev props allocation failed\n");
-		goto props_alloc_failed;
+		dev_err(ictx->dev, "input dev allocation failed\n");
+		goto out;
 	}
 
 	snprintf(ictx->name_idev, sizeof(ictx->name_idev),
-		 "iMON Remote (%04x:%04x)", ictx->vendor, ictx->product);
+		 "iMON Front Panel, Knob and Mouse (%04x:%04x)",
+		 ictx->vendor, ictx->product);
 	idev->name = ictx->name_idev;
 
 	usb_make_path(ictx->usbdev_intf0, ictx->phys_idev,
 		      sizeof(ictx->phys_idev));
-	strlcat(ictx->phys_idev, "/input0", sizeof(ictx->phys_idev));
+	strlcat(ictx->phys_idev, "/input1", sizeof(ictx->phys_idev));
 	idev->phys = ictx->phys_idev;
 
 	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) | BIT_MASK(EV_REL);
@@ -1691,30 +1733,20 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 		__set_bit(kc, idev->keybit);
 	}
 
-	props->priv = ictx;
-	props->driver_type = RC_DRIVER_SCANCODE;
-	/* IR_TYPE_OTHER maps to iMON PAD remote, IR_TYPE_RC6 to MCE remote */
-	props->allowed_protos = IR_TYPE_OTHER | IR_TYPE_RC6;
-	props->change_protocol = imon_ir_change_protocol;
-	ictx->props = props;
-
 	usb_to_input_id(ictx->usbdev_intf0, &idev->id);
 	idev->dev.parent = ictx->dev;
+	input_set_drvdata(idev, ictx);
 
-	ret = ir_input_register(idev, RC_MAP_IMON_PAD, props, MOD_NAME);
+	ret = input_register_device(idev);
 	if (ret < 0) {
-		dev_err(ictx->dev, "remote input dev register failed\n");
-		goto idev_register_failed;
+		dev_err(ictx->dev, "input dev register failed\n");
+		goto out;
 	}
 
 	return idev;
 
-idev_register_failed:
-	kfree(props);
-props_alloc_failed:
+out:
 	input_free_device(idev);
-idev_alloc_failed:
-
 	return NULL;
 }
 
@@ -1736,7 +1768,7 @@ static struct input_dev *imon_init_touch(struct imon_context *ictx)
 
 	usb_make_path(ictx->usbdev_intf1, ictx->phys_touch,
 		      sizeof(ictx->phys_touch));
-	strlcat(ictx->phys_touch, "/input1", sizeof(ictx->phys_touch));
+	strlcat(ictx->phys_touch, "/input2", sizeof(ictx->phys_touch));
 	touch->phys = ictx->phys_touch;
 
 	touch->evbit[0] =
@@ -1911,6 +1943,12 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 		goto idev_setup_failed;
 	}
 
+	ictx->rdev = imon_init_rdev(ictx);
+	if (!ictx->rdev) {
+		dev_err(dev, "%s: rc device setup failed\n", __func__);
+		goto rdev_setup_failed;
+	}
+
 	usb_fill_int_urb(ictx->rx_urb_intf0, ictx->usbdev_intf0,
 		usb_rcvintpipe(ictx->usbdev_intf0,
 			ictx->rx_endpoint_intf0->bEndpointAddress),
@@ -1928,7 +1966,9 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 	return ictx;
 
 urb_submit_failed:
-	ir_input_unregister(ictx->idev);
+	ir_input_unregister(ictx->rdev);
+rdev_setup_failed:
+	input_unregister_device(ictx->idev);
 idev_setup_failed:
 find_endpoint_failed:
 	mutex_unlock(&ictx->lock);
@@ -2289,7 +2329,8 @@ static void __devexit imon_disconnect(struct usb_interface *interface)
 	if (ifnum == 0) {
 		ictx->dev_present_intf0 = false;
 		usb_kill_urb(ictx->rx_urb_intf0);
-		ir_input_unregister(ictx->idev);
+		input_unregister_device(ictx->idev);
+		ir_input_unregister(ictx->rdev);
 		if (ictx->display_supported) {
 			if (ictx->display_type == IMON_DISPLAY_TYPE_LCD)
 				usb_deregister_dev(interface, &imon_lcd_class);
@@ -2310,8 +2351,6 @@ static void __devexit imon_disconnect(struct usb_interface *interface)
 		if (!ictx->display_isopen)
 			free_imon_context(ictx);
 	} else {
-		if (ictx->ir_type == IR_TYPE_RC6)
-			del_timer_sync(&ictx->itimer);
 		mutex_unlock(&ictx->lock);
 	}
 

