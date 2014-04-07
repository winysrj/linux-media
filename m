Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52336 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbaDGOli (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 10:41:38 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3O00BQI0TCO580@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Apr 2014 15:41:36 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'John Sheu' <sheu@google.com>, linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, posciak@google.com, arun.m@samsung.com,
	kgene.kim@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>
References: <1394578325-11298-1-git-send-email-sheu@google.com>
 <1394578325-11298-5-git-send-email-sheu@google.com>
In-reply-to: <1394578325-11298-5-git-send-email-sheu@google.com>
Subject: RE: [PATCH 4/4] v4l2-mem2mem: allow reqbufs(0) with "in use" MMAP
 buffers
Date: Mon, 07 Apr 2014 16:41:36 +0200
Message-id: <06c801cf526f$7b0498a0$710dc9e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pawel, Marek,

Before taking this to my tree I wanted to get an ACK from one of the
videobuf2 maintainers. Could you spare a moment to look through this
patch?

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: John Sheu [mailto:sheu@google.com]
> Sent: Tuesday, March 11, 2014 11:52 PM
> To: linux-media@vger.kernel.org
> Cc: m.chehab@samsung.com; k.debski@samsung.com; posciak@google.com;
> arun.m@samsung.com; kgene.kim@samsung.com; John Sheu
> Subject: [PATCH 4/4] v4l2-mem2mem: allow reqbufs(0) with "in use" MMAP
> buffers
> 
> v4l2-mem2mem presently does not allow VIDIOC_REQBUFS to destroy
> outstanding buffers if the queue is of type V4L2_MEMORY_MMAP, and if
> the buffers are considered "in use".  This is different behavior than
> for other memory types, and prevents us for deallocating buffers in a
> few
> cases:
> 
> * In the case that there are outstanding mmap()ed views on the buffer,
>   refcounting on the videobuf2 buffer backing the vm_area will track
>   lifetime appropriately,
> * In the case that the buffer has been exported as a DMABUF,
> refcounting
>   on the videobuf2 bufer backing the DMABUF will track lifetime
>   appropriately.
> 
> Remove the specific check for type V4L2_MEMOMRY_MMAP when freeing all
> buffers through VIDIOC_REQBUFS.
> 
> Signed-off-by: John Sheu <sheu@google.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 26 +-----------------------
> --
>  1 file changed, 1 insertion(+), 25 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c
> index 8e6695c9..5b6f9da6 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -414,8 +414,7 @@ static int __verify_length(struct vb2_buffer *vb,
> const struct v4l2_buffer *b)  }
> 
>  /**
> - * __buffer_in_use() - return true if the buffer is in use and
> - * the queue cannot be freed (by the means of REQBUFS(0)) call
> + * __buffer_in_use() - return true if the buffer is in use.
>   */
>  static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer
> *vb)  { @@ -435,20 +434,6 @@ static bool __buffer_in_use(struct
> vb2_queue *q, struct vb2_buffer *vb)  }
> 
>  /**
> - * __buffers_in_use() - return true if any buffers on the queue are in
> use and
> - * the queue cannot be freed (by the means of REQBUFS(0)) call
> - */
> -static bool __buffers_in_use(struct vb2_queue *q) -{
> -	unsigned int buffer;
> -	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> -		if (__buffer_in_use(q, q->bufs[buffer]))
> -			return true;
> -	}
> -	return false;
> -}
> -
> -/**
>   * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with
> information to be
>   * returned to userspace
>   */
> @@ -681,15 +666,6 @@ static int __reqbufs(struct vb2_queue *q, struct
> v4l2_requestbuffers *req)
>  	}
> 
>  	if (req->count == 0 || q->num_buffers != 0 || q->memory != req-
> >memory) {
> -		/*
> -		 * We already have buffers allocated, so first check if
> they
> -		 * are not in use and can be freed.
> -		 */
> -		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
> -			dprintk(1, "reqbufs: memory in use, cannot free\n");
> -			return -EBUSY;
> -		}
> -
>  		ret = __vb2_queue_free(q, q->num_buffers);
>  		if (ret)
>  			return ret;
> --
> 1.9.0.279.gdc9e3eb

