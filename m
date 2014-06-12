Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33032 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbaFLRGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [RFC PATCH 18/26] [media] ipuv3-csi: make subdev controls available on video device
Date: Thu, 12 Jun 2014 19:06:32 +0200
Message-Id: <1402592800-2925-19-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/platform/imx/imx-ipuv3-csi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/platform/imx/imx-ipuv3-csi.c b/drivers/media/platform/imx/imx-ipuv3-csi.c
index e75d7f5..0dd40a4 100644
--- a/drivers/media/platform/imx/imx-ipuv3-csi.c
+++ b/drivers/media/platform/imx/imx-ipuv3-csi.c
@@ -250,6 +250,7 @@ struct ipucsi {
 	struct v4l2_format		format;
 	struct ipucsi_format		ipucsifmt;
 	struct v4l2_ctrl_handler	ctrls;
+	struct v4l2_ctrl_handler	ctrls_vdev;
 	struct v4l2_ctrl		*ctrl_test_pattern;
 	struct media_pad		media_pad;
 	struct media_pipeline		pipe;
@@ -1096,12 +1097,19 @@ int v4l2_media_subdev_s_power(struct ipucsi *ipucsi, int enable)
 		goto disable;
 	}
 
+	v4l2_ctrl_handler_init(&ipucsi->ctrls_vdev, 1);
+
 	while (!ret && (entity = media_entity_graph_walk_next(&graph))) {
 		if (media_entity_type(entity) == MEDIA_ENT_T_V4L2_SUBDEV) {
 			sd = media_entity_to_v4l2_subdev(entity);
 			ret = v4l2_subdev_call(sd, core, s_power, 1);
 			if (ret == -ENOIOCTLCMD)
 				ret = 0;
+
+			ret = v4l2_ctrl_add_handler(&ipucsi->ctrls_vdev,
+						    sd->ctrl_handler, NULL);
+			if (ret)
+				return ret;
 		}
 	}
 
@@ -1147,6 +1155,8 @@ static int ipucsi_release(struct file *file)
 	if (v4l2_fh_is_singular_file(file)) {
 		v4l2_media_subdev_s_power(ipucsi, 0);
 
+		v4l2_ctrl_handler_free(&ipucsi->ctrls_vdev);
+
 		vb2_fop_release(file);
 	} else {
 		v4l2_fh_release(file);
@@ -1320,6 +1330,7 @@ static int ipucsi_video_device_init(struct platform_device *pdev,
 	vdev->minor	= -1;
 	vdev->release	= video_device_release_empty;
 	vdev->lock	= &ipucsi->mutex;
+	vdev->ctrl_handler = &ipucsi->ctrls_vdev;
 	vdev->queue	= &ipucsi->vb2_vidq;
 
 	video_set_drvdata(vdev, ipucsi);
-- 
2.0.0.rc2

