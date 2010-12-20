Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51292 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab0LTLh3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 06:37:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v5 03/13] v4l: Rename V4L2_MBUS_FMT_GREY8_1X8 to V4L2_MBUS_FMT_Y8_1X8
Date: Mon, 20 Dec 2010 12:37:15 +0100
Message-Id: <1292845045-7945-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1292845045-7945-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1292845045-7945-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

For consistency with the V4L2_MBUS_FMT_Y10_1X10 format.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m001.c        |    2 +-
 drivers/media/video/mt9v022.c        |    4 ++--
 drivers/media/video/ov6650.c         |   10 +++++-----
 drivers/media/video/sh_mobile_csi2.c |    6 +++---
 drivers/media/video/soc_mediabus.c   |    2 +-
 include/linux/v4l2-mediabus.h        |    2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index fcb4cd9..3aaedf6 100644
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
index b96171c..56dd4fc 100644
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
diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index cf93de9..fe8e3eb 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -207,7 +207,7 @@ static enum v4l2_mbus_pixelcode ov6650_codes[] = {
 	V4L2_MBUS_FMT_YVYU8_2X8,
 	V4L2_MBUS_FMT_VYUY8_2X8,
 	V4L2_MBUS_FMT_SBGGR8_1X8,
-	V4L2_MBUS_FMT_GREY8_1X8,
+	V4L2_MBUS_FMT_Y8_1X8,
 };
 
 static const struct v4l2_queryctrl ov6650_controls[] = {
@@ -800,7 +800,7 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 
 	/* select color matrix configuration for given color encoding */
 	switch (code) {
-	case V4L2_MBUS_FMT_GREY8_1X8:
+	case V4L2_MBUS_FMT_Y8_1X8:
 		dev_dbg(&client->dev, "pixel format GREY8_1X8\n");
 		coma_mask |= COMA_RGB | COMA_WORD_SWAP | COMA_BYTE_SWAP;
 		coma_set |= COMA_BW;
@@ -846,7 +846,7 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 	}
 	priv->code = code;
 
-	if (code == V4L2_MBUS_FMT_GREY8_1X8 ||
+	if (code == V4L2_MBUS_FMT_Y8_1X8 ||
 			code == V4L2_MBUS_FMT_SBGGR8_1X8) {
 		coml_mask = COML_ONE_CHANNEL;
 		coml_set = 0;
@@ -936,8 +936,8 @@ static int ov6650_try_fmt(struct v4l2_subdev *sd,
 
 	switch (mf->code) {
 	case V4L2_MBUS_FMT_Y10_1X10:
-		mf->code = V4L2_MBUS_FMT_GREY8_1X8;
-	case V4L2_MBUS_FMT_GREY8_1X8:
+		mf->code = V4L2_MBUS_FMT_Y8_1X8;
+	case V4L2_MBUS_FMT_Y8_1X8:
 	case V4L2_MBUS_FMT_YVYU8_2X8:
 	case V4L2_MBUS_FMT_YUYV8_2X8:
 	case V4L2_MBUS_FMT_VYUY8_2X8:
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
index a25e19f..1171cac 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -45,7 +45,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_BGR565_2X8_BE,
 	V4L2_MBUS_FMT_SBGGR8_1X8,
 	V4L2_MBUS_FMT_SBGGR10_1X10,
-	V4L2_MBUS_FMT_GREY8_1X8,
+	V4L2_MBUS_FMT_Y8_1X8,
 	V4L2_MBUS_FMT_Y10_1X10,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
-- 
1.7.2.2

