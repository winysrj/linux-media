Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758053Ab0DAR6A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:00 -0400
Date: Thu, 1 Apr 2010 14:56:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/15] V4L/DVB: ir-core: dynamically load the compiled IR
 protocols
Message-ID: <20100401145632.09268907@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of hardcoding the protocols into ir-core, add a register interface
for the IR protocol decoders, and convert ir-nec-decoder into a client of
ir-core.

With this approach, it is possible to dynamically load the needed IR protocols,
and to add a RAW IR interface module, registered as one IR raw protocol decoder.

This patch opens a way to register a lirc_dev interface to work as an userspace
IR protocol decoder.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index 4dde7d1..de410d4 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -7,3 +7,12 @@ config VIDEO_IR
 	tristate
 	depends on IR_CORE
 	default IR_CORE
+
+config IR_NEC_DECODER
+	tristate "Enable IR raw decoder for NEC protocol"
+	depends on IR_CORE
+	default y
+
+	---help---
+	   Enable this option if you have IR with NEC protocol, and
+	   if the IR is decoded in software
diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 18794c7..6140b27 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -1,5 +1,6 @@
 ir-common-objs  := ir-functions.o ir-keymaps.o
-ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o ir-nec-decoder.o
+ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o
 
 obj-$(CONFIG_IR_CORE) += ir-core.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
+obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 104482a..c9a986d 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -1,4 +1,4 @@
-/* ir-raw-event.c - handle IR Pulse/Space event
+/* ir-nec-decoder.c - handle NEC IR Pulse/Space protocol
  *
  * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
  *
@@ -147,7 +147,7 @@ static int __ir_nec_decode(struct input_dev *input_dev,
 		if (++count == 32)
 			break;
 	}
-	*pos++;
+	(*pos)++;
 
 	/*
 	 * Fixme: may need to accept Extended NEC protocol?
@@ -181,9 +181,9 @@ err:
  * This function returns the number of decoded pulses or -EINVAL if no
  * pulse got decoded
  */
-int ir_nec_decode(struct input_dev *input_dev,
-			   struct ir_raw_event *evs,
-			   int len)
+static int ir_nec_decode(struct input_dev *input_dev,
+			 struct ir_raw_event *evs,
+			 int len)
 {
 	int pos = 0;
 	int rc = 0;
@@ -198,4 +198,27 @@ int ir_nec_decode(struct input_dev *input_dev,
 	return rc;
 }
 
-EXPORT_SYMBOL_GPL(ir_nec_decode);
+static struct ir_raw_handler nec_handler = {
+	.decode = ir_nec_decode,
+};
+
+static int __init ir_nec_decode_init(void)
+{
+	ir_raw_handler_register(&nec_handler);
+
+	printk(KERN_INFO "IR NEC protocol handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_nec_decode_exit(void)
+{
+	ir_raw_handler_unregister(&nec_handler);
+}
+
+module_init(ir_nec_decode_init);
+module_exit(ir_nec_decode_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
+MODULE_DESCRIPTION("NEC IR protocol decoder");
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 0ae5543..3eae128 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -13,10 +13,18 @@
  */
 
 #include <media/ir-core.h>
+#include <linux/workqueue.h>
 
 /* Define the max number of bit transitions per IR keycode */
 #define MAX_IR_EVENT_SIZE	256
 
+/* Used to handle IR raw handler extensions */
+static LIST_HEAD(ir_raw_handler_list);
+static DEFINE_MUTEX(ir_raw_handler_lock);
+
+/* Used to load the decoders */
+static struct work_struct wq_load;
+
 static void ir_keyup_timer(unsigned long data)
 {
 	struct input_dev *input_dev = (struct input_dev *)data;
@@ -101,6 +109,7 @@ int ir_raw_event_handle(struct input_dev *input_dev)
 	int				rc;
 	struct ir_raw_event		*evs;
 	int 				len, i;
+	struct ir_raw_handler		*ir_raw_handler;
 
 	/*
 	 * Store the events into a temporary buffer. This allows calling more than
@@ -122,10 +131,56 @@ int ir_raw_event_handle(struct input_dev *input_dev)
 			evs[i].type, (evs[i].delta.tv_nsec + 500) / 1000);
 	}
 
-	rc = ir_nec_decode(input_dev, evs, len);
+	/*
+	 * Call all ir decoders. This allows decoding the same event with
+	 * more than one protocol handler.
+	 * FIXME: better handle the returned code: does it make sense to use
+	 * other decoders, if the first one already handled the IR?
+	 */
+	list_for_each_entry(ir_raw_handler, &ir_raw_handler_list, list) {
+		rc = ir_raw_handler->decode(input_dev, evs, len);
+	}
 
 	kfree(evs);
 
 	return rc;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_handle);
+
+/*
+ * Extension interface - used to register the IR decoders
+ */
+
+int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
+{
+	mutex_lock(&ir_raw_handler_lock);
+	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
+	mutex_unlock(&ir_raw_handler_lock);
+	return 0;
+}
+EXPORT_SYMBOL(ir_raw_handler_register);
+
+void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
+{
+	mutex_lock(&ir_raw_handler_lock);
+	list_del(&ir_raw_handler->list);
+	mutex_unlock(&ir_raw_handler_lock);
+}
+EXPORT_SYMBOL(ir_raw_handler_unregister);
+
+static void init_decoders(struct work_struct *work)
+{
+	/* Load the decoder modules */
+
+	load_nec_decode();
+
+	/* If needed, we may later add some init code. In this case,
+	   it is needed to change the CONFIG_MODULE test at ir-core.h
+	 */
+}
+
+void ir_raw_init(void)
+{
+	INIT_WORK(&wq_load, init_decoders);
+	schedule_work(&wq_load);
+}
\ No newline at end of file
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index ee6b36d..2dbce59 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -1,6 +1,6 @@
 /* ir-register.c - handle IR scancode->keycode tables
  *
- * Copyright (C) 2009 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -27,7 +27,7 @@ static char *ir_devnode(struct device *dev, mode_t *mode)
 	return kasprintf(GFP_KERNEL, "irrcv/%s", dev_name(dev));
 }
 
-struct class ir_input_class = {
+static struct class ir_input_class = {
 	.name		= "irrcv",
 	.devnode	= ir_devnode,
 };
@@ -250,6 +250,9 @@ static int __init ir_core_init(void)
 		return rc;
 	}
 
+	/* Initialize/load the decoders that will be used */
+	ir_raw_init();
+
 	return 0;
 }
 
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 8d8ed7e..c377bf4 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -1,6 +1,8 @@
 /*
  * Remote Controller core header
  *
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
  *  the Free Software Foundation version 2 of the License.
@@ -80,6 +82,14 @@ struct ir_input_dev {
 	int				keypressed;	/* current state */
 };
 
+struct ir_raw_handler {
+	struct list_head list;
+
+	int (*decode)(struct input_dev *input_dev,
+		      struct ir_raw_event *evs,
+		      int len);
+};
+
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
 
 /* Routines from ir-keytable.c */
@@ -104,11 +114,20 @@ int ir_raw_event_register(struct input_dev *input_dev);
 void ir_raw_event_unregister(struct input_dev *input_dev);
 int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type);
 int ir_raw_event_handle(struct input_dev *input_dev);
+int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
+void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
+
+#ifdef MODULE
+void ir_raw_init(void);
+#else
+#define ir_raw_init() 0
+#endif
 
 /* from ir-nec-decoder.c */
-int ir_nec_decode(struct input_dev *input_dev,
-		  struct ir_raw_event *evs,
-		  int len);
-
-
+#ifdef CONFIG_IR_NEC_DECODER_MODULE
+#define load_nec_decode()	request_module("ir-nec-decoder")
+#else
+#define load_nec_decode()	0
 #endif
+
+#endif /* _IR_CORE */
-- 
1.6.6.1


