Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaG1SH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 14:07:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/4] au0828: add support for IR on HVR-950Q
Date: Mon, 28 Jul 2014 15:07:21 -0300
Message-Id: <1406570842-26316-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406570842-26316-1-git-send-email-m.chehab@samsung.com>
References: <1406570842-26316-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HVR-950Q uses an I2C remote controller at address 0x47 (7-bits
notation). Add support for it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/Kconfig        |   7 +
 drivers/media/usb/au0828/Makefile       |   4 +
 drivers/media/usb/au0828/au0828-cards.c |   1 +
 drivers/media/usb/au0828/au0828-core.c  |  25 +-
 drivers/media/usb/au0828/au0828-input.c | 391 ++++++++++++++++++++++++++++++++
 drivers/media/usb/au0828/au0828.h       |  11 +
 6 files changed, 435 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/usb/au0828/au0828-input.c

diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
index fe48403eadd0..1d410ac8f9a8 100644
--- a/drivers/media/usb/au0828/Kconfig
+++ b/drivers/media/usb/au0828/Kconfig
@@ -27,3 +27,10 @@ config VIDEO_AU0828_V4L2
 
 	  Choose Y here to include support for v4l2 analog video
 	  capture within the au0828 driver.
+
+config VIDEO_AU0828_RC
+	bool "AU0828 Remote Controller support"
+	depends on RC_CORE
+	depends on VIDEO_AU0828
+	---help---
+	   Enables Remote Controller support on au0828 driver.
diff --git a/drivers/media/usb/au0828/Makefile b/drivers/media/usb/au0828/Makefile
index be3bdf698022..3dc7539a5c4e 100644
--- a/drivers/media/usb/au0828/Makefile
+++ b/drivers/media/usb/au0828/Makefile
@@ -4,6 +4,10 @@ ifeq ($(CONFIG_VIDEO_AU0828_V4L2),y)
   au0828-objs   += au0828-video.o au0828-vbi.o
 endif
 
+ifeq ($(CONFIG_VIDEO_AU0828_RC),y)
+  au0828-objs   += au0828-input.o
+endif
+
 obj-$(CONFIG_VIDEO_AU0828) += au0828.o
 
 ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index 3a7924044a87..2c6b7da137ed 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -71,6 +71,7 @@ struct au0828_board au0828_boards[] = {
 		.name	= "Hauppauge HVR950Q",
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
+		.has_ir_i2c = 1,
 		/* The au0828 hardware i2c implementation does not properly
 		   support the xc5000's i2c clock stretching.  So we need to
 		   lower the clock frequency enough where the 15us clock
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index ab45a6f9dcc9..56025e689442 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -32,10 +32,12 @@
  * 2 = USB handling
  * 4 = I2C related
  * 8 = Bridge related
+ * 16 = IR related
  */
 int au0828_debug;
 module_param_named(debug, au0828_debug, int, 0644);
-MODULE_PARM_DESC(debug, "enable debug messages");
+MODULE_PARM_DESC(debug,
+		 "set debug bitmask: 1=general, 2=USB, 4=I2C, 8=bridge, 16=IR");
 
 static unsigned int disable_usb_speed_check;
 module_param(disable_usb_speed_check, int, 0444);
@@ -151,6 +153,9 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 
 	dprintk(1, "%s()\n", __func__);
 
+#ifdef CONFIG_VIDEO_AU0828_RC
+	au0828_rc_unregister(dev);
+#endif
 	/* Digital TV */
 	au0828_dvb_unregister(dev);
 
@@ -261,9 +266,15 @@ static int au0828_usb_probe(struct usb_interface *interface,
 		pr_err("%s() au0282_dev_register failed\n",
 		       __func__);
 
+#ifdef CONFIG_VIDEO_AU0828_RC
+	/* Remote controller */
+	au0828_rc_register(dev);
+#endif
 
-	/* Store the pointer to the au0828_dev so it can be accessed in
-	   au0828_usb_disconnect */
+	/*
+	 * Store the pointer to the au0828_dev so it can be accessed in
+	 * au0828_usb_disconnect
+	 */
 	usb_set_intfdata(interface, dev);
 
 	printk(KERN_INFO "Registered device AU0828 [%s]\n",
@@ -279,6 +290,8 @@ static struct usb_driver au0828_usb_driver = {
 	.probe		= au0828_usb_probe,
 	.disconnect	= au0828_usb_disconnect,
 	.id_table	= au0828_usb_id_table,
+
+	/* FIXME: Add suspend and resume functions */
 };
 
 static int __init au0828_init(void)
@@ -298,6 +311,10 @@ static int __init au0828_init(void)
 		printk(KERN_INFO "%s() Bridge Debugging is enabled\n",
 		       __func__);
 
+	if (au0828_debug & 16)
+		printk(KERN_INFO "%s() IR Debugging is enabled\n",
+		       __func__);
+
 	printk(KERN_INFO "au0828 driver loaded\n");
 
 	ret = usb_register(&au0828_usb_driver);
@@ -318,4 +335,4 @@ module_exit(au0828_exit);
 MODULE_DESCRIPTION("Driver for Auvitek AU0828 based products");
 MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.2");
+MODULE_VERSION("0.0.3");
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
new file mode 100644
index 000000000000..d527446d008f
--- /dev/null
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -0,0 +1,391 @@
+/*
+  handle au0828 IR remotes via linux kernel input layer.
+
+   Copyright (C) 2014 Mauro Carvalho Chehab <mchehab@samsung.com>
+   Copyright (c) 2014 Samsung Electronics Co., Ltd.
+
+  Based on em28xx-input.c.
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/usb.h>
+#include <linux/slab.h>
+#include <media/rc-core.h>
+
+#include "au0828.h"
+
+struct au0828_rc {
+	struct au0828_dev *dev;
+	struct rc_dev *rc;
+	char name[32];
+	char phys[32];
+
+	/* poll decoder */
+	int polling;
+	struct delayed_work work;
+
+	/* i2c slave address of external device (if used) */
+	u16 i2c_dev_addr;
+
+	int  (*get_key_i2c)(struct au0828_rc *ir);
+};
+
+/*
+ * AU8522 has a builtin IR receiver. Add functions to get IR from it
+ */
+
+static int au8522_rc_write(struct au0828_rc *ir, u16 reg, u8 data)
+{
+	int rc;
+	char buf[] = { (reg >> 8) | 0x80, reg & 0xff, data };
+	struct i2c_msg msg = { .addr = ir->i2c_dev_addr, .flags = 0,
+			       .buf = buf, .len = sizeof(buf) };
+
+	rc = i2c_transfer(ir->dev->i2c_client.adapter, &msg, 1);
+
+	if (rc < 0)
+		return rc;
+
+	return (rc == 1) ? 0 : -EIO;
+}
+
+static int au8522_rc_read(struct au0828_rc *ir, u16 reg, int val,
+				 char *buf, int size)
+{
+	int rc;
+	char obuf[3];
+	struct i2c_msg msg[2] = { { .addr = ir->i2c_dev_addr, .flags = 0,
+				    .buf = obuf, .len = 2 },
+				  { .addr = ir->i2c_dev_addr, .flags = I2C_M_RD,
+				    .buf = buf, .len = size } };
+
+	obuf[0] = 0x40 | reg >> 8;
+	obuf[1] = reg & 0xff;
+	if (val >= 0) {
+		obuf[2] = val;
+		msg[0].len++;
+	}
+
+	rc = i2c_transfer(ir->dev->i2c_client.adapter, msg, 2);
+
+	if (rc < 0)
+		return rc;
+
+	return (rc == 2) ? 0 : -EIO;
+}
+
+static int au8522_rc_andor(struct au0828_rc *ir, u16 reg, u8 mask, u8 value)
+{
+	int rc;
+	char buf;
+
+	rc = au8522_rc_read(ir, reg, -1, &buf, 1);
+	if (rc < 0)
+		return rc;
+
+	buf = (buf & ~mask) | (value & mask);
+
+	return au8522_rc_write(ir, reg, buf);
+}
+
+#define au8522_rc_set(ir, reg, bit) au8522_rc_andor(ir, (reg), (bit), (bit))
+#define au8522_rc_clear(ir, reg, bit) au8522_rc_andor(ir, (reg), (bit), 0)
+
+/* Remote Controller time units*/
+
+//#define AU8522_UNIT		222222 /* ns */
+#define AU8522_UNIT		200000 /* ns */
+#define NEC_START_SPACE		(4500000 / AU8522_UNIT)
+#define NEC_START_PULSE		(562500 * 16)
+#define RC5_START_SPACE		(4 * AU8522_UNIT)
+#define RC5_START_PULSE		888888
+
+static int au0828_get_key_au8522(struct au0828_rc *ir)
+{
+	unsigned char buf[40];
+	DEFINE_IR_RAW_EVENT(rawir);
+	int i, j, rc;
+	int prv_bit, bit, width;
+	bool first = true;
+
+	/* Check IR int */
+	rc = au8522_rc_read(ir, 0xe1, -1, buf, 1);
+	if (rc < 0 || !(buf[0] & (1 << 4)))
+		return 0;
+
+	/* Something arrived. Get the data */
+	rc = au8522_rc_read(ir, 0xe3, 0x11, buf, sizeof(buf));
+
+
+	if (rc < 0)
+		return rc;
+
+	/* Disable IR */
+	au8522_rc_clear(ir, 0xe0, 1 << 4);
+
+	usleep_range(45000, 46000);
+
+	/* Enable IR */
+	au8522_rc_set(ir, 0xe0, 1 << 4);
+
+	dprintk(16, "RC data received: %*ph\n", 40, buf);
+
+	prv_bit = (buf[0] >> 7) & 0x01;
+	width = 0;
+	for (i = 0; i < sizeof(buf); i++) {
+		for (j = 7; j >= 0; j--) {
+			bit = (buf[i] >> j) & 0x01;
+			if (bit == prv_bit) {
+				width++;
+				continue;
+			}
+
+			/*
+			 * Fix an au8522 bug: the first pulse event
+			 * is lost. So, we need to fake it, based on the
+			 * protocol. That means that not all raw decoders
+			 * will work, as we need to add a hack for each
+			 * protocol, based on the first space.
+			 * So, we only support RC5 and NEC.
+			 */
+
+			if (first) {
+				first = false;
+
+				init_ir_raw_event(&rawir);
+				rawir.pulse = true;
+				if (width > NEC_START_SPACE - 2 &&
+				    width < NEC_START_SPACE + 2) {
+					/* NEC protocol */
+					rawir.duration = NEC_START_PULSE;
+					dprintk(16, "Storing NEC start %s with duration %d",
+						rawir.pulse ? "pulse" : "space",
+						rawir.duration);
+				} else {
+					/* RC5 protocol */
+					rawir.duration = RC5_START_PULSE;
+					dprintk(16, "Storing RC5 start %s with duration %d",
+						rawir.pulse ? "pulse" : "space",
+						rawir.duration);
+				}
+				ir_raw_event_store(ir->rc, &rawir);
+			}
+
+			init_ir_raw_event(&rawir);
+			rawir.pulse = prv_bit ? false : true;
+			rawir.duration = AU8522_UNIT * width;
+			dprintk(16, "Storing %s with duration %d",
+				rawir.pulse ? "pulse" : "space",
+				rawir.duration);
+			ir_raw_event_store(ir->rc, &rawir);
+
+			width = 1;
+			prv_bit = bit;
+		}
+	}
+
+	init_ir_raw_event(&rawir);
+	rawir.pulse = prv_bit ? false : true;
+	rawir.duration = AU8522_UNIT * width;
+	dprintk(16, "Storing end %s with duration %d",
+		rawir.pulse ? "pulse" : "space",
+		rawir.duration);
+	ir_raw_event_store(ir->rc, &rawir);
+
+	ir_raw_event_handle(ir->rc);
+
+	return 1;
+}
+
+/*
+ * Generic IR code
+ */
+
+static void au0828_rc_work(struct work_struct *work)
+{
+	struct au0828_rc *ir = container_of(work, struct au0828_rc, work.work);
+	int rc;
+
+	rc = ir->get_key_i2c(ir);
+	if (rc < 0)
+		pr_info("Error while getting RC scancode\n");
+
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
+}
+
+static int au0828_rc_start(struct rc_dev *rc)
+{
+	struct au0828_rc *ir = rc->priv;
+
+	INIT_DELAYED_WORK(&ir->work, au0828_rc_work);
+
+	/* Enable IR */
+	au8522_rc_set(ir, 0xe0, 1 << 4);
+
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
+
+	return 0;
+}
+
+static void au0828_rc_stop(struct rc_dev *rc)
+{
+	struct au0828_rc *ir = rc->priv;
+
+printk("%s\n", __func__);
+
+	/* Disable IR */
+	au8522_rc_clear(ir, 0xe0, 1 << 4);
+
+	cancel_delayed_work_sync(&ir->work);
+}
+
+static int au0828_probe_i2c_ir(struct au0828_dev *dev)
+{
+	int i = 0;
+	const unsigned short addr_list[] = {
+		 0x47, I2C_CLIENT_END
+	};
+
+	while (addr_list[i] != I2C_CLIENT_END) {
+		if (i2c_probe_func_quick_read(dev->i2c_client.adapter,
+					      addr_list[i]) == 1)
+			return addr_list[i];
+		i++;
+	}
+
+	return -ENODEV;
+}
+
+int au0828_rc_register(struct au0828_dev *dev)
+{
+	struct au0828_rc *ir;
+	struct rc_dev *rc;
+	int err = -ENOMEM;
+	u16 i2c_rc_dev_addr = 0;
+
+	if (!dev->board.has_ir_i2c)
+		return 0;
+
+	i2c_rc_dev_addr = au0828_probe_i2c_ir(dev);
+	if (!i2c_rc_dev_addr)
+		return -ENODEV;
+
+	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
+	rc = rc_allocate_device();
+	if (!ir || !rc)
+		goto error;
+
+	/* record handles to ourself */
+	ir->dev = dev;
+	dev->ir = ir;
+	ir->rc = rc;
+
+	rc->priv = ir;
+	rc->open = au0828_rc_start;
+	rc->close = au0828_rc_stop;
+
+	if (dev->board.has_ir_i2c) {	/* external i2c device */
+		switch (dev->boardnr) {
+		case AU0828_BOARD_HAUPPAUGE_HVR950Q:
+			rc->map_name = RC_MAP_HAUPPAUGE;
+			ir->get_key_i2c = au0828_get_key_au8522;
+			break;
+		default:
+			err = -ENODEV;
+			goto error;
+		}
+
+		ir->i2c_dev_addr = i2c_rc_dev_addr;
+	}
+
+	/* This is how often we ask the chip for IR information */
+	ir->polling = 100; /* ms */
+
+	/* init input device */
+	snprintf(ir->name, sizeof(ir->name), "au0828 IR (%s)",
+		 dev->board.name);
+
+	usb_make_path(dev->usbdev, ir->phys, sizeof(ir->phys));
+	strlcat(ir->phys, "/input0", sizeof(ir->phys));
+
+	rc->input_name = ir->name;
+	rc->input_phys = ir->phys;
+	rc->input_id.bustype = BUS_USB;
+	rc->input_id.version = 1;
+	rc->input_id.vendor = le16_to_cpu(dev->usbdev->descriptor.idVendor);
+	rc->input_id.product = le16_to_cpu(dev->usbdev->descriptor.idProduct);
+	rc->dev.parent = &dev->usbdev->dev;
+	rc->driver_name = "au0828-input";
+	rc->driver_type = RC_DRIVER_IR_RAW;
+	rc->allowed_protocols = RC_BIT_NEC | RC_BIT_RC5;
+
+	/* all done */
+	err = rc_register_device(rc);
+	if (err)
+		goto error;
+
+	pr_info("Remote controller %s initalized\n", ir->name);
+
+	return 0;
+
+error:
+	dev->ir = NULL;
+	rc_free_device(rc);
+	kfree(ir);
+	return err;
+}
+
+void au0828_rc_unregister(struct au0828_dev *dev)
+{
+	struct au0828_rc *ir = dev->ir;
+
+	/* skip detach on non attached boards */
+	if (!ir)
+		return;
+
+	if (ir->rc)
+		rc_unregister_device(ir->rc);
+
+	/* done */
+	kfree(ir);
+	dev->ir = NULL;
+
+	return;
+}
+
+int au0828_rc_suspend(struct au0828_dev *dev)
+{
+	struct au0828_rc *ir = dev->ir;
+
+	if (!ir)
+		return 0;
+
+	cancel_delayed_work_sync(&ir->work);
+
+	return 0;
+}
+
+int au0828_rc_resume(struct au0828_dev *dev)
+{
+	struct au0828_rc *ir = dev->ir;
+
+	if (!ir)
+		return 0;
+
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
+
+	return 0;
+}
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 7112b9d956fa..96bec05d7dac 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -88,6 +88,7 @@ struct au0828_board {
 	unsigned int tuner_type;
 	unsigned char tuner_addr;
 	unsigned char i2c_clk_divider;
+	unsigned char has_ir_i2c:1;
 	struct au0828_input input[AU0828_MAX_INPUT];
 
 };
@@ -213,6 +214,10 @@ struct au0828_dev {
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler v4l2_ctrl_hdl;
 #endif
+#ifdef CONFIG_VIDEO_AU0828_RC
+	struct au0828_rc *ir;
+#endif
+
 	int users;
 	unsigned int resources;	/* resources in use */
 	struct video_device *vdev;
@@ -319,3 +324,9 @@ extern struct videobuf_queue_ops au0828_vbi_qops;
 	do { if (au0828_debug & level)\
 		printk(KERN_DEBUG DRIVER_NAME "/0: " fmt, ## arg);\
 	} while (0)
+
+/* au0828-input.c */
+int au0828_rc_register(struct au0828_dev *dev);
+void au0828_rc_unregister(struct au0828_dev *dev);
+int au0828_rc_suspend(struct au0828_dev *dev);
+int au0828_rc_resume(struct au0828_dev *dev);
-- 
1.9.3

