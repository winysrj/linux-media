Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50175 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757282AbcLPBYD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 20:24:03 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [RFC v2 08/11] vb2: dma-contig: Don't warn on failure in obtaining scatterlist
Date: Fri, 16 Dec 2016 03:24:22 +0200
Message-Id: <20161216012425.11179-9-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

vb2_dc_get_base_sgt() which obtains the scatterlist already prints
information on why the scatterlist could not be obtained.

Also, remove the useless warning of a failed kmalloc().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 2a00d12ffee2..d59f107f0457 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -370,10 +370,8 @@ static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
 	struct sg_table *sgt;
 
 	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
-	if (!sgt) {
-		dev_err(buf->dev, "failed to alloc sg table\n");
+	if (!sgt)
 		return NULL;
-	}
 
 	ret = dma_get_sgtable_attrs(buf->dev, sgt, buf->cookie, buf->dma_addr,
 		buf->size, buf->attrs);
@@ -400,7 +398,7 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 	if (!buf->dma_sgt)
 		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
 
-	if (WARN_ON(!buf->dma_sgt))
+	if (!buf->dma_sgt)
 		return NULL;
 
 	dbuf = dma_buf_export(&exp_info);
-- 
Regards,

Laurent Pinchart

