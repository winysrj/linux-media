Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab0KJDQa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 22:16:30 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAA3GTOu029876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 22:16:29 -0500
Received: from pedra (vpn-229-171.phx2.redhat.com [10.3.229.171])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oAA3DKlZ031781
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 22:16:28 -0500
Date: Wed, 10 Nov 2010 01:13:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] [media] rc-core: merge rc-map.c into rc-main.c
Message-ID: <20101110011311.19ef5134@pedra>
In-Reply-To: <cover.1289358255.git.mchehab@redhat.com>
References: <cover.1289358255.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With this change, all rc-core functions are into just one file, except
for the rc-raw specific functions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 delete mode 100644 drivers/media/rc/rc-map.c

diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 5a1112c..1eb24e6 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,5 +1,5 @@
 ir-common-objs  := ir-functions.o
-rc-core-objs	:= rc-main.o rc-raw.o rc-map.o
+rc-core-objs	:= rc-main.o rc-raw.o
 
 obj-y += keymaps/
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 3942673..73813b8 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -12,7 +12,9 @@
  *  GNU General Public License for more details.
  */
 
-
+#include <media/ir-core.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/device.h>
@@ -30,6 +32,96 @@ static unsigned long ir_core_dev_number;
 /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
 #define IR_KEYPRESS_TIMEOUT 250
 
+/* Used to handle IR raw handler extensions */
+static LIST_HEAD(rc_map_list);
+static DEFINE_SPINLOCK(rc_map_lock);
+
+static struct rc_keymap *seek_rc_map(const char *name)
+{
+	struct rc_keymap *map = NULL;
+
+	spin_lock(&rc_map_lock);
+	list_for_each_entry(map, &rc_map_list, list) {
+		if (!strcmp(name, map->map.name)) {
+			spin_unlock(&rc_map_lock);
+			return map;
+		}
+	}
+	spin_unlock(&rc_map_lock);
+
+	return NULL;
+}
+
+struct ir_scancode_table *get_rc_map(const char *name)
+{
+
+	struct rc_keymap *map;
+
+	map = seek_rc_map(name);
+#ifdef MODULE
+	if (!map) {
+		int rc = request_module(name);
+		if (rc < 0) {
+			printk(KERN_ERR "Couldn't load IR keymap %s\n", name);
+			return NULL;
+		}
+		msleep(20);	/* Give some time for IR to register */
+
+		map = seek_rc_map(name);
+	}
+#endif
+	if (!map) {
+		printk(KERN_ERR "IR keymap %s not found\n", name);
+		return NULL;
+	}
+
+	printk(KERN_INFO "Registered IR keymap %s\n", map->map.name);
+
+	return &map->map;
+}
+EXPORT_SYMBOL_GPL(get_rc_map);
+
+int ir_register_map(struct rc_keymap *map)
+{
+	spin_lock(&rc_map_lock);
+	list_add_tail(&map->list, &rc_map_list);
+	spin_unlock(&rc_map_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ir_register_map);
+
+void ir_unregister_map(struct rc_keymap *map)
+{
+	spin_lock(&rc_map_lock);
+	list_del(&map->list);
+	spin_unlock(&rc_map_lock);
+}
+EXPORT_SYMBOL_GPL(ir_unregister_map);
+
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
+
 /**
  * ir_resize_table() - resizes a scancode table if necessary
  * @rc_tab:	the ir_scancode_table to resize
diff --git a/drivers/media/rc/rc-map.c b/drivers/media/rc/rc-map.c
deleted file mode 100644
index 689143f..0000000
--- a/drivers/media/rc/rc-map.c
+++ /dev/null
@@ -1,107 +0,0 @@
-/* ir-raw-event.c - handle IR Pulse/Space event
- *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-#include <media/ir-core.h>
-#include <linux/spinlock.h>
-#include <linux/delay.h>
-
-/* Used to handle IR raw handler extensions */
-static LIST_HEAD(rc_map_list);
-static DEFINE_SPINLOCK(rc_map_lock);
-
-static struct rc_keymap *seek_rc_map(const char *name)
-{
-	struct rc_keymap *map = NULL;
-
-	spin_lock(&rc_map_lock);
-	list_for_each_entry(map, &rc_map_list, list) {
-		if (!strcmp(name, map->map.name)) {
-			spin_unlock(&rc_map_lock);
-			return map;
-		}
-	}
-	spin_unlock(&rc_map_lock);
-
-	return NULL;
-}
-
-struct ir_scancode_table *get_rc_map(const char *name)
-{
-
-	struct rc_keymap *map;
-
-	map = seek_rc_map(name);
-#ifdef MODULE
-	if (!map) {
-		int rc = request_module(name);
-		if (rc < 0) {
-			printk(KERN_ERR "Couldn't load IR keymap %s\n", name);
-			return NULL;
-		}
-		msleep(20);	/* Give some time for IR to register */
-
-		map = seek_rc_map(name);
-	}
-#endif
-	if (!map) {
-		printk(KERN_ERR "IR keymap %s not found\n", name);
-		return NULL;
-	}
-
-	printk(KERN_INFO "Registered IR keymap %s\n", map->map.name);
-
-	return &map->map;
-}
-EXPORT_SYMBOL_GPL(get_rc_map);
-
-int ir_register_map(struct rc_keymap *map)
-{
-	spin_lock(&rc_map_lock);
-	list_add_tail(&map->list, &rc_map_list);
-	spin_unlock(&rc_map_lock);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_register_map);
-
-void ir_unregister_map(struct rc_keymap *map)
-{
-	spin_lock(&rc_map_lock);
-	list_del(&map->list);
-	spin_unlock(&rc_map_lock);
-}
-EXPORT_SYMBOL_GPL(ir_unregister_map);
-
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
-int ir_rcmap_init(void)
-{
-	return ir_register_map(&empty_map);
-}
-
-void ir_rcmap_cleanup(void)
-{
-	ir_unregister_map(&empty_map);
-}
-- 
1.7.1

