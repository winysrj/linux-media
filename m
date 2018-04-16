Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36121 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752118AbeDPQhV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 12:37:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Guillermo O. Freschi" <kedrot@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org
Subject: [PATCH 5/9] media: staging: atomisp: Comment out several unused sensor resolutions
Date: Mon, 16 Apr 2018 12:37:08 -0400
Message-Id: <e7b962245e375f7e8df9fa3ff8b6e4bd997a08a3.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The register settings for several resolutions aren't used
currently. So, comment them out.

Fix those warnings:

In file included from drivers/staging/media/atomisp/i2c/atomisp-gc2235.c:35:0:
drivers/staging/media/atomisp/i2c/gc2235.h:340:32: warning: 'gc2235_960_640_30fps' defined but not used [-Wunused-const-variable=]
 static struct gc2235_reg const gc2235_960_640_30fps[] = {
                                ^~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/gc2235.h:287:32: warning: 'gc2235_1296_736_30fps' defined but not used [-Wunused-const-variable=]
 static struct gc2235_reg const gc2235_1296_736_30fps[] = {
                                ^~~~~~~~~~~~~~~~~~~~~
In file included from drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:35:0:
drivers/staging/media/atomisp/i2c/ov2722.h:999:32: warning: 'ov2722_720p_30fps' defined but not used [-Wunused-const-variable=]
 static struct ov2722_reg const ov2722_720p_30fps[] = {
                                ^~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2722.h:787:32: warning: 'ov2722_1M3_30fps' defined but not used [-Wunused-const-variable=]
 static struct ov2722_reg const ov2722_1M3_30fps[] = {
                                ^~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2722.h:476:32: warning: 'ov2722_VGA_30fps' defined but not used [-Wunused-const-variable=]
 static struct ov2722_reg const ov2722_VGA_30fps[] = {
                                ^~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2722.h:367:32: warning: 'ov2722_480P_30fps' defined but not used [-Wunused-const-variable=]
 static struct ov2722_reg const ov2722_480P_30fps[] = {
                                ^~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2722.h:257:32: warning: 'ov2722_QVGA_30fps' defined but not used [-Wunused-const-variable=]
 static struct ov2722_reg const ov2722_QVGA_30fps[] = {
                                ^~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/atomisp-ov2680.c: In function '__ov2680_set_exposure':
In file included from drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:35:0:
At top level:
drivers/staging/media/atomisp/i2c/ov2680.h:736:33: warning: 'ov2680_1616x1082_30fps' defined but not used [-Wunused-const-variable=]
  static struct ov2680_reg const ov2680_1616x1082_30fps[] = {
                                 ^~~~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2680.h:649:33: warning: 'ov2680_1456x1096_30fps' defined but not used [-Wunused-const-variable=]
  static struct ov2680_reg const ov2680_1456x1096_30fps[]= {
                                 ^~~~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2680.h:606:33: warning: 'ov2680_1296x976_30fps' defined but not used [-Wunused-const-variable=]
  static struct ov2680_reg const ov2680_1296x976_30fps[] = {
                                 ^~~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2680.h:563:33: warning: 'ov2680_720p_30fps' defined but not used [-Wunused-const-variable=]
  static struct ov2680_reg const ov2680_720p_30fps[] = {
                                 ^~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2680.h:520:33: warning: 'ov2680_800x600_30fps' defined but not used [-Wunused-const-variable=]
  static struct ov2680_reg const ov2680_800x600_30fps[] = {
                                 ^~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2680.h:475:33: warning: 'ov2680_720x592_30fps' defined but not used [-Wunused-const-variable=]
  static struct ov2680_reg const ov2680_720x592_30fps[] = {
                                 ^~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2680.h:433:33: warning: 'ov2680_656x496_30fps' defined but not used [-Wunused-const-variable=]
  static struct ov2680_reg const ov2680_656x496_30fps[] = {
                                 ^~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2680.h:389:33: warning: 'ov2680_QVGA_30fps' defined but not used [-Wunused-const-variable=]
  static struct ov2680_reg const ov2680_QVGA_30fps[] = {
                                 ^~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2680.h:346:33: warning: 'ov2680_CIF_30fps' defined but not used [-Wunused-const-variable=]
  static struct ov2680_reg const ov2680_CIF_30fps[] = {
                                 ^~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov2680.h:301:33: warning: 'ov2680_QCIF_30fps' defined but not used [-Wunused-const-variable=]
  static struct ov2680_reg const ov2680_QCIF_30fps[] = {
                                 ^~~~~~~~~~~~~~~~~
In file included from drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:36:0:
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:988:32: warning: 'ov5693_1424x1168_30fps' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_1424x1168_30fps[] = {
                                ^~~~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:954:32: warning: 'ov5693_2592x1944_30fps' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_2592x1944_30fps[] = {
                                ^~~~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:889:32: warning: 'ov5693_2592x1456_30fps' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_2592x1456_30fps[] = {
                                ^~~~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:862:32: warning: 'ov5693_1940x1096' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_1940x1096[] = {
                                ^~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:796:32: warning: 'ov5693_1636p_30fps' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_1636p_30fps[] = {
                                ^~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:758:32: warning: 'ov5693_1296x736' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_1296x736[] = {
                                ^~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:730:32: warning: 'ov5693_976x556' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_976x556[] = {
                                ^~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:672:32: warning: 'ov5693_736x496' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_736x496[] = {
                                ^~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:643:32: warning: 'ov5693_192x160' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_192x160[] = {
                                ^~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:616:32: warning: 'ov5693_368x304' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_368x304[] = {
                                ^~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:587:32: warning: 'ov5693_336x256' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_336x256[] = {
                                ^~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:540:32: warning: 'ov5693_1296x976' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_1296x976[] = {
                                ^~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:509:32: warning: 'ov5693_654x496' defined but not used [-Wunused-const-variable=]
 static struct ov5693_reg const ov5693_654x496[] = {
                                ^~~~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.h        |  9 ++++++++-
 drivers/staging/media/atomisp/i2c/ov2680.h        |  5 ++++-
 drivers/staging/media/atomisp/i2c/ov2722.h        |  6 ++++++
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h | 18 +++++++++++++++++-
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.h b/drivers/staging/media/atomisp/i2c/gc2235.h
index 0e805bcfa4d8..54bf7812b27a 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.h
+++ b/drivers/staging/media/atomisp/i2c/gc2235.h
@@ -33,6 +33,11 @@
 
 #include "../include/linux/atomisp_platform.h"
 
+/*
+ * FIXME: non-preview resolutions are currently broken
+ */
+#define ENABLE_NON_PREVIEW     0
+
 /* Defines for register writes and register array processing */
 #define I2C_MSG_LENGTH		0x2
 #define I2C_RETRY_COUNT		5
@@ -284,6 +289,7 @@ static struct gc2235_reg const gc2235_init_settings[] = {
 /*
  * Register settings for various resolution
  */
+#if ENABLE_NON_PREVIEW
 static struct gc2235_reg const gc2235_1296_736_30fps[] = {
 	{ GC2235_8BIT, 0x8b, 0xa0 },
 	{ GC2235_8BIT, 0x8c, 0x02 },
@@ -387,6 +393,7 @@ static struct gc2235_reg const gc2235_960_640_30fps[] = {
 	{ GC2235_8BIT, 0xfe, 0x00 }, /* switch to P0 */
 	{ GC2235_TOK_TERM, 0, 0 }
 };
+#endif
 
 static struct gc2235_reg const gc2235_1600_900_30fps[] = {
 	{ GC2235_8BIT, 0x8b, 0xa0 },
@@ -578,7 +585,7 @@ static struct gc2235_resolution gc2235_res_preview[] = {
  * Disable non-preview configurations until the configuration selection is
  * improved.
  */
-#if 0
+#if ENABLE_NON_PREVIEW
 static struct gc2235_resolution gc2235_res_still[] = {
 	{
 		.desc = "gc2235_1600_900_30fps",
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.h b/drivers/staging/media/atomisp/i2c/ov2680.h
index c83ae379f517..bde2f148184d 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.h
+++ b/drivers/staging/media/atomisp/i2c/ov2680.h
@@ -295,6 +295,7 @@ struct ov2680_format {
 	};
 
 
+#if 0 /* None of the definitions below are used currently */
 	/*
 	 * 176x144 30fps  VBlanking 1lane 10Bit (binning)
 	 */
@@ -513,7 +514,6 @@ struct ov2680_format {
 		{OV2680_8BIT, 0x5081, 0x41},
 		{OV2680_TOK_TERM, 0, 0}
 	};
-
 	/*
 	* 800x600 30fps  VBlanking 1lane 10Bit (binning)
 	*/
@@ -685,6 +685,7 @@ struct ov2680_format {
 		// {OV2680_8BIT, 0x5090, 0x0c},
 		{OV2680_TOK_TERM, 0, 0}
 	};
+#endif
 
 	/*
 	 *1616x916  30fps  VBlanking 1lane 10bit
@@ -733,6 +734,7 @@ struct ov2680_format {
 	/*
 	 * 1612x1212 30fps VBlanking 1lane 10Bit
 	 */
+#if 0
 	static struct ov2680_reg const ov2680_1616x1082_30fps[] = {
 		{OV2680_8BIT, 0x3086, 0x00},
 		{OV2680_8BIT, 0x3501, 0x48},
@@ -772,6 +774,7 @@ struct ov2680_format {
 		{OV2680_8BIT, 0x5081, 0x41},
 		{OV2680_TOK_TERM, 0, 0}
         };
+#endif
 	/*
 	 * 1616x1216 30fps VBlanking 1lane 10Bit
 	 */
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.h b/drivers/staging/media/atomisp/i2c/ov2722.h
index 757b37613ccc..d99188a5c9d0 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.h
+++ b/drivers/staging/media/atomisp/i2c/ov2722.h
@@ -254,6 +254,7 @@ struct ov2722_write_ctrl {
 /*
  * Register settings for various resolution
  */
+#if 0
 static struct ov2722_reg const ov2722_QVGA_30fps[] = {
 	{OV2722_8BIT, 0x3718, 0x10},
 	{OV2722_8BIT, 0x3702, 0x0c},
@@ -581,6 +582,7 @@ static struct ov2722_reg const ov2722_VGA_30fps[] = {
 	{OV2722_8BIT, 0x3509, 0x10},
 	{OV2722_TOK_TERM, 0, 0},
 };
+#endif
 
 static struct ov2722_reg const ov2722_1632_1092_30fps[] = {
 	{OV2722_8BIT, 0x3021, 0x03}, /* For stand wait for
@@ -784,6 +786,7 @@ static struct ov2722_reg const ov2722_1452_1092_30fps[] = {
 	{OV2722_8BIT, 0x3509, 0x00},
 	{OV2722_TOK_TERM, 0, 0}
 };
+#if 0
 static struct ov2722_reg const ov2722_1M3_30fps[] = {
 	{OV2722_8BIT, 0x3718, 0x10},
 	{OV2722_8BIT, 0x3702, 0x24},
@@ -890,6 +893,7 @@ static struct ov2722_reg const ov2722_1M3_30fps[] = {
 	{OV2722_8BIT, 0x3509, 0x10},
 	{OV2722_TOK_TERM, 0, 0},
 };
+#endif
 
 static struct ov2722_reg const ov2722_1080p_30fps[] = {
 	{OV2722_8BIT, 0x3021, 0x03}, /* For stand wait for a whole
@@ -996,6 +1000,7 @@ static struct ov2722_reg const ov2722_1080p_30fps[] = {
 	{OV2722_TOK_TERM, 0, 0}
 };
 
+#if 0 /* Currently unused */
 static struct ov2722_reg const ov2722_720p_30fps[] = {
 	{OV2722_8BIT, 0x3021, 0x03},
 	{OV2722_8BIT, 0x3718, 0x10},
@@ -1095,6 +1100,7 @@ static struct ov2722_reg const ov2722_720p_30fps[] = {
 	{OV2722_8BIT, 0x3509, 0x00},
 	{OV2722_TOK_TERM, 0, 0},
 };
+#endif
 
 static struct ov2722_resolution ov2722_res_preview[] = {
 	{
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
index 9058a82455a6..bba99406785e 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
@@ -31,6 +31,12 @@
 
 #include "../../include/linux/atomisp_platform.h"
 
+/*
+ * FIXME: non-preview resolutions are currently broken
+ */
+#define ENABLE_NON_PREVIEW	0
+
+
 #define OV5693_POWER_UP_RETRY_NUM 5
 
 /* Defines for register writes and register array processing */
@@ -503,6 +509,7 @@ static struct ov5693_reg const ov5693_global_setting[] = {
 	{OV5693_TOK_TERM, 0, 0}
 };
 
+#if ENABLE_NON_PREVIEW
 /*
  * 654x496 30fps 17ms VBlanking 2lane 10Bit (Scaling)
  */
@@ -695,6 +702,7 @@ static struct ov5693_reg const ov5693_736x496[] = {
 	{OV5693_8BIT, 0x0100, 0x01},
 	{OV5693_TOK_TERM, 0, 0}
 };
+#endif
 
 /*
 static struct ov5693_reg const ov5693_736x496[] = {
@@ -727,6 +735,7 @@ static struct ov5693_reg const ov5693_736x496[] = {
 /*
  * 976x556 30fps 8.8ms VBlanking 2lane 10Bit (Scaling)
  */
+#if ENABLE_NON_PREVIEW
 static struct ov5693_reg const ov5693_976x556[] = {
 	{OV5693_8BIT, 0x3501, 0x7b},
 	{OV5693_8BIT, 0x3502, 0x00},
@@ -819,6 +828,7 @@ static struct ov5693_reg const ov5693_1636p_30fps[] = {
 	{OV5693_8BIT, 0x0100, 0x01},
 	{OV5693_TOK_TERM, 0, 0}
 };
+#endif
 
 static struct ov5693_reg const ov5693_1616x1216_30fps[] = {
 	{OV5693_8BIT, 0x3501, 0x7b},
@@ -859,6 +869,7 @@ static struct ov5693_reg const ov5693_1616x1216_30fps[] = {
 /*
  * 1940x1096 30fps 8.8ms VBlanking 2lane 10bit (Scaling)
  */
+#if ENABLE_NON_PREVIEW
 static struct ov5693_reg const ov5693_1940x1096[] = {
 	{OV5693_8BIT, 0x3501, 0x7b},
 	{OV5693_8BIT, 0x3502, 0x00},
@@ -916,6 +927,7 @@ static struct ov5693_reg const ov5693_2592x1456_30fps[] = {
 	{OV5693_8BIT, 0x5002, 0x00},
 	{OV5693_TOK_TERM, 0, 0}
 };
+#endif
 
 static struct ov5693_reg const ov5693_2576x1456_30fps[] = {
 	{OV5693_8BIT, 0x3501, 0x7b},
@@ -951,6 +963,7 @@ static struct ov5693_reg const ov5693_2576x1456_30fps[] = {
 /*
  * 2592x1944 30fps 0.6ms VBlanking 2lane 10Bit
  */
+#if ENABLE_NON_PREVIEW
 static struct ov5693_reg const ov5693_2592x1944_30fps[] = {
 	{OV5693_8BIT, 0x3501, 0x7b},
 	{OV5693_8BIT, 0x3502, 0x00},
@@ -977,6 +990,7 @@ static struct ov5693_reg const ov5693_2592x1944_30fps[] = {
 	{OV5693_8BIT, 0x0100, 0x01},
 	{OV5693_TOK_TERM, 0, 0}
 };
+#endif
 
 /*
  * 11:9 Full FOV Output, expected FOV Res: 2346x1920
@@ -985,6 +999,7 @@ static struct ov5693_reg const ov5693_2592x1944_30fps[] = {
  *
  * WA: Left Offset: 8, Hor scal: 64
  */
+#if ENABLE_NON_PREVIEW
 static struct ov5693_reg const ov5693_1424x1168_30fps[] = {
 	{OV5693_8BIT, 0x3501, 0x3b}, /* long exposure[15:8] */
 	{OV5693_8BIT, 0x3502, 0x80}, /* long exposure[7:0] */
@@ -1019,6 +1034,7 @@ static struct ov5693_reg const ov5693_1424x1168_30fps[] = {
 	{OV5693_8BIT, 0x0100, 0x01},
 	{OV5693_TOK_TERM, 0, 0}
 };
+#endif
 
 /*
  * 3:2 Full FOV Output, expected FOV Res: 2560x1706
@@ -1151,7 +1167,7 @@ static struct ov5693_resolution ov5693_res_preview[] = {
  * Disable non-preview configurations until the configuration selection is
  * improved.
  */
-#if 0
+#if ENABLE_NON_PREVIEW
 struct ov5693_resolution ov5693_res_still[] = {
 	{
 		.desc = "ov5693_736x496_30fps",
-- 
2.14.3
