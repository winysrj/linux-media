Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35356 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbcARMxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 07:53:38 -0500
Received: by mail-pa0-f68.google.com with SMTP id gi1so39946642pac.2
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 04:53:38 -0800 (PST)
From: Josh Wu <rainyfeeling@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>,
	Josh Wu <rainyfeeling@gmail.com>
Subject: [PATCH 09/13] atmel-isi: add a function start_isi()
Date: Mon, 18 Jan 2016 20:52:20 +0800
Message-Id: <1453121545-27528-4-git-send-email-rainyfeeling@gmail.com>
In-Reply-To: <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since start_dma() has code which is to start isi, so move such code into
a new function: start_isi().

Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 32 +++++++++++++++------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index e1ad18f..0e42171 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -245,6 +245,20 @@ static int isi_hw_initialize(struct atmel_isi *isi)
 	return 0;
 }
 
+static void start_isi(struct atmel_isi *isi)
+{
+	u32 ctrl;
+
+	/* cxfr for the codec path, pxfr for the preview path */
+	isi_writel(isi, ISI_INTEN,
+		   ISI_SR_CXFR_DONE | ISI_SR_PXFR_DONE);
+
+	/* Enable ISI */
+	ctrl = ISI_CTRL_EN |
+	       (isi->enable_preview_path ? 0 : ISI_CTRL_CDC);
+	isi_writel(isi, ISI_CTRL, ctrl);
+}
+
 static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 {
 	if (isi->active) {
@@ -403,12 +417,6 @@ static void buffer_cleanup(struct vb2_buffer *vb)
 
 static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 {
-	u32 ctrl;
-
-	/* Enable irq: cxfr for the codec path, pxfr for the preview path */
-	isi_writel(isi, ISI_INTEN,
-			ISI_SR_CXFR_DONE | ISI_SR_PXFR_DONE);
-
 	/* Check if already in a frame */
 	if (!isi->enable_preview_path) {
 		if (isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) {
@@ -429,13 +437,6 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 		isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_P_CH);
 	}
 
-	/* Enable ISI */
-	ctrl = ISI_CTRL_EN;
-
-	if (!isi->enable_preview_path)
-		ctrl |= ISI_CTRL_CDC;
-
-	isi_writel(isi, ISI_CTRL, ctrl);
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
@@ -478,8 +479,11 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	spin_lock_irq(&isi->lock);
 
-	if (count)
+	if (count) {
 		start_dma(isi, isi->active);
+		start_isi(isi);
+	}
+
 	spin_unlock_irq(&isi->lock);
 
 	return 0;
-- 
1.9.1

