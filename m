Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33952 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755398AbcLQAhd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 19:37:33 -0500
Date: Sat, 17 Dec 2016 02:36:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        Samu Onkalo <samu.onkalo@intel.com>
Subject: Re: [RFC RESEND 05/11] v4l2-core: Don't sync cache for a buffer if
 so requested
Message-ID: <20161217003659.GO16630@valkosipuli.retiisi.org.uk>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
 <1441972234-8643-6-git-send-email-sakari.ailus@linux.intel.com>
 <8149441.9mS3xkgL8S@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8149441.9mS3xkgL8S@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Dec 15, 2016 at 10:37:20PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday 11 Sep 2015 14:50:28 Sakari Ailus wrote:
> > From: Samu Onkalo <samu.onkalo@intel.com>
> > 
> > The user may request to the driver (vb2) to skip the cache maintenance
> > operations in case the buffer does not need cache synchronisation, e.g. in
> > cases where the buffer is passed between hardware blocks without it being
> > touched by the CPU.
> > 
> > Also document that the prepare and finish vb2_mem_ops might not get called
> > every time the buffer ownership changes between the kernel and the user
> > space.
> > 
> > Signed-off-by: Samu Onkalo <samu.onkalo@intel.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/videobuf2-core.c | 52 ++++++++++++++++++++++-------
> >  include/media/videobuf2-core.h           | 12 +++++---
> >  2 files changed, 49 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c index c5c0707a..b664024 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -187,6 +187,28 @@ static void __vb2_queue_cancel(struct vb2_queue *q);
> >  static void __enqueue_in_driver(struct vb2_buffer *vb);
> > 
> >  /**
> > + * __mem_prepare_planes() - call finish mem op for all planes of the buffer
> > + */
> > +static void __mem_prepare_planes(struct vb2_buffer *vb)
> > +{
> > +	unsigned int plane;
> > +
> > +	for (plane = 0; plane < vb->num_planes; ++plane)
> > +		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
> > +}
> > +
> > +/**
> > + * __mem_finish_planes() - call finish mem op for all planes of the buffer
> > + */
> > +static void __mem_finish_planes(struct vb2_buffer *vb)
> > +{
> > +	unsigned int plane;
> > +
> > +	for (plane = 0; plane < vb->num_planes; ++plane)
> > +		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> > +}
> > +
> > +/**
> >   * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
> >   */
> >  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> > @@ -1391,6 +1413,10 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb,
> > const struct v4l2_buffer *b static int __prepare_mmap(struct vb2_buffer
> > *vb, const struct v4l2_buffer *b) {
> >  	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
> > +
> > +	if (!(b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC))
> > +		__mem_prepare_planes(vb);
> > +
> >  	return call_vb_qop(vb, buf_prepare, vb);
> >  }
> > 
> > @@ -1476,6 +1502,11 @@ static int __prepare_userptr(struct vb2_buffer *vb,
> >  			dprintk(1, "buffer initialization failed\n");
> >  			goto err;
> >  		}
> > +
> > +		/* This is new buffer memory --- always synchronise cache. */
> > +		__mem_prepare_planes(vb);
> > +	} else if (!(b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC)) {
> > +		__mem_prepare_planes(vb);
> >  	}
> > 
> >  	ret = call_vb_qop(vb, buf_prepare, vb);
> > @@ -1601,6 +1632,11 @@ static int __prepare_dmabuf(struct vb2_buffer *vb,
> > const struct v4l2_buffer *b) dprintk(1, "buffer initialization failed\n");
> >  			goto err;
> >  		}
> > +
> > +		/* This is new buffer memory --- always synchronise cache. */
> > +		__mem_prepare_planes(vb);
> > +	} else if (!(b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC)) {
> > +		__mem_prepare_planes(vb);
> >  	}
> > 
> >  	ret = call_vb_qop(vb, buf_prepare, vb);
> > @@ -1624,7 +1660,6 @@ err:
> >  static void __enqueue_in_driver(struct vb2_buffer *vb)
> >  {
> >  	struct vb2_queue *q = vb->vb2_queue;
> > -	unsigned int plane;
> > 
> >  	vb->state = VB2_BUF_STATE_ACTIVE;
> >  	atomic_inc(&q->owned_by_drv_count);
> > @@ -1691,10 +1726,6 @@ static int __buf_prepare(struct vb2_buffer *vb, const
> > struct v4l2_buffer *b) return ret;
> >  	}
> > 
> > -	/* sync buffers */
> > -	for (plane = 0; plane < vb->num_planes; ++plane)
> > -		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
> > -
> >  	vb->state = VB2_BUF_STATE_PREPARED;
> > 
> >  	return 0;
> > @@ -2078,7 +2109,7 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
> >  /**
> >   * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
> >   */
> > -static void __vb2_dqbuf(struct vb2_buffer *vb)
> > +static void __vb2_dqbuf(struct vb2_buffer *vb, bool no_cache_sync)
> >  {
> >  	struct vb2_queue *q = vb->vb2_queue;
> >  	unsigned int plane;
> > @@ -2089,9 +2120,8 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
> > 
> >  	vb->state = VB2_BUF_STATE_DEQUEUED;
> > 
> > -	/* sync buffers */
> > -	for (plane = 0; plane < vb->num_planes; plane++)
> > -		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> > +	if (!no_cache_sync)
> > +		__mem_finish_planes(vb);
> > 
> >  	/* unmap DMABUF buffer */
> >  	if (q->memory == V4L2_MEMORY_DMABUF)
> > @@ -2143,7 +2173,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q,
> > struct v4l2_buffer *b, bool n vb->v4l2_buf.flags & V4L2_BUF_FLAG_LAST)
> >  		q->last_buffer_dequeued = true;
> >  	/* go back to dequeued state */
> > -	__vb2_dqbuf(vb);
> > +	__vb2_dqbuf(vb, b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC);
> > 
> >  	dprintk(1, "dqbuf of buffer %d, with state %d\n",
> >  			vb->v4l2_buf.index, vb->state);
> > @@ -2246,7 +2276,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
> >  			vb->state = VB2_BUF_STATE_PREPARED;
> >  			call_void_vb_qop(vb, buf_finish, vb);
> >  		}
> > -		__vb2_dqbuf(vb);
> > +		__vb2_dqbuf(vb, false);
> >  	}
> >  }
> > 
> > diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> > index 4f7f7ae..a825bd5 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -59,10 +59,14 @@ struct vb2_threadio_data;
> >   *		dmabuf.
> >   * @unmap_dmabuf: releases access control to the dmabuf - allocator is
> > notified
> > *		  that this driver is done using the dmabuf for now.
> > - * @prepare:	called every time the buffer is passed from userspace to the
> > - *		driver, useful for cache synchronisation, optional.
> > - * @finish:	called every time the buffer is passed back from the driver
> > - *		to the userspace, also optional.
> > + * @prepare:	Called on the plane when the buffer ownership is passed from
> > + *		the user space to the kernel and the plane must be cache
> > + *		syncronised. The V4L2_BUF_FLAG_NO_CACHE_SYNC buffer flag may
> 
> s/syncronised/synchronised/
> 
> > + *		be used to skip this call. Optional.
> 
> I would say "The call might be skipped by the videobuf core when the 
> V4L2_BUF_FLAG_NO_CACHE_SYNC buffer flag is set". Your wording could mean that 
> the memops implementation is free to skip cache synchronization internally if 
> the flag is set.
> 
> If the core skips the prepare and finish operations based on the 
> V4L2_BUF_FLAG_NO_CACHE_SYNC flag then those operations must not perform 
> anything else than cache synchronization. That's fine with the current 
> implementation, but it should be documented as such, and I'd rename the 
> operations to sync_for_cpu and sync_for dev (or something similar).

Sounds good to me.

> 
> > + * @finish:	Called on the plane when the buffer ownership is passed from
> > + *		the kernel to the user space and the plane must be cache
> > + *		syncronised. The V4L2_BUF_FLAG_NO_CACHE_SYNC buffer flag may
> > + *		be used to skip this call. Optional.
> 
> Same comment here.
> 
> >   * @vaddr:	return a kernel virtual address to a given memory buffer
> >   *		associated with the passed private structure or NULL if no
> >   *		such mapping exists.
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
