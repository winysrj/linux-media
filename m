Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab1I1NUb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 09:20:31 -0400
Date: Wed, 28 Sep 2011 15:20:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7/7 v9] V4L: soc-camera: add 2 new ioctl() handlers
In-Reply-To: <1314211292-10414-8-git-send-email-g.liakhovetski@gmx.de>
Message-ID: <Pine.LNX.4.64.1109281518190.30317@axis700.grange>
References: <1314211292-10414-1-git-send-email-g.liakhovetski@gmx.de>
 <1314211292-10414-8-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds two new ioctl() handlers: .vidioc_create_bufs() and
.vidioc_prepare_buf() for compliant vb2 soc-camera hosts.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v9: remove "const" from an argument of the .vidioc_prepare_buf() method

 drivers/media/video/soc_camera.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index ac23916..088972d 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -318,6 +318,32 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 		return vb2_dqbuf(&icd->vb2_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
+static int soc_camera_create_bufs(struct file *file, void *priv,
+			    struct v4l2_create_buffers *create)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
+	/* videobuf2 only */
+	if (ici->ops->init_videobuf)
+		return -EINVAL;
+	else
+		return vb2_create_bufs(&icd->vb2_vidq, create);
+}
+
+static int soc_camera_prepare_buf(struct file *file, void *priv,
+				  struct v4l2_buffer *b)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
+	/* videobuf2 only */
+	if (ici->ops->init_videobuf)
+		return -EINVAL;
+	else
+		return vb2_prepare_buf(&icd->vb2_vidq, b);
+}
+
 /* Always entered with .video_lock held */
 static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 {
@@ -1101,6 +1127,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		if (!control || !control->driver || !dev_get_drvdata(control) ||
 		    !try_module_get(control->driver->owner)) {
 			icl->del_device(icd);
+			ret = -ENODEV;
 			goto enodrv;
 		}
 	}
@@ -1366,19 +1393,21 @@ static int soc_camera_device_register(struct soc_camera_device *icd)
 
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
+	.vidioc_prepare_buf	 = soc_camera_prepare_buf,
 	.vidioc_streamon	 = soc_camera_streamon,
 	.vidioc_streamoff	 = soc_camera_streamoff,
 	.vidioc_queryctrl	 = soc_camera_queryctrl,
-- 
1.7.2.5

