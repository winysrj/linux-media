Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58099 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030993AbbKEJz3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2015 04:55:29 -0500
Subject: Re: [RFC PATCH v9 3/6] media: videobuf2: Separate vb2_poll()
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1446545802-28496-1-git-send-email-jh1009.sung@samsung.com>
 <1446545802-28496-4-git-send-email-jh1009.sung@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <563B2789.9050000@xs4all.nl>
Date: Thu, 5 Nov 2015 10:55:21 +0100
MIME-Version: 1.0
In-Reply-To: <1446545802-28496-4-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Junghak,

One comment below:

On 11/03/15 11:16, Junghak Sung wrote:
> Separate vb2_poll() into core and v4l2 part.
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-v4l2.c |   80 +++++++++++++++++++-----------
>  1 file changed, 52 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index d254452..0ca9f23 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -745,7 +745,7 @@ void vb2_queue_release(struct vb2_queue *q)
>  EXPORT_SYMBOL_GPL(vb2_queue_release);
>  
>  /**
> - * vb2_poll() - implements poll userspace operation
> + * vb2_core_poll() - implements poll userspace operation
>   * @q:		videobuf2 queue
>   * @file:	file argument passed to the poll file operation handler
>   * @wait:	wait argument passed to the poll file operation handler
> @@ -757,33 +757,20 @@ EXPORT_SYMBOL_GPL(vb2_queue_release);
>   * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
>   * will be reported as available for writing.
>   *
> - * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
> - * pending events.
> - *
>   * The return values from this function are intended to be directly returned
>   * from poll handler in driver.
>   */
> -unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
> +unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
> +		poll_table *wait)
>  {
> -	struct video_device *vfd = video_devdata(file);
>  	unsigned long req_events = poll_requested_events(wait);
>  	struct vb2_buffer *vb = NULL;
> -	unsigned int res = 0;
>  	unsigned long flags;
>  
> -	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
> -		struct v4l2_fh *fh = file->private_data;
> -
> -		if (v4l2_event_pending(fh))
> -			res = POLLPRI;
> -		else if (req_events & POLLPRI)
> -			poll_wait(file, &fh->wait, wait);
> -	}
> -
>  	if (!q->is_output && !(req_events & (POLLIN | POLLRDNORM)))
> -		return res;
> +		return 0;
>  	if (q->is_output && !(req_events & (POLLOUT | POLLWRNORM)))
> -		return res;
> +		return 0;
>  
>  	/*
>  	 * Start file I/O emulator only if streaming API has not been used yet.
> @@ -792,16 +779,16 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  		if (!q->is_output && (q->io_modes & VB2_READ) &&
>  				(req_events & (POLLIN | POLLRDNORM))) {
>  			if (__vb2_init_fileio(q, 1))
> -				return res | POLLERR;
> +				return POLLERR;
>  		}
>  		if (q->is_output && (q->io_modes & VB2_WRITE) &&
>  				(req_events & (POLLOUT | POLLWRNORM))) {
>  			if (__vb2_init_fileio(q, 0))
> -				return res | POLLERR;
> +				return POLLERR;
>  			/*
>  			 * Write to OUTPUT queue can be done immediately.
>  			 */
> -			return res | POLLOUT | POLLWRNORM;
> +			return POLLOUT | POLLWRNORM;
>  		}
>  	}
>  
> @@ -810,21 +797,21 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  	 * error flag is set.
>  	 */
>  	if (!vb2_is_streaming(q) || q->error)
> -		return res | POLLERR;
> +		return POLLERR;
>  	/*
>  	 * For compatibility with vb1: if QBUF hasn't been called yet, then
>  	 * return POLLERR as well. This only affects capture queues, output
>  	 * queues will always initialize waiting_for_buffers to false.
>  	 */
>  	if (q->waiting_for_buffers)
> -		return res | POLLERR;
> +		return POLLERR;

This check is V4L2 specific (as discussed during the workshop) and it should either
be moved to vb2_poll (not sure if that is possible), or q->waiting_for_buffers
should only be set to true in the vb2-v4l2 part, or something like that.

>  
>  	/*
>  	 * For output streams you can write as long as there are fewer buffers
>  	 * queued than there are buffers available.
>  	 */
>  	if (q->is_output && q->queued_count < q->num_buffers)
> -		return res | POLLOUT | POLLWRNORM;
> +		return POLLOUT | POLLWRNORM;
>  
>  	if (list_empty(&q->done_list)) {
>  		/*
> @@ -832,7 +819,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  		 * return immediately. DQBUF will return -EPIPE.
>  		 */
>  		if (q->last_buffer_dequeued)
> -			return res | POLLIN | POLLRDNORM;
> +			return POLLIN | POLLRDNORM;
>  
>  		poll_wait(file, &q->done_wq, wait);
>  	}
> @@ -849,10 +836,47 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  	if (vb && (vb->state == VB2_BUF_STATE_DONE
>  			|| vb->state == VB2_BUF_STATE_ERROR)) {
>  		return (q->is_output) ?
> -				res | POLLOUT | POLLWRNORM :
> -				res | POLLIN | POLLRDNORM;
> +				POLLOUT | POLLWRNORM :
> +				POLLIN | POLLRDNORM;
>  	}
> -	return res;
> +	return 0;
> +}
> +
> +/**
> + * vb2_poll() - implements poll userspace operation
> + * @q:		videobuf2 queue
> + * @file:	file argument passed to the poll file operation handler
> + * @wait:	wait argument passed to the poll file operation handler
> + *
> + * This function implements poll file operation handler for a driver.
> + * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
> + * be informed that the file descriptor of a video device is available for
> + * reading.
> + * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
> + * will be reported as available for writing.
> + *
> + * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
> + * pending events.
> + *
> + * The return values from this function are intended to be directly returned
> + * from poll handler in driver.
> + */
> +unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
> +{
> +	struct video_device *vfd = video_devdata(file);
> +	unsigned long req_events = poll_requested_events(wait);
> +	unsigned int res = 0;
> +
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
> +		struct v4l2_fh *fh = file->private_data;
> +
> +		if (v4l2_event_pending(fh))
> +			res = POLLPRI;
> +		else if (req_events & POLLPRI)
> +			poll_wait(file, &fh->wait, wait);
> +	}
> +
> +	return res | vb2_core_poll(q, file, wait);
>  }
>  EXPORT_SYMBOL_GPL(vb2_poll);
>  
> 

Regards,

	Hans
