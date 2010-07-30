Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41194 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab0G3LjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 07:39:21 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 08/13] IR: Allow not to compile keymaps in.
Date: Fri, 30 Jul 2010 14:38:48 +0300
Message-Id: <1280489933-20865-9-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
References: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, ir device registration fails if keymap requested by driver is not found.
Fix that by always compiling in the empty keymap, and using it as a failback.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-core-priv.h     |    3 +-
 drivers/media/IR/ir-sysfs.c         |    2 +
 drivers/media/IR/keymaps/Makefile   |    1 -
 drivers/media/IR/keymaps/rc-empty.c |   44 -----------------------------------
 drivers/media/IR/rc-map.c           |   23 ++++++++++++++++++
 include/media/ir-core.h             |    8 ++++-
 6 files changed, 33 insertions(+), 48 deletions(-)
 delete mode 100644 drivers/media/IR/keymaps/rc-empty.c

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index 08383b9..e9c3cce 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -125,7 +125,8 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_init(void);
 
-
+int ir_rcmap_init(void);
+void ir_rcmap_cleanup(void);
 /*
  * Decoder initialization code
  *
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index a841e51..936dff8 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -341,6 +341,7 @@ static int __init ir_core_init(void)
 
 	/* Initialize/load the decoders/keymap code that will be used */
 	ir_raw_init();
+	ir_rcmap_init();
 
 	return 0;
 }
@@ -348,6 +349,7 @@ static int __init ir_core_init(void)
 static void __exit ir_core_exit(void)
 {
 	class_unregister(&ir_input_class);
+	ir_rcmap_cleanup();
 }
 
 module_init(ir_core_init);
diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
index 86d3d1f..24992cd 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-dm1105-nec.o \
 			rc-dntv-live-dvb-t.o \
 			rc-dntv-live-dvbt-pro.o \
-			rc-empty.o \
 			rc-em-terratec.o \
 			rc-encore-enltv2.o \
 			rc-encore-enltv.o \
diff --git a/drivers/media/IR/keymaps/rc-empty.c b/drivers/media/IR/keymaps/rc-empty.c
deleted file mode 100644
index 3b338d8..0000000
--- a/drivers/media/IR/keymaps/rc-empty.c
+++ /dev/null
@@ -1,44 +0,0 @@
-/* empty.h - Keytable for empty Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <media/rc-map.h>
-
-/* empty keytable, can be used as placeholder for not-yet created keytables */
-
-static struct ir_scancode empty[] = {
-	{ 0x2a, KEY_COFFEE },
-};
-
-static struct rc_keymap empty_map = {
-	.map = {
-		.scan    = empty,
-		.size    = ARRAY_SIZE(empty),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_EMPTY,
-	}
-};
-
-static int __init init_rc_map_empty(void)
-{
-	return ir_register_map(&empty_map);
-}
-
-static void __exit exit_rc_map_empty(void)
-{
-	ir_unregister_map(&empty_map);
-}
-
-module_init(init_rc_map_empty)
-module_exit(exit_rc_map_empty)
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/IR/rc-map.c b/drivers/media/IR/rc-map.c
index 46a8f15..689143f 100644
--- a/drivers/media/IR/rc-map.c
+++ b/drivers/media/IR/rc-map.c
@@ -82,3 +82,26 @@ void ir_unregister_map(struct rc_keymap *map)
 }
 EXPORT_SYMBOL_GPL(ir_unregister_map);
 
+
+static struct ir_scancode empty[] = {
+	{ 0x2a, KEY_COFFEE },
+};
+
+static struct rc_keymap empty_map = {
+	.map = {
+		.scan    = empty,
+		.size    = ARRAY_SIZE(empty),
+		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_EMPTY,
+	}
+};
+
+int ir_rcmap_init(void)
+{
+	return ir_register_map(&empty_map);
+}
+
+void ir_rcmap_cleanup(void)
+{
+	ir_unregister_map(&empty_map);
+}
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 513e60d..197d05a 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -110,8 +110,12 @@ static inline int ir_input_register(struct input_dev *dev,
 		return -EINVAL;
 
 	ir_codes = get_rc_map(map_name);
-	if (!ir_codes)
-		return -EINVAL;
+	if (!ir_codes) {
+		ir_codes = get_rc_map(RC_MAP_EMPTY);
+
+		if (!ir_codes)
+			return -EINVAL;
+	}
 
 	rc = __ir_input_register(dev, ir_codes, props, driver_name);
 	if (rc < 0)
-- 
1.7.0.4

