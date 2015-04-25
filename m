Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46806 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933508AbbDYPnb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/12] dt3155v4l: remove pointless dt3155_alloc/free_coherent
Date: Sat, 25 Apr 2015 17:42:43 +0200
Message-Id: <1429976571-34872-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

No idea what the purpose is of these functions. I suspect this was used
once upon a time to pre-allocate buffer memory. But the allocated memory
isn't used anywhere anymore, so just remove this code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 71 -----------------------------
 1 file changed, 71 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 564483a..34836f6 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -29,11 +29,6 @@
 
 #define DT3155_DEVICE_ID 0x1223
 
-/* DT3155_CHUNK_SIZE is 4M (2^22) 8 full size buffers */
-#define DT3155_CHUNK_SIZE (1U << 22)
-
-#define DT3155_COH_FLAGS (GFP_KERNEL | GFP_DMA32 | __GFP_COLD | __GFP_NOWARN)
-
 #define DT3155_BUF_SIZE (768 * 576)
 
 #ifdef CONFIG_DT3155_STREAMING
@@ -754,68 +749,6 @@ static struct video_device dt3155_vdev = {
 	.tvnorms = DT3155_CURRENT_NORM,
 };
 
-/* same as in drivers/base/dma-coherent.c */
-struct dma_coherent_mem {
-	void		*virt_base;
-	dma_addr_t	device_base;
-	int		size;
-	int		flags;
-	unsigned long	*bitmap;
-};
-
-static int dt3155_alloc_coherent(struct device *dev, size_t size, int flags)
-{
-	struct dma_coherent_mem *mem;
-	dma_addr_t dev_base;
-	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
-
-	if ((flags & DMA_MEMORY_MAP) == 0)
-		goto out;
-	if (!size)
-		goto out;
-	if (dev->dma_mem)
-		goto out;
-
-	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
-	if (!mem)
-		goto out;
-	mem->virt_base = dma_alloc_coherent(dev, size, &dev_base,
-							DT3155_COH_FLAGS);
-	if (!mem->virt_base)
-		goto err_alloc_coherent;
-	mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!mem->bitmap)
-		goto err_bitmap;
-
-	/* coherent_dma_mask is already set to 32 bits */
-	mem->device_base = dev_base;
-	mem->size = pages;
-	mem->flags = flags;
-	dev->dma_mem = mem;
-	return DMA_MEMORY_MAP;
-
-err_bitmap:
-	dma_free_coherent(dev, size, mem->virt_base, dev_base);
-err_alloc_coherent:
-	kfree(mem);
-out:
-	return 0;
-}
-
-static void dt3155_free_coherent(struct device *dev)
-{
-	struct dma_coherent_mem *mem = dev->dma_mem;
-
-	if (!mem)
-		return;
-	dev->dma_mem = NULL;
-	dma_free_coherent(dev, mem->size << PAGE_SHIFT,
-					mem->virt_base, mem->device_base);
-	kfree(mem->bitmap);
-	kfree(mem);
-}
-
 static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int err;
@@ -863,9 +796,6 @@ static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = video_register_device(&pd->vdev, VFL_TYPE_GRABBER, -1);
 	if (err)
 		goto err_free_irq;
-	if (dt3155_alloc_coherent(&pdev->dev, DT3155_CHUNK_SIZE,
-							DMA_MEMORY_MAP))
-		dev_info(&pdev->dev, "preallocated 8 buffers\n");
 	dev_info(&pdev->dev, "/dev/video%i is ready\n", pd->vdev.minor);
 	return 0;  /*   success   */
 
@@ -887,7 +817,6 @@ static void dt3155_remove(struct pci_dev *pdev)
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
 	struct dt3155_priv *pd = container_of(v4l2_dev, struct dt3155_priv, v4l2_dev);
 
-	dt3155_free_coherent(&pdev->dev);
 	video_unregister_device(&pd->vdev);
 	free_irq(pd->pdev->irq, pd);
 	v4l2_device_unregister(&pd->v4l2_dev);
-- 
2.1.4

