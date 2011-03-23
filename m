Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:58092 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1CWKBL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 06:01:11 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id CC664189B85
	for <linux-media@vger.kernel.org>; Wed, 23 Mar 2011 11:01:08 +0100 (CET)
Date: Wed, 23 Mar 2011 11:01:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: fix videobof2 to correctly identify allocation failures
Message-ID: <Pine.LNX.4.64.1103231100260.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The videobuf2-dma-contig allocator returns an ERR_PTR() on failure, not
a NULL like all other allocators. Fix videobuf2-core to also correctly
recognise those failures.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/videobuf2-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6698c77..71734a4 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -51,7 +51,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb,
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		mem_priv = call_memop(q, plane, alloc, q->alloc_ctx[plane],
 					plane_sizes[plane]);
-		if (!mem_priv)
+		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
 		/* Associate allocator private data with this plane */
-- 
1.7.2.5

