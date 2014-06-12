Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33029 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbaFLRGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 16/26] [media] ipuv3-csi: Skip 3 lines for NTSC BT.656
Date: Thu, 12 Jun 2014 19:06:30 +0200
Message-Id: <1402592800-2925-17-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TVP5150 creates 480 visible lines, but synchronisation
signals for 486 visible lines.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/imx/imx-ipuv3-csi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/imx/imx-ipuv3-csi.c b/drivers/media/platform/imx/imx-ipuv3-csi.c
index d9326a8..dfa2daa 100644
--- a/drivers/media/platform/imx/imx-ipuv3-csi.c
+++ b/drivers/media/platform/imx/imx-ipuv3-csi.c
@@ -698,8 +698,14 @@ static int ipucsi_videobuf_start_streaming(struct vb2_queue *vq, unsigned int co
 
 	ipu_csi_write(ipucsi, CSI_ACT_FRM_HEIGHT(yres) | CSI_ACT_FRM_WIDTH(xres),
 			CSI_ACT_FRM_SIZE);
-	ipu_csi_write(ipucsi, CSI_OUT_FRM_CTRL_HSC(0) | CSI_OUT_FRM_CTRL_VSC(0),
-			CSI_OUT_FRM_CTRL);
+	/* FIXME */
+	if (xres == 720 && yres == 480) {
+		ipu_csi_write(ipucsi, CSI_OUT_FRM_CTRL_HSC(0) |
+				CSI_OUT_FRM_CTRL_VSC(3), CSI_OUT_FRM_CTRL);
+	} else {
+		ipu_csi_write(ipucsi, CSI_OUT_FRM_CTRL_HSC(0) |
+				CSI_OUT_FRM_CTRL_VSC(0), CSI_OUT_FRM_CTRL);
+	}
 
 	ret = media_entity_pipeline_start(&ipucsi->subdev.entity, &ipucsi->pipe);
 	if (ret)
-- 
2.0.0.rc2

