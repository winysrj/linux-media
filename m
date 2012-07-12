Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62397 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2GLLkT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 07:40:19 -0400
Received: by pbbrp8 with SMTP id rp8so3611891pbb.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 04:40:18 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hans.verkuil@cisco.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] videobuf-dma-contig: Use NULL instead of plain integer
Date: Thu, 12 Jul 2012 17:09:50 +0530
Message-Id: <1342093190-18597-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warning:
drivers/media/video/videobuf-dma-contig.c:59:46:
warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/videobuf-dma-contig.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index 9b9a06f..a5af8b4 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -56,7 +56,7 @@ static int __videobuf_dc_alloc(struct device *dev,
 				dev_err(dev, "dma_map_single failed\n");
 
 				free_pages_exact(mem->vaddr, mem->size);
-				mem->vaddr = 0;
+				mem->vaddr = NULL;
 				return err;
 			}
 		}
-- 
1.7.4.1

