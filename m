Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33345 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZLAPaT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 10:30:19 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	mchehab@infradead.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] V4L - Fix videobuf_dma_contig_user_get() getting page aligned physical address
Date: Tue,  1 Dec 2009 10:30:14 -0500
Message-Id: <1259681414-30246-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

If a USERPTR address that is not aligned to page boundary is passed to the
videobuf_dma_contig_user_get() function, it saves a page aligned address to
the dma_handle. This is not correct. This issue is observed when using USERPTR
IO machism for buffer exchange.

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to V4L-DVB linux-next branch
 drivers/media/video/videobuf-dma-contig.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index d25f284..928dfa1 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -166,7 +166,8 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 			break;
 
 		if (pages_done == 0)
-			mem->dma_handle = this_pfn << PAGE_SHIFT;
+			mem->dma_handle = (this_pfn << PAGE_SHIFT) +
+						(vb->baddr & ~PAGE_MASK);
 		else if (this_pfn != (prev_pfn + 1))
 			ret = -EFAULT;
 
-- 
1.6.0.4

