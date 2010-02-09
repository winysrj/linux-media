Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35498 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752234Ab0BIJZK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 04:25:10 -0500
Date: Tue, 9 Feb 2010 10:25:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>,
	Magnus Damm <damm@opensource.se>
Subject: [PATCH 1/2] soc-camera: add support for VIDIOC_S_PARM and VIDIOC_G_PARM
 ioctls
In-Reply-To: <Pine.LNX.4.64.1002090856050.4585@axis700.grange>
Message-ID: <Pine.LNX.4.64.1002091023590.4585@axis700.grange>
References: <u1vi3wnt2.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.1002090856050.4585@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just pass VIDIOC_S_PARM and VIDIOC_G_PARM down to host drivers. So far no 
special handling in soc-camera core.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 6b3fbcc..abce210 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -781,6 +781,32 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	return ret;
 }
 
+static int soc_camera_g_parm(struct file *file, void *fh,
+			     struct v4l2_streamparm *a)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+
+	if (ici->ops->get_parm)
+		return ici->ops->get_parm(icd, a);
+
+	return -ENOIOCTLCMD;
+}
+
+static int soc_camera_s_parm(struct file *file, void *fh,
+			     struct v4l2_streamparm *a)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+
+	if (ici->ops->set_parm)
+		return ici->ops->set_parm(icd, a);
+
+	return -ENOIOCTLCMD;
+}
+
 static int soc_camera_g_chip_ident(struct file *file, void *fh,
 				   struct v4l2_dbg_chip_ident *id)
 {
@@ -1260,6 +1286,8 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_cropcap		 = soc_camera_cropcap,
 	.vidioc_g_crop		 = soc_camera_g_crop,
 	.vidioc_s_crop		 = soc_camera_s_crop,
+	.vidioc_g_parm		 = soc_camera_g_parm,
+	.vidioc_s_parm		 = soc_camera_s_parm,
 	.vidioc_g_chip_ident     = soc_camera_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	 = soc_camera_g_register,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index dcc5b86..5a17365 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -81,6 +81,8 @@ struct soc_camera_host_ops {
 	int (*set_bus_param)(struct soc_camera_device *, __u32);
 	int (*get_ctrl)(struct soc_camera_device *, struct v4l2_control *);
 	int (*set_ctrl)(struct soc_camera_device *, struct v4l2_control *);
+	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
+	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	unsigned int (*poll)(struct file *, poll_table *);
 	const struct v4l2_queryctrl *controls;
 	int num_controls;
