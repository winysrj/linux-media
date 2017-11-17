Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33604 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752849AbdKQKVj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 05:21:39 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 3/6] media: i2c: add SPDX identifiers to the code I wrote
Date: Fri, 17 Nov 2017 08:21:30 -0200
Message-Id: <507d4a13b32f0920ff557b27b8567e9782ee4a8f.1510913595.git.mchehab@s-opensource.com>
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
 drivers/media/i2c/mt9v011.c      |  4 ++--
 drivers/media/i2c/saa7115.c      | 13 ++-----------
 drivers/media/i2c/saa711x_regs.h | 11 +----------
 drivers/media/i2c/tvp5150.c      |  3 ++-
 drivers/media/i2c/tvp5150_reg.h  |  1 +
 5 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index 9ed1b26b6549..5794b2063add 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -1,8 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * mt9v011 -Micron 1/4-Inch VGA Digital Image Sensor
  *
  * Copyright (c) 2009 Mauro Carvalho Chehab
- * This code is placed under the terms of the GNU General Public License v2
  */
 
 #include <linux/i2c.h>
@@ -17,7 +17,7 @@
 
 MODULE_DESCRIPTION("Micron mt9v011 sensor driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 static int debug;
 module_param(debug, int, 0);
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index d863b04aa2a8..8a741ff19006 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 /* saa711x - Philips SAA711x video decoder driver
  * This driver can work with saa7111, saa7111a, saa7113, saa7114,
  *			     saa7115 and saa7118.
@@ -21,16 +22,6 @@
  *
  * Copyright (c) 2005-2006 Mauro Carvalho Chehab <mchehab@infradead.org>
  *	SAA7111, SAA7113 and SAA7118 support
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 
 #include "saa711x_regs.h"
@@ -51,7 +42,7 @@
 MODULE_DESCRIPTION("Philips SAA7111/SAA7113/SAA7114/SAA7115/SAA7118 video decoder driver");
 MODULE_AUTHOR(  "Maxim Yevtyushkin, Kevin Thayer, Chris Kennedy, "
 		"Hans Verkuil, Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 static bool debug;
 module_param(debug, bool, 0644);
diff --git a/drivers/media/i2c/saa711x_regs.h b/drivers/media/i2c/saa711x_regs.h
index 730ca90b30ac..3ec25d06bb5b 100644
--- a/drivers/media/i2c/saa711x_regs.h
+++ b/drivers/media/i2c/saa711x_regs.h
@@ -1,16 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /* saa711x - Philips SAA711x video decoder register specifications
  *
  * Copyright (c) 2006 Mauro Carvalho Chehab <mchehab@infradead.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 
 #define R_00_CHIP_VERSION                             0x00
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 7b79a7498751..2ce04c9e41b1 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * tvp5150 - Texas Instruments TVP5150A/AM1 and TVP5151 video decoder driver
  *
@@ -30,7 +31,7 @@
 
 MODULE_DESCRIPTION("Texas Instruments TVP5150A/TVP5150AM1/TVP5151 video decoder driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 
 static int debug;
diff --git a/drivers/media/i2c/tvp5150_reg.h b/drivers/media/i2c/tvp5150_reg.h
index 30a48c28d05a..2141ea932f4f 100644
--- a/drivers/media/i2c/tvp5150_reg.h
+++ b/drivers/media/i2c/tvp5150_reg.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * tvp5150 - Texas Instruments TVP5150A/AM1 video decoder registers
  *
-- 
2.14.3
