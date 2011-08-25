Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3818 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1HYLMp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 07:12:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2/RFC] media: vb2: change queue initialization order
Date: Thu, 25 Aug 2011 13:12:23 +0200
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"Uwe =?iso-8859-15?q?Kleine-K=F6nig?="
	<u.kleine-koenig@pengutronix.de>, Marin Mitov <mitov@issp.bas.bg>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1314269531-30080-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1314269531-30080-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251312.23728.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, August 25, 2011 12:52:11 Marek Szyprowski wrote:
> This patch changes the order of operations during stream on call. Now the
> buffers are first queued to the driver and then the start_streaming method
> is called.
> 
> This resolves the most common case when the driver needs to know buffer
> addresses to enable dma engine and start streaming. Additional parameters
> to start_streaming and buffer_queue methods have been added to simplify
> drivers code. The driver are now obliged to check if the number of queued
> buffers is enough to enable hardware streaming. If not - it should return
> an error. In such case all the buffers that have been pre-queued are
> invalidated.
> 
> Drivers that are able to start/stop streaming on-fly, can control dma
> engine directly in buf_queue callback. In this case start_streaming
> callback can be considered as optional. The driver can also assume that
> after a few first buf_queue calls with zero 'streaming' parameter, the core
> will finally call start_streaming callback.

Looks good!

> This patch also updates some videobuf2 clients (s5p-fimc, s5p-mfc, s5p-tv,
> mem2mem_testdev and vivi) to work properly with the changed order of
> operations.

I assume the final patch will update all vb2 clients?

I have a few very minor comments below:

> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/video/mem2mem_testdev.c       |    2 +-
>  drivers/media/video/s5p-fimc/fimc-capture.c |   66 ++++++++++++++++-----------
>  drivers/media/video/s5p-fimc/fimc-core.c    |    2 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c   |    4 +-
>  drivers/media/video/s5p-tv/mixer.h          |    2 -
>  drivers/media/video/s5p-tv/mixer_video.c    |   24 +++++-----
>  drivers/media/video/videobuf2-core.c        |   30 +++++--------
>  drivers/media/video/vivi.c                  |    4 +-
>  include/media/videobuf2-core.h              |   18 +++++--
>  9 files changed, 82 insertions(+), 70 deletions(-)
> ---
> 
> Hello,
> 
> This patch introduces significant changes in the vb2 streamon operation,
> so all vb2 clients need to be checked and updated. Right now I only
> updated virtual and Samsung drivers. Once we agree that this patch can
> be merged, I will update it to include all the required changes for all
> videobuf2 clients as well.
> 
> Best regards
> 
> Marek Szyprowski
> Samsung Poland R&D Center
> 

<snip>

> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index e89fd53..283c6ce 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -823,13 +823,13 @@ static int __qbuf_mmap(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  /**
>   * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
>   */
> -static void __enqueue_in_driver(struct vb2_buffer *vb)
> +static void __enqueue_in_driver(struct vb2_buffer *vb, bool streaming)
>  {
>         struct vb2_queue *q = vb->vb2_queue;
>  
>         vb->state = VB2_BUF_STATE_ACTIVE;
>         atomic_inc(&q->queued_count);
> -       q->ops->buf_queue(vb);
> +       q->ops->buf_queue(vb, streaming);
>  }
>  
>  /**
> @@ -916,7 +916,7 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>          * If not, the buffer will be given to driver on next streamon.
>          */
>         if (q->streaming)
> -               __enqueue_in_driver(vb);
> +               __enqueue_in_driver(vb, 1);

Use 'true' instead of 1.

>  
>         dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
>         return 0;
> @@ -1110,6 +1110,8 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
>  }
>  EXPORT_SYMBOL_GPL(vb2_dqbuf);
>  
> +static void __vb2_queue_cancel(struct vb2_queue *q);
> +

Is it possible to move __vb2_queue_cancel forward instead of having to add a
forward declaration? In general you don't want forward declarations unless
you have some sort of circular dependency.

>  /**
>   * vb2_streamon - start streaming
>   * @q:         videobuf2 queue
> @@ -1144,34 +1146,24 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>         }
>  
>         /*
> -        * Cannot start streaming on an OUTPUT device if no buffers have
> -        * been queued yet.
> +        * If any buffers were queued before streamon,
> +        * we can now pass them to driver for processing.
>          */
> -       if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> -               if (list_empty(&q->queued_list)) {
> -                       dprintk(1, "streamon: no output buffers queued\n");
> -                       return -EINVAL;
> -               }
> -       }
> +       list_for_each_entry(vb, &q->queued_list, queued_entry)
> +               __enqueue_in_driver(vb, 0);

And 'false' instead of 0.

>  
>         /*
>          * Let driver notice that streaming state has been enabled.
>          */
> -       ret = call_qop(q, start_streaming, q);
> +       ret = call_qop(q, start_streaming, q, atomic_read(&q->queued_count));
>         if (ret) {
>                 dprintk(1, "streamon: driver refused to start streaming\n");
> +               __vb2_queue_cancel(q);
>                 return ret;
>         }
>  
>         q->streaming = 1;
>  
> -       /*
> -        * If any buffers were queued before streamon,
> -        * we can now pass them to driver for processing.
> -        */
> -       list_for_each_entry(vb, &q->queued_list, queued_entry)
> -               __enqueue_in_driver(vb);
> -
>         dprintk(3, "Streamon successful\n");
>         return 0;
>  }

<snip>

> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 5287e90..412daf0 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -196,15 +196,23 @@ struct vb2_buffer {
>   *                     before userspace accesses the buffer; optional
>   * @buf_cleanup:       called once before the buffer is freed; drivers may
>   *                     perform any additional cleanup; optional
> - * @start_streaming:   called once before entering 'streaming' state; enables
> - *                     driver to receive buffers over buf_queue() callback
> + * @start_streaming:   called once to enter 'streaming' state; the driver may
> + *                     receive buffers with @buf_queue callback before
> + *                     @start_streaming is called; the driver gets the number
> + *                     of already queued buffers in count parameter; driver
> + *                     can return an error if hardware fails or not enough
> + *                     buffers has been queued, in such case all buffers that
> + *                     have been already given by the @buf_queue callback are
> + *                     invalidated.
>   * @stop_streaming:    called when 'streaming' state must be disabled; driver
>   *                     should stop any DMA transactions or wait until they
>   *                     finish and give back all buffers it got from buf_queue()
>   *                     callback; may use vb2_wait_for_all_buffers() function
>   * @buf_queue:         passes buffer vb to the driver; driver may start
>   *                     hardware operation on this buffer; driver should give
> - *                     the buffer back by calling vb2_buffer_done() function
> + *                     the buffer back by calling vb2_buffer_done() function;
> + *                     'streaming' parameter tells driver wheather streaming
> + *                     state has been enabled not.
>   */
>  struct vb2_ops {
>         int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
> @@ -219,10 +227,10 @@ struct vb2_ops {
>         int (*buf_finish)(struct vb2_buffer *vb);
>         void (*buf_cleanup)(struct vb2_buffer *vb);
>  
> -       int (*start_streaming)(struct vb2_queue *q);
> +       int (*start_streaming)(struct vb2_queue *q, int count);

Perhaps this should be unsigned instead of int?

>         int (*stop_streaming)(struct vb2_queue *q);
>  
> -       void (*buf_queue)(struct vb2_buffer *vb);
> +       void (*buf_queue)(struct vb2_buffer *vb, bool streaming);
>  };
>  
>  /**

Regards,

	Hans
