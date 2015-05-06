Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:43372 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751052AbbEFKXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 06:23:54 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v3 3/3] media: atmel-isi: remove mck back compatiable code as it's not need
Date: Wed, 6 May 2015 18:25:55 +0800
Message-ID: <1430907955-28665-4-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1430907955-28665-1-git-send-email-josh.wu@atmel.com>
References: <1430907955-28665-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The master clock should handled by sensor itself.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---

Changes in v3:
- remove useless definition: ISI_DEFAULT_MCLK_FREQ

Changes in v2:
- totally remove clock_start()/clock_stop() as they are optional.

 drivers/media/platform/soc_camera/atmel-isi.c | 46 ---------------------------
 1 file changed, 46 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 2b05f89..d4989d1 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -35,7 +35,6 @@
 #define VID_LIMIT_BYTES			(16 * 1024 * 1024)
 #define MIN_FRAME_RATE			15
 #define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
-#define ISI_DEFAULT_MCLK_FREQ		25000000
 
 /* Frame buffer descriptor */
 struct fbd {
@@ -83,8 +82,6 @@ struct atmel_isi {
 	struct completion		complete;
 	/* ISI peripherial clock */
 	struct clk			*pclk;
-	/* ISI_MCK, feed to camera sensor to generate pixel clock */
-	struct clk			*mck;
 	unsigned int			irq;
 
 	struct isi_platform_data	pdata;
@@ -727,31 +724,6 @@ static void isi_camera_remove_device(struct soc_camera_device *icd)
 		 icd->devnum);
 }
 
-/* Called with .host_lock held */
-static int isi_camera_clock_start(struct soc_camera_host *ici)
-{
-	struct atmel_isi *isi = ici->priv;
-	int ret;
-
-	if (!IS_ERR(isi->mck)) {
-		ret = clk_prepare_enable(isi->mck);
-		if (ret) {
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
-/* Called with .host_lock held */
-static void isi_camera_clock_stop(struct soc_camera_host *ici)
-{
-	struct atmel_isi *isi = ici->priv;
-
-	if (!IS_ERR(isi->mck))
-		clk_disable_unprepare(isi->mck);
-}
-
 static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
@@ -865,8 +837,6 @@ static struct soc_camera_host_ops isi_soc_camera_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= isi_camera_add_device,
 	.remove		= isi_camera_remove_device,
-	.clock_start	= isi_camera_clock_start,
-	.clock_stop	= isi_camera_clock_stop,
 	.set_fmt	= isi_camera_set_fmt,
 	.try_fmt	= isi_camera_try_fmt,
 	.get_formats	= isi_camera_get_formats,
@@ -904,7 +874,6 @@ static int atmel_isi_probe_dt(struct atmel_isi *isi,
 
 	/* Default settings for ISI */
 	isi->pdata.full_mode = 1;
-	isi->pdata.mck_hz = ISI_DEFAULT_MCLK_FREQ;
 	isi->pdata.frate = ISI_CFG1_FRATE_CAPTURE_ALL;
 
 	np = of_graph_get_next_endpoint(np, NULL);
@@ -980,21 +949,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&isi->video_buffer_list);
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
-	/* ISI_MCK is the sensor master clock. It should be handled by the
-	 * sensor driver directly, as the ISI has no use for that clock. Make
-	 * the clock optional here while platforms transition to the correct
-	 * model.
-	 */
-	isi->mck = devm_clk_get(dev, "isi_mck");
-	if (!IS_ERR(isi->mck)) {
-		/* Set ISI_MCK's frequency, it should be faster than pixel
-		 * clock.
-		 */
-		ret = clk_set_rate(isi->mck, isi->pdata.mck_hz);
-		if (ret < 0)
-			return ret;
-	}
-
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
 				sizeof(struct fbd) * MAX_BUFFER_NUM,
 				&isi->fb_descriptors_phys,
-- 
1.9.1

