Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:44423 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728949AbeHOPZZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 11:25:25 -0400
Subject: Re: [PATCHv18 19/35] vb2: store userspace data in vb2_v4l2_buffer
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
 <20180814142047.93856-20-hverkuil@xs4all.nl>
 <20180814164751.7b52c58d@coco.lan>
 <56ce6185-4b96-240a-5fe1-ecaf607ca407@xs4all.nl>
 <20180815092844.7528c56d@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8fe436c6-37a0-8ad0-fe8b-f3f8107fc483@xs4all.nl>
Date: Wed, 15 Aug 2018 14:33:22 +0200
MIME-Version: 1.0
In-Reply-To: <20180815092844.7528c56d@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/08/18 14:28, Mauro Carvalho Chehab wrote:
> Em Wed, 15 Aug 2018 13:54:53 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 14/08/18 21:47, Mauro Carvalho Chehab wrote:
>>> Em Tue, 14 Aug 2018 16:20:31 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:  
>>
>> <snip>
>>
>>>> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>>>> index 57848ddc584f..360dc4e7d413 100644
>>>> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>>>> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>>>> @@ -154,17 +154,11 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
>>>>  		pr_warn("use the actual size instead.\n");
>>>>  }
>>>>  
>>>> -/*
>>>> - * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
>>>> - * v4l2_buffer by the userspace. It also verifies that struct
>>>> - * v4l2_buffer has a valid number of planes.
>>>> - */
>>>> -static int __fill_vb2_buffer(struct vb2_buffer *vb,
>>>> -		const void *pb, struct vb2_plane *planes)
>>>> +static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>>>>  {
>>>>  	struct vb2_queue *q = vb->vb2_queue;
>>>> -	const struct v4l2_buffer *b = pb;
>>>>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>>>> +	struct vb2_plane *planes = vbuf->planes;
>>>>  	unsigned int plane;
>>>>  	int ret;
>>>>  
>>>> @@ -186,7 +180,6 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>>>>  		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
>>>>  		return -EINVAL;
>>>>  	}
>>>> -	vb->timestamp = 0;  
>>>
>>> See my note below about this removal. On a quick look, I guess we may have
>>> a regression here for output buffers (non-m2m).  
>>
>> Note that this is no longer the __fill_vb2_buffer() callback, and the timestamp
>> is not handled in vb2_fill_vb2_v4l2_buffer(). That's why it is removed here.
>>
>> It is handled in the new __fill_vb2_buffer function, see below for comments.
>>
>>>   
>>>>  	vbuf->sequence = 0;
>>>>  
>>>>  	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
>>>> @@ -208,6 +201,12 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>>>>  			}
>>>>  			break;
>>>>  		default:
>>>> +			for (plane = 0; plane < vb->num_planes; ++plane) {
>>>> +				planes[plane].m.offset =
>>>> +					vb->planes[plane].m.offset;
>>>> +				planes[plane].length =
>>>> +					vb->planes[plane].length;
>>>> +			}
>>>>  			break;
>>>>  		}
>>>>  
>>>> @@ -269,9 +268,12 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>>>>  			planes[0].length = b->length;
>>>>  			break;
>>>>  		default:
>>>> +			planes[0].m.offset = vb->planes[0].m.offset;
>>>> +			planes[0].length = vb->planes[0].length;
>>>>  			break;
>>>>  		}
>>>>  
>>>> +		planes[0].data_offset = 0;
>>>>  		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
>>>>  			if (b->bytesused == 0)
>>>>  				vb2_warn_zero_bytesused(vb);
>>>> @@ -286,7 +288,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>>>>  
>>>>  	}
>>>>  
>>>> -	/* Zero flags that the vb2 core handles */
>>>> +	/* Zero flags that we handle */
>>>>  	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
>>>>  	if (!vb->vb2_queue->copy_timestamp || !V4L2_TYPE_IS_OUTPUT(b->type)) {
>>>>  		/*
>>>> @@ -319,6 +321,10 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>>>>  static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>>>>  				    const char *opname)
>>>>  {
>>>> +	struct vb2_v4l2_buffer *vbuf;
>>>> +	struct vb2_buffer *vb;
>>>> +	int ret;
>>>> +
>>>>  	if (b->type != q->type) {
>>>>  		dprintk(1, "%s: invalid buffer type\n", opname);
>>>>  		return -EINVAL;
>>>> @@ -340,7 +346,15 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>>>>  		return -EINVAL;
>>>>  	}
>>>>  
>>>> -	return __verify_planes_array(q->bufs[b->index], b);
>>>> +	vb = q->bufs[b->index];
>>>> +	vbuf = to_vb2_v4l2_buffer(vb);
>>>> +	ret = __verify_planes_array(vb, b);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	/* Copy relevant information provided by the userspace */
>>>> +	memset(vbuf->planes, 0, sizeof(vbuf->planes[0]) * vb->num_planes);
>>>> +	return vb2_fill_vb2_v4l2_buffer(vb, b);
>>>>  }
>>>>  
>>>>  /*
>>>> @@ -448,6 +462,30 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>>>>  		q->last_buffer_dequeued = true;
>>>>  }
>>>>  
>>>> +/*
>>>> + * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
>>>> + * v4l2_buffer by the userspace. It also verifies that struct
>>>> + * v4l2_buffer has a valid number of planes.
>>>> + */
>>>> +static int __fill_vb2_buffer(struct vb2_buffer *vb, struct vb2_plane *planes)
>>>> +{
>>>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>>>> +	unsigned int plane;
>>>> +
>>>> +	if (!vb->vb2_queue->is_output || !vb->vb2_queue->copy_timestamp)
>>>> +		vb->timestamp = 0;  
>>>
>>> When vb->vb2_queue->copy_timestamp is not NULL, timestamp will be copied,
>>> but how VB2 will fill it if is_output?  
>>
>> vb->vb2_queue->copy_timestamp is a bool, not a pointer. It is true if the timestamps
>> should be copied from output to capture by the driver.
>>
>> So the timestamp provided by the application for an output queue that also wants to
>> copy timestamps needs to be preserved so the driver can copy it to a capture buffer.
>> In all other cases the vb->timestamp should be zeroed and the driver will fill it in
>> later when it is done with the capture or output buffer.
>>
>> Without the request API the sequence during a VIDIOC_QBUF is:
>>
>> 1) call __buf_prepare() which in turn calls the fill_vb2_buffer callback. This zeroed
>>    the timestamp.
>> 2) call the copy_timestamp callback of the vb buffer which fills in the timestamp
>>    from the user-provided v4l2_buffer.
>>
>> With the request API this no longer works since when you queue a buffer to a request
>> it is parked internally and not actually queued to the driver until the request itself
>> is queued. So the sequence in that case is:
>>
>> 1) call copy_timestamp callback to store the user-provided timestamp
>>
>> And when the request is queued:
>>
>> 2) call __buf_prepare() which in turn calls the fill_vb2_buffer callback.
>>
>> So the order of calling copy_timestamp and __buf_prepare is now reversed.
>> I can't call copy_timestamp when the request is queued since I no longer have
>> access to the original struct v4l2_buffer.
>>
>> So __fill_vb2_buffer now leaves the timestamp alone for output buffers that
>> need to copy the timestamp.
>>
>>>
>>> I suspect that the right logic here would be just:
>>>
>>> 	if (!vb->vb2_queue->copy_timestamp)
>>> 		vb->timestamp = 0;  
>>
>> No, it also needs the !vb->vb2_queue->is_output check: capture queues can also
>> have vb2_queue->copy_timestamp set. But there it is the driver that will copy
>> the timestamp from the output side, so we need to zero it here.
>>
>> Note that v4l2-compliance tests this timestamp handling. And in fact, the changes
>> I had to make here to do correct timestamp handling for requests were the result
>> of failures in v4l2-compliance.
> 
> So, not zeroing it if !vb->vb2_queue->is_output is actually a bug fix, right?

No, it is not a bug fix. The old code worked fine since the timestamp was copied
*after* fill_vb2_buffer was called. Now it is reversed and you need this check
to avoid zeroing a copied timestamp.

When I referred to the v4l2-compliance failures I meant failures I got testing
with an early version of the request API that didn't have this modified timestamp
handling code.

Regards,

	Hans

> 
> Please put such change on a separate patchset then. It could make sense to
> c/c stable for it.
> 
>>
>> A general note: I feel that vb2 is getting a bit too complex and could do with some
>> refactoring. It is something I want to look at in the future.
>>
>> Regards,
>>
>> 	Hans
> 
> 
> 
> Thanks,
> Mauro
> 
