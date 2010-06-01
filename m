Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab0FAUxA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:00 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o51Kr0sf017935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:53:00 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o51KqwuY001285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:52:59 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o51KqwIu002453
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:52:58 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o51Kqw9J002452
	for linux-media@vger.kernel.org; Tue, 1 Jun 2010 16:52:58 -0400
Date: Tue, 1 Jun 2010 16:52:58 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] IR: add ir-core to lirc interface bridge driver
Message-ID: <20100601205258.GC31616@redhat.com>
References: <20100601205005.GA28322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601205005.GA28322@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a new ir-core protocol plugin, which bridges from ir-core
raw IR data collection to the classic lirc device interface, which
allows pure ir-core drivers to pass raw IR data out to userspace to
be handled by the lirc userspace daemon.

At the moment, only the receive side is wired up, with future plans
to enable the transmit side as well. Tested successfully with the
mceusb driver and lirc 0.8.6.

Nb: since we're still hashing out what transmit support will look like,
its possible this should actually be ir-lirc-decoder, and transmit
support provided by a separate ir-lirc-encoder, but for the moment, I'm
going with ir-lirc-codec, as lirc_dev is also a two-way device interface.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/Kconfig         |   10 ++
 drivers/media/IR/Makefile        |    1 +
 drivers/media/IR/ir-core-priv.h  |    7 +
 drivers/media/IR/ir-lirc-codec.c |  301 ++++++++++++++++++++++++++++++++++++++
 drivers/media/IR/ir-raw-event.c  |    1 +
 5 files changed, 320 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/IR/ir-lirc-codec.c

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index c3010fb..bd7ee8b 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -66,6 +66,16 @@ config IR_SONY_DECODER
 	   Enable this option if you have an infrared remote control which
 	   uses the Sony protocol, and you need software decoding support.
 
+config IR_LIRC_CODEC
+	tristate "Enable IR to LIRC bridge"
+	depends on IR_CORE
+	depends on LIRC
+	default y
+
+	---help---
+	   Enable this option to pass raw IR to and from userspace via
+	   the LIRC interface.
+
 config IR_IMON
 	tristate "SoundGraph iMON Receiver and Display"
 	depends on USB_ARCH_HAS_HCD
diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 3ba00bb..2ae4f3a 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
 obj-$(CONFIG_IR_JVC_DECODER) += ir-jvc-decoder.o
 obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
+obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 
 # stand-alone IR receivers/transmitters
 obj-$(CONFIG_IR_IMON) += imon.o
diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index b79446f..7ad080d 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -122,4 +122,11 @@ void ir_raw_init(void);
 #define load_sony_decode()	0
 #endif
 
+/* from ir-lirc-codec.c */
+#ifdef CONFIG_IR_LIRC_CODEC_MODULE
+#define load_lirc_codec()	request_module("ir-lirc-codec")
+#else
+#define load_lirc_codec()	0
+#endif
+
 #endif /* _IR_RAW_EVENT */
diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
new file mode 100644
index 0000000..b838ab8
--- /dev/null
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -0,0 +1,301 @@
+/* ir-lirc-codec.c - ir-core to classic lirc interface bridge
+ *
+ * Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
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
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <media/lirc.h>
+#include <media/ir-core.h>
+#include "ir-core-priv.h"
+#include "lirc_dev.h"
+
+/* Used to register lirc_codec clients */
+static LIST_HEAD(decoder_list);
+static DEFINE_SPINLOCK(decoder_lock);
+
+struct decoder_data {
+	struct list_head	list;
+	struct ir_input_dev	*ir_dev;
+	int			enabled:1;
+
+	/* lirc interface bits */
+	struct lirc_driver *drv;
+	int lircdata;
+};
+
+#define LIRCBUF_SIZE 256
+
+/**
+ * get_decoder_data()	- gets decoder data
+ * @ir_input_dev:	input device
+ *
+ * Returns the struct decoder_data that corresponds to a device
+ */
+static struct decoder_data *get_decoder_data(struct ir_input_dev *ir_dev)
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
+	.name	= "lirc_codec",
+	.attrs	= decoder_attributes,
+};
+
+/**
+ * ir_lirc_decode() - Send raw IR data to lirc_dev to be relayed to the
+ *		      lircd userspace daemon for decoding.
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This function returns -EINVAL if the lirc interfaces aren't wired up.
+ */
+static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
+{
+	struct decoder_data *data;
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+
+	data = get_decoder_data(ir_dev);
+	if (!data)
+		return -EINVAL;
+
+	if (!data->enabled)
+		return 0;
+
+	if (!data->drv || !data->drv->rbuf)
+		return -EINVAL;
+
+	IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
+		   TO_US(ev.duration), TO_STR(ev.pulse));
+
+	data->lircdata += ev.duration / 1000;
+	if (ev.pulse)
+		data->lircdata |= PULSE_BIT;
+
+	lirc_buffer_write(data->drv->rbuf, (unsigned char *) &data->lircdata);
+	wake_up(&data->drv->rbuf->wait_poll);
+
+	data->lircdata = 0;
+
+	return 0;
+}
+
+static int ir_lirc_ioctl(struct inode *node, struct file *filep,
+			 unsigned int cmd, unsigned long arg)
+{
+	struct decoder_data *data;
+
+	data = lirc_get_pdata(filep);
+	if (!data)
+		return -EFAULT;
+
+	switch (cmd) {
+	case LIRC_SET_TRANSMITTER_MASK:
+		/* FIXME: implement this */
+		break;
+	default:
+		return lirc_dev_fop_ioctl(node, filep, cmd, arg);
+	}
+
+	return 0;
+}
+
+static int ir_lirc_open(void *data)
+{
+	return 0;
+}
+
+static void ir_lirc_close(void *data)
+{
+	return;
+}
+
+static struct file_operations lirc_fops = {
+	.owner		= THIS_MODULE,
+	/*.write		= lirc_transmit_ir,*/
+	.ioctl		= ir_lirc_ioctl,
+	.read		= lirc_dev_fop_read,
+	.poll		= lirc_dev_fop_poll,
+	.open		= lirc_dev_fop_open,
+	.release	= lirc_dev_fop_close,
+};
+
+static int ir_lirc_register(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct decoder_data *data;
+	struct lirc_driver *drv;
+	struct lirc_buffer *rbuf;
+	int rc;
+
+	rc = sysfs_create_group(&ir_dev->dev.kobj, &decoder_attribute_group);
+	if (rc < 0)
+		return rc;
+
+	rc = -ENOMEM;
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		sysfs_remove_group(&ir_dev->dev.kobj, &decoder_attribute_group);
+		return rc;
+	}
+
+	drv = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
+	if (!drv)
+		goto drv_alloc_failed;
+
+	rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
+	if (!drv)
+		goto rbuf_alloc_failed;
+
+	rc = lirc_buffer_init(rbuf, sizeof(int), LIRCBUF_SIZE);
+	if (rc)
+		goto rbuf_init_failed;
+
+	strcpy(drv->name, "ir-lirc-codec");
+	drv->minor = -1;
+	drv->features = LIRC_CAN_REC_MODE2;
+	drv->data = data;
+	drv->rbuf = rbuf;
+	drv->set_use_inc = &ir_lirc_open;
+	drv->set_use_dec = &ir_lirc_close;
+	drv->code_length = sizeof(struct ir_raw_event) * 8;
+	drv->fops = &lirc_fops;
+	drv->dev = &ir_dev->dev;
+	drv->owner = THIS_MODULE;
+
+	drv->minor = lirc_register_driver(drv);
+	if (drv->minor < 0) {
+		rc = -ENODEV;
+		goto lirc_register_failed;
+	}
+
+	data->ir_dev = ir_dev;
+	data->enabled = 1;
+	data->drv = drv;
+	data->lircdata = PULSE_MASK;
+
+	spin_lock(&decoder_lock);
+	list_add_tail(&data->list, &decoder_list);
+	spin_unlock(&decoder_lock);
+
+	return 0;
+
+lirc_register_failed:
+rbuf_init_failed:
+	kfree(rbuf);
+rbuf_alloc_failed:
+	kfree(drv);
+drv_alloc_failed:
+	kfree(data);
+
+	return rc;
+}
+
+static int ir_lirc_unregister(struct input_dev *input_dev)
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
+	lirc_unregister_driver(data->drv->minor);
+	kfree(data->drv);
+
+	spin_lock(&decoder_lock);
+	list_del(&data->list);
+	spin_unlock(&decoder_lock);
+
+	kfree(data);
+
+	return 0;
+}
+
+static struct ir_raw_handler lirc_handler = {
+	.decode		= ir_lirc_decode,
+	.raw_register	= ir_lirc_register,
+	.raw_unregister	= ir_lirc_unregister,
+};
+
+static int __init ir_lirc_codec_init(void)
+{
+	ir_raw_handler_register(&lirc_handler);
+
+	printk(KERN_INFO "IR LIRC bridge handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_lirc_codec_exit(void)
+{
+	ir_raw_handler_unregister(&lirc_handler);
+}
+
+module_init(ir_lirc_codec_init);
+module_exit(ir_lirc_codec_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
+MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
+MODULE_DESCRIPTION("LIRC IR handler bridge");
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 7edfa10..596445f 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -234,6 +234,7 @@ static void init_decoders(struct work_struct *work)
 	load_rc6_decode();
 	load_jvc_decode();
 	load_sony_decode();
+	load_lirc_codec();
 
 	/* If needed, we may later add some init code. In this case,
 	   it is needed to change the CONFIG_MODULE test at ir-core.h
-- 
1.6.5.2

-- 
Jarod Wilson
jarod@redhat.com

