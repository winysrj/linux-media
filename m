Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:52419 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab1JKLEL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 07:04:11 -0400
From: Josh Wu <josh.wu@atmel.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	nicolas.ferre@atmel.com, s.nawrocki@samsung.com,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v4 1/3] [media] at91: add code to enable/disable ISI_MCK clock
Date: Tue, 11 Oct 2011 19:03:38 +0800
Message-Id: <1318331020-22031-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1318331020-22031-1-git-send-email-josh.wu@atmel.com>
References: <1318331020-22031-1-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch
- add ISI_MCK clock enable/disable code.
- change field name in isi_platform_data structure

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/video/atmel-isi.c |   34 +++++++++++++++++++++++++++++++---
 include/media/atmel-isi.h       |    4 +++-
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 774715d..0617163 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -90,7 +90,10 @@ struct atmel_isi {
 	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
 
 	struct completion		complete;
+	/* ISI peripherial clock */
 	struct clk			*pclk;
+	/* ISI_MCK, feed to camera sensor to generate pixel clock */
+	struct clk			*mck;
 	unsigned int			irq;
 
 	struct isi_platform_data	*pdata;
@@ -773,6 +776,12 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
 	if (ret)
 		return ret;
 
+	ret = clk_enable(isi->mck);
+	if (ret) {
+		clk_disable(isi->pclk);
+		return ret;
+	}
+
 	isi->icd = icd;
 	dev_dbg(icd->parent, "Atmel ISI Camera driver attached to camera %d\n",
 		 icd->devnum);
@@ -786,6 +795,7 @@ static void isi_camera_remove_device(struct soc_camera_device *icd)
 
 	BUG_ON(icd != isi->icd);
 
+	clk_disable(isi->mck);
 	clk_disable(isi->pclk);
 	isi->icd = NULL;
 
@@ -869,7 +879,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd, u32 pixfmt)
 
 	if (isi->pdata->has_emb_sync)
 		cfg1 |= ISI_CFG1_EMB_SYNC;
-	if (isi->pdata->isi_full_mode)
+	if (isi->pdata->full_mode)
 		cfg1 |= ISI_CFG1_FULL_MODE;
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
@@ -907,6 +917,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
 			isi->fb_descriptors_phys);
 
 	iounmap(isi->regs);
+	clk_put(isi->mck);
 	clk_put(isi->pclk);
 	kfree(isi);
 
@@ -925,7 +936,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	struct isi_platform_data *pdata;
 
 	pdata = dev->platform_data;
-	if (!pdata || !pdata->data_width_flags) {
+	if (!pdata || !pdata->data_width_flags || !pdata->mck_hz) {
 		dev_err(&pdev->dev,
 			"No config available for Atmel ISI\n");
 		return -EINVAL;
@@ -954,6 +965,21 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&isi->video_buffer_list);
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
+	/* Get ISI_MCK, provided by programmable clock or external clock */
+	isi->mck = clk_get(dev, "isi_mck");
+	if (IS_ERR_OR_NULL(isi->mck)) {
+		dev_err(dev, "Failed to get isi_mck\n");
+		ret = PTR_ERR(isi->mck);
+		if (isi->mck == NULL)
+			ret = -EINVAL;
+		goto err_alloc_descriptors;
+	}
+
+	/* Set ISI_MCK's frequency, it should be faster than pixel clock */
+	ret = clk_set_rate(isi->mck, pdata->mck_hz);
+	if (ret < 0)
+		goto err_set_mck_rate;
+
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
 				sizeof(struct fbd) * MAX_BUFFER_NUM,
 				&isi->fb_descriptors_phys,
@@ -961,7 +987,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	if (!isi->p_fb_descriptors) {
 		ret = -ENOMEM;
 		dev_err(&pdev->dev, "Can't allocate descriptors!\n");
-		goto err_alloc_descriptors;
+		goto err_set_mck_rate;
 	}
 
 	for (i = 0; i < MAX_BUFFER_NUM; i++) {
@@ -1023,6 +1049,8 @@ err_alloc_ctx:
 			sizeof(struct fbd) * MAX_BUFFER_NUM,
 			isi->p_fb_descriptors,
 			isi->fb_descriptors_phys);
+err_set_mck_rate:
+	clk_put(isi->mck);
 err_alloc_descriptors:
 	kfree(isi);
 err_alloc_isi:
diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
index 26cece5..6568230 100644
--- a/include/media/atmel-isi.h
+++ b/include/media/atmel-isi.h
@@ -110,10 +110,12 @@ struct isi_platform_data {
 	u8 hsync_act_low;
 	u8 vsync_act_low;
 	u8 pclk_act_falling;
-	u8 isi_full_mode;
+	u8 full_mode;
 	u32 data_width_flags;
 	/* Using for ISI_CFG1 */
 	u32 frate;
+	/* Using for ISI_MCK */
+	u32 mck_hz;
 };
 
 #endif /* __ATMEL_ISI_H__ */
-- 
1.6.3.3

