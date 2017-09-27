Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:64738 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751973AbdI0SZn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:43 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 03/13] staging: atomisp: Use module_i2c_driver() macro
Date: Wed, 27 Sep 2017 21:24:58 +0300
Message-Id: <20170927182508.52119-4-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
References: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is done using coccinelle semantic patch:

//<smpl>
@a@
identifier f, x;
@@
-static f(...) { return i2c_add_driver(&x); }

@b depends on a@
identifier e, a.x;
@@
-static e(...) { i2c_del_driver(&x); }

@c depends on a && b@
identifier a.f;
declarer name module_init;
@@
-module_init(f);

@d depends on a && b && c@
identifier b.e, a.x;
declarer name module_exit;
declarer name module_i2c_driver;
@@
-module_exit(e);
+module_i2c_driver(x);
//</smpl>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/gc0310.c        | 15 +--------------
 drivers/staging/media/atomisp/i2c/gc2235.c        | 15 +--------------
 drivers/staging/media/atomisp/i2c/lm3554.c        | 13 +------------
 drivers/staging/media/atomisp/i2c/mt9m114.c       | 14 +-------------
 drivers/staging/media/atomisp/i2c/ov2680.c        | 16 +---------------
 drivers/staging/media/atomisp/i2c/ov2722.c        | 15 +--------------
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c | 15 +--------------
 drivers/staging/media/atomisp/i2c/ov8858.c        | 14 +-------------
 8 files changed, 8 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index 35ed51ffe944..730fa5dd80f5 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -1470,20 +1470,7 @@ static struct i2c_driver gc0310_driver = {
 	.remove = gc0310_remove,
 	.id_table = gc0310_id,
 };
-
-static int init_gc0310(void)
-{
-	return i2c_add_driver(&gc0310_driver);
-}
-
-static void exit_gc0310(void)
-{
-
-	i2c_del_driver(&gc0310_driver);
-}
-
-module_init(init_gc0310);
-module_exit(exit_gc0310);
+module_i2c_driver(gc0310_driver);
 
 MODULE_AUTHOR("Lai, Angie <angie.lai@intel.com>");
 MODULE_DESCRIPTION("A low-level driver for GalaxyCore GC0310 sensors");
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index e43d31ea9676..6d4a432b6bae 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -1199,20 +1199,7 @@ static struct i2c_driver gc2235_driver = {
 	.remove = gc2235_remove,
 	.id_table = gc2235_id,
 };
-
-static int init_gc2235(void)
-{
-	return i2c_add_driver(&gc2235_driver);
-}
-
-static void exit_gc2235(void)
-{
-
-	i2c_del_driver(&gc2235_driver);
-}
-
-module_init(init_gc2235);
-module_exit(exit_gc2235);
+module_i2c_driver(gc2235_driver);
 
 MODULE_AUTHOR("Shuguang Gong <Shuguang.Gong@intel.com>");
 MODULE_DESCRIPTION("A low-level driver for GC2235 sensors");
diff --git a/drivers/staging/media/atomisp/i2c/lm3554.c b/drivers/staging/media/atomisp/i2c/lm3554.c
index 679176f7c542..5424685eb447 100644
--- a/drivers/staging/media/atomisp/i2c/lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/lm3554.c
@@ -991,19 +991,8 @@ static struct i2c_driver lm3554_driver = {
 	.remove = lm3554_remove,
 	.id_table = lm3554_id,
 };
+module_i2c_driver(lm3554_driver);
 
-static __init int init_lm3554(void)
-{
-	return i2c_add_driver(&lm3554_driver);
-}
-
-static __exit void exit_lm3554(void)
-{
-	i2c_del_driver(&lm3554_driver);
-}
-
-module_init(init_lm3554);
-module_exit(exit_lm3554);
 MODULE_AUTHOR("Jing Tao <jing.tao@intel.com>");
 MODULE_DESCRIPTION("LED flash driver for LM3554");
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 3c837cb8859c..14fe39f9feb6 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -1945,19 +1945,7 @@ static struct i2c_driver mt9m114_driver = {
 	.remove = mt9m114_remove,
 	.id_table = mt9m114_id,
 };
-
-static __init int init_mt9m114(void)
-{
-	return i2c_add_driver(&mt9m114_driver);
-}
-
-static __exit void exit_mt9m114(void)
-{
-	i2c_del_driver(&mt9m114_driver);
-}
-
-module_init(init_mt9m114);
-module_exit(exit_mt9m114);
+module_i2c_driver(mt9m114_driver);
 
 MODULE_AUTHOR("Shuguang Gong <Shuguang.gong@intel.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 51b7d61df0f5..0dce3c03b2cd 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -1527,7 +1527,6 @@ MODULE_DEVICE_TABLE(acpi, ov2680_acpi_match);
 MODULE_DEVICE_TABLE(i2c, ov2680_id);
 static struct i2c_driver ov2680_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = OV2680_NAME,
 		.acpi_match_table = ACPI_PTR(ov2680_acpi_match),
 
@@ -1536,20 +1535,7 @@ static struct i2c_driver ov2680_driver = {
 	.remove = ov2680_remove,
 	.id_table = ov2680_id,
 };
-
-static int init_ov2680(void)
-{
-	return i2c_add_driver(&ov2680_driver);
-}
-
-static void exit_ov2680(void)
-{
-
-	i2c_del_driver(&ov2680_driver);
-}
-
-module_init(init_ov2680);
-module_exit(exit_ov2680);
+module_i2c_driver(ov2680_driver);
 
 MODULE_AUTHOR("Jacky Wang <Jacky_wang@ovt.com>");
 MODULE_DESCRIPTION("A low-level driver for OmniVision 2680 sensors");
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.c b/drivers/staging/media/atomisp/i2c/ov2722.c
index 10094ac56561..c9b1b0cabe87 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/ov2722.c
@@ -1353,20 +1353,7 @@ static struct i2c_driver ov2722_driver = {
 	.remove = ov2722_remove,
 	.id_table = ov2722_id,
 };
-
-static int init_ov2722(void)
-{
-	return i2c_add_driver(&ov2722_driver);
-}
-
-static void exit_ov2722(void)
-{
-
-	i2c_del_driver(&ov2722_driver);
-}
-
-module_init(init_ov2722);
-module_exit(exit_ov2722);
+module_i2c_driver(ov2722_driver);
 
 MODULE_AUTHOR("Wei Liu <wei.liu@intel.com>");
 MODULE_DESCRIPTION("A low-level driver for OmniVision 2722 sensors");
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index 219501167584..0aafe5c37cc0 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -2040,20 +2040,7 @@ static struct i2c_driver ov5693_driver = {
 	.remove = ov5693_remove,
 	.id_table = ov5693_id,
 };
-
-static int init_ov5693(void)
-{
-	return i2c_add_driver(&ov5693_driver);
-}
-
-static void exit_ov5693(void)
-{
-
-	i2c_del_driver(&ov5693_driver);
-}
-
-module_init(init_ov5693);
-module_exit(exit_ov5693);
+module_i2c_driver(ov5693_driver);
 
 MODULE_DESCRIPTION("A low-level driver for OmniVision 5693 sensors");
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.c b/drivers/staging/media/atomisp/i2c/ov8858.c
index 43e1638fd674..d0d16b9015d0 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.c
+++ b/drivers/staging/media/atomisp/i2c/ov8858.c
@@ -2203,19 +2203,7 @@ static struct i2c_driver ov8858_driver = {
 	.remove = ov8858_remove,
 	.id_table = ov8858_id,
 };
-
-static __init int ov8858_init_mod(void)
-{
-	return i2c_add_driver(&ov8858_driver);
-}
-
-static __exit void ov8858_exit_mod(void)
-{
-	i2c_del_driver(&ov8858_driver);
-}
-
-module_init(ov8858_init_mod);
-module_exit(ov8858_exit_mod);
+module_i2c_driver(ov8858_driver);
 
 MODULE_DESCRIPTION("A low-level driver for Omnivision OV8858 sensors");
 MODULE_LICENSE("GPL");
-- 
2.14.1
