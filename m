Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53546 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbbFOLeD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:34:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/14] sh-veu: initialize timestamp_flags and copy timestamp info
Date: Mon, 15 Jun 2015 13:33:28 +0200
Message-Id: <1434368021-7467-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This field wasn't set, causing WARN_ON's from the vb2 core.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_veu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 2554f37..77a74d3 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -958,6 +958,7 @@ static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &sh_veu_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->lock = &veu->fop_lock;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret < 0)
@@ -971,6 +972,7 @@ static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &sh_veu_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->lock = &veu->fop_lock;
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -1103,6 +1105,12 @@ static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 	if (!src || !dst)
 		return IRQ_NONE;
 
+	dst->v4l2_buf.timestamp = src->v4l2_buf.timestamp;
+	dst->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->v4l2_buf.flags |=
+		src->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->v4l2_buf.timecode = src->v4l2_buf.timecode;
+
 	spin_lock(&veu->lock);
 	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
-- 
2.1.4

