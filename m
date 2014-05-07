Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37590 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaEGLa5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 May 2014 07:30:57 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH] [media] s5p-mfc: Dequeue sequence header after STREAMON
Date: Wed,  7 May 2014 17:00:52 +0530
Message-Id: <1399462252-21821-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFCv6 encoder needs specific minimum number of buffers to
be queued in the CAPTURE plane. This minimum number will
be known only when the sequence header is generated.
So we used to allow STREAMON on the CAPTURE plane only after
sequence header is generated and checked with the minimum
buffer requirement.

But this causes a problem that we call a vb2_buffer_done
for the sequence header buffer before doing a STREAON on the
CAPTURE plane. This used to still work fine until this patch
was merged b3379c6201bb3555298cdbf0aa004af260f2a6a4.

This problem should also come in earlier MFC firmware versions
if the application calls STREAMON on CAPTURE with some delay
after doing STREAMON on OUTPUT.

So this patch keeps the header buffer until the other frame
buffers are ready and dequeues it just before the first frame
is ready.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index d64b680..4fd1034 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -523,6 +523,7 @@ struct s5p_mfc_codec_ops {
  * @output_state:	state of the output buffers queue
  * @src_bufs:		information on allocated source buffers
  * @dst_bufs:		information on allocated destination buffers
+ * @header_mb:		buf pointer of the encoded sequence header
  * @sequence:		counter for the sequence number for v4l2
  * @dec_dst_flag:	flags for buffers queued in the hardware
  * @dec_src_buf_size:	size of the buffer for source buffers in decoding
@@ -607,6 +608,7 @@ struct s5p_mfc_ctx {
 	int src_bufs_cnt;
 	struct s5p_mfc_buf dst_bufs[MFC_MAX_BUFFERS];
 	int dst_bufs_cnt;
+	struct s5p_mfc_buf *header_mb;
 
 	unsigned int sequence;
 	unsigned long dec_dst_flag;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index a9a23e1..e7dddb0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -787,7 +787,7 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 		ctx->dst_queue_cnt--;
 		vb2_set_plane_payload(dst_mb->b, 0,
 			s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev));
-		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
+		ctx->header_mb = dst_mb;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
 
@@ -845,6 +845,10 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	unsigned int strm_size;
 	unsigned long flags;
 
+	if (ctx->header_mb) {
+		vb2_buffer_done(ctx->header_mb->b, VB2_BUF_STATE_DONE);
+		ctx->header_mb = NULL;
+	}
 	slice_type = s5p_mfc_hw_call(dev->mfc_ops, get_enc_slice_type, dev);
 	strm_size = s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev);
 	mfc_debug(2, "Encoded slice type: %d\n", slice_type);
-- 
1.7.9.5

