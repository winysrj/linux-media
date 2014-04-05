Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47654 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbaDEQkG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Apr 2014 12:40:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1WWTdT-0002eV-AV
	for linux-media@vger.kernel.org; Sat, 05 Apr 2014 18:40:03 +0200
Received: from 187-242-31-181.fibertel.com.ar ([187-242-31-181.fibertel.com.ar])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 05 Apr 2014 18:40:03 +0200
Received: from cramm0 by 187-242-31-181.fibertel.com.ar with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 05 Apr 2014 18:40:03 +0200
To: linux-media@vger.kernel.org
From: Ramiro Morales <cramm0@gmail.com>
Subject: Re: [PATCH] rc-videomate-m1f.c Rename to match remote controler name
Date: Sat, 5 Apr 2014 16:34:05 +0000 (UTC)
Message-ID: <loom.20140405T175545-158@post.gmane.org>
References: <op.v7n77sv031sqp4@00-25-22-b5-7b-09.dummy.porta.siemens.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Samuel Rakitničan <samuel.rakitnican <at> gmail.com> writes:

> 
> This remote was added with support for card Compro VideoMate M1F.
> 
> This remote is shipped with various Compro cards, not this one only.
> 
> Furthermore this remote can be bought separately under name Compro
> VideoMate K100.
> 	http://compro.com.tw/en/product/k100/k100.html
> 
> So give it a proper name.
> 
> Signed-off-by: Samuel Rakitničan <samuel.rakitnican <at> gmail.com>
> Attachment (k100.diff): application/octet-stream, 3440 bytes

This hasn't landed correctly. Two years later, the rename is still
implemented in a halfway fashion on the kernel source tree:

The drivers/media/rc/keymaps/Makefile file still mentions
rc-videomate-m1f.o and there is still a drivers/media/rc/keymaps
/rc-videomate-m1f.c file that should be named rc-videomate-m1f.c instead.

This renders the driver and the remote control unusable for final users
and forces those with some knowledge to solve it e.g. by creating a
/etc/modprobe.d/compro-rc-alias.conf file containing:

  alias rc-videomate-k100 rc-videomate-m1f

diff -ruN linux-source-3.13.0.orig/drivers/media/rc/keymaps/Makefile
linux-source-3.13.0/drivers/media/rc/keymaps/Makefile
--- linux-source-3.13.0.orig/drivers/media/rc/keymaps/Makefile  2014-01-19
23:40:07.000000000 -0300
+++ linux-source-3.13.0/drivers/media/rc/keymaps/Makefile       2014-03-23
22:33:31.871184552 -0300
@@ -94,7 +94,7 @@
                        rc-trekstor.o \
                        rc-tt-1500.o \
                        rc-twinhan1027.o \
-                       rc-videomate-m1f.o \
+                       rc-videomate-k100.o \
                        rc-videomate-s350.o \
                        rc-videomate-tv-pvr.o \
                        rc-winfast.o \
diff -ruN
linux-source-3.13.0.orig/drivers/media/rc/keymaps/rc-videomate-k100.c
linux-source-3.13.0/drivers/media/rc/keymaps/rc-videomate-k100.c
--- linux-source-3.13.0.orig/drivers/media/rc/keymaps/rc-videomate-k100.c  
    1969-12-31 21:00:00.000000000 -0300
+++ linux-source-3.13.0/drivers/media/rc/keymaps/rc-videomate-k100.c   
2014-01-19 23:40:07.000000000 -0300
@@ -0,0 +1,93 @@
+/* videomate-k100.h - Keytable for videomate_k100 Remote Controller
+ *
+ * keymap imported from ir-keymaps.c
+ *
+ * Copyright (c) 2010 by Pavel Osnova <pvosnova@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table videomate_k100[] = {
+       { 0x01, KEY_POWER },
+       { 0x31, KEY_TUNER },
+       { 0x33, KEY_VIDEO },
+       { 0x2f, KEY_RADIO },
+       { 0x30, KEY_CAMERA },
+       { 0x2d, KEY_NEW }, /* TV record button */
+       { 0x17, KEY_CYCLEWINDOWS },
+       { 0x2c, KEY_ANGLE },
+       { 0x2b, KEY_LANGUAGE },
+       { 0x32, KEY_SEARCH }, /* '...' button */
+       { 0x11, KEY_UP },
+       { 0x13, KEY_LEFT },
+       { 0x15, KEY_OK },
+       { 0x14, KEY_RIGHT },
+       { 0x12, KEY_DOWN },
+       { 0x16, KEY_BACKSPACE },
+       { 0x02, KEY_ZOOM }, /* WIN key */
+       { 0x04, KEY_INFO },
+       { 0x05, KEY_VOLUMEUP },
+       { 0x03, KEY_MUTE },
+       { 0x07, KEY_CHANNELUP },
+       { 0x06, KEY_VOLUMEDOWN },
+       { 0x08, KEY_CHANNELDOWN },
+       { 0x0c, KEY_RECORD },
+       { 0x0e, KEY_STOP },
+       { 0x0a, KEY_BACK },
+       { 0x0b, KEY_PLAY },
+       { 0x09, KEY_FORWARD },
+       { 0x10, KEY_PREVIOUS },
+       { 0x0d, KEY_PAUSE },
+       { 0x0f, KEY_NEXT },
+       { 0x1e, KEY_1 },
+       { 0x1f, KEY_2 },
+       { 0x20, KEY_3 },
+       { 0x21, KEY_4 },
+       { 0x22, KEY_5 },
+       { 0x23, KEY_6 },
+       { 0x24, KEY_7 },
+       { 0x25, KEY_8 },
+       { 0x26, KEY_9 },
+       { 0x2a, KEY_NUMERIC_STAR }, /* * key */
+       { 0x1d, KEY_0 },
+       { 0x29, KEY_SUBTITLE }, /* # key */
+       { 0x27, KEY_CLEAR },
+       { 0x34, KEY_SCREEN },
+       { 0x28, KEY_ENTER },
+       { 0x19, KEY_RED },
+       { 0x1a, KEY_GREEN },
+       { 0x1b, KEY_YELLOW },
+       { 0x1c, KEY_BLUE },
+       { 0x18, KEY_TEXT },
+};
+
+static struct rc_map_list videomate_k100_map = {
+       .map = {
+               .scan    = videomate_k100,
+               .size    = ARRAY_SIZE(videomate_k100),
+               .rc_type = RC_TYPE_UNKNOWN,     /* Legacy IR type */
+               .name    = RC_MAP_VIDEOMATE_K100,
+       }
+};
+
+static int __init init_rc_map_videomate_k100(void)
+{
+       return rc_map_register(&videomate_k100_map);
+}
+
+static void __exit exit_rc_map_videomate_k100(void)
+{
+       rc_map_unregister(&videomate_k100_map);
+}
+
+module_init(init_rc_map_videomate_k100)
+module_exit(exit_rc_map_videomate_k100)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pavel Osnova <pvosnova@gmail.com>");
diff -ruN
linux-source-3.13.0.orig/drivers/media/rc/keymaps/rc-videomate-m1f.c
linux-source-3.13.0/drivers/media/rc/keymaps/rc-videomate-m1f.c
--- linux-source-3.13.0.orig/drivers/media/rc/keymaps/rc-videomate-m1f.c   
    2014-01-19 23:40:07.000000000 -0300
+++ linux-source-3.13.0/drivers/media/rc/keymaps/rc-videomate-m1f.c    
1969-12-31 21:00:00.000000000 -0300
@@ -1,93 +0,0 @@
-/* videomate-k100.h - Keytable for videomate_k100 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Pavel Osnova <pvosnova@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <media/rc-map.h>
-#include <linux/module.h>
-
-static struct rc_map_table videomate_k100[] = {
-       { 0x01, KEY_POWER },
-       { 0x31, KEY_TUNER },
-       { 0x33, KEY_VIDEO },
-       { 0x2f, KEY_RADIO },
-       { 0x30, KEY_CAMERA },
-       { 0x2d, KEY_NEW }, /* TV record button */
-       { 0x17, KEY_CYCLEWINDOWS },
-       { 0x2c, KEY_ANGLE },
-       { 0x2b, KEY_LANGUAGE },
-       { 0x32, KEY_SEARCH }, /* '...' button */
-       { 0x11, KEY_UP },
-       { 0x13, KEY_LEFT },
-       { 0x15, KEY_OK },
-       { 0x14, KEY_RIGHT },
-       { 0x12, KEY_DOWN },
-       { 0x16, KEY_BACKSPACE },
-       { 0x02, KEY_ZOOM }, /* WIN key */
-       { 0x04, KEY_INFO },
-       { 0x05, KEY_VOLUMEUP },
-       { 0x03, KEY_MUTE },
-       { 0x07, KEY_CHANNELUP },
-       { 0x06, KEY_VOLUMEDOWN },
-       { 0x08, KEY_CHANNELDOWN },
-       { 0x0c, KEY_RECORD },
-       { 0x0e, KEY_STOP },
-       { 0x0a, KEY_BACK },
-       { 0x0b, KEY_PLAY },
-       { 0x09, KEY_FORWARD },
-       { 0x10, KEY_PREVIOUS },
-       { 0x0d, KEY_PAUSE },
-       { 0x0f, KEY_NEXT },
-       { 0x1e, KEY_1 },
-       { 0x1f, KEY_2 },
-       { 0x20, KEY_3 },
-       { 0x21, KEY_4 },
-       { 0x22, KEY_5 },
-       { 0x23, KEY_6 },
-       { 0x24, KEY_7 },
-       { 0x25, KEY_8 },
-       { 0x26, KEY_9 },
-       { 0x2a, KEY_NUMERIC_STAR }, /* * key */
-       { 0x1d, KEY_0 },
-       { 0x29, KEY_SUBTITLE }, /* # key */
-       { 0x27, KEY_CLEAR },
-       { 0x34, KEY_SCREEN },
-       { 0x28, KEY_ENTER },
-       { 0x19, KEY_RED },
-       { 0x1a, KEY_GREEN },
-       { 0x1b, KEY_YELLOW },
-       { 0x1c, KEY_BLUE },
-       { 0x18, KEY_TEXT },
-};
-
-static struct rc_map_list videomate_k100_map = {
-       .map = {
-               .scan    = videomate_k100,
-               .size    = ARRAY_SIZE(videomate_k100),
-               .rc_type = RC_TYPE_UNKNOWN,     /* Legacy IR type */
-               .name    = RC_MAP_VIDEOMATE_K100,
-       }
-};
-
-static int __init init_rc_map_videomate_k100(void)
-{
-       return rc_map_register(&videomate_k100_map);
-}
-
-static void __exit exit_rc_map_videomate_k100(void)
-{
-       rc_map_unregister(&videomate_k100_map);
-}
-
-module_init(init_rc_map_videomate_k100)
-module_exit(exit_rc_map_videomate_k100)
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Pavel Osnova <pvosnova@gmail.com>");



Regards,

-- 
Ramiro

