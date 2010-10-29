Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760300Ab0J2DNz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 23:13:55 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9T3DtTH031796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:13:55 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9T3Dta2021580
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:13:55 -0400
Date: Thu, 28 Oct 2010 23:13:54 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 2/2] IR: add Apple remote keymap
Message-ID: <20101029031354.GG17238@redhat.com>
References: <20101029031131.GE17238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029031131.GE17238@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are at least two variants, and probably more, of the Apple
remotes. http://en.wikipedia.org/wiki/Apple_Remote contains one set of
codes, while the Apple remote I have in my possession sends a slightly
different set of codes. Just add both to the table. Probably needs
extending for the latest Apple remote, but I don't have one of those.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/keymaps/Makefile       |    1 +
 drivers/media/IR/keymaps/rc-nec-apple.c |   51 +++++++++++++++++++++++++++++++
 include/media/rc-map.h                  |    1 +
 3 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/IR/keymaps/rc-nec-apple.c

diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
index 3194d39..8fa0e53 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-msi-tvanywhere.o \
 			rc-msi-tvanywhere-plus.o \
 			rc-nebula.o \
+			rc-nec-apple.o \
 			rc-nec-terratec-cinergy-xs.o \
 			rc-norwood.o \
 			rc-npgtech.o \
diff --git a/drivers/media/IR/keymaps/rc-nec-apple.c b/drivers/media/IR/keymaps/rc-nec-apple.c
new file mode 100644
index 0000000..9f6189c
--- /dev/null
+++ b/drivers/media/IR/keymaps/rc-nec-apple.c
@@ -0,0 +1,51 @@
+/* rc-nec-apple.c - Keytable for Apple Remote Controls
+ *
+ * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+static struct ir_scancode nec_apple[] = {
+	{ 0xee8702, KEY_MENU},
+	{ 0xee8703, KEY_MENU},
+	{ 0xee8704, KEY_PLAYPAUSE},
+	{ 0xee8705, KEY_PLAYPAUSE},
+	{ 0xee8706, KEY_FORWARD},
+	{ 0xee8707, KEY_FORWARD},
+	{ 0xee8708, KEY_BACK},
+	{ 0xee8709, KEY_BACK},
+	{ 0xee870a, KEY_VOLUMEUP},
+	{ 0xee870b, KEY_VOLUMEUP},
+	{ 0xee870c, KEY_VOLUMEDOWN},
+	{ 0xee870d, KEY_VOLUMEDOWN},
+};
+
+static struct rc_keymap nec_apple_map = {
+	.map = {
+		.scan    = nec_apple,
+		.size    = ARRAY_SIZE(nec_apple),
+		.ir_type = IR_TYPE_NEC,
+		.name    = RC_MAP_NEC_APPLE,
+	}
+};
+
+static int __init init_rc_map_nec_apple(void)
+{
+	return ir_register_map(&nec_apple_map);
+}
+
+static void __exit exit_rc_map_nec_apple(void)
+{
+	ir_unregister_map(&nec_apple_map);
+}
+
+module_init(init_rc_map_nec_apple)
+module_exit(exit_rc_map_nec_apple)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 25883cf..868f0c3 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -110,6 +110,7 @@ void rc_map_init(void);
 #define RC_MAP_MSI_TVANYWHERE_PLUS       "rc-msi-tvanywhere-plus"
 #define RC_MAP_MSI_TVANYWHERE            "rc-msi-tvanywhere"
 #define RC_MAP_NEBULA                    "rc-nebula"
+#define RC_MAP_NEC_APPLE                 "rc-nec-apple"
 #define RC_MAP_NEC_TERRATEC_CINERGY_XS   "rc-nec-terratec-cinergy-xs"
 #define RC_MAP_NORWOOD                   "rc-norwood"
 #define RC_MAP_NPGTECH                   "rc-npgtech"
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

