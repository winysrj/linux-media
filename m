Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40779 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbeECQcJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 12:32:09 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Jan Luebbe <jlu@pengutronix.de>, slongerbeam@gmail.com,
        p.zabel@pengutronix.de
Subject: [PATCH] media: imx-csi: fix burst size for 16 bit
Date: Thu,  3 May 2018 18:32:00 +0200
Message-Id: <20180503163200.12214-1-jlu@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A burst_size of 4 does not work for the 16 bit passthrough formats, so
we use 8 instead.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 1112d8f67a18..08b636084286 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -410,7 +410,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	case V4L2_PIX_FMT_SGRBG16:
 	case V4L2_PIX_FMT_SRGGB16:
 	case V4L2_PIX_FMT_Y16:
-		burst_size = 4;
+		burst_size = 8;
 		passthrough = true;
 		passthrough_bits = 16;
 		break;
-- 
2.17.0
