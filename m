Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42508 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaDIXaT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 19:30:19 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-doc@vger.kernel.org,
	Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/2] dma-buf: fix trivial typo error
Date: Thu, 10 Apr 2014 01:30:05 +0200
Message-Id: <1397086206-5898-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/base/dma-buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index ea77701..840c7fa 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -491,7 +491,7 @@ EXPORT_SYMBOL_GPL(dma_buf_kunmap);
  * 			dma-buf buffer.
  *
  * This function adjusts the passed in vma so that it points at the file of the
- * dma_buf operation. It alsog adjusts the starting pgoff and does bounds
+ * dma_buf operation. It also adjusts the starting pgoff and does bounds
  * checking on the size of the vma. Then it calls the exporters mmap function to
  * set up the mapping.
  *
-- 
1.9.0

