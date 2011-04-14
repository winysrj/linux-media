Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50079 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1DNKWu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2011 06:22:50 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LJN007J70TZ27@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Apr 2011 11:22:47 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJN00MX30TYFA@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Apr 2011 11:22:46 +0100 (BST)
Date: Thu, 14 Apr 2011 12:22:40 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: correct queue initialization order
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Message-id: <1302776560-24623-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

q->memory entry is initialized to late, so if allocation of memory buffers
fails, the buffers might not be freed correctly (q->memory is tested in
__vb2_free_mem, which can be called before setting q->memory).

Reported-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6698c77..25feda7 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -519,6 +519,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
 	memset(plane_sizes, 0, sizeof(plane_sizes));
 	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
+	q->memory = req->memory;
 
 	/*
 	 * Ask the driver how many buffers and planes per buffer it requires.
@@ -560,8 +561,6 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		ret = num_buffers;
 	}
 
-	q->memory = req->memory;
-
 	/*
 	 * Return the number of successfully allocated buffers
 	 * to the userspace.
-- 
1.7.1.569.g6f426
