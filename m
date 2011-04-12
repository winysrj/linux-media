Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:57684 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541Ab1DLVHk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 17:07:40 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2.6.39 v2] V4L: videobuf-dma-contig: fix mmap_mapper broken on ARM
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, Jiri Slaby <jslaby@suse.cz>
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Date: Tue, 12 Apr 2011 23:06:34 +0200
MIME-Version: 1.0
Message-Id: <201104122306.34909.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
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

The patch tries to solve this regression by using 
virt_to_phys(bus_to_virt(mem->dma_handle)) instead of problematic 
virt_to_phys(mem->vaddr). I think this should work even if those 
translations would occure inaccurate for DMA addresses, since possible 
errors introduced by both translations, performed in opposite 
directions, should compensate.

Tested on ARM OMAP1 based Amstrad Delta board.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
v1 -> v2 changes:
- drop dma_mmap_coherent() path, it may not work correctly for device 
  memory preallocated with dma_declare_coherent_memory().

 drivers/media/video/videobuf-dma-contig.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- git/drivers/media/video/videobuf-dma-contig.c.orig	2011-04-09 00:38:45.000000000 +0200
+++ git/drivers/media/video/videobuf-dma-contig.c	2011-04-12 22:36:44.000000000 +0200
@@ -300,8 +300,8 @@ static int __videobuf_mmap_mapper(struct
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	retval = remap_pfn_range(vma, vma->vm_start,
-				 PFN_DOWN(virt_to_phys(mem->vaddr)),
-				 size, vma->vm_page_prot);
+			PFN_DOWN(virt_to_phys(bus_to_virt(mem->dma_handle))),
+			size, vma->vm_page_prot);
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
 		dma_free_coherent(q->dev, mem->size,
