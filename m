Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32793 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbcARMWr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 07:22:47 -0500
Received: by mail-pf0-f194.google.com with SMTP id e65so11737702pfe.0
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 04:22:46 -0800 (PST)
From: Josh Wu <rainyfeeling@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>,
	Josh Wu <rainyfeeling@gmail.com>
Subject: [PATCH 03/13] atmel-isi: add isi_hw_initialize() function to handle hw setup
Date: Mon, 18 Jan 2016 20:21:39 +0800
Message-Id: <1453119709-20940-4-git-send-email-rainyfeeling@gmail.com>
In-Reply-To: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the hardware operation to one isi_hw_initialize(). Then we will
call it in start_streaming().

Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 51 +++++++++++++++------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 3793b68..0c3cb74 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -88,6 +88,7 @@ struct atmel_isi {
 
 	struct isi_platform_data	pdata;
 	u16				width_flags;	/* max 12 bits */
+	u32				bus_param;
 
 	struct list_head		video_buffer_list;
 	struct frame_buffer		*active;
@@ -189,6 +190,30 @@ static void configure_geometry(struct atmel_isi *isi, u32 width,
 	return;
 }
 
+static void isi_hw_initialize(struct atmel_isi *isi)
+{
+	u32 common_flags = isi->bus_param;
+	u32 cfg1 = 0;
+
+	/* set bus param for ISI */
+	if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+		cfg1 |= ISI_CFG1_HSYNC_POL_ACTIVE_LOW;
+	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+		cfg1 |= ISI_CFG1_VSYNC_POL_ACTIVE_LOW;
+	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
+
+	if (isi->pdata.has_emb_sync)
+		cfg1 |= ISI_CFG1_EMB_SYNC;
+	if (isi->pdata.full_mode)
+		cfg1 |= ISI_CFG1_FULL_MODE;
+
+	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
+
+	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
+	isi_writel(isi, ISI_CFG1, cfg1);
+}
+
 static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 {
 	if (isi->active) {
@@ -464,6 +489,8 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* Disable all interrupts */
 	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
 
+	isi_hw_initialize(isi);
+
 	configure_geometry(isi, icd->user_width, icd->user_height,
 				icd->current_fmt);
 
@@ -835,7 +862,6 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
 	unsigned long common_flags;
 	int ret;
-	u32 cfg1 = 0;
 
 	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
 	if (!ret) {
@@ -888,33 +914,12 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 		return ret;
 	}
 
-	/* set bus param for ISI */
-	if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
-		cfg1 |= ISI_CFG1_HSYNC_POL_ACTIVE_LOW;
-	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
-		cfg1 |= ISI_CFG1_VSYNC_POL_ACTIVE_LOW;
-	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
-		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
-
 	dev_dbg(icd->parent, "vsync active %s, hsync active %s, sampling on pix clock %s edge\n",
 		common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? "low" : "high",
 		common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? "low" : "high",
 		common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING ? "falling" : "rising");
 
-	if (isi->pdata.has_emb_sync)
-		cfg1 |= ISI_CFG1_EMB_SYNC;
-	if (isi->pdata.full_mode)
-		cfg1 |= ISI_CFG1_FULL_MODE;
-
-	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
-
-	/* Enable PM and peripheral clock before operate isi registers */
-	pm_runtime_get_sync(ici->v4l2_dev.dev);
-
-	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
-	isi_writel(isi, ISI_CFG1, cfg1);
-
-	pm_runtime_put(ici->v4l2_dev.dev);
+	isi->bus_param = common_flags;
 
 	return 0;
 }
-- 
1.9.1

