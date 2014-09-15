Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:35718 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaIOGsV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:48:21 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00995K8KGSA0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:48:20 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 06/17] [media] s5p-mfc: Only set timestamp/timecode for new
 frames.
Date: Mon, 15 Sep 2014 12:13:01 +0530
Message-id: <1410763393-12183-7-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ilja Friedel <ihf@chromium.org>

Timestamp i of a previously decoded buffer was overwritten for some
H.264 streams with timestamp i+1 of the next buffer. This happened when
encountering frame_type S5P_FIMV_DECODE_FRAME_SKIPPED, indicating no
new frame.

In most cases this wrong indexing might not have been noticed except
for a one frame delay in frame presentation. For H.264 streams though
that require reordering of frames for presentation, it caused a slightly
erratic presentation time lookup and consequently dropped frames in the
Pepper Flash plugin.

Signed-off-by: Ilja H. Friedel <ihf@google.com>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 9df130b..4ab3b53 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -227,11 +227,14 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 	size_t dec_y_addr;
 	unsigned int frame_type;
 
-	dec_y_addr = s5p_mfc_hw_call(dev->mfc_ops, get_dec_y_adr, dev);
+	/* Make sure we actually have a new frame before continuing. */
 	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_dec_frame_type, dev);
+	if (frame_type == S5P_FIMV_DECODE_FRAME_SKIPPED)
+		return;
+	dec_y_addr = s5p_mfc_hw_call(dev->mfc_ops, get_dec_y_adr, dev);
 
 	/* Copy timestamp / timecode from decoded src to dst and set
-	   appropriate flags */
+	   appropriate flags. */
 	src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
 		if (vb2_dma_contig_plane_dma_addr(dst_buf->b, 0) == dec_y_addr) {
@@ -257,6 +260,11 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 				dst_buf->b->v4l2_buf.flags |=
 						V4L2_BUF_FLAG_BFRAME;
 				break;
+			default:
+				/* Don't know how to handle
+				   S5P_FIMV_DECODE_FRAME_OTHER_FRAME. */
+				mfc_debug(2, "Unexpected frame type: %d\n",
+						frame_type);
 			}
 			break;
 		}
-- 
1.7.3.rc2

