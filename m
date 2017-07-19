Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:44651 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754249AbdGSQeW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 12:34:22 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2] [media] imx: csi: enable double write reduction
Date: Wed, 19 Jul 2017 18:34:20 +0200
Message-Id: <20170719163420.27608-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For 4:2:0 subsampled YUV formats, avoid chroma overdraw by only writing
chroma for even lines. Reduces necessary write memory bandwidth by 25%.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Move odd row skipping setup into existing switch statement.
---
 drivers/staging/media/imx/imx-media-csi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index a2d26693912ec..f2d64d1eeff80 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -357,6 +357,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 		passthrough = (sensor_ep->bus_type != V4L2_MBUS_CSI2 &&
 			       sensor_ep->bus.parallel.bus_width >= 16);
 		passthrough_bits = 16;
+		/* Skip writing U and V components to odd rows */
+		ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
 		break;
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
-- 
2.11.0
