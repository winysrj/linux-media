Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18512 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1FHJZ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 05:25:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LMG00A5TSV7X500@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jun 2011 10:25:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMG0029KSV6WZ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jun 2011 10:25:55 +0100 (BST)
Date: Wed, 08 Jun 2011 11:25:50 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] Revert "[media] v4l2: vb2: one more fix for REQBUFS()"
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Message-id: <1307525150-10876-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This reverts commit 31901a078af29c33c736dcbf815656920e904632.

Queue should be reinitialized on each REQBUFS() call even if the memory
access method and buffer count have not been changed. The user might have
changed the format and if we go the short path introduced in that commit,
the memory buffer will not be reallocated to fit with new format.

The previous patch was just over-engineered optimization, which just
introduced a bug to videobuf2.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6ba1461..6489aa2 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -492,13 +492,6 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return -EINVAL;
 	}
 
-	/*
-	 * If the same number of buffers and memory access method is requested
-	 * then return immediately.
-	 */
-	if (q->memory == req->memory && req->count == q->num_buffers)
-		return 0;
-
 	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
 		/*
 		 * We already have buffers allocated, so first check if they
-- 
1.7.1.569.g6f426

