Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1464 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbaHFGo5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 02:44:57 -0400
Message-ID: <53E1CECB.40600@xs4all.nl>
Date: Wed, 06 Aug 2014 08:44:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	sasha.levin@oracle.com
Subject: Re: [PATCHv3] videobuf2: fix lockdep warning
References: <53E0B84E.3050803@xs4all.nl> <9597115.RDDXHorZIT@avalon>
In-Reply-To: <9597115.RDDXHorZIT@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2014 12:15 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Tuesday 05 August 2014 12:56:14 Hans Verkuil wrote:
>> Changes since v2: use a mutex instead of a spinlock due to possible sleeps
>> inside the mmap memop. Use the mutex when buffers are allocated/freed, so
>> it's a much coarser lock.
>>
>> The following lockdep warning has been there ever since commit
>> a517cca6b24fc54ac209e44118ec8962051662e3 one year ago:
> 
> [snip]
> 
>> The reason is that vb2_fop_mmap and vb2_fop_get_unmapped_area take the core
>> lock while they are called with the mmap_sem semaphore held. But elsewhere
>> in the code the core lock is taken first but calls to copy_to/from_user()
>> can take the mmap_sem semaphore as well, potentially causing a classical
>> A-B/B-A deadlock.
>>
>> However, the mmap/get_unmapped_area calls really shouldn't take the core
>> lock at all. So what would happen if they don't take the core lock anymore?
>>
>> There are two situations that need to be taken into account: calling mmap
>> while new buffers are being added and calling mmap while buffers are being
>> deleted.
>>
>> The first case works almost fine without a lock: in all cases mmap relies on
>> correctly filled-in q->num_buffers/q->num_planes values and those are only
>> updated by reqbufs and create_buffers *after* any new buffers have been
>> initialized completely. Except in one case: if an error occurred while
>> allocating the buffers it will increase num_buffers and rely on
>> __vb2_queue_free to decrease it again. So there is a short period where the
>> buffer information may be wrong.
>>
>> The second case definitely does pose a problem: buffers may be in the
>> process of being deleted, without the internal structure being updated.
>>
>> In order to fix this a new mutex is added to vb2_queue that is taken when
>> buffers are allocated or deleted, and in vb2_mmap. That way vb2_mmap won't
>> get stale buffer data. Note that this is a problem only for MEMORY_MMAP, so
>> even though __qbuf_userptr and __qbuf_dmabuf also mess around with buffers
>> (mem_priv in particular), this doesn't clash with vb2_mmap or
>> vb2_get_unmapped_area since those are MMAP specific.
>>
>> As an additional bonus the hack in __buf_prepare, the USERPTR case, can be
>> removed as well since mmap() no longer takes the core lock.
>>
>> All in all a much cleaner solution.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> with one small comment, please see below.
> 
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 56 ++++++++++-------------------
>>  include/media/videobuf2-core.h           |  2 ++
>>  2 files changed, 21 insertions(+), 37 deletions(-)
> 
> [snip]
> 
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index fc910a6..ae1289b 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -366,6 +366,7 @@ struct v4l2_fh;
>>   *		cannot be started unless at least this number of buffers
>>   *		have been queued into the driver.
>>   *
>> + * @queue_lock:	private mutex used when buffers are allocated/freed/mmapped
> 
> queue_lock sounds a bit too generic to me, it might confuse readers into 
> thinking the lock protects the whole queue.

How about mmap_lock?

Regards,

	Hans

> 
>> * @memory:	current memory type used
>>   * @bufs:	videobuf buffer structures
>>   * @num_buffers: number of allocated/used buffers
>> @@ -399,6 +400,7 @@ struct vb2_queue {
>>  	u32				min_buffers_needed;
>>
>>  /* private: internal use only */
>> +	struct mutex			queue_lock;
>>  	enum v4l2_memory		memory;
>>  	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
>>  	unsigned int			num_buffers;
> 

