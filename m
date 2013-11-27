Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4472 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3K0HRg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 02:17:36 -0500
Message-ID: <52959C7B.6020300@xs4all.nl>
Date: Wed, 27 Nov 2013 08:17:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 4/8] vb2: retry start_streaming in case of insufficient
 buffers.
References: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl> <5458942.sLkCAMs10P@avalon> <528F192B.6090709@xs4all.nl> <2969217.JjDzNKjWJr@avalon>
In-Reply-To: <2969217.JjDzNKjWJr@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/2013 04:46 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 22 November 2013 09:43:23 Hans Verkuil wrote:
>> On 11/21/2013 08:09 PM, Laurent Pinchart wrote:
>>> On Thursday 21 November 2013 16:22:02 Hans Verkuil wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> If start_streaming returns -ENODATA, then it will be retried the next
>>>> time a buffer is queued. This means applications no longer need to know
>>>> how many buffers need to be queued before STREAMON can be called. This is
>>>> particularly useful for output stream I/O.
>>>>
>>>> If a DMA engine needs at least X buffers before it can start streaming,
>>>> then for applications to get a buffer out as soon as possible they need
>>>> to know the minimum number of buffers to queue before STREAMON can be
>>>> called. You can't just try STREAMON after every buffer since on failure
>>>> STREAMON will dequeue all your buffers. (Is that a bug or a feature?
>>>> Frankly, I'm not sure).
>>>>
>>>> This patch simplifies applications substantially: they can just call
>>>> STREAMON at the beginning and then start queuing buffers and the DMA
>>>> engine will kick in automagically once enough buffers are available.
>>>>
>>>> This also fixes using write() to stream video: the fileio implementation
>>>> calls streamon without having any queued buffers, which will fail today
>>>> for any driver that requires a minimum number of buffers.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>
>>>>  drivers/media/v4l2-core/videobuf2-core.c | 66 +++++++++++++++++++-------
>>>>  include/media/videobuf2-core.h           | 15 ++++++--
>>>>  2 files changed, 64 insertions(+), 17 deletions(-)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>>>> b/drivers/media/v4l2-core/videobuf2-core.c index 9ea3ae9..5bb91f7 100644
>>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>>> @@ -1332,6 +1332,39 @@ int vb2_prepare_buf(struct vb2_queue *q, struct
>>>> v4l2_buffer *b) }
>>>>
>>>>  EXPORT_SYMBOL_GPL(vb2_prepare_buf);
>>>>
>>>> +/**
>>>> + * vb2_start_streaming() - Attempt to start streaming.
>>>> + * @q:		videobuf2 queue
>>>> + *
>>>> + * If there are not enough buffers, then retry_start_streaming is set to
>>>> + * true and 0 is returned. The next time a buffer is queued and
>>>> + * retry_start_streaming is true, this function will be called again to
>>>> + * retry starting the DMA engine.
>>>> + */
>>>> +static int vb2_start_streaming(struct vb2_queue *q)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	/* Tell the driver to start streaming */
>>>> +	ret = call_qop(q, start_streaming, q, atomic_read(&q->queued_count));
>>>> +
>>>> +	/*
>>>> +	 * If there are not enough buffers queued to start streaming, then
>>>> +	 * the start_streaming operation will return -ENODATA and you have to
>>>> +	 * retry when the next buffer is queued.
>>>> +	 */
>>>> +	if (ret == -ENODATA) {
>>>> +		dprintk(1, "qbuf: not enough buffers, retry when more buffers are
>>>> queued.\n");
>>>> +		q->retry_start_streaming = true;
>>>> +		return 0;
>>>> +	}
>>>> +	if (ret)
>>>> +		dprintk(1, "qbuf: driver refused to start streaming\n");
>>>> +	else
>>>> +		q->retry_start_streaming = false;
>>>> +	return ret;
>>>> +}
>>>> +
>>>>  static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>>>  {
>>>>  	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
>>>> @@ -1377,6 +1410,12 @@ static int vb2_internal_qbuf(struct vb2_queue *q,
>>>> struct v4l2_buffer *b) /* Fill buffer information for the userspace */
>>>>
>>>>  	__fill_v4l2_buffer(vb, b);
>>>>
>>>> +	if (q->retry_start_streaming) {
>>>> +		ret = vb2_start_streaming(q);
>>>> +		if (ret)
>>>> +			return ret;
>>>> +	}
>>>> +
>>>>  	dprintk(1, "%s() of buffer %d succeeded\n", __func__, vb-
>>>> v4l2_buf.index);
>>>> return 0;
>>>>  }
>>>>
>>>> @@ -1526,7 +1565,8 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q)
>>>>  		return -EINVAL;
>>>>  	}
>>>>
>>>> -	wait_event(q->done_wq, !atomic_read(&q->queued_count));
>>>> +	if (!q->retry_start_streaming)
>>>> +		wait_event(q->done_wq, !atomic_read(&q->queued_count));
>>>>  	return 0;
>>>>  
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
>>>> @@ -1640,6 +1680,9 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>>>>  {
>>>>  	unsigned int i;
>>>>
>>>> +	if (q->retry_start_streaming)
>>>> +		q->retry_start_streaming = q->streaming = 0;
>>>> +
>>>>  	/*
>>>>  	 * Tell driver to stop all transactions and release all queued
>>>>  	 * buffers.
>>>> @@ -1689,12 +1732,9 @@ static int vb2_internal_streamon(struct vb2_queue
>>>> *q, enum v4l2_buf_type type) list_for_each_entry(vb, &q->queued_list,
>>>> queued_entry)
>>>>
>>>>  		__enqueue_in_driver(vb);
>>>>
>>>> -	/*
>>>> -	 * Let driver notice that streaming state has been enabled.
>>>> -	 */
>>>> -	ret = call_qop(q, start_streaming, q, atomic_read(&q->queued_count));
>>>> +	/* Tell driver to start streaming. */
>>>
>>> Wouldn't it be better to reset q->retry_start_streaming to 0 here instead
>>> of in the several other locations ?
>>
>> I don't follow. retry_start_streaming is set only in vb2_start_streaming or
>> in queue_cancel. I'm not sure what vb2_internal_streamon has to do with
>> this.
> 
> My point is that the code would be simpler and less error-prone if we reset 
> retry_start_streaming in a single location right before starting the stream 
> instead of in multiple locations when stopping the stream. There would be less 
> chances to introduce a bug when refactoring code in the future in that case.

But that's what happens: it's set when starting the stream (vb2_start_streaming)
and cleared when stopping the stream (__vb2_queue_cancel). I really can't make
it simpler than that.

I still don't see what it is you want to improve here.

Regards,

	Hans
