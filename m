Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45564 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756897AbZFKHMt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 03:12:49 -0400
Date: Thu, 11 Jun 2009 09:12:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: [PATCH 3/4] soc-camera: add support for camera-host controls
In-Reply-To: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
Message-ID: <Pine.LNX.4.64.0906101604420.4817@axis700.grange>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Until now soc-camera only supported client (sensor) controls. This patch
enables camera-host drivers to implement their own controls too.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   24 ++++++++++++++++++++++++
 include/media/soc_camera.h       |    4 ++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 824c68b..8e987ca 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -633,6 +633,7 @@ static int soc_camera_queryctrl(struct file *file, void *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int i;
 
 	WARN_ON(priv != file->private_data);
@@ -640,6 +641,15 @@ static int soc_camera_queryctrl(struct file *file, void *priv,
 	if (!qc->id)
 		return -EINVAL;
 
+	/* First check host controls */
+	for (i = 0; i < ici->ops->num_controls; i++)
+		if (qc->id == ici->ops->controls[i].id) {
+			memcpy(qc, &(ici->ops->controls[i]),
+				sizeof(*qc));
+			return 0;
+		}
+
+	/* Then device controls */
 	for (i = 0; i < icd->ops->num_controls; i++)
 		if (qc->id == icd->ops->controls[i].id) {
 			memcpy(qc, &(icd->ops->controls[i]),
@@ -656,6 +666,7 @@ static int soc_camera_g_ctrl(struct file *file, void *priv,
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	int ret;
 
 	WARN_ON(priv != file->private_data);
 
@@ -672,6 +683,12 @@ static int soc_camera_g_ctrl(struct file *file, void *priv,
 		return 0;
 	}
 
+	if (ici->ops->get_ctrl) {
+		ret = ici->ops->get_ctrl(icd, ctrl);
+		if (ret != -ENOIOCTLCMD)
+			return ret;
+	}
+
 	return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, g_ctrl, ctrl);
 }
 
@@ -681,9 +698,16 @@ static int soc_camera_s_ctrl(struct file *file, void *priv,
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	int ret;
 
 	WARN_ON(priv != file->private_data);
 
+	if (ici->ops->set_ctrl) {
+		ret = ici->ops->set_ctrl(icd, ctrl);
+		if (ret != -ENOIOCTLCMD)
+			return ret;
+	}
+
 	return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, s_ctrl, ctrl);
 }
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 3bc5b6b..2d116bb 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -83,7 +83,11 @@ struct soc_camera_host_ops {
 	int (*reqbufs)(struct soc_camera_file *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
 	int (*set_bus_param)(struct soc_camera_device *, __u32);
+	int (*get_ctrl)(struct soc_camera_device *, struct v4l2_control *);
+	int (*set_ctrl)(struct soc_camera_device *, struct v4l2_control *);
 	unsigned int (*poll)(struct file *, poll_table *);
+	const struct v4l2_queryctrl *controls;
+	int num_controls;
 };
 
 #define SOCAM_SENSOR_INVERT_PCLK	(1 << 0)
-- 
1.6.2.4

