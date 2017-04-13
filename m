Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54359 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754640AbdDMH7f (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 03:59:35 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC v3 08/14] vb2: dma-contig: Don't warn on failure in obtaining scatterlist
Date: Thu, 13 Apr 2017 10:57:13 +0300
Message-Id: <1492070239-21532-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_dc_get_base_sgt() which obtains the scatterlist already prints
information on why the scatterlist could not be obtained.

Also, remove the useless warning of a failed kmalloc().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index ddbbcf0..22636cd 100644
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
2.7.4
