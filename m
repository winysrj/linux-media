Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1315 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaAFOVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 27/27] vivi: add matrix and selection test code.
Date: Mon,  6 Jan 2014 15:21:26 +0100
Message-Id: <1389018086-15903-28-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivi.c | 312 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 286 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 2ec8511..0532d2b 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -48,8 +48,9 @@
  */
 #define FPS_MAX 1000
 
-#define MAX_WIDTH 1920
-#define MAX_HEIGHT 1200
+#define MAX_ZOOM 4
+#define MAX_WIDTH (1920 * MAX_ZOOM)
+#define MAX_HEIGHT (1200 * MAX_ZOOM)
 
 #define VIVI_VERSION "0.8.1"
 
@@ -86,6 +87,9 @@ static const struct v4l2_fract
 #define dprintk(dev, level, fmt, arg...) \
 	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
 
+#define VIVI_CID_CUSTOM_BASE	(V4L2_CID_USER_BASE | 0xf000)
+#define VIVI_PID_CUSTOM_BASE	(V4L2_CID_PROPS_CLASS_BASE | 0xf000)
+
 /* ------------------------------------------------------------------
 	Basic structures
    ------------------------------------------------------------------*/
@@ -207,6 +211,8 @@ struct vivi_dmaqueue {
 
 static LIST_HEAD(vivi_devlist);
 
+#define VIVI_UNSET (-1000)
+
 struct vivi_dev {
 	struct list_head           vivi_devlist;
 	struct v4l2_device 	   v4l2_dev;
@@ -233,6 +239,16 @@ struct vivi_dev {
 	struct v4l2_ctrl	   *string;
 	struct v4l2_ctrl	   *bitmask;
 	struct v4l2_ctrl	   *int_menu;
+	struct v4l2_ctrl	   *store;
+	struct v4l2_ctrl	   *prop1;
+	struct v4l2_ctrl	   *prop2;
+	struct v4l2_ctrl	   *prop3;
+	struct { /* crop/compose selection cluster */
+		struct v4l2_ctrl	   *crop;
+		struct v4l2_ctrl	   *compose;
+	};
+	struct v4l2_prop_selection *crop_sel;
+	struct v4l2_prop_selection *compose_sel;
 
 	spinlock_t                 slock;
 	struct mutex		   mutex;
@@ -253,6 +269,7 @@ struct vivi_dev {
 	const struct vivi_fmt      *fmt;
 	struct v4l2_fract          timeperframe;
 	unsigned int               width, height;
+	unsigned int               canvas_width, canvas_height;
 	struct vb2_queue	   vb_vidq;
 	unsigned int		   field_count;
 
@@ -314,6 +331,7 @@ static const struct bar_std bars[] = {
 };
 
 #define NUM_INPUTS ARRAY_SIZE(bars)
+#define NUM_STORES NUM_INPUTS
 
 #define TO_Y(r, g, b) \
 	(((16829 * r + 33039 * g + 6416 * b  + 32768) >> 16) + 16)
@@ -535,19 +553,26 @@ static void precalculate_line(struct vivi_dev *dev)
 	unsigned pixsize  = dev->pixelsize;
 	unsigned pixsize2 = 2*pixsize;
 	int colorpos;
-	u8 *pos;
+	unsigned width = dev->canvas_width * dev->compose_sel->r.width / dev->crop_sel->r.width;
+	u8 *pos = dev->line;
 
 	for (colorpos = 0; colorpos < 16; ++colorpos) {
 		u8 pix[8];
-		int wstart =  colorpos    * dev->width / 8;
-		int wend   = (colorpos+1) * dev->width / 8;
+		int wstart = (colorpos) * width / 8;
+		int wend   = ((colorpos+1)) * width / 8;
 		int w;
 
+		wstart = wstart & ~1;
+		wend = wend & ~1;
+		if (colorpos == 15)
+			wend = MAX_WIDTH * MAX_ZOOM;
 		gen_twopix(dev, &pix[0],        colorpos % 8, 0);
 		gen_twopix(dev, &pix[pixsize],  colorpos % 8, 1);
 
-		for (w = wstart/2*2, pos = dev->line + w*pixsize; w < wend; w += 2, pos += pixsize2)
+		for (w = wstart; w < wend; w += 2) {
 			memcpy(pos, pix, pixsize2);
+			pos += pixsize2;
+		}
 	}
 }
 
@@ -605,21 +630,26 @@ static void gen_text(struct vivi_dev *dev, char *basep,
 static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 {
 	int stride = dev->width * dev->pixelsize;
-	int hmax = dev->height;
+	int hmax = dev->compose_sel->r.height;
 	void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	u8 *matrix = dev->prop3->cur.p_u8;
 	unsigned ms;
 	char str[100];
 	int h, line = 1;
+	unsigned start;
 	u8 *linestart;
 	s32 gain;
 
 	if (!vbuf)
 		return;
 
-	linestart = dev->line + (dev->mv_count % dev->width) * dev->pixelsize;
+	start = (dev->mv_count + dev->crop_sel->r.left) % dev->canvas_width;
+	start = (start * dev->compose_sel->r.width) / dev->crop_sel->r.width;
+	start &= ~1;
+	linestart = dev->line + start * dev->pixelsize;
 
 	for (h = 0; h < hmax; h++)
-		memcpy(vbuf + h * stride, linestart, stride);
+		memcpy(vbuf + h * stride, linestart, dev->compose_sel->r.width * dev->pixelsize);
 
 	/* Updates stream time */
 
@@ -636,7 +666,7 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 			ms % 1000);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " %dx%d, input %d ",
-			dev->width, dev->height, dev->input);
+			dev->canvas_width, dev->canvas_height, dev->input);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 
 	gain = v4l2_ctrl_g_ctrl(dev->gain);
@@ -665,6 +695,12 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 			dev->int_menu->qmenu_int[*dev->int_menu->cur.p_s32],
 			*dev->int_menu->cur.p_s32);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
+	snprintf(str, sizeof(str), " matrix %3d %3d ",
+			matrix[0], matrix[1]);
+	gen_text(dev, vbuf, line++ * 16, 16, str);
+	snprintf(str, sizeof(str), "        %3d %3d ",
+			matrix[2], matrix[3]);
+	gen_text(dev, vbuf, line++ * 16, 16, str);
 	mutex_unlock(dev->ctrl_handler.lock);
 	if (dev->button_pressed) {
 		dev->button_pressed--;
@@ -858,7 +894,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	BUG_ON(NULL == dev->fmt);
 
 	/*
-	 * Theses properties only change when queue is idle, see s_fmt.
+	 * These properties only change when queue is idle, see s_fmt.
 	 * The below checks should not be performed here, on each
 	 * buffer_prepare (i.e. on each qbuf). Most of the code in this function
 	 * should thus be moved to buffer_init and s_fmt.
@@ -1038,6 +1074,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->pixelsize = dev->fmt->depth / 8;
 	dev->width = f->fmt.pix.width;
 	dev->height = f->fmt.pix.height;
+	dev->crop_sel->r.width = dev->compose_sel->r.width = dev->width;
+	dev->crop_sel->r.height = dev->compose_sel->r.height = dev->height;
 
 	return 0;
 }
@@ -1063,6 +1101,62 @@ static int vidioc_enum_framesizes(struct file *file, void *fh,
 	return 0;
 }
 
+static int adjust_sel(unsigned flags, struct v4l2_rect *r)
+{
+	unsigned w = r->width;
+	unsigned h = r->height;
+
+	if (!(flags & V4L2_SEL_FLAG_LE)) {
+		w++;
+		h++;
+		if (r->width < 2)
+			r->width = 2;
+		if (r->height < 2)
+			r->height = 2;
+	}
+	if (!(flags & V4L2_SEL_FLAG_GE)) {
+		if (r->width > MAX_WIDTH)
+			r->width = MAX_WIDTH;
+		if (r->height > MAX_HEIGHT)
+			r->height = MAX_HEIGHT;
+	}
+	w = w & ~1;
+	h = h & ~1;
+	r->left = r->top = 0;
+	if (r->width < 2 || r->height < 2)
+		return -ERANGE;
+	if (r->width > MAX_WIDTH || r->height > MAX_HEIGHT)
+		return -ERANGE;
+	if ((flags & (V4L2_SEL_FLAG_GE | V4L2_SEL_FLAG_LE)) ==
+			(V4L2_SEL_FLAG_GE | V4L2_SEL_FLAG_LE) &&
+			(r->width != w || r->height != h))
+		return -ERANGE;
+	r->width = w;
+	r->height = h;
+	return 0;
+}
+
+static int vidioc_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	int ret;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (s->target != V4L2_SEL_TGT_FRAME_SIZE)
+		return -EINVAL;
+	ret = adjust_sel(s->flags, &s->r);
+	if (ret)
+		return ret;
+	dev->canvas_width = s->r.width;
+	dev->canvas_height = s->r.height;
+	/* TODO: event handling when changing properties */
+	/* Question: should prop events be optional? */
+	dev->crop_sel->r.width = dev->compose_sel->r.width = dev->canvas_width;
+	dev->crop_sel->r.height = dev->compose_sel->r.height = dev->canvas_height;
+	return 0;
+}
+
 /* only one input in this sample driver */
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *inp)
@@ -1095,16 +1189,18 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 
 	dev->input = i;
 	/*
-	 * Modify the brightness range depending on the input.
+	 * Modify the volume range depending on the input.
 	 * This makes it easy to use vivi to test if applications can
 	 * handle control range modifications and is also how this is
 	 * typically used in practice as different inputs may be hooked
 	 * up to different receivers with different control ranges.
 	 */
-	v4l2_ctrl_modify_range(dev->brightness,
-			128 * i, 255 + 128 * i, 1, 127 + 128 * i);
+	v4l2_ctrl_modify_range(dev->volume,
+			128 * i, 255 + 128 * i, 1, 200 + 128 * i);
 	precalculate_bars(dev);
 	precalculate_line(dev);
+	v4l2_ctrl_apply_store(&dev->ctrl_handler, i + 1);
+	*dev->store->stores[i + 1].p_s32 = i + 1;
 	return 0;
 }
 
@@ -1183,6 +1279,34 @@ static int vivi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
+static int vivi_try_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vivi_dev *dev = container_of(ctrl->handler, struct vivi_dev, ctrl_handler);
+	struct v4l2_prop_selection *crop, *compose;
+	int ret;
+
+	switch (ctrl->id) {
+	case V4L2_CID_CAPTURE_CROP:
+		crop = dev->crop->new.p_sel;
+		ret = adjust_sel(crop->flags, &crop->r);
+		if (ret)
+			return ret;
+		compose = dev->compose->new.p_sel;
+		ret = adjust_sel(compose->flags, &compose->r);
+		if (ret)
+			return ret;
+		if (compose->r.width > crop->r.width * MAX_ZOOM)
+			crop->r.width = compose->r.width / MAX_ZOOM;
+		if (compose->r.height > crop->r.height * MAX_ZOOM)
+			crop->r.height = compose->r.height / MAX_ZOOM;
+		ret = adjust_sel(crop->flags, &crop->r);
+		if (ret)
+			return ret;
+		break;
+	}
+	return 0;
+}
+
 static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vivi_dev *dev = container_of(ctrl->handler, struct vivi_dev, ctrl_handler);
@@ -1191,6 +1315,13 @@ static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_ALPHA_COMPONENT:
 		dev->alpha_component = ctrl->val;
 		break;
+	case V4L2_CID_CAPTURE_CROP:
+		if (dev->crop->is_new)
+			*dev->crop_sel = *dev->crop->new.p_sel;
+		if (dev->compose->is_new)
+			*dev->compose_sel = *dev->compose->new.p_sel;
+		precalculate_line(dev);
+		break;
 	default:
 		if (ctrl == dev->button)
 			dev->button_pressed = 30;
@@ -1205,10 +1336,50 @@ static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 
 static const struct v4l2_ctrl_ops vivi_ctrl_ops = {
 	.g_volatile_ctrl = vivi_g_volatile_ctrl,
+	.try_ctrl = vivi_try_ctrl,
 	.s_ctrl = vivi_s_ctrl,
 };
 
-#define VIVI_CID_CUSTOM_BASE	(V4L2_CID_USER_BASE | 0xf000)
+static const struct v4l2_ctrl_config vivi_ctrl_brightness = {
+	.ops = &vivi_ctrl_ops,
+	.id = V4L2_CID_BRIGHTNESS,
+	.nstores = NUM_STORES,
+	.initial_store = 1,
+	.max = 255,
+	.step = 1,
+	.def = 127,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_contrast = {
+	.ops = &vivi_ctrl_ops,
+	.id = V4L2_CID_CONTRAST,
+	.nstores = NUM_STORES,
+	.initial_store = 1,
+	.max = 255,
+	.step = 1,
+	.def = 16,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_saturation = {
+	.ops = &vivi_ctrl_ops,
+	.id = V4L2_CID_SATURATION,
+	.nstores = NUM_STORES,
+	.initial_store = 1,
+	.max = 255,
+	.step = 1,
+	.def = 127,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_hue = {
+	.ops = &vivi_ctrl_ops,
+	.id = V4L2_CID_HUE,
+	.nstores = NUM_STORES,
+	.initial_store = 1,
+	.min = -128,
+	.max = 127,
+	.step = 1,
+	.def = 0,
+};
 
 static const struct v4l2_ctrl_config vivi_ctrl_button = {
 	.ops = &vivi_ctrl_ops,
@@ -1226,14 +1397,16 @@ static const struct v4l2_ctrl_config vivi_ctrl_boolean = {
 	.max = 1,
 	.step = 1,
 	.def = 1,
+	.flags = V4L2_CTRL_FLAG_CAN_STORE,
 };
 
 static const struct v4l2_ctrl_config vivi_ctrl_int32 = {
 	.ops = &vivi_ctrl_ops,
 	.id = VIVI_CID_CUSTOM_BASE + 2,
 	.name = "Integer 32 Bits",
+	.unit = "km/s",
 	.type = V4L2_CTRL_TYPE_INTEGER,
-	.min = 0x80000000,
+	.min = 0xffffffff80000000,
 	.max = 0x7fffffff,
 	.step = 1,
 };
@@ -1242,6 +1415,9 @@ static const struct v4l2_ctrl_config vivi_ctrl_int64 = {
 	.ops = &vivi_ctrl_ops,
 	.id = VIVI_CID_CUSTOM_BASE + 3,
 	.name = "Integer 64 Bits",
+	.min = -999999999999LL,
+	.max = 999999999999LL,
+	.step = 1,
 	.type = V4L2_CTRL_TYPE_INTEGER64,
 };
 
@@ -1304,6 +1480,82 @@ static const struct v4l2_ctrl_config vivi_ctrl_int_menu = {
 	.qmenu_int = vivi_ctrl_int_menu_values,
 };
 
+static const struct v4l2_ctrl_config vivi_ctrl_store = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 8,
+	.name = "Config Store",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 1,
+	.max = NUM_STORES,
+	.def = 1,
+	.step = 1,
+	.flags = V4L2_CTRL_FLAG_READ_ONLY,
+	.nstores = NUM_STORES,
+	.initial_store = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_prop_int = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_PID_CUSTOM_BASE + 0,
+	.name = "Property1",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.flags = V4L2_CTRL_FLAG_PROPERTY,
+	.def = 0x80,
+	.min = 0,
+	.max = 0xff,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_prop_bool = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_PID_CUSTOM_BASE + 1,
+	.name = "Property2",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.flags = V4L2_CTRL_FLAG_PROPERTY,
+	.def = 1,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vivi_prop_matrix_u8 = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_PID_CUSTOM_BASE + 2,
+	.name = "Property3",
+	.type = V4L2_PROP_TYPE_U8,
+	.flags = V4L2_CTRL_FLAG_PROPERTY,
+	.def = 0x80,
+	.min = 0,
+	.max = 0xff,
+	.step = 1,
+	.cols = 2,
+	.rows = 2,
+	.elem_size = 1,
+	.nstores = NUM_STORES,
+};
+
+static const struct v4l2_ctrl_config vivi_prop_cap_crop = {
+	.ops = &vivi_ctrl_ops,
+	.id = V4L2_CID_CAPTURE_CROP,
+	.name = "Capture Crop",
+	.type = V4L2_PROP_TYPE_SELECTION,
+	.flags = V4L2_CTRL_FLAG_PROPERTY,
+	.cols = 1,
+	.rows = 1,
+	.elem_size = sizeof(struct v4l2_prop_selection),
+};
+
+static const struct v4l2_ctrl_config vivi_prop_cap_compose = {
+	.ops = &vivi_ctrl_ops,
+	.id = V4L2_CID_CAPTURE_COMPOSE,
+	.name = "Capture Compose",
+	.type = V4L2_PROP_TYPE_SELECTION,
+	.flags = V4L2_CTRL_FLAG_PROPERTY,
+	.cols = 1,
+	.rows = 1,
+	.elem_size = sizeof(struct v4l2_prop_selection),
+};
+
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
 	.open           = v4l2_fh_open,
@@ -1333,6 +1585,7 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
 	.vidioc_g_parm        = vidioc_g_parm,
 	.vidioc_s_parm        = vidioc_s_parm,
+	.vidioc_s_selection   = vidioc_s_selection,
 	.vidioc_streamon      = vb2_ioctl_streamon,
 	.vidioc_streamoff     = vb2_ioctl_streamoff,
 	.vidioc_log_status    = v4l2_ctrl_log_status,
@@ -1392,21 +1645,17 @@ static int __init vivi_create_instance(int inst)
 
 	dev->fmt = &formats[0];
 	dev->timeperframe = tpf_default;
-	dev->width = 640;
-	dev->height = 480;
+	dev->width = dev->canvas_width = 640;
+	dev->height = dev->canvas_height = 480;
 	dev->pixelsize = dev->fmt->depth / 8;
 	hdl = &dev->ctrl_handler;
 	v4l2_ctrl_handler_init(hdl, 11);
 	dev->volume = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_AUDIO_VOLUME, 0, 255, 1, 200);
-	dev->brightness = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
-			V4L2_CID_BRIGHTNESS, 0, 255, 1, 127);
-	dev->contrast = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
-			V4L2_CID_CONTRAST, 0, 255, 1, 16);
-	dev->saturation = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
-			V4L2_CID_SATURATION, 0, 255, 1, 127);
-	dev->hue = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
-			V4L2_CID_HUE, -128, 127, 1, 0);
+	dev->brightness = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_brightness, NULL);
+	dev->contrast = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_contrast, NULL);
+	dev->saturation = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_saturation, NULL);
+	dev->hue = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_hue, NULL);
 	dev->autogain = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
 	dev->gain = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
@@ -1421,11 +1670,22 @@ static int __init vivi_create_instance(int inst)
 	dev->string = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_string, NULL);
 	dev->bitmask = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_bitmask, NULL);
 	dev->int_menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int_menu, NULL);
+	dev->store = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_store, NULL);
+	dev->prop1 = v4l2_ctrl_new_custom(hdl, &vivi_prop_int, NULL);
+	dev->prop2 = v4l2_ctrl_new_custom(hdl, &vivi_prop_bool, NULL);
+	dev->prop3 = v4l2_ctrl_new_custom(hdl, &vivi_prop_matrix_u8, NULL);
+	dev->crop = v4l2_ctrl_new_custom(hdl, &vivi_prop_cap_crop, NULL);
+	dev->compose = v4l2_ctrl_new_custom(hdl, &vivi_prop_cap_compose, NULL);
 	if (hdl->error) {
 		ret = hdl->error;
 		goto unreg_dev;
 	}
 	v4l2_ctrl_auto_cluster(2, &dev->autogain, 0, true);
+	v4l2_ctrl_cluster(2, &dev->crop);
+	dev->crop_sel = dev->crop->cur.p_sel;
+	dev->compose_sel = dev->compose->cur.p_sel;
+	dev->crop_sel->r.width = dev->compose_sel->r.width = dev->width;
+	dev->crop_sel->r.height = dev->compose_sel->r.height = dev->height;
 	dev->v4l2_dev.ctrl_handler = hdl;
 
 	/* initialize locks */
-- 
1.8.5.2

