Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52168 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab0DOVqQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 17:46:16 -0400
Subject: [PATCH 3/8] ir-core: Add Sony support to ir-core
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Date: Thu, 15 Apr 2010 23:46:10 +0200
Message-ID: <20100415214610.14142.85260.stgit@localhost.localdomain>
In-Reply-To: <20100415214520.14142.56114.stgit@localhost.localdomain>
References: <20100415214520.14142.56114.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a Sony12/15/20 decoder to ir-core.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/Kconfig           |    9 +
 drivers/media/IR/Makefile          |    1 
 drivers/media/IR/ir-core-priv.h    |    7 +
 drivers/media/IR/ir-raw-event.c    |    1 
 drivers/media/IR/ir-sony-decoder.c |  312 ++++++++++++++++++++++++++++++++++++
 drivers/media/IR/ir-sysfs.c        |    4 
 6 files changed, 334 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/IR/ir-sony-decoder.c

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index 179e4c3..25e10b5 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -45,3 +45,12 @@ config IR_JVC_DECODER
 	---help---
 	   Enable this option if you have an infrared remote control which
 	   uses the JVC protocol, and you need software decoding support.
+
+config IR_SONY_DECODER
+	tristate "Enable IR raw decoder for the Sony protocol"
+	depends on IR_CORE
+	default y
+
+	---help---
+	   Enable this option if you have an infrared remote control which
+	   uses the Sony protocol, and you need software decoding support.
diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 8d0098f..a12ee37 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
 obj-$(CONFIG_IR_JVC_DECODER) += ir-jvc-decoder.o
+obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index 4b1a21d..04962a6 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -118,4 +118,11 @@ void ir_raw_init(void);
 #define load_jvc_decode()	0
 #endif
 
+/* from ir-sony-decoder.c */
+#ifdef CONFIG_IR_SONY_DECODER_MODULE
+#define load_sony_decode()	request_module("ir-sony-decoder")
+#else
+#define load_sony_decode()	0
+#endif
+
 #endif /* _IR_RAW_EVENT */
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 7eef6bf..ea68a3f 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -234,6 +234,7 @@ static void init_decoders(struct work_struct *work)
 	load_rc5_decode();
 	load_rc6_decode();
 	load_jvc_decode();
+	load_sony_decode();
 
 	/* If needed, we may later add some init code. In this case,
 	   it is needed to change the CONFIG_MODULE test at ir-core.h
diff --git a/drivers/media/IR/ir-sony-decoder.c b/drivers/media/IR/ir-sony-decoder.c
new file mode 100644
index 0000000..9f440c5
--- /dev/null
+++ b/drivers/media/IR/ir-sony-decoder.c
@@ -0,0 +1,312 @@
+/* ir-sony-decoder.c - handle Sony IR Pulse/Space protocol
+ *
+ * Copyright (C) 2010 by David Härdeman <david@hardeman.nu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/bitrev.h>
+#include "ir-core-priv.h"
+
+#define SONY_UNIT		600000 /* ns */
+#define SONY_HEADER_PULSE	(4 * SONY_UNIT)
+#define	SONY_HEADER_SPACE	(1 * SONY_UNIT)
+#define SONY_BIT_0_PULSE	(1 * SONY_UNIT)
+#define SONY_BIT_1_PULSE	(2 * SONY_UNIT)
+#define SONY_BIT_SPACE		(1 * SONY_UNIT)
+#define SONY_TRAILER_SPACE	(10 * SONY_UNIT) /* minimum */
+
+/* Used to register sony_decoder clients */
+static LIST_HEAD(decoder_list);
+static DEFINE_SPINLOCK(decoder_lock);
+
+enum sony_state {
+	STATE_INACTIVE,
+	STATE_HEADER_SPACE,
+	STATE_BIT_PULSE,
+	STATE_BIT_SPACE,
+	STATE_FINISHED,
+};
+
+struct decoder_data {
+	struct list_head	list;
+	struct ir_input_dev	*ir_dev;
+	int			enabled:1;
+
+	/* State machine control */
+	enum sony_state		state;
+	u32			sony_bits;
+	unsigned		count;
+};
+
+
+/**
+ * get_decoder_data()	- gets decoder data
+ * @input_dev:	input device
+ *
+ * Returns the struct decoder_data that corresponds to a device
+ */
+static struct decoder_data *get_decoder_data(struct  ir_input_dev *ir_dev)
+{
+	struct decoder_data *data = NULL;
+
+	spin_lock(&decoder_lock);
+	list_for_each_entry(data, &decoder_list, list) {
+		if (data->ir_dev == ir_dev)
+			break;
+	}
+	spin_unlock(&decoder_lock);
+	return data;
+}
+
+static ssize_t store_enabled(struct device *d,
+			     struct device_attribute *mattr,
+			     const char *buf,
+			     size_t len)
+{
+	unsigned long value;
+	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	struct decoder_data *data = get_decoder_data(ir_dev);
+
+	if (!data)
+		return -EINVAL;
+
+	if (strict_strtoul(buf, 10, &value) || value > 1)
+		return -EINVAL;
+
+	data->enabled = value;
+
+	return len;
+}
+
+static ssize_t show_enabled(struct device *d,
+			     struct device_attribute *mattr, char *buf)
+{
+	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	struct decoder_data *data = get_decoder_data(ir_dev);
+
+	if (!data)
+		return -EINVAL;
+
+	if (data->enabled)
+		return sprintf(buf, "1\n");
+	else
+	return sprintf(buf, "0\n");
+}
+
+static DEVICE_ATTR(enabled, S_IRUGO | S_IWUSR, show_enabled, store_enabled);
+
+static struct attribute *decoder_attributes[] = {
+	&dev_attr_enabled.attr,
+	NULL
+};
+
+static struct attribute_group decoder_attribute_group = {
+	.name	= "sony_decoder",
+	.attrs	= decoder_attributes,
+};
+
+/**
+ * ir_sony_decode() - Decode one Sony pulse or space
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @ev:         the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This function returns -EINVAL if the pulse violates the state machine
+ */
+static int ir_sony_decode(struct input_dev *input_dev, struct ir_raw_event ev)
+{
+	struct decoder_data *data;
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	u32 scancode;
+	u8 device, subdevice, function;
+
+	data = get_decoder_data(ir_dev);
+	if (!data)
+		return -EINVAL;
+
+	if (!data->enabled)
+		return 0;
+
+	if (IS_RESET(ev)) {
+		data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	if (!geq_margin(ev.duration, SONY_UNIT, SONY_UNIT / 2))
+		goto out;
+
+	IR_dprintk(2, "Sony decode started at state %d (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+
+	switch (data->state) {
+
+	case STATE_INACTIVE:
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, SONY_HEADER_PULSE, SONY_UNIT / 2))
+			break;
+
+		data->count = 0;
+		data->state = STATE_HEADER_SPACE;
+		return 0;
+
+	case STATE_HEADER_SPACE:
+		if (ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, SONY_HEADER_SPACE, SONY_UNIT / 2))
+			break;
+
+		data->state = STATE_BIT_PULSE;
+		return 0;
+
+	case STATE_BIT_PULSE:
+		if (!ev.pulse)
+			break;
+
+		data->sony_bits <<= 1;
+		if (eq_margin(ev.duration, SONY_BIT_1_PULSE, SONY_UNIT / 2))
+			data->sony_bits |= 1;
+		else if (!eq_margin(ev.duration, SONY_BIT_0_PULSE, SONY_UNIT / 2))
+			break;
+
+		data->count++;
+		data->state = STATE_BIT_SPACE;
+		return 0;
+
+	case STATE_BIT_SPACE:
+		if (ev.pulse)
+			break;
+
+		if (!geq_margin(ev.duration, SONY_BIT_SPACE, SONY_UNIT / 2))
+			break;
+
+		decrease_duration(&ev, SONY_BIT_SPACE);
+
+		if (!geq_margin(ev.duration, SONY_UNIT, SONY_UNIT / 2)) {
+			data->state = STATE_BIT_PULSE;
+			return 0;
+		}
+
+		data->state = STATE_FINISHED;
+		/* Fall through */
+
+	case STATE_FINISHED:
+		if (ev.pulse)
+			break;
+
+		if (!geq_margin(ev.duration, SONY_TRAILER_SPACE, SONY_UNIT / 2))
+			break;
+
+		switch (data->count) {
+		case 12:
+			device    = bitrev8((data->sony_bits <<  3) & 0xF8);
+			subdevice = 0;
+			function  = bitrev8((data->sony_bits >>  4) & 0xFE);
+			break;
+		case 15:
+			device    = bitrev8((data->sony_bits >>  0) & 0xFF);
+			subdevice = 0;
+			function  = bitrev8((data->sony_bits >>  7) & 0xFD);
+			break;
+		case 20:
+			device    = bitrev8((data->sony_bits >>  5) & 0xF8);
+			subdevice = bitrev8((data->sony_bits >>  0) & 0xFF);
+			function  = bitrev8((data->sony_bits >> 12) & 0xFE);
+			break;
+		default:
+			IR_dprintk(1, "Sony invalid bitcount %u\n", data->count);
+			goto out;
+		}
+
+		scancode = device << 16 | subdevice << 8 | function;
+		IR_dprintk(1, "Sony(%u) scancode 0x%05x\n", data->count, scancode);
+		ir_keydown(input_dev, scancode, 0);
+		data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+out:
+	IR_dprintk(1, "Sony decode failed at state %d (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	data->state = STATE_INACTIVE;
+	return -EINVAL;
+}
+
+static int ir_sony_register(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct decoder_data *data;
+	int rc;
+
+	rc = sysfs_create_group(&ir_dev->dev.kobj, &decoder_attribute_group);
+	if (rc < 0)
+		return rc;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		sysfs_remove_group(&ir_dev->dev.kobj, &decoder_attribute_group);
+		return -ENOMEM;
+	}
+
+	data->ir_dev = ir_dev;
+	data->enabled = 1;
+
+	spin_lock(&decoder_lock);
+	list_add_tail(&data->list, &decoder_list);
+	spin_unlock(&decoder_lock);
+
+	return 0;
+}
+
+static int ir_sony_unregister(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	static struct decoder_data *data;
+
+	data = get_decoder_data(ir_dev);
+	if (!data)
+		return 0;
+
+	sysfs_remove_group(&ir_dev->dev.kobj, &decoder_attribute_group);
+
+	spin_lock(&decoder_lock);
+	list_del(&data->list);
+	spin_unlock(&decoder_lock);
+
+	return 0;
+}
+
+static struct ir_raw_handler sony_handler = {
+	.decode		= ir_sony_decode,
+	.raw_register	= ir_sony_register,
+	.raw_unregister	= ir_sony_unregister,
+};
+
+static int __init ir_sony_decode_init(void)
+{
+	ir_raw_handler_register(&sony_handler);
+
+	printk(KERN_INFO "IR Sony protocol handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_sony_decode_exit(void)
+{
+	ir_raw_handler_unregister(&sony_handler);
+}
+
+module_init(ir_sony_decode_init);
+module_exit(ir_sony_decode_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Härdeman <david@hardeman.nu>");
+MODULE_DESCRIPTION("Sony IR protocol decoder");
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 8e2751e..dfd45fa 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -64,6 +64,8 @@ static ssize_t show_protocol(struct device *d,
 		s = "rc6";
 	else if (ir_type == IR_TYPE_JVC)
 		s = "jvc";
+	else if (ir_type == IR_TYPE_SONY)
+		s = "sony";
 	else
 		s = "other";
 
@@ -103,6 +105,8 @@ static ssize_t store_protocol(struct device *d,
 			ir_type |= IR_TYPE_NEC;
 		if (!strcasecmp(buf, "jvc"))
 			ir_type |= IR_TYPE_JVC;
+		if (!strcasecmp(buf, "sony"))
+			ir_type |= IR_TYPE_SONY;
 	}
 
 	if (!ir_type) {
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 214f072..67af24e 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -17,6 +17,7 @@
 #define IR_TYPE_NEC	(1  << 2)
 #define IR_TYPE_RC6	(1  << 3)	/* Philips RC6 protocol */
 #define IR_TYPE_JVC	(1  << 4)	/* JVC protocol */
+#define IR_TYPE_SONY	(1  << 5)	/* Sony12/15/20 protocol */
 #define IR_TYPE_OTHER	(1u << 31)
 
 struct ir_scancode {

