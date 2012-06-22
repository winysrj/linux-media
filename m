Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56673 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab2FVQkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 12:40:13 -0400
Date: Fri, 22 Jun 2012 18:40:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] V4L: soc-camera: add selection API host operations
Message-ID: <Pine.LNX.4.64.1206221749190.17552@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add .get_selection() and .set_selection() soc-camera host driver 
operations. Additionally check, that the user is not trying to change the 
output sizes during a running capture.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 0421bf9..72798d2 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -902,6 +902,65 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	return ret;
 }
 
+static int soc_camera_g_selection(struct file *file, void *fh,
+				  struct v4l2_selection *s)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
+	/* With a wrong type no need to try to fall back to cropping */
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (!ici->ops->get_selection)
+		return -ENOTTY;
+
+	return ici->ops->get_selection(icd, s);
+}
+
+static int soc_camera_s_selection(struct file *file, void *fh,
+				  struct v4l2_selection *s)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	int ret;
+
+	/* In all these cases cropping emulation will not help */
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    (s->target != V4L2_SEL_TGT_COMPOSE_ACTIVE &&
+	     s->target != V4L2_SEL_TGT_CROP_ACTIVE))
+		return -EINVAL;
+
+	if (s->target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
+		/* No output size change during a running capture! */
+		if (is_streaming(ici, icd) &&
+		    (icd->user_width != s->r.width ||
+		     icd->user_height != s->r.height))
+			return -EBUSY;
+
+		/*
+		 * Only one user is allowed to change the output format, touch
+		 * buffers, start / stop streaming, poll for data
+		 */
+		if (icd->streamer && icd->streamer != file)
+			return -EBUSY;
+	}
+
+	if (!ici->ops->set_selection)
+		return -ENOTTY;
+
+	ret = ici->ops->set_selection(icd, s);
+	if (!ret &&
+	    s->target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
+		icd->user_width = s->r.width;
+		icd->user_height = s->r.height;
+		if (!icd->streamer)
+			icd->streamer = file;
+	}
+
+	return ret;
+}
+
 static int soc_camera_g_parm(struct file *file, void *fh,
 			     struct v4l2_streamparm *a)
 {
@@ -1405,6 +1464,8 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_cropcap		 = soc_camera_cropcap,
 	.vidioc_g_crop		 = soc_camera_g_crop,
 	.vidioc_s_crop		 = soc_camera_s_crop,
+	.vidioc_g_selection	 = soc_camera_g_selection,
+	.vidioc_s_selection	 = soc_camera_s_selection,
 	.vidioc_g_parm		 = soc_camera_g_parm,
 	.vidioc_s_parm		 = soc_camera_s_parm,
 	.vidioc_g_chip_ident     = soc_camera_g_chip_ident,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index d865dcf..f997d6a 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -86,6 +86,8 @@ struct soc_camera_host_ops {
 	int (*cropcap)(struct soc_camera_device *, struct v4l2_cropcap *);
 	int (*get_crop)(struct soc_camera_device *, struct v4l2_crop *);
 	int (*set_crop)(struct soc_camera_device *, struct v4l2_crop *);
+	int (*get_selection)(struct soc_camera_device *, struct v4l2_selection *);
+	int (*set_selection)(struct soc_camera_device *, struct v4l2_selection *);
 	/*
 	 * The difference to .set_crop() is, that .set_livecrop is not allowed
 	 * to change the output sizes
