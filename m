Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44274 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab2EWJyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:51 -0400
Subject: [PATCH 43/43] rc-core: make rc-core.h userspace friendly
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:45:46 +0200
Message-ID: <20120523094546.14474.89782.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few ifdef __KERNEL__ and some reorganisation to make rc-core.h usable from
userspace programs.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 include/media/rc-core.h |   76 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 22 deletions(-)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index e311242..0685a4c 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -16,20 +16,21 @@
 #ifndef _RC_CORE
 #define _RC_CORE
 
+#ifdef __KERNEL__
 #include <linux/spinlock.h>
 #include <linux/kfifo.h>
 #include <linux/time.h>
 #include <linux/timer.h>
 #include <media/rc-map.h>
+#else
+#include <sys/time.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <linux/types.h>
+#endif
 
-extern int rc_core_debug;
-#define IR_dprintk(level, fmt, ...)				\
-do {								\
-	if (rc_core_debug >= level)				\
-		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
-} while (0)
-
-#define RC_VERSION 0x010000
+#define RC_VERSION		0x010000
+#define RC_MAX_KEYTABLES	32
 
 /*
  * ioctl definitions
@@ -176,18 +177,37 @@ struct rc_keytable_ioctl {
 	char name[RC_KEYTABLE_NAME_SIZE];
 } __packed;
 
+/**
+ * enum rc_driver_type - describe the kind of driver/hardware used
+ * @RC_DRIVER_SCANCODE:	generates scancodes
+ * @RC_DRIVER_IR_RAW:	generates IR timings which need to be decoded
+ */
 enum rc_driver_type {
-	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
-	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
+	RC_DRIVER_SCANCODE = 0,
+	RC_DRIVER_IR_RAW,
 };
 
-/* This is used for the input EVIOC[SG]KEYCODE_V2 ioctls */
+/**
+ * struct rc_scancode - protocol/scancode pair
+ * @protocol:	the protocol of the rc command
+ * @reserved:	for future use and padding, set to zero
+ * @scancode:	the scancode of the command
+ */
 struct rc_scancode {
 	__u16 protocol;
 	__u16 reserved[3];
 	__u64 scancode;
 };
 
+/**
+ * struct rc_keymap_entry - used in EVIOC[SG]KEYCODE_V2 ioctls
+ * @flags:	see &struct input_keymap_entry
+ * @len:	see &struct input_keymap_entry
+ * @index:	see &struct input_keymap_entry
+ * @keycode:	see &struct input_keymap_entry
+ * @rc:		the scancode/protocol definition, see &struct rc_scancode
+ * @raw:	alternative representation of @rc
+ */
 struct rc_keymap_entry {
 	__u8  flags;
 	__u8  len;
@@ -203,7 +223,7 @@ struct rc_keymap_entry {
  * struct rc_event - used to communicate rc events to userspace
  * @type:	the event type
  * @code:	the event code (type specific)
- * @reserved:	zero for now
+ * @reserved:	padding, zero for now
  * @val:	the event value (type and code specific)
  */
 struct rc_event {
@@ -239,6 +259,9 @@ struct rc_event {
 #define RC_IR_RAW_CARRIER	0x5
 #define RC_IR_RAW_DUTY_CYCLE	0x6
 
+#ifdef __KERNEL__
+/* The rest is implementational details which shouldn't concern userspace */
+
 /**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
@@ -300,7 +323,6 @@ struct rc_event {
  * @get_ir_tx: allow driver to provide tx settings
  * @set_ir_tx: allow driver to change tx settings
  */
-#define RC_MAX_KEYTABLES		32
 #define RC_TX_KFIFO_SIZE		1024
 struct rc_dev {
 	struct device			dev;
@@ -350,22 +372,16 @@ struct rc_dev {
 	void				(*get_ir_tx)(struct rc_dev *dev, struct rc_ir_tx *tx);
 	int				(*set_ir_tx)(struct rc_dev *dev, struct rc_ir_tx *tx);
 };
-
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
 
-/*
- * From rc-main.c
- * Those functions can be used on any type of Remote Controller. They
- * basically creates an input_dev and properly reports the device as a
- * Remote Controller, at sys/class/rc.
- */
-
+/* From rc-main.c - see inline kerneldoc */
 struct rc_dev *rc_allocate_device(void);
 void rc_free_device(struct rc_dev *dev);
 int rc_register_device(struct rc_dev *dev);
 void rc_unregister_device(struct rc_dev *dev);
 void rc_event(struct rc_dev *dev, u16 type, u16 code, u64 val);
 
+/* From rc-keytable.c - see inline kerneldoc */
 void rc_repeat(struct rc_dev *dev);
 void rc_keyup(struct rc_dev *dev);
 void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle, bool autoup);
@@ -373,7 +389,22 @@ void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 t
 #define rc_keydown_notimeout(dev, proto, scan, toggle) rc_do_keydown(dev, proto, scan, toggle, false)
 u32 rc_g_keycode_from_table(struct rc_dev *dev, enum rc_type protocol, u64 scancode);
 
-/* extract mask bits out of data and pack them into the result */
+extern int rc_core_debug;
+#define IR_dprintk(level, fmt, ...)				\
+do {								\
+	if (rc_core_debug >= level)				\
+		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
+} while (0)
+
+/**
+ * ir_extract_bits() - extract bits of data according to a mask
+ * @data:	the data to extract bits from
+ * @mask:	the mask of bits to extract
+ * @return:	the extracted bits packed together
+ *
+ * This helper function is used by some drivers to extract the relevant
+ * (masked) bits of data.
+ */
 static inline u32 ir_extract_bits(u32 data, u32 mask)
 {
 	u32 vbit = 1, value = 0;
@@ -390,4 +421,5 @@ static inline u32 ir_extract_bits(u32 data, u32 mask)
 	return value;
 }
 
+#endif /* __KERNEL__ */
 #endif /* _RC_CORE */

