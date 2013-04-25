Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:12472 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab3DYJuo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 05:50:44 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT005W41ZFFXL0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 18:50:43 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>
Subject: [PATCH 3/7] s5p-mfc: Optimize copy time stamp handling
Date: Thu, 25 Apr 2013 11:49:46 +0200
Message-id: <1366883390-12890-4-git-send-email-k.debski@samsung.com>
In-reply-to: <1366883390-12890-1-git-send-email-k.debski@samsung.com>
References: <1366883390-12890-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Jeongtae Park <jtp.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index e810b1a..49f2d9f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -243,12 +243,10 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 	src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
 		if (vb2_dma_contig_plane_dma_addr(dst_buf->b, 0) == dec_y_addr) {
-			memcpy(&dst_buf->b->v4l2_buf.timecode,
-				&src_buf->b->v4l2_buf.timecode,
-				sizeof(struct v4l2_timecode));
-			memcpy(&dst_buf->b->v4l2_buf.timestamp,
-				&src_buf->b->v4l2_buf.timestamp,
-				sizeof(struct timeval));
+			dst_buf->b->v4l2_buf.timecode =
+						src_buf->b->v4l2_buf.timecode;
+			dst_buf->b->v4l2_buf.timestamp =
+						src_buf->b->v4l2_buf.timestamp;
 			switch (frame_type) {
 			case S5P_FIMV_DECODE_FRAME_I_FRAME:
 				dst_buf->b->v4l2_buf.flags |=
-- 
1.7.9.5

