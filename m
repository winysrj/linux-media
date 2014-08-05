Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16975 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbaHEILk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 04:11:40 -0400
Date: Tue, 5 Aug 2014 11:11:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	James Harper <james.harper@ejbdigital.com.au>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] vmalloc_sg: off by one in error handling
Message-ID: <20140805081113.GB13605@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "i--" needs to happen at the start of the loop or it will try to
release something bogus (probably it will crash) and it won't release
the first ->vaddr_page[].

Fixes: 7b4eeed174b7 ('[media] vmalloc_sg: make sure all pages in vmalloc area are really DMA-ready')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 3c8cc02..3ff15f1 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -253,9 +253,11 @@ int videobuf_dma_init_kernel(struct videobuf_dmabuf *dma, int direction,
 	return 0;
 out_free_pages:
 	while (i > 0) {
-		void *addr = page_address(dma->vaddr_pages[i]);
-		dma_free_coherent(dma->dev, PAGE_SIZE, addr, dma->dma_addr[i]);
+		void *addr;
+
 		i--;
+		addr = page_address(dma->vaddr_pages[i]);
+		dma_free_coherent(dma->dev, PAGE_SIZE, addr, dma->dma_addr[i]);
 	}
 	kfree(dma->dma_addr);
 	dma->dma_addr = NULL;
