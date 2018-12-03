Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:60647 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbeLCMrD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 07:47:03 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 3/3] vivid: add buf_validate callback
Date: Mon,  3 Dec 2018 13:46:03 +0100
Message-Id: <20181203124603.17932-3-hverkuil-cisco@xs4all.nl>
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
 drivers/media/platform/vivid/vivid-vid-out.c | 23 ++++++++++++++------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 7642cbdb0e14..3e93dbbb4ffe 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -81,10 +81,24 @@ static int vid_out_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int vid_out_buf_prepare(struct vb2_buffer *vb)
+static int vid_out_buf_validate(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	if (dev->field_out != V4L2_FIELD_ALTERNATE)
+		vbuf->field = dev->field_out;
+	else if (vbuf->field != V4L2_FIELD_TOP &&
+		 vbuf->field != V4L2_FIELD_BOTTOM)
+		return -EINVAL;
+	return 0;
+}
+
+static int vid_out_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size;
 	unsigned planes;
 	unsigned p;
@@ -105,12 +119,6 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	if (dev->field_out != V4L2_FIELD_ALTERNATE)
-		vbuf->field = dev->field_out;
-	else if (vbuf->field != V4L2_FIELD_TOP &&
-		 vbuf->field != V4L2_FIELD_BOTTOM)
-		return -EINVAL;
-
 	for (p = 0; p < planes; p++) {
 		size = dev->bytesperline_out[p] * dev->fmt_out_rect.height +
 			vb->planes[p].data_offset;
@@ -190,6 +198,7 @@ static void vid_out_buf_request_complete(struct vb2_buffer *vb)
 
 const struct vb2_ops vivid_vid_out_qops = {
 	.queue_setup		= vid_out_queue_setup,
+	.buf_validate		= vid_out_buf_validate,
 	.buf_prepare		= vid_out_buf_prepare,
 	.buf_queue		= vid_out_buf_queue,
 	.start_streaming	= vid_out_start_streaming,
-- 
2.19.1
