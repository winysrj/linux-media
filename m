Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:58632 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660Ab2DRTuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 15:50:35 -0400
Received: by qcro28 with SMTP id o28so4757864qcr.19
        for <linux-media@vger.kernel.org>; Wed, 18 Apr 2012 12:50:31 -0700 (PDT)
MIME-Version: 1.0
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Wed, 18 Apr 2012 14:42:12 -0500
Message-ID: <CAKnK67SK+CKBL-Dx0V0nyYtEWN3wp3D90M9irFCQOmqiX2fKPw@mail.gmail.com>
Subject: [PATCH] v4l: soc-camera: Add support for enum_frameintervals ioctl
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sergio Aguirre <saaguirre@ti.com>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/soc_camera.c |   37 +++++++++++++++++++++++++++++++++++++
 include/media/soc_camera.h       |    1 +
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index eb25756..62c8956 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -266,6 +266,15 @@ static int soc_camera_enum_fsizes(struct file
*file, void *fh,
 	return ici->ops->enum_fsizes(icd, fsize);
 }

+static int soc_camera_enum_fivals(struct file *file, void *fh,
+				   struct v4l2_frmivalenum *fival)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
+	return ici->ops->enum_fivals(icd, fival);
+}
+
 static int soc_camera_reqbufs(struct file *file, void *priv,
 			      struct v4l2_requestbuffers *p)
 {
@@ -1266,6 +1275,31 @@ static int default_enum_fsizes(struct
soc_camera_device *icd,
 	return 0;
 }

+static int default_enum_fivals(struct soc_camera_device *icd,
+			  struct v4l2_frmivalenum *fival)
+{
+	int ret;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	const struct soc_camera_format_xlate *xlate;
+	__u32 pixfmt = fival->pixel_format;
+	struct v4l2_frmivalenum fival_sd = *fival;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate)
+		return -EINVAL;
+	/* map xlate-code to pixel_format, sensor only handle xlate-code*/
+	fival_sd.pixel_format = xlate->code;
+
+	ret = v4l2_subdev_call(sd, video, enum_frameintervals, &fival_sd);
+	if (ret < 0)
+		return ret;
+
+	*fival = fival_sd;
+	fival->pixel_format = pixfmt;
+
+	return 0;
+}
+
 int soc_camera_host_register(struct soc_camera_host *ici)
 {
 	struct soc_camera_host *ix;
@@ -1297,6 +1331,8 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 		ici->ops->get_parm = default_g_parm;
 	if (!ici->ops->enum_fsizes)
 		ici->ops->enum_fsizes = default_enum_fsizes;
+	if (!ici->ops->enum_fivals)
+		ici->ops->enum_fivals = default_enum_fivals;

 	mutex_lock(&list_lock);
 	list_for_each_entry(ix, &hosts, list) {
@@ -1387,6 +1423,7 @@ static const struct v4l2_ioctl_ops
soc_camera_ioctl_ops = {
 	.vidioc_s_std		 = soc_camera_s_std,
 	.vidioc_g_std		 = soc_camera_g_std,
 	.vidioc_enum_framesizes  = soc_camera_enum_fsizes,
+	.vidioc_enum_frameintervals  = soc_camera_enum_fivals,
 	.vidioc_reqbufs		 = soc_camera_reqbufs,
 	.vidioc_querybuf	 = soc_camera_querybuf,
 	.vidioc_qbuf		 = soc_camera_qbuf,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index b5c2b6c..0a3ac07 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -98,6 +98,7 @@ struct soc_camera_host_ops {
 	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	int (*enum_fsizes)(struct soc_camera_device *, struct v4l2_frmsizeenum *);
+	int (*enum_fivals)(struct soc_camera_device *, struct v4l2_frmivalenum *);
 	unsigned int (*poll)(struct file *, poll_table *);
 };

-- 
1.7.5.4
