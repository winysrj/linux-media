Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50398 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1LIR77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 12:59:59 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVY004ZE7BWIA70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 Dec 2011 17:59:57 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVY00A7Y7BWNK@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 Dec 2011 17:59:56 +0000 (GMT)
Date: Fri, 09 Dec 2011 18:59:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v3 4/4] v4l: Update subdev drivers to handle framesamples
 parameter
In-reply-to: <201112061712.30748.laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323453592-17782-1-git-send-email-s.nawrocki@samsung.com>
References: <201112061712.30748.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the sub-device drivers having a devnode enabled so they properly
handle the new framesamples field of struct v4l2_mbus_framefmt.
These drivers don't support compressed (entropy encoded) formats so the
framesamples field is simply initialized to 0, altogether with the
reserved structure member.

There is a few other drivers that expose a devnode (mt9p031, mt9t001,
mt9v032), but they already implicitly initialize the new data structure
field to 0, so they don't need to be touched.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Hi,

In this version the whole reserved field in struct v4l2_mbus_framefmt 
is also cleared, rather than setting only framesamples to 0.  

The omap3isp driver changes have been only compile tested.

Thanks,
Sylwester
---
 drivers/media/video/noon010pc30.c         |    5 ++++-
 drivers/media/video/omap3isp/ispccdc.c    |    2 ++
 drivers/media/video/omap3isp/ispccp2.c    |    2 ++
 drivers/media/video/omap3isp/ispcsi2.c    |    2 ++
 drivers/media/video/omap3isp/isppreview.c |    2 ++
 drivers/media/video/omap3isp/ispresizer.c |    2 ++
 drivers/media/video/s5k6aa.c              |    2 ++
 7 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 50838bf..5af9b60 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -519,13 +519,14 @@ static int noon010_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	mf = &fmt->format;
 
 	mutex_lock(&info->lock);
+	memset(mf, 0, sizeof(mf));
 	mf->width = info->curr_win->width;
 	mf->height = info->curr_win->height;
 	mf->code = info->curr_fmt->code;
 	mf->colorspace = info->curr_fmt->colorspace;
 	mf->field = V4L2_FIELD_NONE;
-
 	mutex_unlock(&info->lock);
+
 	return 0;
 }
 
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
index b0b0fa5..a608149 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1802,6 +1802,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
+	const int offset = offsetof(struct v4l2_mbus_framefmt, framesamples);
 	struct v4l2_mbus_framefmt *format;
 	const struct isp_format_info *info;
 	unsigned int width = fmt->width;
@@ -1863,6 +1864,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 	 */
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 	fmt->field = V4L2_FIELD_NONE;
+	memset(fmt + offset, 0, sizeof(*fmt) - offset);
 }
 
 /*
diff --git a/drivers/media/video/omap3isp/ispccp2.c b/drivers/media/video/omap3isp/ispccp2.c
index 904ca8c..a56a6ad 100644
--- a/drivers/media/video/omap3isp/ispccp2.c
+++ b/drivers/media/video/omap3isp/ispccp2.c
@@ -673,6 +673,7 @@ static void ccp2_try_format(struct isp_ccp2_device *ccp2,
 			       struct v4l2_mbus_framefmt *fmt,
 			       enum v4l2_subdev_format_whence which)
 {
+	const int offset = offsetof(struct v4l2_mbus_framefmt, framesamples);
 	struct v4l2_mbus_framefmt *format;
 
 	switch (pad) {
@@ -711,6 +712,7 @@ static void ccp2_try_format(struct isp_ccp2_device *ccp2,
 
 	fmt->field = V4L2_FIELD_NONE;
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	memset(fmt + offset, 0, sizeof(*fmt) - offset);
 }
 
 /*
diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
index 0c5f1cb..c41443b 100644
--- a/drivers/media/video/omap3isp/ispcsi2.c
+++ b/drivers/media/video/omap3isp/ispcsi2.c
@@ -846,6 +846,7 @@ csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
+	const int offset = offsetof(struct v4l2_mbus_framefmt, framesamples);
 	enum v4l2_mbus_pixelcode pixelcode;
 	struct v4l2_mbus_framefmt *format;
 	const struct isp_format_info *info;
@@ -888,6 +889,7 @@ csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 	/* RGB, non-interlaced */
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 	fmt->field = V4L2_FIELD_NONE;
+	memset(fmt + offset, 0, sizeof(*fmt) - offset);
 }
 
 /*
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index ccb876f..23861c4 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1656,6 +1656,7 @@ static void preview_try_format(struct isp_prev_device *prev,
 			       struct v4l2_mbus_framefmt *fmt,
 			       enum v4l2_subdev_format_whence which)
 {
+	const int offset = offsetof(struct v4l2_mbus_framefmt, framesamples);
 	enum v4l2_mbus_pixelcode pixelcode;
 	struct v4l2_rect *crop;
 	unsigned int i;
@@ -1720,6 +1721,7 @@ static void preview_try_format(struct isp_prev_device *prev,
 	}
 
 	fmt->field = V4L2_FIELD_NONE;
+	memset(fmt + offset, 0, sizeof(*fmt) - offset);
 }
 
 /*
diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 50e593b..fff46e5 100644
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
@@ -1363,6 +1364,7 @@ static void resizer_try_format(struct isp_res_device *res,
 
 	fmt->colorspace = V4L2_COLORSPACE_JPEG;
 	fmt->field = V4L2_FIELD_NONE;
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

