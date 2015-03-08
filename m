Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36081 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbbCHVh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 17:37:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [PATCH] media: omap3isp: hist: Move histogram DMA to DMA engine
Date: Sun,  8 Mar 2015 23:37:55 +0200
Message-Id: <1425850675-32266-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the custom OMAP DMA API usage by DMA engine. Feature-wise the
driver has lost the ability to get notified of DMA transfers failure
through the completion handler, as the DMA engine API doesn't expose
that status information.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isph3a_aewb.c |   1 -
 drivers/media/platform/omap3isp/isph3a_af.c   |   1 -
 drivers/media/platform/omap3isp/isphist.c     | 128 ++++++++++++++++----------
 drivers/media/platform/omap3isp/ispstat.c     |   2 +-
 drivers/media/platform/omap3isp/ispstat.h     |   5 +-
 5 files changed, 80 insertions(+), 57 deletions(-)

This patch conflicts with Sakari's omap3isp DT series, which should get merged
in v4.1. One of the two will need to be rebased. That shouldn't be a big issue
as the conflict is minor.

I've tested the patch on a Beagleboard-xM with the snapshot application from
omap3-isp-live (git://git.ideasonboard.org/omap3-isp-live.git, histogram
branch). Only histogram capture has been validated, the content of the
histogram hasn't been checked.

diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
index b208c54..ccaf92f 100644
--- a/drivers/media/platform/omap3isp/isph3a_aewb.c
+++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
@@ -297,7 +297,6 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 
 	aewb->ops = &h3a_aewb_ops;
 	aewb->priv = aewb_cfg;
-	aewb->dma_ch = -1;
 	aewb->event_type = V4L2_EVENT_OMAP3ISP_AEWB;
 	aewb->isp = isp;
 
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index 8a83e19..92937f7 100644
--- a/drivers/media/platform/omap3isp/isph3a_af.c
+++ b/drivers/media/platform/omap3isp/isph3a_af.c
@@ -360,7 +360,6 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 
 	af->ops = &h3a_af_ops;
 	af->priv = af_cfg;
-	af->dma_ch = -1;
 	af->event_type = V4L2_EVENT_OMAP3ISP_AF;
 	af->isp = isp;
 
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index ce822c3..738b946 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -16,20 +16,18 @@
  */
 
 #include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dmaengine.h>
+#include <linux/omap-dmaengine.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
-#include <linux/device.h>
 
 #include "isp.h"
 #include "ispreg.h"
 #include "isphist.h"
 
-#define OMAP24XX_DMA_NO_DEVICE		0
-
 #define HIST_CONFIG_DMA	1
 
-#define HIST_USING_DMA(hist) ((hist)->dma_ch >= 0)
-
 /*
  * hist_reset_mem - clear Histogram memory before start stats engine.
  */
@@ -62,20 +60,6 @@ static void hist_reset_mem(struct ispstat *hist)
 	hist->wait_acc_frames = conf->num_acc_frames;
 }
 
-static void hist_dma_config(struct ispstat *hist)
-{
-	struct isp_device *isp = hist->isp;
-
-	hist->dma_config.data_type = OMAP_DMA_DATA_TYPE_S32;
-	hist->dma_config.sync_mode = OMAP_DMA_SYNC_ELEMENT;
-	hist->dma_config.frame_count = 1;
-	hist->dma_config.src_amode = OMAP_DMA_AMODE_CONSTANT;
-	hist->dma_config.src_start = isp->mmio_base_phys[OMAP3_ISP_IOMEM_HIST]
-				   + ISPHIST_DATA;
-	hist->dma_config.dst_amode = OMAP_DMA_AMODE_POST_INC;
-	hist->dma_config.src_or_dst_synch = OMAP_DMA_SRC_SYNC;
-}
-
 /*
  * hist_setup_regs - Helper function to update Histogram registers.
  */
@@ -176,17 +160,12 @@ static int hist_busy(struct ispstat *hist)
 						& ISPHIST_PCR_BUSY;
 }
 
-static void hist_dma_cb(int lch, u16 ch_status, void *data)
+static void hist_dma_cb(void *data)
 {
 	struct ispstat *hist = data;
 
-	if (ch_status & ~OMAP_DMA_BLOCK_IRQ) {
-		dev_dbg(hist->isp->dev, "hist: DMA error. status = 0x%04x\n",
-			ch_status);
-		omap_stop_dma(lch);
-		hist_reset_mem(hist);
-		atomic_set(&hist->buf_err, 1);
-	}
+	/* FIXME: The DMA engine API can't report transfer errors :-/ */
+
 	isp_reg_clr(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT,
 		    ISPHIST_CNT_CLEAR);
 
@@ -198,24 +177,58 @@ static void hist_dma_cb(int lch, u16 ch_status, void *data)
 static int hist_buf_dma(struct ispstat *hist)
 {
 	dma_addr_t dma_addr = hist->active_buf->dma_addr;
+	struct dma_async_tx_descriptor *tx;
+	struct dma_slave_config cfg;
+	dma_cookie_t cookie;
+	int ret;
 
 	if (unlikely(!dma_addr)) {
 		dev_dbg(hist->isp->dev, "hist: invalid DMA buffer address\n");
-		hist_reset_mem(hist);
-		return STAT_NO_BUF;
+		goto error;
 	}
 
 	isp_reg_writel(hist->isp, 0, OMAP3_ISP_IOMEM_HIST, ISPHIST_ADDR);
 	isp_reg_set(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT,
 		    ISPHIST_CNT_CLEAR);
 	omap3isp_flush(hist->isp);
-	hist->dma_config.dst_start = dma_addr;
-	hist->dma_config.elem_count = hist->buf_size / sizeof(u32);
-	omap_set_dma_params(hist->dma_ch, &hist->dma_config);
 
-	omap_start_dma(hist->dma_ch);
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.src_addr = hist->isp->mmio_base_phys[OMAP3_ISP_IOMEM_HIST]
+		     + ISPHIST_DATA;
+	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	cfg.src_maxburst = hist->buf_size / 4;
+
+	ret = dmaengine_slave_config(hist->dma_ch, &cfg);
+	if (ret < 0) {
+		dev_dbg(hist->isp->dev,
+			"hist: DMA slave configuration failed\n");
+		goto error;
+	}
+
+	tx = dmaengine_prep_slave_single(hist->dma_ch, dma_addr,
+					 hist->buf_size, DMA_DEV_TO_MEM,
+					 DMA_CTRL_ACK);
+	if (tx == NULL) {
+		dev_dbg(hist->isp->dev,
+			"hist: DMA slave preparation failed\n");
+		goto error;
+	}
+
+	tx->callback = hist_dma_cb;
+	tx->callback_param = hist;
+	cookie = tx->tx_submit(tx);
+	if (dma_submit_error(cookie)) {
+		dev_dbg(hist->isp->dev, "hist: DMA submission failed\n");
+		goto error;
+	}
+
+	dma_async_issue_pending(hist->dma_ch);
 
 	return STAT_BUF_WAITING_DMA;
+
+error:
+	hist_reset_mem(hist);
+	return STAT_NO_BUF;
 }
 
 static int hist_buf_pio(struct ispstat *hist)
@@ -272,7 +285,7 @@ static int hist_buf_process(struct ispstat *hist)
 	if (--(hist->wait_acc_frames))
 		return STAT_NO_BUF;
 
-	if (HIST_USING_DMA(hist))
+	if (hist->dma_ch)
 		ret = hist_buf_dma(hist);
 	else
 		ret = hist_buf_pio(hist);
@@ -473,18 +486,28 @@ int omap3isp_hist_init(struct isp_device *isp)
 
 	hist->isp = isp;
 
-	if (HIST_CONFIG_DMA)
-		ret = omap_request_dma(OMAP24XX_DMA_NO_DEVICE, "DMA_ISP_HIST",
-				       hist_dma_cb, hist, &hist->dma_ch);
-	if (ret) {
-		if (HIST_CONFIG_DMA)
-			dev_warn(isp->dev, "hist: DMA request channel failed. "
-					   "Using PIO only.\n");
-		hist->dma_ch = -1;
-	} else {
-		dev_dbg(isp->dev, "hist: DMA channel = %d\n", hist->dma_ch);
-		hist_dma_config(hist);
-		omap_enable_dma_irq(hist->dma_ch, OMAP_DMA_BLOCK_IRQ);
+	if (HIST_CONFIG_DMA) {
+		struct platform_device *pdev = to_platform_device(isp->dev);
+		struct resource *res;
+		unsigned int sig = 0;
+		dma_cap_mask_t mask;
+
+		dma_cap_zero(mask);
+		dma_cap_set(DMA_SLAVE, mask);
+
+		res = platform_get_resource_byname(pdev, IORESOURCE_DMA,
+						   "hist");
+		if (res)
+			sig = res->start;
+
+		hist->dma_ch = dma_request_slave_channel_compat(mask,
+				omap_dma_filter_fn, &sig, isp->dev, "hist");
+		if (!hist->dma_ch)
+			dev_warn(isp->dev,
+				 "hist: DMA channel request failed, using PIO\n");
+		else
+			dev_dbg(isp->dev, "hist: using DMA channel %s\n",
+				dma_chan_name(hist->dma_ch));
 	}
 
 	hist->ops = &hist_ops;
@@ -493,8 +516,8 @@ int omap3isp_hist_init(struct isp_device *isp)
 
 	ret = omap3isp_stat_init(hist, "histogram", &hist_subdev_ops);
 	if (ret) {
-		if (HIST_USING_DMA(hist))
-			omap_free_dma(hist->dma_ch);
+		if (hist->dma_ch)
+			dma_release_channel(hist->dma_ch);
 	}
 
 	return ret;
@@ -505,7 +528,10 @@ int omap3isp_hist_init(struct isp_device *isp)
  */
 void omap3isp_hist_cleanup(struct isp_device *isp)
 {
-	if (HIST_USING_DMA(&isp->isp_hist))
-		omap_free_dma(isp->isp_hist.dma_ch);
-	omap3isp_stat_cleanup(&isp->isp_hist);
+	struct ispstat *hist = &isp->isp_hist;
+
+	if (hist->dma_ch)
+		dma_release_channel(hist->dma_ch);
+
+	omap3isp_stat_cleanup(hist);
 }
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index a94e834..20434e8 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -21,7 +21,7 @@
 
 #include "isp.h"
 
-#define ISP_STAT_USES_DMAENGINE(stat)	((stat)->dma_ch >= 0)
+#define ISP_STAT_USES_DMAENGINE(stat)	((stat)->dma_ch != NULL)
 
 /*
  * MAGIC_SIZE must always be the greatest common divisor of
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index b32b296..b79380d 100644
--- a/drivers/media/platform/omap3isp/ispstat.h
+++ b/drivers/media/platform/omap3isp/ispstat.h
@@ -20,7 +20,6 @@
 
 #include <linux/types.h>
 #include <linux/omap3isp.h>
-#include <linux/omap-dma.h>
 #include <media/v4l2-event.h>
 
 #include "isp.h"
@@ -33,6 +32,7 @@
 #define STAT_NO_BUF		1	/* An error has occurred */
 #define STAT_BUF_WAITING_DMA	2	/* Histogram only: DMA is running */
 
+struct dma_chan;
 struct ispstat;
 
 struct ispstat_buffer {
@@ -96,7 +96,6 @@ struct ispstat {
 	u8 inc_config;
 	atomic_t buf_err;
 	enum ispstat_state_t state;	/* enabling/disabling state */
-	struct omap_dma_channel_params dma_config;
 	struct isp_device *isp;
 	void *priv;		/* pointer to priv config struct */
 	void *recover_priv;	/* pointer to recover priv configuration */
@@ -110,7 +109,7 @@ struct ispstat {
 	u32 frame_number;
 	u32 buf_size;
 	u32 buf_alloc_size;
-	int dma_ch;
+	struct dma_chan *dma_ch;
 	unsigned long event_type;
 	struct ispstat_buffer *buf;
 	struct ispstat_buffer *active_buf;
-- 
Regards,

Laurent Pinchart

