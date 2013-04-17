Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3539 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965910Ab3DQHEX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 03:04:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [REVIEW PATCH for v3.10] mem2mem_testdev: set timestamp_type and add debug param
Date: Wed, 17 Apr 2013 09:04:10 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304170904.10783.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While testing v4l2-ctl I noticed that this m2m driver didn't set timestamp_type
and that it spammed the kernel log with debug messages. Set timestamp_type
correctly and add debug module option to enable debug messages.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 7487d72..4cc7f65d 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -38,6 +38,10 @@ MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1.1");
 
+static unsigned debug;
+module_param(debug, uint, 0644);
+MODULE_PARM_DESC(debug, "activates debug info");
+
 #define MIN_W 32
 #define MIN_H 32
 #define MAX_W 640
@@ -67,7 +71,7 @@ MODULE_VERSION("0.1.1");
 #define MEM2MEM_VFLIP	(1 << 1)
 
 #define dprintk(dev, fmt, arg...) \
-	v4l2_dbg(1, 1, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
+	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
 
 
 static void m2mtest_dev_release(struct device *dev)
@@ -234,6 +238,10 @@ static int device_process(struct m2mtest_ctx *ctx,
 	bytes_left = bytesperline - tile_w * MEM2MEM_NUM_TILES;
 	w = 0;
 
+	memcpy(&out_vb->v4l2_buf.timestamp,
+			&in_vb->v4l2_buf.timestamp,
+			sizeof(struct timeval));
+
 	switch (ctx->mode) {
 	case MEM2MEM_HFLIP | MEM2MEM_VFLIP:
 		p_out += bytesperline * height - bytes_left;
@@ -844,6 +852,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &m2mtest_qops;
 	src_vq->mem_ops = &vb2_vmalloc_memops;
+	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -855,6 +864,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &m2mtest_qops;
 	dst_vq->mem_ops = &vb2_vmalloc_memops;
+	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	return vb2_queue_init(dst_vq);
 }
