Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40361 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbaDCXfZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:35:25 -0400
Subject: [PATCH 49/49] rc-core: make rc-core.h userspace friendly
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:35:24 +0200
Message-ID: <20140403233524.27099.33078.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few ifdef __KERNEL__ and some reorganisation to make rc-core.h usable from
userspace programs. A split into include/uapi/ might be a good idea later.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 include/media/rc-core.h |   71 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 23 deletions(-)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index aff3bdd..caa159f 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -16,21 +16,22 @@
 #ifndef _RC_CORE
 #define _RC_CORE
 
+#ifdef __KERNEL__
 #include <linux/spinlock.h>
 #include <linux/kfifo.h>
 #include <linux/time.h>
 #include <linux/timer.h>
 #include <linux/cdev.h>
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
@@ -177,13 +178,27 @@ struct rc_keytable_ioctl {
 	char name[RC_KEYTABLE_NAME_SIZE];
 } __packed;
 
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
@@ -236,6 +251,9 @@ struct rc_event {
 
 #define RC_TX_KFIFO_SIZE	1024
 
+#ifdef __KERNEL__
+/* The rest is implementational details which shouldn't concern userspace */
+
 /**
  * struct rc_scancode_filter - Filter scan codes.
  * @data:	Scancode data to match.
@@ -323,7 +341,6 @@ enum rc_filter_type {
  * @get_ir_tx: allow driver to provide tx settings
  * @set_ir_tx: allow driver to change tx settings
  */
-#define RC_MAX_KEYTABLES		32
 struct rc_dev {
 	struct device			dev;
 	struct cdev			cdev;
@@ -382,31 +399,23 @@ struct rc_dev {
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
 void rc_event(struct rc_dev *dev, u16 type, u16 code, u32 val);
-
 int rc_open(struct rc_dev *rdev);
 void rc_close(struct rc_dev *rdev);
 
+/* From rc-keytable.c - see inline kerneldoc */
 void rc_repeat(struct rc_dev *dev);
-void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
-		   u32 scancode, u8 toggle, bool autoup);
 void rc_keyup(struct rc_dev *dev);
 u32 rc_g_keycode_from_table(struct rc_dev *dev, enum rc_type protocol, u64 scancode);
-
+void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
+		   u32 scancode, u8 toggle, bool autoup);
 static inline void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle) {
 	rc_do_keydown(dev, protocol, scancode, toggle, true);
 }
@@ -415,7 +424,22 @@ static inline void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protoco
 	rc_do_keydown(dev, protocol, scancode, toggle, false);
 }
 
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
@@ -432,4 +456,5 @@ static inline u32 ir_extract_bits(u32 data, u32 mask)
 	return value;
 }
 
+#endif /* __KERNEL__ */
 #endif /* _RC_CORE */

