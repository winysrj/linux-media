Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:46549 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbcGUMOO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 08:14:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	laurent.pinchart@ideasonboard.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/2] vb2: add WARN_ONs checking if a valid struct device was passed
Date: Thu, 21 Jul 2016 14:14:03 +0200
Message-Id: <1469103243-5296-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1469103243-5296-1-git-send-email-hverkuil@xs4all.nl>
References: <1469103243-5296-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The dma-contig and dma-sg memops require a valid struct device for
the DMA to be handled correctly.

Call WARN_ON and return ERR_PTR(-EINVAL) if it was NULL.

Setting the correct device pointer was forgotten in several new driver
submissions. This was caught during code review, but it really should be
caught in the code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 9 +++++++++
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 863f658..925b34b 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -141,6 +141,9 @@ static void *vb2_dc_alloc(struct device *dev, const struct dma_attrs *attrs,
 {
 	struct vb2_dc_buf *buf;
 
+	if (WARN_ON(!dev))
+		return ERR_PTR(-EINVAL);
+
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
@@ -499,6 +502,9 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (WARN_ON(!dev))
+		return ERR_PTR(-EINVAL);
+
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
@@ -679,6 +685,9 @@ static void *vb2_dc_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	if (dbuf->size < size)
 		return ERR_PTR(-EFAULT);
 
+	if (WARN_ON(!dev))
+		return ERR_PTR(-EINVAL);
+
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index e2afd2c..64a386d 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -232,6 +232,9 @@ static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
 	DEFINE_DMA_ATTRS(attrs);
 	struct frame_vector *vec;
 
+	if (WARN_ON(!dev))
+		return ERR_PTR(-EINVAL);
+
 	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -618,6 +621,9 @@ static void *vb2_dma_sg_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	struct vb2_dma_sg_buf *buf;
 	struct dma_buf_attachment *dba;
 
+	if (WARN_ON(!dev))
+		return ERR_PTR(-EINVAL);
+
 	if (dbuf->size < size)
 		return ERR_PTR(-EFAULT);
 
-- 
2.8.1

