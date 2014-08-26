Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbaHZVzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 09/35] [media] atmel-isi: tag dma_addr_t as such
Date: Tue, 26 Aug 2014 18:54:45 -0300
Message-Id: <1409090111-8290-10-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using u32 for DMA address, use the proper
Kernel type for it.

   drivers/media/platform/soc_camera/atmel-isi.c: In function 'atmel_isi_probe':
>> drivers/media/platform/soc_camera/atmel-isi.c:981:26: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type
     isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
                             ^

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 3408b045b3f1..f87012b15b28 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -54,7 +54,7 @@ static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl)
 struct isi_dma_desc {
 	struct list_head list;
 	struct fbd *p_fbd;
-	u32 fbd_phys;
+	dma_addr_t fbd_phys;
 };
 
 /* Frame buffer data */
@@ -75,7 +75,7 @@ struct atmel_isi {
 
 	/* Allocate descriptors for dma buffer use */
 	struct fbd			*p_fb_descriptors;
-	u32				fb_descriptors_phys;
+	dma_addr_t			fb_descriptors_phys;
 	struct				list_head dma_desc_head;
 	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
 
@@ -169,7 +169,7 @@ static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 		isi->active = list_entry(isi->video_buffer_list.next,
 					struct frame_buffer, list);
 		isi_writel(isi, ISI_DMA_C_DSCR,
-			isi->active->p_dma_desc->fbd_phys);
+			(u32)isi->active->p_dma_desc->fbd_phys);
 		isi_writel(isi, ISI_DMA_C_CTRL,
 			ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
 		isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
@@ -346,7 +346,7 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 		return;
 	}
 
-	isi_writel(isi, ISI_DMA_C_DSCR, buffer->p_dma_desc->fbd_phys);
+	isi_writel(isi, ISI_DMA_C_DSCR, (u32)buffer->p_dma_desc->fbd_phys);
 	isi_writel(isi, ISI_DMA_C_CTRL, ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
 	isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
 
-- 
1.9.3

