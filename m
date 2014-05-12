Return-path: <linux-media-owner@vger.kernel.org>
Received: from lgeamrelo02.lge.com ([156.147.1.126]:42197 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaELLyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 07:54:41 -0400
From: "gioh.kim" <gioh.kim@lge.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gunho.lee@lge.com, gioh.kim@lge.com
Subject: [PATCH] Documentation/dma-buf-sharing.txt: update API descriptions
Date: Mon, 12 May 2014 20:48:12 +0900
Message-Id: <1399895292-29520-1-git-send-email-gioh.kim@lge.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "gioh.kim" <gioh.kim@lge.com>

update some descriptions for API arguments and descriptions.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 Documentation/dma-buf-sharing.txt |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 505e711..1ea89b8 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -56,7 +56,7 @@ The dma_buf buffer sharing API usage contains the following steps:
 				     size_t size, int flags,
 				     const char *exp_name)
 
-   If this succeeds, dma_buf_export allocates a dma_buf structure, and returns a
+   If this succeeds, dma_buf_export_named allocates a dma_buf structure, and returns a
    pointer to the same. It also associates an anonymous file with this buffer,
    so it can be exported. On failure to allocate the dma_buf object, it returns
    NULL.
@@ -66,7 +66,7 @@ The dma_buf buffer sharing API usage contains the following steps:
 
    Exporting modules which do not wish to provide any specific name may use the
    helper define 'dma_buf_export()', with the same arguments as above, but
-   without the last argument; a __FILE__ pre-processor directive will be
+   without the last argument; a KBUILD_MODNAME pre-processor directive will be
    inserted in place of 'exp_name' instead.
 
 2. Userspace gets a handle to pass around to potential buffer-users
@@ -76,7 +76,7 @@ The dma_buf buffer sharing API usage contains the following steps:
    drivers and/or processes.
 
    Interface:
-      int dma_buf_fd(struct dma_buf *dmabuf)
+      int dma_buf_fd(struct dma_buf *dmabuf, int flags)
 
    This API installs an fd for the anonymous file associated with this buffer;
    returns either 'fd', or error.
@@ -157,7 +157,9 @@ to request use of buffer for allocation.
    "dma_buf->ops->" indirection from the users of this interface.
 
    In struct dma_buf_ops, unmap_dma_buf is defined as
-      void (*unmap_dma_buf)(struct dma_buf_attachment *, struct sg_table *);
+      void (*unmap_dma_buf)(struct dma_buf_attachment *,
+                            struct sg_table *,
+                            enum dma_data_direction);
 
    unmap_dma_buf signifies the end-of-DMA for the attachment provided. Like
    map_dma_buf, this API also must be implemented by the exporter.
-- 
1.7.9.5

