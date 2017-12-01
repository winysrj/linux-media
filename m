Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40468 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752803AbdLANrU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 08:47:20 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml@vger.kernel.org, Sean Young <sean@mess.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        James Hogan <jhogan@kernel.org>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jasmin Jessich <jasmin@anw.at>,
        Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH v2 2/7] media: rc: add SPDX identifiers to the code I wrote
Date: Fri,  1 Dec 2017 11:47:08 -0200
Message-Id: <8d6c6cc360547cbfa397c9c3c55bac40cca62903.1512135871.git.mchehab@s-opensource.com>
In-Reply-To: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
References: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
In-Reply-To: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
References: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're now using SPDX identifiers, on the several
media drivers I wrote, add the proper SPDX, identifying
the license I meant.

As we're now using the short license, it doesn't make sense to
keep the original license text.

Also, fix MODULE_LICENSE to properly identify GPL v2.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>
---
 drivers/media/rc/ir-nec-decoder.c   | 19 +++++--------------
 drivers/media/rc/ir-rc5-decoder.c   | 21 ++++++---------------
 drivers/media/rc/ir-sanyo-decoder.c | 37 ++++++++++++++-----------------------
 drivers/media/rc/rc-core-priv.h     | 18 ++++--------------
 drivers/media/rc/rc-ir-raw.c        | 17 ++++-------------
 drivers/media/rc/rc-main.c          | 19 +++++--------------
 6 files changed, 38 insertions(+), 93 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 6880c190dcd2..22eed9505244 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -1,16 +1,7 @@
-/* ir-nec-decoder.c - handle NEC IR Pulse/Space protocol
- *
- * Copyright (C) 2010 by Mauro Carvalho Chehab
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
+// SPDX-License-Identifier: GPL-2.0
+// ir-nec-decoder.c - handle NEC IR Pulse/Space protocol
+//
+// Copyright (C) 2010 by Mauro Carvalho Chehab
 
 #include <linux/bitrev.h>
 #include <linux/module.h>
@@ -281,7 +272,7 @@ static void __exit ir_nec_decode_exit(void)
 module_init(ir_nec_decode_init);
 module_exit(ir_nec_decode_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("NEC IR protocol decoder");
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 1292f534de43..cbff3e26d481 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -1,17 +1,8 @@
-/* ir-rc5-decoder.c - decoder for RC5(x) and StreamZap protocols
- *
- * Copyright (C) 2010 by Mauro Carvalho Chehab
- * Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
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
+// SPDX-License-Identifier: GPL-2.0
+// ir-rc5-decoder.c - decoder for RC5(x) and StreamZap protocols
+//
+// Copyright (C) 2010 by Mauro Carvalho Chehab
+// Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
 
 /*
  * This decoder handles the 14 bit RC5 protocol, 15 bit "StreamZap" protocol
@@ -300,7 +291,7 @@ static void __exit ir_rc5_decode_exit(void)
 module_init(ir_rc5_decode_init);
 module_exit(ir_rc5_decode_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab and Jarod Wilson");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("RC5(x/sz) IR protocol decoder");
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index d94e07b02f3b..2138f0e9472d 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -1,25 +1,16 @@
-/* ir-sanyo-decoder.c - handle SANYO IR Pulse/Space protocol
- *
- * Copyright (C) 2011 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- * This protocol uses the NEC protocol timings. However, data is formatted as:
- *	13 bits Custom Code
- *	13 bits NOT(Custom Code)
- *	8 bits Key data
- *	8 bits NOT(Key data)
- *
- * According with LIRC, this protocol is used on Sanyo, Aiwa and Chinon
- * Information for this protocol is available at the Sanyo LC7461 datasheet.
- */
+// SPDX-License-Identifier: GPL-2.0
+// ir-sanyo-decoder.c - handle SANYO IR Pulse/Space protocol
+//
+// Copyright (C) 2011 by Mauro Carvalho Chehab
+//
+// This protocol uses the NEC protocol timings. However, data is formatted as:
+//	13 bits Custom Code
+//	13 bits NOT(Custom Code)
+//	8 bits Key data
+//	8 bits NOT(Key data)
+//
+// According with LIRC, this protocol is used on Sanyo, Aiwa and Chinon
+// Information for this protocol is available at the Sanyo LC7461 datasheet.
 
 #include <linux/module.h>
 #include <linux/bitrev.h>
@@ -236,7 +227,7 @@ static void __exit ir_sanyo_decode_exit(void)
 module_init(ir_sanyo_decode_init);
 module_exit(ir_sanyo_decode_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("SANYO IR protocol decoder");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index ae4dd0c27731..564d6e13585e 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -1,17 +1,7 @@
-/*
- * Remote Controller core raw events header
- *
- * Copyright (C) 2010 by Mauro Carvalho Chehab
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
+// SPDX-License-Identifier: GPL-2.0
+// Remote Controller core raw events header
+//
+// Copyright (C) 2010 by Mauro Carvalho Chehab
 
 #ifndef _RC_CORE_PRIV
 #define _RC_CORE_PRIV
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index d78483a504c9..0616eee564a8 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -1,16 +1,7 @@
-/* rc-ir-raw.c - handle IR pulse/space events
- *
- * Copyright (C) 2010 by Mauro Carvalho Chehab
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
+// SPDX-License-Identifier: GPL-2.0
+// rc-ir-raw.c - handle IR pulse/space events
+//
+// Copyright (C) 2010 by Mauro Carvalho Chehab
 
 #include <linux/export.h>
 #include <linux/kthread.h>
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index c144b77eac98..372f4d61cb48 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1,16 +1,7 @@
-/* rc-main.c - Remote Controller core module
- *
- * Copyright (C) 2009-2010 by Mauro Carvalho Chehab
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
+// SPDX-License-Identifier: GPL-2.0
+// rc-main.c - Remote Controller core module
+//
+// Copyright (C) 2009-2010 by Mauro Carvalho Chehab
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
@@ -1905,4 +1896,4 @@ EXPORT_SYMBOL_GPL(rc_core_debug);
 module_param_named(debug, rc_core_debug, int, 0644);
 
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
-- 
2.14.3
