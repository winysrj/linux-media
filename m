Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38696 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725783AbeKNI2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 03:28:00 -0500
Date: Wed, 14 Nov 2018 00:27:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Subject: Re: [PATCH] media: vb2: Allow reqbufs(0) with "in use" MMAP buffers
Message-ID: <20181113222743.bt452a3xyapuv7ce@valkosipuli.retiisi.org.uk>
References: <20181113150621.22276-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113150621.22276-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tue, Nov 13, 2018 at 04:06:21PM +0100, Philipp Zabel wrote:
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
> To let userspace know that the kernel now supports orphaning buffers
> that are still in use, add a new V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
> to be set by reqbufs and create_bufs.
> 
> Signed-off-by: John Sheu <sheu@chromium.org>
> Reviewed-by: Pawel Osciak <posciak@chromium.org>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> [p.zabel@pengutronix.de: moved __vb2_queue_cancel out of the mmap_lock
>  and added V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS]
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

This lets the user to allocate lots of mmap'ed buffers that are pinned in
physical memory. Considering that we don't really have a proper mechanism
to limit that anyway,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

That said, the patch must be accompanied by the documentation change in
Documentation/media/uapi/v4l/vidioc-reqbufs.rst .

I wonder what Hans thinks.

> ---
>  .../media/common/videobuf2/videobuf2-core.c   | 26 +------------------
>  .../media/common/videobuf2/videobuf2-v4l2.c   |  2 +-
>  include/uapi/linux/videodev2.h                |  1 +
>  3 files changed, 3 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 975ff5669f72..608459450c1e 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -553,20 +553,6 @@ bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>  }
>  EXPORT_SYMBOL(vb2_buffer_in_use);
>  
> -/*
> - * __buffers_in_use() - return true if any buffers on the queue are in use and
> - * the queue cannot be freed (by the means of REQBUFS(0)) call
> - */
> -static bool __buffers_in_use(struct vb2_queue *q)
> -{
> -	unsigned int buffer;
> -	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> -		if (vb2_buffer_in_use(q, q->bufs[buffer]))
> -			return true;
> -	}
> -	return false;
> -}
> -
>  void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
>  {
>  	call_void_bufop(q, fill_user_buffer, q->bufs[index], pb);
> @@ -674,23 +660,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  
>  	if (*count == 0 || q->num_buffers != 0 ||
>  	    (q->memory != VB2_MEMORY_UNKNOWN && q->memory != memory)) {
> -		/*
> -		 * We already have buffers allocated, so first check if they
> -		 * are not in use and can be freed.
> -		 */
> -		mutex_lock(&q->mmap_lock);
> -		if (q->memory == VB2_MEMORY_MMAP && __buffers_in_use(q)) {
> -			mutex_unlock(&q->mmap_lock);
> -			dprintk(1, "memory in use, cannot free\n");
> -			return -EBUSY;
> -		}
> -
>  		/*
>  		 * Call queue_cancel to clean up any buffers in the
>  		 * QUEUED state which is possible if buffers were prepared or
>  		 * queued without ever calling STREAMON.
>  		 */
>  		__vb2_queue_cancel(q);
> +		mutex_lock(&q->mmap_lock);
>  		ret = __vb2_queue_free(q, q->num_buffers);
>  		mutex_unlock(&q->mmap_lock);
>  		if (ret)
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index a17033ab2c22..f02d452ceeb9 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -624,7 +624,7 @@ EXPORT_SYMBOL(vb2_querybuf);
>  
>  static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
>  {
> -	*caps = 0;
> +	*caps = V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS;
>  	if (q->io_modes & VB2_MMAP)
>  		*caps |= V4L2_BUF_CAP_SUPPORTS_MMAP;
>  	if (q->io_modes & VB2_USERPTR)
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index c8e8ff810190..2a223835214c 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -879,6 +879,7 @@ struct v4l2_requestbuffers {
>  #define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
>  #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
>  #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
> +#define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
>  
>  /**
>   * struct v4l2_plane - plane info for multi-planar buffers

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
