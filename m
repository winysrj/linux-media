Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:52180 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757750Ab1DJWtw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2011 18:49:52 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2.6.39] V4L: videobuf-dma-contig: fix mmap_mapper broken on ARM
Date: Mon, 11 Apr 2011 00:47:59 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104110048.08764.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

After switching from mem->dma_handle to virt_to_phys(mem->vaddr) used 
for obtaining page frame number passed to remap_pfn_range()
(commit 35d9f510b67b10338161aba6229d4f55b4000f5b), videobuf-dma-contig 
stopped working on my ARM based board. The ARM architecture maintainer, 
Russell King, confirmed that using something like 
virt_to_phys(dma_alloc_coherent()) is not supported on ARM, and can be 
broken on other architectures as well. The author of the change, Jiri 
Slaby, also confirmed that his code may not work on all architectures.

The patch takes two different countermeasures against this regression:

1. On architectures which provide dma_mmap_coherent() function (ARM for 
   now), use it instead of just remap_pfn_range(). The code is stollen 
   from sound/core/pcm_native.c:snd_pcm_default_mmap().
   Set vma->vm_pgoff to 0 before calling dma_mmap_coherent(), or it 
   fails.

2. On other architectures, use virt_to_phys(bus_to_virt(mem->dma_handle)) 
   instead of problematic virt_to_phys(mem->vaddr). This should work 
   even if those translations would occure inaccurate for DMA addresses, 
   since possible errors introduced by both calculations, performed in 
   opposite directions, should compensate.

Both solutions tested on ARM OMAP1 based Amstrad Delta board.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 drivers/media/video/videobuf-dma-contig.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- linux-2.6.39-rc2/drivers/media/video/videobuf-dma-contig.c.orig	2011-04-09 00:38:45.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/videobuf-dma-contig.c	2011-04-10 15:00:23.000000000 +0200
@@ -295,13 +295,26 @@ static int __videobuf_mmap_mapper(struct
 
 	/* Try to remap memory */
 
+#ifndef ARCH_HAS_DMA_MMAP_COHERENT
+/* This should be defined / handled globally! */
+#ifdef CONFIG_ARM
+#define ARCH_HAS_DMA_MMAP_COHERENT
+#endif
+#endif
+
+#ifdef ARCH_HAS_DMA_MMAP_COHERENT
+	vma->vm_pgoff = 0;
+	retval = dma_mmap_coherent(q->dev, vma, mem->vaddr, mem->dma_handle,
+			mem->size);
+#else
 	size = vma->vm_end - vma->vm_start;
 	size = (size < mem->size) ? size : mem->size;
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	retval = remap_pfn_range(vma, vma->vm_start,
-				 PFN_DOWN(virt_to_phys(mem->vaddr)),
-				 size, vma->vm_page_prot);
+			PFN_DOWN(virt_to_phys(bus_to_virt(mem->dma_handle))),
+			size, vma->vm_page_prot);
+#endif
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
 		dma_free_coherent(q->dev, mem->size,
