Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0GCEIy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 00:08:54 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6348reQ000707
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:08:54 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o6348rij017097
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:08:53 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o6348qAV031526
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:08:52 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o6348qZk031525
	for linux-media@vger.kernel.org; Sat, 3 Jul 2010 00:08:52 -0400
Date: Sat, 3 Jul 2010 00:08:52 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 3/3] IR: add empty lirc pseudo-keymap
Message-ID: <20100703040852.GE31255@redhat.com>
References: <20100601205005.GA28322@redhat.com>
 <20100703040530.GB31255@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100703040530.GB31255@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2: No changes from prior submission here.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/keymaps/Makefile  |    1 +
 drivers/media/IR/keymaps/rc-lirc.c |   41 ++++++++++++++++++++++++++++++++++++
 include/media/rc-map.h             |    1 +
 3 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/IR/keymaps/rc-lirc.c

diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
index 08e5a10..7dffd41 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-kaiomy.o \
 			rc-kworld-315u.o \
 			rc-kworld-plus-tv-analog.o \
+			rc-lirc.o \
 			rc-manli.o \
 			rc-msi-tvanywhere.o \
 			rc-msi-tvanywhere-plus.o \
diff --git a/drivers/media/IR/keymaps/rc-lirc.c b/drivers/media/IR/keymaps/rc-lirc.c
new file mode 100644
index 0000000..43fcf90
--- /dev/null
+++ b/drivers/media/IR/keymaps/rc-lirc.c
@@ -0,0 +1,41 @@
+/* rc-lirc.c - Empty dummy keytable, for use when its preferred to pass
+ * all raw IR data to the lirc userspace decoder.
+ *
+ * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/ir-core.h>
+
+static struct ir_scancode lirc[] = {
+	{ },
+};
+
+static struct rc_keymap lirc_map = {
+	.map = {
+		.scan    = lirc,
+		.size    = ARRAY_SIZE(lirc),
+		.ir_type = IR_TYPE_LIRC,
+		.name    = RC_MAP_LIRC,
+	}
+};
+
+static int __init init_rc_map_lirc(void)
+{
+	return ir_register_map(&lirc_map);
+}
+
+static void __exit exit_rc_map_lirc(void)
+{
+	ir_unregister_map(&lirc_map);
+}
+
+module_init(init_rc_map_lirc)
+module_exit(exit_rc_map_lirc)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 63b35e4..056d0e4 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -91,6 +91,7 @@ void rc_map_init(void);
 #define RC_MAP_KAIOMY                    "rc-kaiomy"
 #define RC_MAP_KWORLD_315U               "rc-kworld-315u"
 #define RC_MAP_KWORLD_PLUS_TV_ANALOG     "rc-kworld-plus-tv-analog"
+#define RC_MAP_LIRC                      "rc-lirc"
 #define RC_MAP_MANLI                     "rc-manli"
 #define RC_MAP_MSI_TVANYWHERE_PLUS       "rc-msi-tvanywhere-plus"
 #define RC_MAP_MSI_TVANYWHERE            "rc-msi-tvanywhere"
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com

