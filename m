Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24642 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1A1M5K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 07:57:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LFQ00E2PHB78090@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 28 Jan 2011 12:57:08 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LFQ00GEKHB77J@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 28 Jan 2011 12:57:07 +0000 (GMT)
Date: Fri, 28 Jan 2011 13:56:39 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/2] v4l2: vb2: fix queue reallocation and REQBUFS(0) case
In-reply-to: <1296219400-2582-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com
Message-id: <1296219400-2582-2-git-send-email-m.szyprowski@samsung.com>
References: <1296219400-2582-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch fixes 2 minor bugs in videobuf2 core:
1. Queue should be reallocated if one change the memory access
method without changing the number of buffers.
2. In case of REQBUFS(0), the request should not be passed to the
driver.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-core.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index cc7ab0a..2f724ed 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -488,7 +488,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return -EINVAL;
 	}
 
-	if (req->count == 0 || q->num_buffers != 0) {
+	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
 		/*
 		 * We already have buffers allocated, so first check if they
 		 * are not in use and can be freed.
@@ -501,6 +501,13 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		ret = __vb2_queue_free(q);
 		if (ret != 0)
 			return ret;
+
+		/*
+		 * In case of REQBUFS(0) return immedietely without calling
+		 * driver's queue_setup() callback and allocating resources.
+		 */
+		if (req->count == 0)
+			return 0;
 	}
 
 	/*
-- 
1.7.1.569.g6f426

