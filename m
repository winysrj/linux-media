Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48636 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab3LDP2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 10:28:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 5/5] v4l: atmel-isi: Make the MCK clock optional
Date: Wed,  4 Dec 2013 16:28:36 +0100
Message-Id: <1386170916-13723-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386170916-13723-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386170916-13723-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ISI_MCK is the sensor master clock. It should be handled by the sensor
driver directly, as the ISI has no use for that clock. Make the clock
optional here while platforms transition to the correct model.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 36 ++++++++++++++++-----------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index ae2c8c1..3e8d412 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -725,10 +725,12 @@ static int isi_camera_clock_start(struct soc_camera_host *ici)
 	if (ret)
 		return ret;
 
-	ret = clk_prepare_enable(isi->mck);
-	if (ret) {
-		clk_disable_unprepare(isi->pclk);
-		return ret;
+	if (!IS_ERR(isi->mck)) {
+		ret = clk_prepare_enable(isi->mck);
+		if (ret) {
+			clk_disable_unprepare(isi->pclk);
+			return ret;
+		}
 	}
 
 	return 0;
@@ -739,7 +741,8 @@ static void isi_camera_clock_stop(struct soc_camera_host *ici)
 {
 	struct atmel_isi *isi = ici->priv;
 
-	clk_disable_unprepare(isi->mck);
+	if (!IS_ERR(isi->mck))
+		clk_disable_unprepare(isi->mck);
 	clk_disable_unprepare(isi->pclk);
 }
 
@@ -883,7 +886,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	struct isi_platform_data *pdata;
 
 	pdata = dev->platform_data;
-	if (!pdata || !pdata->data_width_flags || !pdata->mck_hz) {
+	if (!pdata || !pdata->data_width_flags) {
 		dev_err(&pdev->dev,
 			"No config available for Atmel ISI\n");
 		return -EINVAL;
@@ -905,18 +908,21 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&isi->video_buffer_list);
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
-	/* Get ISI_MCK, provided by programmable clock or external clock */
+	/* ISI_MCK is the sensor master clock. It should be handled by the
+	 * sensor driver directly, as the ISI has no use for that clock. Make
+	 * the clock optional here while platforms transition to the correct
+	 * model.
+	 */
 	isi->mck = devm_clk_get(dev, "isi_mck");
-	if (IS_ERR(isi->mck)) {
-		dev_err(dev, "Failed to get isi_mck\n");
-		return PTR_ERR(isi->mck);
+	if (!IS_ERR(isi->mck)) {
+		/* Set ISI_MCK's frequency, it should be faster than pixel
+		 * clock.
+		 */
+		ret = clk_set_rate(isi->mck, pdata->mck_hz);
+		if (ret < 0)
+			return ret;
 	}
 
-	/* Set ISI_MCK's frequency, it should be faster than pixel clock */
-	ret = clk_set_rate(isi->mck, pdata->mck_hz);
-	if (ret < 0)
-		return ret;
-
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
 				sizeof(struct fbd) * MAX_BUFFER_NUM,
 				&isi->fb_descriptors_phys,
-- 
1.8.3.2

