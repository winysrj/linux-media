Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59689 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936192AbcJGQBX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:23 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 21/22] [media] imx: Set i.MX MIPI CSI-2 entity function to bridge
Date: Fri,  7 Oct 2016 18:01:06 +0200
Message-Id: <20161007160107.5074-22-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
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
index 0613187..85d2ef7 100644
--- a/drivers/media/platform/imx/imx-mipi-csi2.c
+++ b/drivers/media/platform/imx/imx-mipi-csi2.c
@@ -585,6 +585,7 @@ static int mipi_csi2_probe(struct platform_device *pdev)
 	csi2->pads[2].flags = MEDIA_PAD_FL_SOURCE;
 	csi2->pads[3].flags = MEDIA_PAD_FL_SOURCE;
 	csi2->pads[4].flags = MEDIA_PAD_FL_SOURCE;
+	csi2->subdev.entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
 	ret = media_entity_pads_init(&csi2->subdev.entity, MIPI_CSI2_PADS,
 				csi2->pads);
 	if (ret < 0)
-- 
2.9.3

