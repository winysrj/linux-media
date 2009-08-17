Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45461 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbZHQXV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 19:21:59 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 1/5 - v3]V4L: vpfe capture - adding new fields for vpfe capture enhancements
Date: Mon, 17 Aug 2009 19:21:54 -0400
Message-Id: <1250551314-32662-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Resending with V4L prefix.....

Restructured the patch to apply cleanly. This will allow compilation after
applying each patch. To do this existing fields in the header files are
retained and removed later when the new fields are used.

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to V4L-DVB linux-next repository
 include/media/davinci/vpfe_capture.h |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index 71d8982..196245e 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -47,6 +47,8 @@ struct vpfe_pixel_format {
 	struct v4l2_fmtdesc fmtdesc;
 	/* bytes per pixel */
 	int bpp;
+	/* decoder format */
+	u32 subdev_pix_fmt;
 };
 
 struct vpfe_std_info {
@@ -61,9 +63,16 @@ struct vpfe_route {
 	u32 output;
 };
 
+enum vpfe_subdev_id {
+	VPFE_SUBDEV_TVP5146 = 1,
+	VPFE_SUBDEV_MT9T031 = 2
+};
+
 struct vpfe_subdev_info {
-	/* Sub device name */
+	/* Deprecated. Will be removed in the next patch */
 	char name[32];
+	/* Sub device module name */
+	char module_name[32];
 	/* Sub device group id */
 	int grp_id;
 	/* Number of inputs supported */
@@ -72,12 +81,16 @@ struct vpfe_subdev_info {
 	struct v4l2_input *inputs;
 	/* Sub dev routing information for each input */
 	struct vpfe_route *routes;
-	/* check if sub dev supports routing */
-	int can_route;
 	/* ccdc bus/interface configuration */
 	struct vpfe_hw_if_param ccdc_if_params;
 	/* i2c subdevice board info */
 	struct i2c_board_info board_info;
+	/* Is this a camera sub device ? */
+	unsigned is_camera:1;
+	/* check if sub dev supports routing */
+	unsigned can_route:1;
+	/* registered ? */
+	unsigned registered:1;
 };
 
 struct vpfe_config {
@@ -92,6 +105,12 @@ struct vpfe_config {
 	/* vpfe clock */
 	struct clk *vpssclk;
 	struct clk *slaveclk;
+	/* setup function for the input path */
+	int (*setup_input)(enum vpfe_subdev_id id);
+	/* number of clocks */
+	int num_clocks;
+	/* clocks used for vpfe capture */
+	char *clocks[];
 };
 
 struct vpfe_device {
@@ -102,6 +121,8 @@ struct vpfe_device {
 	struct v4l2_subdev **sd;
 	/* vpfe cfg */
 	struct vpfe_config *cfg;
+	/* clock ptrs for vpfe capture */
+	struct clk **clks;
 	/* V4l2 device */
 	struct v4l2_device v4l2_dev;
 	/* parent device */
-- 
1.6.0.4

