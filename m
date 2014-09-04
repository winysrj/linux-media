Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:27883 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010AbaIDCcE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 22:32:04 -0400
From: Zhaowei Yuan <zhaowei.yuan@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	m.chehab@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com
Cc: linux-samsung-soc@vger.kernel.org
Subject: [PATCH] [media] s5p_mfc: correct the loop condition
Date: Thu, 04 Sep 2014 10:28:06 +0800
Message-id: <1409797686-2638-1-git-send-email-zhaowei.yuan@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It should take ctx->dst_fmt->num_planes as
the loop condition for CAPTURE.

Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 9103258..af367c3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -990,7 +990,7 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		if (ctx->capture_state == QUEUE_BUFS_MMAPED)
 			return 0;
-		for (i = 0; i <= ctx->src_fmt->num_planes ; i++) {
+		for (i = 0; i < ctx->dst_fmt->num_planes; i++) {
 			if (IS_ERR_OR_NULL(ERR_PTR(
 					vb2_dma_contig_plane_dma_addr(vb, i)))) {
 				mfc_err("Plane mem not allocated\n");
--
1.7.9.5

