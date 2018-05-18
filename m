Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33448 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752128AbeERSyJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 14:54:09 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 15/20] m2m-deinterlace: Implement wait_prepare and wait_finish
Date: Fri, 18 May 2018 15:52:03 -0300
Message-Id: <20180518185208.17722-16-ezequiel@collabora.com>
In-Reply-To: <20180518185208.17722-1-ezequiel@collabora.com>
References: <20180518185208.17722-1-ezequiel@collabora.com>
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
 drivers/media/platform/m2m-deinterlace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 1e4195144f39..94dd8ec0f265 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -856,6 +856,8 @@ static const struct vb2_ops deinterlace_qops = {
 	.queue_setup	 = deinterlace_queue_setup,
 	.buf_prepare	 = deinterlace_buf_prepare,
 	.buf_queue	 = deinterlace_buf_queue,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
@@ -872,6 +874,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->dev = ctx->dev->v4l2_dev.dev;
+	src_vq->lock = &ctx->dev->dev_mutex;
 	q_data[V4L2_M2M_SRC].fmt = &formats[0];
 	q_data[V4L2_M2M_SRC].width = 640;
 	q_data[V4L2_M2M_SRC].height = 480;
@@ -890,6 +893,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->dev = ctx->dev->v4l2_dev.dev;
+	dst_vq->lock = &ctx->dev->dev_mutex;
 	q_data[V4L2_M2M_DST].fmt = &formats[0];
 	q_data[V4L2_M2M_DST].width = 640;
 	q_data[V4L2_M2M_DST].height = 480;
-- 
2.16.3
