Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33159 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbcARMWv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 07:22:51 -0500
Received: by mail-pa0-f65.google.com with SMTP id pv5so33584335pac.0
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 04:22:51 -0800 (PST)
From: Josh Wu <rainyfeeling@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>,
	Josh Wu <rainyfeeling@gmail.com>
Subject: [PATCH 04/13] atmel-isi: move the cfg1 initialize to isi_hw_initialize()
Date: Mon, 18 Jan 2016 20:21:40 +0800
Message-Id: <1453119709-20940-5-git-send-email-rainyfeeling@gmail.com>
In-Reply-To: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since cfg1 initialization just about the frame rate, and it hardware
related, just move it to isi_hw_initialize().

Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 0c3cb74..4bd8258 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -210,6 +210,10 @@ static void isi_hw_initialize(struct atmel_isi *isi)
 
 	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
 
+	cfg1 |= isi->pdata.frate & ISI_CFG1_FRATE_DIV_MASK;
+
+	cfg1 |= ISI_CFG1_DISCR;
+
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
 	isi_writel(isi, ISI_CFG1, cfg1);
 }
@@ -409,9 +413,8 @@ static void buffer_cleanup(struct vb2_buffer *vb)
 
 static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 {
-	u32 ctrl, cfg1;
+	u32 ctrl;
 
-	cfg1 = isi_readl(isi, ISI_CFG1);
 	/* Enable irq: cxfr for the codec path, pxfr for the preview path */
 	isi_writel(isi, ISI_INTEN,
 			ISI_SR_CXFR_DONE | ISI_SR_PXFR_DONE);
@@ -436,10 +439,6 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 		isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_P_CH);
 	}
 
-	cfg1 &= ~ISI_CFG1_FRATE_DIV_MASK;
-	/* Enable linked list */
-	cfg1 |= isi->pdata.frate | ISI_CFG1_DISCR;
-
 	/* Enable ISI */
 	ctrl = ISI_CTRL_EN;
 
@@ -447,7 +446,6 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 		ctrl |= ISI_CTRL_CDC;
 
 	isi_writel(isi, ISI_CTRL, ctrl);
-	isi_writel(isi, ISI_CFG1, cfg1);
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
-- 
1.9.1

