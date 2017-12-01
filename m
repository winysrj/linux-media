Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65336 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752945AbdLANrg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 08:47:36 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH v2 6/7] media: i2c: add SPDX identifiers to the code I wrote
Date: Fri,  1 Dec 2017 11:47:12 -0200
Message-Id: <382b95334c8221d7f62f13a484ba133bdb0f7d04.1512135871.git.mchehab@s-opensource.com>
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
---
 drivers/media/i2c/mt9v011.c      | 13 +++++----
 drivers/media/i2c/saa7115.c      | 58 +++++++++++++++++-----------------------
 drivers/media/i2c/saa711x_regs.h | 14 +++-------
 drivers/media/i2c/tvp5150.c      | 13 +++++----
 drivers/media/i2c/tvp5150_reg.h  |  5 ++--
 5 files changed, 42 insertions(+), 61 deletions(-)

diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index 9ed1b26b6549..5e29064fae91 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -1,9 +1,8 @@
-/*
- * mt9v011 -Micron 1/4-Inch VGA Digital Image Sensor
- *
- * Copyright (c) 2009 Mauro Carvalho Chehab
- * This code is placed under the terms of the GNU General Public License v2
- */
+// SPDX-License-Identifier: GPL-2.0
+//
+// mt9v011 -Micron 1/4-Inch VGA Digital Image Sensor
+//
+// Copyright (c) 2009 Mauro Carvalho Chehab <mchehab@kernel.org>
 
 #include <linux/i2c.h>
 #include <linux/slab.h>
@@ -17,7 +16,7 @@
 
 MODULE_DESCRIPTION("Micron mt9v011 sensor driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 static int debug;
 module_param(debug, int, 0);
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index d863b04aa2a8..7dd6cff6d811 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1,37 +1,27 @@
-/* saa711x - Philips SAA711x video decoder driver
- * This driver can work with saa7111, saa7111a, saa7113, saa7114,
- *			     saa7115 and saa7118.
- *
- * Based on saa7114 driver by Maxim Yevtyushkin, which is based on
- * the saa7111 driver by Dave Perks.
- *
- * Copyright (C) 1998 Dave Perks <dperks@ibm.net>
- * Copyright (C) 2002 Maxim Yevtyushkin <max@linuxmedialabs.com>
- *
- * Slight changes for video timing and attachment output by
- * Wolfgang Scherr <scherr@net4you.net>
- *
- * Moved over to the linux >= 2.4.x i2c protocol (1/1/2003)
- * by Ronald Bultje <rbultje@ronald.bitfreak.net>
- *
- * Added saa7115 support by Kevin Thayer <nufan_wfk at yahoo.com>
- * (2/17/2003)
- *
- * VBI support (2004) and cleanups (2005) by Hans Verkuil <hverkuil@xs4all.nl>
- *
- * Copyright (c) 2005-2006 Mauro Carvalho Chehab <mchehab@infradead.org>
- *	SAA7111, SAA7113 and SAA7118 support
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
- */
+// SPDX-License-Identifier: GPL-2.0+
+// saa711x - Philips SAA711x video decoder driver
+// This driver can work with saa7111, saa7111a, saa7113, saa7114,
+//			     saa7115 and saa7118.
+//
+// Based on saa7114 driver by Maxim Yevtyushkin, which is based on
+// the saa7111 driver by Dave Perks.
+//
+// Copyright (C) 1998 Dave Perks <dperks@ibm.net>
+// Copyright (C) 2002 Maxim Yevtyushkin <max@linuxmedialabs.com>
+//
+// Slight changes for video timing and attachment output by
+// Wolfgang Scherr <scherr@net4you.net>
+//
+// Moved over to the linux >= 2.4.x i2c protocol (1/1/2003)
+// by Ronald Bultje <rbultje@ronald.bitfreak.net>
+//
+// Added saa7115 support by Kevin Thayer <nufan_wfk at yahoo.com>
+// (2/17/2003)
+//
+// VBI support (2004) and cleanups (2005) by Hans Verkuil <hverkuil@xs4all.nl>
+//
+// Copyright (c) 2005-2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+//	SAA7111, SAA7113 and SAA7118 support
 
 #include "saa711x_regs.h"
 
diff --git a/drivers/media/i2c/saa711x_regs.h b/drivers/media/i2c/saa711x_regs.h
index 730ca90b30ac..a50d480e101a 100644
--- a/drivers/media/i2c/saa711x_regs.h
+++ b/drivers/media/i2c/saa711x_regs.h
@@ -1,16 +1,8 @@
-/* saa711x - Philips SAA711x video decoder register specifications
+/*
+ * SPDX-License-Identifier: GPL-2.0+
+ * saa711x - Philips SAA711x video decoder register specifications
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
index 7b79a7498751..3c1851984b90 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1,9 +1,8 @@
-/*
- * tvp5150 - Texas Instruments TVP5150A/AM1 and TVP5151 video decoder driver
- *
- * Copyright (c) 2005,2006 Mauro Carvalho Chehab (mchehab@infradead.org)
- * This code is placed under the terms of the GNU General Public License v2
- */
+// SPDX-License-Identifier: GPL-2.0
+//
+// tvp5150 - Texas Instruments TVP5150A/AM1 and TVP5151 video decoder driver
+//
+// Copyright (c) 2005,2006 Mauro Carvalho Chehab <mchehab@infradead.org>
 
 #include <dt-bindings/media/tvp5150.h>
 #include <linux/i2c.h>
@@ -30,7 +29,7 @@
 
 MODULE_DESCRIPTION("Texas Instruments TVP5150A/TVP5150AM1/TVP5151 video decoder driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 
 static int debug;
diff --git a/drivers/media/i2c/tvp5150_reg.h b/drivers/media/i2c/tvp5150_reg.h
index 30a48c28d05a..654c44284787 100644
--- a/drivers/media/i2c/tvp5150_reg.h
+++ b/drivers/media/i2c/tvp5150_reg.h
@@ -1,8 +1,9 @@
 /*
+ * SPDX-License-Identifier: GPL-2.0
+ *
  * tvp5150 - Texas Instruments TVP5150A/AM1 video decoder registers
  *
- * Copyright (c) 2005,2006 Mauro Carvalho Chehab (mchehab@infradead.org)
- * This code is placed under the terms of the GNU General Public License v2
+ * Copyright (c) 2005,2006 Mauro Carvalho Chehab <mchehab@infradead.org>
  */
 
 #define TVP5150_VD_IN_SRC_SEL_1      0x00 /* Video input source selection #1 */
-- 
2.14.3
