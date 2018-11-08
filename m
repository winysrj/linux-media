Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:47484 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728556AbeKHMVr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 07:21:47 -0500
From: jasonx.z.chen@intel.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, andy.yeh@intel.com,
        tfiga@chromium.org
Subject: [PATCH] media: imx258: remove test pattern map from driver
Date: Thu,  8 Nov 2018 10:47:34 +0800
Message-Id: <1541645254-11011-1-git-send-email-jasonx.z.chen@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Chen, JasonX Z" <jasonx.z.chen@intel.com>

change bayer order when using test pattern mode.
remove test pattern mapping method

Signed-off-by: Chen, JasonX Z <jasonx.z.chen@intel.com>
---
 drivers/media/i2c/imx258.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index 31a1e22..5a72b4a 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -62,11 +62,6 @@
 
 /* Test Pattern Control */
 #define IMX258_REG_TEST_PATTERN		0x0600
-#define IMX258_TEST_PATTERN_DISABLE	0
-#define IMX258_TEST_PATTERN_SOLID_COLOR	1
-#define IMX258_TEST_PATTERN_COLOR_BARS	2
-#define IMX258_TEST_PATTERN_GREY_COLOR	3
-#define IMX258_TEST_PATTERN_PN9		4
 
 /* Orientation */
 #define REG_MIRROR_FLIP_CONTROL		0x0101
@@ -504,20 +499,12 @@ struct imx258_mode {
 
 static const char * const imx258_test_pattern_menu[] = {
 	"Disabled",
-	"Color Bars",
 	"Solid Color",
+	"Color Bars",
 	"Grey Color Bars",
 	"PN9"
 };
 
-static const int imx258_test_pattern_val[] = {
-	IMX258_TEST_PATTERN_DISABLE,
-	IMX258_TEST_PATTERN_COLOR_BARS,
-	IMX258_TEST_PATTERN_SOLID_COLOR,
-	IMX258_TEST_PATTERN_GREY_COLOR,
-	IMX258_TEST_PATTERN_PN9,
-};
-
 /* Configurations for supported link frequencies */
 #define IMX258_LINK_FREQ_634MHZ	633600000ULL
 #define IMX258_LINK_FREQ_320MHZ	320000000ULL
@@ -757,6 +744,7 @@ static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
 	 * Applying V4L2 control value only happens
 	 * when power is up for streaming
 	 */
+
 	if (pm_runtime_get_if_in_use(&client->dev) == 0)
 		return 0;
 
@@ -778,13 +766,10 @@ static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_TEST_PATTERN:
 		ret = imx258_write_reg(imx258, IMX258_REG_TEST_PATTERN,
 				IMX258_REG_VALUE_16BIT,
-				imx258_test_pattern_val[ctrl->val]);
-
+				ctrl->val);
 		ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
 				IMX258_REG_VALUE_08BIT,
-				ctrl->val == imx258_test_pattern_val
-				[IMX258_TEST_PATTERN_DISABLE] ?
-				REG_CONFIG_MIRROR_FLIP :
+				!ctrl->val ? REG_CONFIG_MIRROR_FLIP :
 				REG_CONFIG_FLIP_TEST_PATTERN);
 		break;
 	default:
-- 
1.9.1
