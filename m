Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:56866 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaFFFb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 01:31:56 -0400
Received: by mail-qg0-f47.google.com with SMTP id j107so3412552qga.34
        for <linux-media@vger.kernel.org>; Thu, 05 Jun 2014 22:31:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401970991-4421-3-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1401970991-4421-3-git-send-email-laurent.pinchart@ideasonboard.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 6 Jun 2014 14:31:15 +0900
Message-ID: <CAMm-=zCQsPP4k1RDtVfHxk4AWhLESUMDT=+aHnM3nReBtpa8qA@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 2/2] v4l: vb2: Add fatal error condition flag
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
Thanks for the patch. Did you test this to work in fileio mode? Looks
like it should, but would like to make sure.
Thanks,
Pawel

On Thu, Jun 5, 2014 at 9:23 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> When a fatal error occurs that render the device unusable, the only
> options for a driver to signal the error condition to userspace is to
> set the V4L2_BUF_FLAG_ERROR flag when dequeuing buffers and to return an
> error from the buffer prepare handler when queuing buffers.
>
> The buffer error flag indicates a transient error and can't be used by
> applications to detect fatal errors. Returning an error from vb2_qbuf()
> is thus the only real indication that a fatal error occurred. However,
> this is difficult to handle for multithreaded applications that requeue
> buffers from a thread other than the control thread. In particular the
> poll() call in the control thread will not notify userspace of the
> error.
>
> This patch adds an explicit mechanism to report fatal errors to
> userspace. Applications can call the vb2_queue_error() function to
> signal a fatal error. From this moment on, buffer preparation will
> return -EIO to userspace, and vb2_poll() will set the POLLERR flag and
> return immediately. The error flag is cleared when cancelling the queue,
> either at stream off time (through vb2_streamoff) or when releasing the
> queue with vb2_queue_release().
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 40 +++++++++++++++++++++++++++++---
>  include/media/videobuf2-core.h           |  3 +++
>  2 files changed, 40 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index fd428e0..c7aa07d 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1582,6 +1582,11 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                 return -EINVAL;
>         }
>
> +       if (q->error) {
> +               dprintk(1, "fatal error occurred on queue\n");
> +               return -EIO;
> +       }
> +
>         vb->state = VB2_BUF_STATE_PREPARING;
>         vb->v4l2_buf.timestamp.tv_sec = 0;
>         vb->v4l2_buf.timestamp.tv_usec = 0;
> @@ -1877,6 +1882,11 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>                         return -EINVAL;
>                 }
>
> +               if (q->error) {
> +                       dprintk(1, "Queue in error state, will not wait for buffers\n");
> +                       return -EIO;
> +               }
> +
>                 if (!list_empty(&q->done_list)) {
>                         /*
>                          * Found a buffer that we were waiting for.
> @@ -1902,7 +1912,8 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>                  */
>                 dprintk(3, "will sleep waiting for buffers\n");
>                 ret = wait_event_interruptible(q->done_wq,
> -                               !list_empty(&q->done_list) || !q->streaming);
> +                               !list_empty(&q->done_list) || !q->streaming ||
> +                               q->error);
>
>                 /*
>                  * We need to reevaluate both conditions again after reacquiring
> @@ -2099,6 +2110,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>         q->streaming = 0;
>         q->start_streaming_called = 0;
>         q->queued_count = 0;
> +       q->error = 0;
>
>         /*
>          * Remove all buffers from videobuf's list...
> @@ -2176,6 +2188,27 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>  }
>
>  /**
> + * vb2_queue_error() - signal a fatal error on the queue
> + * @q:         videobuf2 queue
> + *
> + * Flag that a fatal unrecoverable error has occurred and wake up all processes
> + * waiting on the queue. Polling will now set POLLERR and queuing and dequeuing
> + * buffers will return -EIO.
> + *
> + * The error flag will be cleared when cancelling the queue, either from
> + * vb2_streamoff or vb2_queue_release. Drivers should thus not call this
> + * function before starting the stream, otherwise the error flag will remain set
> + * until the queue is released when closing the device node.
> + */
> +void vb2_queue_error(struct vb2_queue *q)
> +{
> +       q->error = 1;
> +
> +       wake_up_all(&q->done_wq);
> +}
> +EXPORT_SYMBOL_GPL(vb2_queue_error);
> +
> +/**
>   * vb2_streamon - start streaming
>   * @q:         videobuf2 queue
>   * @type:      type argument passed from userspace to vidioc_streamon handler
> @@ -2533,9 +2566,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>         }
>
>         /*
> -        * There is nothing to wait for if the queue isn't streaming.
> +        * There is nothing to wait for if the queue isn't streaming or if the
> +        * error flag is set.
>          */
> -       if (!vb2_is_streaming(q))
> +       if (!vb2_is_streaming(q) || q->error)
>                 return res | POLLERR;
>
>         if (list_empty(&q->done_list))
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index bca25dc..5a67f31 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -375,6 +375,7 @@ struct v4l2_fh;
>   * @streaming: current streaming state
>   * @start_streaming_called: start_streaming() was called successfully and we
>   *             started streaming.
> + * @error:     a fatal error occured on the queue
>   * @fileio:    file io emulator internal data, used only if emulator is active
>   * @threadio:  thread io internal data, used only if thread is active
>   */
> @@ -411,6 +412,7 @@ struct vb2_queue {
>
>         unsigned int                    streaming:1;
>         unsigned int                    start_streaming_called:1;
> +       unsigned int                    error:1;
>
>         struct vb2_fileio_data          *fileio;
>         struct vb2_threadio_data        *threadio;
> @@ -443,6 +445,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
>  int __must_check vb2_queue_init(struct vb2_queue *q);
>
>  void vb2_queue_release(struct vb2_queue *q);
> +void vb2_queue_error(struct vb2_queue *q);
>
>  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
>  int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
> --
> 1.8.5.5
>
