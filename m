Return-path: <mchehab@pedra>
Received: from dakia2.marvell.com ([65.219.4.35]:57741 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1AQJ14 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 04:27:56 -0500
From: Qing Xu <qingx@marvell.com>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Qing Xu <qingx@marvell.com>
Subject: [PATCH] [media] v4l: soc-camera: add enum-frame-size ioctl
Date: Mon, 17 Jan 2011 17:30:52 +0800
Message-Id: <1295256652-6276-1-git-send-email-qingx@marvell.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

add vidioc_enum_framesizes implementation, follow default_g_parm()
and g_mbus_fmt() method

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/media/video/soc_camera.c |   42 ++++++++++++++++++++++++++++++++++++++
 include/media/soc_camera.h       |    1 +
 include/media/v4l2-subdev.h      |    2 +
 3 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 052bd6d..35260a5 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -145,6 +145,18 @@ static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
 	return v4l2_subdev_call(sd, core, s_std, *a);
 }
 
+static int soc_camera_enum_fsizes(struct file *file, void *fh,
+					 struct v4l2_frmsizeenum *fsize)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+
+	if (ici->ops->enum_fsizes)
+		return ici->ops->enum_fsizes(icd, fsize);
+
+	return -ENOIOCTLCMD;
+}
+
 static int soc_camera_reqbufs(struct file *file, void *priv,
 			      struct v4l2_requestbuffers *p)
 {
@@ -1160,6 +1172,33 @@ static int default_s_parm(struct soc_camera_device *icd,
 	return v4l2_subdev_call(sd, video, s_parm, parm);
 }
 
+static int default_enum_fsizes(struct soc_camera_device *icd,
+			  struct v4l2_frmsizeenum *fsize)
+{
+	int ret;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_mbus_framefmt mf;
+	const struct soc_camera_format_xlate *xlate;
+	__u32 pixfmt = fsize->pixel_format;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		return -EINVAL;
+	}
+
+	mf.code = xlate->code;
+
+	ret = v4l2_subdev_call(sd, video, enum_mbus_fsizes, &mf);
+	if (ret < 0)
+		return ret;
+
+	fsize->discrete.height = mf.height;
+	fsize->discrete.width = mf.width;
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+
+	return 0;
+}
+
 static void soc_camera_device_init(struct device *dev, void *pdata)
 {
 	dev->platform_data	= pdata;
@@ -1195,6 +1234,8 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 		ici->ops->set_parm = default_s_parm;
 	if (!ici->ops->get_parm)
 		ici->ops->get_parm = default_g_parm;
+	if (!ici->ops->enum_fsizes)
+		ici->ops->enum_fsizes = default_enum_fsizes;
 
 	mutex_lock(&list_lock);
 	list_for_each_entry(ix, &hosts, list) {
@@ -1302,6 +1343,7 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_g_input		 = soc_camera_g_input,
 	.vidioc_s_input		 = soc_camera_s_input,
 	.vidioc_s_std		 = soc_camera_s_std,
+	.vidioc_enum_framesizes  = soc_camera_enum_fsizes,
 	.vidioc_reqbufs		 = soc_camera_reqbufs,
 	.vidioc_try_fmt_vid_cap  = soc_camera_try_fmt_vid_cap,
 	.vidioc_querybuf	 = soc_camera_querybuf,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 86e3631..6e4800c 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -85,6 +85,7 @@ struct soc_camera_host_ops {
 	int (*set_ctrl)(struct soc_camera_device *, struct v4l2_control *);
 	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
+	int (*enum_fsizes)(struct soc_camera_device *, struct v4l2_frmsizeenum *);
 	unsigned int (*poll)(struct file *, poll_table *);
 	const struct v4l2_queryctrl *controls;
 	int num_controls;
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b0316a7..d4e0d80 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -275,6 +275,8 @@ struct v4l2_subdev_video_ops {
 			struct v4l2_dv_timings *timings);
 	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
 			     enum v4l2_mbus_pixelcode *code);
+	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
+			     struct v4l2_mbus_framefmt *fmt);
 	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
 			  struct v4l2_mbus_framefmt *fmt);
 	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
-- 
1.6.3.3

