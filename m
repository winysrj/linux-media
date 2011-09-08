Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:63275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab1IHIoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:17 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 02/13 v3] sh_mobile_ceu_camera: implement the control handler.
Date: Thu,  8 Sep 2011 10:43:55 +0200
Message-Id: <1315471446-17890-3-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

And since this is the last and only host driver that uses controls, also
remove the now obsolete control fields from soc_camera.h.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[g.liakhovetski@gmx.de: moved code around, fixed problems]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   91 ++++++++++++----------------
 include/media/soc_camera.h                 |    4 -
 2 files changed, 38 insertions(+), 57 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 8711aa8..955947a 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -997,6 +997,38 @@ static bool sh_mobile_ceu_packing_supported(const struct soc_mbus_pixelfmt *fmt)
 
 static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect);
 
+static struct soc_camera_device *ctrl_to_icd(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct soc_camera_device,
+							ctrl_handler);
+}
+
+static int sh_mobile_ceu_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct soc_camera_device *icd = ctrl_to_icd(ctrl);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+
+	switch (ctrl->id) {
+	case V4L2_CID_SHARPNESS:
+		switch (icd->current_fmt->host_fmt->fourcc) {
+		case V4L2_PIX_FMT_NV12:
+		case V4L2_PIX_FMT_NV21:
+		case V4L2_PIX_FMT_NV16:
+		case V4L2_PIX_FMT_NV61:
+			ceu_write(pcdev, CLFCR, !ctrl->val);
+			return 0;
+		}
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static const struct v4l2_ctrl_ops sh_mobile_ceu_ctrl_ops = {
+	.s_ctrl = sh_mobile_ceu_s_ctrl,
+};
+
 static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int idx,
 				     struct soc_camera_format_xlate *xlate)
 {
@@ -1033,6 +1065,12 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		struct v4l2_rect rect;
 		int shift = 0;
 
+		/* Add our control */
+		v4l2_ctrl_new_std(&icd->ctrl_handler, &sh_mobile_ceu_ctrl_ops,
+				  V4L2_CID_SHARPNESS, 0, 1, 1, 0);
+		if (icd->ctrl_handler.error)
+			return icd->ctrl_handler.error;
+
 		/* FIXME: subwindow is lost between close / open */
 
 		/* Cache current client geometry */
@@ -1961,55 +1999,6 @@ static int sh_mobile_ceu_init_videobuf(struct vb2_queue *q,
 	return vb2_queue_init(q);
 }
 
-static int sh_mobile_ceu_get_ctrl(struct soc_camera_device *icd,
-				  struct v4l2_control *ctrl)
-{
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	u32 val;
-
-	switch (ctrl->id) {
-	case V4L2_CID_SHARPNESS:
-		val = ceu_read(pcdev, CLFCR);
-		ctrl->value = val ^ 1;
-		return 0;
-	}
-	return -ENOIOCTLCMD;
-}
-
-static int sh_mobile_ceu_set_ctrl(struct soc_camera_device *icd,
-				  struct v4l2_control *ctrl)
-{
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-
-	switch (ctrl->id) {
-	case V4L2_CID_SHARPNESS:
-		switch (icd->current_fmt->host_fmt->fourcc) {
-		case V4L2_PIX_FMT_NV12:
-		case V4L2_PIX_FMT_NV21:
-		case V4L2_PIX_FMT_NV16:
-		case V4L2_PIX_FMT_NV61:
-			ceu_write(pcdev, CLFCR, !ctrl->value);
-			return 0;
-		}
-		return -EINVAL;
-	}
-	return -ENOIOCTLCMD;
-}
-
-static const struct v4l2_queryctrl sh_mobile_ceu_controls[] = {
-	{
-		.id		= V4L2_CID_SHARPNESS,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Low-pass filter",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-	},
-};
-
 static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= sh_mobile_ceu_add_device,
@@ -2021,14 +2010,10 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.set_livecrop	= sh_mobile_ceu_set_livecrop,
 	.set_fmt	= sh_mobile_ceu_set_fmt,
 	.try_fmt	= sh_mobile_ceu_try_fmt,
-	.set_ctrl	= sh_mobile_ceu_set_ctrl,
-	.get_ctrl	= sh_mobile_ceu_get_ctrl,
 	.poll		= sh_mobile_ceu_poll,
 	.querycap	= sh_mobile_ceu_querycap,
 	.set_bus_param	= sh_mobile_ceu_set_bus_param,
 	.init_videobuf2	= sh_mobile_ceu_init_videobuf,
-	.controls	= sh_mobile_ceu_controls,
-	.num_controls	= ARRAY_SIZE(sh_mobile_ceu_controls),
 };
 
 struct bus_wait {
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2e15e17..d41b8bd 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -96,14 +96,10 @@ struct soc_camera_host_ops {
 	int (*reqbufs)(struct soc_camera_device *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
 	int (*set_bus_param)(struct soc_camera_device *, __u32);
-	int (*get_ctrl)(struct soc_camera_device *, struct v4l2_control *);
-	int (*set_ctrl)(struct soc_camera_device *, struct v4l2_control *);
 	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	int (*enum_fsizes)(struct soc_camera_device *, struct v4l2_frmsizeenum *);
 	unsigned int (*poll)(struct file *, poll_table *);
-	const struct v4l2_queryctrl *controls;
-	int num_controls;
 };
 
 #define SOCAM_SENSOR_INVERT_PCLK	(1 << 0)
-- 
1.7.2.5

