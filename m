Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:36063 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756867AbcLOAIK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 19:08:10 -0500
Received: by mail-qk0-f180.google.com with SMTP id n21so39630218qka.3
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2016 16:08:01 -0800 (PST)
From: Laura Abbott <labbott@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com
Cc: Laura Abbott <labbott@redhat.com>, romlem@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Bryan Huntsman <bryanh@codeaurora.org>, pratikp@codeaurora.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>
Subject: [RFC PATCH 4/4] staging: android: ion: Call dma_map_sg for syncing and mapping
Date: Wed, 14 Dec 2016 16:07:43 -0800
Message-Id: <1481760463-3515-5-git-send-email-labbott@redhat.com>
In-Reply-To: <1481760463-3515-1-git-send-email-labbott@redhat.com>
References: <1481760463-3515-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Technically, calling dma_buf_map_attachment should return a buffer
properly dma_mapped. Add calls to dma_map_sg to begin_cpu_access to
ensure this happens. As a side effect, this lets Ion buffers take
advantage of the dma_buf sync ioctls.

Not-signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/ion.c | 61 ++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 86dba07..5177d79 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -776,6 +776,11 @@ static struct sg_table *dup_sg_table(struct sg_table *table)
 	return new_table;
 }
 
+static void free_duped_table(struct sg_table *table)
+{
+	sg_free_table(table);
+	kfree(table);
+}
 
 static struct sg_table *ion_map_dma_buf(struct dma_buf_attachment *attachment,
 					enum dma_data_direction direction)
@@ -784,15 +789,29 @@ static struct sg_table *ion_map_dma_buf(struct dma_buf_attachment *attachment,
 	struct ion_buffer *buffer = dmabuf->priv;
 	struct sg_table *table;
 
-	return dup_sg_table(buffer->sg_table);
+	/*
+	 * TODO: Need to sync wrt CPU or device completely owning?
+	 */
+
+	table = dup_sg_table(buffer->sg_table);
+
+	if (!dma_map_sg(attachment->dev, table->sgl, table->nents,
+			direction)){
+		ret = -ENOMEM;
+		goto err;
+	}
+
+err:
+	free_duped_table(table);
+	return ERR_PTR(ret);
 }
 
 static void ion_unmap_dma_buf(struct dma_buf_attachment *attachment,
 			      struct sg_table *table,
 			      enum dma_data_direction direction)
 {
-	sg_free_table(table);
-	kfree(table);
+	dma_unmap_sg(attachment->dev, table->sgl, table->nents, direction);
+	free_duped_table(table);
 }
 
 struct ion_vma_list {
@@ -889,16 +908,24 @@ static int ion_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
 	struct ion_buffer *buffer = dmabuf->priv;
 	void *vaddr;
 
-	if (!buffer->heap->ops->map_kernel) {
-		pr_err("%s: map kernel is not implemented by this heap.\n",
-		       __func__);
-		return -ENODEV;
+	/*
+	 * TODO: Move this elsewhere because we don't always need a vaddr
+	 */
+	if (buffer->heap->ops->map_kernel) {
+		mutex_lock(&buffer->lock);
+		vaddr = ion_buffer_kmap_get(buffer);
+		mutex_unlock(&buffer->lock);
 	}
 
-	mutex_lock(&buffer->lock);
-	vaddr = ion_buffer_kmap_get(buffer);
-	mutex_unlock(&buffer->lock);
-	return PTR_ERR_OR_ZERO(vaddr);
+	/*
+	 * Close enough right now? Flag to skip sync?
+	 */
+	if (!dma_map_sg(buffer->dev->dev.this_device, buffer->sg_table->sgl,
+			buffer->sg_table->nents,
+                        DMA_BIDIRECTIONAL))
+		return -ENOMEM;
+
+	return 0;
 }
 
 static int ion_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
@@ -906,9 +933,15 @@ static int ion_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
 {
 	struct ion_buffer *buffer = dmabuf->priv;
 
-	mutex_lock(&buffer->lock);
-	ion_buffer_kmap_put(buffer);
-	mutex_unlock(&buffer->lock);
+	if (buffer->heap->ops->map_kernel) {
+		mutex_lock(&buffer->lock);
+		ion_buffer_kmap_put(buffer);
+		mutex_unlock(&buffer->lock);
+	}
+
+	dma_unmap_sg(buffer->dev->dev.this_device, buffer->sg_table->sgl,
+			buffer->sg_table->nents,
+			DMA_BIDIRECTIONAL);
 
 	return 0;
 }
-- 
2.7.4

