Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53621 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbdJ2U7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:59:05 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 13/28] media: lirc: lirc interface should not be a raw decoder
Date: Sun, 29 Oct 2017 20:59:03 +0000
Message-Id: <55962f5504fd604f1dbf95681ad9e344e8ac28e6.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc user interface exists as a raw decoder, which does not make
much sense for transmit-only devices.

In addition, we want to have lirc char devices for devices which do not
use raw IR, i.e. scancode only devices.

Note that rc-code, lirc_dev, ir-lirc-codec are now calling functions of
each other, so they've been merged into one module rc-core to avoid
circular dependencies.

Since ir-lirc-codec no longer exists as separate codec module, there is no
need for RC_DRIVER_IR_RAW_TX type drivers to call ir_raw_event_register().

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig              |  29 ++-----
 drivers/media/rc/Makefile             |   5 +-
 drivers/media/rc/ir-lirc-codec.c      | 137 +++++++++-------------------------
 drivers/media/rc/ir-mce_kbd-decoder.c |   6 --
 drivers/media/rc/lirc_dev.c           |  47 ++++--------
 drivers/media/rc/rc-core-priv.h       |  45 ++++++++---
 drivers/media/rc/rc-ir-raw.c          |  24 ++----
 drivers/media/rc/rc-main.c            |  52 ++++++-------
 include/media/lirc_dev.h              |  10 ---
 include/media/rc-core.h               |  33 ++++----
 10 files changed, 144 insertions(+), 244 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index afb3456d4e20..0f863822889e 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -16,34 +16,21 @@ menuconfig RC_CORE
 if RC_CORE
 source "drivers/media/rc/keymaps/Kconfig"
 
-menuconfig RC_DECODERS
-        bool "Remote controller decoders"
-	depends on RC_CORE
-	default y
-
-if RC_DECODERS
 config LIRC
-	tristate "LIRC interface driver"
+	bool "LIRC user interface"
 	depends on RC_CORE
-
 	---help---
-	   Enable this option to build the Linux Infrared Remote
-	   Control (LIRC) core device interface driver. The LIRC
-	   interface passes raw IR to and from userspace, where the
-	   LIRC daemon handles protocol decoding for IR reception and
-	   encoding for IR transmitting (aka "blasting").
+	   Enable this option to enable the Linux Infrared Remote
+	   Control user interface (e.g. /dev/lirc*). This interface
+	   passes raw IR to and from userspace, which is needed for
+	   IR transmitting (aka "blasting") and for the lirc daemon.
 
-config IR_LIRC_CODEC
-	tristate "Enable IR to LIRC bridge"
+menuconfig RC_DECODERS
+        bool "Remote controller decoders"
 	depends on RC_CORE
-	depends on LIRC
 	default y
 
-	---help---
-	   Enable this option to pass raw IR to and from userspace via
-	   the LIRC interface.
-
-
+if RC_DECODERS
 config IR_NEC_DECODER
 	tristate "Enable IR raw decoder for the NEC protocol"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 643797dc971b..a1ef86767aef 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,9 +1,9 @@
-rc-core-objs	:= rc-main.o rc-ir-raw.o
 
 obj-y += keymaps/
 
 obj-$(CONFIG_RC_CORE) += rc-core.o
-obj-$(CONFIG_LIRC) += lirc_dev.o
+rc-core-y := rc-main.o rc-ir-raw.o
+rc-core-$(CONFIG_LIRC) += lirc_dev.o ir-lirc-codec.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
@@ -12,7 +12,6 @@ obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
 obj-$(CONFIG_IR_SANYO_DECODER) += ir-sanyo-decoder.o
 obj-$(CONFIG_IR_SHARP_DECODER) += ir-sharp-decoder.o
 obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
-obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 obj-$(CONFIG_IR_XMP_DECODER) += ir-xmp-decoder.o
 
 # stand-alone IR receivers/transmitters
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index d733179e2a94..aec0109b1a69 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -14,7 +14,6 @@
 
 #include <linux/sched.h>
 #include <linux/wait.h>
-#include <linux/module.h>
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 #include <media/rc-core.h>
@@ -23,21 +22,15 @@
 #define LIRCBUF_SIZE 256
 
 /**
- * ir_lirc_decode() - Send raw IR data to lirc_dev to be relayed to the
- *		      lircd userspace daemon for decoding.
- * @input_dev:	the struct rc_dev descriptor of the device
- * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ * ir_lirc_raw_event() - Send raw IR data to lirc to be relayed to userspace
  *
- * This function returns -EINVAL if the lirc interfaces aren't wired up.
+ * @dev:	the struct rc_dev descriptor of the device
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
  */
-static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
+void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 {
-	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!dev->raw->lirc.ldev || !dev->raw->lirc.ldev->buf)
-		return -EINVAL;
-
 	/* Packet start */
 	if (ev.reset) {
 		/* Userspace expects a long space event before the start of
@@ -56,15 +49,15 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	/* Packet end */
 	} else if (ev.timeout) {
 
-		if (lirc->gap)
-			return 0;
+		if (dev->gap)
+			return;
 
-		lirc->gap_start = ktime_get();
-		lirc->gap = true;
-		lirc->gap_duration = ev.duration;
+		dev->gap_start = ktime_get();
+		dev->gap = true;
+		dev->gap_duration = ev.duration;
 
-		if (!lirc->send_timeout_reports)
-			return 0;
+		if (!dev->send_timeout_reports)
+			return;
 
 		sample = LIRC_TIMEOUT(ev.duration / 1000);
 		IR_dprintk(2, "timeout report (duration: %d)\n", sample);
@@ -72,21 +65,21 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	/* Normal sample */
 	} else {
 
-		if (lirc->gap) {
+		if (dev->gap) {
 			int gap_sample;
 
-			lirc->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
-				lirc->gap_start));
+			dev->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
+							 dev->gap_start));
 
 			/* Convert to ms and cap by LIRC_VALUE_MASK */
-			do_div(lirc->gap_duration, 1000);
-			lirc->gap_duration = min(lirc->gap_duration,
-							(u64)LIRC_VALUE_MASK);
+			do_div(dev->gap_duration, 1000);
+			dev->gap_duration = min_t(u64, dev->gap_duration,
+						  LIRC_VALUE_MASK);
 
-			gap_sample = LIRC_SPACE(lirc->gap_duration);
-			lirc_buffer_write(dev->raw->lirc.ldev->buf,
+			gap_sample = LIRC_SPACE(dev->gap_duration);
+			lirc_buffer_write(dev->lirc_dev->buf,
 					  (unsigned char *)&gap_sample);
-			lirc->gap = false;
+			dev->gap = false;
 		}
 
 		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
@@ -95,18 +88,16 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			   TO_US(ev.duration), TO_STR(ev.pulse));
 	}
 
-	lirc_buffer_write(dev->raw->lirc.ldev->buf,
+	lirc_buffer_write(dev->lirc_dev->buf,
 			  (unsigned char *) &sample);
-	wake_up(&dev->raw->lirc.ldev->buf->wait_poll);
 
-	return 0;
+	wake_up(&dev->lirc_dev->buf->wait_poll);
 }
 
 static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 				   size_t n, loff_t *ppos)
 {
-	struct lirc_codec *lirc;
-	struct rc_dev *dev;
+	struct rc_dev *dev = file->private_data;
 	unsigned int *txbuf = NULL;
 	struct ir_raw_event *raw = NULL;
 	ssize_t ret = -EINVAL;
@@ -118,22 +109,12 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 
 	start = ktime_get();
 
-	lirc = lirc_get_pdata(file);
-	if (!lirc)
-		return -EFAULT;
-
-	dev = lirc->dev;
-	if (!dev) {
-		ret = -EFAULT;
-		goto out;
-	}
-
 	if (!dev->tx_ir) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (lirc->send_mode == LIRC_MODE_SCANCODE) {
+	if (dev->send_mode == LIRC_MODE_SCANCODE) {
 		struct lirc_scancode scan;
 
 		if (n != sizeof(scan))
@@ -198,7 +179,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (ret < 0)
 		goto out;
 
-	if (lirc->send_mode == LIRC_MODE_SCANCODE) {
+	if (dev->send_mode == LIRC_MODE_SCANCODE) {
 		ret = n;
 	} else {
 		for (duration = i = 0; i < ret; i++)
@@ -228,20 +209,11 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			unsigned long arg)
 {
-	struct lirc_codec *lirc;
-	struct rc_dev *dev;
+	struct rc_dev *dev = filep->private_data;
 	u32 __user *argp = (u32 __user *)(arg);
 	int ret = 0;
 	__u32 val = 0, tmp;
 
-	lirc = lirc_get_pdata(filep);
-	if (!lirc)
-		return -EFAULT;
-
-	dev = lirc->dev;
-	if (!dev)
-		return -EFAULT;
-
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
 		ret = get_user(val, argp);
 		if (ret)
@@ -255,7 +227,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (!dev->tx_ir)
 			return -ENOTTY;
 
-		val = lirc->send_mode;
+		val = dev->send_mode;
 		break;
 
 	case LIRC_SET_SEND_MODE:
@@ -265,7 +237,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (!(val == LIRC_MODE_PULSE || val == LIRC_MODE_SCANCODE))
 			return -EINVAL;
 
-		lirc->send_mode = val;
+		dev->send_mode = val;
 		return 0;
 
 	/* TX settings */
@@ -299,7 +271,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			return -EINVAL;
 
 		return dev->s_rx_carrier_range(dev,
-					       dev->raw->lirc.carrier_low,
+					       dev->carrier_low,
 					       val);
 
 	case LIRC_SET_REC_CARRIER_RANGE:
@@ -309,7 +281,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (val <= 0)
 			return -EINVAL;
 
-		dev->raw->lirc.carrier_low = val;
+		dev->carrier_low = val;
 		return 0;
 
 	case LIRC_GET_REC_RESOLUTION:
@@ -367,7 +339,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (!dev->timeout)
 			return -ENOTTY;
 
-		lirc->send_timeout_reports = !!val;
+		dev->send_timeout_reports = !!val;
 		break;
 
 	default:
@@ -394,7 +366,7 @@ static const struct file_operations lirc_fops = {
 	.llseek		= no_llseek,
 };
 
-static int ir_lirc_register(struct rc_dev *dev)
+int ir_lirc_register(struct rc_dev *dev)
 {
 	struct lirc_dev *ldev;
 	int rc = -ENOMEM;
@@ -436,7 +408,6 @@ static int ir_lirc_register(struct rc_dev *dev)
 	snprintf(ldev->name, sizeof(ldev->name), "ir-lirc-codec (%s)",
 		 dev->driver_name);
 	ldev->features = features;
-	ldev->data = &dev->raw->lirc;
 	ldev->buf = NULL;
 	ldev->chunk_size = sizeof(int);
 	ldev->buffer_size = LIRCBUF_SIZE;
@@ -449,10 +420,8 @@ static int ir_lirc_register(struct rc_dev *dev)
 	if (rc < 0)
 		goto out;
 
-	dev->raw->lirc.send_mode = LIRC_MODE_PULSE;
-
-	dev->raw->lirc.ldev = ldev;
-	dev->raw->lirc.dev = dev;
+	dev->send_mode = LIRC_MODE_PULSE;
+	dev->lirc_dev = ldev;
 	return 0;
 
 out:
@@ -460,40 +429,8 @@ static int ir_lirc_register(struct rc_dev *dev)
 	return rc;
 }
 
-static int ir_lirc_unregister(struct rc_dev *dev)
-{
-	struct lirc_codec *lirc = &dev->raw->lirc;
-
-	lirc_unregister_device(lirc->ldev);
-	lirc->ldev = NULL;
-
-	return 0;
-}
-
-static struct ir_raw_handler lirc_handler = {
-	.protocols	= 0,
-	.decode		= ir_lirc_decode,
-	.raw_register	= ir_lirc_register,
-	.raw_unregister	= ir_lirc_unregister,
-};
-
-static int __init ir_lirc_codec_init(void)
-{
-	ir_raw_handler_register(&lirc_handler);
-
-	printk(KERN_INFO "IR LIRC bridge handler initialized\n");
-	return 0;
-}
-
-static void __exit ir_lirc_codec_exit(void)
+void ir_lirc_unregister(struct rc_dev *dev)
 {
-	ir_raw_handler_unregister(&lirc_handler);
+	lirc_unregister_device(dev->lirc_dev);
+	dev->lirc_dev = NULL;
 }
-
-module_init(ir_lirc_codec_init);
-module_exit(ir_lirc_codec_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
-MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
-MODULE_DESCRIPTION("LIRC IR handler bridge");
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index efa3b735dcc4..48eef43b0530 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -358,9 +358,6 @@ static int ir_mce_kbd_register(struct rc_dev *dev)
 	struct input_dev *idev;
 	int i, ret;
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
-		return 0;
-
 	idev = input_allocate_device();
 	if (!idev)
 		return -ENOMEM;
@@ -416,9 +413,6 @@ static int ir_mce_kbd_unregister(struct rc_dev *dev)
 	struct mce_kbd_dec *mce_kbd = &dev->raw->mce_kbd;
 	struct input_dev *idev = mce_kbd->idev;
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
-		return 0;
-
 	del_timer_sync(&mce_kbd->rx_timeout);
 	input_unregister_device(idev);
 
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index ef7e915dc9a2..3cc95deaa84e 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -26,7 +26,7 @@
 #include <linux/cdev.h>
 #include <linux/idr.h>
 
-#include <media/rc-core.h>
+#include "rc-core-priv.h"
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 
@@ -236,7 +236,7 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 
 	d->open++;
 
-	lirc_init_pdata(inode, file);
+	file->private_data = d->rdev;
 	nonseekable_open(inode, file);
 	mutex_unlock(&d->mutex);
 
@@ -250,11 +250,12 @@ EXPORT_SYMBOL(lirc_dev_fop_open);
 
 int lirc_dev_fop_close(struct inode *inode, struct file *file)
 {
-	struct lirc_dev *d = file->private_data;
+	struct rc_dev *rcdev = file->private_data;
+	struct lirc_dev *d = rcdev->lirc_dev;
 
 	mutex_lock(&d->mutex);
 
-	rc_close(d->rdev);
+	rc_close(rcdev);
 	d->open--;
 
 	mutex_unlock(&d->mutex);
@@ -265,7 +266,8 @@ EXPORT_SYMBOL(lirc_dev_fop_close);
 
 unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 {
-	struct lirc_dev *d = file->private_data;
+	struct rc_dev *rcdev = file->private_data;
+	struct lirc_dev *d = rcdev->lirc_dev;
 	unsigned int ret;
 
 	if (!d->attached)
@@ -290,7 +292,8 @@ EXPORT_SYMBOL(lirc_dev_fop_poll);
 
 long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct lirc_dev *d = file->private_data;
+	struct rc_dev *rcdev = file->private_data;
+	struct lirc_dev *d = rcdev->lirc_dev;
 	__u32 mode;
 	int result;
 
@@ -349,7 +352,8 @@ ssize_t lirc_dev_fop_read(struct file *file,
 			  size_t length,
 			  loff_t *ppos)
 {
-	struct lirc_dev *d = file->private_data;
+	struct rc_dev *rcdev = file->private_data;
+	struct lirc_dev *d = rcdev->lirc_dev;
 	unsigned char *buf;
 	int ret, written = 0;
 	DECLARE_WAITQUEUE(wait, current);
@@ -448,24 +452,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 }
 EXPORT_SYMBOL(lirc_dev_fop_read);
 
-void lirc_init_pdata(struct inode *inode, struct file *file)
-{
-	struct lirc_dev *d = container_of(inode->i_cdev, struct lirc_dev, cdev);
-
-	file->private_data = d;
-}
-EXPORT_SYMBOL(lirc_init_pdata);
-
-void *lirc_get_pdata(struct file *file)
-{
-	struct lirc_dev *d = file->private_data;
-
-	return d->data;
-}
-EXPORT_SYMBOL(lirc_get_pdata);
-
-
-static int __init lirc_dev_init(void)
+int __init lirc_dev_init(void)
 {
 	int retval;
 
@@ -489,16 +476,8 @@ static int __init lirc_dev_init(void)
 	return 0;
 }
 
-static void __exit lirc_dev_exit(void)
+void __exit lirc_dev_exit(void)
 {
 	class_destroy(lirc_class);
 	unregister_chrdev_region(lirc_base_dev, LIRC_MAX_DEVICES);
-	pr_info("module unloaded\n");
 }
-
-module_init(lirc_dev_init);
-module_exit(lirc_dev_exit);
-
-MODULE_DESCRIPTION("LIRC base driver module");
-MODULE_AUTHOR("Artur Lipowski");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index d29b1b1ef4b7..21e515d34f64 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -22,6 +22,20 @@
 #include <linux/slab.h>
 #include <media/rc-core.h>
 
+/**
+ * rc_open - Opens a RC device
+ *
+ * @rdev: pointer to struct rc_dev.
+ */
+int rc_open(struct rc_dev *rdev);
+
+/**
+ * rc_close - Closes a RC device
+ *
+ * @rdev: pointer to struct rc_dev.
+ */
+void rc_close(struct rc_dev *rdev);
+
 struct ir_raw_handler {
 	struct list_head list;
 
@@ -31,7 +45,7 @@ struct ir_raw_handler {
 		      struct ir_raw_event *events, unsigned int max);
 	u32 carrier;
 
-	/* These two should only be used by the lirc decoder */
+	/* These two should only be used by the mce kbd decoder */
 	int (*raw_register)(struct rc_dev *dev);
 	int (*raw_unregister)(struct rc_dev *dev);
 };
@@ -105,17 +119,6 @@ struct ir_raw_event_ctrl {
 		unsigned count;
 		unsigned wanted_bits;
 	} mce_kbd;
-	struct lirc_codec {
-		struct rc_dev *dev;
-		struct lirc_dev *ldev;
-		int carrier_low;
-
-		ktime_t gap_start;
-		u64 gap_duration;
-		bool gap;
-		bool send_timeout_reports;
-		u8 send_mode;
-	} lirc;
 	struct xmp_dec {
 		int state;
 		unsigned count;
@@ -275,6 +278,24 @@ void ir_raw_load_modules(u64 *protocols);
 void ir_raw_init(void);
 
 /*
+ * lirc interface
+ */
+#ifdef CONFIG_LIRC
+int lirc_dev_init(void);
+void lirc_dev_exit(void);
+void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
+int ir_lirc_register(struct rc_dev *dev);
+void ir_lirc_unregister(struct rc_dev *dev);
+#else
+static inline int lirc_dev_init(void) { return 0; }
+static inline void lirc_dev_exit(void) {}
+static inline void ir_lirc_raw_event(struct rc_dev *dev,
+				     struct ir_raw_event ev) { }
+static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
+static inline void ir_lirc_unregister(struct rc_dev *dev) { }
+#endif
+
+/*
  * Decoder initialization code
  *
  * Those load logic are called during ir-core init, and automatically
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index b84201cb012a..8d7fce5dd6ff 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -40,6 +40,7 @@ static int ir_raw_event_thread(void *data)
 				if (raw->dev->enabled_protocols &
 				    handler->protocols || !handler->protocols)
 					handler->decode(raw->dev, ev);
+			ir_lirc_raw_event(raw->dev, ev);
 			raw->prev_ev = ev;
 		}
 		mutex_unlock(&ir_raw_handler_lock);
@@ -529,16 +530,9 @@ EXPORT_SYMBOL(ir_raw_encode_carrier);
  */
 int ir_raw_event_prepare(struct rc_dev *dev)
 {
-	static bool raw_init; /* 'false' default value, raw decoders loaded? */
-
 	if (!dev)
 		return -EINVAL;
 
-	if (!raw_init) {
-		request_module("ir-lirc-codec");
-		raw_init = true;
-	}
-
 	dev->raw = kzalloc(sizeof(*dev->raw), GFP_KERNEL);
 	if (!dev->raw)
 		return -ENOMEM;
@@ -557,19 +551,11 @@ int ir_raw_event_register(struct rc_dev *dev)
 	struct ir_raw_handler *handler;
 	struct task_struct *thread;
 
-	/*
-	 * raw transmitters do not need any event registration
-	 * because the event is coming from userspace
-	 */
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		thread = kthread_run(ir_raw_event_thread, dev->raw, "rc%u",
-				     dev->minor);
+	thread = kthread_run(ir_raw_event_thread, dev->raw, "rc%u", dev->minor);
+	if (IS_ERR(thread))
+		return PTR_ERR(thread);
 
-		if (IS_ERR(thread))
-			return PTR_ERR(thread);
-
-		dev->raw->thread = thread;
-	}
+	dev->raw->thread = thread;
 
 	mutex_lock(&ir_raw_handler_lock);
 	list_add_tail(&dev->raw->list, &ir_raw_client_list);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 62102b3ef5aa..758c14b90a87 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -845,7 +845,6 @@ int rc_open(struct rc_dev *rdev)
 
 	return rval;
 }
-EXPORT_SYMBOL_GPL(rc_open);
 
 static int ir_open(struct input_dev *idev)
 {
@@ -865,7 +864,6 @@ void rc_close(struct rc_dev *rdev)
 		mutex_unlock(&rdev->lock);
 	}
 }
-EXPORT_SYMBOL_GPL(rc_close);
 
 static void ir_close(struct input_dev *idev)
 {
@@ -940,23 +938,6 @@ struct rc_filter_attribute {
 		.mask = (_mask),					\
 	}
 
-static bool lirc_is_present(void)
-{
-#if defined(CONFIG_LIRC_MODULE)
-	struct module *lirc;
-
-	mutex_lock(&module_mutex);
-	lirc = find_module("lirc_dev");
-	mutex_unlock(&module_mutex);
-
-	return lirc ? true : false;
-#elif defined(CONFIG_LIRC)
-	return true;
-#else
-	return false;
-#endif
-}
-
 /**
  * show_protocols() - shows the current IR protocol(s)
  * @device:	the device descriptor
@@ -1001,8 +982,10 @@ static ssize_t show_protocols(struct device *device,
 			allowed &= ~proto_names[i].type;
 	}
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW && lirc_is_present())
+#ifdef CONFIG_LIRC
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		tmp += sprintf(tmp, "[lirc] ");
+#endif
 
 	if (tmp != buf)
 		tmp--;
@@ -1759,8 +1742,7 @@ int rc_register_device(struct rc_dev *dev)
 		dev->sysfs_groups[attr++] = &rc_dev_wakeup_filter_attr_grp;
 	dev->sysfs_groups[attr++] = NULL;
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW ||
-	    dev->driver_type == RC_DRIVER_IR_RAW_TX) {
+	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		rc = ir_raw_event_prepare(dev);
 		if (rc < 0)
 			goto out_minor;
@@ -1787,19 +1769,28 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_dev;
 	}
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW ||
-	    dev->driver_type == RC_DRIVER_IR_RAW_TX) {
-		rc = ir_raw_event_register(dev);
+	/* Ensure that the lirc kfifo is setup before we start the thread */
+	if (dev->driver_type != RC_DRIVER_SCANCODE) {
+		rc = ir_lirc_register(dev);
 		if (rc < 0)
 			goto out_rx;
 	}
 
+	if (dev->driver_type == RC_DRIVER_IR_RAW) {
+		rc = ir_raw_event_register(dev);
+		if (rc < 0)
+			goto out_lirc;
+	}
+
 	IR_dprintk(1, "Registered rc%u (driver: %s)\n",
 		   dev->minor,
 		   dev->driver_name ? dev->driver_name : "unknown");
 
 	return 0;
 
+out_lirc:
+	if (dev->driver_type != RC_DRIVER_SCANCODE)
+		ir_lirc_unregister(dev);
 out_rx:
 	rc_free_rx_device(dev);
 out_dev:
@@ -1853,6 +1844,9 @@ void rc_unregister_device(struct rc_dev *dev)
 
 	rc_free_rx_device(dev);
 
+	if (dev->driver_type != RC_DRIVER_SCANCODE)
+		ir_lirc_unregister(dev);
+
 	device_del(&dev->dev);
 
 	ida_simple_remove(&rc_ida, dev->minor);
@@ -1875,6 +1869,13 @@ static int __init rc_core_init(void)
 		return rc;
 	}
 
+	rc = lirc_dev_init();
+	if (rc) {
+		pr_err("rc_core: unable to init lirc\n");
+		class_unregister(&rc_class);
+		return 0;
+	}
+
 	led_trigger_register_simple("rc-feedback", &led_feedback);
 	rc_map_register(&empty_map);
 
@@ -1883,6 +1884,7 @@ static int __init rc_core_init(void)
 
 static void __exit rc_core_exit(void)
 {
+	lirc_dev_exit();
 	class_unregister(&rc_class);
 	led_trigger_unregister_simple(led_feedback);
 	rc_map_unregister(&empty_map);
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 0a03dd9e5a68..dd0c078796e8 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -121,7 +121,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  *			Only used if @rbuf is NULL.
  * @chunk_size:		Size of each FIFO buffer.
  *			Only used if @rbuf is NULL.
- * @data:		private per-driver data
  * @buf:		if %NULL, lirc_dev will allocate and manage the buffer,
  *			otherwise allocated by the caller which will
  *			have to write to the buffer by other means, like irq's
@@ -146,7 +145,6 @@ struct lirc_dev {
 	struct lirc_buffer *buf;
 	bool buf_internal;
 
-	void *data;
 	struct rc_dev *rdev;
 	const struct file_operations *fops;
 	struct module *owner;
@@ -168,14 +166,6 @@ int lirc_register_device(struct lirc_dev *d);
 
 void lirc_unregister_device(struct lirc_dev *d);
 
-/* Must be called in the open fop before lirc_get_pdata() can be used */
-void lirc_init_pdata(struct inode *inode, struct file *file);
-
-/* Returns the private data stored in the lirc_dev
- * associated with the given device file pointer.
- */
-void *lirc_get_pdata(struct file *file);
-
 /* default file operations
  * used by drivers if they override only some operations
  */
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index ca48632ec8e2..5d6e415c7acc 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -20,6 +20,7 @@
 #include <linux/kfifo.h>
 #include <linux/time.h>
 #include <linux/timer.h>
+#include <media/lirc_dev.h>
 #include <media/rc-map.h>
 
 extern int rc_core_debug;
@@ -115,6 +116,15 @@ enum rc_filter_type {
  * @max_timeout: maximum timeout supported by device
  * @rx_resolution : resolution (in ns) of input sampler
  * @tx_resolution: resolution (in ns) of output sampler
+ * @lirc_dev: lirc char device
+ * @carrier_low: when setting the carrier range, first the low end must be
+ *	set with an ioctl and then the high end with another ioctl
+ * @gap_start: time when gap starts
+ * @gap_duration: duration of initial gap
+ * @gap: true if we're in a gap
+ * @send_timeout_reports: report timeouts in lirc raw IR.
+ * @send_mode: lirc mode for sending, either LIRC_MODE_SCANCODE or
+ *	LIRC_MODE_PULSE
  * @change_protocol: allow changing the protocol used on hardware decoders
  * @open: callback to allow drivers to enable polling/irq when IR input device
  *	is opened.
@@ -174,6 +184,15 @@ struct rc_dev {
 	u32				max_timeout;
 	u32				rx_resolution;
 	u32				tx_resolution;
+#ifdef CONFIG_LIRC
+	struct lirc_dev			*lirc_dev;
+	int				carrier_low;
+	ktime_t				gap_start;
+	u64				gap_duration;
+	bool				gap;
+	bool				send_timeout_reports;
+	u8				send_mode;
+#endif
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_proto);
 	int				(*open)(struct rc_dev *dev);
 	void				(*close)(struct rc_dev *dev);
@@ -248,20 +267,6 @@ int devm_rc_register_device(struct device *parent, struct rc_dev *dev);
  */
 void rc_unregister_device(struct rc_dev *dev);
 
-/**
- * rc_open - Opens a RC device
- *
- * @rdev: pointer to struct rc_dev.
- */
-int rc_open(struct rc_dev *rdev);
-
-/**
- * rc_close - Closes a RC device
- *
- * @rdev: pointer to struct rc_dev.
- */
-void rc_close(struct rc_dev *rdev);
-
 void rc_repeat(struct rc_dev *dev);
 void rc_keydown(struct rc_dev *dev, enum rc_proto protocol, u32 scancode,
 		u8 toggle);
-- 
2.13.6
