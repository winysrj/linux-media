Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43118 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031330Ab2CPQEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 12:04:51 -0400
Received: by gghe5 with SMTP id e5so4339306ggh.19
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 09:04:51 -0700 (PDT)
From: Rob Clark <rob.clark@linaro.org>
To: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Cc: patches@linaro.org, sumit.semwal@linaro.org, daniel@ffwll.ch,
	airlied@redhat.com, Rob Clark <rob@ti.com>
Subject: [PATCH] dma-buf: add get_dma_buf()
Date: Fri, 16 Mar 2012 11:04:41 -0500
Message-Id: <1331913881-13105-1-git-send-email-rob.clark@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Clark <rob@ti.com>

Works in a similar way to get_file(), and is needed in cases such as
when the exporter needs to also keep a reference to the dmabuf (that
is later released with a dma_buf_put()), and possibly other similar
cases.

Signed-off-by: Rob Clark <rob@ti.com>
---
 include/linux/dma-buf.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index cbdff81..25eb287 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -132,6 +132,20 @@ struct dma_buf_attachment {
 	void *priv;
 };
 
+/**
+ * get_dma_buf - convenience wrapper for get_file.
+ * @dmabuf:	[in]	pointer to dma_buf
+ *
+ * Increments the reference count on the dma-buf, needed in case of drivers
+ * that either need to create additional references to the dmabuf on the
+ * kernel side.  For example, an exporter that needs to keep a dmabuf ptr
+ * so that subsequent exports don't create a new dmabuf.
+ */
+static inline void get_dma_buf(struct dma_buf *dmabuf)
+{
+	get_file(dmabuf->file);
+}
+
 #ifdef CONFIG_DMA_SHARED_BUFFER
 struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 							struct device *dev);
-- 
1.7.5.4

