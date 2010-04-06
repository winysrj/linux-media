Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483Ab0DFSSy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:54 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIsXC019249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:54 -0400
Date: Tue, 6 Apr 2010 15:18:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/26] V4L/DVB: ir-core: Add support for RC map code
 register
Message-ID: <20100406151803.593c8b4c@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having all RC tables hardcoded on one file with
all tables there, add infrastructure for registering and dynamically
load the table(s) when needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 drivers/media/IR/rc-map.c

diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 6140b27..3a4f590 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -1,5 +1,5 @@
 ir-common-objs  := ir-functions.o ir-keymaps.o
-ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o
+ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o rc-map.o
 
 obj-$(CONFIG_IR_CORE) += ir-core.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
diff --git a/drivers/media/IR/rc-map.c b/drivers/media/IR/rc-map.c
new file mode 100644
index 0000000..aa269f5
--- /dev/null
+++ b/drivers/media/IR/rc-map.c
@@ -0,0 +1,75 @@
+/* ir-raw-event.c - handle IR Pulse/Space event
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
+#include <media/ir-core.h>
+#include <linux/spinlock.h>
+
+/* Used to handle IR raw handler extensions */
+static LIST_HEAD(rc_map_list);
+static spinlock_t rc_map_lock;
+
+
+static struct rc_keymap *seek_rc_map(const char *name)
+{
+	struct rc_keymap *map = NULL;
+
+	spin_lock(&rc_map_lock);
+	list_for_each_entry(map, &rc_map_list, list) {
+		if (!strcmp(name, map->map.name))
+			break;
+	}
+	spin_unlock(&rc_map_lock);
+
+	return map;
+}
+
+struct ir_scancode_table *get_rc_map(const char *name)
+{
+	int rc = 0;
+
+	struct rc_keymap *map;
+
+	map = seek_rc_map(name);
+#ifdef MODULE
+	if (!map) {
+		rc = request_module("name");
+		if (rc < 0)
+			return NULL;
+
+		map = seek_rc_map(name);
+	}
+#endif
+	if (!map)
+		return NULL;
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
+EXPORT_SYMBOL_GPL(ir_raw_handler_register);
+
+void ir_unregister_map(struct rc_keymap *map)
+{
+	spin_lock(&rc_map_lock);
+	list_del(&map->list);
+	spin_unlock(&rc_map_lock);
+}
+EXPORT_SYMBOL_GPL(ir_raw_handler_unregister);
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 643ff25..39df3cf 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -52,6 +52,11 @@ struct ir_scancode_table {
 	spinlock_t		lock;
 };
 
+struct rc_keymap {
+	struct list_head	 list;
+	struct ir_scancode_table map;
+};
+
 struct ir_dev_props {
 	unsigned long allowed_protos;
 	void 		*priv;
@@ -126,6 +131,12 @@ int ir_input_register(struct input_dev *dev,
 		      const char *driver_name);
 void ir_input_unregister(struct input_dev *input_dev);
 
+/* Routines from rc-map.c */
+
+int ir_register_map(struct rc_keymap *map);
+void ir_unregister_map(struct rc_keymap *map);
+struct ir_scancode_table *get_rc_map(const char *name);
+
 /* Routines from ir-sysfs.c */
 
 int ir_register_class(struct input_dev *input_dev);
-- 
1.6.6.1


