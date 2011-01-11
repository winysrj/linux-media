Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2158 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab1AKXGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 18:06:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH 02/12] sh_mobile_ceu_camera: implement the control handler.
Date: Wed, 12 Jan 2011 00:06:02 +0100
Message-Id: <4ef0bba6ffe2a932c43cdc99d22fe0da0e6bfcd5.1294786597.git.hverkuil@xs4all.nl>
In-Reply-To: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
References: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

And since this is the last and only host driver that uses controls, also
remove the now obsolete control fields from soc_camera.h.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   95 ++++++++++++---------------
 include/media/soc_camera.h                 |    4 -
 2 files changed, 42 insertions(+), 57 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 954222b..f007f57 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -112,6 +112,7 @@ struct sh_mobile_ceu_dev {
 
 	unsigned int image_mode:1;
 	unsigned int is_16bit:1;
+	unsigned int added_controls:1;
 };
 
 struct sh_mobile_ceu_cam {
@@ -133,6 +134,12 @@ struct sh_mobile_ceu_cam {
 	enum v4l2_mbus_pixelcode code;
 };
 
+static inline struct soc_camera_device *to_icd(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct soc_camera_device,
+							ctrl_handler);
+}
+
 static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
 {
 	unsigned long flags;
@@ -490,6 +497,33 @@ out:
 	return IRQ_HANDLED;
 }
 
+static int sh_mobile_ceu_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct soc_camera_device *icd = to_icd(ctrl);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+
+	ici = to_soc_camera_host(icd->dev.parent);
+	pcdev = ici->priv;
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
+	return -EINVAL;
+}
+
+static const struct v4l2_ctrl_ops sh_mobile_ceu_ctrl_ops = {
+	.s_ctrl = sh_mobile_ceu_s_ctrl,
+};
+
 /* Called with .video_lock held */
 static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 {
@@ -500,6 +534,14 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 	if (pcdev->icd)
 		return -EBUSY;
 
+	if (!pcdev->added_controls) {
+		v4l2_ctrl_new_std(&icd->ctrl_handler, &sh_mobile_ceu_ctrl_ops,
+				V4L2_CID_SHARPNESS, 0, 1, 1, 0);
+		if (icd->ctrl_handler.error)
+			return icd->ctrl_handler.error;
+		pcdev->added_controls = 1;
+	}
+
 	dev_info(icd->dev.parent,
 		 "SuperH Mobile CEU driver attached to camera %d\n",
 		 icd->devnum);
@@ -1789,55 +1831,6 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
 				       icd, &icd->video_lock);
 }
 
-static int sh_mobile_ceu_get_ctrl(struct soc_camera_device *icd,
-				  struct v4l2_control *ctrl)
-{
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
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
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
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
@@ -1848,15 +1841,11 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.set_crop	= sh_mobile_ceu_set_crop,
 	.set_fmt	= sh_mobile_ceu_set_fmt,
 	.try_fmt	= sh_mobile_ceu_try_fmt,
-	.set_ctrl	= sh_mobile_ceu_set_ctrl,
-	.get_ctrl	= sh_mobile_ceu_get_ctrl,
 	.reqbufs	= sh_mobile_ceu_reqbufs,
 	.poll		= sh_mobile_ceu_poll,
 	.querycap	= sh_mobile_ceu_querycap,
 	.set_bus_param	= sh_mobile_ceu_set_bus_param,
 	.init_videobuf	= sh_mobile_ceu_init_videobuf,
-	.controls	= sh_mobile_ceu_controls,
-	.num_controls	= ARRAY_SIZE(sh_mobile_ceu_controls),
 };
 
 struct bus_wait {
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index ee61ffb..b71b26e 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -83,13 +83,9 @@ struct soc_camera_host_ops {
 	int (*reqbufs)(struct soc_camera_device *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
 	int (*set_bus_param)(struct soc_camera_device *, __u32);
-	int (*get_ctrl)(struct soc_camera_device *, struct v4l2_control *);
-	int (*set_ctrl)(struct soc_camera_device *, struct v4l2_control *);
 	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	unsigned int (*poll)(struct file *, poll_table *);
-	const struct v4l2_queryctrl *controls;
-	int num_controls;
 };
 
 #define SOCAM_SENSOR_INVERT_PCLK	(1 << 0)
-- 
1.7.0.4

