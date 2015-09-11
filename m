Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:21344 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbbIKLwa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 07:52:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	sumit.semwal@linaro.org, robdclark@gmail.com,
	daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC RESEND 09/11] vb2: dma-contig: Don't warn on failure in obtaining scatterlist
Date: Fri, 11 Sep 2015 14:50:32 +0300
Message-Id: <1441972234-8643-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_dc_get_base_sgt() which obtains the scatterlist already prints
information on why the scatterlist could not be obtained.

Also, remove the useless warning of a failed kmalloc().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 3260392..65bc687 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -88,10 +88,8 @@ static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
 	struct sg_table *sgt;
 
 	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
-	if (!sgt) {
-		dev_err(buf->dev, "failed to alloc sg table\n");
+	if (!sgt)
 		return NULL;
-	}
 
 	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
 		buf->size);
@@ -411,7 +409,7 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 	if (!buf->dma_sgt)
 		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
 
-	if (WARN_ON(!buf->dma_sgt))
+	if (!buf->dma_sgt)
 		return NULL;
 
 	dbuf = dma_buf_export(&exp_info);
-- 
2.1.0.231.g7484e3b

