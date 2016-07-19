Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:56077 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbcGSOX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:23:28 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 11/16] [media] rcar-vin: add abstraction layer to interact with subdevices
Date: Tue, 19 Jul 2016 16:21:02 +0200
Message-Id: <20160719142107.22358-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to try and separate which v4l2 subdevice operation the driver
calls from which subdevice it currently have chosen as its current input
a abstraction is created. The abstraction is mostly straight forward:

- The v4l2_subdev_call() calls that only can act on the current active
  subdevice are replaced with rvin_subdev_call(). The parameters
  describing the v4l2 operation is kept the same but the first argument
  is switch from a struct v4l2_subdev* to a struct rvin_dev*. The
  abstraction then pass on the v4l2 operation to the correct subdevice.

- The v4l2_subdev_call() calls that can be used in enumerate input
  properties are replaced with rvin_subdev_call_input() (g_input_status,
  dv_timings_cap, g_tvnorms and enum_dv_timings).  The parameters
  describing the v4l2 operation is kept the same but the first two
  arguments are switch from a struct v4l2_subdev* to a struct rvin_dev*
  and a number for the input source.  The abstraction then pass on the
  v4l2 operation to the correct subdevice.

- Wrappers are added to get the media bus format and code from the
  currently active input source.

- Wrapper are added to handle controls from the currently active input
  source.

This patch just adds and replace the v4l2 calls with there abstraction
layer counter part, there are still only one possible input source. This
is done to prepare for Gen3 support where there are more then one
possible subdevices to chose from at runtime.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 37 +++++++++++++
 drivers/media/platform/rcar-vin/rcar-dma.c  | 29 ++++++-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 81 ++++++++++++++---------------
 drivers/media/platform/rcar-vin/rcar-vin.h  | 15 ++++++
 4 files changed, 107 insertions(+), 55 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index fa1fa53..6fe9b6c 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -26,6 +26,43 @@
 #include "rcar-vin.h"
 
 /* -----------------------------------------------------------------------------
+ * Subdevice group helpers
+ */
+
+int rvin_subdev_get_code(struct rvin_dev *vin, u32 *code)
+{
+	*code = vin->digital.code;
+	return 0;
+}
+
+int rvin_subdev_get_mbus_cfg(struct rvin_dev *vin,
+			     struct v4l2_mbus_config *mbus_cfg)
+{
+	*mbus_cfg = vin->digital.mbus_cfg;
+	return 0;
+}
+
+struct v4l2_subdev_pad_config*
+rvin_subdev_alloc_pad_config(struct rvin_dev *vin)
+{
+	return v4l2_subdev_alloc_pad_config(vin->digital.subdev);
+}
+
+int rvin_subdev_ctrl_add_handler(struct rvin_dev *vin)
+{
+	int ret;
+
+	v4l2_ctrl_handler_free(&vin->ctrl_handler);
+
+	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
+	if (ret < 0)
+		return ret;
+
+	return v4l2_ctrl_add_handler(&vin->ctrl_handler,
+				     vin->digital.subdev->ctrl_handler, NULL);
+}
+
+/* -----------------------------------------------------------------------------
  * Async notifier
  */
 
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 79e7963..252adae 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -130,9 +130,16 @@ static u32 rvin_read(struct rvin_dev *vin, u32 offset)
 
 static int rvin_setup(struct rvin_dev *vin)
 {
-	u32 vnmc, dmr, dmr2, interrupts;
+	u32 code, vnmc, dmr, dmr2, interrupts;
+	struct v4l2_mbus_config mbus_cfg;
 	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
 
+	if (rvin_subdev_get_mbus_cfg(vin, &mbus_cfg))
+		return -EINVAL;
+
+	if (rvin_subdev_get_code(vin, &code))
+		return -EINVAL;
+
 	switch (vin->format.field) {
 	case V4L2_FIELD_TOP:
 		vnmc = VNMC_IM_ODD;
@@ -163,7 +170,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	/*
 	 * Input interface
 	 */
-	switch (vin->digital.code) {
+	switch (code) {
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
@@ -171,7 +178,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
-		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
 		input_is_yuv = true;
 		break;
@@ -180,7 +187,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
-		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
 		input_is_yuv = true;
 		break;
@@ -192,11 +199,11 @@ static int rvin_setup(struct rvin_dev *vin)
 	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
 
 	/* Hsync Signal Polarity Select */
-	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
+	if (!(mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_HPS;
 
 	/* Vsync Signal Polarity Select */
-	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
+	if (!(mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_VPS;
 
 	/*
@@ -1028,12 +1035,10 @@ static void rvin_buffer_queue(struct vb2_buffer *vb)
 static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct rvin_dev *vin = vb2_get_drv_priv(vq);
-	struct v4l2_subdev *sd;
 	unsigned long flags;
 	int ret;
 
-	sd = vin_to_source(vin);
-	v4l2_subdev_call(sd, video, s_stream, 1);
+	rvin_subdev_call(vin, video, s_stream, 1);
 
 	spin_lock_irqsave(&vin->qlock, flags);
 
@@ -1058,7 +1063,7 @@ out:
 	/* Return all buffers if something went wrong */
 	if (ret) {
 		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
-		v4l2_subdev_call(sd, video, s_stream, 0);
+		rvin_subdev_call(vin, video, s_stream, 0);
 	}
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
@@ -1069,7 +1074,6 @@ out:
 static void rvin_stop_streaming(struct vb2_queue *vq)
 {
 	struct rvin_dev *vin = vb2_get_drv_priv(vq);
-	struct v4l2_subdev *sd;
 	unsigned long flags;
 	int retries = 0;
 
@@ -1108,8 +1112,7 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
 
-	sd = vin_to_source(vin);
-	v4l2_subdev_call(sd, video, s_stream, 0);
+	rvin_subdev_call(vin, video, s_stream, 0);
 
 	/* disable interrupts */
 	rvin_disable_interrupts(vin);
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index d0e9d65..90f2725 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -97,24 +97,26 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 				    struct v4l2_pix_format *pix,
 				    struct rvin_source_fmt *source)
 {
-	struct v4l2_subdev *sd;
 	struct v4l2_subdev_pad_config *pad_cfg;
 	struct v4l2_subdev_format format = {
 		.which = which,
 	};
+	u32 code;
 	int ret;
 
-	sd = vin_to_source(vin);
+	ret = rvin_subdev_get_code(vin, &code);
+	if (ret)
+		return -EINVAL;
 
-	v4l2_fill_mbus_format(&format.format, pix, vin->digital.code);
+	v4l2_fill_mbus_format(&format.format, pix, code);
 
-	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
+	pad_cfg = rvin_subdev_alloc_pad_config(vin);
 	if (pad_cfg == NULL)
 		return -ENOMEM;
 
 	format.pad = vin->src_pad_idx;
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, pad_cfg, &format);
+	ret = rvin_subdev_call(vin, pad, set_fmt, pad_cfg, &format);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		goto done;
 
@@ -380,35 +382,46 @@ static int rvin_cropcap(struct file *file, void *priv,
 			struct v4l2_cropcap *crop)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	return v4l2_subdev_call(sd, video, cropcap, crop);
+	return rvin_subdev_call(vin, video, cropcap, crop);
 }
 
 static int rvin_enum_input(struct file *file, void *priv,
 			   struct v4l2_input *i)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
+	struct v4l2_dv_timings_cap cap;
 	int ret;
 
 	if (i->index != 0)
 		return -EINVAL;
 
-	ret = v4l2_subdev_call(sd, video, g_input_status, &i->status);
+
+	ret = rvin_subdev_call_input(vin, i->index, video,
+				     g_input_status, &i->status);
+
 	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
 		return ret;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	i->std = vin->vdev.tvnorms;
+	strlcpy(i->name, "Digital", sizeof(i->name));
 
-	if (v4l2_subdev_has_op(sd, pad, dv_timings_cap))
-		i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
+	/* Test if pad supports dv_timings_cap */
+	ret = rvin_subdev_call_input(vin, i->index, pad, dv_timings_cap, &cap);
+	if (ret) {
+		i->capabilities = V4L2_IN_CAP_STD;
+		ret = rvin_subdev_call_input(vin, i->index, video, g_tvnorms,
+					     &i->std);
+		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+			return ret;
 
-	strlcpy(i->name, "Camera", sizeof(i->name));
+	} else {
+		i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
+		i->std = 0;
+	}
 
 	return 0;
 }
@@ -429,26 +442,25 @@ static int rvin_s_input(struct file *file, void *priv, unsigned int i)
 static int rvin_querystd(struct file *file, void *priv, v4l2_std_id *a)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 
-	return v4l2_subdev_call(sd, video, querystd, a);
+	return rvin_subdev_call(vin, video, querystd, a);
 }
 
 static int rvin_s_std(struct file *file, void *priv, v4l2_std_id a)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 	struct v4l2_subdev_format fmt = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
-	int ret = v4l2_subdev_call(sd, video, s_std, a);
+	int ret;
 
+	ret = rvin_subdev_call(vin, video, s_std, a);
 	if (ret < 0)
 		return ret;
 
 	/* Changing the standard will change the width/height */
-	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
+	ret = rvin_subdev_call(vin, pad, get_fmt, NULL, &fmt);
 	if (ret) {
 		vin_err(vin, "Failed to get initial format\n");
 		return ret;
@@ -471,9 +483,8 @@ static int rvin_s_std(struct file *file, void *priv, v4l2_std_id a)
 static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 
-	return v4l2_subdev_call(sd, video, g_std, a);
+	return rvin_subdev_call(vin, video, g_std, a);
 }
 
 static int rvin_subscribe_event(struct v4l2_fh *fh,
@@ -490,15 +501,10 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
 				struct v4l2_enum_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
-	int pad, ret;
-
-	pad = timings->pad;
-	timings->pad = vin->src_pad_idx;
-
-	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
+	int ret;
 
-	timings->pad = pad;
+	ret = rvin_subdev_call_input(vin, timings->pad, pad, enum_dv_timings,
+				     timings);
 
 	return ret;
 }
@@ -507,10 +513,9 @@ static int rvin_s_dv_timings(struct file *file, void *priv_fh,
 			     struct v4l2_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 	int ret;
 
-	ret = v4l2_subdev_call(sd, video, s_dv_timings, timings);
+	ret = rvin_subdev_call(vin, video, s_dv_timings, timings);
 	if (ret)
 		return ret;
 
@@ -526,33 +531,25 @@ static int rvin_g_dv_timings(struct file *file, void *priv_fh,
 			     struct v4l2_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 
-	return v4l2_subdev_call(sd, video, g_dv_timings, timings);
+	return rvin_subdev_call(vin, video, g_dv_timings, timings);
 }
 
 static int rvin_query_dv_timings(struct file *file, void *priv_fh,
 				 struct v4l2_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 
-	return v4l2_subdev_call(sd, video, query_dv_timings, timings);
+	return rvin_subdev_call(vin, video, query_dv_timings, timings);
 }
 
 static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
 			       struct v4l2_dv_timings_cap *cap)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
-	int pad, ret;
-
-	pad = cap->pad;
-	cap->pad = vin->src_pad_idx;
-
-	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
+	int ret;
 
-	cap->pad = pad;
+	ret = rvin_subdev_call_input(vin, cap->pad, pad, dv_timings_cap, cap);
 
 	return ret;
 }
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 972eb30..a8c4d72 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -165,4 +165,19 @@ void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
 		    u32 width, u32 height);
 void rvin_crop_scale_comp(struct rvin_dev *vin);
 
+/* Subdevice group helpers */
+#define rvin_subdev_call(v, o, f, args...)				\
+	(v->digital.subdev ?						\
+	 v4l2_subdev_call(v->digital.subdev, o, f, ##args) : -ENODEV)
+#define rvin_subdev_call_input(v, i, o, f, args...)			\
+	(v->digital.subdev ?						\
+	 v4l2_subdev_call(v->digital.subdev, o, f, ##args) : -ENODEV)
+
+int rvin_subdev_get_code(struct rvin_dev *vin, u32 *code);
+int rvin_subdev_get_mbus_cfg(struct rvin_dev *vin,
+			     struct v4l2_mbus_config *mbus_cfg);
+
+int rvin_subdev_ctrl_add_handler(struct rvin_dev *vin);
+struct v4l2_subdev_pad_config *rvin_subdev_alloc_pad_config(struct rvin_dev
+							    *vin);
 #endif
-- 
2.9.0

