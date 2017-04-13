Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:30258 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751054AbdDMH6C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 03:58:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC v3 06/14] vb2: dma-contig: Assign DMA attrs for a buffer unconditionally
Date: Thu, 13 Apr 2017 10:57:11 +0300
Message-Id: <1492070239-21532-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

attrs used to be a pointer and the caller of vb2_dc_alloc() could
optionally provide it, or NULL. This was when struct dma_attrs was used
to describe DMA attributes rather than an unsigned long value. There is no
longer a need to maintain the condition, assign the value unconditionally.
There is no functional difference because the memory was initialised to
zero anyway.

Fixes: 00085f1e ("dma-mapping: use unsigned long for dma_attrs")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 30082a4..a8a46a8 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -149,8 +149,7 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	if (attrs)
-		buf->attrs = attrs;
+	buf->attrs = attrs;
 	buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
 					GFP_KERNEL | gfp_flags, buf->attrs);
 	if (!buf->cookie) {
-- 
2.7.4
