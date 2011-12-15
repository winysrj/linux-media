Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49073 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742Ab1LOKOJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 05:14:09 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW8001SBPRI7N30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Dec 2011 10:14:06 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW800J25PRIW4@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Dec 2011 10:14:06 +0000 (GMT)
Date: Thu, 15 Dec 2011 11:14:02 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCHv5] v4l: Update subdev drivers to handle framesamples parameter
In-reply-to: <1323865388-26994-3-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	riverful.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323944042-15871-1-git-send-email-s.nawrocki@samsung.com>
References: <1323865388-26994-3-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the sub-device drivers having a devnode enabled so they properly
handle the new framesamples field of struct v4l2_mbus_framefmt.
These drivers don't support compressed (entropy encoded) formats so the
framesamples field is simply initialized to 0, altogether with the
reserved field.

There is a few other drivers that expose a devnode (mt9p031, mt9t001,
mt9v032) but they already implicitly initialize the new data structure
field to 0, so they don't need to be touched.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v4:
 - in the try format functions use local copies of only width, height, code
   rather that caching whole struct v4l2_mbus_framefmt

Changes since v3:
 - use local copy of the format data structure to clear all structure
   members which are unused by a driver, in way that it don't break
   after new fields are added to struct v4l2_mbus_framefmt;

The omap3isp changes are only compile tested. Thus I'd like to ask someone 
who has access to the hardware to test the patch and provide Ack or 
Tested-by :)

Thanks,
Sylwester
---
 drivers/media/video/noon010pc30.c         |    3 +++
 drivers/media/video/omap3isp/ispccdc.c    |    8 ++++++--
 drivers/media/video/omap3isp/ispccp2.c    |   16 +++++++++++-----
 drivers/media/video/omap3isp/ispcsi2.c    |   14 +++++++++-----
 drivers/media/video/omap3isp/isppreview.c |   15 ++++++++++-----
 drivers/media/video/omap3isp/ispresizer.c |    3 +++
 drivers/media/video/s5k6aa.c              |    2 ++
 7 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 50838bf..9a6a7ac 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -519,6 +519,7 @@ static int noon010_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	mf = &fmt->format;
 
 	mutex_lock(&info->lock);
+	memset(mf, 0, sizeof(mf));
 	mf->width = info->curr_win->width;
 	mf->height = info->curr_win->height;
 	mf->code = info->curr_fmt->code;
@@ -546,12 +547,14 @@ static const struct noon010_format *noon010_try_fmt(struct v4l2_subdev *sd,
 static int noon010_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			   struct v4l2_subdev_format *fmt)
 {
+	const int offset = offsetof(struct v4l2_mbus_framefmt, framesamples);
 	struct noon010_info *info = to_noon010(sd);
 	const struct noon010_frmsize *size = NULL;
 	const struct noon010_format *nf;
 	struct v4l2_mbus_framefmt *mf;
 	int ret = 0;
 
+	memset(&fmt->format + offset, 0, sizeof(fmt->format) - offset);
 	nf = noon010_try_fmt(sd, &fmt->format);
 	noon010_try_frame_size(&fmt->format, &size);
 	fmt->format.colorspace = V4L2_COLORSPACE_JPEG;
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index b0b0fa5..9e12548 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1802,6 +1802,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
+	enum v4l2_mbus_pixelcode pixelcode = fmt->code;
 	struct v4l2_mbus_framefmt *format;
 	const struct isp_format_info *info;
 	unsigned int width = fmt->width;
@@ -1810,21 +1811,24 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 
 	switch (pad) {
 	case CCDC_PAD_SINK:
+		memset(fmt, 0, sizeof(*fmt));
+
 		/* TODO: If the CCDC output formatter pad is connected directly
 		 * to the resizer, only YUV formats can be used.
 		 */
 		for (i = 0; i < ARRAY_SIZE(ccdc_fmts); i++) {
-			if (fmt->code == ccdc_fmts[i])
+			if (pixelcode == ccdc_fmts[i])
 				break;
 		}
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(ccdc_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+			pixelcode = V4L2_MBUS_FMT_SGRBG10_1X10;
 
 		/* Clamp the input size. */
 		fmt->width = clamp_t(u32, width, 32, 4096);
 		fmt->height = clamp_t(u32, height, 32, 4096);
+		fmt->code = pixelcode;
 		break;
 
 	case CCDC_PAD_SOURCE_OF:
diff --git a/drivers/media/video/omap3isp/ispccp2.c b/drivers/media/video/omap3isp/ispccp2.c
index 904ca8c..864b220 100644
--- a/drivers/media/video/omap3isp/ispccp2.c
+++ b/drivers/media/video/omap3isp/ispccp2.c
@@ -673,25 +673,31 @@ static void ccp2_try_format(struct isp_ccp2_device *ccp2,
 			       struct v4l2_mbus_framefmt *fmt,
 			       enum v4l2_subdev_format_whence which)
 {
+	enum v4l2_mbus_pixelcode pixelcode = fmt->code;
+	unsigned int height = fmt->height;
+	unsigned int width = fmt->width;
 	struct v4l2_mbus_framefmt *format;
 
 	switch (pad) {
 	case CCP2_PAD_SINK:
-		if (fmt->code != V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8)
+		memset(fmt, 0, sizeof(*fmt));
+		if (pixelcode != V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8)
 			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		else
+			fmt->code = pixelcode;
 
 		if (ccp2->input == CCP2_INPUT_SENSOR) {
-			fmt->width = clamp_t(u32, fmt->width,
+			fmt->width = clamp_t(u32, width,
 					     ISPCCP2_DAT_START_MIN,
 					     ISPCCP2_DAT_START_MAX);
-			fmt->height = clamp_t(u32, fmt->height,
+			fmt->height = clamp_t(u32, height,
 					      ISPCCP2_DAT_SIZE_MIN,
 					      ISPCCP2_DAT_SIZE_MAX);
 		} else if (ccp2->input == CCP2_INPUT_MEMORY) {
-			fmt->width = clamp_t(u32, fmt->width,
+			fmt->width = clamp_t(u32, width,
 					     ISPCCP2_LCM_HSIZE_COUNT_MIN,
 					     ISPCCP2_LCM_HSIZE_COUNT_MAX);
-			fmt->height = clamp_t(u32, fmt->height,
+			fmt->height = clamp_t(u32, height,
 					      ISPCCP2_LCM_VSIZE_MIN,
 					      ISPCCP2_LCM_VSIZE_MAX);
 		}
diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
index 0c5f1cb..1d37c6b 100644
--- a/drivers/media/video/omap3isp/ispcsi2.c
+++ b/drivers/media/video/omap3isp/ispcsi2.c
@@ -846,32 +846,36 @@ csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
-	enum v4l2_mbus_pixelcode pixelcode;
+	enum v4l2_mbus_pixelcode pixelcode = fmt->code;
 	struct v4l2_mbus_framefmt *format;
 	const struct isp_format_info *info;
+	u32 width = fmt->width;
+	u32 height = fmt->height;
 	unsigned int i;
 
 	switch (pad) {
 	case CSI2_PAD_SINK:
+		memset(fmt, 0, sizeof(*fmt));
 		/* Clamp the width and height to valid range (1-8191). */
 		for (i = 0; i < ARRAY_SIZE(csi2_input_fmts); i++) {
-			if (fmt->code == csi2_input_fmts[i])
+			if (pixelcode == csi2_input_fmts[i])
 				break;
 		}
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(csi2_input_fmts))
 			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		else
+			fmt->code = pixelcode;
 
-		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
-		fmt->height = clamp_t(u32, fmt->height, 1, 8191);
+		fmt->width = clamp_t(u32, width, 1, 8191);
+		fmt->height = clamp_t(u32, height, 1, 8191);
 		break;
 
 	case CSI2_PAD_SOURCE:
 		/* Source format same as sink format, except for DPCM
 		 * compression.
 		 */
-		pixelcode = fmt->code;
 		format = __csi2_get_format(csi2, fh, CSI2_PAD_SINK, which);
 		memcpy(fmt, format, sizeof(*fmt));
 
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index ccb876f..84e1095 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1656,10 +1656,14 @@ static void preview_try_format(struct isp_prev_device *prev,
 			       struct v4l2_mbus_framefmt *fmt,
 			       enum v4l2_subdev_format_whence which)
 {
-	enum v4l2_mbus_pixelcode pixelcode;
+	enum v4l2_mbus_pixelcode pixelcode = fmt->code;
+	u32 height = fmt->height;
+	u32 width = fmt->width;
 	struct v4l2_rect *crop;
 	unsigned int i;
 
+	memset(fmt, 0, sizeof(*fmt));
+
 	switch (pad) {
 	case PREV_PAD_SINK:
 		/* When reading data from the CCDC, the input size has already
@@ -1672,9 +1676,9 @@ static void preview_try_format(struct isp_prev_device *prev,
 		 * filter array interpolation.
 		 */
 		if (prev->input == PREVIEW_INPUT_MEMORY) {
-			fmt->width = clamp_t(u32, fmt->width, PREV_MIN_IN_WIDTH,
+			fmt->width = clamp_t(u32, width, PREV_MIN_IN_WIDTH,
 					     preview_max_out_width(prev));
-			fmt->height = clamp_t(u32, fmt->height,
+			fmt->height = clamp_t(u32, height,
 					      PREV_MIN_IN_HEIGHT,
 					      PREV_MAX_IN_HEIGHT);
 		}
@@ -1682,17 +1686,18 @@ static void preview_try_format(struct isp_prev_device *prev,
 		fmt->colorspace = V4L2_COLORSPACE_SRGB;
 
 		for (i = 0; i < ARRAY_SIZE(preview_input_fmts); i++) {
-			if (fmt->code == preview_input_fmts[i])
+			if (pixelcode == preview_input_fmts[i])
 				break;
 		}
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(preview_input_fmts))
 			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		else
+			fmt->code = pixelcode;
 		break;
 
 	case PREV_PAD_SOURCE:
-		pixelcode = fmt->code;
 		*fmt = *__preview_get_format(prev, fh, PREV_PAD_SINK, which);
 
 		switch (pixelcode) {
diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 50e593b..82f6985 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1336,6 +1336,7 @@ static void resizer_try_format(struct isp_res_device *res,
 			       struct v4l2_mbus_framefmt *fmt,
 			       enum v4l2_subdev_format_whence which)
 {
+	const int offset = offsetof(struct v4l2_mbus_framefmt, framesamples);
 	struct v4l2_mbus_framefmt *format;
 	struct resizer_ratio ratio;
 	struct v4l2_rect crop;
@@ -1363,6 +1364,8 @@ static void resizer_try_format(struct isp_res_device *res,
 
 	fmt->colorspace = V4L2_COLORSPACE_JPEG;
 	fmt->field = V4L2_FIELD_NONE;
+
+	memset(fmt + offset, 0, sizeof(*fmt) - offset);
 }
 
 /*
diff --git a/drivers/media/video/s5k6aa.c b/drivers/media/video/s5k6aa.c
index 0df7f2a..b9d1f03 100644
--- a/drivers/media/video/s5k6aa.c
+++ b/drivers/media/video/s5k6aa.c
@@ -1070,8 +1070,10 @@ __s5k6aa_get_crop_rect(struct s5k6aa *s5k6aa, struct v4l2_subdev_fh *fh,
 static void s5k6aa_try_format(struct s5k6aa *s5k6aa,
 			      struct v4l2_mbus_framefmt *mf)
 {
+	const int offset = offsetof(struct v4l2_mbus_framefmt, framesamples);
 	unsigned int index;
 
+	memset(mf + offset, 0, sizeof(*mf) - offset);
 	v4l_bound_align_image(&mf->width, S5K6AA_WIN_WIDTH_MIN,
 			      S5K6AA_WIN_WIDTH_MAX, 1,
 			      &mf->height, S5K6AA_WIN_HEIGHT_MIN,
-- 
1.7.8

