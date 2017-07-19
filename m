Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:43347 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751233AbdGSMWt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 08:22:49 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] imx: csi: enable double write reduction
Date: Wed, 19 Jul 2017 14:22:43 +0200
Message-Id: <20170719122243.22911-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For 4:2:0 subsampled YUV formats, avoid chroma overdraw by only writing
chroma for even lines. Reduces necessary write memory bandwidth by 25%.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index a2d26693912ec..0fb70d5a9e7fe 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -388,6 +388,12 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 			goto unsetup_vb2;
 	}
 
+	switch (image.pix.pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_NV12:
+		ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
+	}
+
 	ipu_cpmem_set_burstsize(priv->idmac_ch, burst_size);
 
 	/*
-- 
2.11.0
