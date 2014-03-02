Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2017 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaCBHZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Mar 2014 02:25:26 -0500
Message-ID: <5312DCC9.3010205@xs4all.nl>
Date: Sun, 02 Mar 2014 08:24:57 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: k.debski@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATH v6 06/10] v4l: Handle buffer timestamp flags correctly
References: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi> <1393679828-25878-7-git-send-email-sakari.ailus@iki.fi> <5311EE75.1000305@xs4all.nl> <53120FF4.2050108@iki.fi>
In-Reply-To: <53120FF4.2050108@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/01/2014 05:51 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the comments.
> 
> Hans Verkuil wrote:
>> On 03/01/2014 02:17 PM, Sakari Ailus wrote:
>>> For COPY timestamps, buffer timestamp source flags will traverse the queue
>>> untouched.
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>> ---
>>>  drivers/media/v4l2-core/videobuf2-core.c |   26 +++++++++++++++++++++++++-
>>>  1 file changed, 25 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>>> index 3dda083..7afeb6b 100644
>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>> @@ -488,7 +488,22 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>>>  	 * Clear any buffer state related flags.
>>>  	 */
>>>  	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
>>> -	b->flags |= q->timestamp_flags;
>>> +	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
>>> +	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
>>> +		/*
>>> +		 * For COPY timestamps, we just set the timestamp type
>>> +		 * here. The timestamp source is already in b->flags.
>>> +		 */
>>> +		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
>>> +	} else {
>>> +		/*
>>> +		 * For non-COPY timestamps, drop timestamp source and
>>> +		 * obtain the timestamp type and source from the
>>> +		 * queue.
>>> +		 */
>>> +		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
>>> +		b->flags |= q->timestamp_flags;
>>> +	}
>>
>> It's correct, but I would do it a bit differently:
>>
>> 	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
>> 	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
>> 	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
>> 	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
>> 		/*
>> 		 * For non-COPY timestamps, drop timestamp source and
>> 		 * obtain the timestamp type and source from the
>> 		 * queue.
>> 		 */
>> 		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
>> 		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
>> 	}
>>
>> That way it is clearer that the timestamp type is always set and that it is
>> just the timestamp source that has special handling.
> 
> I was actually pondering between the above and what ended up into the
> code. ;-) I'll fix that and change the comment to say:
> 
> 		/*
> 		 * For non-COPY timestamps, drop timestamp source bits
> 		 * and obtain the timestamp source from the queue.
> 		 */
>>
>>>  
>>>  	switch (vb->state) {
>>>  	case VB2_BUF_STATE_QUEUED:
>>> @@ -1031,6 +1046,15 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>>>  
>>>  	/* Zero flags that the vb2 core handles */
>>>  	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
>>> +	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
>>> +	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
>>> +		/*
>>> +		 * Non-COPY timestamps will get their timestamp and
>>> +		 * timestamp source flags from the queue.
>>> +		 */
>>> +		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
>>> +	}
>>
>> This should be:
>>
>> 	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
>> 	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
>>
>> Capture buffers also need to clear the TSTAMP_SRC flags as they will get it
>> from the output queue. In other words: capture buffers never set the timestamp
>> source flags, only output buffers can do that if timestamps are copied.
> 
> Good point. I'll also change the comment accordingly:
> 
> 		/*
> 		 * Non-COPY timestamps and non-OUTPUT queues will get
> 		 * their timestamp and timestamp source flags from the
> 		 * queue.
> 		 */
> 
>> As an aside: the more I think about it, the more I believe that we're not quite
>> doing the right thing when it comes to copying timestamps. The problem is that
>> TIMESTAMP_COPY is part of the timestamp type mask. It should be a separate bit.
>> That way output buffers supply both type and source, and capture buffers give
>> those back to the application. Right now you can't copy the timestamp type since
>> COPY is part of those types.
> 
> Is that a real problem? The timestamp types are related to clocks and in
> that sense, "copy" is one of them: it's anything the program queueing it
> to the OUTPUT queue has specified. In other words, I don't think the
> combination of monotonic (or realtime) and copy would be meaningful.
> 
>> We did not really think that through.
> 
> At least I don't see a problem with how it's currently implemented. :-)

Well, the problem is that when you capture from hardware you get a timestamp
and a timestamp type (i.e. which clock did the timestamp use?). If you then
pass that captured stream through a m2m device for postprocessing you will
have lost the timestamp type on the other side of the m2m device since it
will be replaced with COPY.

That's not right IMHO.

What should happen I think for m2m copy devices is the following:

Initially after creating the buffers the timestamp type is set to COPY for
both capture and output buffers. You fill in the output buffer with timestamp,
timestamp source and timestamp type and call QBUF. At the moment QUERYBUF
will return what you put in there. Dequeuing that buffer on the capture side
will give back what you put in.

On the capture side the timestamp type should be set to COPY when you queue
the empty buffer and it will stay that way until the buffer is filled up
with the new frame in the m2m device.

I'm not sure what to do on the output side when dequeuing a buffer: keep the
values you put in when queuing it, or replace it with COPY. I think keeping
it is better, you might want to queue the same buffer to another m2m device
so you don't want to set up those values again.

Yeah, I think that would make sense. COPY can still be part of the timestamp
type mask, but it's just replaced by the user's timestamp settings as you
would expect.

Regards,

	Hans
