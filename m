Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39364 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbbCXRq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 13:46:59 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 4/4] [media] s5p-mfc: Set last buffer flag
Date: Tue, 24 Mar 2015 18:46:54 +0100
Message-Id: <1427219214-5368-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427219214-5368-1-git-send-email-p.zabel@pengutronix.de>
References: <1427219214-5368-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting the last buffer flag causes the videobuf2 core to return -EPIPE from
DQBUF calls on the capture queue after the last buffer is dequeued.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8e44a59..f08d639 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -211,6 +211,7 @@ static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 			dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
 		else
 			dst_buf->b->v4l2_buf.field = V4L2_FIELD_INTERLACED;
+		dst_buf->b->v4l2_buf.flags |= V4L2_BUF_FLAG_LAST;
 
 		ctx->dec_dst_flag &= ~(1 << dst_buf->b->v4l2_buf.index);
 		vb2_buffer_done(dst_buf->b, VB2_BUF_STATE_DONE);
-- 
2.1.4

