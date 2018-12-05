Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_RHS_DOB,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68910C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39F732082B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39F732082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbeLEKUu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:20:50 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39796 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727504AbeLEKUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 05:20:50 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id UUIKgznz1aOW5UUIRgJehs; Wed, 05 Dec 2018 11:20:47 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 02/10] vb2: add tag support
Date:   Wed,  5 Dec 2018 11:20:32 +0100
Message-Id: <20181205102040.11741-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfG3mIdY9eUAC3AkQ/eMG8VEtMpbIDQ7PH0bCQimHkJPpmxn55UspX/xgNkNrKz3PlGEVDLEtVBPjULh3fPVihksOMrWPGClue40r5aJDgGozbcx77qni
 7Cb24q4jjsNTlGVr4d4dD9JciPx7fybVNtz6iI5nXxJmM4uUtfEyxAw3b4sMUt0iH551uVagb399UAQgwjN3cPRCLKMm9x38SEuiMVccI+o5Eo5P7k+9+H0n
 GwUV7eJbc3fO5ZkaM7ZidMwelFbNeS7ru4HASO4U9drOJFpRRdIjx29HUViGenooxUsn2lDtvgt20ueOfAoHEL7FkfM/3BI1OO4EReW6jk13Cj+KmBj9+Ny8
 GEIe8k9D7+kyqsgWBBtltymviq5VFQ4Z04eDe4Ji/PAQUlv7/op1uH/apkSU3xj0j/W6ZuQZVpG+Y7y8ftM1C9/PcLeU/Q==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Add support for tags to vb2. Besides just storing and setting
the tag this patch also adds the vb2_find_tag() function that
can be used to find a buffer with the given tag.

This function will only look at DEQUEUED and DONE buffers, i.e.
buffers that are already processed.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 .../media/common/videobuf2/videobuf2-v4l2.c   | 39 ++++++++++++++++---
 include/media/videobuf2-v4l2.h                | 21 +++++++++-
 2 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 1244c246d0c4..e0e31e1c67c9 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -50,7 +50,8 @@ module_param(debug, int, 0644);
 				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
 /* Output buffer flags that should be passed on to the driver */
 #define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
-				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
+				 V4L2_BUF_FLAG_KEYFRAME | \
+				 V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_TAG)
 
 /*
  * __verify_planes_array() - verify that the planes array passed in struct
@@ -144,7 +145,10 @@ static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 		 */
 		if (q->copy_timestamp)
 			vb->timestamp = timeval_to_ns(&b->timestamp);
-		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
+		vbuf->flags |= b->flags &
+			(V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_TAG);
+		if (b->flags & V4L2_BUF_FLAG_TAG)
+			vbuf->tag = b->tag;
 		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
 			vbuf->timecode = b->timecode;
 	}
@@ -194,6 +198,7 @@ static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b
 	}
 	vbuf->sequence = 0;
 	vbuf->request_fd = -1;
+	vbuf->tag = 0;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		switch (b->memory) {
@@ -314,12 +319,12 @@ static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b
 
 	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
-		 * For output buffers mask out the timecode flag:
-		 * this will be handled later in vb2_qbuf().
+		 * For output buffers mask out the timecode and tag flags:
+		 * these will be handled later in vb2_qbuf().
 		 * The 'field' is valid metadata for this output buffer
 		 * and so that needs to be copied here.
 		 */
-		vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
+		vbuf->flags &= ~(V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_TAG);
 		vbuf->field = b->field;
 	} else {
 		/* Zero any output buffer flags as this is a capture buffer */
@@ -460,7 +465,10 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->flags = vbuf->flags;
 	b->field = vbuf->field;
 	b->timestamp = ns_to_timeval(vb->timestamp);
-	b->timecode = vbuf->timecode;
+	if (b->flags & V4L2_BUF_FLAG_TAG)
+		b->tag = vbuf->tag;
+	if (b->flags & V4L2_BUF_FLAG_TIMECODE)
+		b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
 	b->reserved2 = 0;
 	b->request_fd = 0;
@@ -586,6 +594,25 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
 	.copy_timestamp		= __copy_timestamp,
 };
 
+int vb2_find_tag(const struct vb2_queue *q, u32 tag,
+		 unsigned int start_idx)
+{
+	unsigned int i;
+
+	for (i = start_idx; i < q->num_buffers; i++) {
+		struct vb2_buffer *vb = q->bufs[i];
+		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+		if ((vb->state == VB2_BUF_STATE_DEQUEUED ||
+		     vb->state == VB2_BUF_STATE_DONE) &&
+		    (vbuf->flags & V4L2_BUF_FLAG_TAG) &&
+		    vbuf->tag == tag)
+			return i;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(vb2_find_tag);
+
 /*
  * vb2_querybuf() - query video buffer information
  * @q:		videobuf queue
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 727855463838..c2a541af6b2c 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -31,8 +31,9 @@
  * @field:	field order of the image in the buffer, as defined by
  *		&enum v4l2_field.
  * @timecode:	frame timecode.
+ * @tag:	user specified buffer tag value.
  * @sequence:	sequence count of this frame.
- * @request_fd:	the request_fd associated with this buffer
+ * @request_fd:	the request_fd associated with this buffer.
  * @planes:	plane information (userptr/fd, length, bytesused, data_offset).
  *
  * Should contain enough information to be able to cover all the fields
@@ -44,6 +45,7 @@ struct vb2_v4l2_buffer {
 	__u32			flags;
 	__u32			field;
 	struct v4l2_timecode	timecode;
+	__u32			tag;
 	__u32			sequence;
 	__s32			request_fd;
 	struct vb2_plane	planes[VB2_MAX_PLANES];
@@ -55,6 +57,23 @@ struct vb2_v4l2_buffer {
 #define to_vb2_v4l2_buffer(vb) \
 	container_of(vb, struct vb2_v4l2_buffer, vb2_buf)
 
+/**
+ * vb2_find_tag() - Find buffer with given tag in the queue
+ *
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @tag:	the tag to find. Only buffers in state DEQUEUED or DONE
+ *		are considered.
+ * @start_idx:	the start index (usually 0) in the buffer array to start
+ *		searching from. Note that there may be multiple buffers
+ *		with the same tag value, so you can restart the search
+ *		by setting @start_idx to the previously found index + 1.
+ *
+ * Returns the buffer index of the buffer with the given @tag, or
+ * -1 if no buffer with @tag was found.
+ */
+int vb2_find_tag(const struct vb2_queue *q, u32 tag,
+		 unsigned int start_idx);
+
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
 
 /**
-- 
2.19.1

