Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:56756 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0JEOZF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 10:25:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH/RFC v3 02/11] v4l: Rename V4L2_MBUS_FMT_GREY8_1X8 to V4L2_MBUS_FMT_Y8_1X8
Date: Tue,  5 Oct 2010 16:25:05 +0200
Message-Id: <1286288714-16506-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

For consistency with the V4L2_MBUS_FMT_Y10_1X10 format.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m001.c        |    2 +-
 drivers/media/video/mt9v022.c        |    4 ++--
 drivers/media/video/sh_mobile_csi2.c |    6 +++---
 drivers/media/video/soc_mediabus.c   |    2 +-
 include/linux/v4l2-mediabus.h        |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 79f096d..c6adc41 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -79,7 +79,7 @@ static const struct mt9m001_datafmt mt9m001_colour_fmts[] = {
 static const struct mt9m001_datafmt mt9m001_monochrome_fmts[] = {
 	/* Order important - see above */
 	{V4L2_MBUS_FMT_Y10_1X10, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_GREY8_1X8, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_Y8_1X8, V4L2_COLORSPACE_JPEG},
 };
 
 struct mt9m001 {
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index e7cd23c..196c291 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -95,7 +95,7 @@ static const struct mt9v022_datafmt mt9v022_colour_fmts[] = {
 static const struct mt9v022_datafmt mt9v022_monochrome_fmts[] = {
 	/* Order important - see above */
 	{V4L2_MBUS_FMT_Y10_1X10, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_GREY8_1X8, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_Y8_1X8, V4L2_COLORSPACE_JPEG},
 };
 
 struct mt9v022 {
@@ -392,7 +392,7 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
 	 * icd->try_fmt(), datawidth is from our supported format list
 	 */
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_GREY8_1X8:
+	case V4L2_MBUS_FMT_Y8_1X8:
 	case V4L2_MBUS_FMT_Y10_1X10:
 		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATM)
 			return -EINVAL;
diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
index 84a6468..dd1b81b 100644
--- a/drivers/media/video/sh_mobile_csi2.c
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -56,7 +56,7 @@ static int sh_csi2_try_fmt(struct v4l2_subdev *sd,
 		switch (mf->code) {
 		case V4L2_MBUS_FMT_UYVY8_2X8:		/* YUV422 */
 		case V4L2_MBUS_FMT_YUYV8_1_5X8:		/* YUV420 */
-		case V4L2_MBUS_FMT_GREY8_1X8:		/* RAW8 */
+		case V4L2_MBUS_FMT_Y8_1X8:		/* RAW8 */
 		case V4L2_MBUS_FMT_SBGGR8_1X8:
 		case V4L2_MBUS_FMT_SGRBG8_1X8:
 			break;
@@ -67,7 +67,7 @@ static int sh_csi2_try_fmt(struct v4l2_subdev *sd,
 		break;
 	case SH_CSI2I:
 		switch (mf->code) {
-		case V4L2_MBUS_FMT_GREY8_1X8:		/* RAW8 */
+		case V4L2_MBUS_FMT_Y8_1X8:		/* RAW8 */
 		case V4L2_MBUS_FMT_SBGGR8_1X8:
 		case V4L2_MBUS_FMT_SGRBG8_1X8:
 		case V4L2_MBUS_FMT_SBGGR10_1X10:	/* RAW10 */
@@ -111,7 +111,7 @@ static int sh_csi2_s_fmt(struct v4l2_subdev *sd,
 	case V4L2_MBUS_FMT_RGB565_2X8_BE:
 		tmp |= 0x22;	/* RGB565 */
 		break;
-	case V4L2_MBUS_FMT_GREY8_1X8:
+	case V4L2_MBUS_FMT_Y8_1X8:
 	case V4L2_MBUS_FMT_SBGGR8_1X8:
 	case V4L2_MBUS_FMT_SGRBG8_1X8:
 		tmp |= 0x2a;	/* RAW8 */
diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index 9139121..d9c297d 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -88,7 +88,7 @@ static const struct soc_mbus_pixelfmt mbus_fmt[] = {
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(GREY8_1X8)] = {
+	[MBUS_IDX(Y8_1X8)] = {
 		.fourcc			= V4L2_PIX_FMT_GREY,
 		.name			= "Grey",
 		.bits_per_sample	= 8,
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 127512a..75c2d55 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -37,7 +37,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB565_2X8_BE,
 	V4L2_MBUS_FMT_SBGGR8_1X8,
 	V4L2_MBUS_FMT_SBGGR10_1X10,
-	V4L2_MBUS_FMT_GREY8_1X8,
+	V4L2_MBUS_FMT_Y8_1X8,
 	V4L2_MBUS_FMT_Y10_1X10,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
-- 
1.7.2.2

