Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:18014 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754805AbeASNeZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 08:34:25 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <mchehab@kernel.org>
CC: <arnd@arndb.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: v4l: omap_vout: vrfb: Use the wrapper for prep_interleaved_dma()
Date: Fri, 19 Jan 2018 15:34:34 +0200
Message-ID: <20180119133434.3587-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of directly accessing to dmadev->device_prep_interleaved_dma() use
the dmaengine_prep_interleaved_dma() wrapper instead.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/media/platform/omap/omap_vout_vrfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index 123c2b26a933..72c0ac2cbf3d 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -271,7 +271,7 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
 	xt->dst_sgl = true;
 	xt->dst_inc = true;
 
-	tx = dmadev->device_prep_interleaved_dma(chan, xt, flags);
+	tx = dmaengine_prep_interleaved_dma(chan, xt, flags);
 	if (tx == NULL) {
 		pr_err("%s: DMA interleaved prep error\n", __func__);
 		return -EINVAL;
-- 
Peter

Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
