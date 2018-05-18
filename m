Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38566 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbeERVJZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 17:09:25 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] tw686x: Fix incorrect vb2_mem_ops GFP flags
Date: Fri, 18 May 2018 18:07:48 -0300
Message-Id: <20180518210748.21983-4-ezequiel@collabora.com>
In-Reply-To: <20180518210748.21983-1-ezequiel@collabora.com>
References: <20180518210748.21983-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the driver is configured in the "memcpy" dma-mode,
it uses vb2_vmalloc_memops, which is backed by a SLAB
allocator and so shouldn't be using GFP_DMA32.

Fix it.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/pci/tw686x/tw686x-video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index c3fafa97b2d0..0ea8dd44026c 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -1228,7 +1228,8 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		vc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		vc->vidq.min_buffers_needed = 2;
 		vc->vidq.lock = &vc->vb_mutex;
-		vc->vidq.gfp_flags = GFP_DMA32;
+		vc->vidq.gfp_flags = dev->dma_mode != TW686X_DMA_MODE_MEMCPY ?
+				     GFP_DMA32 : 0;
 		vc->vidq.dev = &dev->pci_dev->dev;
 
 		err = vb2_queue_init(&vc->vidq);
-- 
2.16.3
