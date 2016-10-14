Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:55449 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755782AbcJNRfI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:35:08 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 20/21] [media] imx: Set i.MX MIPI CSI-2 entity function to bridge
Date: Fri, 14 Oct 2016 19:34:40 +0200
Message-Id: <1476466481-24030-21-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The i.MX6 MIPI CSI2 bridge converts the external MIPI CSI2 input into
a SoC internal parallel bus connected to the IPU CSIs via the CSI2IPU
gasket.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/imx/imx-mipi-csi2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/imx/imx-mipi-csi2.c b/drivers/media/platform/imx/imx-mipi-csi2.c
index 7b289cc..6b00a67 100644
--- a/drivers/media/platform/imx/imx-mipi-csi2.c
+++ b/drivers/media/platform/imx/imx-mipi-csi2.c
@@ -606,6 +606,7 @@ static int mipi_csi2_probe(struct platform_device *pdev)
 	csi2->pads[2].flags = MEDIA_PAD_FL_SOURCE;
 	csi2->pads[3].flags = MEDIA_PAD_FL_SOURCE;
 	csi2->pads[4].flags = MEDIA_PAD_FL_SOURCE;
+	csi2->subdev.entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
 	ret = media_entity_pads_init(&csi2->subdev.entity, MIPI_CSI2_PADS,
 				csi2->pads);
 	if (ret < 0)
-- 
2.9.3

