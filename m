Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63968 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752881AbdKQKVk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 05:21:40 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH 5/6] media: tuners: add SPDX identifiers to the code I wrote
Date: Fri, 17 Nov 2017 08:21:32 -0200
Message-Id: <6ac4ea66b5c3edb1d374b84ecb1270e2f1b0687d.1510913595.git.mchehab@s-opensource.com>
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
 drivers/media/tuners/r820t.c              | 14 ++------------
 drivers/media/tuners/tea5761.c            |  5 ++---
 drivers/media/tuners/tea5767.c            |  4 ++--
 drivers/media/tuners/tuner-xc2028-types.h |  2 +-
 drivers/media/tuners/tuner-xc2028.c       |  5 ++---
 drivers/media/tuners/tuner-xc2028.h       |  2 +-
 6 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index ba80376a3b86..d80297adbf68 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Rafael Micro R820T driver
  *
@@ -19,17 +20,6 @@
  *		improve reception. This was not implemented here yet.
  *
  *	RF Gain set/get is not implemented.
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
  */
 
 #include <linux/videodev2.h>
@@ -2388,4 +2378,4 @@ EXPORT_SYMBOL_GPL(r820t_attach);
 
 MODULE_DESCRIPTION("Rafael Micro r820t silicon tuner driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/tuners/tea5761.c b/drivers/media/tuners/tea5761.c
index a9b1bb134409..455b7dbad6ca 100644
--- a/drivers/media/tuners/tea5761.c
+++ b/drivers/media/tuners/tea5761.c
@@ -1,10 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * For Philips TEA5761 FM Chip
  * I2C address is allways 0x20 (0x10 at 7-bit mode).
  *
  * Copyright (c) 2005-2007 Mauro Carvalho Chehab (mchehab@infradead.org)
- * This code is placed under the terms of the GNUv2 General Public License
- *
  */
 
 #include <linux/i2c.h>
@@ -341,4 +340,4 @@ EXPORT_SYMBOL_GPL(tea5761_autodetection);
 
 MODULE_DESCRIPTION("Philips TEA5761 FM tuner driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/tuners/tea5767.c b/drivers/media/tuners/tea5767.c
index 525b7ab90c80..d89764ad9209 100644
--- a/drivers/media/tuners/tea5767.c
+++ b/drivers/media/tuners/tea5767.c
@@ -1,10 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * For Philips TEA5767 FM Chip used on some TV Cards like Prolink Pixelview
  * I2C address is allways 0xC0.
  *
  *
  * Copyright (c) 2005 Mauro Carvalho Chehab (mchehab@infradead.org)
- * This code is placed under the terms of the GNU General Public License
  *
  * tea5767 autodetection thanks to Torsten Seeboth and Atsushi Nakagawa
  * from their contributions on DScaler.
@@ -473,4 +473,4 @@ EXPORT_SYMBOL_GPL(tea5767_autodetection);
 
 MODULE_DESCRIPTION("Philips TEA5767 FM tuner driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/tuners/tuner-xc2028-types.h b/drivers/media/tuners/tuner-xc2028-types.h
index 7e4798783db7..43949ff69e67 100644
--- a/drivers/media/tuners/tuner-xc2028-types.h
+++ b/drivers/media/tuners/tuner-xc2028-types.h
@@ -1,10 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
 /* tuner-xc2028_types
  *
  * This file includes internal tipes to be used inside tuner-xc2028.
  * Shouldn't be included outside tuner-xc2028
  *
  * Copyright (c) 2007-2008 Mauro Carvalho Chehab (mchehab@infradead.org)
- * This code is placed under the terms of the GNU General Public License v2
  */
 
 /* xc3028 firmware types */
diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index b5b62b08159e..d2870fba4591 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1,11 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
 /* tuner-xc2028
  *
  * Copyright (c) 2007-2008 Mauro Carvalho Chehab (mchehab@infradead.org)
  *
  * Copyright (c) 2007 Michel Ludwig (michel.ludwig@gmail.com)
  *       - frontend interface
- *
- * This code is placed under the terms of the GNU General Public License v2
  */
 
 #include <linux/i2c.h>
@@ -1521,6 +1520,6 @@ EXPORT_SYMBOL(xc2028_attach);
 MODULE_DESCRIPTION("Xceive xc2028/xc3028 tuner driver");
 MODULE_AUTHOR("Michel Ludwig <michel.ludwig@gmail.com>");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
 MODULE_FIRMWARE(XC3028L_DEFAULT_FIRMWARE);
diff --git a/drivers/media/tuners/tuner-xc2028.h b/drivers/media/tuners/tuner-xc2028.h
index 98e4effca896..b3c25dff96d8 100644
--- a/drivers/media/tuners/tuner-xc2028.h
+++ b/drivers/media/tuners/tuner-xc2028.h
@@ -1,7 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /* tuner-xc2028
  *
  * Copyright (c) 2007-2008 Mauro Carvalho Chehab (mchehab@infradead.org)
- * This code is placed under the terms of the GNU General Public License v2
  */
 
 #ifndef __TUNER_XC2028_H__
-- 
2.14.3
