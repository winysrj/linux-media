Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40847 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754000AbeCWL50 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 16/30] media: videobuf-dma-sg: Fix a weird cast
Date: Fri, 23 Mar 2018 07:57:02 -0400
Message-Id: <b1a5dea69e48c3306e47ac470e3ff9f2fc0bbe28.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just use %p. Fixes this warning:
	drivers/media/v4l2-core/videobuf-dma-sg.c:247 videobuf_dma_init_kernel() warn: argument 2 to %08lx specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index f412429cf5ba..add2edb23eac 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -244,9 +244,8 @@ static int videobuf_dma_init_kernel(struct videobuf_dmabuf *dma, int direction,
 		goto out_free_pages;
 	}
 
-	dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
-				(unsigned long)dma->vaddr,
-				nr_pages << PAGE_SHIFT);
+	dprintk(1, "vmalloc is at addr %p, size=%d\n",
+		dma->vaddr, nr_pages << PAGE_SHIFT);
 
 	memset(dma->vaddr, 0, nr_pages << PAGE_SHIFT);
 	dma->nr_pages = nr_pages;
-- 
2.14.3
