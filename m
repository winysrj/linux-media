Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64423 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1GRGa6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 02:30:58 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LOI00M00NFJKP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jul 2011 07:30:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LOI000GYNFIVL@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jul 2011 07:30:55 +0100 (BST)
Date: Mon, 18 Jul 2011 08:30:06 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFCv1 PATCH 5/6] videobuf2-core: also test for pending events.
In-reply-to: <7e5b35d540b5937481b1b9a44cd926b170a81188.1310549521.git.hans.verkuil@cisco.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: 'Hans Verkuil' <hans.verkuil@cisco.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <00c801cc4514$2263cc90$672b65b0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
 <7e5b35d540b5937481b1b9a44cd926b170a81188.1310549521.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, July 13, 2011 11:39 AM Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/media/video/videobuf2-core.c |   41 +++++++++++++++++++++++-------
> ---
>  1 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c
> b/drivers/media/video/videobuf2-core.c
> index 1892bb8..1922bf8 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -19,6 +19,9 @@
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> 
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-event.h>
>  #include <media/videobuf2-core.h>
> 
>  static int debug;
> @@ -1360,15 +1363,28 @@ static int __vb2_cleanup_fileio(struct vb2_queue
> *q);
>   * For OUTPUT queues, if a buffer is ready to be dequeued, the file
> descriptor
>   * will be reported as available for writing.
>   *
> + * If the driver uses struct v4l2_fh, then vb2_poll() will also check for
> any
> + * pending events.
> + *
>   * The return values from this function are intended to be directly
> returned
>   * from poll handler in driver.
>   */
>  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table
> *wait)
>  {
> +	struct video_device *vfd = video_devdata(file);
>  	unsigned long req_events = poll_requested_events(wait);
> -	unsigned long flags;
> -	unsigned int ret;
>  	struct vb2_buffer *vb = NULL;
> +	unsigned int res = 0;
> +	unsigned long flags;
> +
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
> +		struct v4l2_fh *fh = file->private_data;
> +
> +		if (v4l2_event_pending(fh))
> +			res = POLLPRI;
> +		else if (req_events & POLLPRI)
> +			poll_wait(file, &fh->wait, wait);
> +	}
> 
>  	/*
>  	 * Start file I/O emulator only if streaming API has not been used
> yet.
> @@ -1376,19 +1392,17 @@ unsigned int vb2_poll(struct vb2_queue *q, struct
> file *file, poll_table *wait)
>  	if (q->num_buffers == 0 && q->fileio == NULL) {
>  		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)
> &&
>  				(req_events & (POLLIN | POLLRDNORM))) {
> -			ret = __vb2_init_fileio(q, 1);
> -			if (ret)
> -				return POLLERR;
> +			if (__vb2_init_fileio(q, 1))
> +				return res | POLLERR;
>  		}
>  		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)
> &&
>  				(req_events & (POLLOUT | POLLWRNORM))) {
> -			ret = __vb2_init_fileio(q, 0);
> -			if (ret)
> -				return POLLERR;
> +			if (__vb2_init_fileio(q, 0))
> +				return res | POLLERR;
>  			/*
>  			 * Write to OUTPUT queue can be done immediately.
>  			 */
> -			return POLLOUT | POLLWRNORM;
> +			return res | POLLOUT | POLLWRNORM;
>  		}
>  	}
> 
> @@ -1396,7 +1410,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct
> file *file, poll_table *wait)
>  	 * There is nothing to wait for if no buffers have already been
> queued.
>  	 */
>  	if (list_empty(&q->queued_list))
> -		return POLLERR;
> +		return res | POLLERR;
> 
>  	poll_wait(file, &q->done_wq, wait);
> 
> @@ -1411,10 +1425,11 @@ unsigned int vb2_poll(struct vb2_queue *q, struct
> file *file, poll_table *wait)
> 
>  	if (vb && (vb->state == VB2_BUF_STATE_DONE
>  			|| vb->state == VB2_BUF_STATE_ERROR)) {
> -		return (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | POLLWRNORM :
> -			POLLIN | POLLRDNORM;
> +		return (V4L2_TYPE_IS_OUTPUT(q->type)) ?
> +				res | POLLOUT | POLLWRNORM :
> +				res | POLLIN | POLLRDNORM;
>  	}
> -	return 0;
> +	return res;
>  }
>  EXPORT_SYMBOL_GPL(vb2_poll);
> 
> --

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



