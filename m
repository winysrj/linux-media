Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54857 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935385AbeEYGly (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 02:41:54 -0400
MIME-Version: 1.0
In-Reply-To: <20180521165946.11778-2-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com> <20180521165946.11778-2-ezequiel@collabora.com>
From: sathyam panda <panda.sathyam9@gmail.com>
Date: Fri, 25 May 2018 12:11:52 +0530
Message-ID: <CAE6UAyx81nZDQEHuNn0BK5EkB-KmNdSnkiNF+NJTmiUkz72CrA@mail.gmail.com>
Subject: Re: [PATCH v10 01/16] videobuf2: Make struct vb2_buffer refcounted
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, kernel@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 5/21/18, Ezequiel Garcia <ezequiel@collabora.com> wrote:
> The in-fence implementation involves having a per-buffer fence callback,
> that triggers on the fence signal. The fence callback is called
> asynchronously
> and needs a valid reference to the associated ideobuf2 buffer.
>
> Allow this by making the vb2_buffer refcounted, so it can be passed
> to other contexts.
>

-Is it really required, because when a queued buffer with an in_fence
is deallocated, firstly queue is cancelled.
-And __vb2_dqbuf is called which calls dma_fence_remove_callback.
-So if fence callback has been called -__vb2_dqbuf will wait to
acquire fence lock.
-So during execution of fence callback, buffers and queue are still valid.
-And if __vb2_dqbuf remove callback first ,then dma_fence_signal will
wait for lock
- so there won't be any fence callback to call for that buffer when
dma_fence_signal resumes.

> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 27
> ++++++++++++++++++++++---
>  include/media/videobuf2-core.h                  |  7 +++++--
>  2 files changed, 29 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
> b/drivers/media/common/videobuf2/videobuf2-core.c
> index d3f7bb33a54d..f1feb45c1e37 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -190,6 +190,26 @@ module_param(debug, int, 0644);
>  static void __vb2_queue_cancel(struct vb2_queue *q);
>  static void __enqueue_in_driver(struct vb2_buffer *vb);
>
> +static void __vb2_buffer_free(struct kref *kref)
> +{
> +	struct vb2_buffer *vb =
> +		container_of(kref, struct vb2_buffer, refcount);
> +	kfree(vb);
> +}
> +
> +static void __vb2_buffer_put(struct vb2_buffer *vb)
> +{
> +	if (vb)
> +		kref_put(&vb->refcount, __vb2_buffer_free);
> +}
> +
> +static struct vb2_buffer *__vb2_buffer_get(struct vb2_buffer *vb)
> +{
> +	if (vb)
> +		kref_get(&vb->refcount);
> +	return vb;
> +}
> +
>  /*
>   * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
>   */
> @@ -346,6 +366,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum
> vb2_memory memory,
>  			break;
>  		}
>
> +		kref_init(&vb->refcount);
>  		vb->state = VB2_BUF_STATE_DEQUEUED;
>  		vb->vb2_queue = q;
>  		vb->num_planes = num_planes;
> @@ -365,7 +386,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum
> vb2_memory memory,
>  				dprintk(1, "failed allocating memory for buffer %d\n",
>  					buffer);
>  				q->bufs[vb->index] = NULL;
> -				kfree(vb);
> +				__vb2_buffer_put(vb);
>  				break;
>  			}
>  			__setup_offsets(vb);
> @@ -380,7 +401,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum
> vb2_memory memory,
>  					buffer, vb);
>  				__vb2_buf_mem_free(vb);
>  				q->bufs[vb->index] = NULL;
> -				kfree(vb);
> +				__vb2_buffer_put(vb);
>  				break;
>  			}
>  		}
> @@ -520,7 +541,7 @@ static int __vb2_queue_free(struct vb2_queue *q,
> unsigned int buffers)
>  	/* Free videobuf buffers */
>  	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
>  	     ++buffer) {
> -		kfree(q->bufs[buffer]);
> +		__vb2_buffer_put(q->bufs[buffer]);
>  		q->bufs[buffer] = NULL;
>  	}
>
> diff --git a/include/media/videobuf2-core.h
> b/include/media/videobuf2-core.h
> index f6818f732f34..baa4632c7e59 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -12,11 +12,12 @@
>  #ifndef _MEDIA_VIDEOBUF2_CORE_H
>  #define _MEDIA_VIDEOBUF2_CORE_H
>
> +#include <linux/bitops.h>
> +#include <linux/dma-buf.h>
> +#include <linux/kref.h>
>  #include <linux/mm_types.h>
>  #include <linux/mutex.h>
>  #include <linux/poll.h>
> -#include <linux/dma-buf.h>
> -#include <linux/bitops.h>
>
>  #define VB2_MAX_FRAME	(32)
>  #define VB2_MAX_PLANES	(8)
> @@ -249,6 +250,7 @@ struct vb2_buffer {
>
>  	/* private: internal use only
>  	 *
> +	 * refcount:		refcount for this buffer
>  	 * state:		current buffer state; do not change
>  	 * queued_entry:	entry on the queued buffers list, which holds
>  	 *			all buffers queued from userspace
> @@ -256,6 +258,7 @@ struct vb2_buffer {
>  	 *			to be dequeued to userspace
>  	 * vb2_plane:		per-plane information; do not change
>  	 */
> +	struct kref		refcount;
>  	enum vb2_buffer_state	state;
>
>  	struct vb2_plane	planes[VB2_MAX_PLANES];
>

Regards,
 Sathyam
