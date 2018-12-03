Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38682 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbeLCNw6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 08:52:58 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv3 8/9] vicodec: add tag support
Date: Mon,  3 Dec 2018 14:51:42 +0100
Message-Id: <20181203135143.45487-9-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
References: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Copy tags in vicodec.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/vicodec/vicodec-core.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index b7bdfe97215b..4d39ea033653 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -190,18 +190,8 @@ static int device_process(struct vicodec_ctx *ctx,
 	}
 
 	out_vb->sequence = q_cap->sequence++;
-	out_vb->vb2_buf.timestamp = in_vb->vb2_buf.timestamp;
-
-	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
-		out_vb->timecode = in_vb->timecode;
-	out_vb->field = in_vb->field;
 	out_vb->flags &= ~V4L2_BUF_FLAG_LAST;
-	out_vb->flags |= in_vb->flags &
-		(V4L2_BUF_FLAG_TIMECODE |
-		 V4L2_BUF_FLAG_KEYFRAME |
-		 V4L2_BUF_FLAG_PFRAME |
-		 V4L2_BUF_FLAG_BFRAME |
-		 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
+	v4l2_m2m_buf_copy_data(in_vb, out_vb, !ctx->is_enc);
 
 	return 0;
 }
@@ -1083,6 +1073,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = ctx->is_enc ? &ctx->dev->enc_mutex :
 		&ctx->dev->dec_mutex;
+	src_vq->supports_tags = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -1098,6 +1089,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_vmalloc_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = src_vq->lock;
+	dst_vq->supports_tags = true;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.19.1
