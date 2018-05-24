Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49802 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967154AbeEXVD2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 17:03:28 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Subject: [PATCH] v4l: vsp1: Update LIF buffer thresholds
Date: Fri, 25 May 2018 00:03:22 +0300
Message-Id: <20180524210322.11402-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The LIF module has a data buffer to accommodate clock rate differences
between the DU and the VSP. Several programmable threshold values
control DU start of frame notification by the VSP and VSP clock
stop/resume. The R-Car Gen2 and Gen3 datasheets recommend values for the
different SoCs. Update the driver to use the recommended values for
optimal operation.

Based on a BSP patch from Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
with Gen2 and V3H/V3M updates.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_lif.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 0cb63244b21a..d313fa19eecb 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -88,14 +88,35 @@ static void lif_configure_stream(struct vsp1_entity *entity,
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(&entity->subdev);
-	unsigned int hbth = 1300;
-	unsigned int obth = 400;
-	unsigned int lbth = 200;
+	unsigned int hbth;
+	unsigned int obth;
+	unsigned int lbth;
 
 	format = vsp1_entity_get_pad_format(&lif->entity, lif->entity.config,
 					    LIF_PAD_SOURCE);
 
-	obth = min(obth, (format->width + 1) / 2 * format->height - 4);
+	switch (entity->vsp1->version & VI6_IP_VERSION_SOC_MASK) {
+	case VI6_IP_VERSION_MODEL_VSPD_GEN2:
+	case VI6_IP_VERSION_MODEL_VSPD_V2H:
+		hbth = 1536;
+		obth = min(128, (format->width + 1) / 2 * format->height - 4);
+		lbth = 1520;
+		break;
+
+	case VI6_IP_VERSION_MODEL_VSPDL_GEN3:
+	case VI6_IP_VERSION_MODEL_VSPD_V3:
+		hbth = 0;
+		obth = 1500;
+		lbth = 0;
+		break;
+
+	case VI6_IP_VERSION_MODEL_VSPD_GEN3:
+	default:
+		hbth = 0;
+		obth = 3000;
+		lbth = 0;
+		break;
+	}
 
 	vsp1_lif_write(lif, dlb, VI6_LIF_CSBTH,
 			(hbth << VI6_LIF_CSBTH_HBTH_SHIFT) |
-- 
Regards,

Laurent Pinchart
