Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39607 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbcGAJ5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 05:57:04 -0400
Subject: [PATCHv5 05/13] media/pci: convert drivers to use the new vb2_queue
 dev field
To: linux-media@vger.kernel.org
References: <1467034324-37626-1-git-send-email-hverkuil@xs4all.nl>
 <1467034324-37626-6-git-send-email-hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <eb8277fd-c462-3eff-8ada-5319f3b5057b@xs4all.nl>
Date: Fri, 1 Jul 2016 11:55:00 +0200
MIME-Version: 1.0
In-Reply-To: <1467034324-37626-6-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 62ddd1aabe5672541055bc6de3c80ca1e3635729 Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 15 Feb 2016 15:37:15 +0100
Subject: [PATCH 05/13] media/pci: convert drivers to use the new vb2_queue dev
 field

Stop using alloc_ctx and just fill in the device pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Federico Vaga <federico.vaga@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
After rebasing the vb2: replace allocation context by device pointer patch series I discovered
that newly committed changes to tw686x required that driver to be updated as well.
This is the patch for that.
---
diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 0e839f6..d380a8d 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -177,24 +177,7 @@ static void tw686x_contig_buf_refill(struct tw686x_video_channel *vc,
 	vc->curr_bufs[pb] = NULL;
 }

-static void tw686x_contig_cleanup(struct tw686x_dev *dev)
-{
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
-}
-
-static int tw686x_contig_setup(struct tw686x_dev *dev)
-{
-	dev->alloc_ctx = vb2_dma_contig_init_ctx(&dev->pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		dev_err(&dev->pci_dev->dev, "unable to init DMA context\n");
-		return PTR_ERR(dev->alloc_ctx);
-	}
-	return 0;
-}
-
 const struct tw686x_dma_ops contig_dma_ops = {
-	.setup		= tw686x_contig_setup,
-	.cleanup	= tw686x_contig_cleanup,
 	.buf_refill	= tw686x_contig_buf_refill,
 	.mem_ops	= &vb2_dma_contig_memops,
 	.hw_dma_mode	= TW686X_FRAME_MODE,
@@ -316,21 +299,10 @@ static int tw686x_sg_dma_alloc(struct tw686x_video_channel *vc,
 	return 0;
 }

-static void tw686x_sg_cleanup(struct tw686x_dev *dev)
-{
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
-}
-
 static int tw686x_sg_setup(struct tw686x_dev *dev)
 {
 	unsigned int sg_table_size, pb, ch, channels;

-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&dev->pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		dev_err(&dev->pci_dev->dev, "unable to init DMA context\n");
-		return PTR_ERR(dev->alloc_ctx);
-	}
-
 	if (is_second_gen(dev)) {
 		/*
 		 * TW6865/TW6869: each channel needs a pair of
@@ -360,7 +332,6 @@ static int tw686x_sg_setup(struct tw686x_dev *dev)

 const struct tw686x_dma_ops sg_dma_ops = {
 	.setup		= tw686x_sg_setup,
-	.cleanup	= tw686x_sg_cleanup,
 	.alloc		= tw686x_sg_dma_alloc,
 	.free		= tw686x_sg_dma_free,
 	.buf_refill	= tw686x_sg_buf_refill,
@@ -449,7 +420,6 @@ static int tw686x_queue_setup(struct vb2_queue *vq,
 		return 0;
 	}

-	alloc_ctxs[0] = vc->dev->alloc_ctx;
 	sizes[0] = szimage;
 	*nplanes = 1;
 	return 0;
@@ -1063,9 +1033,6 @@ void tw686x_video_free(struct tw686x_dev *dev)
 			for (pb = 0; pb < 2; pb++)
 				dev->dma_ops->free(vc, pb);
 	}
-
-	if (dev->dma_ops->cleanup)
-		dev->dma_ops->cleanup(dev);
 }

 int tw686x_video_init(struct tw686x_dev *dev)
@@ -1135,6 +1102,7 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		vc->vidq.min_buffers_needed = 2;
 		vc->vidq.lock = &vc->vb_mutex;
 		vc->vidq.gfp_flags = GFP_DMA32;
+		vc->vidq.dev = &dev->pci_dev->dev;

 		err = vb2_queue_init(&vc->vidq);
 		if (err) {
diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
index 35d7bc9..f24a2a9 100644
--- a/drivers/media/pci/tw686x/tw686x.h
+++ b/drivers/media/pci/tw686x/tw686x.h
@@ -106,7 +106,6 @@ struct tw686x_video_channel {

 struct tw686x_dma_ops {
 	int (*setup)(struct tw686x_dev *dev);
-	void (*cleanup)(struct tw686x_dev *dev);
 	int (*alloc)(struct tw686x_video_channel *vc, unsigned int pb);
 	void (*free)(struct tw686x_video_channel *vc, unsigned int pb);
 	void (*buf_refill)(struct tw686x_video_channel *vc, unsigned int pb);
@@ -132,8 +131,6 @@ struct tw686x_dev {
 	struct pci_dev *pci_dev;
 	__u32 __iomem *mmio;

-	void *alloc_ctx;
-
 	const struct tw686x_dma_ops *dma_ops;
 	struct tw686x_video_channel *video_channels;
 	struct tw686x_audio_channel *audio_channels;
