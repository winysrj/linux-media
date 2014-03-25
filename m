Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp02.atmel.com ([204.2.163.16]:17942 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751697AbaCYKsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 06:48:23 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
	<laurent.pinchart@ideasonboard.com>, <josh.wu@atmel.com>
Subject: [PATCH v2 2/3] [media] atmel-isi: convert the pdata from pointer to structure
Date: Tue, 25 Mar 2014 18:41:27 +0800
Message-ID: <1395744087-5753-3-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1395744087-5753-1-git-send-email-josh.wu@atmel.com>
References: <1395744087-5753-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now the platform data is initialized by allocation of isi
structure. In the future, we use pdata to store the dt parameters.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
v1 --> v2:
 no change.

 drivers/media/platform/soc_camera/atmel-isi.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 9d977c5..f4add0a 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -84,7 +84,7 @@ struct atmel_isi {
 	struct clk			*mck;
 	unsigned int			irq;
 
-	struct isi_platform_data	*pdata;
+	struct isi_platform_data	pdata;
 	u16				width_flags;	/* max 12 bits */
 
 	struct list_head		video_buffer_list;
@@ -350,7 +350,7 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 
 	cfg1 &= ~ISI_CFG1_FRATE_DIV_MASK;
 	/* Enable linked list */
-	cfg1 |= isi->pdata->frate | ISI_CFG1_DISCR;
+	cfg1 |= isi->pdata.frate | ISI_CFG1_DISCR;
 
 	/* Enable codec path and ISI */
 	ctrl = ISI_CTRL_CDC | ISI_CTRL_EN;
@@ -797,7 +797,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 	/* Make choises, based on platform preferences */
 	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
 	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
-		if (isi->pdata->hsync_act_low)
+		if (isi->pdata.hsync_act_low)
 			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_HIGH;
 		else
 			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_LOW;
@@ -805,7 +805,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 
 	if ((common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH) &&
 	    (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)) {
-		if (isi->pdata->vsync_act_low)
+		if (isi->pdata.vsync_act_low)
 			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
 		else
 			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
@@ -813,7 +813,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 
 	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
 	    (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
-		if (isi->pdata->pclk_act_falling)
+		if (isi->pdata.pclk_act_falling)
 			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
 		else
 			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
@@ -835,9 +835,9 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
 
-	if (isi->pdata->has_emb_sync)
+	if (isi->pdata.has_emb_sync)
 		cfg1 |= ISI_CFG1_EMB_SYNC;
-	if (isi->pdata->full_mode)
+	if (isi->pdata.full_mode)
 		cfg1 |= ISI_CFG1_FULL_MODE;
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
@@ -912,7 +912,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	if (IS_ERR(isi->pclk))
 		return PTR_ERR(isi->pclk);
 
-	isi->pdata = pdata;
+	memcpy(&isi->pdata, pdata, sizeof(struct isi_platform_data));
 	isi->active = NULL;
 	spin_lock_init(&isi->lock);
 	INIT_LIST_HEAD(&isi->video_buffer_list);
@@ -928,7 +928,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		/* Set ISI_MCK's frequency, it should be faster than pixel
 		 * clock.
 		 */
-		ret = clk_set_rate(isi->mck, pdata->mck_hz);
+		ret = clk_set_rate(isi->mck, isi->pdata.mck_hz);
 		if (ret < 0)
 			return ret;
 	}
@@ -962,9 +962,9 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
-	if (pdata->data_width_flags & ISI_DATAWIDTH_8)
+	if (isi->pdata.data_width_flags & ISI_DATAWIDTH_8)
 		isi->width_flags = 1 << 7;
-	if (pdata->data_width_flags & ISI_DATAWIDTH_10)
+	if (isi->pdata.data_width_flags & ISI_DATAWIDTH_10)
 		isi->width_flags |= 1 << 9;
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
-- 
1.7.9.5

