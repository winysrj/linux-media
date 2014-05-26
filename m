Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37485 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaEZOTB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 10:19:01 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] videobuf2: call __verify_length only for MMAP and USERPTR memory
Date: Mon, 26 May 2014 16:18:54 +0200
Message-Id: <1401113934-29601-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For DMABUF memory, buffer length is allowed to be zero on QBUF because the
actual buffer size can be taken from the DMABUF. Therefore, the length check
can only be done later in __qbuf_dmabuf, once the dmabuf was obtained.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/videobuf2-core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f9059bb..434bdff 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1374,6 +1374,15 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		if (planes[plane].length == 0)
 			planes[plane].length = dbuf->size;
 
+		/* verify that the bytesused value fits in the plane length and
+		 * that the data offset doesn't exceed the bytesused value.
+		 */
+		if ((planes[plane].bytesused > planes[plane].length) ||
+		    (planes[plane].data_offset >= planes[plane].bytesused)) {
+			ret = -EINVAL;
+			goto err;
+		}
+
 		if (planes[plane].length < planes[plane].data_offset +
 		    q->plane_sizes[plane]) {
 			dprintk(1, "qbuf: invalid dmabuf length for plane %d\n",
@@ -1488,9 +1497,10 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	struct rw_semaphore *mmap_sem;
-	int ret;
+	int ret = 0;
 
-	ret = __verify_length(vb, b);
+	if (q->memory != V4L2_MEMORY_DMABUF)
+		ret = __verify_length(vb, b);
 	if (ret < 0) {
 		dprintk(1, "%s(): plane parameters verification failed: %d\n",
 			__func__, ret);
@@ -1529,6 +1539,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		up_read(mmap_sem);
 		break;
 	case V4L2_MEMORY_DMABUF:
+		/* __qbuf_dmabuf verifies buffer length itself */
 		ret = __qbuf_dmabuf(vb, b);
 		break;
 	default:
-- 
2.0.0.rc2

