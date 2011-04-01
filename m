Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:57493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab1DAINQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2011 04:13:16 -0400
Date: Fri, 1 Apr 2011 10:13:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH/RFC 3/4] V4L: soc-camera: add support for new multi-size
 video-buffer ioctl()s
In-Reply-To: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
Message-ID: <Pine.LNX.4.64.1104011011480.9530@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   46 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 11f0f1e..6a41e89 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -286,6 +286,45 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 		return vb2_dqbuf(&icd->vb2_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
+static int soc_camera_create_bufs(struct file *file, void *priv,
+			    struct v4l2_create_buffers *create)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+
+	/* videobuf2 only */
+	if (ici->ops->init_videobuf)
+		return -EINVAL;
+	else
+		return vb2_create_bufs(&icd->vb2_vidq, create);
+}
+
+static int soc_camera_destroy_bufs(struct file *file, void *priv,
+			    struct v4l2_buffer_span *span)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+
+	/* videobuf2 only */
+	if (ici->ops->init_videobuf)
+		return -EINVAL;
+	else
+		return vb2_destroy_bufs(&icd->vb2_vidq, span);
+}
+
+static int soc_camera_submit_buf(struct file *file, void *priv,
+			    unsigned int idx)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+
+	/* videobuf2 only */
+	if (ici->ops->init_videobuf)
+		return -EINVAL;
+	else
+		return vb2_submit_buf(&icd->vb2_vidq, idx);
+}
+
 /* Always entered with .video_lock held */
 static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 {
@@ -1420,19 +1459,22 @@ static void soc_camera_device_unregister(struct soc_camera_device *icd)
 
 static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_querycap	 = soc_camera_querycap,
+	.vidioc_try_fmt_vid_cap  = soc_camera_try_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap    = soc_camera_g_fmt_vid_cap,
-	.vidioc_enum_fmt_vid_cap = soc_camera_enum_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap    = soc_camera_s_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap = soc_camera_enum_fmt_vid_cap,
 	.vidioc_enum_input	 = soc_camera_enum_input,
 	.vidioc_g_input		 = soc_camera_g_input,
 	.vidioc_s_input		 = soc_camera_s_input,
 	.vidioc_s_std		 = soc_camera_s_std,
 	.vidioc_enum_framesizes  = soc_camera_enum_fsizes,
 	.vidioc_reqbufs		 = soc_camera_reqbufs,
-	.vidioc_try_fmt_vid_cap  = soc_camera_try_fmt_vid_cap,
 	.vidioc_querybuf	 = soc_camera_querybuf,
 	.vidioc_qbuf		 = soc_camera_qbuf,
 	.vidioc_dqbuf		 = soc_camera_dqbuf,
+	.vidioc_create_bufs	 = soc_camera_create_bufs,
+	.vidioc_destroy_bufs	 = soc_camera_destroy_bufs,
+	.vidioc_submit_buf	 = soc_camera_submit_buf,
 	.vidioc_streamon	 = soc_camera_streamon,
 	.vidioc_streamoff	 = soc_camera_streamoff,
 	.vidioc_queryctrl	 = soc_camera_queryctrl,
-- 
1.7.2.5

