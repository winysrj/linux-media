Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0GCEHz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 00:07:55 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6347sD8001156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:07:55 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o6347sEC012710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:07:54 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o6347rmn031511
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:07:53 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o6347rPn031510
	for linux-media@vger.kernel.org; Sat, 3 Jul 2010 00:07:53 -0400
Date: Sat, 3 Jul 2010 00:07:53 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 2/3] IR: add ir-core to lirc userspace decoder bridge
 driver
Message-ID: <20100703040753.GD31255@redhat.com>
References: <20100601205005.GA28322@redhat.com>
 <20100703040530.GB31255@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100703040530.GB31255@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2: copy of buffer data from userspace done inside this plugin/driver,
keeping the actual drivers minimal, and more flexible in what we can
deliver to them later on (they may be fed from within kernelspace later
on, by an in-kernel IR encoder).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/Kconfig         |   10 ++
 drivers/media/IR/Makefile        |    1 +
 drivers/media/IR/ir-core-priv.h  |   13 ++
 drivers/media/IR/ir-lirc-codec.c |  284 ++++++++++++++++++++++++++++++++++++++
 drivers/media/IR/ir-raw-event.c  |    1 +
 drivers/media/IR/ir-sysfs.c      |    8 +
 include/media/rc-map.h           |    4 +-
 7 files changed, 320 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/IR/ir-lirc-codec.c

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index 5a32b99..d8e5c73 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -67,6 +67,16 @@ config IR_SONY_DECODER
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
index 0a82b22..babd520 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -73,6 +73,11 @@ struct ir_raw_event_ctrl {
 		bool first;
 		bool toggle;
 	} jvc;
+	struct lirc_codec {
+		struct ir_input_dev *ir_dev;
+		struct lirc_driver *drv;
+		int lircdata;
+	} lirc;
 };
 
 /* macros for IR decoders */
@@ -164,4 +169,12 @@ void ir_raw_init(void);
 #define load_sony_decode()	0
 #endif
 
+/* from ir-lirc-codec.c */
+#ifdef CONFIG_IR_LIRC_CODEC_MODULE
+#define load_lirc_codec()	request_module("ir-lirc-codec")
+#else
+#define load_lirc_codec()	0
+#endif
+
+
 #endif /* _IR_RAW_EVENT */
diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
new file mode 100644
index 0000000..aff31d1
--- /dev/null
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -0,0 +1,284 @@
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
+#define LIRCBUF_SIZE 256
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
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+
+	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_LIRC))
+		return 0;
+
+	if (!ir_dev->raw->lirc.drv || !ir_dev->raw->lirc.drv->rbuf)
+		return -EINVAL;
+
+	IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
+		   TO_US(ev.duration), TO_STR(ev.pulse));
+
+	ir_dev->raw->lirc.lircdata += ev.duration / 1000;
+	if (ev.pulse)
+		ir_dev->raw->lirc.lircdata |= PULSE_BIT;
+
+	lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
+			  (unsigned char *) &ir_dev->raw->lirc.lircdata);
+	wake_up(&ir_dev->raw->lirc.drv->rbuf->wait_poll);
+
+	ir_dev->raw->lirc.lircdata = 0;
+
+	return 0;
+}
+
+static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
+				   size_t n, loff_t *ppos)
+{
+	struct lirc_codec *lirc;
+	struct ir_input_dev *ir_dev;
+	int *txbuf; /* buffer with values to transmit */
+	int ret = 0, count;
+
+	lirc = lirc_get_pdata(file);
+	if (!lirc)
+		return -EFAULT;
+
+	if (n % sizeof(int))
+		return -EINVAL;
+
+	count = n / sizeof(int);
+	if (count > LIRCBUF_SIZE || count % 2 == 0)
+		return -EINVAL;
+
+	txbuf = kzalloc(sizeof(int) * LIRCBUF_SIZE, GFP_KERNEL);
+	if (!txbuf)
+		return -ENOMEM;
+
+	if (copy_from_user(txbuf, buf, n)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ir_dev = lirc->ir_dev;
+	if (!ir_dev) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (ir_dev->props && ir_dev->props->tx_ir)
+		ret = ir_dev->props->tx_ir(ir_dev->props->priv, txbuf, (u32)n);
+
+out:
+	kfree(txbuf);
+	return ret;
+}
+
+static int ir_lirc_ioctl(struct inode *node, struct file *filep,
+			 unsigned int cmd, unsigned long arg)
+{
+	struct lirc_codec *lirc;
+	struct ir_input_dev *ir_dev;
+	int ret = 0;
+	void *drv_data;
+	unsigned long val;
+
+	lirc = lirc_get_pdata(filep);
+	if (!lirc)
+		return -EFAULT;
+
+	ir_dev = lirc->ir_dev;
+	if (!ir_dev || !ir_dev->props || !ir_dev->props->priv)
+		return -EFAULT;
+
+	drv_data = ir_dev->props->priv;
+
+	switch (cmd) {
+	case LIRC_SET_TRANSMITTER_MASK:
+		ret = get_user(val, (unsigned long *)arg);
+		if (ret)
+			return ret;
+
+		if (ir_dev->props && ir_dev->props->s_tx_mask)
+			ret = ir_dev->props->s_tx_mask(drv_data, (u32)val);
+		else
+			return -EINVAL;
+		break;
+
+	case LIRC_SET_SEND_CARRIER:
+		ret = get_user(val, (unsigned long *)arg);
+		if (ret)
+			return ret;
+
+		if (ir_dev->props && ir_dev->props->s_tx_carrier)
+			ir_dev->props->s_tx_carrier(drv_data, (u32)val);
+		else
+			return -EINVAL;
+		break;
+
+	case LIRC_GET_SEND_MODE:
+		val = LIRC_CAN_SEND_PULSE & LIRC_CAN_SEND_MASK;
+		ret = put_user(val, (unsigned long *)arg);
+		break;
+
+	case LIRC_SET_SEND_MODE:
+		ret = get_user(val, (unsigned long *)arg);
+		if (ret)
+			return ret;
+
+		if (val != (LIRC_MODE_PULSE & LIRC_CAN_SEND_MASK))
+			return -EINVAL;
+		break;
+
+	default:
+		return lirc_dev_fop_ioctl(node, filep, cmd, arg);
+	}
+
+	return ret;
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
+	.write		= ir_lirc_transmit_ir,
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
+	struct lirc_driver *drv;
+	struct lirc_buffer *rbuf;
+	int rc = -ENOMEM;
+	unsigned long features;
+
+	drv = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
+	if (!drv)
+		return rc;
+
+	rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
+	if (!drv)
+		goto rbuf_alloc_failed;
+
+	rc = lirc_buffer_init(rbuf, sizeof(int), LIRCBUF_SIZE);
+	if (rc)
+		goto rbuf_init_failed;
+
+	features = LIRC_CAN_REC_MODE2;
+	if (ir_dev->props->tx_ir) {
+		features |= LIRC_CAN_SEND_PULSE;
+		if (ir_dev->props->s_tx_mask)
+			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
+		if (ir_dev->props->s_tx_carrier)
+			features |= LIRC_CAN_SET_SEND_CARRIER;
+	}
+
+	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
+		 ir_dev->driver_name);
+	drv->minor = -1;
+	drv->features = features;
+	drv->data = &ir_dev->raw->lirc;
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
+	ir_dev->raw->lirc.drv = drv;
+	ir_dev->raw->lirc.ir_dev = ir_dev;
+	ir_dev->raw->lirc.lircdata = PULSE_MASK;
+
+	return 0;
+
+lirc_register_failed:
+rbuf_init_failed:
+	kfree(rbuf);
+rbuf_alloc_failed:
+	kfree(drv);
+
+	return rc;
+}
+
+static int ir_lirc_unregister(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct lirc_codec *lirc = &ir_dev->raw->lirc;
+
+	lirc_unregister_driver(lirc->drv->minor);
+	lirc_buffer_free(lirc->drv->rbuf);
+	kfree(lirc->drv);
+
+	return 0;
+}
+
+static struct ir_raw_handler lirc_handler = {
+	.protocols	= IR_TYPE_LIRC,
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
index 5f98ab8..6f192ef 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -253,6 +253,7 @@ static void init_decoders(struct work_struct *work)
 	load_rc6_decode();
 	load_jvc_decode();
 	load_sony_decode();
+	load_lirc_codec();
 
 	/* If needed, we may later add some init code. In this case,
 	   it is needed to change the CONFIG_MODULE test at ir-core.h
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index f73e4a6..a841e51 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -93,6 +93,11 @@ static ssize_t show_protocols(struct device *d,
 	else if (allowed & IR_TYPE_SONY)
 		tmp += sprintf(tmp, "sony ");
 
+	if (allowed & enabled & IR_TYPE_LIRC)
+		tmp += sprintf(tmp, "[lirc] ");
+	else if (allowed & IR_TYPE_LIRC)
+		tmp += sprintf(tmp, "lirc ");
+
 	if (tmp != buf)
 		tmp--;
 	*tmp = '\n';
@@ -160,6 +165,9 @@ static ssize_t store_protocols(struct device *d,
 	} else if (!strncasecmp(tmp, "sony", 4)) {
 		tmp += 4;
 		mask = IR_TYPE_SONY;
+	} else if (!strncasecmp(tmp, "lirc", 4)) {
+		tmp += 4;
+		mask = IR_TYPE_LIRC;
 	} else {
 		IR_dprintk(1, "Unknown protocol\n");
 		return -EINVAL;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 7abe12e..63b35e4 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -17,10 +17,12 @@
 #define IR_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
 #define IR_TYPE_JVC	(1  << 3)	/* JVC protocol */
 #define IR_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
+#define IR_TYPE_LIRC	(1  << 30)	/* Pass raw IR to lirc userspace */
 #define IR_TYPE_OTHER	(1u << 31)
 
 #define IR_TYPE_ALL (IR_TYPE_RC5 | IR_TYPE_NEC  | IR_TYPE_RC6  | \
-		     IR_TYPE_JVC | IR_TYPE_SONY | IR_TYPE_OTHER)
+		     IR_TYPE_JVC | IR_TYPE_SONY | IR_TYPE_LIRC | \
+		     IR_TYPE_OTHER)
 
 struct ir_scancode {
 	u32	scancode;
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com

