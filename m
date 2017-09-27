Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:27346 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751590AbdI0SZN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:13 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 04/13] staging: atomisp: Switch i2c drivers to use ->probe_new()
Date: Wed, 27 Sep 2017 21:24:59 +0300
Message-Id: <20170927182508.52119-5-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
References: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since most of the drivers are being used on ACPI enabled platforms
there is no need to keep legacy API support for them. Thus, switch
to ->probe_new() callback and remove orphaned code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/Kconfig            |  9 +++++++--
 drivers/staging/media/atomisp/i2c/gc0310.c           | 12 ++++--------
 drivers/staging/media/atomisp/i2c/gc0310.h           |  7 -------
 drivers/staging/media/atomisp/i2c/gc2235.c           | 13 +++++--------
 drivers/staging/media/atomisp/i2c/gc2235.h           |  7 -------
 drivers/staging/media/atomisp/i2c/lm3554.c           | 18 ++++--------------
 drivers/staging/media/atomisp/i2c/mt9m114.c          | 11 +++--------
 drivers/staging/media/atomisp/i2c/mt9m114.h          |  5 -----
 drivers/staging/media/atomisp/i2c/ov2680.c           | 14 ++++----------
 drivers/staging/media/atomisp/i2c/ov2680.h           | 10 ----------
 drivers/staging/media/atomisp/i2c/ov2722.c           | 13 ++++---------
 drivers/staging/media/atomisp/i2c/ov2722.h           |  7 -------
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig     |  2 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c    | 12 ++++--------
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h    |  7 -------
 drivers/staging/media/atomisp/i2c/ov8858.c           | 20 +++++---------------
 drivers/staging/media/atomisp/i2c/ov8858.h           |  1 -
 drivers/staging/media/atomisp/i2c/ov8858_btns.h      |  1 -
 drivers/staging/media/atomisp/include/media/lm3554.h |  1 -
 19 files changed, 41 insertions(+), 129 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/Kconfig b/drivers/staging/media/atomisp/i2c/Kconfig
index 4da028d919c5..74bd45e54d69 100644
--- a/drivers/staging/media/atomisp/i2c/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/Kconfig
@@ -6,6 +6,7 @@ source "drivers/staging/media/atomisp/i2c/ov5693/Kconfig"
 
 config VIDEO_OV2722
        tristate "OVT ov2722 sensor support"
+	depends on ACPI
        depends on I2C && VIDEO_V4L2
        ---help---
 	 This is a Video4Linux2 sensor-level driver for the OVT
@@ -17,6 +18,7 @@ config VIDEO_OV2722
 
 config VIDEO_GC2235
        tristate "Galaxy gc2235 sensor support"
+	depends on ACPI
        depends on I2C && VIDEO_V4L2
        ---help---
 	 This is a Video4Linux2 sensor-level driver for the OVT
@@ -28,6 +30,7 @@ config VIDEO_GC2235
 
 config VIDEO_OV8858
        tristate "Omnivision ov8858 sensor support"
+	depends on ACPI
        depends on I2C && VIDEO_V4L2 && VIDEO_ATOMISP
        ---help---
 	 This is a Video4Linux2 sensor-level driver for the Omnivision
@@ -49,6 +52,7 @@ config VIDEO_MSRLIST_HELPER
 
 config VIDEO_MT9M114
        tristate "Aptina mt9m114 sensor support"
+	depends on ACPI
        depends on I2C && VIDEO_V4L2
        ---help---
 	 This is a Video4Linux2 sensor-level driver for the Micron
@@ -60,6 +64,7 @@ config VIDEO_MT9M114
 
 config VIDEO_GC0310
 	tristate "GC0310 sensor support"
+	depends on ACPI
 	depends on I2C && VIDEO_V4L2
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Galaxycore
@@ -67,6 +72,7 @@ config VIDEO_GC0310
 	 
 config VIDEO_OV2680
        tristate "Omnivision OV2680 sensor support"
+	depends on ACPI
        depends on I2C && VIDEO_V4L2
        ---help---
 	 This is a Video4Linux2 sensor-level driver for the Omnivision
@@ -82,6 +88,7 @@ config VIDEO_OV2680
 
 config VIDEO_LM3554
        tristate "LM3554 flash light driver"
+	depends on ACPI
        depends on VIDEO_V4L2 && I2C
        ---help---
 	 This is a Video4Linux2 sub-dev driver for the LM3554
@@ -89,5 +96,3 @@ config VIDEO_LM3554
 
 	 To compile this driver as a module, choose M here: the
 	 module will be called lm3554
-
-
diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index 730fa5dd80f5..6f54304f1ca0 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -1375,8 +1375,7 @@ static int gc0310_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int gc0310_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int gc0310_probe(struct i2c_client *client)
 {
 	struct gc0310_device *dev;
 	int ret;
@@ -1457,18 +1456,15 @@ static const struct acpi_device_id gc0310_acpi_match[] = {
 	{"INT0310"},
 	{},
 };
-
 MODULE_DEVICE_TABLE(acpi, gc0310_acpi_match);
 
-MODULE_DEVICE_TABLE(i2c, gc0310_id);
 static struct i2c_driver gc0310_driver = {
 	.driver = {
-		.name = GC0310_NAME,
-		.acpi_match_table = ACPI_PTR(gc0310_acpi_match),
+		.name = "gc0310",
+		.acpi_match_table = gc0310_acpi_match,
 	},
-	.probe = gc0310_probe,
+	.probe_new = gc0310_probe,
 	.remove = gc0310_remove,
-	.id_table = gc0310_id,
 };
 module_i2c_driver(gc0310_driver);
 
diff --git a/drivers/staging/media/atomisp/i2c/gc0310.h b/drivers/staging/media/atomisp/i2c/gc0310.h
index 7d8a0aeecb6c..7e97e45b4f79 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.h
+++ b/drivers/staging/media/atomisp/i2c/gc0310.h
@@ -36,8 +36,6 @@
 
 #include "../include/linux/atomisp_platform.h"
 
-#define GC0310_NAME		"gc0310"
-
 /* Defines for register writes and register array processing */
 #define I2C_MSG_LENGTH		1
 #define I2C_RETRY_COUNT		5
@@ -196,11 +194,6 @@ struct gc0310_write_ctrl {
 	struct gc0310_write_buffer buffer;
 };
 
-static const struct i2c_device_id gc0310_id[] = {
-	{GC0310_NAME, 0},
-	{}
-};
-
 /*
  * Register settings for various resolution
  */
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 6d4a432b6bae..8ed12e16caf4 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -1114,8 +1114,7 @@ static int gc2235_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int gc2235_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int gc2235_probe(struct i2c_client *client)
 {
 	struct gc2235_device *dev;
 	void *gcpdev;
@@ -1187,17 +1186,15 @@ static const struct acpi_device_id gc2235_acpi_match[] = {
 	{ "INT33F8" },
 	{},
 };
-
 MODULE_DEVICE_TABLE(acpi, gc2235_acpi_match);
-MODULE_DEVICE_TABLE(i2c, gc2235_id);
+
 static struct i2c_driver gc2235_driver = {
 	.driver = {
-		.name = GC2235_NAME,
-		.acpi_match_table = ACPI_PTR(gc2235_acpi_match),
+		.name = "gc2235",
+		.acpi_match_table = gc2235_acpi_match,
 	},
-	.probe = gc2235_probe,
+	.probe_new = gc2235_probe,
 	.remove = gc2235_remove,
-	.id_table = gc2235_id,
 };
 module_i2c_driver(gc2235_driver);
 
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.h b/drivers/staging/media/atomisp/i2c/gc2235.h
index a8d6aa9c9a5d..3c30a05c3991 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.h
+++ b/drivers/staging/media/atomisp/i2c/gc2235.h
@@ -33,8 +33,6 @@
 
 #include "../include/linux/atomisp_platform.h"
 
-#define GC2235_NAME		"gc2235"
-
 /* Defines for register writes and register array processing */
 #define I2C_MSG_LENGTH		0x2
 #define I2C_RETRY_COUNT		5
@@ -200,11 +198,6 @@ struct gc2235_write_ctrl {
 	struct gc2235_write_buffer buffer;
 };
 
-static const struct i2c_device_id gc2235_id[] = {
-	{GC2235_NAME, 0},
-	{}
-};
-
 static struct gc2235_reg const gc2235_stream_on[] = {
 	{ GC2235_8BIT, 0xfe, 0x03}, /* switch to P3 */
 	{ GC2235_8BIT, 0x10, 0x91}, /* start mipi */
diff --git a/drivers/staging/media/atomisp/i2c/lm3554.c b/drivers/staging/media/atomisp/i2c/lm3554.c
index 5424685eb447..f74380074177 100644
--- a/drivers/staging/media/atomisp/i2c/lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/lm3554.c
@@ -862,8 +862,7 @@ static void *lm3554_platform_data_func(struct i2c_client *client)
 	return &platform_data;
 }
 
-static int lm3554_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
+static int lm3554_probe(struct i2c_client *client)
 {
 	int err = 0;
 	struct lm3554 *flash;
@@ -962,13 +961,6 @@ static int lm3554_remove(struct i2c_client *client)
 	return ret;
 }
 
-static const struct i2c_device_id lm3554_id[] = {
-	{LM3554_NAME, 0},
-	{},
-};
-
-MODULE_DEVICE_TABLE(i2c, lm3554_id);
-
 static const struct dev_pm_ops lm3554_pm_ops = {
 	.suspend = lm3554_suspend,
 	.resume = lm3554_resume,
@@ -978,18 +970,16 @@ static const struct acpi_device_id lm3554_acpi_match[] = {
 	{ "INTCF1C" },
 	{},
 };
-
 MODULE_DEVICE_TABLE(acpi, lm3554_acpi_match);
 
 static struct i2c_driver lm3554_driver = {
 	.driver = {
-		.name = LM3554_NAME,
+		.name = "lm3554",
 		.pm   = &lm3554_pm_ops,
-		.acpi_match_table = ACPI_PTR(lm3554_acpi_match),
+		.acpi_match_table = lm3554_acpi_match,
 	},
-	.probe = lm3554_probe,
+	.probe_new = lm3554_probe,
 	.remove = lm3554_remove,
-	.id_table = lm3554_id,
 };
 module_i2c_driver(lm3554_driver);
 
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 14fe39f9feb6..8c75372782d8 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -1853,8 +1853,7 @@ static int mt9m114_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int mt9m114_probe(struct i2c_client *client,
-		       const struct i2c_device_id *id)
+static int mt9m114_probe(struct i2c_client *client)
 {
 	struct mt9m114_device *dev;
 	int ret = 0;
@@ -1926,24 +1925,20 @@ static int mt9m114_probe(struct i2c_client *client,
 	return 0;
 }
 
-MODULE_DEVICE_TABLE(i2c, mt9m114_id);
-
 static const struct acpi_device_id mt9m114_acpi_match[] = {
 	{ "INT33F0" },
 	{ "CRMT1040" },
 	{},
 };
-
 MODULE_DEVICE_TABLE(acpi, mt9m114_acpi_match);
 
 static struct i2c_driver mt9m114_driver = {
 	.driver = {
 		.name = "mt9m114",
-		.acpi_match_table = ACPI_PTR(mt9m114_acpi_match),
+		.acpi_match_table = mt9m114_acpi_match,
 	},
-	.probe = mt9m114_probe,
+	.probe_new = mt9m114_probe,
 	.remove = mt9m114_remove,
-	.id_table = mt9m114_id,
 };
 module_i2c_driver(mt9m114_driver);
 
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.h b/drivers/staging/media/atomisp/i2c/mt9m114.h
index 5e7d79d2e01b..1ad1b1ac55e7 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.h
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.h
@@ -394,11 +394,6 @@ static struct mt9m114_res_struct mt9m114_res[] = {
 };
 #define N_RES (ARRAY_SIZE(mt9m114_res))
 
-static const struct i2c_device_id mt9m114_id[] = {
-	{"mt9m114", 0},
-	{}
-};
-
 static struct misensor_reg const mt9m114_exitstandby[] = {
 	{MISENSOR_16BIT,  0x098E, 0xDC00},
 	/* exit-standby */
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 0dce3c03b2cd..99c6d699f899 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -1438,8 +1438,7 @@ static int ov2680_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int ov2680_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int ov2680_probe(struct i2c_client *client)
 {
 	struct ov2680_device *dev;
 	int ret;
@@ -1523,21 +1522,16 @@ static const struct acpi_device_id ov2680_acpi_match[] = {
 };
 MODULE_DEVICE_TABLE(acpi, ov2680_acpi_match);
 
-
-MODULE_DEVICE_TABLE(i2c, ov2680_id);
 static struct i2c_driver ov2680_driver = {
 	.driver = {
-		.name = OV2680_NAME,
-		.acpi_match_table = ACPI_PTR(ov2680_acpi_match),
-
+		.name = "ov2680",
+		.acpi_match_table = ov2680_acpi_match,
 	},
-	.probe = ov2680_probe,
+	.probe_new = ov2680_probe,
 	.remove = ov2680_remove,
-	.id_table = ov2680_id,
 };
 module_i2c_driver(ov2680_driver);
 
 MODULE_AUTHOR("Jacky Wang <Jacky_wang@ovt.com>");
 MODULE_DESCRIPTION("A low-level driver for OmniVision 2680 sensors");
 MODULE_LICENSE("GPL");
-
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.h b/drivers/staging/media/atomisp/i2c/ov2680.h
index ab8907e6c9ef..198c158de3f2 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.h
+++ b/drivers/staging/media/atomisp/i2c/ov2680.h
@@ -35,10 +35,6 @@
 
 #include "../include/linux/atomisp_platform.h"
 
-#define OV2680_NAME		"ov2680"
-#define OV2680B_NAME	"ov2680b"
-#define OV2680F_NAME	"ov2680f"
-
 /* Defines for register writes and register array processing */
 #define I2C_MSG_LENGTH		0x2
 #define I2C_RETRY_COUNT		5
@@ -227,12 +223,6 @@ struct ov2680_format {
 		struct ov2680_write_buffer buffer;
 	};
 
-	static const struct i2c_device_id ov2680_id[] = {
-		{OV2680B_NAME, 0},
-		{OV2680F_NAME, 0},
-		{}
-	};
-
 	static struct ov2680_reg const ov2680_global_setting[] = {
 	    {OV2680_8BIT, 0x0103, 0x01},
 	    {OV2680_8BIT, 0x3002, 0x00},
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.c b/drivers/staging/media/atomisp/i2c/ov2722.c
index c9b1b0cabe87..2481fda345c0 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/ov2722.c
@@ -1276,8 +1276,7 @@ static int __ov2722_init_ctrl_handler(struct ov2722_device *dev)
 	return 0;
 }
 
-static int ov2722_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int ov2722_probe(struct i2c_client *client)
 {
 	struct ov2722_device *dev;
 	void *ovpdev;
@@ -1335,23 +1334,19 @@ static int ov2722_probe(struct i2c_client *client,
 	return ret;
 }
 
-MODULE_DEVICE_TABLE(i2c, ov2722_id);
-
 static const struct acpi_device_id ov2722_acpi_match[] = {
 	{ "INT33FB" },
 	{},
 };
-
 MODULE_DEVICE_TABLE(acpi, ov2722_acpi_match);
 
 static struct i2c_driver ov2722_driver = {
 	.driver = {
-		.name = OV2722_NAME,
-		.acpi_match_table = ACPI_PTR(ov2722_acpi_match),
+		.name = "ov2722",
+		.acpi_match_table = ov2722_acpi_match,
 	},
-	.probe = ov2722_probe,
+	.probe_new = ov2722_probe,
 	.remove = ov2722_remove,
-	.id_table = ov2722_id,
 };
 module_i2c_driver(ov2722_driver);
 
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.h b/drivers/staging/media/atomisp/i2c/ov2722.h
index 73ecb1679718..3ee8eaadba49 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.h
+++ b/drivers/staging/media/atomisp/i2c/ov2722.h
@@ -35,8 +35,6 @@
 
 #include "../include/linux/atomisp_platform.h"
 
-#define OV2722_NAME		"ov2722"
-
 #define OV2722_POWER_UP_RETRY_NUM 5
 
 /* Defines for register writes and register array processing */
@@ -257,11 +255,6 @@ struct ov2722_write_ctrl {
 	struct ov2722_write_buffer buffer;
 };
 
-static const struct i2c_device_id ov2722_id[] = {
-	{OV2722_NAME, 0},
-	{}
-};
-
 /*
  * Register settings for various resolution
  */
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/Kconfig b/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
index 9e8d32521e7e..29b522237f39 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
@@ -1,5 +1,6 @@
 config VIDEO_OV5693
        tristate "Omnivision ov5693 sensor support"
+	depends on ACPI
        depends on I2C && VIDEO_V4L2
        ---help---
 	 This is a Video4Linux2 sensor-level driver for the Micron
@@ -8,4 +9,3 @@ config VIDEO_OV5693
 	 ov5693 is video camera sensor.
 
 	 It currently only works with the atomisp driver.
-
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index 0aafe5c37cc0..a083c61ad3ea 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -1935,8 +1935,7 @@ static int ov5693_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int ov5693_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int ov5693_probe(struct i2c_client *client)
 {
 	struct ov5693_device *dev;
 	int i2c;
@@ -2023,8 +2022,6 @@ static int ov5693_probe(struct i2c_client *client,
 	return ret;
 }
 
-MODULE_DEVICE_TABLE(i2c, ov5693_id);
-
 static const struct acpi_device_id ov5693_acpi_match[] = {
 	{"INT33BE"},
 	{},
@@ -2033,12 +2030,11 @@ MODULE_DEVICE_TABLE(acpi, ov5693_acpi_match);
 
 static struct i2c_driver ov5693_driver = {
 	.driver = {
-		.name = OV5693_NAME,
-		.acpi_match_table = ACPI_PTR(ov5693_acpi_match),
+		.name = "ov5693",
+		.acpi_match_table = ov5693_acpi_match,
 	},
-	.probe = ov5693_probe,
+	.probe_new = ov5693_probe,
 	.remove = ov5693_remove,
-	.id_table = ov5693_id,
 };
 module_i2c_driver(ov5693_driver);
 
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
index 8c2e6794463b..b94a72a300d4 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
@@ -35,8 +35,6 @@
 
 #include "../../include/linux/atomisp_platform.h"
 
-#define OV5693_NAME		"ov5693"
-
 #define OV5693_POWER_UP_RETRY_NUM 5
 
 /* Defines for register writes and register array processing */
@@ -278,11 +276,6 @@ struct ov5693_write_ctrl {
 	struct ov5693_write_buffer buffer;
 };
 
-static const struct i2c_device_id ov5693_id[] = {
-	{OV5693_NAME, 0},
-	{}
-};
-
 static struct ov5693_reg const ov5693_global_setting[] = {
 	{OV5693_8BIT, 0x0103, 0x01},
 	{OV5693_8BIT, 0x3001, 0x0a},
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.c b/drivers/staging/media/atomisp/i2c/ov8858.c
index d0d16b9015d0..28f277fa2bc9 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.c
+++ b/drivers/staging/media/atomisp/i2c/ov8858.c
@@ -2082,8 +2082,7 @@ static const struct v4l2_ctrl_config ctrls[] = {
 	}
 };
 
-static int ov8858_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int ov8858_probe(struct i2c_client *client)
 {
 	struct ov8858_device *dev;
 	unsigned int i;
@@ -2101,8 +2100,6 @@ static int ov8858_probe(struct i2c_client *client,
 
 	mutex_init(&dev->input_lock);
 
-	if (id)
-		dev->i2c_id = id->driver_data;
 	dev->fmt_idx = 0;
 	dev->sensor_id = OV_ID_DEFAULT;
 	dev->vcm_driver = &ov8858_vcms[OV8858_ID_DEFAULT];
@@ -2182,26 +2179,19 @@ static int ov8858_probe(struct i2c_client *client,
 	return ret;
 }
 
-static const struct i2c_device_id ov8858_id[] = {
-	{OV8858_NAME, 0},
-	{}
-};
-
-MODULE_DEVICE_TABLE(i2c, ov8858_id);
-
 static const struct acpi_device_id ov8858_acpi_match[] = {
 	{"INT3477"},
 	{},
 };
+MODULE_DEVICE_TABLE(acpi, ov8858_acpi_match);
 
 static struct i2c_driver ov8858_driver = {
 	.driver = {
-		.name = OV8858_NAME,
-		.acpi_match_table = ACPI_PTR(ov8858_acpi_match),
+		.name = "ov8858",
+		.acpi_match_table = ov8858_acpi_match,
 	},
-	.probe = ov8858_probe,
+	.probe_new = ov8858_probe,
 	.remove = ov8858_remove,
-	.id_table = ov8858_id,
 };
 module_i2c_driver(ov8858_driver);
 
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.h b/drivers/staging/media/atomisp/i2c/ov8858.h
index 638d1a803a2b..0f1b76e49a34 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.h
+++ b/drivers/staging/media/atomisp/i2c/ov8858.h
@@ -113,7 +113,6 @@
 
 #define OV_SUBDEV_PREFIX			"ov"
 #define OV_ID_DEFAULT				0x0000
-#define	OV8858_NAME				"ov8858"
 #define OV8858_CHIP_ID				0x8858
 
 #define OV8858_LONG_EXPO			0x3500
diff --git a/drivers/staging/media/atomisp/i2c/ov8858_btns.h b/drivers/staging/media/atomisp/i2c/ov8858_btns.h
index 7d74a8899fae..5cf03c220876 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858_btns.h
+++ b/drivers/staging/media/atomisp/i2c/ov8858_btns.h
@@ -113,7 +113,6 @@
 
 #define OV_SUBDEV_PREFIX			"ov"
 #define OV_ID_DEFAULT				0x0000
-#define	OV8858_NAME				"ov8858"
 #define OV8858_CHIP_ID				0x8858
 
 #define OV8858_LONG_EXPO			0x3500
diff --git a/drivers/staging/media/atomisp/include/media/lm3554.h b/drivers/staging/media/atomisp/include/media/lm3554.h
index 7d6a8c05dd52..df17d546f661 100644
--- a/drivers/staging/media/atomisp/include/media/lm3554.h
+++ b/drivers/staging/media/atomisp/include/media/lm3554.h
@@ -24,7 +24,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-subdev.h>
 
-#define LM3554_NAME    "lm3554"
 #define LM3554_ID      3554
 
 #define	v4l2_queryctrl_entry_integer(_id, _name,\
-- 
2.14.1
