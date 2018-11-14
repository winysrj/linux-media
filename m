Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:39639 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733121AbeKNXvK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 18:51:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 7/9] vim2m: add tag support
Date: Wed, 14 Nov 2018 14:47:41 +0100
Message-Id: <20181114134743.18993-8-hverkuil@xs4all.nl>
In-Reply-To: <20181114134743.18993-1-hverkuil@xs4all.nl>
References: <20181114134743.18993-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Copy tags in vim2m.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vim2m.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d82db738f174..9d1222f489b8 100644
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
@@ -856,6 +846,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->dev->dev_mutex;
 	src_vq->supports_requests = true;
+	src_vq->supports_tags = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -869,6 +860,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	dst_vq->mem_ops = &vb2_vmalloc_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->dev->dev_mutex;
+	dst_vq->supports_tags = true;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.19.1
