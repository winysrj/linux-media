Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.uli-eckhardt.de ([85.214.28.137]:42512 "EHLO
	mail.uli-eckhardt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751919AbaGZR4E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 13:56:04 -0400
Message-ID: <53D3EBB1.7070001@uli-eckhardt.de>
Date: Sat, 26 Jul 2014 19:56:01 +0200
From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: jarod@wilsonet.com, linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] imon: Define keytables per USB Device Id
References: <53247996.7050303@uli-eckhardt.de> <20140723175537.0e9e5541.m.chehab@samsung.com> <53D3E991.9040006@uli-eckhardt.de>
In-Reply-To: <53D3E991.9040006@uli-eckhardt.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch defines the keytables per USB Device ID.

Signed-off-by: Ulrich Eckhardt <uli@uli-eckhardt.de>

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 6f24e77..81bdb98 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -87,6 +87,18 @@ static ssize_t lcd_write(struct file *file, const char *buf,
 
 /*** G L O B A L S ***/
 
+struct imon_panel_key_table {
+	u64 hw_code;
+	u32 keycode;
+};
+
+struct imon_usb_dev_descr {
+	__u16 flags;
+#define IMON_NO_FLAGS 0
+#define IMON_NEED_20MS_PKT_DELAY 1
+	struct imon_panel_key_table key_table[];
+};
+
 struct imon_context {
 	struct device *dev;
 	/* Newer devices have two interfaces */
@@ -150,6 +162,8 @@ struct imon_context {
 	struct timer_list ttimer;	/* touch screen timer */
 	int touch_x;			/* x coordinate on touchscreen */
 	int touch_y;			/* y coordinate on touchscreen */
+	struct imon_usb_dev_descr *dev_descr; /* device description with key
+						 table for front panels */
 };
 
 #define TOUCH_TIMEOUT	(HZ/30)
@@ -186,8 +200,111 @@ enum {
 	IMON_KEY_PANEL	= 2,
 };
 
-enum {
-	IMON_NEED_20MS_PKT_DELAY = 1
+static struct usb_class_driver imon_vfd_class = {
+	.name		= DEVICE_NAME,
+	.fops		= &vfd_fops,
+	.minor_base	= DISPLAY_MINOR_BASE,
+};
+
+static struct usb_class_driver imon_lcd_class = {
+	.name		= DEVICE_NAME,
+	.fops		= &lcd_fops,
+	.minor_base	= DISPLAY_MINOR_BASE,
+};
+
+/* imon receiver front panel/knob key table */
+static const struct imon_usb_dev_descr imon_default_table = {
+	.flags = IMON_NO_FLAGS,
+	.key_table = {
+		{ 0x000000000f00ffeell, KEY_MEDIA }, /* Go */
+		{ 0x000000001200ffeell, KEY_UP },
+		{ 0x000000001300ffeell, KEY_DOWN },
+		{ 0x000000001400ffeell, KEY_LEFT },
+		{ 0x000000001500ffeell, KEY_RIGHT },
+		{ 0x000000001600ffeell, KEY_ENTER },
+		{ 0x000000001700ffeell, KEY_ESC },
+		{ 0x000000001f00ffeell, KEY_AUDIO },
+		{ 0x000000002000ffeell, KEY_VIDEO },
+		{ 0x000000002100ffeell, KEY_CAMERA },
+		{ 0x000000002700ffeell, KEY_DVD },
+		{ 0x000000002300ffeell, KEY_TV },
+		{ 0x000000002b00ffeell, KEY_EXIT },
+		{ 0x000000002c00ffeell, KEY_SELECT },
+		{ 0x000000002d00ffeell, KEY_MENU },
+		{ 0x000000000500ffeell, KEY_PREVIOUS },
+		{ 0x000000000700ffeell, KEY_REWIND },
+		{ 0x000000000400ffeell, KEY_STOP },
+		{ 0x000000003c00ffeell, KEY_PLAYPAUSE },
+		{ 0x000000000800ffeell, KEY_FASTFORWARD },
+		{ 0x000000000600ffeell, KEY_NEXT },
+		{ 0x000000010000ffeell, KEY_RIGHT },
+		{ 0x000001000000ffeell, KEY_LEFT },
+		{ 0x000000003d00ffeell, KEY_SELECT },
+		{ 0x000100000000ffeell, KEY_VOLUMEUP },
+		{ 0x010000000000ffeell, KEY_VOLUMEDOWN },
+		{ 0x000000000100ffeell, KEY_MUTE },
+		/* 0xffdc iMON MCE VFD */
+		{ 0x00010000ffffffeell, KEY_VOLUMEUP },
+		{ 0x01000000ffffffeell, KEY_VOLUMEDOWN },
+		{ 0x00000001ffffffeell, KEY_MUTE },
+		{ 0x0000000fffffffeell, KEY_MEDIA },
+		{ 0x00000012ffffffeell, KEY_UP },
+		{ 0x00000013ffffffeell, KEY_DOWN },
+		{ 0x00000014ffffffeell, KEY_LEFT },
+		{ 0x00000015ffffffeell, KEY_RIGHT },
+		{ 0x00000016ffffffeell, KEY_ENTER },
+		{ 0x00000017ffffffeell, KEY_ESC },
+		/* iMON Knob values */
+		{ 0x000100ffffffffeell, KEY_VOLUMEUP },
+		{ 0x010000ffffffffeell, KEY_VOLUMEDOWN },
+		{ 0x000008ffffffffeell, KEY_MUTE },
+		{ 0, KEY_RESERVED },
+	}
+};
+
+static const struct imon_usb_dev_descr imon_OEM_VFD = {
+	.flags = IMON_NEED_20MS_PKT_DELAY,
+	.key_table = {
+		{ 0x000000000f00ffeell, KEY_MEDIA }, /* Go */
+		{ 0x000000001200ffeell, KEY_UP },
+		{ 0x000000001300ffeell, KEY_DOWN },
+		{ 0x000000001400ffeell, KEY_LEFT },
+		{ 0x000000001500ffeell, KEY_RIGHT },
+		{ 0x000000001600ffeell, KEY_ENTER },
+		{ 0x000000001700ffeell, KEY_ESC },
+		{ 0x000000001f00ffeell, KEY_AUDIO },
+		{ 0x000000002b00ffeell, KEY_EXIT },
+		{ 0x000000002c00ffeell, KEY_SELECT },
+		{ 0x000000002d00ffeell, KEY_MENU },
+		{ 0x000000000500ffeell, KEY_PREVIOUS },
+		{ 0x000000000700ffeell, KEY_REWIND },
+		{ 0x000000000400ffeell, KEY_STOP },
+		{ 0x000000003c00ffeell, KEY_PLAYPAUSE },
+		{ 0x000000000800ffeell, KEY_FASTFORWARD },
+		{ 0x000000000600ffeell, KEY_NEXT },
+		{ 0x000000010000ffeell, KEY_RIGHT },
+		{ 0x000001000000ffeell, KEY_LEFT },
+		{ 0x000000003d00ffeell, KEY_SELECT },
+		{ 0x000100000000ffeell, KEY_VOLUMEUP },
+		{ 0x010000000000ffeell, KEY_VOLUMEDOWN },
+		{ 0x000000000100ffeell, KEY_MUTE },
+		/* 0xffdc iMON MCE VFD */
+		{ 0x00010000ffffffeell, KEY_VOLUMEUP },
+		{ 0x01000000ffffffeell, KEY_VOLUMEDOWN },
+		{ 0x00000001ffffffeell, KEY_MUTE },
+		{ 0x0000000fffffffeell, KEY_MEDIA },
+		{ 0x00000012ffffffeell, KEY_UP },
+		{ 0x00000013ffffffeell, KEY_DOWN },
+		{ 0x00000014ffffffeell, KEY_LEFT },
+		{ 0x00000015ffffffeell, KEY_RIGHT },
+		{ 0x00000016ffffffeell, KEY_ENTER },
+		{ 0x00000017ffffffeell, KEY_ESC },
+		/* iMON Knob values */
+		{ 0x000100ffffffffeell, KEY_VOLUMEUP },
+		{ 0x010000ffffffffeell, KEY_VOLUMEDOWN },
+		{ 0x000008ffffffffeell, KEY_MUTE },
+		{ 0, KEY_RESERVED },
+	}
 };
 
 /*
@@ -208,7 +325,8 @@ static struct usb_device_id imon_usb_id_table[] = {
 	 * SoundGraph iMON PAD (IR & LCD)
 	 * SoundGraph iMON Knob (IR only)
 	 */
-	{ USB_DEVICE(0x15c2, 0xffdc) },
+	{ USB_DEVICE(0x15c2, 0xffdc),
+	  .driver_info = (unsigned long)&imon_default_table },
 
 	/*
 	 * Newer devices, all driven by the latest iMON Windows driver, full
@@ -216,43 +334,62 @@ static struct usb_device_id imon_usb_id_table[] = {
 	 * Need user input to fill in details on unknown devices.
 	 */
 	/* SoundGraph iMON OEM Touch LCD (IR & 7" VGA LCD) */
-	{ USB_DEVICE(0x15c2, 0x0034) },
+	{ USB_DEVICE(0x15c2, 0x0034),
+	  .driver_info = (unsigned long)&imon_default_table },
 	/* SoundGraph iMON OEM Touch LCD (IR & 4.3" VGA LCD) */
-	{ USB_DEVICE(0x15c2, 0x0035) },
+	{ USB_DEVICE(0x15c2, 0x0035),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* SoundGraph iMON OEM VFD (IR & VFD) */
-	{ USB_DEVICE(0x15c2, 0x0036), .driver_info = IMON_NEED_20MS_PKT_DELAY },
+	{ USB_DEVICE(0x15c2, 0x0036),
+	  .driver_info = (unsigned long)&imon_OEM_VFD },
 	/* device specifics unknown */
-	{ USB_DEVICE(0x15c2, 0x0037) },
+	{ USB_DEVICE(0x15c2, 0x0037),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* SoundGraph iMON OEM LCD (IR & LCD) */
-	{ USB_DEVICE(0x15c2, 0x0038) },
+	{ USB_DEVICE(0x15c2, 0x0038),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* SoundGraph iMON UltraBay (IR & LCD) */
-	{ USB_DEVICE(0x15c2, 0x0039) },
+	{ USB_DEVICE(0x15c2, 0x0039),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* device specifics unknown */
-	{ USB_DEVICE(0x15c2, 0x003a) },
+	{ USB_DEVICE(0x15c2, 0x003a),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* device specifics unknown */
-	{ USB_DEVICE(0x15c2, 0x003b) },
+	{ USB_DEVICE(0x15c2, 0x003b),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* SoundGraph iMON OEM Inside (IR only) */
-	{ USB_DEVICE(0x15c2, 0x003c) },
+	{ USB_DEVICE(0x15c2, 0x003c),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* device specifics unknown */
-	{ USB_DEVICE(0x15c2, 0x003d) },
+	{ USB_DEVICE(0x15c2, 0x003d),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* device specifics unknown */
-	{ USB_DEVICE(0x15c2, 0x003e) },
+	{ USB_DEVICE(0x15c2, 0x003e),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* device specifics unknown */
-	{ USB_DEVICE(0x15c2, 0x003f) },
+	{ USB_DEVICE(0x15c2, 0x003f),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* device specifics unknown */
-	{ USB_DEVICE(0x15c2, 0x0040) },
+	{ USB_DEVICE(0x15c2, 0x0040),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* SoundGraph iMON MINI (IR only) */
-	{ USB_DEVICE(0x15c2, 0x0041) },
+	{ USB_DEVICE(0x15c2, 0x0041),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* Antec Veris Multimedia Station EZ External (IR only) */
-	{ USB_DEVICE(0x15c2, 0x0042) },
+	{ USB_DEVICE(0x15c2, 0x0042),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* Antec Veris Multimedia Station Basic Internal (IR only) */
-	{ USB_DEVICE(0x15c2, 0x0043) },
+	{ USB_DEVICE(0x15c2, 0x0043),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* Antec Veris Multimedia Station Elite (IR & VFD) */
-	{ USB_DEVICE(0x15c2, 0x0044) },
+	{ USB_DEVICE(0x15c2, 0x0044),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* Antec Veris Multimedia Station Premiere (IR & LCD) */
-	{ USB_DEVICE(0x15c2, 0x0045) },
+	{ USB_DEVICE(0x15c2, 0x0045),
+	  .driver_info = (unsigned long)&imon_default_table},
 	/* device specifics unknown */
-	{ USB_DEVICE(0x15c2, 0x0046) },
+	{ USB_DEVICE(0x15c2, 0x0046),
+	  .driver_info = (unsigned long)&imon_default_table},
 	{}
 };
 
@@ -266,67 +403,6 @@ static struct usb_driver imon_driver = {
 	.id_table	= imon_usb_id_table,
 };
 
-static struct usb_class_driver imon_vfd_class = {
-	.name		= DEVICE_NAME,
-	.fops		= &vfd_fops,
-	.minor_base	= DISPLAY_MINOR_BASE,
-};
-
-static struct usb_class_driver imon_lcd_class = {
-	.name		= DEVICE_NAME,
-	.fops		= &lcd_fops,
-	.minor_base	= DISPLAY_MINOR_BASE,
-};
-
-/* imon receiver front panel/knob key table */
-static const struct {
-	u64 hw_code;
-	u32 keycode;
-} imon_panel_key_table[] = {
-	{ 0x000000000f00ffeell, KEY_MEDIA }, /* Go */
-	{ 0x000000001200ffeell, KEY_UP },
-	{ 0x000000001300ffeell, KEY_DOWN },
-	{ 0x000000001400ffeell, KEY_LEFT },
-	{ 0x000000001500ffeell, KEY_RIGHT },
-	{ 0x000000001600ffeell, KEY_ENTER },
-	{ 0x000000001700ffeell, KEY_ESC },
-	{ 0x000000001f00ffeell, KEY_AUDIO },
-	{ 0x000000002000ffeell, KEY_VIDEO },
-	{ 0x000000002100ffeell, KEY_CAMERA },
-	{ 0x000000002700ffeell, KEY_DVD },
-	{ 0x000000002300ffeell, KEY_TV },
-	{ 0x000000002b00ffeell, KEY_EXIT },
-	{ 0x000000002c00ffeell, KEY_SELECT },
-	{ 0x000000002d00ffeell, KEY_MENU },
-	{ 0x000000000500ffeell, KEY_PREVIOUS },
-	{ 0x000000000700ffeell, KEY_REWIND },
-	{ 0x000000000400ffeell, KEY_STOP },
-	{ 0x000000003c00ffeell, KEY_PLAYPAUSE },
-	{ 0x000000000800ffeell, KEY_FASTFORWARD },
-	{ 0x000000000600ffeell, KEY_NEXT },
-	{ 0x000000010000ffeell, KEY_RIGHT },
-	{ 0x000001000000ffeell, KEY_LEFT },
-	{ 0x000000003d00ffeell, KEY_SELECT },
-	{ 0x000100000000ffeell, KEY_VOLUMEUP },
-	{ 0x010000000000ffeell, KEY_VOLUMEDOWN },
-	{ 0x000000000100ffeell, KEY_MUTE },
-	/* 0xffdc iMON MCE VFD */
-	{ 0x00010000ffffffeell, KEY_VOLUMEUP },
-	{ 0x01000000ffffffeell, KEY_VOLUMEDOWN },
-	{ 0x00000001ffffffeell, KEY_MUTE },
-	{ 0x0000000fffffffeell, KEY_MEDIA },
-	{ 0x00000012ffffffeell, KEY_UP },
-	{ 0x00000013ffffffeell, KEY_DOWN },
-	{ 0x00000014ffffffeell, KEY_LEFT },
-	{ 0x00000015ffffffeell, KEY_RIGHT },
-	{ 0x00000016ffffffeell, KEY_ENTER },
-	{ 0x00000017ffffffeell, KEY_ESC },
-	/* iMON Knob values */
-	{ 0x000100ffffffffeell, KEY_VOLUMEUP },
-	{ 0x010000ffffffffeell, KEY_VOLUMEDOWN },
-	{ 0x000008ffffffffeell, KEY_MUTE },
-};
-
 /* to prevent races between open() and disconnect(), probing, etc */
 static DEFINE_MUTEX(driver_lock);
 
@@ -1210,18 +1286,19 @@ static u32 imon_mce_key_lookup(struct imon_context *ictx, u32 scancode)
 	return keycode;
 }
 
-static u32 imon_panel_key_lookup(u64 code)
+static u32 imon_panel_key_lookup(struct imon_context *ictx, u64 code)
 {
 	int i;
 	u32 keycode = KEY_RESERVED;
+	struct imon_panel_key_table *key_table = ictx->dev_descr->key_table;
 
-	for (i = 0; i < ARRAY_SIZE(imon_panel_key_table); i++) {
-		if (imon_panel_key_table[i].hw_code == (code | 0xffee)) {
-			keycode = imon_panel_key_table[i].keycode;
+	for (i = 0; key_table[i].hw_code != 0; i++) {
+		if (key_table[i].hw_code == (code | 0xffee)) {
+			keycode = key_table[i].keycode;
 			break;
 		}
 	}
-
+	ictx->release_code = false;
 	return keycode;
 }
 
@@ -1511,7 +1588,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	if (len == 8 && buf[7] == 0xee) {
 		scancode = be64_to_cpu(*((u64 *)buf));
 		ktype = IMON_KEY_PANEL;
-		kc = imon_panel_key_lookup(scancode);
+		kc = imon_panel_key_lookup(ictx, scancode);
 	} else {
 		scancode = be32_to_cpu(*((u32 *)buf));
 		if (ictx->rc_type == RC_BIT_RC6_MCE) {
@@ -1906,6 +1983,7 @@ out:
 
 static struct input_dev *imon_init_idev(struct imon_context *ictx)
 {
+	struct imon_panel_key_table *key_table = ictx->dev_descr->key_table;
 	struct input_dev *idev;
 	int ret, i;
 
@@ -1931,8 +2009,8 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 		BIT_MASK(REL_WHEEL);
 
 	/* panel and/or knob code support */
-	for (i = 0; i < ARRAY_SIZE(imon_panel_key_table); i++) {
-		u32 kc = imon_panel_key_table[i].keycode;
+	for (i = 0; key_table[i].hw_code != 0; i++) {
+		u32 kc = key_table[i].keycode;
 		__set_bit(kc, idev->keybit);
 	}
 
@@ -2133,9 +2211,11 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf,
 	ictx->vendor  = le16_to_cpu(ictx->usbdev_intf0->descriptor.idVendor);
 	ictx->product = le16_to_cpu(ictx->usbdev_intf0->descriptor.idProduct);
 
+	/* save drive info for later accessing the panel/knob key table */
+	ictx->dev_descr = (struct imon_usb_dev_descr *)id->driver_info;
 	/* default send_packet delay is 5ms but some devices need more */
-	ictx->send_packet_delay = id->driver_info & IMON_NEED_20MS_PKT_DELAY ?
-				  20 : 5;
+	ictx->send_packet_delay = ictx->dev_descr->flags &
+				  IMON_NEED_20MS_PKT_DELAY ? 20 : 5;
 
 	ret = -ENODEV;
 	iface_desc = intf->cur_altsetting;

-- 
Ulrich Eckhardt                  http://www.uli-eckhardt.de

Ein Blitzableiter auf dem Kirchturm ist das denkbar stärkste 
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)
