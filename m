Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36688 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaJULHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:07:39 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	kiran@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH v3 04/13] [media] s5p-mfc: Only set timestamp/timecode for new frames.
Date: Tue, 21 Oct 2014 16:36:58 +0530
Message-Id: <1413889627-8431-5-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
References: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
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
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 79c9537..eb71055 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -220,11 +220,14 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
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
@@ -250,6 +253,11 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
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
1.7.9.5

