Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33107 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161577AbcBQPtR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 10:49:17 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH/RFC 6/9] media: rcar-vin: add DV timings support
Date: Wed, 17 Feb 2016 16:48:42 +0100
Message-Id: <1455724125-13004-7-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ioctls DV_TIMINGS_CAP, ENUM_DV_TIMINGS, G_DV_TIMINGS, S_DV_TIMINGS,
and QUERY_DV_TIMINGS.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 69 ++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 6b23c968..d40b39b 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -511,12 +511,17 @@ static int rvin_enum_input(struct file *file, void *priv,
 		struct v4l2_input *i)
 {
 	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_sd(vin);
 
 	if (i->index != 0)
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	i->std = vin->vdev.tvnorms;
+
+	if (v4l2_subdev_has_op(sd, pad, dv_timings_cap))
+		i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
+
 	strlcpy(i->name, "Camera", sizeof(i->name));
 
 	return 0;
@@ -572,6 +577,64 @@ static int rvin_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	return ret;
 }
 
+static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_enum_dv_timings *timings)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_sd(vin);
+
+	timings->pad = 0;
+	return v4l2_subdev_call(sd,
+			pad, enum_dv_timings, timings);
+}
+
+static int rvin_s_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_sd(vin);
+	int err;
+
+	err = v4l2_subdev_call(sd,
+			video, s_dv_timings, timings);
+	if (!err) {
+		vin->sensor.width = timings->bt.width;
+		vin->sensor.height = timings->bt.height;
+	}
+	return err;
+}
+
+static int rvin_g_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_sd(vin);
+
+	return v4l2_subdev_call(sd,
+			video, g_dv_timings, timings);
+}
+
+static int rvin_query_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_sd(vin);
+
+	return v4l2_subdev_call(sd,
+			video, query_dv_timings, timings);
+}
+
+static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings_cap *cap)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_sd(vin);
+
+	cap->pad = 0;
+	return v4l2_subdev_call(sd,
+			pad, dv_timings_cap, cap);
+}
+
 static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 	.vidioc_querycap		= rvin_querycap,
 	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
@@ -588,6 +651,12 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 	.vidioc_g_input			= rvin_g_input,
 	.vidioc_s_input			= rvin_s_input,
 
+	.vidioc_dv_timings_cap		= rvin_dv_timings_cap,
+	.vidioc_enum_dv_timings		= rvin_enum_dv_timings,
+	.vidioc_g_dv_timings		= rvin_g_dv_timings,
+	.vidioc_s_dv_timings		= rvin_s_dv_timings,
+	.vidioc_query_dv_timings	= rvin_query_dv_timings,
+
 	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
 	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
 	.vidioc_querybuf		= vb2_ioctl_querybuf,
-- 
2.6.4

