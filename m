Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EBDC282D7
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EB3520838
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbfBKKOC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:14:02 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39723 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfBKKOC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:14:02 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id t8b7gs8zWRO5Zt8bAg3GnH; Mon, 11 Feb 2019 11:14:01 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 1/6] vb2: add requires_requests bit for stateless codecs
Date:   Mon, 11 Feb 2019 11:13:52 +0100
Message-Id: <20190211101357.48754-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
References: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfJiEjTxQpxnSvpzpkjp9Xx4QPqYFUvnR79eNbVxxJTdmhAOwUbwm6TOr69A0RItKJSbnTAesiw1MuMSWeC13NW2FjKzMTv4GPF6TSUeEeeiwCK9B/sV0
 qqTrngwGsKTZSOfth93BBGgYy+YbBCMc63jSNcpzSWpkcptOAlCdcHK/oTbhehznBLr5idEVImxFLuKfO+F52VA6CC+nv0y29a/+F5oA/DZK9olhggxaWVf4
 x5Bhva+nPG3GkwvWumt9MvvtDg4D+MRDezG+hT5TStKqWETKWXGap5oYRgp7e/qp9rZUBm9IQ5Wz28to7vPXASLuI14wKlawhWzZbObWWjg=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Stateless codecs require the use of the Request API as opposed of it
being optional.

So add a bit to indicate this and let vb2 check for this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 5 ++++-
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 6 ++++++
 include/media/videobuf2-core.h                  | 3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 34cc87ca8d59..2b1e93e429be 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1516,7 +1516,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 
 	if ((req && q->uses_qbuf) ||
 	    (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
-	     q->uses_requests)) {
+	     (q->uses_requests || q->requires_requests))) {
 		dprintk(1, "queue in wrong mode (qbuf vs requests)\n");
 		return -EBUSY;
 	}
@@ -2244,6 +2244,9 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	    WARN_ON(!q->ops->buf_queue))
 		return -EINVAL;
 
+	if (WARN_ON(q->requires_requests && !q->supports_requests))
+		return -EINVAL;
+
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
 	spin_lock_init(&q->done_lock);
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 3aeaea3af42a..8b15b7762c56 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -385,6 +385,10 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 			dprintk(1, "%s: queue uses requests\n", opname);
 			return -EBUSY;
 		}
+		if (q->requires_requests) {
+			dprintk(1, "%s: queue requires requests\n", opname);
+			return -EACCES;
+		}
 		return 0;
 	} else if (!q->supports_requests) {
 		dprintk(1, "%s: queue does not support requests\n", opname);
@@ -657,6 +661,8 @@ static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
 #ifdef CONFIG_MEDIA_CONTROLLER_REQUEST_API
 	if (q->supports_requests)
 		*caps |= V4L2_BUF_CAP_SUPPORTS_REQUESTS;
+	if (q->requires_requests)
+		*caps |= V4L2_BUF_CAP_REQUIRES_REQUESTS;
 #endif
 }
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 06142c1469cc..7f76bc65453e 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -481,6 +481,8 @@ struct vb2_buf_ops {
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
  * @supports_requests: this queue supports the Request API.
+ * @requires_requests: this queue requires the Request API. If this is set to 1,
+ *		then supports_requests must be set to 1 as well.
  * @uses_qbuf:	qbuf was used directly for this queue. Set to 1 the first
  *		time this is called. Set to 0 when the queue is canceled.
  *		If this is 1, then you cannot queue buffers from a request.
@@ -555,6 +557,7 @@ struct vb2_queue {
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
 	unsigned			supports_requests:1;
+	unsigned			requires_requests:1;
 	unsigned			uses_qbuf:1;
 	unsigned			uses_requests:1;
 
-- 
2.20.1

