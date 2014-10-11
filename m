Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1025 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaJKJXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Oct 2014 05:23:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 02/10] vb2-dma-contig: sync mem for cpu after mapping
Date: Sat, 11 Oct 2014 11:22:29 +0200
Message-Id: <1413019357-12382-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1413019357-12382-1-git-send-email-hverkuil@xs4all.nl>
References: <1413019357-12382-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The driver might touch the data after mapping in buf_prepare, so make sure it
is synced for cpu.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 4a02ade..dd39651 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -666,6 +666,12 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		goto fail_map_sg;
 	}
 
+	/*
+	 * After mapping the buffer we have to sync it for cpu since the
+	 * buf_prepare() callback might need to access/modify the buffer.
+	 */
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+
 	buf->dma_addr = sg_dma_address(sgt->sgl);
 	buf->size = size;
 	buf->dma_sgt = sgt;
-- 
2.1.1

