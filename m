Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:44805 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032317AbdAFMtO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jan 2017 07:49:14 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/9] [media] lirc: lirc interface should not be a raw decoder
Date: Fri,  6 Jan 2017 12:49:04 +0000
Message-Id: <e4c35a88f4d76c314a24222f28f93e10eeb6430d.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc bridge exists as a raw decoder. We would like to make the bridge
to also work for scancode drivers in further commits, so it cannot be
a raw decoder.

Note that rc-code, lirc_dev, ir-lirc-codec are now calling functions of
each other, so they've been merged into one module rc-core to avoid
circular dependencies.

Since ir-lirc-codec no longer exists as separate codec module, there is no
need for RC_DRIVER_IR_RAW_TX type drivers to call ir_raw_event_register().

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig         | 15 ++++++------
 drivers/media/rc/Makefile        |  6 ++---
 drivers/media/rc/ir-lirc-codec.c | 38 ++++---------------------------
 drivers/media/rc/lirc_dev.c      | 22 +++---------------
 drivers/media/rc/rc-core-priv.h  | 24 +++++++++++++++++++-
 drivers/media/rc/rc-ir-raw.c     | 17 +++++---------
 drivers/media/rc/rc-main.c       | 49 ++++++++++++++++++++--------------------
 7 files changed, 71 insertions(+), 100 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index d0ddbd3..b2607c7 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -6,14 +6,8 @@ config RC_CORE
 
 source "drivers/media/rc/keymaps/Kconfig"
 
-menuconfig RC_DECODERS
-        bool "Remote controller decoders"
-	depends on RC_CORE
-	default y
-
-if RC_DECODERS
 config LIRC
-	tristate "LIRC interface driver"
+	bool "LIRC interface driver"
 	depends on RC_CORE
 
 	---help---
@@ -24,7 +18,7 @@ config LIRC
 	   encoding for IR transmitting (aka "blasting").
 
 config IR_LIRC_CODEC
-	tristate "Enable IR to LIRC bridge"
+	bool "Enable IR to LIRC bridge"
 	depends on RC_CORE
 	depends on LIRC
 	default y
@@ -33,7 +27,12 @@ config IR_LIRC_CODEC
 	   Enable this option to pass raw IR to and from userspace via
 	   the LIRC interface.
 
+menuconfig RC_DECODERS
+	bool "Remote controller decoders"
+	depends on RC_CORE
+	default y
 
+if RC_DECODERS
 config IR_NEC_DECODER
 	tristate "Enable IR raw decoder for the NEC protocol"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 938c98b..cbb2da0 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,9 +1,10 @@
-rc-core-objs	:= rc-main.o rc-ir-raw.o
 
 obj-y += keymaps/
 
 obj-$(CONFIG_RC_CORE) += rc-core.o
-obj-$(CONFIG_LIRC) += lirc_dev.o
+rc-core-y := rc-main.o rc-ir-raw.o
+rc-core-$(CONFIG_LIRC) += lirc_dev.o
+rc-core-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
@@ -12,7 +13,6 @@ obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
 obj-$(CONFIG_IR_SANYO_DECODER) += ir-sanyo-decoder.o
 obj-$(CONFIG_IR_SHARP_DECODER) += ir-sharp-decoder.o
 obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
-obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 obj-$(CONFIG_IR_XMP_DECODER) += ir-xmp-decoder.o
 
 # stand-alone IR receivers/transmitters
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 9e41305..c3a2a6d 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -14,7 +14,6 @@
 
 #include <linux/sched.h>
 #include <linux/wait.h>
-#include <linux/module.h>
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 #include <media/rc-core.h>
@@ -23,14 +22,14 @@
 #define LIRCBUF_SIZE 256
 
 /**
- * ir_lirc_decode() - Send raw IR data to lirc_dev to be relayed to the
- *		      lircd userspace daemon for decoding.
+ * ir_lirc_raw_event() - Send raw IR data to lirc to be relayed to userspace
+ *
  * @input_dev:	the struct rc_dev descriptor of the device
  * @duration:	the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the lirc interfaces aren't wired up.
  */
-static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
+int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
@@ -342,7 +341,7 @@ static const struct file_operations lirc_fops = {
 	.llseek		= no_llseek,
 };
 
-static int ir_lirc_register(struct rc_dev *dev)
+int ir_lirc_register(struct rc_dev *dev)
 {
 	struct lirc_driver *drv;
 	struct lirc_buffer *rbuf;
@@ -418,7 +417,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 	return rc;
 }
 
-static int ir_lirc_unregister(struct rc_dev *dev)
+int ir_lirc_unregister(struct rc_dev *dev)
 {
 	struct lirc_codec *lirc = &dev->raw->lirc;
 
@@ -430,30 +429,3 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 	return 0;
 }
 
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
-{
-	ir_raw_handler_unregister(&lirc_handler);
-}
-
-module_init(ir_lirc_codec_init);
-module_exit(ir_lirc_codec_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
-MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
-MODULE_DESCRIPTION("LIRC IR handler bridge");
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 7f5d109..5884f0e 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -37,12 +37,10 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 
-#include <media/rc-core.h>
+#include "rc-core-priv.h"
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 
-static bool debug;
-
 #define IRCTL_DEV_NAME	"BaseRemoteCtl"
 #define NOPLUG		-1
 #define LOGHEAD		"lirc_dev (%s[%d]): "
@@ -763,7 +761,7 @@ ssize_t lirc_dev_fop_write(struct file *file, const char __user *buffer,
 EXPORT_SYMBOL(lirc_dev_fop_write);
 
 
-static int __init lirc_dev_init(void)
+int __init lirc_dev_init(void)
 {
 	int retval;
 
@@ -781,28 +779,14 @@ static int __init lirc_dev_init(void)
 		return retval;
 	}
 
-
 	pr_info("IR Remote Control driver registered, major %d\n",
 						MAJOR(lirc_base_dev));
 
 	return 0;
 }
 
-
-
-static void __exit lirc_dev_exit(void)
+void __exit lirc_dev_exit(void)
 {
 	class_destroy(lirc_class);
 	unregister_chrdev_region(lirc_base_dev, MAX_IRCTL_DEVICES);
-	pr_info("module unloaded\n");
 }
-
-module_init(lirc_dev_init);
-module_exit(lirc_dev_exit);
-
-MODULE_DESCRIPTION("LIRC base driver module");
-MODULE_AUTHOR("Artur Lipowski");
-MODULE_LICENSE("GPL");
-
-module_param(debug, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "Enable debugging messages");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index a70a5c55..6819310 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -30,7 +30,7 @@ struct ir_raw_handler {
 	int (*encode)(enum rc_type protocol, u32 scancode,
 		      struct ir_raw_event *events, unsigned int max);
 
-	/* These two should only be used by the lirc decoder */
+	/* These two should only be used by the mce kbd decoder */
 	int (*raw_register)(struct rc_dev *dev);
 	int (*raw_unregister)(struct rc_dev *dev);
 };
@@ -270,6 +270,28 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_init(void);
 
 /*
+ * lirc interface bridge
+ */
+#ifdef CONFIG_IR_LIRC_CODEC
+int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
+int ir_lirc_register(struct rc_dev *dev);
+int ir_lirc_unregister(struct rc_dev *dev);
+#else
+static inline int ir_lirc_raw_event(struct rc_dev *dev,
+				    struct ir_raw_event ev) { return 0; }
+static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
+static inline int ir_lirc_unregister(struct rc_dev *dev) { return 0; }
+#endif
+
+#ifdef CONFIG_LIRC
+int lirc_dev_init(void);
+void lirc_dev_exit(void);
+#else
+static inline int lirc_dev_init(void) { return 0; }
+static inline void lirc_dev_exit(void) {}
+#endif
+
+/*
  * Decoder initialization code
  *
  * Those load logic are called during ir-core init, and automatically
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 7fa84b6..2421258 100644
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
@@ -502,18 +503,12 @@ int ir_raw_event_register(struct rc_dev *dev)
 	dev->change_protocol = change_protocol;
 	INIT_KFIFO(dev->raw->kfifo);
 
-	/*
-	 * raw transmitters do not need any event registration
-	 * because the event is coming from userspace
-	 */
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-					       "rc%u", dev->minor);
+	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
+				       "rc%u", dev->minor);
 
-		if (IS_ERR(dev->raw->thread)) {
-			rc = PTR_ERR(dev->raw->thread);
-			goto out;
-		}
+	if (IS_ERR(dev->raw->thread)) {
+		rc = PTR_ERR(dev->raw->thread);
+		goto out;
 	}
 
 	mutex_lock(&ir_raw_handler_lock);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 075d7a9..b135365 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -903,23 +903,6 @@ struct rc_filter_attribute {
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
@@ -971,8 +954,10 @@ static ssize_t show_protocols(struct device *device,
 			allowed &= ~proto_names[i].type;
 	}
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW && lirc_is_present())
+#ifdef CONFIG_IR_LIRC_CODEC
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		tmp += sprintf(tmp, "[lirc] ");
+#endif
 
 	if (tmp != buf)
 		tmp--;
@@ -1742,7 +1727,6 @@ static void rc_free_rx_device(struct rc_dev *dev)
 
 int rc_register_device(struct rc_dev *dev)
 {
-	static bool raw_init; /* 'false' default value, raw decoders loaded? */
 	const char *path;
 	int attr = 0;
 	int minor;
@@ -1784,17 +1768,18 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_dev;
 	}
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW ||
-	    dev->driver_type == RC_DRIVER_IR_RAW_TX) {
-		if (!raw_init) {
-			request_module_nowait("ir-lirc-codec");
-			raw_init = true;
-		}
+	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		rc = ir_raw_event_register(dev);
 		if (rc < 0)
 			goto out_rx;
 	}
 
+	if (dev->driver_type != RC_DRIVER_SCANCODE) {
+		rc = ir_lirc_register(dev);
+		if (rc < 0)
+			goto out_raw;
+	}
+
 	/* Allow the RC sysfs nodes to be accessible */
 	atomic_set(&dev->initialized, 1);
 
@@ -1804,6 +1789,9 @@ int rc_register_device(struct rc_dev *dev)
 
 	return 0;
 
+out_raw:
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		ir_raw_event_unregister(dev);
 out_rx:
 	rc_free_rx_device(dev);
 out_dev:
@@ -1851,6 +1839,9 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
+	if (dev->driver_type != RC_DRIVER_SCANCODE)
+		ir_lirc_unregister(dev);
+
 	rc_free_rx_device(dev);
 
 	device_del(&dev->dev);
@@ -1875,6 +1866,13 @@ static int __init rc_core_init(void)
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
 
@@ -1883,6 +1881,7 @@ static int __init rc_core_init(void)
 
 static void __exit rc_core_exit(void)
 {
+	lirc_dev_exit();
 	class_unregister(&rc_class);
 	led_trigger_unregister_simple(led_feedback);
 	rc_map_unregister(&empty_map);
-- 
2.9.3

