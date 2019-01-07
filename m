Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A44FC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50B2C206A3
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfAGOPK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:15:10 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:60477 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726911AbfAGOPK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 09:15:10 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gVgGgHMEABDyIgVgKgOFoB; Mon, 07 Jan 2019 15:15:08 +0100
Subject: Re: epoll and vb2_poll: can't wake_up
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     Yi Qingliang <niqingliang2003@gmail.com>,
        linux-media@vger.kernel.org
References: <CADwFkYdCXY5my5DW=qGJcJBDpjtZpRHXN6h4H2geneekiOzCgg@mail.gmail.com>
 <3268a1a8-1712-52b2-e0e4-c6a98f003d75@xs4all.nl>
Message-ID: <17220072-7c86-2d0f-3f1d-a9c6e6568db5@xs4all.nl>
Date:   Mon, 7 Jan 2019 15:15:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <3268a1a8-1712-52b2-e0e4-c6a98f003d75@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDgkNFP8AUAFTDcUTIeZ67QjvQQ12QVuWu49IPHqGZW9WFglurRpeldJ0kYGVEw6VF+KV2FA2dXJaTjU8/7B5SkcbAyU6mkaWmNMtGSz8V6EjnNhOIWC
 O4YYj8bnCkif+5iYoH99Iis10vl6/2+l0rpJqvXnArCf8T6yMORmWGnQWI1FBeNXQdcM/+7mKGu/D8Z8iC2u7AqZqQCgxIj2JfAiLH+EWzYfv4p5OS5jiB5X
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/07/2019 02:45 PM, Hans Verkuil wrote:
> On 12/29/2018 03:10 AM, Yi Qingliang wrote:
>> Hello, I encountered a "can't wake_up" problem when use camera on imx6.
>>
>> if delay some time after 'streamon' the /dev/video0, then add fd
>> through epoll_ctl, then the process can't be waken_up after some time.
>>
>> I checked both the epoll / vb2_poll(videobuf2_core.c) code.
>>
>> epoll will pass 'poll_table' structure to vb2_poll, but it only
>> contain valid function pointer when inserting fd.
>>
>> in vb2_poll, if found new data in done list, it will not call 'poll_wait'.
>> after that, every call to vb2_poll will not contain valid poll_table,
>> which will result in all calling to poll_wait will not work.
>>
>> so if app can process frames quickly, and found frame data when
>> inserting fd (i.e. poll_wait will not be called or not contain valid
>> function pointer), it will not found valid frame in 'vb2_poll' finally
>> at some time, then call 'poll_wait' to expect be waken up at following
>> vb2_buffer_done, but no good luck.
>>
>> I also checked the 'videobuf-core.c', there is no this problem.
>>
>> of course, both epoll and vb2_poll are right by itself side, but the
>> result is we can't get new frames.
>>
>> I think by epoll's implementation, the user should always call poll_wait.
>>
>> and it's better to split the two actions: 'wait' and 'poll' both for
>> epoll framework and all epoll users, for example, v4l2.
>>
>> am I right?
>>
>> Yi Qingliang
>>
> 
> Can you test this patch?
> 
> Looking at what other drivers/frameworks do it seems that calling
> poll_wait() at the start of the poll function is the right approach.
> 
> Regards,
> 
> 	Hans

Here is a new patch that should do the right thing for all the media
frameworks. Please test!

If it works, then I'll make a proper patch submission.

	Hans

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 70e8c3366f9c..e37443c1461f 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2329,8 +2329,6 @@ __poll_t vb2_core_poll(struct vb2_queue *q, struct file *file,
 		 */
 		if (q->last_buffer_dequeued)
 			return EPOLLIN | EPOLLRDNORM;
-
-		poll_wait(file, &q->done_wq, wait);
 	}

 	/*
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 78a841b83d41..e657f0949641 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -848,13 +848,12 @@ __poll_t vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	__poll_t req_events = poll_requested_events(wait);
 	__poll_t res = 0;

+	poll_wait(file, &q->done_wq, wait);
 	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
 		struct v4l2_fh *fh = file->private_data;

 		if (v4l2_event_pending(fh))
 			res = EPOLLPRI;
-		else if (req_events & EPOLLPRI)
-			poll_wait(file, &fh->wait, wait);
 	}

 	return res | vb2_core_poll(q, file, wait);
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 6974f1731529..2fd60cef4ccf 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -437,6 +437,7 @@ __poll_t dvb_vb2_poll(struct dvb_vb2_ctx *ctx, struct file *file,
 		      poll_table *wait)
 {
 	dprintk(3, "[%s]\n", ctx->name);
+	poll_wait(file, &ctx->vb_q.done_wq, wait);
 	return vb2_core_poll(&ctx->vb_q, file, wait);
 }

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index c71a34ae6383..b5c984dd42df 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -97,6 +97,7 @@ static __poll_t media_request_poll(struct file *filp,
 	unsigned long flags;
 	__poll_t ret = 0;

+	poll_wait(filp, &req->poll_wait, wait);
 	if (!(poll_requested_events(wait) & EPOLLPRI))
 		return 0;

@@ -110,8 +111,6 @@ static __poll_t media_request_poll(struct file *filp,
 		goto unlock;
 	}

-	poll_wait(filp, &req->poll_wait, wait);
-
 unlock:
 	spin_unlock_irqrestore(&req->lock, flags);
 	return ret;
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 5bbdec55b7d7..8803eab90b6e 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -617,13 +617,14 @@ __poll_t v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	__poll_t rc = 0;
 	unsigned long flags;

+	poll_wait(file, &src_q->done_wq, wait);
+	poll_wait(file, &dst_q->done_wq, wait);
+
 	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
 		struct v4l2_fh *fh = file->private_data;

 		if (v4l2_event_pending(fh))
 			rc = EPOLLPRI;
-		else if (req_events & EPOLLPRI)
-			poll_wait(file, &fh->wait, wait);
 		if (!(req_events & (EPOLLOUT | EPOLLWRNORM | EPOLLIN | EPOLLRDNORM)))
 			return rc;
 	}
@@ -642,11 +643,6 @@ __poll_t v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		goto end;
 	}

-	spin_lock_irqsave(&src_q->done_lock, flags);
-	if (list_empty(&src_q->done_list))
-		poll_wait(file, &src_q->done_wq, wait);
-	spin_unlock_irqrestore(&src_q->done_lock, flags);
-
 	spin_lock_irqsave(&dst_q->done_lock, flags);
 	if (list_empty(&dst_q->done_list)) {
 		/*
@@ -657,8 +653,6 @@ __poll_t v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			spin_unlock_irqrestore(&dst_q->done_lock, flags);
 			return rc | EPOLLIN | EPOLLRDNORM;
 		}
-
-		poll_wait(file, &dst_q->done_wq, wait);
 	}
 	spin_unlock_irqrestore(&dst_q->done_lock, flags);


