Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:28685 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1B1K0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 05:26:11 -0500
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHB00JEDOZKRX00@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Feb 2011 19:26:08 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHB007ENOZBXZ@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Feb 2011 19:26:08 +0900 (KST)
Date: Mon, 28 Feb 2011 11:25:58 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors
In-reply-to: <1298830353-9797-2-git-send-email-laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: pawel@osciak.com, hverkuil@xs4all.nl,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <004601cbd731$e61cfd60$b256f820$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1298830353-9797-2-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Sunday, February 27, 2011 7:13 PM Laurent Pinchart wrote:

> videobuf2 expects drivers to check buffer in the buf_prepare operation
> and to return success only if the buffer can queued without any issue.
> 
> For hot-pluggable devices, disconnection events need to be handled at
> buf_queue time. Checking the disconnected flag and adding the buffer to
> the driver queue need to be performed without releasing the driver
> spinlock, otherwise race conditions can occur in which the driver could
> still allow a buffer to be queued after the disconnected flag has been
> set, resulting in a hang during the next DQBUF operation.
> 
> This problem can be solved either in the videobuf2 core or in the device
> drivers. To avoid adding a spinlock to videobuf2, make buf_queue return
> an int and handle buf_queue failures in videobuf2. Drivers must not
> return an error in buf_queue if the condition leading to the error can
> be caught in buf_prepare.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

We discussed how to solve the hot-plug issue and this is the solution I prefer.

> ---
>  drivers/media/video/videobuf2-core.c |   32 ++++++++++++++++++++++++++------
>  include/media/videobuf2-core.h       |    2 +-
>  2 files changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index cc7ab0a..1d81536 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -798,13 +798,22 @@ static int __qbuf_mmap(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  /**
>   * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
>   */
> -static void __enqueue_in_driver(struct vb2_buffer *vb)
> +static int __enqueue_in_driver(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> +	int ret;
> 
>  	vb->state = VB2_BUF_STATE_ACTIVE;
>  	atomic_inc(&q->queued_count);
> -	q->ops->buf_queue(vb);
> +	ret = q->ops->buf_queue(vb);
> +	if (ret == 0)
> +		return 0;
> +
> +	vb->state = VB2_BUF_STATE_ERROR;
> +	atomic_dec(&q->queued_count);
> +	wake_up_all(&q->done_wq);
> +
> +	return ret;
>  }
> 
>  /**
> @@ -890,8 +899,13 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  	 * If already streaming, give the buffer to driver for processing.
>  	 * If not, the buffer will be given to driver on next streamon.
>  	 */
> -	if (q->streaming)
> -		__enqueue_in_driver(vb);
> +	if (q->streaming) {
> +		ret = __enqueue_in_driver(vb);
> +		if (ret < 0) {
> +			dprintk(1, "qbuf: buffer queue failed\n");
> +			return ret;
> +		}
> +	}
> 
>  	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
>  	return 0;
> @@ -1101,6 +1115,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
>  int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>  {
>  	struct vb2_buffer *vb;
> +	int ret;
> 
>  	if (q->fileio) {
>  		dprintk(1, "streamon: file io in progress\n");
> @@ -1139,8 +1154,13 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>  	 * If any buffers were queued before streamon,
>  	 * we can now pass them to driver for processing.
>  	 */
> -	list_for_each_entry(vb, &q->queued_list, queued_entry)
> -		__enqueue_in_driver(vb);
> +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> +		ret = __enqueue_in_driver(vb);
> +		if (ret < 0) {
> +			dprintk(1, "streamon: buffer queue failed\n");
> +			return ret;
> +		}
> +	}
> 
>  	dprintk(3, "Streamon successful\n");
>  	return 0;
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 597efe6..3a92f75 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -225,7 +225,7 @@ struct vb2_ops {
>  	int (*start_streaming)(struct vb2_queue *q);
>  	int (*stop_streaming)(struct vb2_queue *q);
> 
> -	void (*buf_queue)(struct vb2_buffer *vb);
> +	int (*buf_queue)(struct vb2_buffer *vb);
>  };
> 
>  /**
> --
> 1.7.3.4

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


