Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab0DWF1R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 01:27:17 -0400
Date: Fri, 23 Apr 2010 01:27:11 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH] IR/imon: convert to ir-core protocol change handling
Message-ID: <20100423052711.GA29432@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drop the imon driver's internal protocol definitions in favor of using
those provided by ir-core. Should make ir-keytable Just Work for
switching protocol on the fly on the imon devices that support both the
native imon remotes and mce remotes.

The imon-no-pad-stabilize pseudo-protocol was dropped as a protocol, and
converted to a separate modprobe option (which it probably should have
been in the first place). On the TODO list is to convert this to an as yet
unwritten protocol-specific options framework.

While the mce remotes obviously map to IR_TYPE_RC6, I've yet to look at
what the actual ir signals from the native imon remotes are, so for the
moment, imon native ir is mapped to IR_TYPE_OTHER. Nailing it down more
accurately is also on the TODO list.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 drivers/media/IR/imon.c                |  151 ++++++++++++++------------------
 drivers/media/IR/keymaps/rc-imon-mce.c |    4 +-
 drivers/media/IR/keymaps/rc-imon-pad.c |    3 +-
 3 files changed, 69 insertions(+), 89 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index d941b98..b65c31a 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -127,8 +127,7 @@ struct imon_context {
 
 	u32 kc;				/* current input keycode */
 	u32 last_keycode;		/* last reported input keycode */
-	u8 ir_protocol;			/* iMON or MCE (RC6) IR protocol? */
-	u8 ir_proto_mask;		/* supported IR protocol mask */
+	u64 ir_type;			/* iMON or MCE (RC6) IR protocol? */
 	u8 mce_toggle_bit;		/* last mce toggle bit */
 	bool release_code;		/* some keys send a release code */
 
@@ -174,20 +173,6 @@ enum {
 };
 
 enum {
-	IMON_IR_PROTOCOL_AUTO       = 0x0,
-	IMON_IR_PROTOCOL_MCE        = 0x1,
-	IMON_IR_PROTOCOL_IMON       = 0x2,
-	IMON_IR_PROTOCOL_IMON_NOPAD = 0x4,
-};
-
-enum {
-	IMON_IR_PROTO_MASK_NONE = 0x0,
-	IMON_IR_PROTO_MASK_MCE  = IMON_IR_PROTOCOL_MCE,
-	IMON_IR_PROTO_MASK_IMON = IMON_IR_PROTOCOL_IMON |
-				  IMON_IR_PROTOCOL_IMON_NOPAD,
-};
-
-enum {
 	IMON_KEY_IMON	= 0,
 	IMON_KEY_MCE	= 1,
 	IMON_KEY_PANEL	= 2,
@@ -330,12 +315,10 @@ module_param(display_type, int, S_IRUGO);
 MODULE_PARM_DESC(display_type, "Type of attached display. 0=autodetect, "
 		 "1=vfd, 2=lcd, 3=vga, 4=none (default: autodetect)");
 
-/* IR protocol: native iMON, Windows MCE (RC-6), or iMON w/o PAD stabilize */
-static int ir_protocol;
-module_param(ir_protocol, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(ir_protocol, "Which IR protocol to use. 0=auto-detect, "
-		 "1=Windows Media Center Ed. (RC-6), 2=iMON native, "
-		 "4=iMON w/o PAD stabilize (default: auto-detect)");
+static int pad_stabilize = 1;
+module_param(pad_stabilize, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(pad_stabilize, "Apply stabilization algorithm to iMON PAD "
+		 "presses in arrow key mode. 0=disable, 1=enable (default).");
 
 /*
  * In certain use cases, mouse mode isn't really helpful, and could actually
@@ -1007,72 +990,67 @@ static void imon_touch_display_timeout(unsigned long data)
  * really just RC-6), but only one or the other at a time, as the signals
  * are decoded onboard the receiver.
  */
-static void imon_set_ir_protocol(struct imon_context *ictx)
+int imon_ir_change_protocol(void *priv, u64 ir_type)
 {
 	int retval;
+	struct imon_context *ictx = priv;
 	struct device *dev = ictx->dev;
+	bool pad_mouse;
 	unsigned char ir_proto_packet[] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
 
-	if (ir_protocol && !(ir_protocol & ictx->ir_proto_mask))
+	if (!(ir_type & ictx->props->allowed_protos))
 		dev_warn(dev, "Looks like you're trying to use an IR protocol "
 			 "this device does not support\n");
 
-	switch (ir_protocol) {
-	case IMON_IR_PROTOCOL_AUTO:
-		if (ictx->product == 0xffdc) {
-			if (ictx->ir_proto_mask & IMON_IR_PROTO_MASK_MCE) {
-				ir_proto_packet[0] = 0x01;
-				ictx->ir_protocol = IMON_IR_PROTOCOL_MCE;
-				ictx->pad_mouse = 0;
-				init_timer(&ictx->itimer);
-				ictx->itimer.data = (unsigned long)ictx;
-				ictx->itimer.function = imon_mce_timeout;
-			} else {
-				ictx->ir_protocol = IMON_IR_PROTOCOL_IMON;
-				ictx->pad_mouse = 1;
-			}
-		}
-		break;
-	case IMON_IR_PROTOCOL_MCE:
+	switch (ir_type) {
+	case IR_TYPE_RC6:
 		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
 		ir_proto_packet[0] = 0x01;
-		ictx->ir_protocol = IMON_IR_PROTOCOL_MCE;
-		ictx->pad_mouse = 0;
+		pad_mouse = false;
 		init_timer(&ictx->itimer);
 		ictx->itimer.data = (unsigned long)ictx;
 		ictx->itimer.function = imon_mce_timeout;
 		break;
-	case IMON_IR_PROTOCOL_IMON:
-		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
-		/* ir_proto_packet[0] = 0x00; // already the default */
-		ictx->ir_protocol = IMON_IR_PROTOCOL_IMON;
-		ictx->pad_mouse = 1;
-		break;
-	case IMON_IR_PROTOCOL_IMON_NOPAD:
-		dev_dbg(dev, "Configuring IR receiver for iMON protocol "
-			"without PAD stabilize function enabled\n");
+	case IR_TYPE_UNKNOWN:
+	case IR_TYPE_OTHER:
+		dev_dbg(dev, "Configuring IR receiver for iMON protocol");
+		if (pad_stabilize) {
+			printk(KERN_CONT "\n");
+			pad_mouse = true;
+		} else {
+			printk(KERN_CONT " (without PAD stabilization)\n");
+			pad_mouse = false;
+		}
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		ictx->ir_protocol = IMON_IR_PROTOCOL_IMON_NOPAD;
-		ictx->pad_mouse = 0;
+		ir_type = IR_TYPE_OTHER;
 		break;
 	default:
-		dev_info(dev, "%s: unknown IR protocol specified, will "
-			 "just default to iMON protocol\n", __func__);
-		ictx->ir_protocol = IMON_IR_PROTOCOL_IMON;
-		ictx->pad_mouse = 1;
+		dev_warn(dev, "Unsupported IR protocol specified, overriding "
+			 "to iMON IR protocol");
+		if (pad_stabilize) {
+			printk(KERN_CONT "\n");
+			pad_mouse = true;
+		} else {
+			printk(KERN_CONT " (without PAD stabilization)\n");
+			pad_mouse = false;
+		}
+		/* ir_proto_packet[0] = 0x00; // already the default */
+		ir_type = IR_TYPE_OTHER;
 		break;
 	}
 
 	memcpy(ictx->usb_tx_buf, &ir_proto_packet, sizeof(ir_proto_packet));
 
 	retval = send_packet(ictx);
-	if (retval) {
-		dev_info(dev, "%s: failed to set IR protocol, falling back "
-			 "to standard iMON protocol mode\n", __func__);
-		ir_protocol = IMON_IR_PROTOCOL_IMON;
-		ictx->ir_protocol = IMON_IR_PROTOCOL_IMON;
-	}
+	if (retval)
+		goto out;
+
+	ictx->ir_type = ir_type;
+	ictx->pad_mouse = pad_mouse;
+
+out:
+	return retval;
 }
 
 static inline int tv2int(const struct timeval *a, const struct timeval *b)
@@ -1329,7 +1307,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		rel_x = buf[2];
 		rel_y = buf[3];
 
-		if (ictx->ir_protocol == IMON_IR_PROTOCOL_IMON) {
+		if (ictx->ir_type == IR_TYPE_OTHER && pad_stabilize) {
 			if ((buf[1] == 0) && ((rel_x != 0) || (rel_y != 0))) {
 				dir = stabilize((int)rel_x, (int)rel_y,
 						timeout, threshold);
@@ -1386,7 +1364,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		buf[0] = 0x01;
 		buf[1] = buf[4] = buf[5] = buf[6] = buf[7] = 0;
 
-		if (ictx->ir_protocol == IMON_IR_PROTOCOL_IMON) {
+		if (ictx->ir_type == IR_TYPE_OTHER && pad_stabilize) {
 			dir = stabilize((int)rel_x, (int)rel_y,
 					timeout, threshold);
 			if (!dir) {
@@ -1499,7 +1477,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		kc = imon_panel_key_lookup(panel_key);
 	} else {
 		remote_key = (u32) (le64_to_cpu(temp_key) & 0xffffffff);
-		if (ictx->ir_protocol == IMON_IR_PROTOCOL_MCE) {
+		if (ictx->ir_type == IR_TYPE_RC6) {
 			if (buf[0] == 0x80)
 				ktype = IMON_KEY_MCE;
 			kc = imon_mce_key_lookup(ictx, remote_key);
@@ -1680,12 +1658,6 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 	struct ir_dev_props *props;
 	struct ir_input_dev *ir;
 	int ret, i;
-	char *ir_codes = NULL;
-
-	if (ir_protocol == IMON_IR_PROTOCOL_MCE)
-		ir_codes = RC_MAP_IMON_MCE;
-	else
-		ir_codes = RC_MAP_IMON_PAD;
 
 	idev = input_allocate_device();
 	if (!idev) {
@@ -1727,8 +1699,12 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 		__set_bit(kc, idev->keybit);
 	}
 
+	props->priv = ictx;
 	props->driver_type = RC_DRIVER_SCANCODE;
-	props->allowed_protos = IR_TYPE_UNKNOWN;
+	/* IR_TYPE_OTHER maps to iMON PAD remote, IR_TYPE_RC6 to MCE remote */
+	props->allowed_protos = IR_TYPE_OTHER | IR_TYPE_RC6;
+	props->change_protocol = imon_ir_change_protocol;
+	ictx->props = props;
 
 	ictx->ir = ir;
 	memcpy(&ir->dev, ictx->dev, sizeof(struct device));
@@ -1738,7 +1714,7 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 
 	input_set_drvdata(idev, ir);
 
-	ret = ir_input_register(idev, ir_codes, props, MOD_NAME);
+	ret = ir_input_register(idev, RC_MAP_IMON_PAD, props, MOD_NAME);
 	if (ret < 0) {
 		dev_err(ictx->dev, "remote input dev register failed\n");
 		goto idev_register_failed;
@@ -2058,13 +2034,14 @@ rx_urb_alloc_failed:
  * is no actual data to report. However, byte 6 of this buffer looks like
  * its unique across device variants, so we're trying to key off that to
  * figure out which display type (if any) and what IR protocol the device
- * actually supports.
+ * actually supports. These devices have their IR protocol hard-coded into
+ * their firmware, they can't be changed on the fly like the newer hardware.
  */
 static void imon_get_ffdc_type(struct imon_context *ictx)
 {
 	u8 ffdc_cfg_byte = ictx->usb_rx_buf[6];
 	u8 detected_display_type = IMON_DISPLAY_TYPE_NONE;
-	u8 ir_proto_mask = IMON_IR_PROTO_MASK_IMON;
+	u64 allowed_protos = IR_TYPE_OTHER;
 
 	switch (ffdc_cfg_byte) {
 	/* iMON Knob, no display, iMON IR + vol knob */
@@ -2076,7 +2053,6 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 	case 0x35:
 		dev_info(ictx->dev, "0xffdc iMON VFD + knob, no IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-		ir_proto_mask = IMON_IR_PROTO_MASK_NONE;
 		break;
 	/* iMON VFD, iMON IR */
 	case 0x24:
@@ -2088,7 +2064,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 	case 0x9f:
 		dev_info(ictx->dev, "0xffdc iMON LCD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_LCD;
-		ir_proto_mask = IMON_IR_PROTO_MASK_MCE;
+		allowed_protos = IR_TYPE_RC6;
 		break;
 	default:
 		dev_info(ictx->dev, "Unknown 0xffdc device, "
@@ -2097,10 +2073,11 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 		break;
 	}
 
-	printk(" (id 0x%02x)\n", ffdc_cfg_byte);
+	printk(KERN_CONT " (id 0x%02x)\n", ffdc_cfg_byte);
 
 	ictx->display_type = detected_display_type;
-	ictx->ir_proto_mask = ir_proto_mask;
+	ictx->props->allowed_protos = allowed_protos;
+	ictx->ir_type = allowed_protos;
 }
 
 static void imon_set_display_type(struct imon_context *ictx,
@@ -2255,9 +2232,6 @@ static int __devinit imon_probe(struct usb_interface *interface,
 
 		if (product == 0xffdc)
 			imon_get_ffdc_type(ictx);
-		else
-			ictx->ir_proto_mask = IMON_IR_PROTO_MASK_MCE |
-					      IMON_IR_PROTO_MASK_IMON;
 
 		imon_set_display_type(ictx, interface);
 
@@ -2266,7 +2240,12 @@ static int __devinit imon_probe(struct usb_interface *interface,
 	}
 
 	/* set IR protocol/remote type */
-	imon_set_ir_protocol(ictx);
+	ret = imon_ir_change_protocol(ictx, ictx->ir_type);
+	if (ret) {
+		dev_warn(dev, "%s: failed to set IR protocol, falling back "
+			 "to standard iMON protocol mode\n", __func__);
+		ictx->ir_type = IR_TYPE_OTHER;
+	}
 
 	dev_info(dev, "iMON device (%04x:%04x, intf%d) on "
 		 "usb<%d:%d> initialized\n", vendor, product, ifnum,
@@ -2343,7 +2322,7 @@ static void __devexit imon_disconnect(struct usb_interface *interface)
 		if (!ictx->display_isopen)
 			free_imon_context(ictx);
 	} else {
-		if (ictx->ir_protocol == IMON_IR_PROTOCOL_MCE)
+		if (ictx->ir_type == IR_TYPE_RC6)
 			del_timer_sync(&ictx->itimer);
 		mutex_unlock(&ictx->lock);
 	}
diff --git a/drivers/media/IR/keymaps/rc-imon-mce.c b/drivers/media/IR/keymaps/rc-imon-mce.c
index 9c6dda3..e49f350 100644
--- a/drivers/media/IR/keymaps/rc-imon-mce.c
+++ b/drivers/media/IR/keymaps/rc-imon-mce.c
@@ -119,8 +119,8 @@ static struct rc_keymap imon_mce_map = {
 	.map = {
 		.scan    = imon_mce,
 		.size    = ARRAY_SIZE(imon_mce),
-		/* its actually RC6, but w/a hardware decoder */
-		.ir_type = IR_TYPE_UNKNOWN,
+		/* its RC6, but w/a hardware decoder */
+		.ir_type = IR_TYPE_RC6,
 		.name    = RC_MAP_IMON_MCE,
 	}
 };
diff --git a/drivers/media/IR/keymaps/rc-imon-pad.c b/drivers/media/IR/keymaps/rc-imon-pad.c
index 331ba90..bc4db72 100644
--- a/drivers/media/IR/keymaps/rc-imon-pad.c
+++ b/drivers/media/IR/keymaps/rc-imon-pad.c
@@ -133,7 +133,8 @@ static struct rc_keymap imon_pad_map = {
 	.map = {
 		.scan    = imon_pad,
 		.size    = ARRAY_SIZE(imon_pad),
-		.ir_type = IR_TYPE_UNKNOWN,
+		/* actual protocol details unknown, hardware decoder */
+		.ir_type = IR_TYPE_OTHER,
 		.name    = RC_MAP_IMON_PAD,
 	}
 };

-- 
Jarod Wilson
jarod@redhat.com

