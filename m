Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47582 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752884AbdKQKVk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 05:21:40 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>, Shawn Guo <shawn.guo@linaro.org>,
        James Hogan <jhogan@kernel.org>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Jasmin Jessich <jasmin@anw.at>
Subject: [PATCH 4/6] media: rc: add SPDX identifiers to the code I wrote
Date: Fri, 17 Nov 2017 08:21:31 -0200
Message-Id: <1c640afaac1b0dd7b1d6fc3aefefff72095b09d9.1510913595.git.mchehab@s-opensource.com>
In-Reply-To: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
References: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
In-Reply-To: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
References: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're now using SPDX identifiers, on the several
media drivers I wrote, add the proper SPDX, identifying
the license I meant.

As we're now using the short license, it doesn't make sense to
keep the original license text.

Also, fix MODULE_LICENSE to properly identify GPL v2.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/ir-nec-decoder.c   | 12 ++----------
 drivers/media/rc/ir-rc5-decoder.c   | 12 ++----------
 drivers/media/rc/ir-sanyo-decoder.c | 12 ++----------
 drivers/media/rc/rc-core-priv.h     | 10 +---------
 drivers/media/rc/rc-ir-raw.c        | 10 +---------
 drivers/media/rc/rc-main.c          | 12 ++----------
 6 files changed, 10 insertions(+), 58 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 817c18f2ddd1..3b9fc60cc9b8 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /* ir-nec-decoder.c - handle NEC IR Pulse/Space protocol
  *
  * Copyright (C) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #include <linux/bitrev.h>
@@ -277,7 +269,7 @@ static void __exit ir_nec_decode_exit(void)
 module_init(ir_nec_decode_init);
 module_exit(ir_nec_decode_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("NEC IR protocol decoder");
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 1292f534de43..c97b50425abf 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -1,16 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /* ir-rc5-decoder.c - decoder for RC5(x) and StreamZap protocols
  *
  * Copyright (C) 2010 by Mauro Carvalho Chehab
  * Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 /*
@@ -300,7 +292,7 @@ static void __exit ir_rc5_decode_exit(void)
 module_init(ir_rc5_decode_init);
 module_exit(ir_rc5_decode_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab and Jarod Wilson");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("RC5(x/sz) IR protocol decoder");
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 758c60956850..86b8f7bbb6ae 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -1,16 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /* ir-sanyo-decoder.c - handle SANYO IR Pulse/Space protocol
  *
  * Copyright (C) 2011 by Mauro Carvalho Chehab
  *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
  * This protocol uses the NEC protocol timings. However, data is formatted as:
  *	13 bits Custom Code
  *	13 bits NOT(Custom Code)
@@ -236,7 +228,7 @@ static void __exit ir_sanyo_decode_exit(void)
 module_init(ir_sanyo_decode_init);
 module_exit(ir_sanyo_decode_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("SANYO IR protocol decoder");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 7da9c96cb058..f5e2de061930 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -1,16 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Remote Controller core raw events header
  *
  * Copyright (C) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #ifndef _RC_CORE_PRIV
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 503bc425a187..2228abc859f8 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /* rc-ir-raw.c - handle IR pulse/space events
  *
  * Copyright (C) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #include <linux/export.h>
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 981cccd6b988..06c4be7da7f4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /* rc-main.c - Remote Controller core module
  *
  * Copyright (C) 2009-2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -1874,4 +1866,4 @@ EXPORT_SYMBOL_GPL(rc_core_debug);
 module_param_named(debug, rc_core_debug, int, 0644);
 
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
-- 
2.14.3
