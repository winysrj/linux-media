Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31885 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab1KPTWe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 14:22:34 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LUR002TVPTKE6@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Nov 2011 19:22:32 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUR00B5DPTKZ9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Nov 2011 19:22:32 +0000 (GMT)
Date: Wed, 16 Nov 2011 20:22:28 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: fix queueing of userptr buffers with null buffer
 pointer
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Message-id: <1321471348-11567-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Heuristic that checks if the memory pointer has been changed lacked a check
if the pointer was actually provided by the userspace, what allowed one to
queue a NULL pointer which was accepted without further checking. This
patch fixes this issue.

Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index ec49fed..24f11ae 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -765,7 +765,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		/* Skip the plane if already verified */
-		if (vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
+		if (vb->v4l2_planes[plane].m.userptr &&
+		    vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
 		    && vb->v4l2_planes[plane].length == planes[plane].length)
 			continue;
 
-- 
1.7.1.569.g6f426

