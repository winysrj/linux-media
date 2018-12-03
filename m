Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:51384 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725990AbeLCNw6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 08:52:58 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv3 7/9] vim2m: add tag support
Date: Mon,  3 Dec 2018 14:51:41 +0100
Message-Id: <20181203135143.45487-8-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
References: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Copy tags in vim2m.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/vim2m.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d01821a6906a..be328483a53a 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -241,17 +241,7 @@ static int device_process(struct vim2m_ctx *ctx,
 	out_vb->sequence =
 		get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
 	in_vb->sequence = q_data->sequence++;
-	out_vb->vb2_buf.timestamp = in_vb->vb2_buf.timestamp;
-
-	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
-		out_vb->timecode = in_vb->timecode;
-	out_vb->field = in_vb->field;
-	out_vb->flags = in_vb->flags &
-		(V4L2_BUF_FLAG_TIMECODE |
-		 V4L2_BUF_FLAG_KEYFRAME |
-		 V4L2_BUF_FLAG_PFRAME |
-		 V4L2_BUF_FLAG_BFRAME |
-		 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
+	v4l2_m2m_buf_copy_data(out_vb, in_vb, true);
 
 	switch (ctx->mode) {
 	case MEM2MEM_HFLIP | MEM2MEM_VFLIP:
@@ -855,6 +845,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->dev->dev_mutex;
 	src_vq->supports_requests = true;
+	src_vq->supports_tags = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -868,6 +859,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	dst_vq->mem_ops = &vb2_vmalloc_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->dev->dev_mutex;
+	dst_vq->supports_tags = true;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.19.1
