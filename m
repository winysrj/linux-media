Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55423 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab0BVQKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:10:22 -0500
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KY9000UV3L8KK@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Feb 2010 16:10:20 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KY900ILT3L7VX@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Feb 2010 16:10:19 +0000 (GMT)
Date: Mon, 22 Feb 2010 17:10:06 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v1 1/4] v4l: add missing checks for kzalloc returning NULL.
In-reply-to: <1266855010-2198-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, m-karicheri2@ti.com
Message-id: <1266855010-2198-2-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1266855010-2198-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
---
 drivers/media/video/videobuf-dma-sg.c  |    2 ++
 drivers/media/video/videobuf-vmalloc.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index fa78555..fcd045e 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -418,6 +418,8 @@ static void *__videobuf_alloc(size_t size)
 	struct videobuf_buffer *vb;
 
 	vb = kzalloc(size+sizeof(*mem),GFP_KERNEL);
+	if (!vb)
+		return vb;
 
 	mem = vb->priv = ((char *)vb)+size;
 	mem->magic=MAGIC_SG_MEM;
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index d6e6a28..136e093 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -138,6 +138,8 @@ static void *__videobuf_alloc(size_t size)
 	struct videobuf_buffer *vb;
 
 	vb = kzalloc(size+sizeof(*mem),GFP_KERNEL);
+	if (!vb)
+		return vb;
 
 	mem = vb->priv = ((char *)vb)+size;
 	mem->magic=MAGIC_VMAL_MEM;
-- 
1.7.0.31.g1df487

