Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:65132 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3DLD5r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 23:57:47 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0ML4002FWJ00JAD0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 12 Apr 2013 12:57:46 +0900 (KST)
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: [PATCH] media: vb2: add length check for mmap
Date: Fri, 12 Apr 2013 12:57:57 +0900
Message-id: <1365739077-8740-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The length of mmap() can be bigger than length of vb2 buffer, so
it should be checked.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index db1235d..2c6ff2d 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1886,6 +1886,11 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 
 	vb = q->bufs[buffer];
 
+	if (vb->v4l2_planes[plane].length < (vma->vm_end - vma->vm_start)) {
+		dprintk(1, "Invalid length\n");
+		return -EINVAL;
+	}
+
 	ret = call_memop(q, mmap, vb->planes[plane].mem_priv, vma);
 	if (ret)
 		return ret;
-- 
1.7.4.1

