Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34950 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbdCBVpB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 16:45:01 -0500
Received: by mail-qk0-f178.google.com with SMTP id m67so31709495qkf.2
        for <linux-media@vger.kernel.org>; Thu, 02 Mar 2017 13:45:00 -0800 (PST)
From: Laura Abbott <labbott@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com
Cc: Laura Abbott <labbott@redhat.com>, romlem@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org
Subject: [RFC PATCH 03/12] staging: android: ion: Duplicate sg_table
Date: Thu,  2 Mar 2017 13:44:35 -0800
Message-Id: <1488491084-17252-4-git-send-email-labbott@redhat.com>
In-Reply-To: <1488491084-17252-1-git-send-email-labbott@redhat.com>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Ion currently returns a single sg_table on each dma_map call. This is
incorrect for later usage.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/ion.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 94a498e..ce4adac 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -799,6 +799,32 @@ static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 				       struct device *dev,
 				       enum dma_data_direction direction);
 
+static struct sg_table *dup_sg_table(struct sg_table *table)
+{
+	struct sg_table *new_table;
+	int ret, i;
+	struct scatterlist *sg, *new_sg;
+
+	new_table = kzalloc(sizeof(*new_table), GFP_KERNEL);
+	if (!new_table)
+		return ERR_PTR(-ENOMEM);
+
+	ret = sg_alloc_table(new_table, table->nents, GFP_KERNEL);
+	if (ret) {
+		kfree(table);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	new_sg = new_table->sgl;
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		memcpy(new_sg, sg, sizeof(*sg));
+		sg->dma_address = 0;
+		new_sg = sg_next(new_sg);
+	}
+
+	return new_table;
+}
+
 static struct sg_table *ion_map_dma_buf(struct dma_buf_attachment *attachment,
 					enum dma_data_direction direction)
 {
@@ -806,13 +832,15 @@ static struct sg_table *ion_map_dma_buf(struct dma_buf_attachment *attachment,
 	struct ion_buffer *buffer = dmabuf->priv;
 
 	ion_buffer_sync_for_device(buffer, attachment->dev, direction);
-	return buffer->sg_table;
+	return dup_sg_table(buffer->sg_table);
 }
 
 static void ion_unmap_dma_buf(struct dma_buf_attachment *attachment,
 			      struct sg_table *table,
 			      enum dma_data_direction direction)
 {
+	sg_free_table(table);
+	kfree(table);
 }
 
 void ion_pages_sync_for_device(struct device *dev, struct page *page,
-- 
2.7.4
