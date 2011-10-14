Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20766 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1JNMyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 08:54:44 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LT200K0U3V629@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 14 Oct 2011 13:54:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LT200HHB3V6IW@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 14 Oct 2011 13:54:42 +0100 (BST)
Date: Fri, 14 Oct 2011 14:54:29 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: set buffer length correctly for all buffer types
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Message-id: <1318596869-30027-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_planes[plane].length field was not initialized for userptr buffers.
This patch fixes this issue.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index d8affb8..5656fdf 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -58,7 +58,6 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 
 		/* Associate allocator private data with this plane */
 		vb->planes[plane].mem_priv = mem_priv;
-		vb->v4l2_planes[plane].length = q->plane_sizes[plane];
 	}
 
 	return 0;
@@ -121,6 +120,7 @@ static void __setup_offsets(struct vb2_queue *q)
 			continue;
 
 		for (plane = 0; plane < vb->num_planes; ++plane) {
+			vb->v4l2_planes[plane].length = q->plane_sizes[plane];
 			vb->v4l2_planes[plane].m.mem_offset = off;
 
 			dprintk(3, "Buffer %d, plane %d offset 0x%08lx\n",
-- 
1.7.1.569.g6f426

