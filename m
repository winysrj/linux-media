Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:38021 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbeDGNEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 09:04:47 -0400
From: Marek Vasut <marex@denx.de>
To: linux-media@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] media: imx: Skip every second frame in VDIC DIRECT mode
Date: Sat,  7 Apr 2018 15:04:40 +0200
Message-Id: <20180407130440.24886-1-marex@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In VDIC direct mode, the VDIC applies combing filter during and
doubles the framerate, that is, after the first two half-frames
are received and the first frame is emitted by the VDIC, every
subsequent half-frame is patched into the result and a full frame
is produced. The half-frame order in the full frames is as follows
12 32 34 54 etc.

Drop every second frame to trim the framerate back to the original
one of the signal and skip the odd patched frames.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-vdic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 482250d47e7c..b538bbebedc5 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -289,6 +289,7 @@ static int vdic_setup_direct(struct vdic_priv *priv)
 	/* set VDIC to receive from CSI for direct path */
 	ipu_fsu_link(priv->ipu, IPUV3_CHANNEL_CSI_DIRECT,
 		     IPUV3_CHANNEL_CSI_VDI_PREV);
+	ipu_set_vdi_skip(priv->ipu, 0x2);
 
 	return 0;
 }
@@ -313,6 +314,8 @@ static int vdic_setup_indirect(struct vdic_priv *priv)
 	const struct imx_media_pixfmt *incc;
 	int in_size, ret;
 
+	ipu_set_vdi_skip(priv->ipu, 0x0);
+
 	infmt = &priv->format_mbus[VDIC_SINK_PAD_IDMAC];
 	incc = priv->cc[VDIC_SINK_PAD_IDMAC];
 
-- 
2.16.2
