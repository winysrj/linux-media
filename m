Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46662 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbbINHIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2015 03:08:17 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NUN032D9NTQMZ90@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Sep 2015 16:08:14 +0900 (KST)
Message-id: <55F671A6.1020600@samsung.com>
Date: Mon, 14 Sep 2015 16:05:10 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v4 8/8] [media] videobuf2: Remove v4l2-dependencies
 from videobuf2-core
References: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com>
 <1441797597-17389-9-git-send-email-jh1009.sung@samsung.com>
 <55F2CD53.5060404@xs4all.nl>
In-reply-to: <55F2CD53.5060404@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/11/2015 09:47 PM, Hans Verkuil wrote:
> Hi Junghak,
>
> Patch 7/8 helped a lot in reducing the size of this one. But it is still difficult
> to review so I would like to request one final (honest!) split for this patch:
>
> Move all the code that does not depend on the new buf_ops into a separate patch.
> So the new q->is_output and q->multiplanar field can be moved to that patch.
> But also the changes to functions like vb2_expbuf() or streamon/off where some
> checks are moved from core.c to v4l2.c can be done separately.
>
> All such pretty easy to review modifications should be put in a separate patch,
> leaving me with one remaining patch that I really need to study.
>
> I recommend that you wait until 4.3-rc1 is released and merged back in our tree
> since that will contain a number of vb2 changes (Jan Kara's work). So it makes
> sense to rebase on top of that first before doing more work on this.
>

I'll prepare to rebase on 4.3-rc1 and make it much easier to review.

> I did find a few things in this patch as well, see my comments below:
>
> On 09/09/2015 01:19 PM, Junghak Sung wrote:
>> Move v4l2-stuffs from videobuf2-core to videobuf2-v4l2. And make
>> wrappers that use the vb2_core_* functions.
>>
>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c     |  517 ++++++++++++++++----------
>>   drivers/media/v4l2-core/videobuf2-internal.h |   51 +--
>>   drivers/media/v4l2-core/videobuf2-v4l2.c     |  312 ++++++++++++----
>>   include/media/videobuf2-core.h               |   20 +-
>>   include/media/videobuf2-v4l2.h               |    3 +-
>>   5 files changed, 601 insertions(+), 302 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 3e6ee0e..56d34f2 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>
> <snip>
>
>> @@ -454,13 +426,34 @@ static bool __buffers_in_use(struct vb2_queue *q)
>>   {
>>   	unsigned int buffer;
>>   	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
>> -		if (__buffer_in_use(q, q->bufs[buffer]))
>> +		if (vb2_buffer_in_use(q, q->bufs[buffer]))
>>   			return true;
>>   	}
>>   	return false;
>>   }
>>
>>   /**
>> + * vb2_core_querybuf() - query video buffer information
>> + * @q:		videobuf queue
>> + * @index:	id number of the buffer
>> + * @pb:		buffer struct passed from userspace
>> + *
>> + * Should be called from vidioc_querybuf ioctl handler in driver.
>> + * The passed buffer should have been verified.
>> + * This function fills the relevant information for the userspace.
>> + *
>> + * The return values from this function are intended to be directly returned
>> + * from vidioc_querybuf handler in driver.
>> + */
>> +int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
>> +{
>> +	call_bufop(q, fill_user_buffer, q->bufs[index], pb);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(vb2_core_querybuf);
>
> This should be a void function since it never returns an error.
>
> But do we need it at all? It really doesn't do anything that is core-specific.
> The querybuf ioctl is really pure V4L2 and has nothing to do with the vb2 core.
>

I think it would be better to keep this code, like other vb2_core 
functions. I do not want to call buf_ops callback function - i.e. 
full_user_buffer() - from the v4l2-side.
And return value is also needed because fill_user_buffer() can return 
error code.
But, this code should be modified like:

int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
{
	return call_bufop(q, fill_user_buffer, q->bufs[index], pb);
}

>> +
>> +/**
>>    * __verify_userptr_ops() - verify that all memory operations required for
>>    * USERPTR queue type have been provided
>>    */
>> @@ -1182,52 +1174,27 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>>   	call_void_vb_qop(vb, buf_queue, vb);
>>   }
>>
>> -int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>> +static int __buf_prepare(struct vb2_buffer *vb, void *pb)
>>   {
>> -	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>>   	struct vb2_queue *q = vb->vb2_queue;
>>   	int ret;
>>
>> -	ret = __verify_length(vb, b);
>> -	if (ret < 0) {
>> -		dprintk(1, "plane parameters verification failed: %d\n", ret);
>> -		return ret;
>> -	}
>> -	if (b->field == V4L2_FIELD_ALTERNATE && V4L2_TYPE_IS_OUTPUT(q->type)) {
>> -		/*
>> -		 * If the format's field is ALTERNATE, then the buffer's field
>> -		 * should be either TOP or BOTTOM, not ALTERNATE since that
>> -		 * makes no sense. The driver has to know whether the
>> -		 * buffer represents a top or a bottom field in order to
>> -		 * program any DMA correctly. Using ALTERNATE is wrong, since
>> -		 * that just says that it is either a top or a bottom field,
>> -		 * but not which of the two it is.
>> -		 */
>> -		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
>> -		return -EINVAL;
>> -	}
>> -
>>   	if (q->error) {
>>   		dprintk(1, "fatal error occurred on queue\n");
>>   		return -EIO;
>>   	}
>>
>> -	vb->state = VB2_BUF_STATE_PREPARING;
>
> Hmmm, this moved to v4l2.c. Why? This still belongs here as far as I can tell.
> I suspect that was a copy-and-paste mistake.
>
Correct! I'll fix it.

>> -	vbuf->timestamp.tv_sec = 0;
>> -	vbuf->timestamp.tv_usec = 0;
>> -	vbuf->sequence = 0;
>> -
>>   	switch (q->memory) {
>>   	case VB2_MEMORY_MMAP:
>> -		ret = __qbuf_mmap(vb, b);
>> +		ret = __qbuf_mmap(vb, pb);
>>   		break;
>>   	case VB2_MEMORY_USERPTR:
>>   		down_read(&current->mm->mmap_sem);
>> -		ret = __qbuf_userptr(vb, b);
>> +		ret = __qbuf_userptr(vb, pb);
>>   		up_read(&current->mm->mmap_sem);
>>   		break;
>>   	case VB2_MEMORY_DMABUF:
>> -		ret = __qbuf_dmabuf(vb, b);
>> +		ret = __qbuf_dmabuf(vb, pb);
>>   		break;
>>   	default:
>>   		WARN(1, "Invalid queue type\n");
>> @@ -1241,32 +1208,94 @@ int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>   	return ret;
>>   }
>>
>> -int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>> -				    const char *opname)
>> +/**
>> + * vb2_verify_buffer() - verify the buffer information passed from userspace
>> + */
>> +int vb2_verify_buffer(struct vb2_queue *q,
>> +			enum vb2_memory memory, unsigned int type,
>> +			unsigned int index, unsigned int nplanes,
>> +			void *pplane, const char *opname)
>>   {
>> -	if (b->type != q->type) {
>> +	if (type != q->type) {
>>   		dprintk(1, "%s: invalid buffer type\n", opname);
>>   		return -EINVAL;
>>   	}
>>
>> -	if (b->index >= q->num_buffers) {
>> +	if (index >= q->num_buffers) {
>>   		dprintk(1, "%s: buffer index out of range\n", opname);
>>   		return -EINVAL;
>>   	}
>>
>> -	if (q->bufs[b->index] == NULL) {
>> +	if (q->bufs[index] == NULL) {
>>   		/* Should never happen */
>>   		dprintk(1, "%s: buffer is NULL\n", opname);
>>   		return -EINVAL;
>>   	}
>>
>> -	if (b->memory != q->memory) {
>> +	if (memory != VB2_MEMORY_UNKNOWN && memory != q->memory) {
>>   		dprintk(1, "%s: invalid memory type\n", opname);
>>   		return -EINVAL;
>>   	}
>>
>> -	return __verify_planes_array(q->bufs[b->index], b);
>> +	if (q->is_multiplanar) {
>> +		struct vb2_buffer *vb = q->bufs[index];
>> +
>> +		/* Is memory for copying plane information present? */
>> +		if (NULL == pplane) {
>> +			dprintk(1, "%s: multi-planar buffer passed but "
>> +				"planes array not provided\n", opname);
>> +			return -EINVAL;
>> +		}
>
> This doesn't belong here. pplane is very much v4l2 specific and should be
> tested there.

Apparently, it should be checked on v4l2-side. I'll fix it.
Thank you.

Best regards,
Junghak

>
>> +
>> +		if (nplanes < vb->num_planes || nplanes > VB2_MAX_PLANES) {
>> +			dprintk(1, "%s: incorrect planes array length, "
>> +				"expected %d, got %d\n",
>> +				opname, vb->num_planes, nplanes);
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(vb2_verify_buffer);
>> +
>> +/**
>> + * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
>> + * @q:		videobuf2 queue
>> + * @index:	id number of the buffer
>> + * @pb:		buffer structure passed from userspace to vidioc_prepare_buf
>> + *		handler in driver
>> + *
>> + * Should be called from vidioc_prepare_buf ioctl handler of a driver.
>> + * The passed buffer should have been verified.
>> + * This function calls buf_prepare callback in the driver (if provided),
>> + * in which driver-specific buffer initialization can be performed,
>> + *
>> + * The return values from this function are intended to be directly returned
>> + * from vidioc_prepare_buf handler in driver.
>> + */
>> +int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>> +{
>> +	struct vb2_buffer *vb;
>> +	int ret;
>> +
>> +	vb = q->bufs[index];
>> +	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
>> +		dprintk(1, "invalid buffer state %d\n",
>> +			vb->state);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = __buf_prepare(vb, pb);
>> +	if (!ret) {
>> +		/* Fill buffer information for the userspace */
>> +		call_bufop(q, fill_user_buffer, vb, pb);
>> +
>> +		dprintk(1, "prepare of buffer %d succeeded\n", vb->index);
>> +	}
>> +	return ret;
>>   }
>> +EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
>>
>>   /**
>>    * vb2_start_streaming() - Attempt to start streaming.
>
> Regards,
>
> 	Hans
>
