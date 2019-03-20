Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C202C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE4202184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfCTMdJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 08:33:09 -0400
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56655 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727915AbfCTMdI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 08:33:08 -0400
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 6aP3hd3OKeXb86aP4hCEUF; Wed, 20 Mar 2019 13:33:06 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCH v5.1 1/2] vb2: add requires_requests bit for stateless codecs
Date:   Wed, 20 Mar 2019 13:33:04 +0100
Message-Id: <20190320123305.5224-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190320123305.5224-1-hverkuil-cisco@xs4all.nl>
References: <20190320123305.5224-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfFyHJoj8MpaET1Wn/JKYnvOayg0QoUYoWtmhrbXrn1YD4YU0dMveNnMc+HSxYEFu2C1YK53rOj8AxZ0wzAHXD6tAujhSRC3uoGgkoHLBsh9dw+n8NCSl
 XWkP4NNvMnF0HYjxMv4KERXn1bQIocjqcIUYy+WSKF88MkX+xvDoV3SiHtXRDAMbIvo/zZCJBwiCEr4JK7wphC5iahKPXFCzjChhIqRvql4Xf1KuMUxh+9M5
 DNgJdQvKciVPMnYaN95/ADF8FReQRqJ9QsXt4Q10lfs=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Stateless codecs require the use of the Request API as opposed of it
being optional.

So add a bit to indicate this and let vb2 check for this.

If an attempt is made to queue a buffer without an associated request,
then the EBADR error is returned to userspace.

Doing this check in the vb2 core simplifies drivers, since they
don't have to check for this, they can just set this flag.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 Documentation/media/uapi/v4l/vidioc-qbuf.rst    | 4 ++++
 drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++++
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 4 ++++
 include/media/videobuf2-core.h                  | 3 +++
 4 files changed, 20 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index c138d149faea..5739c3676062 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -189,6 +189,10 @@ EACCES
     The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
     support requests for the given buffer type.
 
+EBADR
+    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was not set but the device requires
+    that the buffer is part of a request.
+
 EBUSY
     The first buffer was queued via a request, but the application now tries
     to queue it directly, or vice versa (it is not permitted to mix the two
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 678a31a2b549..b98ec6e1a222 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1507,6 +1507,12 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 
 	vb = q->bufs[index];
 
+	if (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
+	    q->requires_requests) {
+		dprintk(1, "qbuf requires a request\n");
+		return -EBADR;
+	}
+
 	if ((req && q->uses_qbuf) ||
 	    (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
 	     q->uses_requests)) {
@@ -2238,6 +2244,9 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	    WARN_ON(!q->ops->buf_queue))
 		return -EINVAL;
 
+	if (WARN_ON(q->requires_requests && !q->supports_requests))
+		return -EINVAL;
+
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
 	spin_lock_init(&q->done_lock);
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 74d3abf33b50..84de18b30a95 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -381,6 +381,10 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 		return 0;
 
 	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD)) {
+		if (q->requires_requests) {
+			dprintk(1, "%s: queue requires requests\n", opname);
+			return -EBADR;
+		}
 		if (q->uses_requests) {
 			dprintk(1, "%s: queue uses requests\n", opname);
 			return -EBUSY;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index c02af6370e9b..fe010ad62b90 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -482,6 +482,8 @@ struct vb2_buf_ops {
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
  * @supports_requests: this queue supports the Request API.
+ * @requires_requests: this queue requires the Request API. If this is set to 1,
+ *		then supports_requests must be set to 1 as well.
  * @uses_qbuf:	qbuf was used directly for this queue. Set to 1 the first
  *		time this is called. Set to 0 when the queue is canceled.
  *		If this is 1, then you cannot queue buffers from a request.
@@ -556,6 +558,7 @@ struct vb2_queue {
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
 	unsigned			supports_requests:1;
+	unsigned			requires_requests:1;
 	unsigned			uses_qbuf:1;
 	unsigned			uses_requests:1;
 
-- 
2.20.1

