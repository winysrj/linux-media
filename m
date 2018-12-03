Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:56628 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbeLCMrD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 07:47:03 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 2/3] vim2m: add buf_validate callback
Date: Mon,  3 Dec 2018 13:46:02 +0100
Message-Id: <20181203124603.17932-2-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181203124603.17932-1-hverkuil-cisco@xs4all.nl>
References: <20181203124603.17932-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Split off the field validation from buf_prepare into a new
buf_validate function. Field validation for output buffers should
be done there since buf_prepare is not guaranteed to be called at
QBUF time.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vim2m.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d01821a6906a..9559be91daca 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -753,15 +753,13 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int vim2m_buf_prepare(struct vb2_buffer *vb)
+static int vim2m_buf_validate(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct vim2m_q_data *q_data;
 
 	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
 
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
 	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
 		if (vbuf->field == V4L2_FIELD_ANY)
 			vbuf->field = V4L2_FIELD_NONE;
@@ -772,6 +770,17 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 		}
 	}
 
+	return 0;
+}
+
+static int vim2m_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vim2m_q_data *q_data;
+
+	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
+
+	q_data = get_q_data(ctx, vb->vb2_queue->type);
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
 		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
 				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
@@ -832,6 +841,7 @@ static void vim2m_buf_request_complete(struct vb2_buffer *vb)
 
 static const struct vb2_ops vim2m_qops = {
 	.queue_setup	 = vim2m_queue_setup,
+	.buf_validate	 = vim2m_buf_validate,
 	.buf_prepare	 = vim2m_buf_prepare,
 	.buf_queue	 = vim2m_buf_queue,
 	.start_streaming = vim2m_start_streaming,
-- 
2.19.1
