Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:23431 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaGYKOr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 06:14:47 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<laurent.pinchart@ideasonboard.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v3 2/3] media: atmel-isi: convert the pdata from pointer to structure
Date: Fri, 25 Jul 2014 18:13:39 +0800
Message-ID: <1406283219-32015-3-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1406283219-32015-1-git-send-email-josh.wu@atmel.com>
References: <1406283219-32015-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now the platform data is initialized by allocation of isi
structure. In the future, we use pdata to store the dt parameters.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
v2 -> v3:
  use sizeof(isi->pdata) instead of using sizeof(struct).

 drivers/media/platform/soc_camera/atmel-isi.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 802c203..74af560 100644
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
@@ -795,7 +795,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 	/* Make choises, based on platform preferences */
 	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
 	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
-		if (isi->pdata->hsync_act_low)
+		if (isi->pdata.hsync_act_low)
 			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_HIGH;
 		else
 			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_LOW;
@@ -803,7 +803,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 
 	if ((common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH) &&
 	    (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)) {
-		if (isi->pdata->vsync_act_low)
+		if (isi->pdata.vsync_act_low)
 			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
 		else
 			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
@@ -811,7 +811,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 
 	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
 	    (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
-		if (isi->pdata->pclk_act_falling)
+		if (isi->pdata.pclk_act_falling)
 			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
 		else
 			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
@@ -833,9 +833,9 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
 
-	if (isi->pdata->has_emb_sync)
+	if (isi->pdata.has_emb_sync)
 		cfg1 |= ISI_CFG1_EMB_SYNC;
-	if (isi->pdata->full_mode)
+	if (isi->pdata.full_mode)
 		cfg1 |= ISI_CFG1_FULL_MODE;
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
@@ -910,7 +910,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	if (IS_ERR(isi->pclk))
 		return PTR_ERR(isi->pclk);
 
-	isi->pdata = pdata;
+	memcpy(&isi->pdata, pdata, sizeof(isi->pdata));
 	isi->active = NULL;
 	spin_lock_init(&isi->lock);
 	INIT_LIST_HEAD(&isi->video_buffer_list);
@@ -926,7 +926,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		/* Set ISI_MCK's frequency, it should be faster than pixel
 		 * clock.
 		 */
-		ret = clk_set_rate(isi->mck, pdata->mck_hz);
+		ret = clk_set_rate(isi->mck, isi->pdata.mck_hz);
 		if (ret < 0)
 			return ret;
 	}
@@ -960,9 +960,9 @@ static int atmel_isi_probe(struct platform_device *pdev)
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
1.9.1

