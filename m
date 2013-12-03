Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1667 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3LCJn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 04:43:26 -0500
Message-ID: <529DA74E.6080902@xs4all.nl>
Date: Tue, 03 Dec 2013 10:41:34 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 1/9] vb2: push the mmap semaphore down to __buf_prepare()
References: <1385719124-11338-1-git-send-email-hverkuil@xs4all.nl> <f9d4d16ac6acde33e1c5c569cea9ae5886e7a1d7.1385719098.git.hans.verkuil@cisco.com> <1515245.TOT59KTYAx@avalon>
In-Reply-To: <1515245.TOT59KTYAx@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29/13 19:16, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Friday 29 November 2013 10:58:36 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Rather than taking the mmap semaphore at a relatively high-level function,
>> push it down to the place where it is really needed.
>>
>> It was placed in vb2_queue_or_prepare_buf() to prevent racing with other
>> vb2 calls. The only way I can see that a race can happen is when two
>> threads queue the same buffer. The solution for that it to introduce
>> a PREPARING state.
> 
> This looks better to me, but what about a vb2_reqbufs(0) call being processed 
> during the time window where we release the queue mutex ?

You have a nasty mind. That can still go wrong, but note that this is true for
the existing code as well as far as I can tell.

How about this patch to fix this race?

It just refuses to free buffers if any of them is in the preparing state.
It returns EAGAIN in that case (or would EBUSY be better?).

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 2aff646..c3ff993 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -284,10 +284,28 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
  * related information, if no buffers are left return the queue to an
  * uninitialized state. Might be called even if the queue has already been freed.
  */
-static void __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
+static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 {
 	unsigned int buffer;
 
+	/*
+	 * Sanity check: when preparing a buffer the queue lock is released for
+	 * a short while (see __buf_prepare for the details), which would allow
+	 * a race with a reqbufs which can call this function. Removing the
+	 * buffers from underneath __buf_prepare is obviously a bad idea, so we
+	 * check if any of the buffers is in the state PREPARING, and if so we
+	 * just return -EAGAIN.
+	 */
+	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
+	     ++buffer) {
+		if (q->bufs[buffer] == NULL)
+			continue;
+		if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
+			dprintk(1, "reqbufs: preparing buffers, cannot free\n");
+			return -EAGAIN;
+		}
+	}
+
 	/* Call driver-provided cleanup function for each buffer, if provided */
 	if (q->ops->buf_cleanup) {
 		for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
@@ -312,6 +330,7 @@ static void __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	if (!q->num_buffers)
 		q->memory = 0;
 	INIT_LIST_HEAD(&q->queued_list);
+	return 0;
 }
 
 /**
@@ -644,7 +663,9 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 			return -EBUSY;
 		}
 
-		__vb2_queue_free(q, q->num_buffers);
+		ret = __vb2_queue_free(q, q->num_buffers);
+		if (ret)
+			return ret;
 
 		/*
 		 * In case of REQBUFS(0) return immediately without calling

