Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43185 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1JLQMx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 12:12:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LSY004QQNPFVS60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Oct 2011 17:12:51 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LSY002BANPF94@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Oct 2011 17:12:51 +0100 (BST)
Date: Wed, 12 Oct 2011 18:12:44 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: add a check for uninitialized buffer
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Message-id: <1318435964-9986-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

__buffer_in_use() might be called for empty/uninitialized buffer in the
following scenario: REQBUF(n, USER_PTR), QUERYBUF(). This patch fixes
kernel ops in such case.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>

---
 drivers/media/video/videobuf2-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index d8affb8..cdbbab7 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -284,14 +284,14 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 {
 	unsigned int plane;
 	for (plane = 0; plane < vb->num_planes; ++plane) {
+		void mem_priv = vb->planes[plane].mem_priv;
 		/*
 		 * If num_users() has not been provided, call_memop
 		 * will return 0, apparently nobody cares about this
 		 * case anyway. If num_users() returns more than 1,
 		 * we are not the only user of the plane's memory.
 		 */
-		if (call_memop(q, plane, num_users,
-				vb->planes[plane].mem_priv) > 1)
+		if (mem_priv && call_memop(q, plane, num_users, mem_priv) > 1)
 			return true;
 	}
 	return false;
-- 
1.7.1.569.g6f426

