Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab1K0FcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 00:32:21 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: [PATCH 18/62] media: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:26:58 +0800
Message-Id: <1322371662-26166-19-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/media/video/ivtv/ivtv-udma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-udma.c b/drivers/media/video/ivtv/ivtv-udma.c
index 69cc816..7338cb2 100644
--- a/drivers/media/video/ivtv/ivtv-udma.c
+++ b/drivers/media/video/ivtv/ivtv-udma.c
@@ -57,9 +57,9 @@ int ivtv_udma_fill_sg_list (struct ivtv_user_dma *dma, struct ivtv_dma_page_info
 			if (dma->bouncemap[map_offset] == NULL)
 				return -1;
 			local_irq_save(flags);
-			src = kmap_atomic(dma->map[map_offset], KM_BOUNCE_READ) + offset;
+			src = kmap_atomic(dma->map[map_offset]) + offset;
 			memcpy(page_address(dma->bouncemap[map_offset]) + offset, src, len);
-			kunmap_atomic(src, KM_BOUNCE_READ);
+			kunmap_atomic(src);
 			local_irq_restore(flags);
 			sg_set_page(&dma->SGlist[map_offset], dma->bouncemap[map_offset], len, offset);
 		}
-- 
1.7.4.4

