Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2266 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbaCJN6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 09:58:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, k.debski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 7/7] mem2mem_testdev: improve field handling
Date: Mon, 10 Mar 2014 14:58:29 +0100
Message-Id: <1394459909-36497-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394459909-36497-1-git-send-email-hverkuil@xs4all.nl>
References: <1394459909-36497-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

try_fmt should just set field to NONE and not return an error if
a different field was passed.

buf_prepare should check if the field passed in from userspace has a
supported field value. At the moment only NONE is supported and ANY
is mapped to NONE.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index dec8092..4f3096b 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -516,19 +516,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 
 static int vidioc_try_fmt(struct v4l2_format *f, struct m2mtest_fmt *fmt)
 {
-	enum v4l2_field field;
-
-	field = f->fmt.pix.field;
-
-	if (field == V4L2_FIELD_ANY)
-		field = V4L2_FIELD_NONE;
-	else if (V4L2_FIELD_NONE != field)
-		return -EINVAL;
-
 	/* V4L2 specification suggests the driver corrects the format struct
 	 * if any of the dimensions is unsupported */
-	f->fmt.pix.field = field;
-
 	if (f->fmt.pix.height < MIN_H)
 		f->fmt.pix.height = MIN_H;
 	else if (f->fmt.pix.height > MAX_H)
@@ -542,6 +531,7 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct m2mtest_fmt *fmt)
 	f->fmt.pix.width &= ~DIM_ALIGN_MASK;
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.field = V4L2_FIELD_NONE;
 	f->fmt.pix.priv = 0;
 
 	return 0;
@@ -760,6 +750,15 @@ static int m2mtest_buf_prepare(struct vb2_buffer *vb)
 	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
+	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+		if (vb->v4l2_buf.field == V4L2_FIELD_ANY)
+			vb->v4l2_buf.field = V4L2_FIELD_NONE;
+		if (vb->v4l2_buf.field != V4L2_FIELD_NONE) {
+			dprintk(ctx->dev, "%s field isn't supported\n",
+					__func__);
+			return -EINVAL;
+		}
+	}
 
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
 		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
-- 
1.9.0

