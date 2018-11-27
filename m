Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35442 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729637AbeK0UbD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 15:31:03 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: bingbu.cao@intel.com, luca@lucaceresoli.net, ady.yeh@intel.com,
        tfiga@chromium.org
Subject: [PATCH 1/1] media: Use common test pattern menu entries
Date: Tue, 27 Nov 2018 11:33:41 +0200
Message-Id: <20181127093341.8909-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the test pattern menu itself is not standardised, many devices
support the same test patterns. Aligning the menu entries helps the user
space to use the interface, and adding macros for the menu entry strings
helps to keep them aligned.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/imx258.c             | 10 +++++-----
 drivers/media/i2c/imx319.c             | 10 +++++-----
 drivers/media/i2c/imx355.c             | 10 +++++-----
 drivers/media/i2c/ov2640.c             |  4 ++--
 drivers/media/i2c/smiapp/smiapp-core.c | 10 +++++-----
 include/uapi/linux/v4l2-controls.h     |  5 +++++
 6 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index f86ae18bc104..c795d4c4c0e4 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -498,11 +498,11 @@ static const struct imx258_reg mode_1048_780_regs[] = {
 };
 
 static const char * const imx258_test_pattern_menu[] = {
-	"Disabled",
-	"Solid Colour",
-	"Eight Vertical Colour Bars",
-	"Colour Bars With Fade to Grey",
-	"Pseudorandom Sequence (PN9)",
+	V4L2_TEST_PATTERN_DISABLED,
+	V4L2_TEST_PATTERN_SOLID_COLOUR,
+	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS,
+	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY,
+	V4L2_TEST_PATTERN_PN9,
 };
 
 /* Configurations for supported link frequencies */
diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
index 17c2e4b41221..eddaf69a67b6 100644
--- a/drivers/media/i2c/imx319.c
+++ b/drivers/media/i2c/imx319.c
@@ -1647,11 +1647,11 @@ static const struct imx319_reg mode_1280x720_regs[] = {
 };
 
 static const char * const imx319_test_pattern_menu[] = {
-	"Disabled",
-	"Solid Colour",
-	"Eight Vertical Colour Bars",
-	"Colour Bars With Fade to Grey",
-	"Pseudorandom Sequence (PN9)",
+	V4L2_TEST_PATTERN_DISABLED,
+	V4L2_TEST_PATTERN_SOLID_COLOUR,
+	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS,
+	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY,
+	V4L2_TEST_PATTERN_PN9,
 };
 
 /* supported link frequencies */
diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
index bed293b60e50..824d07156f9c 100644
--- a/drivers/media/i2c/imx355.c
+++ b/drivers/media/i2c/imx355.c
@@ -875,11 +875,11 @@ static const struct imx355_reg mode_820x616_regs[] = {
 };
 
 static const char * const imx355_test_pattern_menu[] = {
-	"Disabled",
-	"Solid Colour",
-	"Eight Vertical Colour Bars",
-	"Colour Bars With Fade to Grey",
-	"Pseudorandom Sequence (PN9)",
+	V4L2_TEST_PATTERN_DISABLED,
+	V4L2_TEST_PATTERN_SOLID_COLOUR,
+	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS,
+	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY,
+	V4L2_TEST_PATTERN_PN9,
 };
 
 /* supported link frequencies */
diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 5d2d6735cc78..507ec7176a7d 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -707,8 +707,8 @@ static int ov2640_reset(struct i2c_client *client)
 }
 
 static const char * const ov2640_test_pattern_menu[] = {
-	"Disabled",
-	"Eight Vertical Colour Bars",
+	V4L2_TEST_PATTERN_DISABLED,
+	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS,
 };
 
 /*
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 58a45c353e27..f6a92b9f178c 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -409,11 +409,11 @@ static void smiapp_update_mbus_formats(struct smiapp_sensor *sensor)
 }
 
 static const char * const smiapp_test_patterns[] = {
-	"Disabled",
-	"Solid Colour",
-	"Eight Vertical Colour Bars",
-	"Colour Bars With Fade to Grey",
-	"Pseudorandom Sequence (PN9)",
+	V4L2_TEST_PATTERN_DISABLED,
+	V4L2_TEST_PATTERN_SOLID_COLOUR,
+	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS,
+	V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY,
+	V4L2_TEST_PATTERN_PN9,
 };
 
 static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 998983a6e6b7..a74ff6f1ac88 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -1014,6 +1014,11 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
+#define V4L2_TEST_PATTERN_DISABLED		"Disabled"
+#define V4L2_TEST_PATTERN_SOLID_COLOUR		"Solid Colour"
+#define V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS		"Eight Vertical Colour Bars"
+#define V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY "Colour Bars With Fade to Grey"
+#define V4L2_TEST_PATTERN_PN9			"Pseudorandom Sequence (PN9)"
 #define V4L2_CID_DEINTERLACING_MODE		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
 #define V4L2_CID_DIGITAL_GAIN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 5)
 
-- 
2.11.0
