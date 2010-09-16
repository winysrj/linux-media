Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab0IPFZJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 01:25:09 -0400
Date: Thu, 16 Sep 2010 01:24:39 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Anders Eriksson <aeriksson@fastmail.fm>,
	Anssi Hannula <anssi.hannula@iki.fi>
Subject: [PATCH 4/4] IR/imon: set up mce-only devices w/mce keytable
Message-ID: <20100916052439.GE23299@redhat.com>
References: <20100916051932.GA23299@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916051932.GA23299@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From 321eb136b4c933a6a2e6583ccf110c22874c02fe Mon Sep 17 00:00:00 2001
From: Jarod Wilson <jarod@redhat.com>
Date: Tue, 14 Sep 2010 23:28:41 -0400
Subject: [PATCH 4/4] IR/imon: set up mce-only devices w/mce keytable

Currently, they get set up with the pad keytable, which they can't
actually use at all. Also add another variant of volume scancodes from
another 0xffdc device, and properly set up the 0x9e 0xffdc device as an
iMON VFD w/MCE proto IR.

Based on data and a prior patch from Anders Eriksson on the lirc list.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |  264 ++++++++++++++++++++++++----------------------
 1 files changed, 138 insertions(+), 126 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 4b73b8e..ef81d38 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -292,6 +292,9 @@ static const struct {
 	{ 0x000100000000ffeell, KEY_VOLUMEUP },
 	{ 0x010000000000ffeell, KEY_VOLUMEDOWN },
 	{ 0x000000000100ffeell, KEY_MUTE },
+	/* 0xffdc iMON MCE VFD */
+	{ 0x00010000ffffffeell, KEY_VOLUMEUP },
+	{ 0x01000000ffffffeell, KEY_VOLUMEDOWN },
 	/* iMON Knob values */
 	{ 0x000100ffffffffeell, KEY_VOLUMEUP },
 	{ 0x010000ffffffffeell, KEY_VOLUMEDOWN },
@@ -1701,11 +1704,128 @@ static void usb_rx_callback_intf1(struct urb *urb)
 	usb_submit_urb(ictx->rx_urb_intf1, GFP_ATOMIC);
 }
 
+/*
+ * The 0x15c2:0xffdc device ID was used for umpteen different imon
+ * devices, and all of them constantly spew interrupts, even when there
+ * is no actual data to report. However, byte 6 of this buffer looks like
+ * its unique across device variants, so we're trying to key off that to
+ * figure out which display type (if any) and what IR protocol the device
+ * actually supports. These devices have their IR protocol hard-coded into
+ * their firmware, they can't be changed on the fly like the newer hardware.
+ */
+static void imon_get_ffdc_type(struct imon_context *ictx)
+{
+	u8 ffdc_cfg_byte = ictx->usb_rx_buf[6];
+	u8 detected_display_type = IMON_DISPLAY_TYPE_NONE;
+	u64 allowed_protos = IR_TYPE_OTHER;
+
+	switch (ffdc_cfg_byte) {
+	/* iMON Knob, no display, iMON IR + vol knob */
+	case 0x21:
+		dev_info(ictx->dev, "0xffdc iMON Knob, iMON IR");
+		ictx->display_supported = false;
+		break;
+	/* iMON 2.4G LT (usb stick), no display, iMON RF */
+	case 0x4e:
+		dev_info(ictx->dev, "0xffdc iMON 2.4G LT, iMON RF");
+		ictx->display_supported = false;
+		ictx->rf_device = true;
+		break;
+	/* iMON VFD, no IR (does have vol knob tho) */
+	case 0x35:
+		dev_info(ictx->dev, "0xffdc iMON VFD + knob, no IR");
+		detected_display_type = IMON_DISPLAY_TYPE_VFD;
+		break;
+	/* iMON VFD, iMON IR */
+	case 0x24:
+	case 0x85:
+		dev_info(ictx->dev, "0xffdc iMON VFD, iMON IR");
+		detected_display_type = IMON_DISPLAY_TYPE_VFD;
+		break;
+	/* iMON LCD, MCE IR */
+	case 0x9e:
+		dev_info(ictx->dev, "0xffdc iMON VFD, MCE IR");
+		detected_display_type = IMON_DISPLAY_TYPE_VFD;
+		allowed_protos = IR_TYPE_RC6;
+		break;
+	/* iMON LCD, MCE IR */
+	case 0x9f:
+		dev_info(ictx->dev, "0xffdc iMON LCD, MCE IR");
+		detected_display_type = IMON_DISPLAY_TYPE_LCD;
+		allowed_protos = IR_TYPE_RC6;
+		break;
+	default:
+		dev_info(ictx->dev, "Unknown 0xffdc device, "
+			 "defaulting to VFD and iMON IR");
+		detected_display_type = IMON_DISPLAY_TYPE_VFD;
+		break;
+	}
+
+	printk(KERN_CONT " (id 0x%02x)\n", ffdc_cfg_byte);
+
+	ictx->display_type = detected_display_type;
+	ictx->props->allowed_protos = allowed_protos;
+	ictx->ir_type = allowed_protos;
+}
+
+static void imon_set_display_type(struct imon_context *ictx)
+{
+	u8 configured_display_type = IMON_DISPLAY_TYPE_VFD;
+
+	/*
+	 * Try to auto-detect the type of display if the user hasn't set
+	 * it by hand via the display_type modparam. Default is VFD.
+	 */
+
+	if (display_type == IMON_DISPLAY_TYPE_AUTO) {
+		switch (ictx->product) {
+		case 0xffdc:
+			/* set in imon_get_ffdc_type() */
+			configured_display_type = ictx->display_type;
+			break;
+		case 0x0034:
+		case 0x0035:
+			configured_display_type = IMON_DISPLAY_TYPE_VGA;
+			break;
+		case 0x0038:
+		case 0x0039:
+		case 0x0045:
+			configured_display_type = IMON_DISPLAY_TYPE_LCD;
+			break;
+		case 0x003c:
+		case 0x0041:
+		case 0x0042:
+		case 0x0043:
+			configured_display_type = IMON_DISPLAY_TYPE_NONE;
+			ictx->display_supported = false;
+			break;
+		case 0x0036:
+		case 0x0044:
+		default:
+			configured_display_type = IMON_DISPLAY_TYPE_VFD;
+			break;
+		}
+	} else {
+		configured_display_type = display_type;
+		if (display_type == IMON_DISPLAY_TYPE_NONE)
+			ictx->display_supported = false;
+		else
+			ictx->display_supported = true;
+		dev_info(ictx->dev, "%s: overriding display type to %d via "
+			 "modparam\n", __func__, display_type);
+	}
+
+	ictx->display_type = configured_display_type;
+}
+
 static struct input_dev *imon_init_rdev(struct imon_context *ictx)
 {
 	struct input_dev *rdev;
 	struct ir_dev_props *props;
 	int ret;
+	char *ir_codes = NULL;
+	const unsigned char fp_packet[] = { 0x40, 0x00, 0x00, 0x00,
+					    0x00, 0x00, 0x00, 0x88 };
 
 	rdev = input_allocate_device();
 	props = kzalloc(sizeof(*props), GFP_KERNEL);
@@ -1733,7 +1853,24 @@ static struct input_dev *imon_init_rdev(struct imon_context *ictx)
 	props->change_protocol = imon_ir_change_protocol;
 	ictx->props = props;
 
-	ret = ir_input_register(rdev, RC_MAP_IMON_PAD, props, MOD_NAME);
+	/* Enable front-panel buttons and/or knobs */
+	memcpy(ictx->usb_tx_buf, &fp_packet, sizeof(fp_packet));
+	ret = send_packet(ictx);
+	/* Not fatal, but warn about it */
+	if (ret)
+		dev_info(ictx->dev, "panel buttons/knobs setup failed\n");
+
+	if (ictx->product == 0xffdc)
+		imon_get_ffdc_type(ictx);
+
+	imon_set_display_type(ictx);
+
+	if (ictx->ir_type == IR_TYPE_RC6)
+		ir_codes = RC_MAP_IMON_MCE;
+	else
+		ir_codes = RC_MAP_IMON_PAD;
+
+	ret = ir_input_register(rdev, ir_codes, props, MOD_NAME);
 	if (ret < 0) {
 		dev_err(ictx->dev, "remote input dev register failed\n");
 		goto out;
@@ -2099,116 +2236,6 @@ rx_urb_alloc_failed:
 	return NULL;
 }
 
-/*
- * The 0x15c2:0xffdc device ID was used for umpteen different imon
- * devices, and all of them constantly spew interrupts, even when there
- * is no actual data to report. However, byte 6 of this buffer looks like
- * its unique across device variants, so we're trying to key off that to
- * figure out which display type (if any) and what IR protocol the device
- * actually supports. These devices have their IR protocol hard-coded into
- * their firmware, they can't be changed on the fly like the newer hardware.
- */
-static void imon_get_ffdc_type(struct imon_context *ictx)
-{
-	u8 ffdc_cfg_byte = ictx->usb_rx_buf[6];
-	u8 detected_display_type = IMON_DISPLAY_TYPE_NONE;
-	u64 allowed_protos = IR_TYPE_OTHER;
-
-	switch (ffdc_cfg_byte) {
-	/* iMON Knob, no display, iMON IR + vol knob */
-	case 0x21:
-		dev_info(ictx->dev, "0xffdc iMON Knob, iMON IR");
-		ictx->display_supported = false;
-		break;
-	/* iMON 2.4G LT (usb stick), no display, iMON RF */
-	case 0x4e:
-		dev_info(ictx->dev, "0xffdc iMON 2.4G LT, iMON RF");
-		ictx->display_supported = false;
-		ictx->rf_device = true;
-		break;
-	/* iMON VFD, no IR (does have vol knob tho) */
-	case 0x35:
-		dev_info(ictx->dev, "0xffdc iMON VFD + knob, no IR");
-		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-		break;
-	/* iMON VFD, iMON IR */
-	case 0x24:
-	case 0x85:
-		dev_info(ictx->dev, "0xffdc iMON VFD, iMON IR");
-		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-		break;
-	/* iMON LCD, MCE IR */
-	case 0x9e:
-	case 0x9f:
-		dev_info(ictx->dev, "0xffdc iMON LCD, MCE IR");
-		detected_display_type = IMON_DISPLAY_TYPE_LCD;
-		allowed_protos = IR_TYPE_RC6;
-		break;
-	default:
-		dev_info(ictx->dev, "Unknown 0xffdc device, "
-			 "defaulting to VFD and iMON IR");
-		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-		break;
-	}
-
-	printk(KERN_CONT " (id 0x%02x)\n", ffdc_cfg_byte);
-
-	ictx->display_type = detected_display_type;
-	ictx->props->allowed_protos = allowed_protos;
-	ictx->ir_type = allowed_protos;
-}
-
-static void imon_set_display_type(struct imon_context *ictx,
-				  struct usb_interface *intf)
-{
-	u8 configured_display_type = IMON_DISPLAY_TYPE_VFD;
-
-	/*
-	 * Try to auto-detect the type of display if the user hasn't set
-	 * it by hand via the display_type modparam. Default is VFD.
-	 */
-
-	if (display_type == IMON_DISPLAY_TYPE_AUTO) {
-		switch (ictx->product) {
-		case 0xffdc:
-			/* set in imon_get_ffdc_type() */
-			configured_display_type = ictx->display_type;
-			break;
-		case 0x0034:
-		case 0x0035:
-			configured_display_type = IMON_DISPLAY_TYPE_VGA;
-			break;
-		case 0x0038:
-		case 0x0039:
-		case 0x0045:
-			configured_display_type = IMON_DISPLAY_TYPE_LCD;
-			break;
-		case 0x003c:
-		case 0x0041:
-		case 0x0042:
-		case 0x0043:
-			configured_display_type = IMON_DISPLAY_TYPE_NONE;
-			ictx->display_supported = false;
-			break;
-		case 0x0036:
-		case 0x0044:
-		default:
-			configured_display_type = IMON_DISPLAY_TYPE_VFD;
-			break;
-		}
-	} else {
-		configured_display_type = display_type;
-		if (display_type == IMON_DISPLAY_TYPE_NONE)
-			ictx->display_supported = false;
-		else
-			ictx->display_supported = true;
-		dev_info(ictx->dev, "%s: overriding display type to %d via "
-			 "modparam\n", __func__, display_type);
-	}
-
-	ictx->display_type = configured_display_type;
-}
-
 static void imon_init_display(struct imon_context *ictx,
 			      struct usb_interface *intf)
 {
@@ -2249,8 +2276,6 @@ static int __devinit imon_probe(struct usb_interface *interface,
 	struct imon_context *ictx = NULL;
 	struct imon_context *first_if_ctx = NULL;
 	u16 vendor, product;
-	const unsigned char fp_packet[] = { 0x40, 0x00, 0x00, 0x00,
-					    0x00, 0x00, 0x00, 0x88 };
 
 	code_length = BUF_CHUNK_SIZE * 8;
 
@@ -2291,19 +2316,6 @@ static int __devinit imon_probe(struct usb_interface *interface,
 	usb_set_intfdata(interface, ictx);
 
 	if (ifnum == 0) {
-		/* Enable front-panel buttons and/or knobs */
-		memcpy(ictx->usb_tx_buf, &fp_packet, sizeof(fp_packet));
-		ret = send_packet(ictx);
-		/* Not fatal, but warn about it */
-		if (ret)
-			dev_info(dev, "failed to enable panel buttons "
-				 "and/or knobs\n");
-
-		if (product == 0xffdc)
-			imon_get_ffdc_type(ictx);
-
-		imon_set_display_type(ictx, interface);
-
 		if (product == 0xffdc && ictx->rf_device) {
 			sysfs_err = sysfs_create_group(&interface->dev.kobj,
 						       &imon_rf_attribute_group);
-- 
1.7.2.2


-- 
Jarod Wilson
jarod@redhat.com

