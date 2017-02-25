Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:41769 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbdBYMRx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 07:17:53 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 06/19] [media] rc: lirc keymap no longer makes any sense
Date: Sat, 25 Feb 2017 11:51:21 +0000
Message-Id: <ba62e72160d86a1eefb2eb39894e42fee9317fcb.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc keymap existed once upon a time to select the lirc protocol.
Since '275ddb4 [media] rc-core: remove the LIRC "protocol"', IR is
always passed to the lirc decoder so this keymap is no longer needed.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/keymaps/Makefile  |  1 -
 drivers/media/rc/keymaps/rc-lirc.c | 42 --------------------------------------
 drivers/media/rc/st_rc.c           |  2 +-
 include/media/rc-map.h             |  1 -
 4 files changed, 1 insertion(+), 45 deletions(-)
 delete mode 100644 drivers/media/rc/keymaps/rc-lirc.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index ffe9e61..2945f99 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -57,7 +57,6 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-kworld-pc150u.o \
 			rc-kworld-plus-tv-analog.o \
 			rc-leadtek-y04g0051.o \
-			rc-lirc.o \
 			rc-lme2510.o \
 			rc-manli.o \
 			rc-medion-x10.o \
diff --git a/drivers/media/rc/keymaps/rc-lirc.c b/drivers/media/rc/keymaps/rc-lirc.c
deleted file mode 100644
index e172f5d..0000000
--- a/drivers/media/rc/keymaps/rc-lirc.c
+++ /dev/null
@@ -1,42 +0,0 @@
-/* rc-lirc.c - Empty dummy keytable, for use when its preferred to pass
- * all raw IR data to the lirc userspace decoder.
- *
- * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <media/rc-core.h>
-#include <linux/module.h>
-
-static struct rc_map_table lirc[] = {
-	{ },
-};
-
-static struct rc_map_list lirc_map = {
-	.map = {
-		.scan    = lirc,
-		.size    = ARRAY_SIZE(lirc),
-		.rc_type = RC_TYPE_OTHER,
-		.name    = RC_MAP_LIRC,
-	}
-};
-
-static int __init init_rc_map_lirc(void)
-{
-	return rc_map_register(&lirc_map);
-}
-
-static void __exit exit_rc_map_lirc(void)
-{
-	rc_map_unregister(&lirc_map);
-}
-
-module_init(init_rc_map_lirc)
-module_exit(exit_rc_map_lirc)
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index f0d7190..6228d93 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -298,7 +298,7 @@ static int st_rc_probe(struct platform_device *pdev)
 	rdev->open = st_rc_open;
 	rdev->close = st_rc_close;
 	rdev->driver_name = IR_ST_NAME;
-	rdev->map_name = RC_MAP_LIRC;
+	rdev->map_name = RC_MAP_EMPTY;
 	rdev->input_name = "ST Remote Control Receiver";
 
 	ret = rc_register_device(rdev);
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index a704749..878d852 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -255,7 +255,6 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_KWORLD_PC150U             "rc-kworld-pc150u"
 #define RC_MAP_KWORLD_PLUS_TV_ANALOG     "rc-kworld-plus-tv-analog"
 #define RC_MAP_LEADTEK_Y04G0051          "rc-leadtek-y04g0051"
-#define RC_MAP_LIRC                      "rc-lirc"
 #define RC_MAP_LME2510                   "rc-lme2510"
 #define RC_MAP_MANLI                     "rc-manli"
 #define RC_MAP_MEDION_X10                "rc-medion-x10"
-- 
2.9.3
