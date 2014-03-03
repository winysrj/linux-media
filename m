Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50758 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaCCLWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 06:22:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 06/17] vb2: call buf_finish from __queue_cancel.
Date: Mon, 03 Mar 2014 12:24:12 +0100
Message-ID: <1906063.QvkTUhjlBo@avalon>
In-Reply-To: <1393609335-12081-7-git-send-email-hverkuil@xs4all.nl>
References: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl> <1393609335-12081-7-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 28 February 2014 18:42:04 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If a queue was canceled, then the buf_finish op was never called for the
> pending buffers. So add this call to queue_cancel. Before calling buf_finish
> set the buffer state to PREPARED, which is the correct state. That way the
> states DONE and ERROR will only be seen in buf_finish if streaming is in
> progress.
> 
> Since buf_finish can now be called from non-streaming state we need to
> adapt the handful of drivers that actually need to know this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/parport/bw-qcam.c          |  3 +++
>  drivers/media/pci/sta2x11/sta2x11_vip.c  |  3 ++-
>  drivers/media/usb/uvc/uvc_queue.c        |  3 ++-
>  drivers/media/v4l2-core/videobuf2-core.c | 14 ++++++++++++--
>  include/media/videobuf2-core.h           | 10 +++++++++-
>  5 files changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/parport/bw-qcam.c
> b/drivers/media/parport/bw-qcam.c index 0166aef..8d69bfb 100644
> --- a/drivers/media/parport/bw-qcam.c
> +++ b/drivers/media/parport/bw-qcam.c
> @@ -674,6 +674,9 @@ static void buffer_finish(struct vb2_buffer *vb)
>  	int size = vb->vb2_queue->plane_sizes[0];
>  	int len;
> 
> +	if (!vb2_is_streaming(vb->vb2_queue))
> +		return;
> +
>  	mutex_lock(&qcam->lock);
>  	parport_claim_or_block(qcam->pdev);
> 
> diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c
> b/drivers/media/pci/sta2x11/sta2x11_vip.c index e66556c..bb11443 100644
> --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
> +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
> @@ -337,7 +337,8 @@ static void buffer_finish(struct vb2_buffer *vb)
>  	list_del_init(&vip_buf->list);
>  	spin_unlock(&vip->lock);
> 
> -	vip_active_buf_next(vip);
> +	if (vb2_is_streaming(vb->vb2_queue))
> +		vip_active_buf_next(vip);
>  }
> 
>  static int start_streaming(struct vb2_queue *vq, unsigned int count)
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index cca2c6e..ab9f96e 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -111,7 +111,8 @@ static void uvc_buffer_finish(struct vb2_buffer *vb)
>  			container_of(queue, struct uvc_streaming, queue);
>  	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
> 
> -	uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
> +	if (vb->state == VB2_BUF_STATE_DONE)
> +		uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
>  }
> 
>  static void uvc_wait_prepare(struct vb2_queue *vq)
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index 59bfd85..6f84bcb 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1878,9 +1878,19 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
> 
>  	/*
>  	 * Reinitialize all buffers for next use.
> +	 * Make sure to call buf_finish for any queued buffers. Normally
> +	 * that's done in dqbuf, but that's not going to happen when we
> +	 * cancel the whole queue.

I would also state that buf_finish can't simply be moved to __vb2_dqbuf as it 
needs to be called before __fill_v4l2_buffer in the DQBUF path. Otherwise 
someone might submit a patch to simplify that vb2 code later when we'll have 
forgotten about this, introducing a bug.

>  	 */
> -	for (i = 0; i < q->num_buffers; ++i)
> -		__vb2_dqbuf(q->bufs[i]);
> +	for (i = 0; i < q->num_buffers; ++i) {
> +		struct vb2_buffer *vb = q->bufs[i];
> +
> +		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
> +			vb->state = VB2_BUF_STATE_PREPARED;
> +			call_vb_qop(vb, buf_finish, vb);
> +		}
> +		__vb2_dqbuf(vb);
> +	}
>  }
> 
>  static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type
> type) diff --git a/include/media/videobuf2-core.h
> b/include/media/videobuf2-core.h index f443ce0..3cb0bcf 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -276,7 +276,15 @@ struct vb2_buffer {
>   *			in driver; optional
>   * @buf_finish:		called before every dequeue of the buffer back to
>   *			userspace; drivers may perform any operations required
> - *			before userspace accesses the buffer; optional
> + *			before userspace accesses the buffer; optional. The
> + *			buffer state can be one of the following: DONE and
> + *			ERROR occur while streaming is in progress, and the
> + *			PREPARED state occurs when the queue has been canceled
> + *			and all pending buffers are being returned to their
> + *			default DEQUEUED state. Typically you only have to do
> + *			something if the state is VB2_BUF_STATE_DONE, since in
> + *			all other cases the buffer contents will be ignored
> + *			anyway.
>   * @buf_cleanup:	called once before the buffer is freed; drivers may
>   *			perform any additional cleanup; optional
>   * @start_streaming:	called once to enter 'streaming' state; the driver 
may

-- 
Regards,

Laurent Pinchart

