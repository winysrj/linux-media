Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43563 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2HNJ3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 05:29:47 -0400
Received: from eusync3.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8Q00F23NQD0X70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 10:30:13 +0100 (BST)
Received: from localhost.localdomain ([106.116.147.88])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M8Q00EHONPECH60@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 10:29:45 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] v4l/s5p-mfc: added DMABUF support for encoder
Date: Tue, 14 Aug 2012 11:29:33 +0200
Message-id: <1344936573-8164-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Patch cleanly applies after patch
http://patchwork.linuxtv.org/patch/13797/
---
 drivers/media/video/s5p-mfc/s5p_mfc.c     |    4 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index e5c2b80..ab7b74c 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -801,7 +801,7 @@ static int s5p_mfc_open(struct file *file)
 		q->io_modes = VB2_MMAP;
 		q->ops = get_dec_queue_ops();
 	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
-		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 		q->ops = get_enc_queue_ops();
 	} else {
 		ret = -ENOENT;
@@ -822,7 +822,7 @@ static int s5p_mfc_open(struct file *file)
 		q->io_modes = VB2_MMAP;
 		q->ops = get_dec_queue_ops();
 	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
-		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 		q->ops = get_enc_queue_ops();
 	} else {
 		ret = -ENOENT;
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index 53c305d..b1a5f85 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1028,7 +1028,8 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 
 	/* if memory is not mmp or userptr return error */
 	if ((reqbufs->memory != V4L2_MEMORY_MMAP) &&
-		(reqbufs->memory != V4L2_MEMORY_USERPTR))
+		(reqbufs->memory != V4L2_MEMORY_USERPTR) &&
+		(reqbufs->memory != V4L2_MEMORY_DMABUF))
 		return -EINVAL;
 	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		if (ctx->capture_state != QUEUE_FREE) {
-- 
1.7.0.4

