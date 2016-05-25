Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:35809 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbcEYTTv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 15:19:51 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 3/8] media: rcar-vin: add DV timings support
Date: Wed, 25 May 2016 21:10:04 +0200
Message-Id: <1464203409-1279-4-git-send-email-niklas.soderlund@ragnatech.se>
In-Reply-To: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>

Adds ioctls DV_TIMINGS_CAP, ENUM_DV_TIMINGS, G_DV_TIMINGS, S_DV_TIMINGS,
and QUERY_DV_TIMINGS.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 82 +++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 3788f8a..10a5c10 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -400,6 +400,10 @@ static int rvin_enum_input(struct file *file, void *priv,
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	i->std = vin->vdev.tvnorms;
+
+	if (v4l2_subdev_has_op(sd, pad, dv_timings_cap))
+		i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
+
 	strlcpy(i->name, "Camera", sizeof(i->name));
 
 	return 0;
@@ -478,6 +482,78 @@ static int rvin_subscribe_event(struct v4l2_fh *fh,
 	return v4l2_ctrl_subscribe_event(fh, sub);
 }
 
+static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_enum_dv_timings *timings)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_source(vin);
+	int pad, ret;
+
+	pad = timings->pad;
+	timings->pad = vin->src_pad_idx;
+
+	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
+
+	timings->pad = pad;
+
+	return ret;
+}
+
+static int rvin_s_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_source(vin);
+	int err;
+
+	err = v4l2_subdev_call(sd,
+			video, s_dv_timings, timings);
+	if (!err) {
+		vin->source.width = timings->bt.width;
+		vin->source.height = timings->bt.height;
+		vin->format.width = timings->bt.width;
+		vin->format.height = timings->bt.height;
+	}
+	return err;
+}
+
+static int rvin_g_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_source(vin);
+
+	return v4l2_subdev_call(sd,
+			video, g_dv_timings, timings);
+}
+
+static int rvin_query_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_source(vin);
+
+	return v4l2_subdev_call(sd,
+			video, query_dv_timings, timings);
+}
+
+static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings_cap *cap)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_source(vin);
+	int pad, ret;
+
+	pad = cap->pad;
+	cap->pad = vin->src_pad_idx;
+
+	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
+
+	cap->pad = pad;
+
+	return ret;
+}
+
 static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 	.vidioc_querycap		= rvin_querycap,
 	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
@@ -494,6 +570,12 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
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
2.8.2

