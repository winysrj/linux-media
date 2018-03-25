Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38169 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752496AbeCYLAG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 07:00:06 -0400
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] dma-buf: add peer2peer flag
Date: Sun, 25 Mar 2018 12:59:56 +0200
Message-Id: <20180325110000.2238-4-christian.koenig@amd.com>
In-Reply-To: <20180325110000.2238-1-christian.koenig@amd.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a peer2peer flag noting that the importer can deal with device
resources which are not backed by pages.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/dma-buf/dma-buf.c | 1 +
 include/linux/dma-buf.h   | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index ffaa2f9a9c2c..f420225f93c6 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -565,6 +565,7 @@ struct dma_buf_attachment *dma_buf_attach(const struct dma_buf_attach_info *info
 
 	attach->dev = info->dev;
 	attach->dmabuf = dmabuf;
+	attach->peer2peer = info->peer2peer;
 	attach->priv = info->priv;
 	attach->invalidate = info->invalidate;
 
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 15dd8598bff1..1ef50bd9bc5b 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -313,6 +313,7 @@ struct dma_buf {
  * @dmabuf: buffer for this attachment.
  * @dev: device attached to the buffer.
  * @node: list of dma_buf_attachment.
+ * @peer2peer: true if the importer can handle peer resources without pages.
  * @priv: exporter specific attachment data.
  *
  * This structure holds the attachment information between the dma_buf buffer
@@ -328,6 +329,7 @@ struct dma_buf_attachment {
 	struct dma_buf *dmabuf;
 	struct device *dev;
 	struct list_head node;
+	bool peer2peer;
 	void *priv;
 
 	/**
@@ -392,6 +394,7 @@ struct dma_buf_export_info {
  * @dmabuf:	the exported dma_buf
  * @dev:	the device which wants to import the attachment
  * @priv:	private data of importer to this attachment
+ * @peer2peer:	true if the importer can handle peer resources without pages
  * @invalidate:	callback to use for invalidating mappings
  *
  * This structure holds the information required to attach to a buffer. Used
@@ -401,6 +404,7 @@ struct dma_buf_attach_info {
 	struct dma_buf *dmabuf;
 	struct device *dev;
 	void *priv;
+	bool peer2peer;
 	void (*invalidate)(struct dma_buf_attachment *attach);
 };
 
-- 
2.14.1
