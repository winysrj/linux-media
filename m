Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2145 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3CKLq6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 25/42] go7007: convert to the control framework and remove obsolete JPEGCOMP support.
Date: Mon, 11 Mar 2013 12:46:03 +0100
Message-Id: <5ceb7620bf16f13e4be268e237fc801976b49331.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just add a read-only V4L2_CID_JPEG_ACTIVE_MARKER control to replace
the JPEGCOMP support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-driver.c |   11 +-
 drivers/staging/media/go7007/go7007-priv.h   |    3 +
 drivers/staging/media/go7007/go7007-v4l2.c   |  249 +++++++-------------------
 3 files changed, 71 insertions(+), 192 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index dca85d8..d689989 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -268,12 +268,17 @@ int go7007_register_encoder(struct go7007 *go, unsigned num_i2c_devs)
 	ret = go7007_init_encoder(go);
 	mutex_unlock(&go->hw_lock);
 	if (ret < 0)
-		return -1;
+		return ret;
+
+	ret = go7007_v4l2_ctrl_init(go);
+	if (ret < 0)
+		return ret;
 
 	if (!go->i2c_adapter_online &&
 			go->board_info->flags & GO7007_BOARD_USE_ONBOARD_I2C) {
-		if (go7007_i2c_init(go) < 0)
-			return -1;
+		ret = go7007_i2c_init(go);
+		if (ret < 0)
+			return ret;
 		go->i2c_adapter_online = 1;
 	}
 	if (go->i2c_adapter_online) {
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 54cfc0a..d127a8d 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -22,6 +22,7 @@
  */
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 struct go7007;
 
@@ -182,6 +183,7 @@ struct go7007 {
 	void *boot_fw;
 	unsigned boot_fw_len;
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler hdl;
 	enum { STATUS_INIT, STATUS_ONLINE, STATUS_SHUTDOWN } status;
 	spinlock_t spinlock;
 	struct mutex hw_lock;
@@ -296,6 +298,7 @@ int go7007_i2c_remove(struct go7007 *go);
 
 /* go7007-v4l2.c */
 int go7007_v4l2_init(struct go7007 *go);
+int go7007_v4l2_ctrl_init(struct go7007 *go);
 void go7007_v4l2_remove(struct go7007 *go);
 
 /* snd-go7007.c */
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 53d2cbc..cb89af3 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -42,9 +42,6 @@
 #ifndef V4L2_MPEG_STREAM_TYPE_MPEG_ELEM
 #define	V4L2_MPEG_STREAM_TYPE_MPEG_ELEM   6 /* MPEG elementary stream */
 #endif
-#ifndef V4L2_MPEG_VIDEO_ENCODING_MPEG_4
-#define	V4L2_MPEG_VIDEO_ENCODING_MPEG_4   3
-#endif
 
 #define call_all(dev, o, f, args...) \
 	v4l2_device_call_until_err(dev, 0, o, f, ##args)
@@ -387,67 +384,18 @@ static int clip_to_modet_map(struct go7007 *go, int region,
 }
 #endif
 
-static int mpeg_query_ctrl(struct v4l2_queryctrl *ctrl)
+static int go7007_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	static const u32 mpeg_ctrls[] = {
-		V4L2_CID_MPEG_CLASS,
-		V4L2_CID_MPEG_STREAM_TYPE,
-		V4L2_CID_MPEG_VIDEO_ENCODING,
-		V4L2_CID_MPEG_VIDEO_ASPECT,
-		V4L2_CID_MPEG_VIDEO_GOP_SIZE,
-		V4L2_CID_MPEG_VIDEO_GOP_CLOSURE,
-		V4L2_CID_MPEG_VIDEO_BITRATE,
-		0
-	};
-	static const u32 *ctrl_classes[] = {
-		mpeg_ctrls,
-		NULL
-	};
-
-	ctrl->id = v4l2_ctrl_next(ctrl_classes, ctrl->id);
-
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_CLASS:
-		return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		return v4l2_ctrl_query_fill(ctrl,
-				V4L2_MPEG_STREAM_TYPE_MPEG2_DVD,
-				V4L2_MPEG_STREAM_TYPE_MPEG_ELEM, 1,
-				V4L2_MPEG_STREAM_TYPE_MPEG_ELEM);
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		return v4l2_ctrl_query_fill(ctrl,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_1,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_4, 1,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		return v4l2_ctrl_query_fill(ctrl,
-				V4L2_MPEG_VIDEO_ASPECT_1x1,
-				V4L2_MPEG_VIDEO_ASPECT_16x9, 1,
-				V4L2_MPEG_VIDEO_ASPECT_1x1);
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		return v4l2_ctrl_query_fill(ctrl, 0, 34, 1, 15);
-	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
-		return v4l2_ctrl_query_fill(ctrl, 0, 1, 1, 0);
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		return v4l2_ctrl_query_fill(ctrl,
-				64000,
-				10000000, 1,
-				1500000);
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
+	struct go7007 *go =
+		container_of(ctrl->handler, struct go7007, hdl);
 
-static int mpeg_s_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
-{
 	/* pretty sure we can't change any of these while streaming */
 	if (go->streaming)
 		return -EBUSY;
 
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_STREAM_TYPE:
-		switch (ctrl->value) {
+		switch (ctrl->val) {
 		case V4L2_MPEG_STREAM_TYPE_MPEG2_DVD:
 			go->format = GO7007_FORMAT_MPEG2;
 			go->bitrate = 9800000;
@@ -459,15 +407,12 @@ static int mpeg_s_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 			go->gop_header_enable = 1;
 			go->dvd_mode = 1;
 			break;
-		case V4L2_MPEG_STREAM_TYPE_MPEG_ELEM:
-			/* todo: */
-			break;
 		default:
 			return -EINVAL;
 		}
 		break;
 	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		switch (ctrl->value) {
+		switch (ctrl->val) {
 		case V4L2_MPEG_VIDEO_ENCODING_MPEG_1:
 			go->format = GO7007_FORMAT_MPEG1;
 			go->pali = 0;
@@ -479,7 +424,7 @@ static int mpeg_s_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 			else*/
 				go->pali = 0x48;
 			break;
-		case V4L2_MPEG_VIDEO_ENCODING_MPEG_4:
+		case V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC:
 			go->format = GO7007_FORMAT_MPEG4;
 			/*if (mpeg->pali >> 24 == 4)
 				go->pali = mpeg->pali & 0xff;
@@ -499,9 +444,10 @@ static int mpeg_s_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 		go->dvd_mode = 0;
 		break;
 	case V4L2_CID_MPEG_VIDEO_ASPECT:
+		/* TODO: is this really the right thing to do for mjpeg? */
 		if (go->format == GO7007_FORMAT_MJPEG)
 			return -EINVAL;
-		switch (ctrl->value) {
+		switch (ctrl->val) {
 		case V4L2_MPEG_VIDEO_ASPECT_1x1:
 			go->aspect_ratio = GO7007_RATIO_1_1;
 			break;
@@ -511,80 +457,18 @@ static int mpeg_s_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 		case V4L2_MPEG_VIDEO_ASPECT_16x9:
 			go->aspect_ratio = GO7007_RATIO_16_9;
 			break;
-		case V4L2_MPEG_VIDEO_ASPECT_221x100:
-		default:
-			return -EINVAL;
-		}
-		break;
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		if (ctrl->value < 0 || ctrl->value > 34)
-			return -EINVAL;
-		go->gop_size = ctrl->value;
-		break;
-	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
-		if (ctrl->value != 0 && ctrl->value != 1)
-			return -EINVAL;
-		go->closed_gop = ctrl->value;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		/* Upper bound is kind of arbitrary here */
-		if (ctrl->value < 64000 || ctrl->value > 10000000)
-			return -EINVAL;
-		go->bitrate = ctrl->value;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int mpeg_g_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
-{
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		if (go->dvd_mode)
-			ctrl->value = V4L2_MPEG_STREAM_TYPE_MPEG2_DVD;
-		else
-			ctrl->value = V4L2_MPEG_STREAM_TYPE_MPEG_ELEM;
-		break;
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		switch (go->format) {
-		case GO7007_FORMAT_MPEG1:
-			ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_1;
-			break;
-		case GO7007_FORMAT_MPEG2:
-			ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_2;
-			break;
-		case GO7007_FORMAT_MPEG4:
-			ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_4;
-			break;
-		default:
-			return -EINVAL;
-		}
-		break;
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		switch (go->aspect_ratio) {
-		case GO7007_RATIO_1_1:
-			ctrl->value = V4L2_MPEG_VIDEO_ASPECT_1x1;
-			break;
-		case GO7007_RATIO_4_3:
-			ctrl->value = V4L2_MPEG_VIDEO_ASPECT_4x3;
-			break;
-		case GO7007_RATIO_16_9:
-			ctrl->value = V4L2_MPEG_VIDEO_ASPECT_16x9;
-			break;
 		default:
 			return -EINVAL;
 		}
 		break;
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		ctrl->value = go->gop_size;
+		go->gop_size = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
-		ctrl->value = go->closed_gop;
+		go->closed_gop = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		ctrl->value = go->bitrate;
+		go->bitrate = ctrl->val;
 		break;
 	default:
 		return -EINVAL;
@@ -968,41 +852,6 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-			   struct v4l2_queryctrl *query)
-{
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
-	int id = query->id;
-
-	if (0 == call_all(&go->v4l2_dev, core, queryctrl, query))
-		return 0;
-
-	query->id = id;
-	return mpeg_query_ctrl(query);
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
-
-	if (0 == call_all(&go->v4l2_dev, core, g_ctrl, ctrl))
-		return 0;
-
-	return mpeg_g_ctrl(ctrl, go);
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
-
-	if (0 == call_all(&go->v4l2_dev, core, s_ctrl, ctrl))
-		return 0;
-
-	return mpeg_s_ctrl(ctrl, go);
-}
-
 static int vidioc_g_parm(struct file *filp, void *priv,
 		struct v4l2_streamparm *parm)
 {
@@ -1423,28 +1272,6 @@ static int vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *
 	return 0;
 }
 
-static int vidioc_g_jpegcomp(struct file *file, void *priv,
-			 struct v4l2_jpegcompression *params)
-{
-	memset(params, 0, sizeof(*params));
-	params->quality = 50; /* ?? */
-	params->jpeg_markers = V4L2_JPEG_MARKER_DHT |
-				V4L2_JPEG_MARKER_DQT;
-
-	return 0;
-}
-
-static int vidioc_s_jpegcomp(struct file *file, void *priv,
-			 const struct v4l2_jpegcompression *params)
-{
-	if (params->quality != 50 ||
-			params->jpeg_markers != (V4L2_JPEG_MARKER_DHT |
-						V4L2_JPEG_MARKER_DQT))
-		return -EINVAL;
-
-	return 0;
-}
-
 /* FIXME:
 	Those ioctls are private, and not needed, since several standard
 	extended controls already provide streaming control.
@@ -1782,6 +1609,10 @@ static struct v4l2_file_operations go7007_fops = {
 	.poll		= go7007_poll,
 };
 
+static struct v4l2_ctrl_ops go7007_ctrl_ops = {
+	.s_ctrl = go7007_s_ctrl,
+};
+
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_querycap          = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid_cap,
@@ -1801,9 +1632,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enumaudio         = vidioc_enumaudio,
 	.vidioc_g_audio           = vidioc_g_audio,
 	.vidioc_s_audio           = vidioc_s_audio,
-	.vidioc_queryctrl         = vidioc_queryctrl,
-	.vidioc_g_ctrl            = vidioc_g_ctrl,
-	.vidioc_s_ctrl            = vidioc_s_ctrl,
 	.vidioc_streamon          = vidioc_streamon,
 	.vidioc_streamoff         = vidioc_streamoff,
 	.vidioc_g_tuner           = vidioc_g_tuner,
@@ -1817,8 +1645,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_cropcap           = vidioc_cropcap,
 	.vidioc_g_crop            = vidioc_g_crop,
 	.vidioc_s_crop            = vidioc_s_crop,
-	.vidioc_g_jpegcomp        = vidioc_g_jpegcomp,
-	.vidioc_s_jpegcomp        = vidioc_s_jpegcomp,
 };
 
 static struct video_device go7007_template = {
@@ -1829,6 +1655,50 @@ static struct video_device go7007_template = {
 	.tvnorms	= V4L2_STD_ALL,
 };
 
+int go7007_v4l2_ctrl_init(struct go7007 *go)
+{
+	struct v4l2_ctrl_handler *hdl = &go->hdl;
+	struct v4l2_ctrl *ctrl;
+
+	v4l2_ctrl_handler_init(hdl, 12);
+	v4l2_ctrl_new_std_menu(hdl, &go7007_ctrl_ops,
+			V4L2_CID_MPEG_STREAM_TYPE,
+			V4L2_MPEG_STREAM_TYPE_MPEG2_DVD,
+			0x7,
+			V4L2_MPEG_STREAM_TYPE_MPEG2_DVD);
+	v4l2_ctrl_new_std_menu(hdl, &go7007_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_ENCODING,
+			V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC,
+			0,
+			V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
+	v4l2_ctrl_new_std_menu(hdl, &go7007_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_ASPECT,
+			V4L2_MPEG_VIDEO_ASPECT_16x9,
+			0,
+			V4L2_MPEG_VIDEO_ASPECT_1x1);
+	v4l2_ctrl_new_std(hdl, &go7007_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, 34, 1, 15);
+	v4l2_ctrl_new_std(hdl, &go7007_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_GOP_CLOSURE, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &go7007_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_BITRATE,
+			64000, 10000000, 1, 1500000);
+	ctrl = v4l2_ctrl_new_std(hdl, &go7007_ctrl_ops,
+			V4L2_CID_JPEG_ACTIVE_MARKER, 0,
+			V4L2_JPEG_ACTIVE_MARKER_DQT | V4L2_JPEG_ACTIVE_MARKER_DHT, 0,
+			V4L2_JPEG_ACTIVE_MARKER_DQT | V4L2_JPEG_ACTIVE_MARKER_DHT);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+	if (hdl->error) {
+		int rv = hdl->error;
+
+		v4l2_err(&go->v4l2_dev, "Could not register controls\n");
+		return rv;
+	}
+	go->v4l2_dev.ctrl_handler = hdl;
+	return 0;
+}
+
 int go7007_v4l2_init(struct go7007 *go)
 {
 	int rv;
@@ -1869,4 +1739,5 @@ void go7007_v4l2_remove(struct go7007 *go)
 		spin_unlock_irqrestore(&go->spinlock, flags);
 	}
 	mutex_unlock(&go->hw_lock);
+	v4l2_ctrl_handler_free(&go->hdl);
 }
-- 
1.7.10.4

