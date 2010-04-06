Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab0DFSSa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:30 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIUDr022721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:30 -0400
Date: Tue, 6 Apr 2010 15:18:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 24/26] V4L/DVB: ir-core: Add support for badly-implemented
 hardware decoders
Message-ID: <20100406151800.011a1482@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few hardware Remote Controller decoders, even using a standard protocol,
aren't able to provide the entire scancode. Due to that, the capability
of using other IR's are limited on those hardware.

Adds a way to indicate to ir-core what are the bits that the hardware
provides, from a scancode, allowing the addition of a complete IR table
to the kernel and allowing a limited support for changing the Remote
Controller on those devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 drivers/media/IR/keymaps/rc-pixelview-mk12.c

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 39d8fcb..f509be2 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -88,6 +88,18 @@ static int ir_do_setkeycode(struct input_dev *dev,
 {
 	unsigned int i;
 	int old_keycode = KEY_RESERVED;
+	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+
+	/*
+	 * Unfortunately, some hardware-based IR decoders don't provide
+	 * all bits for the complete IR code. In general, they provide only
+	 * the command part of the IR code. Yet, as it is possible to replace
+	 * the provided IR with another one, it is needed to allow loading
+	 * IR tables from other remotes. So,
+	 */
+	if (ir_dev->props && ir_dev->props->scanmask) {
+		scancode &= ir_dev->props->scanmask;
+	}
 
 	/* First check if we already have a mapping for this ir command */
 	for (i = 0; i < rc_tab->len; i++) {
@@ -447,6 +459,13 @@ int __ir_input_register(struct input_dev *input_dev,
 						  sizeof(struct ir_scancode));
 	ir_dev->rc_tab.scan = kmalloc(ir_dev->rc_tab.alloc, GFP_KERNEL);
 	ir_dev->rc_tab.size = ir_dev->rc_tab.alloc / sizeof(struct ir_scancode);
+	if (props) {
+		ir_dev->props = props;
+		if (props->open)
+			input_dev->open = ir_open;
+		if (props->close)
+			input_dev->close = ir_close;
+	}
 
 	if (!ir_dev->rc_tab.scan) {
 		rc = -ENOMEM;
@@ -464,12 +483,6 @@ int __ir_input_register(struct input_dev *input_dev,
 		goto out_table;
 	}
 
-	ir_dev->props = props;
-	if (props && props->open)
-		input_dev->open = ir_open;
-	if (props && props->close)
-		input_dev->close = ir_close;
-
 	rc = ir_register_class(input_dev);
 	if (rc < 0)
 		goto out_table;
diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
index 937b7db..c4d891d 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-pinnacle-grey.o \
 			rc-pinnacle-pctv-hd.o \
 			rc-pixelview.o \
+			rc-pixelview-mk12.o \
 			rc-pixelview-new.o \
 			rc-powercolor-real-angel.o \
 			rc-proteus-2309.o \
diff --git a/drivers/media/IR/keymaps/rc-pixelview-mk12.c b/drivers/media/IR/keymaps/rc-pixelview-mk12.c
new file mode 100644
index 0000000..5a735d5
--- /dev/null
+++ b/drivers/media/IR/keymaps/rc-pixelview-mk12.c
@@ -0,0 +1,83 @@
+/* rc-pixelview-mk12.h - Keytable for pixelview Remote Controller
+ *
+ * keymap imported from ir-keymaps.c
+ *
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+/*
+ * Keytable for MK-F12 IR remote provided together with Pixelview
+ * Ultra Pro Remote Controller. Uses NEC extended format.
+ */
+static struct ir_scancode pixelview_mk12[] = {
+	{ 0x866b03, KEY_TUNER },	/* Timeshift */
+	{ 0x866b1e, KEY_POWER2 },	/* power */
+
+	{ 0x866b01, KEY_1 },
+	{ 0x866b0b, KEY_2 },
+	{ 0x866b1b, KEY_3 },
+	{ 0x866b05, KEY_4 },
+	{ 0x866b09, KEY_5 },
+	{ 0x866b15, KEY_6 },
+	{ 0x866b06, KEY_7 },
+	{ 0x866b0a, KEY_8 },
+	{ 0x866b12, KEY_9 },
+	{ 0x866b02, KEY_0 },
+
+	{ 0x866b13, KEY_AGAIN },	/* loop */
+	{ 0x866b10, KEY_DIGITS },	/* +100 */
+
+	{ 0x866b00, KEY_MEDIA },	/* source */
+	{ 0x866b18, KEY_MUTE },		/* mute */
+	{ 0x866b19, KEY_CAMERA },	/* snapshot */
+	{ 0x866b1a, KEY_SEARCH },	/* scan */
+
+	{ 0x866b16, KEY_CHANNELUP },	/* chn + */
+	{ 0x866b14, KEY_CHANNELDOWN },	/* chn - */
+	{ 0x866b1f, KEY_VOLUMEUP },	/* vol + */
+	{ 0x866b17, KEY_VOLUMEDOWN },	/* vol - */
+	{ 0x866b1c, KEY_ZOOM },		/* zoom */
+
+	{ 0x866b04, KEY_REWIND },
+	{ 0x866b0e, KEY_RECORD },
+	{ 0x866b0c, KEY_FORWARD },
+
+	{ 0x866b1d, KEY_STOP },
+	{ 0x866b08, KEY_PLAY },
+	{ 0x866b0f, KEY_PAUSE },
+
+	{ 0x866b0d, KEY_TV },
+	{ 0x866b07, KEY_RADIO },	/* FM */
+};
+
+static struct rc_keymap pixelview_map = {
+	.map = {
+		.scan    = pixelview_mk12,
+		.size    = ARRAY_SIZE(pixelview_mk12),
+		.ir_type = IR_TYPE_NEC,
+		.name    = RC_MAP_PIXELVIEW_MK12,
+	}
+};
+
+static int __init init_rc_map_pixelview(void)
+{
+	return ir_register_map(&pixelview_map);
+}
+
+static void __exit exit_rc_map_pixelview(void)
+{
+	ir_unregister_map(&pixelview_map);
+}
+
+module_init(init_rc_map_pixelview)
+module_exit(exit_rc_map_pixelview)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 9dbec1c..5e60b48 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -247,6 +247,9 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	char *ir_codes = NULL;
 	u64 ir_type = IR_TYPE_OTHER;
 	int err = -ENOMEM;
+	u32 hardware_mask = 0;	/* For devices with a hardware mask, when
+				 * used with a full-code IR table
+				 */
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	input_dev = input_allocate_device();
@@ -313,11 +316,18 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_PROLINK_PLAYTVPVR:
 	case CX88_BOARD_PIXELVIEW_PLAYTV_ULTRA_PRO:
-		ir_codes = RC_MAP_PIXELVIEW;
+		/*
+		 * It seems that this hardware is paired with NEC extended
+		 * address 0x866b. So, unfortunately, its usage with other
+		 * IR's with different address won't work. Still, there are
+		 * other IR's from the same manufacturer that works, like the
+		 * 002-T mini RC, provided with newer PV hardware
+		 */
+		ir_codes = RC_MAP_PIXELVIEW_MK12;
 		ir->gpio_addr = MO_GP1_IO;
-		ir->mask_keycode = 0x1f;	/* Only command is retrieved */
 		ir->mask_keyup = 0x80;
 		ir->polling = 10; /* ms */
+		hardware_mask = 0x3f;	/* Hardware returns only 6 bits from command part */
 		break;
 	case CX88_BOARD_PROLINK_PV_8000GT:
 	case CX88_BOARD_PROLINK_PV_GLOBAL_XTREME:
@@ -409,6 +419,21 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		goto err_out_free;
 	}
 
+	/*
+	 * The usage of mask_keycode were very convenient, due to several
+	 * reasons. Among others, the scancode tables were using the scancode
+	 * as the index elements. So, the less bits it was used, the smaller
+	 * the table were stored. After the input changes, the better is to use
+	 * the full scancodes, since it allows replacing the IR remote by
+	 * another one. Unfortunately, there are still some hardware, like
+	 * Pixelview Ultra Pro, where only part of the scancode is sent via
+	 * GPIO. So, there's no way to get the full scancode. Due to that,
+	 * hardware_mask were introduced here: it represents those hardware
+	 * that has such limits.
+	 */
+	if (hardware_mask && !ir->mask_keycode)
+		ir->mask_keycode = hardware_mask;
+
 	/* init input device */
 	snprintf(ir->name, sizeof(ir->name), "cx88 IR (%s)", core->board.name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(pci));
@@ -436,6 +461,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	ir->props.priv = core;
 	ir->props.open = cx88_ir_open;
 	ir->props.close = cx88_ir_close;
+	ir->props.scanmask = hardware_mask;
 
 	/* all done */
 	err = ir_input_register(ir->input, ir_codes, &ir->props, MODULE_NAME);
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 0f64b48..4397ea3 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -33,12 +33,28 @@ enum raw_event_type {
 	IR_STOP_EVENT	= (1 << 3),
 };
 
+/**
+ * struct ir_dev_props - Allow caller drivers to set special properties
+ * @allowed_protos: bitmask with the supported IR_TYPE_* protocols
+ * @scanmask: some hardware decoders are not capable of providing the full
+ *	scancode to the application. As this is a hardware limit, we can't do
+ *	anything with it. Yet, as the same keycode table can be used with other
+ *	devices, a mask is provided to allow its usage. Drivers should generally
+ *	leave this field in blank
+ * @priv: driver-specific data, to be used on the callbacks
+ * @change_protocol: allow changing the protocol used on hardware decoders
+ * @open: callback to allow drivers to enable polling/irq when IR input device
+ *	is opened.
+ * @close: callback to allow drivers to disable polling/irq when IR input device
+ *	is opened.
+ */
 struct ir_dev_props {
-	unsigned long allowed_protos;
+	unsigned long	allowed_protos;
+	u32		scanmask;
 	void 		*priv;
-	int (*change_protocol)(void *priv, u64 ir_type);
-	int (*open)(void *priv);
-	void (*close)(void *priv);
+	int		(*change_protocol)(void *priv, u64 ir_type);
+	int		(*open)(void *priv);
+	void		(*close)(void *priv);
 };
 
 struct ir_raw_event {
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index b10990d..3b7fe5a 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -18,7 +18,7 @@
 #define IR_TYPE_OTHER	(1u << 31)
 
 struct ir_scancode {
-	u16	scancode;
+	u32	scancode;
 	u32	keycode;
 };
 
@@ -95,6 +95,7 @@ void rc_map_init(void);
 #define RC_MAP_PINNACLE_PCTV_HD          "rc-pinnacle-pctv-hd"
 #define RC_MAP_PIXELVIEW_NEW             "rc-pixelview-new"
 #define RC_MAP_PIXELVIEW                 "rc-pixelview"
+#define RC_MAP_PIXELVIEW_MK12            "rc-pixelview-mk12"
 #define RC_MAP_POWERCOLOR_REAL_ANGEL     "rc-powercolor-real-angel"
 #define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
 #define RC_MAP_PURPLETV                  "rc-purpletv"
-- 
1.6.6.1


