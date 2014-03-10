Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45534 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaCJNZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 09:25:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [RFC] videobuf2-dma-contig broken for IOMMU + USERPTR buffers without struct page mapping
Date: Mon, 10 Mar 2014 14:27:13 +0100
Message-ID: <8402247.KhzdAKyPLE@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On some platforms (namely ARM) IOMMUs are handled transparently by the DMA 
mapping implementation. This requires mapping and unmapping all USERPTR 
buffers for DMA, regardless of whether they're backed by struct page or not. 
videobuf2-dma-contig is broken in that regard, as it call dma_map_sg() and 
dma_unmap_sg() only for buffers backed with struct page.

The page-less USERPTR dma-contig support was mostly intended (if I'm not 
mistaken) to support "exporters" (in the dmabuf sense, but through mmap() on 
the exporter side and USERPTR on the V4L2 side) that required large physically 
contiguous buffers. Allocating such buffers required reserving memory at boot 
time and resulted in no struct page mappings for that memory.

Now that CMA is available I believe that most (if not all) drivers have been 
converted to CMA using the dma_alloc_* API. My original test case for page-
less USERPTR buffers with the OMAP3 ISP, capturing to mmap()ed fbdev memory, 
now has the memory backed by struct page.

I wonder whether we should drop support for this broken feature altogether, or 
fix it. A fix won't be easy, given that dma_map_sg() assumes that the memory 
is backed by struct page at least on some platforms. On ARM, for instance, it 
calls page_to_phys(sg_page()) on sglist entries.

Does anyone still have a test case for this features ?

-- 
Regards,

Laurent Pinchart

