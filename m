Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4402DC43613
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D854217D4
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfAGLeu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:34:50 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:46212 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727025AbfAGLes (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:34:48 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gTB4gFRVhBDyIgTB8gNVGw; Mon, 07 Jan 2019 12:34:46 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv6 6/8] vb2: add vb2_find_timestamp()
Date:   Mon,  7 Jan 2019 12:34:39 +0100
Message-Id: <20190107113441.21569-7-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
References: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfCjeMOvf+KPq2SN08QQfqMB40uPoMr67uJG9k85tQ3R4NRmBt5/LrAa+muRz7CHkIv4KbpVduYj/tu52c0iILKo7c6VG3tDuZgzuEb0an6OWKxmORBmo
 IsmMnd5Rc8M3Baxu9MRucDOaJQ4OenGr0qeHX10dTFs46ZxjpcyNqGVdNy3Ia2pPTy9BJ9fueZ8ugNWcrSGEjO8iR90ENaMEWSXMboH8OE5W6MMmb8uSQrMf
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
 .../media/common/videobuf2/videobuf2-v4l2.c   | 19 ++++++++++++++++++-
 include/media/videobuf2-v4l2.h                | 17 +++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 78a841b83d41..e9f90cfe89a5 100644
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
@@ -589,6 +589,23 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
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
index 727855463838..a9961bc776dc 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
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

