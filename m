Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:30712 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbaGaI2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 04:28:38 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9K00CSVI7L4310@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jul 2014 17:28:34 +0900 (KST)
From: panpan liu <panpan1.liu@samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] videobuf2-core: simplify and unify the kernel api
Date: Thu, 31 Jul 2014 16:28:15 +0800
Message-id: <1406795295-3013-1-git-send-email-panpan1.liu@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Making the kernel api more simplified and unified.

Signed-off-by: panpan liu <panpan1.liu@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 mode change 100644 => 100755 drivers/media/v4l2-core/videobuf2-core.c

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
old mode 100644
new mode 100755
index 9abb15e..71ba92c
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1194,7 +1194,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane)
 		call_memop(q, prepare, vb->planes[plane].mem_priv);

-	q->ops->buf_queue(vb);
+	call_qop(q, buf_queue, vb);
 }

 static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
--
1.7.9.5

