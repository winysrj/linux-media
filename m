Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33306 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbcCBRRH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 12:17:07 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v2 6/9] media: rcar-vin: add DV timings support
Date: Wed,  2 Mar 2016 18:16:34 +0100
Message-Id: <1456938997-29971-7-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1456938997-29971-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1456938997-29971-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ioctls DV_TIMINGS_CAP, ENUM_DV_TIMINGS, G_DV_TIMINGS, S_DV_TIMINGS,
and QUERY_DV_TIMINGS.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 69 ++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 3d957dc..4596eda 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -644,12 +644,17 @@ static int rvin_enum_input(struct file *file, void *priv,
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
@@ -692,6 +697,64 @@ static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
 	return v4l2_subdev_call(sd, video, g_std, a);
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
@@ -706,6 +769,12 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 	.vidioc_g_input			= rvin_g_input,
 	.vidioc_s_input			= rvin_s_input,
 
+	.vidioc_dv_timings_cap		= rvin_dv_timings_cap,
+	.vidioc_enum_dv_timings		= rvin_enum_dv_timings,
+	.vidioc_g_dv_timings		= rvin_g_dv_timings,
+	.vidioc_s_dv_timings		= rvin_s_dv_timings,
+	.vidioc_query_dv_timings	= rvin_query_dv_timings,
+
 	.vidioc_querystd		= rvin_querystd,
 	.vidioc_g_std			= rvin_g_std,
 	.vidioc_s_std			= rvin_s_std,
-- 
2.6.4

