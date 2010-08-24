Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40977 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0HXIKk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 04:10:40 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: jbe@pengutronix.de, Juergen Beisert <j.beisert@pengutronix.de>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH] mx3fb and ipu_idmac cleanups
Date: Tue, 24 Aug 2010 10:10:34 +0200
Message-Id: <1282637434-5413-1-git-send-email-m.grzeschik@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

From: Juergen Beisert <j.beisert@pengutronix.de>

Signed-off-by: Juergen Beisert <jbe@pengutronix.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/dma/ipu/ipu_idmac.c |    2 +-
 drivers/video/mx3fb.c       |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index cb26ee9..e065703 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -321,7 +321,7 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 		params->ip.wid2	= 4;		/* Blue bit width - 1 */
 		break;
 	case IPU_PIX_FMT_BGR24:
-		params->ip.bpp	= 1;		/* 24 BPP & RGB PFS */
+		params->ip.bpp	= 1;		/* 24 BPP & BGR PFS */
 		params->ip.pfs	= 4;
 		params->ip.npb	= 7;
 		params->ip.sat	= 2;		/* SAT = 32-bit access */
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 7cfc170..658f10a 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -660,12 +660,12 @@ static uint32_t bpp_to_pixfmt(int bpp)
 {
 	uint32_t pixfmt = 0;
 	switch (bpp) {
-	case 24:
-		pixfmt = IPU_PIX_FMT_BGR24;
-		break;
 	case 32:
 		pixfmt = IPU_PIX_FMT_BGR32;
 		break;
+	case 24:
+		pixfmt = IPU_PIX_FMT_BGR24;
+		break;
 	case 16:
 		pixfmt = IPU_PIX_FMT_RGB565;
 		break;
-- 
1.7.1

