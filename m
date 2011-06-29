Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62400 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1F2JhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 05:37:11 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNJ006QCPDXBO@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 10:37:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNJ005XIPDW3X@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 10:37:08 +0100 (BST)
Date: Wed, 29 Jun 2011 11:37:00 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: fix allocation failure check
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Jonathan Corbet <corbet@lwn.net>
Message-id: <1309340220-3139-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

__vb2_queue_alloc function returns the number of successfully allocated
buffers. There is no point in checking if the returned value is negative.
If this function returns 0, videobuf2 should just return -ENOMEM to
userspace, because no driver can work without memory buffers.

Reported-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6ba1461..5517913 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -539,9 +539,9 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	/* Finally, allocate buffers and video memory */
 	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes,
 				plane_sizes);
-	if (ret < 0) {
-		dprintk(1, "Memory allocation failed with error: %d\n", ret);
-		return ret;
+	if (ret == 0) {
+		dprintk(1, "Memory allocation failed\n");
+		return -ENOMEM;
 	}
 
 	/*
-- 
1.7.1.569.g6f426

