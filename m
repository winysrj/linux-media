Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36665 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab1CJM3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 07:29:22 -0500
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LHU00K2PDCU54@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 12:29:19 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LHU00G1BDCU4A@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 12:29:18 +0000 (GMT)
Date: Thu, 10 Mar 2011 13:28:41 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/3] v4l2: vb2: simplify __vb2_queue_free function
In-reply-to: <1299760122-29493-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	andrzej.p@samsung.com, pawel@osciak.com
Message-id: <1299760122-29493-3-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1299760122-29493-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

__vb2_queue_free function doesn't really return anything useful. This patch
removes support for the return value to simplify the code.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-core.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 9df484d..f564920 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -227,7 +227,7 @@ static void __vb2_free_mem(struct vb2_queue *q)
  * and return the queue to an uninitialized state. Might be called even if the
  * queue has already been freed.
  */
-static int __vb2_queue_free(struct vb2_queue *q)
+static void __vb2_queue_free(struct vb2_queue *q)
 {
 	unsigned int buffer;
 
@@ -251,8 +251,6 @@ static int __vb2_queue_free(struct vb2_queue *q)
 
 	q->num_buffers = 0;
 	q->memory = 0;
-
-	return 0;
 }
 
 /**
@@ -505,9 +503,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 			return -EBUSY;
 		}
 
-		ret = __vb2_queue_free(q);
-		if (ret != 0)
-			return ret;
+		__vb2_queue_free(q);
 
 		/*
 		 * In case of REQBUFS(0) return immediately without calling
-- 
1.7.1.569.g6f426
