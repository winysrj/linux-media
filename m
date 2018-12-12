Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C52C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6C5B2084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6C5B2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbeLLMjG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:39:06 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:54395 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727382AbeLLMjG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 07:39:06 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id X3n3gidc5uDWoX3n6gHoWw; Wed, 12 Dec 2018 13:39:04 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv5 6/8] vb2: add vb2_find_timestamp()
Date:   Wed, 12 Dec 2018 13:38:59 +0100
Message-Id: <20181212123901.34109-7-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDHd6ERTK7RM32mc/MX3BgW/wGw99H95hHfgKIRdh3CyUZZovlctbVhEYqH7W2vjqq7A32lp9ID7ZyLat76rU2FrjlMNCfqCnh+kJMKTiQeb1PVI7zxb
 zCjex5ZMBOIRzEk5cOr33huvyXZNtxNxQKETKmFhfYyypwSd6iHPPjr24HSEkeFh5ez2HHbifQuMLB8GBWouJ6nS0ID757dnDHN9G4rcsx9vAI8HahNMuXaM
 WAzGSqjB/qWw/P8pS4Re8djKKqKJkeajEqwU09haqaFijTb9/vqz1kg8nZMigom+hV1mEtfgjLZfYHp/HmkimZl1ED9XFbdzNAb14x5Zyf7A8XhtQjFby1CV
 JxmtVLaN5pTNu4NN0yzNGR1UouOM0TgvfA5OD4DcuFFk+A0mIDOXQAH4gnFo/oK/gUKvSUqQdlvP1jTjrN7MaNiara5XVZVTC1T3bjlwBiFHEZG49yc=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Use v4l2_timeval_to_ns instead of timeval_to_ns to ensure that
both kernelspace and userspace will use the same conversion
function.

Next add a new vb2_find_timestamp() function to find buffers
with a specific timestamp.

This function will only look at DEQUEUED and DONE buffers, i.e.
buffers that are already processed.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 .../media/common/videobuf2/videobuf2-v4l2.c   | 22 +++++++++++++++++--
 include/media/videobuf2-v4l2.h                | 19 +++++++++++++++-
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 1244c246d0c4..8d1231c2da65 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -143,7 +143,7 @@ static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 		 * and the timecode field and flag if needed.
 		 */
 		if (q->copy_timestamp)
-			vb->timestamp = timeval_to_ns(&b->timestamp);
+			vb->timestamp = v4l2_timeval_to_ns(&b->timestamp);
 		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
 		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
 			vbuf->timecode = b->timecode;
@@ -460,7 +460,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->flags = vbuf->flags;
 	b->field = vbuf->field;
 	b->timestamp = ns_to_timeval(vb->timestamp);
-	b->timecode = vbuf->timecode;
+	if (b->flags & V4L2_BUF_FLAG_TIMECODE)
+		b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
 	b->reserved2 = 0;
 	b->request_fd = 0;
@@ -586,6 +587,23 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
 	.copy_timestamp		= __copy_timestamp,
 };
 
+int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
+		       unsigned int start_idx)
+{
+	unsigned int i;
+
+	for (i = start_idx; i < q->num_buffers; i++) {
+		struct vb2_buffer *vb = q->bufs[i];
+
+		if ((vb->state == VB2_BUF_STATE_DEQUEUED ||
+		     vb->state == VB2_BUF_STATE_DONE) &&
+		    vb->timestamp == timestamp)
+			return i;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(vb2_find_timestamp);
+
 /*
  * vb2_querybuf() - query video buffer information
  * @q:		videobuf queue
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 727855463838..80f1afa0edad 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -32,7 +32,7 @@
  *		&enum v4l2_field.
  * @timecode:	frame timecode.
  * @sequence:	sequence count of this frame.
- * @request_fd:	the request_fd associated with this buffer
+ * @request_fd:	the request_fd associated with this buffer.
  * @planes:	plane information (userptr/fd, length, bytesused, data_offset).
  *
  * Should contain enough information to be able to cover all the fields
@@ -55,6 +55,23 @@ struct vb2_v4l2_buffer {
 #define to_vb2_v4l2_buffer(vb) \
 	container_of(vb, struct vb2_v4l2_buffer, vb2_buf)
 
+/**
+ * vb2_find_timestamp() - Find buffer with given timestamp in the queue
+ *
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @timestamp:	the timestamp to find. Only buffers in state DEQUEUED or DONE
+ *		are considered.
+ * @start_idx:	the start index (usually 0) in the buffer array to start
+ *		searching from. Note that there may be multiple buffers
+ *		with the same timestamp value, so you can restart the search
+ *		by setting @start_idx to the previously found index + 1.
+ *
+ * Returns the buffer index of the buffer with the given @timestamp, or
+ * -1 if no buffer with @timestamp was found.
+ */
+int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
+		       unsigned int start_idx);
+
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
 
 /**
-- 
2.19.2

