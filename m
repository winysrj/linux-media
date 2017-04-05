Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40722
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932540AbdDEQCw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 12:02:52 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: linux@armlinux.org.uk, gregkh@linuxfoundation.org,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>, will.deacon@arm.com,
        Robin.Murphy@arm.com, jroedel@suse.de, bart.vanassche@sandisk.com,
        gregory.clement@free-electrons.com, acourbot@nvidia.com,
        festevam@gmail.com, krzk@kernel.org,
        niklas.soderlund+renesas@ragnatech.se, sricharan@codeaurora.org,
        dledford@redhat.com, vinod.koul@intel.com,
        andrew.smirnov@gmail.com, mauricfo@linux.vnet.ibm.com,
        alexander.h.duyck@intel.com, sagi@grimberg.me,
        ming.l@ssi.samsung.com, martin.petersen@oracle.com,
        javier@dowhile0.org, javier@osg.samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH] arm: dma: fix sharing of coherent DMA memory without struct page
Date: Wed,  5 Apr 2017 10:02:42 -0600
Message-Id: <20170405160242.14195-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When coherent DMA memory without struct page is shared, importer
fails to find the page and runs into kernel page fault when it
tries to dmabuf_ops_attach/map_sg/map_page the invalid page found
in the sg_table. Please see www.spinics.net/lists/stable/msg164204.html
for more information on this problem.

This solution allows coherent DMA memory without struct page to be
shared by providing a way for the exporter to tag the DMA buffer as
a special buffer without struct page association and passing the
information in sg_table to the importer. This information is used
in attach/map_sg to avoid cleaning D-cache and mapping.

The details of the change are:

Framework:
- Add a new dma_attrs field to struct scatterlist.
- Add a new DMA_ATTR_DEV_COHERENT_NOPAGE attribute to clearly identify
  Coherent memory without struct page.
- Add a new dma_check_dev_coherent() interface to check if memory is
  the device coherent area. There is no way to tell where the memory
  returned by dma_alloc_attrs() came from.

Exporter logic:
- Add logic to vb2_dc_alloc() to call dma_check_dev_coherent() and set
  DMA_ATTR_DEV_COHERENT_NOPAGE based the results of the check. This is
  done in the exporter context.
- Add logic to arm_dma_get_sgtable() to identify memory without struct
  page using DMA_ATTR_DEV_COHERENT_NOPAGE attribute. If this attr is
  set, arm_dma_get_sgtable() will set page as the cpu_addr and update
  dma_address and dma_attrs fields in struct scatterlist for this sgl.
  This is done in exporter context when buffer is exported. With this
  Note: This change is made on top of Russell King's patch that added
  !pfn_valid(pfn) check to arm_dma_get_sgtable() to error out on invalid
  pages. Coherent memory without struct page will trigger this error.

Importer logic:
- Add logic to vb2_dc_dmabuf_ops_attach() to identify memory without
  struct page using DMA_ATTR_DEV_COHERENT_NOPAGE attribute when it copies
  the sg_table from the exporter. It will copy dma_attrs and dma_address
  fields. With this logic, dmabuf_ops_attach will no longer trip on an
  invalid page.
- Add logic to arm_dma_map_sg() to avoid mapping the page when sg_table
  has DMA_ATTR_DEV_COHERENT_NOPAGE buffer.
- Add logic to arm_dma_unmap_sg() to do nothing for sg entries with
  DMA_ATTR_DEV_COHERENT_NOPAGE attribute.

Without this change the following use-case that runs into kernel
pagefault when importer tries to attach the exported buffer.

With this change it works: (what a relief after watching pagefaults for
weeks!!)

gst-launch-1.0 filesrc location=~/GH3_MOV_HD.mp4 ! qtdemux ! h264parse ! v4l2video4dec capture-io-mode=dmabuf ! v4l2video7convert output-io-mode=dmabuf-import ! kmssink force-modesetting=true

I am sending RFC patch to get feedback on the approach and see if I missed
anything.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 arch/arm/mm/dma-mapping.c                      | 34 ++++++++++++++++++++++----
 drivers/base/dma-coherent.c                    | 25 +++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-dma-contig.c |  6 +++++
 include/linux/dma-mapping.h                    |  8 ++++++
 include/linux/scatterlist.h                    |  1 +
 5 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 63eabb0..75c6692 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -939,13 +939,28 @@ int arm_dma_get_sgtable(struct device *dev, struct sg_table *sgt,
 		 void *cpu_addr, dma_addr_t handle, size_t size,
 		 unsigned long attrs)
 {
-	struct page *page = pfn_to_page(dma_to_pfn(dev, handle));
+	unsigned long pfn = dma_to_pfn(dev, handle);
+	struct page *page;
 	int ret;
 
+	/* If the PFN is not valid, we do not have a struct page. */
+	if (!pfn_valid(pfn)) {
+		/* If memory is from per-device coherent area, use cpu_addr */
+		if (attrs & DMA_ATTR_DEV_COHERENT_NOPAGE)
+			page = cpu_addr;
+		else
+			return -ENXIO;
+	} else
+		page = pfn_to_page(pfn);
+
 	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
 	if (unlikely(ret))
 		return ret;
 
+	if (attrs & DMA_ATTR_DEV_COHERENT_NOPAGE)
+		sgt->sgl->dma_address = handle;
+
+	sgt->sgl->dma_attrs = attrs;
 	sg_set_page(sgt->sgl, page, PAGE_ALIGN(size), 0);
 	return 0;
 }
@@ -1080,10 +1095,17 @@ int arm_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
 		s->dma_length = s->length;
 #endif
-		s->dma_address = ops->map_page(dev, sg_page(s), s->offset,
+		/*
+		 * there is no struct page for this DMA buffer.
+		 * s->dma_address is the handle
+		 */
+		if (!(s->dma_attrs & DMA_ATTR_DEV_COHERENT_NOPAGE)) {
+			s->dma_address = ops->map_page(dev, sg_page(s),
+						s->offset,
 						s->length, dir, attrs);
-		if (dma_mapping_error(dev, s->dma_address))
-			goto bad_mapping;
+			if (dma_mapping_error(dev, s->dma_address))
+				goto bad_mapping;
+		}
 	}
 	return nents;
 
@@ -1112,7 +1134,9 @@ void arm_dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 	int i;
 
 	for_each_sg(sg, s, nents, i)
-		ops->unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir, attrs);
+		if (!(s->dma_attrs & DMA_ATTR_DEV_COHERENT_NOPAGE))
+			ops->unmap_page(dev, sg_dma_address(s),
+					sg_dma_len(s), dir, attrs);
 }
 
 /**
diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
index 640a7e6..d08cf44 100644
--- a/drivers/base/dma-coherent.c
+++ b/drivers/base/dma-coherent.c
@@ -209,6 +209,31 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 EXPORT_SYMBOL(dma_alloc_from_coherent);
 
 /**
+ * dma_check_dev_coherent() - checks if memory is from the device coherent area
+ *
+ * @dev:	device whose coherent area is checked to validate memory
+ * @dma_handle:	dma handle associated with the allocated memory
+ * @vaddr:	the virtual address to the allocated area.
+ *
+ * Returns true if memory does belong to the per-device cohrent area.
+ * false otherwise.
+ */
+bool dma_check_dev_coherent(struct device *dev, dma_addr_t dma_handle,
+				void *vaddr)
+{
+	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
+
+	if (mem && vaddr >= mem->virt_base &&
+	    vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT)) &&
+	    dma_handle >= mem->device_base &&
+	    dma_handle < (mem->device_base + (mem->size << PAGE_SHIFT)))
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(dma_check_dev_coherent);
+
+/**
  * dma_release_from_coherent() - try to free the memory allocated from per-device coherent memory pool
  * @dev:	device from which the memory was allocated
  * @order:	the order of pages allocated
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index fb6a177..f7caf2b 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -161,6 +161,9 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 	if ((buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0)
 		buf->vaddr = buf->cookie;
 
+	if (dma_check_dev_coherent(dev, buf->dma_addr, buf->cookie))
+		buf->attrs |= DMA_ATTR_DEV_COHERENT_NOPAGE;
+
 	/* Prevent the device from being released while the buffer is used */
 	buf->dev = get_device(dev);
 	buf->size = size;
@@ -248,6 +251,9 @@ static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
 	rd = buf->sgt_base->sgl;
 	wr = sgt->sgl;
 	for (i = 0; i < sgt->orig_nents; ++i) {
+		if (rd->dma_attrs & DMA_ATTR_DEV_COHERENT_NOPAGE)
+			wr->dma_address = rd->dma_address;
+		wr->dma_attrs = rd->dma_attrs;
 		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
 		rd = sg_next(rd);
 		wr = sg_next(wr);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 0977317..9f3ec53 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -70,6 +70,12 @@
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
 /*
+ * DMA_ATTR_DEV_COHERENT_NOPAGE: This is a hint to the DMA-mapping sub-system
+ * that this memory isn't backed by struct page.
+ */
+#define DMA_ATTR_DEV_COHERENT_NOPAGE	(1UL << 10)
+
+/*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
  * It can be given to a device to use as a DMA source or target.  A CPU cannot
  * reference a dma_addr_t directly because there may be translation between
@@ -160,6 +166,8 @@ static inline int is_device_dma_capable(struct device *dev)
  */
 int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 				       dma_addr_t *dma_handle, void **ret);
+bool dma_check_dev_coherent(struct device *dev, dma_addr_t dma_handle,
+				void *vaddr);
 int dma_release_from_coherent(struct device *dev, int order, void *vaddr);
 
 int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index cb3c8fe..7da610b 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -18,6 +18,7 @@ struct scatterlist {
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
 	unsigned int	dma_length;
 #endif
+	unsigned long	dma_attrs;
 };
 
 /*
-- 
2.7.4
