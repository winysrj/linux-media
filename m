Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41800 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752974AbdLANr2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 08:47:28 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml@vger.kernel.org, Philippe Ombredanne <pombredanne@nexb.com>
Subject: [PATCH v2 3/7] media: tuners: add SPDX identifiers to the code I wrote
Date: Fri,  1 Dec 2017 11:47:09 -0200
Message-Id: <4bdb728d03cb4f40375196de7c4a0f8a01a070ad.1512135871.git.mchehab@s-opensource.com>
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
 drivers/media/tuners/r820t.c              | 56 ++++++++++++-------------------
 drivers/media/tuners/tea5761.c            | 15 ++++-----
 drivers/media/tuners/tea5767.c            | 21 +++++-------
 drivers/media/tuners/tuner-xc2028-types.h |  5 +--
 drivers/media/tuners/tuner-xc2028.c       | 18 +++++-----
 drivers/media/tuners/tuner-xc2028.h       |  5 +--
 6 files changed, 51 insertions(+), 69 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index ba80376a3b86..69a507f355b5 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1,36 +1,24 @@
-/*
- * Rafael Micro R820T driver
- *
- * Copyright (C) 2013 Mauro Carvalho Chehab
- *
- * This driver was written from scratch, based on an existing driver
- * that it is part of rtl-sdr git tree, released under GPLv2:
- *	https://groups.google.com/forum/#!topic/ultra-cheap-sdr/Y3rBEOFtHug
- *	https://github.com/n1gp/gr-baz
- *
- * From what I understood from the threads, the original driver was converted
- * to userspace from a Realtek tree. I couldn't find the original tree.
- * However, the original driver look awkward on my eyes. So, I decided to
- * write a new version from it from the scratch, while trying to reproduce
- * everything found there.
- *
- * TODO:
- *	After locking, the original driver seems to have some routines to
- *		improve reception. This was not implemented here yet.
- *
- *	RF Gain set/get is not implemented.
- *
- *    This program is free software; you can redistribute it and/or modify
- *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
- *
- *    This program is distributed in the hope that it will be useful,
- *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *    GNU General Public License for more details.
- *
- */
+// SPDX-License-Identifier: GPL-2.0
+// Rafael Micro R820T driver
+//
+// Copyright (C) 2013 Mauro Carvalho Chehab
+//
+// This driver was written from scratch, based on an existing driver
+// that it is part of rtl-sdr git tree, released under GPLv2:
+//	https://groups.google.com/forum/#!topic/ultra-cheap-sdr/Y3rBEOFtHug
+//	https://github.com/n1gp/gr-baz
+//
+// From what I understood from the threads, the original driver was converted
+// to userspace from a Realtek tree. I couldn't find the original tree.
+// However, the original driver look awkward on my eyes. So, I decided to
+// write a new version from it from the scratch, while trying to reproduce
+// everything found there.
+//
+// TODO:
+//	After locking, the original driver seems to have some routines to
+//		improve reception. This was not implemented here yet.
+//
+//	RF Gain set/get is not implemented.
 
 #include <linux/videodev2.h>
 #include <linux/mutex.h>
@@ -2388,4 +2376,4 @@ EXPORT_SYMBOL_GPL(r820t_attach);
 
 MODULE_DESCRIPTION("Rafael Micro r820t silicon tuner driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/tuners/tea5761.c b/drivers/media/tuners/tea5761.c
index a9b1bb134409..88b3e80c38ad 100644
--- a/drivers/media/tuners/tea5761.c
+++ b/drivers/media/tuners/tea5761.c
@@ -1,11 +1,8 @@
-/*
- * For Philips TEA5761 FM Chip
- * I2C address is allways 0x20 (0x10 at 7-bit mode).
- *
- * Copyright (c) 2005-2007 Mauro Carvalho Chehab (mchehab@infradead.org)
- * This code is placed under the terms of the GNUv2 General Public License
- *
- */
+// SPDX-License-Identifier: GPL-2.0
+// For Philips TEA5761 FM Chip
+// I2C address is always 0x20 (0x10 at 7-bit mode).
+//
+// Copyright (c) 2005-2007 Mauro Carvalho Chehab (mchehab@infradead.org)
 
 #include <linux/i2c.h>
 #include <linux/slab.h>
@@ -341,4 +338,4 @@ EXPORT_SYMBOL_GPL(tea5761_autodetection);
 
 MODULE_DESCRIPTION("Philips TEA5761 FM tuner driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/tuners/tea5767.c b/drivers/media/tuners/tea5767.c
index 525b7ab90c80..2b2c064d7dc3 100644
--- a/drivers/media/tuners/tea5767.c
+++ b/drivers/media/tuners/tea5767.c
@@ -1,14 +1,11 @@
-/*
- * For Philips TEA5767 FM Chip used on some TV Cards like Prolink Pixelview
- * I2C address is allways 0xC0.
- *
- *
- * Copyright (c) 2005 Mauro Carvalho Chehab (mchehab@infradead.org)
- * This code is placed under the terms of the GNU General Public License
- *
- * tea5767 autodetection thanks to Torsten Seeboth and Atsushi Nakagawa
- * from their contributions on DScaler.
- */
+// SPDX-License-Identifier: GPL-2.0
+// For Philips TEA5767 FM Chip used on some TV Cards like Prolink Pixelview
+// I2C address is always 0xC0.
+//
+// Copyright (c) 2005 Mauro Carvalho Chehab (mchehab@infradead.org)
+//
+// tea5767 autodetection thanks to Torsten Seeboth and Atsushi Nakagawa
+// from their contributions on DScaler.
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
@@ -473,4 +470,4 @@ EXPORT_SYMBOL_GPL(tea5767_autodetection);
 
 MODULE_DESCRIPTION("Philips TEA5767 FM tuner driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/tuners/tuner-xc2028-types.h b/drivers/media/tuners/tuner-xc2028-types.h
index 7e4798783db7..bb0437c36c03 100644
--- a/drivers/media/tuners/tuner-xc2028-types.h
+++ b/drivers/media/tuners/tuner-xc2028-types.h
@@ -1,10 +1,11 @@
-/* tuner-xc2028_types
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * tuner-xc2028_types
  *
  * This file includes internal tipes to be used inside tuner-xc2028.
  * Shouldn't be included outside tuner-xc2028
  *
  * Copyright (c) 2007-2008 Mauro Carvalho Chehab (mchehab@infradead.org)
- * This code is placed under the terms of the GNU General Public License v2
  */
 
 /* xc3028 firmware types */
diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index b5b62b08159e..ae739f842c2d 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1,12 +1,10 @@
-/* tuner-xc2028
- *
- * Copyright (c) 2007-2008 Mauro Carvalho Chehab (mchehab@infradead.org)
- *
- * Copyright (c) 2007 Michel Ludwig (michel.ludwig@gmail.com)
- *       - frontend interface
- *
- * This code is placed under the terms of the GNU General Public License v2
- */
+// SPDX-License-Identifier: GPL-2.0
+// tuner-xc2028
+//
+// Copyright (c) 2007-2008 Mauro Carvalho Chehab (mchehab@infradead.org)
+//
+// Copyright (c) 2007 Michel Ludwig (michel.ludwig@gmail.com)
+//       - frontend interface
 
 #include <linux/i2c.h>
 #include <asm/div64.h>
@@ -1521,6 +1519,6 @@ EXPORT_SYMBOL(xc2028_attach);
 MODULE_DESCRIPTION("Xceive xc2028/xc3028 tuner driver");
 MODULE_AUTHOR("Michel Ludwig <michel.ludwig@gmail.com>");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
 MODULE_FIRMWARE(XC3028L_DEFAULT_FIRMWARE);
diff --git a/drivers/media/tuners/tuner-xc2028.h b/drivers/media/tuners/tuner-xc2028.h
index 98e4effca896..d8378f9960a5 100644
--- a/drivers/media/tuners/tuner-xc2028.h
+++ b/drivers/media/tuners/tuner-xc2028.h
@@ -1,7 +1,8 @@
-/* tuner-xc2028
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * tuner-xc2028
  *
  * Copyright (c) 2007-2008 Mauro Carvalho Chehab (mchehab@infradead.org)
- * This code is placed under the terms of the GNU General Public License v2
  */
 
 #ifndef __TUNER_XC2028_H__
-- 
2.14.3
