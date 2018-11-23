Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42084 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390637AbeKWWvT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 17:51:19 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] media: vb2: be sure to free on errors
Date: Fri, 23 Nov 2018 07:07:17 -0500
Message-Id: <e1b3d00067767ceb39da5e0014b320835b443908.1542974835.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
drivers/media/common/videobuf2/videobuf2-core.c: drivers/media/common/videobuf2/videobuf2-core.c:2159 vb2_mmap() warn: inconsistent returns 'mutex:&q->mmap_lock'.
  Locked on:   line 2148
  Unlocked on: line 2100
               line 2108
               line 2113
               line 2118
               line 2156
               line 2159

There is one error condition that doesn't unlock a mutex.

Fixes: cd26d1c4d1bc ("media: vb2: vb2_mmap: move lock up")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 04d1250747cf..0ca81d495bda 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2145,7 +2145,8 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	if (length < (vma->vm_end - vma->vm_start)) {
 		dprintk(1,
 			"MMAP invalid, as it would overflow buffer length\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
-- 
2.19.1
