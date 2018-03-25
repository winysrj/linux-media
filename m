Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53284 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbeCYLAD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 07:00:03 -0400
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] lib/scatterlist: add sg_set_dma_addr() helper
Date: Sun, 25 Mar 2018 12:59:53 +0200
Message-Id: <20180325110000.2238-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use this function to set an sg entry to point to device resources mapped
using dma_map_resource(). The page pointer is set to NULL and only the DMA
address, length and offset values are valid.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 include/linux/scatterlist.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 22b2131bcdcd..f944ee4e482c 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -149,6 +149,29 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
 }
 
+/**
+ * sg_set_dma_addr - Set sg entry to point at specified dma address
+ * @sg:		 SG entry
+ * @address:	 DMA address to set
+ * @len:	 Length of data
+ * @offset:	 Offset into page
+ *
+ * Description:
+ *   Use this function to set an sg entry to point to device resources mapped
+ *   using dma_map_resource(). The page pointer is set to NULL and only the DMA
+ *   address, length and offset values are valid.
+ *
+ **/
+static inline void sg_set_dma_addr(struct scatterlist *sg, dma_addr_t address,
+				   unsigned int len, unsigned int offset)
+{
+	sg_set_page(sg, NULL, len, offset);
+	sg->dma_address = address;
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
+	sg->dma_length = len;
+#endif
+}
+
 /*
  * Loop over each sg element, following the pointer to a new list if necessary
  */
-- 
2.14.1
