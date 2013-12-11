Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42837 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3LKMcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 07:32:55 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v3] v4l: sh_vou: Fix warnings due to improper casts and printk formats
Date: Wed, 11 Dec 2013 13:33:03 +0100
Message-Id: <1386765183-1522-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the %zu and %pad printk specifiers to print size_t and dma_addr_t
variables. This fixes warnings on platforms where dma_addr_t has a
different size than int.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/sh_vou.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 4f30341..65c9f18 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -286,7 +286,7 @@ static int sh_vou_buf_prepare(struct videobuf_queue *vq,
 	vb->size = vb->height * bytes_per_line;
 	if (vb->baddr && vb->bsize < vb->size) {
 		/* User buffer too small */
-		dev_warn(vq->dev, "User buffer too small: [%u] @ %lx\n",
+		dev_warn(vq->dev, "User buffer too small: [%zu] @ %lx\n",
 			 vb->bsize, vb->baddr);
 		return -EINVAL;
 	}
@@ -302,9 +302,10 @@ static int sh_vou_buf_prepare(struct videobuf_queue *vq,
 	}
 
 	dev_dbg(vou_dev->v4l2_dev.dev,
-		"%s(): fmt #%d, %u bytes per line, phys 0x%x, type %d, state %d\n",
+		"%s(): fmt #%d, %u bytes per line, phys %pad, type %d, state %d\n",
 		__func__, vou_dev->pix_idx, bytes_per_line,
-		videobuf_to_dma_contig(vb), vb->memory, vb->state);
+		({ dma_addr_t addr = videobuf_to_dma_contig(vb); &addr; }),
+		vb->memory, vb->state);
 
 	return 0;
 }
-- 
Regards,

Laurent Pinchart

