Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33828 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbbJOJcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 05:32:14 -0400
Message-ID: <561F7240.9010505@xs4all.nl>
Date: Thu, 15 Oct 2015 11:30:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <posciak@chromium.org>,
	Daniel Kurtz <djkurtz@chromium.org>,
	John Sheu <sheu@chromium.org>
Subject: Re: [PATCH] media: vb2: Allow reqbufs(0) with "in use" MMAP buffers
References: <1444899925-22608-1-git-send-email-tfiga@chromium.org>
In-Reply-To: <1444899925-22608-1-git-send-email-tfiga@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

I think this makes sense. After all, just closing the filehandle has the
same effect. However, I would like to see some documentation improvements
to go along with this vb2 patch.

1) The VIDIOC_REQBUFS ioctl documentation needs to be extended so it
describes that it is OK to do this (release all buffers even if still mapped),
and mention that the memory remains in use unless userspace unmaps. This to
prevent users from thinking REQBUFS(X) will somehow unmap automatically.

2) Here http://hverkuil.home.xs4all.nl/spec/media.html#mmap the spec mentions
that "This ioctl can also be used to change the number of buffers or to free
the allocated memory, provided none of the buffers are still mapped.". This
needs to be updated.

After making this change, does v4l2-compliance still work? I don't think I
have a test there that checks if reqbufs(0) fails if buffers are still
mmapped, but I'm not 100% certain either.

Regards,

	Hans

On 10/15/15 11:05, Tomasz Figa wrote:
> From: John Sheu <sheu@chromium.org>
> 
> Videobuf2 presently does not allow VIDIOC_REQBUFS to destroy outstanding
> buffers if the queue is of type V4L2_MEMORY_MMAP, and if the buffers are
> considered "in use".  This is different behavior than for other memory
> types and prevents us from deallocating buffers in following two cases:
> 
> 1) There are outstanding mmap()ed views on the buffer. However even if
>    we put the buffer in reqbufs(0), there will be remaining references,
>    due to vma .open/close() adjusting vb2 buffer refcount appropriately.
>    This means that the buffer will be in fact freed only when the last
>    mmap()ed view is unmapped.
> 
> 2) Buffer has been exported as a DMABUF. Refcount of the vb2 buffer
>    is managed properly by VB2 DMABUF ops, i.e. incremented on DMABUF
>    get and decremented on DMABUF release. This means that the buffer
>    will be alive until all importers release it.
> 
> Considering both cases above, there does not seem to be any need to
> prevent reqbufs(0) operation, because buffer lifetime is already
> properly managed by both mmap() and DMABUF code paths. Let's remove it
> and allow userspace freeing the queue (and potentially allocating a new
> one) even though old buffers might be still in processing.
> 
> Signed-off-by: John Sheu <sheu@chromium.org>
> Reviewed-by: Pawel Osciak <posciak@chromium.org>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 22 ----------------------
>  1 file changed, 22 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 4f59b7e..931c5de 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -636,19 +636,6 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>  	return false;
>  }
>  
> -/**
> - * __buffers_in_use() - return true if any buffers on the queue are in use and
> - * the queue cannot be freed (by the means of REQBUFS(0)) call
> - */
> -static bool __buffers_in_use(struct vb2_queue *q)
> -{
> -	unsigned int buffer;
> -	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> -		if (__buffer_in_use(q, q->bufs[buffer]))
> -			return true;
> -	}
> -	return false;
> -}
>  
>  /**
>   * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
> @@ -884,16 +871,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  	}
>  
>  	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
> -		/*
> -		 * We already have buffers allocated, so first check if they
> -		 * are not in use and can be freed.
> -		 */
>  		mutex_lock(&q->mmap_lock);
> -		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
> -			mutex_unlock(&q->mmap_lock);
> -			dprintk(1, "memory in use, cannot free\n");
> -			return -EBUSY;
> -		}
>  
>  		/*
>  		 * Call queue_cancel to clean up any buffers in the PREPARED or
> 
