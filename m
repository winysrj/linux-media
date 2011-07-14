Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36824 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1GNVKq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 17:10:46 -0400
Date: Thu, 14 Jul 2011 15:10:44 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] videobuf2: Do not unconditionally map S/G buffers into
 kernel space
Message-ID: <20110714151044.44cb89ee@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The one in-tree videobuf2-dma-sg driver (mmp-camera) has no need for a
kernel-space mapping of the buffers; one suspects that most other drivers
would not either.  The videobuf2-dma-sg module does the right thing if
buf->vaddr == NULL - it maps the buffer on demand if somebody needs it.  So
let's not map the buffer at allocation time; that will save a little CPU
time and a lot of address space in the vmalloc range.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/videobuf2-dma-sg.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-sg.c b/drivers/media/video/videobuf2-dma-sg.c
index b2d9485..0e8edc1 100644
--- a/drivers/media/video/videobuf2-dma-sg.c
+++ b/drivers/media/video/videobuf2-dma-sg.c
@@ -77,12 +77,6 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
 
 	printk(KERN_DEBUG "%s: Allocated buffer of %d pages\n",
 		__func__, buf->sg_desc.num_pages);
-
-	if (!buf->vaddr)
-		buf->vaddr = vm_map_ram(buf->pages,
-					buf->sg_desc.num_pages,
-					-1,
-					PAGE_KERNEL);
 	return buf;
 
 fail_pages_alloc:
-- 
1.7.6

