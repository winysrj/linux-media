Return-path: <linux-media-owner@vger.kernel.org>
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:15308
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419Ab3CEKig (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Mar 2013 05:38:36 -0500
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	<linux-media@vger.kernel.org>
CC: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH] [media] dma-mapping: enable no mmu support in dma_common_mmap
Date: Tue, 5 Mar 2013 18:40:11 -0500
Message-ID: <1362526811-15768-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No MMU systems also make use of this function to do mmap.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/base/dma-mapping.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index 0ce39a3..ae655b2 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -245,7 +245,6 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 		    void *cpu_addr, dma_addr_t dma_addr, size_t size)
 {
 	int ret = -ENXIO;
-#ifdef CONFIG_MMU
 	unsigned long user_count = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	unsigned long pfn = page_to_pfn(virt_to_page(cpu_addr));
@@ -262,7 +261,6 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 				      user_count << PAGE_SHIFT,
 				      vma->vm_page_prot);
 	}
-#endif	/* CONFIG_MMU */
 
 	return ret;
 }
-- 
1.7.0.4


