Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:60503 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZKJN4B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 08:56:01 -0500
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id nAADu462017224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 07:56:06 -0600
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH] Davinci VPFE Capture: Add support for Control ioctls
Date: Tue, 10 Nov 2009 19:26:02 +0530
Message-Id: <1257861362-8219-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Added support for Control IOCTL,
	- s_ctrl
	- g_ctrl
	- queryctrl

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |   38 ++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index abe21e4..9c859a7 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1368,6 +1368,41 @@ static int vpfe_g_std(struct file *file, void *priv, v4l2_std_id *std_id)
 	return 0;
 }
 
+static int vpfe_queryctrl(struct file *file, void *priv,
+		struct v4l2_queryctrl *qctrl)
+{
+	struct vpfe_device *vpfe_dev = video_drvdata(file);
+	struct vpfe_subdev_info *sdinfo;
+
+	sdinfo = vpfe_dev->current_subdev;
+
+	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
+					 core, queryctrl, qctrl);
+
+}
+
+static int vpfe_g_ctrl(struct file *file, void *priv, struct v4l2_control *ctrl)
+{
+	struct vpfe_device *vpfe_dev = video_drvdata(file);
+	struct vpfe_subdev_info *sdinfo;
+
+	sdinfo = vpfe_dev->current_subdev;
+
+	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
+					 core, g_ctrl, ctrl);
+}
+
+static int vpfe_s_ctrl(struct file *file, void *priv, struct v4l2_control *ctrl)
+{
+	struct vpfe_device *vpfe_dev = video_drvdata(file);
+	struct vpfe_subdev_info *sdinfo;
+
+	sdinfo = vpfe_dev->current_subdev;
+
+	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
+					 core, s_ctrl, ctrl);
+}
+
 /*
  *  Videobuf operations
  */
@@ -1939,6 +1974,9 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
 	.vidioc_querystd	 = vpfe_querystd,
 	.vidioc_s_std		 = vpfe_s_std,
 	.vidioc_g_std		 = vpfe_g_std,
+	.vidioc_queryctrl	 = vpfe_queryctrl,
+	.vidioc_g_ctrl		 = vpfe_g_ctrl,
+	.vidioc_s_ctrl		 = vpfe_s_ctrl,
 	.vidioc_reqbufs		 = vpfe_reqbufs,
 	.vidioc_querybuf	 = vpfe_querybuf,
 	.vidioc_qbuf		 = vpfe_qbuf,
-- 
1.6.2.4

