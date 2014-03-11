Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39706 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaCKIf2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 04:35:28 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 13/14] v4l: ti-vpe: Set correct field parameter for output and capture buffers
Date: Tue, 11 Mar 2014 14:03:52 +0530
Message-ID: <1394526833-24805-14-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-1-git-send-email-archit@ti.com>
References: <1393922965-15967-1-git-send-email-archit@ti.com>
 <1394526833-24805-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vpe driver wasn't setting the correct field parameter for dequed CAPTURE
type buffers for the case where the captured output is progressive.

Set the field to V4L2_FIELD_NONE for the completed destination buffers when
the captured output is progressive.

For OUTPUT type buffers, a queued buffer's field is forced to V4L2_FIELD_NONE
if the pixel format(configured through s_fmt for the buffer type
V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE specifies) the field type isn't interlaced.
If the pixel format specified was V4L2_FIELD_ALTERNATE, and the queued buffer's
field isn't V4L2_FIELD_TOP or V4L2_FIELD_BOTTOM, the vb2 buf_prepare op returns
an error.

This ensures compliance, and that the dequeued output and captured buffers
contain the field type that the driver used internally.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 970408a..c884910 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1296,10 +1296,10 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 		d_buf->timecode = s_buf->timecode;
 	}
 	d_buf->sequence = ctx->sequence;
-	d_buf->field = ctx->field;
 
 	d_q_data = &ctx->q_data[Q_DATA_DST];
 	if (d_q_data->flags & Q_DATA_INTERLACED) {
+		d_buf->field = ctx->field;
 		if (ctx->field == V4L2_FIELD_BOTTOM) {
 			ctx->sequence++;
 			ctx->field = V4L2_FIELD_TOP;
@@ -1308,6 +1308,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 			ctx->field = V4L2_FIELD_BOTTOM;
 		}
 	} else {
+		d_buf->field = V4L2_FIELD_NONE;
 		ctx->sequence++;
 	}
 
@@ -1871,6 +1872,16 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
 	num_planes = q_data->fmt->coplanar ? 2 : 1;
 
+	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (!(q_data->flags & Q_DATA_INTERLACED)) {
+			vb->v4l2_buf.field = V4L2_FIELD_NONE;
+		} else {
+			if (vb->v4l2_buf.field != V4L2_FIELD_TOP ||
+					vb->v4l2_buf.field != V4L2_FIELD_BOTTOM)
+				return -EINVAL;
+		}
+	}
+
 	for (i = 0; i < num_planes; i++) {
 		if (vb2_plane_size(vb, i) < q_data->sizeimage[i]) {
 			vpe_err(ctx->dev,
-- 
1.8.3.2

