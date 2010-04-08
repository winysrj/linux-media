Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316Ab0DHTha (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Apr 2010 15:37:30 -0400
Date: Thu, 8 Apr 2010 16:37:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 8/8] V4L/DVB: ir-core: move subsystem internal calls to
 ir-core-priv.h
Message-ID: <20100408163716.70862743@pedra>
In-Reply-To: <cover.1270754989.git.mchehab@redhat.com>
References: <cover.1270754989.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir-core.h has the kABI to be used by the bridge drivers, when needing to register
IR protocols and pass IR events. However, the same file also contains IR subsystem
internal calls, meant to be used inside ir-core and between ir-core and the raw
decoders.

Better to move those functions to an internal header, for some reasons:

1) Header will be a little more cleaner;

2) It avoids the need of recompile everything (bridge/hardware drivers, etc),
   just because a new decoder were added, or some other internal change were needed;

3) Better organize the ir-core API, splitting the functions that are internal to
   IR core and the ancillary drivers (decoders, lirc_dev) from the features that
   should be exported to IR subsystem clients.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 drivers/media/IR/ir-core-priv.h

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
new file mode 100644
index 0000000..ab785bc
--- /dev/null
+++ b/drivers/media/IR/ir-core-priv.h
@@ -0,0 +1,112 @@
+/*
+ * Remote Controller core raw events header
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
+#ifndef _IR_RAW_EVENT
+#define _IR_RAW_EVENT
+
+#include <media/ir-core.h>
+
+struct ir_raw_handler {
+	struct list_head list;
+
+	int (*decode)(struct input_dev *input_dev, s64 duration);
+	int (*raw_register)(struct input_dev *input_dev);
+	int (*raw_unregister)(struct input_dev *input_dev);
+};
+
+struct ir_raw_event_ctrl {
+	struct work_struct		rx_work;	/* for the rx decoding workqueue */
+	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
+	ktime_t				last_event;	/* when last event occurred */
+	enum raw_event_type		last_type;	/* last event type */
+	struct input_dev		*input_dev;	/* pointer to the parent input_dev */
+};
+
+/* macros for IR decoders */
+#define PULSE(units)				((units))
+#define SPACE(units)				(-(units))
+#define IS_RESET(duration)			((duration) == 0)
+#define IS_PULSE(duration)			((duration) > 0)
+#define IS_SPACE(duration)			((duration) < 0)
+#define DURATION(duration)			(abs((duration)))
+#define IS_TRANSITION(x, y)			((x) * (y) < 0)
+#define DECREASE_DURATION(duration, amount)			\
+	do {							\
+		if (IS_SPACE(duration))				\
+			duration += (amount);			\
+		else if (IS_PULSE(duration))			\
+			duration -= (amount);			\
+	} while (0)
+
+#define TO_UNITS(duration, unit_len)				\
+	((int)((duration) > 0 ?					\
+		DIV_ROUND_CLOSEST(abs((duration)), (unit_len)) :\
+		-DIV_ROUND_CLOSEST(abs((duration)), (unit_len))))
+#define TO_US(duration)		((int)TO_UNITS(duration, 1000))
+
+/*
+ * Routines from ir-keytable.c to be used internally on ir-core and decoders
+ */
+
+u32 ir_g_keycode_from_table(struct input_dev *input_dev,
+			    u32 scancode);
+void ir_repeat(struct input_dev *dev);
+void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
+
+/*
+ * Routines from ir-sysfs.c - Meant to be called only internally inside
+ * ir-core
+ */
+
+int ir_register_class(struct input_dev *input_dev);
+void ir_unregister_class(struct input_dev *input_dev);
+
+/*
+ * Routines from ir-raw-event.c to be used internally and by decoders
+ */
+int ir_raw_event_register(struct input_dev *input_dev);
+void ir_raw_event_unregister(struct input_dev *input_dev);
+static inline void ir_raw_event_reset(struct input_dev *input_dev)
+{
+	ir_raw_event_store(input_dev, 0);
+	ir_raw_event_handle(input_dev);
+}
+int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
+void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
+void ir_raw_init(void);
+
+
+/*
+ * Decoder initialization code
+ *
+ * Those load logic are called during ir-core init, and automatically
+ * loads the compiled decoders for their usage with IR raw events
+ */
+
+/* from ir-nec-decoder.c */
+#ifdef CONFIG_IR_NEC_DECODER_MODULE
+#define load_nec_decode()	request_module("ir-nec-decoder")
+#else
+#define load_nec_decode()	0
+#endif
+
+/* from ir-rc5-decoder.c */
+#ifdef CONFIG_IR_RC5_DECODER_MODULE
+#define load_rc5_decode()	request_module("ir-rc5-decoder")
+#else
+#define load_rc5_decode()	0
+#endif
+
+#endif /* _IR_RAW_EVENT */
diff --git a/drivers/media/IR/ir-functions.c b/drivers/media/IR/ir-functions.c
index ab06919..db591e4 100644
--- a/drivers/media/IR/ir-functions.c
+++ b/drivers/media/IR/ir-functions.c
@@ -24,6 +24,7 @@
 #include <linux/string.h>
 #include <linux/jiffies.h>
 #include <media/ir-common.h>
+#include "ir-core-priv.h"
 
 /* -------------------------------------------------------------------------- */
 
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 67b2aa1..01bddc4 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -14,7 +14,7 @@
 
 
 #include <linux/input.h>
-#include <media/ir-common.h>
+#include "ir-core-priv.h"
 
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
 #define IR_TAB_MIN_SIZE	256
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 5085f90..f22d1af 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -12,8 +12,8 @@
  *  GNU General Public License for more details.
  */
 
-#include <media/ir-core.h>
 #include <linux/bitrev.h>
+#include "ir-core-priv.h"
 
 #define NEC_NBITS		32
 #define NEC_UNIT		562500  /* ns */
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 3a25d8d..2efc051 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -12,10 +12,10 @@
  *  GNU General Public License for more details.
  */
 
-#include <media/ir-core.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/sched.h>
+#include "ir-core-priv.h"
 
 /* Define the max number of pulse/space transitions to buffer */
 #define MAX_IR_EVENT_SIZE      512
diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
index d6def8c..59bcaa9 100644
--- a/drivers/media/IR/ir-rc5-decoder.c
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -19,7 +19,7 @@
  * the first two bits are start bits, and a third one is a filing bit
  */
 
-#include <media/ir-core.h>
+#include "ir-core-priv.h"
 
 #define RC5_NBITS		14
 #define RC5_UNIT		888888 /* ns */
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 17d4341..a222d4f 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -14,7 +14,7 @@
 
 #include <linux/input.h>
 #include <linux/device.h>
-#include <media/ir-core.h>
+#include "ir-core-priv.h"
 
 #define IRRCV_NUM_DEVICES	256
 
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index e9a0cbf..40b6250 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -31,13 +31,6 @@ enum rc_driver_type {
 	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
 };
 
-enum raw_event_type {
-	IR_SPACE	= (1 << 0),
-	IR_PULSE	= (1 << 1),
-	IR_START_EVENT	= (1 << 2),
-	IR_STOP_EVENT	= (1 << 3),
-};
-
 /**
  * struct ir_dev_props - Allow caller drivers to set special properties
  * @driver_type: specifies if the driver or hardware have already a decoder,
@@ -65,14 +58,6 @@ struct ir_dev_props {
 	void			(*close)(void *priv);
 };
 
-struct ir_raw_event_ctrl {
-	struct work_struct		rx_work;	/* for the rx decoding workqueue */
-	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
-	ktime_t				last_event;	/* when last event occurred */
-	enum raw_event_type		last_type;	/* last event type */
-	struct input_dev		*input_dev;	/* pointer to the parent input_dev */
-};
-
 struct ir_input_dev {
 	struct device			dev;		/* device */
 	char				*driver_name;	/* Name of the driver module */
@@ -92,22 +77,16 @@ struct ir_input_dev {
 	u8				last_toggle;	/* toggle of last command */
 };
 
-struct ir_raw_handler {
-	struct list_head list;
-
-	int (*decode)(struct input_dev *input_dev, s64 duration);
-	int (*raw_register)(struct input_dev *input_dev);
-	int (*raw_unregister)(struct input_dev *input_dev);
+enum raw_event_type {
+	IR_SPACE        = (1 << 0),
+	IR_PULSE        = (1 << 1),
+	IR_START_EVENT  = (1 << 2),
+	IR_STOP_EVENT   = (1 << 3),
 };
 
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
 
-/* Routines from ir-keytable.c */
-
-u32 ir_g_keycode_from_table(struct input_dev *input_dev,
-			    u32 scancode);
-void ir_repeat(struct input_dev *dev);
-void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
+/* From ir-keytable.c */
 int __ir_input_register(struct input_dev *dev,
 		      const struct ir_scancode_table *ir_codes,
 		      const struct ir_dev_props *props,
@@ -143,60 +122,11 @@ static inline int ir_input_register(struct input_dev *dev,
 
 void ir_input_unregister(struct input_dev *input_dev);
 
-/* Routines from ir-sysfs.c */
+/* From ir-raw-event.c */
 
-int ir_register_class(struct input_dev *input_dev);
-void ir_unregister_class(struct input_dev *input_dev);
-
-/* Routines from ir-raw-event.c */
-int ir_raw_event_register(struct input_dev *input_dev);
-void ir_raw_event_unregister(struct input_dev *input_dev);
 void ir_raw_event_handle(struct input_dev *input_dev);
 int ir_raw_event_store(struct input_dev *input_dev, s64 duration);
 int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
-static inline void ir_raw_event_reset(struct input_dev *input_dev)
-{
-	ir_raw_event_store(input_dev, 0);
-	ir_raw_event_handle(input_dev);
-}
-int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
-void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
-void ir_raw_init(void);
 
-/* from ir-nec-decoder.c */
-#ifdef CONFIG_IR_NEC_DECODER_MODULE
-#define load_nec_decode()	request_module("ir-nec-decoder")
-#else
-#define load_nec_decode()	0
-#endif
-
-/* from ir-rc5-decoder.c */
-#ifdef CONFIG_IR_RC5_DECODER_MODULE
-#define load_rc5_decode()	request_module("ir-rc5-decoder")
-#else
-#define load_rc5_decode()	0
-#endif
-
-/* macros for ir decoders */
-#define PULSE(units)				((units))
-#define SPACE(units)				(-(units))
-#define IS_RESET(duration)			((duration) == 0)
-#define IS_PULSE(duration)			((duration) > 0)
-#define IS_SPACE(duration)			((duration) < 0)
-#define DURATION(duration)			(abs((duration)))
-#define IS_TRANSITION(x, y)			((x) * (y) < 0)
-#define DECREASE_DURATION(duration, amount)			\
-	do {							\
-		if (IS_SPACE(duration))				\
-			duration += (amount);			\
-		else if (IS_PULSE(duration))			\
-			duration -= (amount);			\
-	} while (0)
-
-#define TO_UNITS(duration, unit_len)				\
-	((int)((duration) > 0 ?					\
-		DIV_ROUND_CLOSEST(abs((duration)), (unit_len)) :\
-		-DIV_ROUND_CLOSEST(abs((duration)), (unit_len))))
-#define TO_US(duration)		((int)TO_UNITS(duration, 1000))
 
 #endif /* _IR_CORE */
-- 
1.6.6.1

