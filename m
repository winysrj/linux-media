Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4083 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaBYKQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 10/13] mem2mem_testdev: add USERPTR support.
Date: Tue, 25 Feb 2014 11:16:00 +0100
Message-Id: <1393323363-30058-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There is no reason why we shouldn't enable this here.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 0745d1a..8ca828a 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -779,7 +779,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	int ret;
 
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	src_vq->drv_priv = ctx;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &m2mtest_qops;
@@ -792,7 +792,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 		return ret;
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	dst_vq->drv_priv = ctx;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &m2mtest_qops;
-- 
1.9.0

