Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:52508 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbbIOIW3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 04:22:29 -0400
Subject: Re: [RFC RESEND 05/11] v4l2-core: Don't sync cache for a buffer if so
 requested
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@linaro.org,
	robdclark@gmail.com, daniel.vetter@ffwll.ch, labbott@redhat.com,
	Samu Onkalo <samu.onkalo@intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
 <1441972234-8643-6-git-send-email-sakari.ailus@linux.intel.com>
 <55F30B65.4040309@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <55F7D540.9020403@linux.intel.com>
Date: Tue, 15 Sep 2015 11:22:24 +0300
MIME-Version: 1.0
In-Reply-To: <55F30B65.4040309@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On 09/11/2015 01:50 PM, Sakari Ailus wrote:
>> From: Samu Onkalo <samu.onkalo@intel.com>
>>
>> The user may request to the driver (vb2) to skip the cache maintenance
>> operations in case the buffer does not need cache synchronisation, e.g. in
>> cases where the buffer is passed between hardware blocks without it being
>> touched by the CPU.
>>
>> Also document that the prepare and finish vb2_mem_ops might not get called
>> every time the buffer ownership changes between the kernel and the user
>> space.
>>
>> Signed-off-by: Samu Onkalo <samu.onkalo@intel.com>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 52 +++++++++++++++++++++++++-------
>>  include/media/videobuf2-core.h           | 12 +++++---
>>  2 files changed, 49 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index c5c0707a..b664024 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -187,6 +187,28 @@ static void __vb2_queue_cancel(struct vb2_queue *q);
>>  static void __enqueue_in_driver(struct vb2_buffer *vb);
>>  
>>  /**
>> + * __mem_prepare_planes() - call finish mem op for all planes of the buffer
>> + */
>> +static void __mem_prepare_planes(struct vb2_buffer *vb)
>> +{
>> +	unsigned int plane;
>> +
>> +	for (plane = 0; plane < vb->num_planes; ++plane)
>> +		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
>> +}
>> +
>> +/**
>> + * __mem_finish_planes() - call finish mem op for all planes of the buffer
>> + */
>> +static void __mem_finish_planes(struct vb2_buffer *vb)
>> +{
>> +	unsigned int plane;
>> +
>> +	for (plane = 0; plane < vb->num_planes; ++plane)
>> +		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
>> +}
>> +
>> +/**
>>   * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
>>   */
>>  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>> @@ -1391,6 +1413,10 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>>  static int __prepare_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>  {
>>  	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
>> +
>> +	if (!(b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC))
>> +		__mem_prepare_planes(vb);
>> +
>>  	return call_vb_qop(vb, buf_prepare, vb);
>>  }
>>  
>> @@ -1476,6 +1502,11 @@ static int __prepare_userptr(struct vb2_buffer *vb,
>>  			dprintk(1, "buffer initialization failed\n");
>>  			goto err;
>>  		}
>> +
>> +		/* This is new buffer memory --- always synchronise cache. */
>> +		__mem_prepare_planes(vb);
>> +	} else if (!(b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC)) {
>> +		__mem_prepare_planes(vb);
>>  	}
>>  
>>  	ret = call_vb_qop(vb, buf_prepare, vb);
>> @@ -1601,6 +1632,11 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>  			dprintk(1, "buffer initialization failed\n");
>>  			goto err;
>>  		}
>> +
>> +		/* This is new buffer memory --- always synchronise cache. */
>> +		__mem_prepare_planes(vb);
>> +	} else if (!(b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC)) {
>> +		__mem_prepare_planes(vb);
>>  	}
>>  
>>  	ret = call_vb_qop(vb, buf_prepare, vb);
>> @@ -1624,7 +1660,6 @@ err:
>>  static void __enqueue_in_driver(struct vb2_buffer *vb)
>>  {
>>  	struct vb2_queue *q = vb->vb2_queue;
>> -	unsigned int plane;
>>  
>>  	vb->state = VB2_BUF_STATE_ACTIVE;
>>  	atomic_inc(&q->owned_by_drv_count);
>> @@ -1691,10 +1726,6 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>  		return ret;
>>  	}
>>  
>> -	/* sync buffers */
>> -	for (plane = 0; plane < vb->num_planes; ++plane)
>> -		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
>> -
> 
> Why not keep the prepare memop call here? Why push it down into the __prepare_*
> functions?

I think flushing the buffer the first time it's used is a good thing to
do regardless of what the user suggests, since it's freshly allocated
memory and there could data in the CPU write cache. Once streaming is
ongoing, the user process owns the buffer memory.

> 
> It is wrong too, since the prepare memop should be called *after* the buf_prepare
> callback (buf_prepare should be allowed to touch the buffer for fixups for video
> output).

This is a different matter. I'll reorder the calls.

> 
> With the begin/end_cpu_access() code from my patch series buf_prepare would handle
> this correctly, but we might be doing unnecessary syncs.
> 
> The more I review this, the more I think that the first step should be to take my
> begin/end_cpu_access patch series. With that in place it is at least explicit if a
> driver needs cpu access to a buffer.

Could you rebase and re-post what's not in upstream of that set, please?

> And for USB drivers that use videobuf2-vmalloc this means that they always need cpu
> access between the buf_prepare() and the buf_finish() calls. After all, they are
> copying data from URBs into the buffer.

Indeed.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
