Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074Ab0DFSSo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:44 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIhIl007628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:44 -0400
Date: Tue, 6 Apr 2010 15:18:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 20/26] V4L-DVB: ir-rc5-decoder: Add a decoder for RC-5 IR
 protocol
Message-ID: <20100406151801.48488765@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This decoder is also based on a state machine, just like the NEC protocol
decoder. It is pedantic in the sense that accepts only 14 bits. As there
are some variants that outputs less bits, it needs to be improved to also
handle those.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 drivers/media/IR/ir-rc5-decoder.c

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index 0c557b8..ba81bda 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -18,3 +18,12 @@ config IR_NEC_DECODER
 	---help---
 	   Enable this option if you have IR with NEC protocol, and
 	   if the IR is decoded in software
+
+config IR_RC5_DECODER
+	tristate "Enable IR raw decoder for RC-5 protocol"
+	depends on IR_CORE
+	default y
+
+	---help---
+	   Enable this option if you have IR with RC-5 protocol, and
+	   if the IR is decoded in software
diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 0e3f912..62e12d5 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -6,3 +6,4 @@ obj-y += keymaps/
 obj-$(CONFIG_IR_CORE) += ir-core.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
+obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 59f2054..617e437 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -200,6 +200,7 @@ static void init_decoders(struct work_struct *work)
 	/* Load the decoder modules */
 
 	load_nec_decode();
+	load_rc5_decode();
 
 	/* If needed, we may later add some init code. In this case,
 	   it is needed to change the CONFIG_MODULE test at ir-core.h
diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
new file mode 100644
index 0000000..4b7eafe
--- /dev/null
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -0,0 +1,371 @@
+/* ir-rc5-decoder.c - handle RC-5 IR Pulse/Space protocol
+ *
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+/*
+ * This code only handles 14 bits RC-5 protocols. There are other variants
+ * that use a different number of bits. This is currently unsupported
+ */
+
+#include <media/ir-core.h>
+
+#define RC5_NBITS		14
+#define RC5_HALFBIT		888888 /* ns */
+#define RC5_BIT			(RC5_HALFBIT * 2)
+#define RC5_DURATION		(RC5_BIT * RC5_NBITS)
+
+#define is_rc5_halfbit(nsec) ((ev->delta.tv_nsec >= RC5_HALFBIT / 2) &&	   \
+		      (ev->delta.tv_nsec < RC5_HALFBIT + RC5_HALFBIT / 2))
+
+#define n_half(nsec) ((ev->delta.tv_nsec + RC5_HALFBIT / 2) / RC5_HALFBIT)
+
+/* Used to register rc5_decoder clients */
+static LIST_HEAD(decoder_list);
+static spinlock_t decoder_lock;
+
+enum rc5_state {
+	STATE_INACTIVE,
+	STATE_START2_SPACE,
+	STATE_START2_MARK,
+	STATE_MARKSPACE,
+	STATE_TRAILER_MARK,
+};
+
+static char *st_name[] = {
+	"Inactive",
+	"start2 sapce",
+	"start2 mark",
+	"mark",
+	"space",
+	"trailer"
+};
+
+struct rc5_code {
+	u8	address;
+	u8	command;
+};
+
+struct decoder_data {
+	struct list_head	list;
+	struct ir_input_dev	*ir_dev;
+	int			enabled:1;
+
+	/* State machine control */
+	enum rc5_state		state;
+	struct rc5_code		rc5_code;
+	unsigned		n_half;
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
+
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
+	.name	= "rc5_decoder",
+	.attrs	= decoder_attributes,
+};
+
+/**
+ * handle_event() - Decode one RC-5 pulse or space
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @ev:		event array with type/duration of pulse/space
+ *
+ * This function returns -EINVAL if the pulse violates the state machine
+ */
+static int handle_event(struct input_dev *input_dev,
+			struct ir_raw_event *ev)
+{
+	struct decoder_data *data;
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	int bit, last_bit, n_half;
+
+	data = get_decoder_data(ir_dev);
+	if (!data)
+		return -EINVAL;
+
+	/* Except for the initial event, what matters is the previous bit */
+	bit = (ev->type & IR_PULSE) ? 1 : 0;
+
+	last_bit = !bit;
+
+	/* Discards spurious space last_bits when inactive */
+
+	/* Very long delays are considered as start events */
+	if (ev->delta.tv_nsec > RC5_DURATION + RC5_HALFBIT / 2)
+		data->state = STATE_INACTIVE;
+
+	if (ev->type & IR_START_EVENT)
+		data->state = STATE_INACTIVE;
+
+	switch (data->state) {
+	case STATE_INACTIVE:
+IR_dprintk(1, "currently inative. Received bit (%s) @%luus\n",
+	last_bit ? "pulse" : "space",
+	(ev->delta.tv_nsec + 500) / 1000);
+
+		/* Discards the initial start space */
+		if (bit)
+			return 0;
+		data->count = 0;
+		data->n_half = 0;
+		memset (&data->rc5_code, 0, sizeof(data->rc5_code));
+
+		data->state = STATE_START2_SPACE;
+		return 0;
+	case STATE_START2_SPACE:
+		if (last_bit)
+			goto err;
+		if (!is_rc5_halfbit(ev->delta.tv_nsec))
+			goto err;
+		data->state = STATE_START2_MARK;
+		return 0;
+	case STATE_START2_MARK:
+		if (!last_bit)
+			goto err;
+
+		if (!is_rc5_halfbit(ev->delta.tv_nsec))
+			goto err;
+
+		data->state = STATE_MARKSPACE;
+		return 0;
+	case STATE_MARKSPACE:
+		n_half = n_half(ev->delta.tv_nsec);
+		if (n_half < 1 || n_half > 3) {
+			IR_dprintk(1, "Decode failed at %d-th bit (%s) @%luus\n",
+				data->count,
+				last_bit ? "pulse" : "space",
+				(ev->delta.tv_nsec + 500) / 1000);
+printk("%d halves\n", n_half);
+			goto err2;
+		}
+		data->n_half += n_half;
+
+		if (!last_bit)
+			return 0;
+
+		/* Got one complete mark/space cycle */
+
+		bit = ((data->count + 1) * 2)/ data->n_half;
+
+printk("%d halves, %d bits\n", n_half, bit);
+
+#if 1 /* SANITY check - while testing the decoder */
+		if (bit > 1) {
+			IR_dprintk(1, "Decoder HAS failed at %d-th bit (%s) @%luus\n",
+				data->count,
+				last_bit ? "pulse" : "space",
+				(ev->delta.tv_nsec + 500) / 1000);
+
+			goto err2;
+		}
+#endif
+		/* Ok, we've got a valid bit. proccess it */
+		if (bit) {
+			int shift = data->count;
+
+			/*
+			 * RC-5 transmit bytes on this temporal order:
+			 * address | not address | command | not command
+			 */
+			if (shift < 8) {
+				data->rc5_code.address |= 1 << shift;
+			} else {
+				data->rc5_code.command |= 1 << (shift - 8);
+			}
+		}
+		IR_dprintk(1, "RC-5: bit #%d: %d (%d)\n",
+				data->count, bit, data->n_half);
+		if (++data->count >= RC5_NBITS) {
+			u32 scancode;
+			scancode = data->rc5_code.address << 8 |
+					data->rc5_code.command;
+			IR_dprintk(1, "RC-5 scancode 0x%04x\n", scancode);
+
+			ir_keydown(input_dev, scancode, 0);
+
+			data->state = STATE_TRAILER_MARK;
+		}
+		return 0;
+	case STATE_TRAILER_MARK:
+		if (!last_bit)
+			goto err;
+		data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+err:
+	IR_dprintk(1, "RC-5 decoded failed at state %s (%s) @ %luus\n",
+		   st_name[data->state],
+		   bit ? "pulse" : "space",
+		   (ev->delta.tv_nsec + 500) / 1000);
+err2:
+	data->state = STATE_INACTIVE;
+	return -EINVAL;
+}
+
+/**
+ * ir_rc5_decode() - Decodes all RC-5 pulsecodes on a given array
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @evs:	event array with type/duration of pulse/space
+ * @len:	length of the array
+ * This function returns the number of decoded pulses
+ */
+static int ir_rc5_decode(struct input_dev *input_dev,
+			 struct ir_raw_event *evs,
+			 int len)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct decoder_data *data;
+	int pos = 0;
+	int rc = 0;
+
+	data = get_decoder_data(ir_dev);
+	if (!data || !data->enabled)
+		return 0;
+
+	for (pos = 0; pos < len; pos++)
+		handle_event(input_dev, &evs[pos]);
+
+	return rc;
+}
+
+static int ir_rc5_register(struct input_dev *input_dev)
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
+static int ir_rc5_unregister(struct input_dev *input_dev)
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
+static struct ir_raw_handler rc5_handler = {
+	.decode		= ir_rc5_decode,
+	.raw_register	= ir_rc5_register,
+	.raw_unregister	= ir_rc5_unregister,
+};
+
+static int __init ir_rc5_decode_init(void)
+{
+	ir_raw_handler_register(&rc5_handler);
+
+	printk(KERN_INFO "IR RC-5 protocol handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_rc5_decode_exit(void)
+{
+	ir_raw_handler_unregister(&rc5_handler);
+}
+
+module_init(ir_rc5_decode_init);
+module_exit(ir_rc5_decode_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
+MODULE_DESCRIPTION("RC-5 IR protocol decoder");
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index b452a47..4090073 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -178,4 +178,11 @@ void ir_raw_init(void);
 #define load_nec_decode()	0
 #endif
 
+/* from ir-rc5-decoder.c */
+#ifdef CONFIG_IR_RC5_DECODER_MODULE
+#define load_rc5_decode()	request_module("ir-rc5-decoder")
+#else
+#define load_rc5_decode()	0
+#endif
+
 #endif /* _IR_CORE */
-- 
1.6.6.1


