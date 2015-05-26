Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45235 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbbEZN07 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 09:26:59 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 09/13] crypto: omap-des - Support for deferred probing when requesting DMA channels
Date: Tue, 26 May 2015 16:26:04 +0300
Message-ID: <1432646768-12532-10-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to use ma_request_slave_channel_compat_reason() to request the DMA
channels. Only fall back to pio mode if the error code returned is not
-EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-des.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 46307098f8ba..06be02f520da 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -340,7 +340,7 @@ static void omap_des_dma_out_callback(void *data)
 
 static int omap_des_dma_init(struct omap_des_dev *dd)
 {
-	int err = -ENOMEM;
+	int err;
 	dma_cap_mask_t mask;
 
 	dd->dma_lch_out = NULL;
@@ -349,21 +349,20 @@ static int omap_des_dma_init(struct omap_des_dev *dd)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	dd->dma_lch_in = dma_request_slave_channel_compat(mask,
-							  omap_dma_filter_fn,
-							  &dd->dma_in,
-							  dd->dev, "rx");
-	if (!dd->dma_lch_in) {
+	dd->dma_lch_in = dma_request_slave_channel_compat_reason(mask,
+					omap_dma_filter_fn, &dd->dma_in,
+					dd->dev, "rx");
+	if (IS_ERR(dd->dma_lch_in)) {
 		dev_err(dd->dev, "Unable to request in DMA channel\n");
-		goto err_dma_in;
+		return PTR_ERR(dd->dma_lch_in);
 	}
 
-	dd->dma_lch_out = dma_request_slave_channel_compat(mask,
-							   omap_dma_filter_fn,
-							   &dd->dma_out,
-							   dd->dev, "tx");
-	if (!dd->dma_lch_out) {
+	dd->dma_lch_out = dma_request_slave_channel_compat_reason(mask,
+					omap_dma_filter_fn, &dd->dma_out,
+					dd->dev, "tx");
+	if (IS_ERR(dd->dma_lch_out)) {
 		dev_err(dd->dev, "Unable to request out DMA channel\n");
+		err = PTR_ERR(dd->dma_lch_out);
 		goto err_dma_out;
 	}
 
@@ -371,14 +370,15 @@ static int omap_des_dma_init(struct omap_des_dev *dd)
 
 err_dma_out:
 	dma_release_channel(dd->dma_lch_in);
-err_dma_in:
-	if (err)
-		pr_err("error: %d\n", err);
+
 	return err;
 }
 
 static void omap_des_dma_cleanup(struct omap_des_dev *dd)
 {
+	if (dd->pio_only)
+		return;
+
 	dma_release_channel(dd->dma_lch_out);
 	dma_release_channel(dd->dma_lch_in);
 }
@@ -1110,7 +1110,9 @@ static int omap_des_probe(struct platform_device *pdev)
 	tasklet_init(&dd->queue_task, omap_des_queue_task, (unsigned long)dd);
 
 	err = omap_des_dma_init(dd);
-	if (err && DES_REG_IRQ_STATUS(dd) && DES_REG_IRQ_ENABLE(dd)) {
+	if (err == -EPROBE_DEFER) {
+		goto err_irq;
+	} else if (err && DES_REG_IRQ_STATUS(dd) && DES_REG_IRQ_ENABLE(dd)) {
 		dd->pio_only = 1;
 
 		irq = platform_get_irq(pdev, 0);
@@ -1154,8 +1156,8 @@ err_algs:
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
 			crypto_unregister_alg(
 					&dd->pdata->algs_info[i].algs_list[j]);
-	if (!dd->pio_only)
-		omap_des_dma_cleanup(dd);
+
+	omap_des_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
 	tasklet_kill(&dd->queue_task);
-- 
2.3.5

