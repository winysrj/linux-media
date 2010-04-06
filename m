Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447Ab0DFSSg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:36 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIZtl010848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:35 -0400
Date: Tue, 6 Apr 2010 15:18:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 23/26] V4L/DVB: ir-core: move rc map code to rc-map.h
Message-ID: <20100406151800.205434a0@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The keymaps don't need to be recompiled every time a change at ir-core.h
happens, since it only depends on rc-map defines. By moving those
definitions to the proper header, the code became cleaner, and avoids
needing to recompile all the RC maps every time a non-related change
is introduced.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 1c1e8d9..0f64b48 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -16,7 +16,6 @@
 #ifndef _IR_CORE
 #define _IR_CORE
 
-#include <linux/input.h>
 #include <linux/spinlock.h>
 #include <linux/kfifo.h>
 #include <linux/time.h>
@@ -27,12 +26,6 @@ extern int ir_core_debug;
 #define IR_dprintk(level, fmt, arg...)	if (ir_core_debug >= level) \
 	printk(KERN_DEBUG "%s: " fmt , __func__, ## arg)
 
-#define IR_TYPE_UNKNOWN	0
-#define IR_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
-#define IR_TYPE_PD	(1  << 1)	/* Pulse distance encoded IR */
-#define IR_TYPE_NEC	(1  << 2)
-#define IR_TYPE_OTHER	(((u64)1) << 63l)
-
 enum raw_event_type {
 	IR_SPACE	= (1 << 0),
 	IR_PULSE	= (1 << 1),
@@ -40,26 +33,6 @@ enum raw_event_type {
 	IR_STOP_EVENT	= (1 << 3),
 };
 
-struct ir_scancode {
-	u16	scancode;
-	u32	keycode;
-};
-
-struct ir_scancode_table {
-	struct ir_scancode	*scan;
-	unsigned int		size;	/* Max number of entries */
-	unsigned int		len;	/* Used number of entries */
-	unsigned int		alloc;	/* Size of *scan in bytes */
-	u64			ir_type;
-	char			*name;
-	spinlock_t		lock;
-};
-
-struct rc_keymap {
-	struct list_head	 list;
-	struct ir_scancode_table map;
-};
-
 struct ir_dev_props {
 	unsigned long allowed_protos;
 	void 		*priv;
@@ -108,13 +81,6 @@ struct ir_raw_handler {
 
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
 
-/* Routines from rc-map.c */
-
-int ir_register_map(struct rc_keymap *map);
-void ir_unregister_map(struct rc_keymap *map);
-struct ir_scancode_table *get_rc_map(const char *name);
-void rc_map_init(void);
-
 /* Routines from ir-keytable.c */
 
 u32 ir_g_keycode_from_table(struct input_dev *input_dev,
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 9ea0033..b10990d 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -9,7 +9,42 @@
  * (at your option) any later version.
  */
 
-#include <media/ir-core.h>
+#include <linux/input.h>
+
+#define IR_TYPE_UNKNOWN	0
+#define IR_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
+#define IR_TYPE_PD	(1  << 1)	/* Pulse distance encoded IR */
+#define IR_TYPE_NEC	(1  << 2)
+#define IR_TYPE_OTHER	(1u << 31)
+
+struct ir_scancode {
+	u16	scancode;
+	u32	keycode;
+};
+
+struct ir_scancode_table {
+	struct ir_scancode	*scan;
+	unsigned int		size;	/* Max number of entries */
+	unsigned int		len;	/* Used number of entries */
+	unsigned int		alloc;	/* Size of *scan in bytes */
+	u64			ir_type;
+	char			*name;
+	spinlock_t		lock;
+};
+
+struct rc_keymap {
+	struct list_head	 list;
+	struct ir_scancode_table map;
+};
+
+/* Routines from rc-map.c */
+
+int ir_register_map(struct rc_keymap *map);
+void ir_unregister_map(struct rc_keymap *map);
+struct ir_scancode_table *get_rc_map(const char *name);
+void rc_map_init(void);
+
+/* Names of the several keytables defined in-kernel */
 
 #define RC_MAP_ADSTECH_DVB_T_PCI         "rc-adstech-dvb-t-pci"
 #define RC_MAP_APAC_VIEWCOMP             "rc-apac-viewcomp"
-- 
1.6.6.1


