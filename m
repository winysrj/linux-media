Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33629 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1JCHWL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 03:22:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LSH00HMEB4XMX50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Oct 2011 08:22:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LSH00D9IB4WEX@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Oct 2011 08:22:09 +0100 (BST)
Date: Mon, 03 Oct 2011 09:21:45 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: fix incorrect return value
In-reply-to: <4E85C5A7.7090005@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-id: <1317626505-17612-1-git-send-email-m.szyprowski@samsung.com>
References: <4E85C5A7.7090005@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes incorrect return value. Errors should be returned
as negative numbers.

Reported-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6687ac3..3f5c7a3 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -751,7 +751,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
 
 		/* Check if the provided plane buffer is large enough */
 		if (planes[plane].length < q->plane_sizes[plane]) {
-			ret = EINVAL;
+			ret = -EINVAL;
 			goto err;
 		}
 
-- 
1.7.1.569.g6f426

