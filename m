Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35890 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934701AbeFOTII (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 15:08:08 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 10/17] mx_emmaprp: Implement wait_prepare and wait_finish
Date: Fri, 15 Jun 2018 16:07:30 -0300
Message-Id: <20180615190737.24139-11-ezequiel@collabora.com>
In-Reply-To: <20180615190737.24139-1-ezequiel@collabora.com>
References: <20180615190737.24139-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is currently specifying a video_device lock,
which means it is protecting all the ioctls (including
queue ioctls) with a single mutex.

It's therefore straightforward to implement wait_prepare
and wait_finish, by explicitly setting the vb2_queue lock.

Having these callbacks releases the queue lock while blocking,
which improves latency by allowing for example streamoff
or qbuf operations while waiting in dqbuf.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/mx2_emmaprp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 5a8eff60e95f..7f9b356e7cc7 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -747,6 +747,8 @@ static const struct vb2_ops emmaprp_qops = {
 	.queue_setup	 = emmaprp_queue_setup,
 	.buf_prepare	 = emmaprp_buf_prepare,
 	.buf_queue	 = emmaprp_buf_queue,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
@@ -763,6 +765,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->dev = ctx->dev->v4l2_dev.dev;
+	src_vq->lock = &ctx->dev->dev_mutex;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -776,6 +779,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->dev = ctx->dev->v4l2_dev.dev;
+	dst_vq->lock = &ctx->dev->dev_mutex;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.17.1
