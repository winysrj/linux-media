Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3223 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaDKIMP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 04:12:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 13/13] v4l2-pci-skeleton.c: fix alternate field handling.
Date: Fri, 11 Apr 2014 10:11:19 +0200
Message-Id: <1397203879-37443-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For interlaced HDTV timings the correct field setting is FIELD_ALTERNATE,
not INTERLACED. Update this template driver accordingly:

- add check for the invalid combination of read() and FIELD_ALTERNATE.
- in the interrupt handler set v4l2_buffer field to alternating TOP and
  BOTTOM.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c | 39 +++++++++++++++++++--------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 54eca2b..53dd346 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -77,7 +77,8 @@ struct skeleton {
 
 	spinlock_t qlock;
 	struct list_head buf_list;
-	unsigned int sequence;
+	unsigned field;
+	unsigned sequence;
 };
 
 struct skel_buffer {
@@ -124,7 +125,7 @@ static const struct v4l2_dv_timings_cap skel_timings_cap = {
  * Interrupt handler: typically interrupts happen after a new frame has been
  * captured. It is the job of the handler to remove the new frame from the
  * internal list and give it back to the vb2 framework, updating the sequence
- * counter and timestamp at the same time.
+ * counter, field and timestamp at the same time.
  */
 static irqreturn_t skeleton_irq(int irq, void *dev_id)
 {
@@ -139,8 +140,15 @@ static irqreturn_t skeleton_irq(int irq, void *dev_id)
 		spin_lock(&skel->qlock);
 		list_del(&new_buf->list);
 		spin_unlock(&skel->qlock);
-		new_buf->vb.v4l2_buf.sequence = skel->sequence++;
 		v4l2_get_timestamp(&new_buf->vb.v4l2_buf.timestamp);
+		new_buf->vb.v4l2_buf.sequence = skel->sequence++;
+		new_buf->vb.v4l2_buf.field = skel->field;
+		if (skel->format.field == V4L2_FIELD_ALTERNATE) {
+			if (skel->field == V4L2_FIELD_BOTTOM)
+				skel->field = V4L2_FIELD_TOP;
+			else if (skel->field == V4L2_FIELD_TOP)
+				skel->field = V4L2_FIELD_BOTTOM;
+		}
 		vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_DONE);
 	}
 #endif
@@ -160,6 +168,17 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 {
 	struct skeleton *skel = vb2_get_drv_priv(vq);
 
+	skel->field = skel->format.field;
+	if (skel->field == V4L2_FIELD_ALTERNATE) {
+		/*
+		 * You cannot use read() with FIELD_ALTERNATE since the field
+		 * information (TOP/BOTTOM) cannot be passed back to the user.
+		 */
+		if (vb2_fileio_is_active(q))
+			return -EINVAL;
+		skel->field = V4L2_FIELD_TOP;
+	}
+
 	if (vq->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - vq->num_buffers;
 
@@ -173,10 +192,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 /*
  * Prepare the buffer for queueing to the DMA engine: check and set the
- * payload size and fill in the field. Note: if the format's field is
- * V4L2_FIELD_ALTERNATE, then vb->v4l2_buf.field should be set in the
- * interrupt handler since that's usually where you know if the TOP or
- * BOTTOM field has been captured.
+ * payload size.
  */
 static int buffer_prepare(struct vb2_buffer *vb)
 {
@@ -190,7 +206,6 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	}
 
 	vb2_set_plane_payload(vb, 0, size);
-	vb->v4l2_buf.field = skel->format.field;
 	return 0;
 }
 
@@ -318,10 +333,12 @@ static void skeleton_fill_pix_format(struct skeleton *skel,
 		/* HDMI input */
 		pix->width = skel->timings.bt.width;
 		pix->height = skel->timings.bt.height;
-		if (skel->timings.bt.interlaced)
-			pix->field = V4L2_FIELD_INTERLACED;
-		else
+		if (skel->timings.bt.interlaced) {
+			pix->field = V4L2_FIELD_ALTERNATE;
+			pix->height /= 2;
+		} else {
 			pix->field = V4L2_FIELD_NONE;
+		}
 		pix->colorspace = V4L2_COLORSPACE_REC709;
 	}
 
-- 
1.9.1

