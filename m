Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41556 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbbHaCBu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 22:01:50 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NTX02EDYCB04W40@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 31 Aug 2015 11:01:48 +0900 (KST)
Message-id: <55E3B58B.3040808@samsung.com>
Date: Mon, 31 Aug 2015 11:01:47 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v3 2/5] media: videobuf2: Restructure vb2_buffer
References: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com>
 <1440590372-2377-3-git-send-email-jh1009.sung@samsung.com>
 <55E062A1.2010900@xs4all.nl>
In-reply-to: <55E062A1.2010900@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Thank you for your review.
I leave some comments in the body for reply.

Regards,
Junghak



On 08/28/2015 10:31 PM, Hans Verkuil wrote:
> Hi Junghak,
>
> Thanks for this patch, it looks much better. I do have a number of comments, though...
>
> On 08/26/2015 01:59 PM, Junghak Sung wrote:
>> Remove v4l2-specific stuff from struct vb2_buffer and add member variables
>> related with buffer management.
>>
>> struct vb2_plane {
>>          <snip>
>>          /* plane information */
>>          unsigned int            bytesused;
>>          unsigned int            length;
>>          union {
>>                  unsigned int    offset;
>>                  unsigned long   userptr;
>>                  int             fd;
>>          } m;
>>          unsigned int            data_offset;
>> }
>>
>> struct vb2_buffer {
>>          <snip>
>>          /* buffer information */
>>          unsigned int            num_planes;
>>          unsigned int            index;
>>          unsigned int            type;
>>          unsigned int            memory;
>>
>>          struct vb2_plane        planes[VIDEO_MAX_PLANES];
>>          <snip>
>> };
>>
>> And create struct vb2_v4l2_buffer as container buffer for v4l2 use.
>>
>> struct vb2_v4l2_buffer {
>>          struct vb2_buffer       vb2_buf;
>>
>>          __u32                   flags;
>>          __u32                   field;
>>          struct timeval          timestamp;
>>          struct v4l2_timecode    timecode;
>>          __u32                   sequence;
>> };
>>
>> This patch includes only changes inside of videobuf2. So, it is required to
>> modify all device drivers which use videobuf2.
>>
>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c |  324 +++++++++++++++++-------------
>>   include/media/videobuf2-core.h           |   50 ++---
>>   include/media/videobuf2-v4l2.h           |   26 +++
>>   3 files changed, 236 insertions(+), 164 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index ab00ea0..9266d50 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -35,10 +35,10 @@
>>   static int debug;
>>   module_param(debug, int, 0644);
>>
>> -#define dprintk(level, fmt, arg...)					      \
>> -	do {								      \
>> -		if (debug >= level)					      \
>> -			pr_info("vb2: %s: " fmt, __func__, ## arg); \
>> +#define dprintk(level, fmt, arg...)					\
>> +	do {								\
>> +		if (debug >= level)					\
>> +			pr_info("vb2: %s: " fmt, __func__, ## arg);	\
>
> These are just whitespace changes, and that is something it see *a lot* in this
> patch. And usually for no clear reason.
>
> Please remove those whitespace changes, it makes a difficult patch even harder
> to read than it already is.
>

I just wanted to remove unnecessary white spaces or adjust alignment.
OK, I will revert those whitespace changes for better review.

>>   	} while (0)
>>
>>   #ifdef CONFIG_VIDEO_ADV_DEBUG
>
> <snip>
>
>> @@ -656,12 +652,21 @@ static bool __buffers_in_use(struct vb2_queue *q)
>>    */
>>   static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>>   {
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>>   	struct vb2_queue *q = vb->vb2_queue;
>> +	unsigned int plane;
>>
>>   	/* Copy back data such as timestamp, flags, etc. */
>> -	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
>> -	b->reserved2 = vb->v4l2_buf.reserved2;
>> -	b->reserved = vb->v4l2_buf.reserved;
>
> Hmm, I'm not sure why these reserved fields were copied here. I think it was
> for compatibility reasons for some old drivers that abused the reserved field.
> However, in the new code these reserved fields should probably be explicitly
> initialized to 0.
>
>> +	b->index = vb->index;
>> +	b->type = vb->type;
>> +	b->memory = vb->memory;
>> +	b->bytesused = 0;
>> +
>> +	b->flags = vbuf->flags;
>> +	b->field = vbuf->field;
>> +	b->timestamp = vbuf->timestamp;
>> +	b->timecode = vbuf->timecode;
>> +	b->sequence = vbuf->sequence;
>>
>>   	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
>>   		/*
>> @@ -669,21 +674,33 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>>   		 * for it. The caller has already verified memory and size.
>>   		 */
>>   		b->length = vb->num_planes;
>> -		memcpy(b->m.planes, vb->v4l2_planes,
>> -			b->length * sizeof(struct v4l2_plane));
>
> A similar problem occurs here: the memcpy would have copied the reserved
> field in v4l2_plane as well, but that no longer happens, so you need to
> do an explicit memset for the reserved field in the new code.
>

It means that I'd better add reserved fields to struct vb2_buffer and 
struct vb2_plane in order to keep the information in struct v4l2_buffer
and struct v4l2_plane???


>> +		for (plane = 0; plane < vb->num_planes; ++plane) {
>> +			struct v4l2_plane *pdst = &b->m.planes[plane];
>> +			struct vb2_plane *psrc = &vb->planes[plane];
>> +
>> +			pdst->bytesused = psrc->bytesused;
>> +			pdst->length = psrc->length;
>> +			if (q->memory == V4L2_MEMORY_MMAP)
>> +				pdst->m.mem_offset = psrc->m.offset;
>> +			else if (q->memory == V4L2_MEMORY_USERPTR)
>> +				pdst->m.userptr = psrc->m.userptr;
>> +			else if (q->memory == V4L2_MEMORY_DMABUF)
>> +				pdst->m.fd = psrc->m.fd;
>> +			pdst->data_offset = psrc->data_offset;
>> +		}
>>   	} else {
>>   		/*
>>   		 * We use length and offset in v4l2_planes array even for
>>   		 * single-planar buffers, but userspace does not.
>>   		 */
>> -		b->length = vb->v4l2_planes[0].length;
>> -		b->bytesused = vb->v4l2_planes[0].bytesused;
>> +		b->length = vb->planes[0].length;
>> +		b->bytesused = vb->planes[0].bytesused;
>>   		if (q->memory == V4L2_MEMORY_MMAP)
>> -			b->m.offset = vb->v4l2_planes[0].m.mem_offset;
>> +			b->m.offset = vb->planes[0].m.offset;
>>   		else if (q->memory == V4L2_MEMORY_USERPTR)
>> -			b->m.userptr = vb->v4l2_planes[0].m.userptr;
>> +			b->m.userptr = vb->planes[0].m.userptr;
>>   		else if (q->memory == V4L2_MEMORY_DMABUF)
>> -			b->m.fd = vb->v4l2_planes[0].m.fd;
>> +			b->m.fd = vb->planes[0].m.fd;
>>   	}
>>
>>   	/*
>> @@ -692,7 +709,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>>   	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
>>   	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
>>   	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
>> -	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
>> +			V4L2_BUF_FLAG_TIMESTAMP_COPY) {
>>   		/*
>>   		 * For non-COPY timestamps, drop timestamp source bits
>>   		 * and obtain the timestamp source from the queue.
>> @@ -767,7 +784,7 @@ EXPORT_SYMBOL(vb2_querybuf);
>>   static int __verify_userptr_ops(struct vb2_queue *q)
>>   {
>>   	if (!(q->io_modes & VB2_USERPTR) || !q->mem_ops->get_userptr ||
>> -	    !q->mem_ops->put_userptr)
>> +			!q->mem_ops->put_userptr)
>>   		return -EINVAL;
>>
>>   	return 0;
>> @@ -780,7 +797,7 @@ static int __verify_userptr_ops(struct vb2_queue *q)
>>   static int __verify_mmap_ops(struct vb2_queue *q)
>>   {
>>   	if (!(q->io_modes & VB2_MMAP) || !q->mem_ops->alloc ||
>> -	    !q->mem_ops->put || !q->mem_ops->mmap)
>> +			!q->mem_ops->put || !q->mem_ops->mmap)
>>   		return -EINVAL;
>>
>>   	return 0;
>> @@ -793,8 +810,8 @@ static int __verify_mmap_ops(struct vb2_queue *q)
>>   static int __verify_dmabuf_ops(struct vb2_queue *q)
>>   {
>>   	if (!(q->io_modes & VB2_DMABUF) || !q->mem_ops->attach_dmabuf ||
>> -	    !q->mem_ops->detach_dmabuf  || !q->mem_ops->map_dmabuf ||
>> -	    !q->mem_ops->unmap_dmabuf)
>> +		!q->mem_ops->detach_dmabuf  || !q->mem_ops->map_dmabuf ||
>> +		!q->mem_ops->unmap_dmabuf)
>>   		return -EINVAL;
>>
>>   	return 0;
>> @@ -808,7 +825,7 @@ static int __verify_memory_type(struct vb2_queue *q,
>>   		enum v4l2_memory memory, enum v4l2_buf_type type)
>>   {
>>   	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR &&
>> -	    memory != V4L2_MEMORY_DMABUF) {
>> +			memory != V4L2_MEMORY_DMABUF) {
>>   		dprintk(1, "unsupported memory type\n");
>>   		return -EINVAL;
>>   	}
>> @@ -927,7 +944,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>>   	 * Driver also sets the size and allocator context for each plane.
>>   	 */
>>   	ret = call_qop(q, queue_setup, q, NULL, &num_buffers, &num_planes,
>> -		       q->plane_sizes, q->alloc_ctx);
>> +			q->plane_sizes, q->alloc_ctx);
>>   	if (ret)
>>   		return ret;
>>
>> @@ -952,7 +969,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>>   		num_buffers = allocated_buffers;
>>
>>   		ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
>> -			       &num_planes, q->plane_sizes, q->alloc_ctx);
>> +				&num_planes, q->plane_sizes, q->alloc_ctx);
>>
>>   		if (!ret && allocated_buffers < num_buffers)
>>   			ret = -ENOMEM;
>> @@ -1040,7 +1057,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>>   	 * buffer and their sizes are acceptable
>>   	 */
>>   	ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
>> -		       &num_planes, q->plane_sizes, q->alloc_ctx);
>> +			&num_planes, q->plane_sizes, q->alloc_ctx);
>>   	if (ret)
>>   		return ret;
>>
>> @@ -1063,7 +1080,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>>   		 * queue driver has set up
>>   		 */
>>   		ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
>> -			       &num_planes, q->plane_sizes, q->alloc_ctx);
>> +				&num_planes, q->plane_sizes, q->alloc_ctx);
>>
>>   		if (!ret && allocated_buffers < num_buffers)
>>   			ret = -ENOMEM;
>> @@ -1183,8 +1200,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>>   		return;
>>
>>   	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
>> -		    state != VB2_BUF_STATE_ERROR &&
>> -		    state != VB2_BUF_STATE_QUEUED))
>> +		state != VB2_BUF_STATE_ERROR &&
>> +		state != VB2_BUF_STATE_QUEUED))
>>   		state = VB2_BUF_STATE_ERROR;
>>
>>   #ifdef CONFIG_VIDEO_ADV_DEBUG
>
> All the chunks above are all spurious whitespace changes. As mentioned in the beginning,
> please remove all those pointless whitespace changes!
>
> There are a lot more of these, but I won't comment on them anymore.
>
> Basically this patch looks good to me, so once I have the next version without all the
> whitespace confusion and with the reserved field issues solved I'll do a final review.
>
> BTW, did you test this with 'v4l2-compliance -s' and with the vivid driver? Just to
> make sure you didn't break anything.
>

Actually, I've tested with v4l2-compliance for just one v4l2 drivers -
au0828.
I'll try to test with vivid driver at next round.


> Regards,
>
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
