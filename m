Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33972 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdG0JFN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 05:05:13 -0400
Received: by mail-wr0-f193.google.com with SMTP id o33so16385094wrb.1
        for <linux-media@vger.kernel.org>; Thu, 27 Jul 2017 02:05:12 -0700 (PDT)
From: Tvrtko Ursulin <tursulin@ursulin.net>
To: Intel-gfx@lists.freedesktop.org
Cc: Ben Widawsky <benjamin.widawsky@intel.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] lib/scatterlist: Fix offset type in sg_alloc_table_from_pages
Date: Thu, 27 Jul 2017 10:05:01 +0100
Message-Id: <20170727090504.15812-2-tvrtko.ursulin@linux.intel.com>
In-Reply-To: <20170727090504.15812-1-tvrtko.ursulin@linux.intel.com>
References: <20170727090504.15812-1-tvrtko.ursulin@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Scatterlist entries have an unsigned int for the offset so
correct the sg_alloc_table_from_pages function accordingly.

Since these are offsets withing a page, unsigned int is
wide enough.

Also converts callers which were using unsigned long locally
with the lower_32_bits annotation to make it explicitly
clear what is happening.

v2: Use offset_in_page. (Chris Wilson)

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com> (v1)
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 4 ++--
 drivers/rapidio/devices/rio_mport_cdev.c       | 4 ++--
 include/linux/scatterlist.h                    | 2 +-
 lib/scatterlist.c                              | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 4f246d166111..2405077fdc71 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -479,7 +479,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 {
 	struct vb2_dc_buf *buf;
 	struct frame_vector *vec;
-	unsigned long offset;
+	unsigned int offset;
 	int n_pages, i;
 	int ret = 0;
 	struct sg_table *sgt;
@@ -507,7 +507,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 	buf->dev = dev;
 	buf->dma_dir = dma_dir;
 
-	offset = vaddr & ~PAGE_MASK;
+	offset = lower_32_bits(offset_in_page(vaddr));
 	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
 	if (IS_ERR(vec)) {
 		ret = PTR_ERR(vec);
diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 5beb0c361076..5c1b6388122a 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -876,10 +876,10 @@ rio_dma_transfer(struct file *filp, u32 transfer_mode,
 	 * offset within the internal buffer specified by handle parameter.
 	 */
 	if (xfer->loc_addr) {
-		unsigned long offset;
+		unsigned int offset;
 		long pinned;
 
-		offset = (unsigned long)(uintptr_t)xfer->loc_addr & ~PAGE_MASK;
+		offset = lower_32_bits(offset_in_page(xfer->loc_addr));
 		nr_pages = PAGE_ALIGN(xfer->length + offset) >> PAGE_SHIFT;
 
 		page_list = kmalloc_array(nr_pages,
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4b3286ac60c8..205aefb4ed93 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -263,7 +263,7 @@ int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int,
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
 int sg_alloc_table_from_pages(struct sg_table *sgt,
 	struct page **pages, unsigned int n_pages,
-	unsigned long offset, unsigned long size,
+	unsigned int offset, unsigned long size,
 	gfp_t gfp_mask);
 
 size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index be7b4dd6b68d..dee0c5004e2f 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -391,7 +391,7 @@ EXPORT_SYMBOL(sg_alloc_table);
  */
 int sg_alloc_table_from_pages(struct sg_table *sgt,
 	struct page **pages, unsigned int n_pages,
-	unsigned long offset, unsigned long size,
+	unsigned int offset, unsigned long size,
 	gfp_t gfp_mask)
 {
 	unsigned int chunks;
-- 
2.9.4
