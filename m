Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21698 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab1LNMXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 07:23:15 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LW70034F12OQ8@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 12:23:12 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW7007RT12NJD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 12:23:12 +0000 (GMT)
Date: Wed, 14 Dec 2011 13:23:08 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCHv4 2/2] v4l: Update subdev drivers to handle framesamples
 parameter
In-reply-to: <1323865388-26994-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323865388-26994-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <201112120131.24192.laurent.pinchart@ideasonboard.com>
 <1323865388-26994-1-git-send-email-s.nawrocki@samsung.com>
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
--

Changes since v3:
- use local copy of the format data structure to clear all structure
  members which are unused by a driver, in way that it don't break
  after new fields are added to struct v4l2_mbus_framefmt; 	

The omap3isp changes are only compile tested. I'd like to ask someone who 
has access to the hardware to test the patch.

Regards,
Sylwester
---
 drivers/media/video/noon010pc30.c         |    3 ++
 drivers/media/video/omap3isp/ispccdc.c    |   12 +++++++---
 drivers/media/video/omap3isp/ispccp2.c    |   31 ++++++++++++++++------------
 drivers/media/video/omap3isp/ispcsi2.c    |   12 +++++++---
 drivers/media/video/omap3isp/isppreview.c |   23 ++++++++++++++-------
 drivers/media/video/omap3isp/ispresizer.c |   19 +++++++++++++----
 drivers/media/video/s5k6aa.c              |    2 +
 7 files changed, 68 insertions(+), 34 deletions(-)

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
index b0b0fa5..0663278 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1806,10 +1806,12 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 	const struct isp_format_info *info;
 	unsigned int width = fmt->width;
 	unsigned int height = fmt->height;
+	struct v4l2_mbus_framefmt mf;
 	unsigned int i;
 
 	switch (pad) {
 	case CCDC_PAD_SINK:
+		memset(&mf, 0, sizeof(mf));
 		/* TODO: If the CCDC output formatter pad is connected directly
 		 * to the resizer, only YUV formats can be used.
 		 */
@@ -1820,11 +1822,13 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(ccdc_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
-
+			mf.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		else
+			mf.code = fmt->code;
 		/* Clamp the input size. */
-		fmt->width = clamp_t(u32, width, 32, 4096);
-		fmt->height = clamp_t(u32, height, 32, 4096);
+		mf.width = clamp_t(u32, width, 32, 4096);
+		mf.height = clamp_t(u32, height, 32, 4096);
+		*fmt = mf;
 		break;
 
 	case CCDC_PAD_SOURCE_OF:
diff --git a/drivers/media/video/omap3isp/ispccp2.c b/drivers/media/video/omap3isp/ispccp2.c
index 904ca8c..90599e9 100644
--- a/drivers/media/video/omap3isp/ispccp2.c
+++ b/drivers/media/video/omap3isp/ispccp2.c
@@ -674,27 +674,32 @@ static void ccp2_try_format(struct isp_ccp2_device *ccp2,
 			       enum v4l2_subdev_format_whence which)
 {
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_mbus_framefmt mf;
 
 	switch (pad) {
 	case CCP2_PAD_SINK:
+		memset(&mf, 0, sizeof(mf));
 		if (fmt->code != V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8)
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+			mf.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		else
+			mf.code = fmt->code;
 
 		if (ccp2->input == CCP2_INPUT_SENSOR) {
-			fmt->width = clamp_t(u32, fmt->width,
-					     ISPCCP2_DAT_START_MIN,
-					     ISPCCP2_DAT_START_MAX);
-			fmt->height = clamp_t(u32, fmt->height,
-					      ISPCCP2_DAT_SIZE_MIN,
-					      ISPCCP2_DAT_SIZE_MAX);
+			mf.width = clamp_t(u32, fmt->width,
+					   ISPCCP2_DAT_START_MIN,
+					   ISPCCP2_DAT_START_MAX);
+			mf.height = clamp_t(u32, fmt->height,
+					    ISPCCP2_DAT_SIZE_MIN,
+					    ISPCCP2_DAT_SIZE_MAX);
 		} else if (ccp2->input == CCP2_INPUT_MEMORY) {
-			fmt->width = clamp_t(u32, fmt->width,
-					     ISPCCP2_LCM_HSIZE_COUNT_MIN,
-					     ISPCCP2_LCM_HSIZE_COUNT_MAX);
-			fmt->height = clamp_t(u32, fmt->height,
-					      ISPCCP2_LCM_VSIZE_MIN,
-					      ISPCCP2_LCM_VSIZE_MAX);
+			mf.width = clamp_t(u32, fmt->width,
+					   ISPCCP2_LCM_HSIZE_COUNT_MIN,
+					   ISPCCP2_LCM_HSIZE_COUNT_MAX);
+			mf.height = clamp_t(u32, fmt->height,
+					    ISPCCP2_LCM_VSIZE_MIN,
+					    ISPCCP2_LCM_VSIZE_MAX);
 		}
+		*fmt = mf;
 		break;
 
 	case CCP2_PAD_SOURCE:
diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
index 0c5f1cb..b989ef7 100644
--- a/drivers/media/video/omap3isp/ispcsi2.c
+++ b/drivers/media/video/omap3isp/ispcsi2.c
@@ -849,10 +849,12 @@ csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 	enum v4l2_mbus_pixelcode pixelcode;
 	struct v4l2_mbus_framefmt *format;
 	const struct isp_format_info *info;
+	struct v4l2_mbus_framefmt mf;
 	unsigned int i;
 
 	switch (pad) {
 	case CSI2_PAD_SINK:
+		memset(&mf, 0, sizeof(mf));
 		/* Clamp the width and height to valid range (1-8191). */
 		for (i = 0; i < ARRAY_SIZE(csi2_input_fmts); i++) {
 			if (fmt->code == csi2_input_fmts[i])
@@ -861,10 +863,12 @@ csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(csi2_input_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
-
-		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
-		fmt->height = clamp_t(u32, fmt->height, 1, 8191);
+			mf.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		else
+			mf.code = fmt->code;
+		mf.width = clamp_t(u32, fmt->width, 1, 8191);
+		mf.height = clamp_t(u32, fmt->height, 1, 8191);
+		*fmt = mf;
 		break;
 
 	case CSI2_PAD_SOURCE:
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index ccb876f..31f2f5c 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1657,9 +1657,12 @@ static void preview_try_format(struct isp_prev_device *prev,
 			       enum v4l2_subdev_format_whence which)
 {
 	enum v4l2_mbus_pixelcode pixelcode;
+	struct v4l2_mbus_framefmt mf;
 	struct v4l2_rect *crop;
 	unsigned int i;
 
+	memset(&mf, 0, sizeof(mf));
+
 	switch (pad) {
 	case PREV_PAD_SINK:
 		/* When reading data from the CCDC, the input size has already
@@ -1672,15 +1675,13 @@ static void preview_try_format(struct isp_prev_device *prev,
 		 * filter array interpolation.
 		 */
 		if (prev->input == PREVIEW_INPUT_MEMORY) {
-			fmt->width = clamp_t(u32, fmt->width, PREV_MIN_IN_WIDTH,
-					     preview_max_out_width(prev));
-			fmt->height = clamp_t(u32, fmt->height,
-					      PREV_MIN_IN_HEIGHT,
-					      PREV_MAX_IN_HEIGHT);
+			mf.width = clamp_t(u32, fmt->width, PREV_MIN_IN_WIDTH,
+					   preview_max_out_width(prev));
+			mf.height = clamp_t(u32, fmt->height,
+					    PREV_MIN_IN_HEIGHT,
+					    PREV_MAX_IN_HEIGHT);
 		}
 
-		fmt->colorspace = V4L2_COLORSPACE_SRGB;
-
 		for (i = 0; i < ARRAY_SIZE(preview_input_fmts); i++) {
 			if (fmt->code == preview_input_fmts[i])
 				break;
@@ -1688,11 +1689,17 @@ static void preview_try_format(struct isp_prev_device *prev,
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(preview_input_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+			mf.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		else
+			mf.code = fmt->code;
+
+		*fmt = mf;
+		fmt->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 
 	case PREV_PAD_SOURCE:
 		pixelcode = fmt->code;
+		memset(fmt, 0, sizeof(mf));
 		*fmt = *__preview_get_format(prev, fh, PREV_PAD_SINK, which);
 
 		switch (pixelcode) {
diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 50e593b..761b00d 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1337,19 +1337,24 @@ static void resizer_try_format(struct isp_res_device *res,
 			       enum v4l2_subdev_format_whence which)
 {
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_mbus_framefmt mf;
 	struct resizer_ratio ratio;
 	struct v4l2_rect crop;
 
+	memset(&mf, 0, sizeof(mf));
+
 	switch (pad) {
 	case RESZ_PAD_SINK:
 		if (fmt->code != V4L2_MBUS_FMT_YUYV8_1X16 &&
 		    fmt->code != V4L2_MBUS_FMT_UYVY8_1X16)
-			fmt->code = V4L2_MBUS_FMT_YUYV8_1X16;
+			mf.code = V4L2_MBUS_FMT_YUYV8_1X16;
+		else
+			mf.code = fmt->code;
 
-		fmt->width = clamp_t(u32, fmt->width, MIN_IN_WIDTH,
-				     resizer_max_in_width(res));
-		fmt->height = clamp_t(u32, fmt->height, MIN_IN_HEIGHT,
-				      MAX_IN_HEIGHT);
+		mf.width = clamp_t(u32, fmt->width, MIN_IN_WIDTH,
+				   resizer_max_in_width(res));
+		mf.height = clamp_t(u32, fmt->height, MIN_IN_HEIGHT,
+				    MAX_IN_HEIGHT);
 		break;
 
 	case RESZ_PAD_SOURCE:
@@ -1358,9 +1363,13 @@ static void resizer_try_format(struct isp_res_device *res,
 
 		crop = *__resizer_get_crop(res, fh, which);
 		resizer_calc_ratios(res, &crop, fmt, &ratio);
+		mf.width = fmt->width;
+		mf.height = fmt->height;
+		mf.code = fmt->code;
 		break;
 	}
 
+	*fmt = mf;
 	fmt->colorspace = V4L2_COLORSPACE_JPEG;
 	fmt->field = V4L2_FIELD_NONE;
 }
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

