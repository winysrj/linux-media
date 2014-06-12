Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33031 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaFLRGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [RFC PATCH 17/26] [media] ipuv3-csi: Pass ipucsi to v4l2_media_subdev_s_power
Date: Thu, 12 Jun 2014 19:06:31 +0200
Message-Id: <1402592800-2925-18-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sascha Hauer <s.hauer@pengutronix.de>

Makes it easier to access ipucsi from v4l2_media_subdev_s_power which
is needed in subsequent patches.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/platform/imx/imx-ipuv3-csi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/imx/imx-ipuv3-csi.c b/drivers/media/platform/imx/imx-ipuv3-csi.c
index dfa2daa..e75d7f5 100644
--- a/drivers/media/platform/imx/imx-ipuv3-csi.c
+++ b/drivers/media/platform/imx/imx-ipuv3-csi.c
@@ -1080,8 +1080,9 @@ disable:
 	return ret;
 }
 
-int v4l2_media_subdev_s_power(struct media_entity *entity, int enable)
+int v4l2_media_subdev_s_power(struct ipucsi *ipucsi, int enable)
 {
+	struct media_entity *entity = &ipucsi->subdev.entity;
 	struct media_entity_graph graph;
 	struct media_entity *first;
 	struct v4l2_subdev *sd;
@@ -1131,7 +1132,7 @@ static int ipucsi_open(struct file *file)
 		goto out;
 
 	if (v4l2_fh_is_singular_file(file))
-		ret = v4l2_media_subdev_s_power(&ipucsi->subdev.entity, 1);
+		ret = v4l2_media_subdev_s_power(ipucsi, 1);
 
 out:
 	mutex_unlock(&ipucsi->mutex);
@@ -1144,7 +1145,7 @@ static int ipucsi_release(struct file *file)
 
 	mutex_lock(&ipucsi->mutex);
 	if (v4l2_fh_is_singular_file(file)) {
-		v4l2_media_subdev_s_power(&ipucsi->subdev.entity, 0);
+		v4l2_media_subdev_s_power(ipucsi, 0);
 
 		vb2_fop_release(file);
 	} else {
-- 
2.0.0.rc2

