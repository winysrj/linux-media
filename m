Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51393 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab1I2OWw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 10:22:52 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LSA00A45FY0OW50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Sep 2011 15:22:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LSA003G0FXZ1C@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Sep 2011 15:22:48 +0100 (BST)
Date: Thu, 29 Sep 2011 16:22:41 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 5/5] v4l: s5p-tv: mixer: add support for selection API
In-reply-to: <1317306161-23696-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	mchehab@redhat.com
Message-id: <1317306161-23696-6-git-send-email-t.stanislaws@samsung.com>
References: <1317306161-23696-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add support for V4L2 selection API to s5p-tv driver.  Moreover it
removes old API for cropping.  Old applications would still work because the
crop ioctls are emulated using the selection API.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/mixer.h           |   14 +-
 drivers/media/video/s5p-tv/mixer_grp_layer.c |  157 +++++++++---
 drivers/media/video/s5p-tv/mixer_video.c     |  339 +++++++++++++++++---------
 drivers/media/video/s5p-tv/mixer_vp_layer.c  |  108 ++++++---
 4 files changed, 422 insertions(+), 196 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/video/s5p-tv/mixer.h
index 51ad59b..1597078 100644
--- a/drivers/media/video/s5p-tv/mixer.h
+++ b/drivers/media/video/s5p-tv/mixer.h
@@ -86,6 +86,17 @@ struct mxr_crop {
 	unsigned int field;
 };
 
+/** stages of geometry operations */
+enum mxr_geometry_stage {
+	MXR_GEOMETRY_SINK,
+	MXR_GEOMETRY_COMPOSE,
+	MXR_GEOMETRY_CROP,
+	MXR_GEOMETRY_SOURCE,
+};
+
+/* flag indicating that offset should be 0 */
+#define MXR_NO_OFFSET	0x80000000
+
 /** description of transformation from source to destination image */
 struct mxr_geometry {
 	/** cropping for source image */
@@ -133,7 +144,8 @@ struct mxr_layer_ops {
 	/** streaming stop/start */
 	void (*stream_set)(struct mxr_layer *, int);
 	/** adjusting geometry */
-	void (*fix_geometry)(struct mxr_layer *);
+	void (*fix_geometry)(struct mxr_layer *,
+		enum mxr_geometry_stage, unsigned long);
 };
 
 /** layer instance, a single window and content displayed on output */
diff --git a/drivers/media/video/s5p-tv/mixer_grp_layer.c b/drivers/media/video/s5p-tv/mixer_grp_layer.c
index de8270c..1ed10f8 100644
--- a/drivers/media/video/s5p-tv/mixer_grp_layer.c
+++ b/drivers/media/video/s5p-tv/mixer_grp_layer.c
@@ -101,47 +101,132 @@ static void mxr_graph_format_set(struct mxr_layer *layer)
 		layer->fmt, &layer->geo);
 }
 
-static void mxr_graph_fix_geometry(struct mxr_layer *layer)
+static inline unsigned int closest(unsigned int x, unsigned int a,
+	unsigned int b, unsigned long flags)
+{
+	unsigned int mid = (a + b) / 2;
+
+	/* choosing closest value with constraints according to table:
+	 * -------------+-----+-----+-----+-------+
+	 * flags	|  0  |  LE |  GE | LE|GE |
+	 * -------------+-----+-----+-----+-------+
+	 * x <= a	|  a  |  a  |  a  |   a   |
+	 * a < x <= mid	|  a  |  a  |  b  |   a   |
+	 * mid < x < b	|  b  |  a  |  b  |   b   |
+	 * b <= x	|  b  |  b  |  b  |   b   |
+	 * -------------+-----+-----+-----+-------+
+	 */
+
+	/* remove all non-constraint flags */
+	flags &= V4L2_SEL_SIZE_LE | V4L2_SEL_SIZE_GE;
+
+	if (x <= a)
+		return  a;
+	if (x >= b)
+		return b;
+	if (flags == V4L2_SEL_SIZE_LE)
+		return a;
+	if (flags == V4L2_SEL_SIZE_GE)
+		return b;
+	if (x <= mid)
+		return a;
+	return b;
+}
+
+static inline unsigned int do_center(unsigned int center,
+	unsigned int size, unsigned int upper, unsigned int flags)
+{
+	unsigned int lower;
+
+	if (flags & MXR_NO_OFFSET)
+		return 0;
+
+	lower = center - min(center, size / 2);
+	return min(lower, upper - size);
+}
+
+static void mxr_graph_fix_geometry(struct mxr_layer *layer,
+	enum mxr_geometry_stage stage, unsigned long flags)
 {
 	struct mxr_geometry *geo = &layer->geo;
+	struct mxr_crop *src = &geo->src;
+	struct mxr_crop *dst = &geo->dst;
+	unsigned int x_center, y_center;
 
-	/* limit to boundary size */
-	geo->src.full_width = clamp_val(geo->src.full_width, 1, 32767);
-	geo->src.full_height = clamp_val(geo->src.full_height, 1, 2047);
-	geo->src.width = clamp_val(geo->src.width, 1, geo->src.full_width);
-	geo->src.width = min(geo->src.width, 2047U);
-	/* not possible to crop of Y axis */
-	geo->src.y_offset = min(geo->src.y_offset, geo->src.full_height - 1);
-	geo->src.height = geo->src.full_height - geo->src.y_offset;
-	/* limitting offset */
-	geo->src.x_offset = min(geo->src.x_offset,
-		geo->src.full_width - geo->src.width);
-
-	/* setting position in output */
-	geo->dst.width = min(geo->dst.width, geo->dst.full_width);
-	geo->dst.height = min(geo->dst.height, geo->dst.full_height);
-
-	/* Mixer supports only 1x and 2x scaling */
-	if (geo->dst.width >= 2 * geo->src.width) {
-		geo->x_ratio = 1;
-		geo->dst.width = 2 * geo->src.width;
-	} else {
-		geo->x_ratio = 0;
-		geo->dst.width = geo->src.width;
-	}
+	switch (stage) {
 
-	if (geo->dst.height >= 2 * geo->src.height) {
-		geo->y_ratio = 1;
-		geo->dst.height = 2 * geo->src.height;
-	} else {
-		geo->y_ratio = 0;
-		geo->dst.height = geo->src.height;
-	}
+	case MXR_GEOMETRY_SINK: /* nothing to be fixed here */
+		flags = 0;
+		/* fall through */
+
+	case MXR_GEOMETRY_COMPOSE:
+		/* remember center of the area */
+		x_center = dst->x_offset + dst->width / 2;
+		y_center = dst->y_offset + dst->height / 2;
+		/* round up/down to 2 multiple depending on flags */
+		if (flags & V4L2_SEL_SIZE_LE) {
+			dst->width = round_down(dst->width, 2);
+			dst->height = round_down(dst->height, 2);
+		} else {
+			dst->width = round_up(dst->width, 2);
+			dst->height = round_up(dst->height, 2);
+		}
+		/* assure that compose rect is inside display area */
+		dst->width = min(dst->width, dst->full_width);
+		dst->height = min(dst->height, dst->full_height);
+
+		/* ensure that compose is reachable using 2x scaling */
+		dst->width = min(dst->width, 2 * src->full_width);
+		dst->height = min(dst->height, 2 * src->full_height);
+
+		/* setup offsets */
+		dst->x_offset = do_center(x_center, dst->width,
+			dst->full_width, flags);
+		dst->y_offset = do_center(y_center, dst->height,
+			dst->full_height, flags);
+		flags = 0;
+		/* fall through */
 
-	geo->dst.x_offset = min(geo->dst.x_offset,
-		geo->dst.full_width - geo->dst.width);
-	geo->dst.y_offset = min(geo->dst.y_offset,
-		geo->dst.full_height - geo->dst.height);
+	case MXR_GEOMETRY_CROP:
+		/* remember center of the area */
+		x_center = src->x_offset + src->width / 2;
+		y_center = src->y_offset + src->height / 2;
+		/* ensure that cropping area lies inside the buffer */
+		if (src->full_width < dst->width)
+			src->width = dst->width / 2;
+		else
+			src->width = closest(src->width, dst->width / 2,
+				dst->width, flags);
+
+		if (src->width == dst->width)
+			geo->x_ratio = 0;
+		else
+			geo->x_ratio = 1;
+
+		if (src->full_height < dst->height)
+			src->height = dst->height / 2;
+		else
+			src->height = closest(src->height, dst->height / 2,
+				dst->height, flags);
+
+		if (src->height == dst->height)
+			geo->y_ratio = 0;
+		else
+			geo->y_ratio = 1;
+
+		/* setup offsets */
+		src->x_offset = do_center(x_center, src->width,
+			src->full_width, flags);
+		src->y_offset = do_center(y_center, src->height,
+			src->full_height, flags);
+		flags = 0;
+		/* fall through */
+	case MXR_GEOMETRY_SOURCE:
+		src->full_width = clamp_val(src->full_width,
+			src->width + src->x_offset, 32767);
+		src->full_height = clamp_val(src->full_height,
+			src->height + src->y_offset, 2047);
+	};
 }
 
 /* PUBLIC API */
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 4917e2c..250aa9e 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -169,18 +169,22 @@ static int mxr_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-/* Geometry handling */
-static void mxr_layer_geo_fix(struct mxr_layer *layer)
+static void mxr_geometry_dump(struct mxr_device *mdev, struct mxr_geometry *geo)
 {
-	struct mxr_device *mdev = layer->mdev;
-	struct v4l2_mbus_framefmt mbus_fmt;
-
-	/* TODO: add some dirty flag to avoid unnecessary adjustments */
-	mxr_get_mbus_fmt(mdev, &mbus_fmt);
-	layer->geo.dst.full_width = mbus_fmt.width;
-	layer->geo.dst.full_height = mbus_fmt.height;
-	layer->geo.dst.field = mbus_fmt.field;
-	layer->ops.fix_geometry(layer);
+	mxr_dbg(mdev, "src.full_size = (%u, %u)\n",
+		geo->src.full_width, geo->src.full_height);
+	mxr_dbg(mdev, "src.size = (%u, %u)\n",
+		geo->src.width, geo->src.height);
+	mxr_dbg(mdev, "src.offset = (%u, %u)\n",
+		geo->src.x_offset, geo->src.y_offset);
+	mxr_dbg(mdev, "dst.full_size = (%u, %u)\n",
+		geo->dst.full_width, geo->dst.full_height);
+	mxr_dbg(mdev, "dst.size = (%u, %u)\n",
+		geo->dst.width, geo->dst.height);
+	mxr_dbg(mdev, "dst.offset = (%u, %u)\n",
+		geo->dst.x_offset, geo->dst.y_offset);
+	mxr_dbg(mdev, "ratio = (%u, %u)\n",
+		geo->x_ratio, geo->y_ratio);
 }
 
 static void mxr_layer_default_geo(struct mxr_layer *layer)
@@ -203,27 +207,29 @@ static void mxr_layer_default_geo(struct mxr_layer *layer)
 	layer->geo.src.width = layer->geo.src.full_width;
 	layer->geo.src.height = layer->geo.src.full_height;
 
-	layer->ops.fix_geometry(layer);
+	mxr_geometry_dump(mdev, &layer->geo);
+	layer->ops.fix_geometry(layer, MXR_GEOMETRY_SINK, 0);
+	mxr_geometry_dump(mdev, &layer->geo);
 }
 
-static void mxr_geometry_dump(struct mxr_device *mdev, struct mxr_geometry *geo)
+static void mxr_layer_update_output(struct mxr_layer *layer)
 {
-	mxr_dbg(mdev, "src.full_size = (%u, %u)\n",
-		geo->src.full_width, geo->src.full_height);
-	mxr_dbg(mdev, "src.size = (%u, %u)\n",
-		geo->src.width, geo->src.height);
-	mxr_dbg(mdev, "src.offset = (%u, %u)\n",
-		geo->src.x_offset, geo->src.y_offset);
-	mxr_dbg(mdev, "dst.full_size = (%u, %u)\n",
-		geo->dst.full_width, geo->dst.full_height);
-	mxr_dbg(mdev, "dst.size = (%u, %u)\n",
-		geo->dst.width, geo->dst.height);
-	mxr_dbg(mdev, "dst.offset = (%u, %u)\n",
-		geo->dst.x_offset, geo->dst.y_offset);
-	mxr_dbg(mdev, "ratio = (%u, %u)\n",
-		geo->x_ratio, geo->y_ratio);
-}
+	struct mxr_device *mdev = layer->mdev;
+	struct v4l2_mbus_framefmt mbus_fmt;
+
+	mxr_get_mbus_fmt(mdev, &mbus_fmt);
+	/* checking if update is needed */
+	if (layer->geo.dst.full_width == mbus_fmt.width &&
+		layer->geo.dst.full_height == mbus_fmt.width)
+		return;
 
+	layer->geo.dst.full_width = mbus_fmt.width;
+	layer->geo.dst.full_height = mbus_fmt.height;
+	layer->geo.dst.field = mbus_fmt.field;
+	layer->ops.fix_geometry(layer, MXR_GEOMETRY_SINK, 0);
+
+	mxr_geometry_dump(mdev, &layer->geo);
+}
 
 static const struct mxr_format *find_format_by_fourcc(
 	struct mxr_layer *layer, unsigned long fourcc);
@@ -248,37 +254,6 @@ static int mxr_enum_fmt(struct file *file, void  *priv,
 	return 0;
 }
 
-static int mxr_s_fmt(struct file *file, void *priv,
-	struct v4l2_format *f)
-{
-	struct mxr_layer *layer = video_drvdata(file);
-	const struct mxr_format *fmt;
-	struct v4l2_pix_format_mplane *pix;
-	struct mxr_device *mdev = layer->mdev;
-	struct mxr_geometry *geo = &layer->geo;
-
-	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
-
-	pix = &f->fmt.pix_mp;
-	fmt = find_format_by_fourcc(layer, pix->pixelformat);
-	if (fmt == NULL) {
-		mxr_warn(mdev, "not recognized fourcc: %08x\n",
-			pix->pixelformat);
-		return -EINVAL;
-	}
-	layer->fmt = fmt;
-	geo->src.full_width = pix->width;
-	geo->src.width = pix->width;
-	geo->src.full_height = pix->height;
-	geo->src.height = pix->height;
-	/* assure consistency of geometry */
-	mxr_layer_geo_fix(layer);
-	mxr_dbg(mdev, "width=%u height=%u span=%u\n",
-		geo->src.width, geo->src.height, geo->src.full_width);
-
-	return 0;
-}
-
 static unsigned int divup(unsigned int divident, unsigned int divisor)
 {
 	return (divident + divisor - 1) / divisor;
@@ -298,6 +273,10 @@ static void mxr_mplane_fill(struct v4l2_plane_pix_format *planes,
 {
 	int i;
 
+	/* checking if nothing to fill */
+	if (!planes)
+		return;
+
 	memset(planes, 0, sizeof(*planes) * fmt->num_subframes);
 	for (i = 0; i < fmt->num_planes; ++i) {
 		struct v4l2_plane_pix_format *plane = planes
@@ -331,73 +310,191 @@ static int mxr_g_fmt(struct file *file, void *priv,
 	return 0;
 }
 
-static inline struct mxr_crop *choose_crop_by_type(struct mxr_geometry *geo,
-	enum v4l2_buf_type type)
-{
-	switch (type) {
-	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		return &geo->dst;
-	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		return &geo->src;
-	default:
-		return NULL;
-	}
-}
-
-static int mxr_g_crop(struct file *file, void *fh, struct v4l2_crop *a)
+static int mxr_s_fmt(struct file *file, void *priv,
+	struct v4l2_format *f)
 {
 	struct mxr_layer *layer = video_drvdata(file);
-	struct mxr_crop *crop;
+	const struct mxr_format *fmt;
+	struct v4l2_pix_format_mplane *pix;
+	struct mxr_device *mdev = layer->mdev;
+	struct mxr_geometry *geo = &layer->geo;
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
-	crop = choose_crop_by_type(&layer->geo, a->type);
-	if (crop == NULL)
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+
+	pix = &f->fmt.pix_mp;
+	fmt = find_format_by_fourcc(layer, pix->pixelformat);
+	if (fmt == NULL) {
+		mxr_warn(mdev, "not recognized fourcc: %08x\n",
+			pix->pixelformat);
 		return -EINVAL;
-	mxr_layer_geo_fix(layer);
-	a->c.left = crop->x_offset;
-	a->c.top = crop->y_offset;
-	a->c.width = crop->width;
-	a->c.height = crop->height;
+	}
+	layer->fmt = fmt;
+	/* set source size to highest accepted value */
+	geo->src.full_width = max(geo->dst.full_width, pix->width);
+	geo->src.full_height = max(geo->dst.full_height, pix->height);
+	layer->ops.fix_geometry(layer, MXR_GEOMETRY_SOURCE, 0);
+	mxr_geometry_dump(mdev, &layer->geo);
+	/* set cropping to total visible screen */
+	geo->src.width = pix->width;
+	geo->src.height = pix->height;
+	geo->src.x_offset = 0;
+	geo->src.y_offset = 0;
+	/* assure consistency of geometry */
+	layer->ops.fix_geometry(layer, MXR_GEOMETRY_CROP, MXR_NO_OFFSET);
+	mxr_geometry_dump(mdev, &layer->geo);
+	/* set full size to lowest possible value */
+	geo->src.full_width = 0;
+	geo->src.full_height = 0;
+	layer->ops.fix_geometry(layer, MXR_GEOMETRY_SOURCE, 0);
+	mxr_geometry_dump(mdev, &layer->geo);
+
+	/* returning results */
+	mxr_g_fmt(file, priv, f);
+
 	return 0;
 }
 
-static int mxr_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
+static int mxr_g_selection(struct file *file, void *fh,
+	struct v4l2_selection *s)
 {
 	struct mxr_layer *layer = video_drvdata(file);
-	struct mxr_crop *crop;
+	struct mxr_geometry *geo = &layer->geo;
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
-	crop = choose_crop_by_type(&layer->geo, a->type);
-	if (crop == NULL)
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
-	crop->x_offset = a->c.left;
-	crop->y_offset = a->c.top;
-	crop->width = a->c.width;
-	crop->height = a->c.height;
-	mxr_layer_geo_fix(layer);
+
+	switch (s->target) {
+	case V4L2_SEL_CROP_ACTIVE:
+		s->r.left = geo->src.x_offset;
+		s->r.top = geo->src.y_offset;
+		s->r.width = geo->src.width;
+		s->r.height = geo->src.height;
+		break;
+	case V4L2_SEL_CROP_DEFAULT:
+	case V4L2_SEL_CROP_BOUNDS:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = geo->src.full_width;
+		s->r.height = geo->src.full_height;
+		break;
+	case V4L2_SEL_COMPOSE_ACTIVE:
+	case V4L2_SEL_COMPOSE_PADDED:
+		s->r.left = geo->dst.x_offset;
+		s->r.top = geo->dst.y_offset;
+		s->r.width = geo->dst.width;
+		s->r.height = geo->dst.height;
+		break;
+	case V4L2_SEL_COMPOSE_DEFAULT:
+	case V4L2_SEL_COMPOSE_BOUNDS:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = geo->dst.full_width;
+		s->r.height = geo->dst.full_height;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-static int mxr_cropcap(struct file *file, void *fh, struct v4l2_cropcap *a)
+/* returns 1 if rectangle 'a' is inside 'b' */
+static int mxr_is_rect_inside(struct v4l2_rect *a, struct v4l2_rect *b)
+{
+	if (a->left < b->left)
+		return 0;
+	if (a->top < b->top)
+		return 0;
+	if (a->left + a->width > b->left + b->width)
+		return 0;
+	if (a->top + a->height > b->top + b->height)
+		return 0;
+	return 1;
+}
+
+static int mxr_s_selection(struct file *file, void *fh,
+	struct v4l2_selection *s)
 {
 	struct mxr_layer *layer = video_drvdata(file);
-	struct mxr_crop *crop;
+	struct mxr_geometry *geo = &layer->geo;
+	struct mxr_crop *target = NULL;
+	enum mxr_geometry_stage stage;
+	struct mxr_geometry tmp;
+	struct v4l2_rect res;
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
-	crop = choose_crop_by_type(&layer->geo, a->type);
-	if (crop == NULL)
+	memset(&res, 0, sizeof res);
+
+	mxr_dbg(layer->mdev, "%s: rect: %dx%d@%d,%d\n", __func__,
+		s->r.width, s->r.height, s->r.left, s->r.top);
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+	switch (s->target) {
+	/* ignore read-only targets */
+	case V4L2_SEL_CROP_DEFAULT:
+	case V4L2_SEL_CROP_BOUNDS:
+		res.width = geo->src.full_width;
+		res.height = geo->src.full_height;
+		break;
+
+	/* ignore read-only targets */
+	case V4L2_SEL_COMPOSE_DEFAULT:
+	case V4L2_SEL_COMPOSE_BOUNDS:
+		res.width = geo->dst.full_width;
+		res.height = geo->dst.full_height;
+		break;
+
+	case V4L2_SEL_CROP_ACTIVE:
+		target = &geo->src;
+		stage = MXR_GEOMETRY_CROP;
+		break;
+	case V4L2_SEL_COMPOSE_ACTIVE:
+	case V4L2_SEL_COMPOSE_PADDED:
+		target = &geo->dst;
+		stage = MXR_GEOMETRY_COMPOSE;
+		break;
+	default:
 		return -EINVAL;
-	mxr_layer_geo_fix(layer);
-	a->bounds.left = 0;
-	a->bounds.top = 0;
-	a->bounds.width = crop->full_width;
-	a->bounds.top = crop->full_height;
-	a->defrect = a->bounds;
-	/* setting pixel aspect to 1/1 */
-	a->pixelaspect.numerator = 1;
-	a->pixelaspect.denominator = 1;
+	}
+	/* apply change and update geometry if needed */
+	if (target) {
+		/* backup current geometry if setup fails */
+		memcpy(&tmp, geo, sizeof tmp);
+
+		/* apply requested selection */
+		target->x_offset = s->r.left;
+		target->y_offset = s->r.top;
+		target->width = s->r.width;
+		target->height = s->r.height;
+
+		layer->ops.fix_geometry(layer, stage, s->flags);
+
+		/* retrieve update selection rectangle */
+		res.left = target->x_offset;
+		res.top = target->y_offset;
+		res.width = target->width;
+		res.height = target->height;
+
+		mxr_geometry_dump(layer->mdev, &layer->geo);
+	}
+
+	/* checking if the rectangle satisfies constraints */
+	if ((s->flags & V4L2_SEL_SIZE_LE) && !mxr_is_rect_inside(&res, &s->r))
+		goto fail;
+	if ((s->flags & V4L2_SEL_SIZE_GE) && !mxr_is_rect_inside(&s->r, &res))
+		goto fail;
+
+	/* return result rectangle */
+	s->r = res;
+
 	return 0;
+fail:
+	/* restore old geometry, which is not touched if target is NULL */
+	if (target)
+		memcpy(geo, &tmp, sizeof tmp);
+	return -ERANGE;
 }
 
 static int mxr_enum_dv_presets(struct file *file, void *fh,
@@ -437,6 +534,8 @@ static int mxr_s_dv_preset(struct file *file, void *fh,
 
 	mutex_unlock(&mdev->mutex);
 
+	mxr_layer_update_output(layer);
+
 	/* any failure should return EINVAL according to V4L2 doc */
 	return ret ? -EINVAL : 0;
 }
@@ -477,6 +576,8 @@ static int mxr_s_std(struct file *file, void *fh, v4l2_std_id *norm)
 
 	mutex_unlock(&mdev->mutex);
 
+	mxr_layer_update_output(layer);
+
 	return ret ? -EINVAL : 0;
 }
 
@@ -525,25 +626,27 @@ static int mxr_s_output(struct file *file, void *fh, unsigned int i)
 	struct video_device *vfd = video_devdata(file);
 	struct mxr_layer *layer = video_drvdata(file);
 	struct mxr_device *mdev = layer->mdev;
-	int ret = 0;
 
 	if (i >= mdev->output_cnt || mdev->output[i] == NULL)
 		return -EINVAL;
 
 	mutex_lock(&mdev->mutex);
 	if (mdev->n_output > 0) {
-		ret = -EBUSY;
-		goto done;
+		mutex_unlock(&mdev->mutex);
+		return -EBUSY;
 	}
 	mdev->current_output = i;
 	vfd->tvnorms = 0;
 	v4l2_subdev_call(to_outsd(mdev), video, g_tvnorms_output,
 		&vfd->tvnorms);
+	mutex_unlock(&mdev->mutex);
+
+	/* update layers geometry */
+	mxr_layer_update_output(layer);
+
 	mxr_dbg(mdev, "tvnorms = %08llx\n", vfd->tvnorms);
 
-done:
-	mutex_unlock(&mdev->mutex);
-	return ret;
+	return 0;
 }
 
 static int mxr_g_output(struct file *file, void *fh, unsigned int *p)
@@ -632,10 +735,9 @@ static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
 	.vidioc_enum_output = mxr_enum_output,
 	.vidioc_s_output = mxr_s_output,
 	.vidioc_g_output = mxr_g_output,
-	/* Crop ioctls */
-	.vidioc_g_crop = mxr_g_crop,
-	.vidioc_s_crop = mxr_s_crop,
-	.vidioc_cropcap = mxr_cropcap,
+	/* selection ioctls */
+	.vidioc_g_selection = mxr_g_selection,
+	.vidioc_s_selection = mxr_s_selection,
 };
 
 static int mxr_video_open(struct file *file)
@@ -804,10 +906,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* block any changes in output configuration */
 	mxr_output_get(mdev);
 
-	/* update layers geometry */
-	mxr_layer_geo_fix(layer);
-	mxr_geometry_dump(mdev, &layer->geo);
-
+	mxr_layer_update_output(layer);
 	layer->ops.format_set(layer);
 	/* enabling layer in hardware */
 	spin_lock_irqsave(&layer->enq_slock, flags);
diff --git a/drivers/media/video/s5p-tv/mixer_vp_layer.c b/drivers/media/video/s5p-tv/mixer_vp_layer.c
index f3bb2e3..e41ec2e 100644
--- a/drivers/media/video/s5p-tv/mixer_vp_layer.c
+++ b/drivers/media/video/s5p-tv/mixer_vp_layer.c
@@ -127,47 +127,77 @@ static void mxr_vp_format_set(struct mxr_layer *layer)
 	mxr_reg_vp_format(layer->mdev, layer->fmt, &layer->geo);
 }
 
-static void mxr_vp_fix_geometry(struct mxr_layer *layer)
+static inline unsigned int do_center(unsigned int center,
+	unsigned int size, unsigned int upper, unsigned int flags)
 {
-	struct mxr_geometry *geo = &layer->geo;
+	unsigned int lower;
+
+	if (flags & MXR_NO_OFFSET)
+		return 0;
+
+	lower = center - min(center, size / 2);
+	return min(lower, upper - size);
+}
 
-	/* align horizontal size to 8 pixels */
-	geo->src.full_width = ALIGN(geo->src.full_width, 8);
-	/* limit to boundary size */
-	geo->src.full_width = clamp_val(geo->src.full_width, 8, 8192);
-	geo->src.full_height = clamp_val(geo->src.full_height, 1, 8192);
-	geo->src.width = clamp_val(geo->src.width, 32, geo->src.full_width);
-	geo->src.width = min(geo->src.width, 2047U);
-	geo->src.height = clamp_val(geo->src.height, 4, geo->src.full_height);
-	geo->src.height = min(geo->src.height, 2047U);
-
-	/* setting size of output window */
-	geo->dst.width = clamp_val(geo->dst.width, 8, geo->dst.full_width);
-	geo->dst.height = clamp_val(geo->dst.height, 1, geo->dst.full_height);
-
-	/* ensure that scaling is in range 1/4x to 16x */
-	if (geo->src.width >= 4 * geo->dst.width)
-		geo->src.width = 4 * geo->dst.width;
-	if (geo->dst.width >= 16 * geo->src.width)
-		geo->dst.width = 16 * geo->src.width;
-	if (geo->src.height >= 4 * geo->dst.height)
-		geo->src.height = 4 * geo->dst.height;
-	if (geo->dst.height >= 16 * geo->src.height)
-		geo->dst.height = 16 * geo->src.height;
-
-	/* setting scaling ratio */
-	geo->x_ratio = (geo->src.width << 16) / geo->dst.width;
-	geo->y_ratio = (geo->src.height << 16) / geo->dst.height;
-
-	/* adjust offsets */
-	geo->src.x_offset = min(geo->src.x_offset,
-		geo->src.full_width - geo->src.width);
-	geo->src.y_offset = min(geo->src.y_offset,
-		geo->src.full_height - geo->src.height);
-	geo->dst.x_offset = min(geo->dst.x_offset,
-		geo->dst.full_width - geo->dst.width);
-	geo->dst.y_offset = min(geo->dst.y_offset,
-		geo->dst.full_height - geo->dst.height);
+static void mxr_vp_fix_geometry(struct mxr_layer *layer,
+	enum mxr_geometry_stage stage, unsigned long flags)
+{
+	struct mxr_geometry *geo = &layer->geo;
+	struct mxr_crop *src = &geo->src;
+	struct mxr_crop *dst = &geo->dst;
+	unsigned long x_center, y_center;
+
+	switch (stage) {
+
+	case MXR_GEOMETRY_SINK: /* nothing to be fixed here */
+	case MXR_GEOMETRY_COMPOSE:
+		/* remember center of the area */
+		x_center = dst->x_offset + dst->width / 2;
+		y_center = dst->y_offset + dst->height / 2;
+
+		/* ensure that compose is reachable using 16x scaling */
+		dst->width = clamp(dst->width, 8U, 16 * src->full_width);
+		dst->height = clamp(dst->height, 1U, 16 * src->full_height);
+
+		/* setup offsets */
+		dst->x_offset = do_center(x_center, dst->width,
+			dst->full_width, flags);
+		dst->y_offset = do_center(y_center, dst->height,
+			dst->full_height, flags);
+		flags = 0; /* remove possible MXR_NO_OFFSET flag */
+		/* fall through */
+	case MXR_GEOMETRY_CROP:
+		/* remember center of the area */
+		x_center = src->x_offset + src->width / 2;
+		y_center = src->y_offset + src->height / 2;
+
+		/* ensure scaling is between 0.25x .. 16x */
+		src->width = clamp(src->width, round_up(dst->width, 4),
+			dst->width * 16);
+		src->height = clamp(src->height, round_up(dst->height, 4),
+			dst->height * 16);
+
+		/* hardware limits */
+		src->width = clamp(src->width, 32U, 2047U);
+		src->height = clamp(src->height, 4U, 2047U);
+
+		/* setup offsets */
+		src->x_offset = do_center(x_center, src->width,
+			src->full_width, flags);
+		src->y_offset = do_center(y_center, src->height,
+			src->full_height, flags);
+
+		/* setting scaling ratio */
+		geo->x_ratio = (src->width << 16) / dst->width;
+		geo->y_ratio = (src->height << 16) / dst->height;
+		/* fall through */
+
+	case MXR_GEOMETRY_SOURCE:
+		src->full_width = clamp(src->full_width,
+			ALIGN(src->width + src->x_offset, 8), 8192U);
+		src->full_height = clamp(src->full_height,
+			src->height + src->y_offset, 8192U);
+	};
 }
 
 /* PUBLIC API */
-- 
1.7.6

