Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:12547 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbZKMIsT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 03:48:19 -0500
Received: by qw-out-2122.google.com with SMTP id 3so619560qwe.37
        for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 00:48:24 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 13 Nov 2009 09:48:24 +0100
Message-ID: <156a113e0911130048p67ddbabfv263293de9f7f04d9@mail.gmail.com>
Subject: [PATCH] em28xx: fix for "Leadtek winfast tv usbii deluxe"
From: Magnus Alm <magnus.alm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx: fix for "Leadtek winfast tv usbii deluxe"

From: Magnus Alm <magnus.alm@gmail.com>

This patch adds working:
Video and Sound for Television, Svideo and Composite.
Radio.
Stereo.
Also ir-remote for kernel 2.6.30 and higher.

Priority: high

diff -r 19c0469c02c3 linux/drivers/media/common/ir-keymaps.c
--- a/linux/drivers/media/common/ir-keymaps.c	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/drivers/media/common/ir-keymaps.c	Fri Nov 13 09:40:40 2009 +0100
@@ -3303,3 +3303,51 @@
 	.size = ARRAY_SIZE(ir_codes_gadmei_rm008z),
 };
 EXPORT_SYMBOL_GPL(ir_codes_gadmei_rm008z_table);
+
+/* Leadtek Winfast TV USB II Deluxe remote
+   Magnus Alm <magnus.alm@gmail.com>
+ */
+static struct ir_scancode ir_codes_winfast_usbii_deluxe[] = {
+	{ 0x62, KEY_0},
+	{ 0x75, KEY_1},
+	{ 0x76, KEY_2},
+	{ 0x77, KEY_3},
+	{ 0x79, KEY_4},
+	{ 0x7a, KEY_5},
+	{ 0x7b, KEY_6},
+	{ 0x7d, KEY_7},
+	{ 0x7e, KEY_8},
+	{ 0x7f, KEY_9},
+
+	{ 0x38, KEY_CAMERA},		/* SNAPSHOT */
+	{ 0x37, KEY_RECORD},		/* RECORD */
+	{ 0x35, KEY_TIME},		/* TIMESHIFT */
+
+	{ 0x74, KEY_VOLUMEUP},		/* VOLUMEUP */
+	{ 0x78, KEY_VOLUMEDOWN},	/* VOLUMEDOWN */
+	{ 0x64, KEY_MUTE},		/* MUTE */
+
+	{ 0x21, KEY_CHANNEL},		/* SURF */
+	{ 0x7c, KEY_CHANNELUP},		/* CHANNELUP */
+	{ 0x60, KEY_CHANNELDOWN},	/* CHANNELDOWN */
+	{ 0x61, KEY_LAST},		/* LAST CHANNEL (RECALL) */
+
+	{ 0x72, KEY_VIDEO}, 		/* INPUT MODES (TV/FM) */
+
+	{ 0x70, KEY_POWER2},		/* TV ON/OFF */
+
+	{ 0x39, KEY_CYCLEWINDOWS},	/* MINIMIZE (BOSS) */
+	{ 0x3a, KEY_NEW},		/* PIP */
+	{ 0x73, KEY_ZOOM},		/* FULLSECREEN */
+
+	{ 0x66, KEY_INFO},		/* OSD (DISPLAY) */	
+
+	{ 0x31, KEY_DOT},		/* '.' */
+	{ 0x63, KEY_ENTER},		/* ENTER */
+
+};
+struct ir_scancode_table ir_codes_winfast_usbii_deluxe_table = {
+	.scan = ir_codes_winfast_usbii_deluxe,
+	.size = ARRAY_SIZE(ir_codes_winfast_usbii_deluxe),
+};
+EXPORT_SYMBOL_GPL(ir_codes_winfast_usbii_deluxe_table);
diff -r 19c0469c02c3 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Nov 07
15:51:01 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Fri Nov 13
09:40:40 2009 +0100
@@ -466,21 +466,30 @@
 		.name         = "Leadtek Winfast USB II Deluxe",
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_PHILIPS_FM1216ME_MK3,
-		.tda9887_conf = TDA9887_PRESENT,
+		.has_ir_i2c   = 1,
+		.tvaudio_addr = 0x58,
+		.tda9887_conf = TDA9887_PRESENT |
+				TDA9887_PORT2_ACTIVE |
+				TDA9887_QSS,
 		.decoder      = EM28XX_SAA711X,
+		.adecoder     = EM28XX_TVAUDIO,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
-			.vmux     = SAA7115_COMPOSITE2,
-			.amux     = EM28XX_AMUX_VIDEO,
+			.vmux     = SAA7115_COMPOSITE4,
+			.amux     = EM28XX_AMUX_AUX,
 		}, {
 			.type     = EM28XX_VMUX_COMPOSITE1,
-			.vmux     = SAA7115_COMPOSITE0,
+			.vmux     = SAA7115_COMPOSITE5,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
-			.vmux     = SAA7115_COMPOSITE0,
+			.vmux     = SAA7115_SVIDEO3,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
+			.radio	  = {
+			.type     = EM28XX_RADIO,
+			.amux     = EM28XX_AMUX_AUX,
+			}
 	},
 	[EM2820_BOARD_VIDEOLOGY_20K14XUSB] = {
 		.name         = "Videology 20K14XUSB USB2.0",
@@ -2309,9 +2318,12 @@
 		return;
 	}
 #else
+	/* Leadtek winfast tv USBII deluxe can find a non working IR-device */
+	/* at address 0x18, so if that address is needed for another board in */
+	/* the future, please put it after 0x1f. */
 	struct i2c_board_info info;
 	const unsigned short addr_list[] = {
-		 0x30, 0x47, I2C_CLIENT_END
+		 0x1f, 0x30, 0x47, I2C_CLIENT_END	
 	};

 	if (disable_ir)
@@ -2361,6 +2373,18 @@
 		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
 #endif
 		break;
+	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+		ir->ir_codes = &ir_codes_winfast_usbii_deluxe_table;;			
+		ir->get_key = em28xx_get_key_winfast_usbii_deluxe;			
+		snprintf(ir->name, sizeof(ir->name),			
+			"i2c IR (EM2820 Winfast TV USBII Deluxe)");
+#else
+		dev->init_data.ir_codes = &ir_codes_winfast_usbii_deluxe_table;;		
+		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;		
+		dev->init_data.name = "i2c IR (EM2820 Winfast TV USBII Deluxe)";
+#endif
+		break;
 	}
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)

diff -r 19c0469c02c3 linux/drivers/media/video/em28xx/em28xx-input.c
--- a/linux/drivers/media/video/em28xx/em28xx-input.c	Sat Nov 07
15:51:01 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-input.c	Fri Nov 13
09:40:40 2009 +0100
@@ -180,6 +180,52 @@
 	return 1;
 }

+int em28xx_get_key_winfast_usbii_deluxe(struct IR_i2c *ir, u32
*ir_key, u32 *ir_raw)
+{
+	unsigned char subaddr, keydetect, key;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+	struct i2c_msg msg[] = { { .addr = ir->c.addr, .flags = 0, .buf =
&subaddr, .len = 1},
+#else
+	struct i2c_msg msg[] = { { .addr = ir->c->addr, .flags = 0, .buf =
&subaddr, .len = 1},
+#endif
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+				{ .addr = ir->c.addr, .flags = I2C_M_RD, .buf = &keydetect, .len = 1} };
+#else
+				{ .addr = ir->c->addr, .flags = I2C_M_RD, .buf = &keydetect, .len = 1} };
+#endif
+
+	subaddr = 0x10;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+	if (2 != i2c_transfer(ir->c.adapter, msg, 2)) {
+#else
+	if (2 != i2c_transfer(ir->c->adapter, msg, 2)) {
+#endif
+		i2cdprintk("read error\n");
+		return -EIO;
+	}
+	if (keydetect == 0x00)
+		return 0;
+
+	subaddr = 0x00;
+	msg[1].buf = &key;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+	if (2 != i2c_transfer(ir->c.adapter, msg, 2)) {
+#else
+	if (2 != i2c_transfer(ir->c->adapter, msg, 2)) {
+#endif
+		i2cdprintk("read error\n");
+	return -EIO;
+	}
+	if (key == 0x00)
+		return 0;
+
+	*ir_key = key;
+	*ir_raw = key;
+	return 1;
+}
+
 /**********************************************************
  Poll based get keycode functions
  **********************************************************/
diff -r 19c0469c02c3 linux/drivers/media/video/em28xx/em28xx.h
--- a/linux/drivers/media/video/em28xx/em28xx.h	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx.h	Fri Nov 13 09:40:40 2009 +0100
@@ -704,6 +704,8 @@
 int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw);
 int em28xx_get_key_pinnacle_usb_grey(struct IR_i2c *ir, u32 *ir_key,
 				     u32 *ir_raw);
+int em28xx_get_key_winfast_usbii_deluxe(struct IR_i2c *ir, u32 *ir_key,
+				     u32 *ir_raw);
 void em28xx_register_snapshot_button(struct em28xx *dev);
 void em28xx_deregister_snapshot_button(struct em28xx *dev);

diff -r 19c0469c02c3 linux/drivers/media/video/ir-kbd-i2c.c
--- a/linux/drivers/media/video/ir-kbd-i2c.c	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/drivers/media/video/ir-kbd-i2c.c	Fri Nov 13 09:40:40 2009 +0100
@@ -415,6 +415,7 @@
 		ir_codes    = &ir_codes_pv951_table;
 		break;
 	case 0x18:
+	case 0x1f:
 	case 0x1a:
 		name        = "Hauppauge";
 		ir->get_key = get_key_haup;
diff -r 19c0469c02c3 linux/include/media/ir-common.h
--- a/linux/include/media/ir-common.h	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/include/media/ir-common.h	Fri Nov 13 09:40:40 2009 +0100
@@ -179,4 +179,5 @@
 extern struct ir_scancode_table ir_codes_terratec_cinergy_xs_table;
 extern struct ir_scancode_table ir_codes_videomate_s350_table;
 extern struct ir_scancode_table ir_codes_gadmei_rm008z_table;
+extern struct ir_scancode_table ir_codes_winfast_usbii_deluxe_table;
 #endif
