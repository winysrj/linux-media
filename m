Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33938 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaHEAEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 20:04:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCHv2] videobuf2: fix lockdep warning
Date: Tue, 05 Aug 2014 02:04:30 +0200
Message-ID: <82778243.v34EWnYyY9@avalon>
In-Reply-To: <53DF78B0.8000209@xs4all.nl>
References: <53DF78B0.8000209@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 04 August 2014 14:12:32 Hans Verkuil wrote:
> Changes since v1: use a spinlock instead of playing around with mmap_sem
> since current->mm might point to different entities as pointed out by
> Marek.
> 
> The following lockdep warning has been there ever since commit
> a517cca6b24fc54ac209e44118ec8962051662e3 one year ago:

[snip]

> The reason is that vb2_fop_mmap and vb2_fop_get_unmapped_area take the core
> lock while they are called with the mmap_sem semaphore held. But elsewhere
> in the code the core lock is taken first but calls to copy_to/from_user()
> can take the mmap_sem semaphore as well, potentially causing a classical
> A-B/B-A deadlock.
> 
> However, the mmap/get_unmapped_area calls really shouldn't take the core
> lock at all. So what would happen if they don't take the core lock anymore?
> 
> There are two situations that need to be taken into account: calling mmap
> while new buffers are being added and calling mmap while buffers are being
> deleted.
> 
> The first case works fine without a lock: in all cases mmap relies on
> correctly filled-in q->num_buffers/q->num_planes values and those are only
> updated after any new buffers have been initialized completely. So it will
> never get partially initialized buffer information.
> 
> The second case does pose a problem: buffers may be in the process of being
> deleted, without the internal structure being updated.
> 
> The core issue is that mem_priv may be non-NULL when it is already freed.
> The solution I chose is to add a spinlock that is taken whenever mem_priv
> is changed and when vb2_mmap() and vb2_fop_get_unmapped_area() need it.
> That way those functions can be certain that mem_priv can be relied upon.

I think you introduce a race condition. __reqbufs() will first check whether 
any buffer is in use by calling __buffers_in_use() and will the proceed to 
free the buffers with __vb2_queue_free(). If a buffer is mmap()ed between the 
two calls I believe vb2 will happily free the memory with this patch applied.

Also, are all the memops mmap() implementations safe to be called with a 
spinlock held, or could some of them need to sleep ? How costly can they be in 
terms of CPU time ?

> As an additional bonus the hack in __buf_prepare, the USERPTR case, can be
> removed as well since mmap() no longer takes the core lock.
> 
> All-in-all a much cleaner solution.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 105 ++++++++++++++--------------
>  include/media/videobuf2-core.h           |   2 +
>  2 files changed, 58 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index c359006..18bf059 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -205,7 +205,9 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  			goto free;
> 
>  		/* Associate allocator private data with this plane */
> +		spin_lock(&vb->planes_lock);
>  		vb->planes[plane].mem_priv = mem_priv;
> +		spin_unlock(&vb->planes_lock);
>  		vb->v4l2_planes[plane].length = q->plane_sizes[plane];
>  	}
> 
> @@ -213,8 +215,12 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  free:
>  	/* Free already allocated memory if one of the allocations failed */
>  	for (; plane > 0; --plane) {
> -		call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
> +		mem_priv = vb->planes[plane - 1].mem_priv;
> +
> +		spin_lock(&vb->planes_lock);
>  		vb->planes[plane - 1].mem_priv = NULL;
> +		spin_unlock(&vb->planes_lock);
> +		call_void_memop(vb, put, mem_priv);
>  	}
> 
>  	return -ENOMEM;
> @@ -228,8 +234,21 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
>  	unsigned int plane;
> 
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
> -		call_void_memop(vb, put, vb->planes[plane].mem_priv);
> +		void *mem_priv = vb->planes[plane].mem_priv;
> +
> +		/*
> +		 * There is a potential race condition between mmap() and
> +		 * __vb2_buf_mem_free() where mmap() might map a buffer that is
> +		 * about to be freed. So before we delete it we take the
> +		 * planes_lock, set mem_priv to NULL and release the spinlock
> +		 * again. Since vb2_mmap() uses the same spinlock it can never
> +		 * read a stale mem_priv pointer.
> +		 */
> +		spin_lock(&vb->planes_lock);
>  		vb->planes[plane].mem_priv = NULL;
> +		spin_unlock(&vb->planes_lock);
> +
> +		call_void_memop(vb, put, mem_priv);
>  		dprintk(3, "freed plane %d of buffer %d\n", plane,
>  			vb->v4l2_buf.index);
>  	}
> @@ -244,9 +263,14 @@ static void __vb2_buf_userptr_put(struct vb2_buffer
> *vb) unsigned int plane;
> 
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
> -		if (vb->planes[plane].mem_priv)
> -			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
> -		vb->planes[plane].mem_priv = NULL;
> +		void *mem_priv = vb->planes[plane].mem_priv;
> +
> +		if (mem_priv) {
> +			spin_lock(&vb->planes_lock);
> +			vb->planes[plane].mem_priv = NULL;
> +			spin_unlock(&vb->planes_lock);
> +			call_void_memop(vb, put_userptr, mem_priv);
> +		}
>  	}
>  }
> 
> @@ -256,13 +280,18 @@ static void __vb2_buf_userptr_put(struct vb2_buffer
> *vb) */
>  static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane
> *p) {
> -	if (!p->mem_priv)
> +	void *mem_priv = p->mem_priv;
> +
> +	if (!mem_priv)
>  		return;
> 
> +	spin_lock(&vb->planes_lock);
> +	p->mem_priv = NULL;
> +	spin_unlock(&vb->planes_lock);
>  	if (p->dbuf_mapped)
> -		call_void_memop(vb, unmap_dmabuf, p->mem_priv);
> +		call_void_memop(vb, unmap_dmabuf, mem_priv);
> 
> -	call_void_memop(vb, detach_dmabuf, p->mem_priv);
> +	call_void_memop(vb, detach_dmabuf, mem_priv);
>  	dma_buf_put(p->dbuf);
>  	memset(p, 0, sizeof(*p));
>  }
> @@ -366,6 +395,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum
> v4l2_memory memory, vb->v4l2_buf.index = q->num_buffers + buffer;
>  		vb->v4l2_buf.type = q->type;
>  		vb->v4l2_buf.memory = memory;
> +		spin_lock_init(&vb->planes_lock);
> 
>  		/* Allocate video buffer memory for the MMAP type */
>  		if (memory == V4L2_MEMORY_MMAP) {
> @@ -1347,7 +1377,6 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) {
>  	struct v4l2_plane planes[VIDEO_MAX_PLANES];
>  	struct vb2_queue *q = vb->vb2_queue;
> -	void *mem_priv;
>  	unsigned int plane;
>  	int ret;
>  	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
> @@ -1358,6 +1387,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) __fill_vb2_buffer(vb, b, planes);
> 
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		void *mem_priv = vb->planes[plane].mem_priv;
> +
>  		/* Skip the plane if already verified */
>  		if (vb->v4l2_planes[plane].m.userptr &&
>  		    vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
> @@ -1378,15 +1409,17 @@ static int __qbuf_userptr(struct vb2_buffer *vb,
> const struct v4l2_buffer *b) }
> 
>  		/* Release previously acquired memory if present */
> -		if (vb->planes[plane].mem_priv) {
> +		if (mem_priv) {
>  			if (!reacquired) {
>  				reacquired = true;
>  				call_void_vb_qop(vb, buf_cleanup, vb);
>  			}
> -			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
> +			spin_lock(&vb->planes_lock);
> +			vb->planes[plane].mem_priv = NULL;
> +			spin_unlock(&vb->planes_lock);
> +			call_void_memop(vb, put_userptr, mem_priv);
>  		}
> 
> -		vb->planes[plane].mem_priv = NULL;
>  		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
> 
>  		/* Acquire each plane's memory */
> @@ -1399,7 +1432,9 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
>  			goto err;
>  		}
> +		spin_lock(&vb->planes_lock);
>  		vb->planes[plane].mem_priv = mem_priv;
> +		spin_unlock(&vb->planes_lock);
>  	}
> 
>  	/*
> @@ -1510,7 +1545,9 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) }
> 
>  		vb->planes[plane].dbuf = dbuf;
> +		spin_lock(&vb->planes_lock);
>  		vb->planes[plane].mem_priv = mem_priv;
> +		spin_unlock(&vb->planes_lock);
>  	}
> 
>  	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
> @@ -1582,7 +1619,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer
> *b) {
>  	struct vb2_queue *q = vb->vb2_queue;
> -	struct rw_semaphore *mmap_sem;
>  	int ret;
> 
>  	ret = __verify_length(vb, b);
> @@ -1619,26 +1655,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) ret = __qbuf_mmap(vb, b);
>  		break;
>  	case V4L2_MEMORY_USERPTR:
> -		/*
> -		 * In case of user pointer buffers vb2 allocators need to get
> -		 * direct access to userspace pages. This requires getting
> -		 * the mmap semaphore for read access in the current process
> -		 * structure. The same semaphore is taken before calling mmap
> -		 * operation, while both qbuf/prepare_buf and mmap are called
> -		 * by the driver or v4l2 core with the driver's lock held.
> -		 * To avoid an AB-BA deadlock (mmap_sem then driver's lock in
> -		 * mmap and driver's lock then mmap_sem in qbuf/prepare_buf),
> -		 * the videobuf2 core releases the driver's lock, takes
> -		 * mmap_sem and then takes the driver's lock again.
> -		 */
> -		mmap_sem = &current->mm->mmap_sem;
> -		call_void_qop(q, wait_prepare, q);
> -		down_read(mmap_sem);
> -		call_void_qop(q, wait_finish, q);
> -
>  		ret = __qbuf_userptr(vb, b);
> -
> -		up_read(mmap_sem);
>  		break;
>  	case V4L2_MEMORY_DMABUF:
>  		ret = __qbuf_dmabuf(vb, b);
> @@ -2485,7 +2502,9 @@ int vb2_mmap(struct vb2_queue *q, struct
> vm_area_struct *vma) return -EINVAL;
>  	}
> 
> +	spin_lock(&vb->planes_lock);
>  	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
> +	spin_unlock(&vb->planes_lock);
>  	if (ret)
>  		return ret;
> 
> @@ -2504,6 +2523,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue
> *q, unsigned long off = pgoff << PAGE_SHIFT;
>  	struct vb2_buffer *vb;
>  	unsigned int buffer, plane;
> +	void *vaddr;
>  	int ret;
> 
>  	if (q->memory != V4L2_MEMORY_MMAP) {
> @@ -2520,7 +2540,8 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue
> *q,
> 
>  	vb = q->bufs[buffer];
> 
> -	return (unsigned long)vb2_plane_vaddr(vb, plane);
> +	vaddr = vb2_plane_vaddr(vb, plane);
> +	return vaddr ? (unsigned long)vaddr : -EINVAL;
>  }
>  EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
>  #endif
> @@ -3346,15 +3367,8 @@ EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
>  int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	struct video_device *vdev = video_devdata(file);
> -	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> -	int err;
> 
> -	if (lock && mutex_lock_interruptible(lock))
> -		return -ERESTARTSYS;
> -	err = vb2_mmap(vdev->queue, vma);
> -	if (lock)
> -		mutex_unlock(lock);
> -	return err;
> +	return vb2_mmap(vdev->queue, vma);
>  }
>  EXPORT_SYMBOL_GPL(vb2_fop_mmap);
> 
> @@ -3473,15 +3487,8 @@ unsigned long vb2_fop_get_unmapped_area(struct file
> *file, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned
> long flags)
>  {
>  	struct video_device *vdev = video_devdata(file);
> -	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> -	int ret;
> 
> -	if (lock && mutex_lock_interruptible(lock))
> -		return -ERESTARTSYS;
> -	ret = vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
> -	if (lock)
> -		mutex_unlock(lock);
> -	return ret;
> +	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
>  }
>  EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
>  #endif
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index fc910a6..551d334 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -187,6 +187,7 @@ struct vb2_queue;
>   *			buffers queued from userspace
>   * @done_entry:		entry on the list that stores all buffers ready to
>   *			be dequeued to userspace
> + * @planes_lock:	private spinlock for the per-plane information
>   * @planes:		private per-plane information; do not change
>   */
>  struct vb2_buffer {
> @@ -203,6 +204,7 @@ struct vb2_buffer {
>  	struct list_head	queued_entry;
>  	struct list_head	done_entry;
> 
> +	spinlock_t		planes_lock;
>  	struct vb2_plane	planes[VIDEO_MAX_PLANES];
> 
>  #ifdef CONFIG_VIDEO_ADV_DEBUG

-- 
Regards,

Laurent Pinchart

