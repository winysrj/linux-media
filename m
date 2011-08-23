Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:53290 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1HWKMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Aug 2011 06:12:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH/RFC] media: vb2: change queue initialization order
Date: Tue, 23 Aug 2011 12:11:25 +0200
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"Uwe =?iso-8859-15?q?Kleine-K=F6nig?="
	<u.kleine-koenig@pengutronix.de>, Marin Mitov <mitov@issp.bas.bg>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108231211.25278.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

Are you planning a RFCv2 for this?

I've been implementing vb2 in an internal driver and this initialization
order of vb2 is a bit of a pain to be honest.

Regards,

	Hans

On Wednesday, June 29, 2011 11:49:06 Marek Szyprowski wrote:
> This patch introduces VB2_STREAMON_WITHOUT_BUFFERS io flag and changes
> the order of operations during stream on operation. Now the buffer are
> first queued to the driver and then the start_streaming method is called.
> This resolves the most common case when the driver needs to know buffer
> addresses to enable dma engine and start streaming. For drivers that can
> handle start_streaming without queued buffers (mem2mem and 'one shot'
> capture case) a new VB2_STREAMON_WITHOUT_BUFFERS io flag has been
> introduced. Driver can set it to let videobuf2 know that it support this
> mode.
> 
> This patch also updates videobuf2 clients (s5p-fimc, mem2mem_testdev and
> vivi) to work properly with the changed order of operations and enables
> use of the newly introduced flag.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
> ---
> 
>  drivers/media/video/mem2mem_testdev.c       |    4 +-
>  drivers/media/video/s5p-fimc/fimc-capture.c |   65 
++++++++++++++++----------
>  drivers/media/video/s5p-fimc/fimc-core.c    |    4 +-
>  drivers/media/video/videobuf2-core.c        |   21 ++++-----
>  drivers/media/video/vivi.c                  |    2 +-
>  include/media/videobuf2-core.h              |   11 +++--
>  6 files changed, 62 insertions(+), 45 deletions(-)
> 
> 
> ---
> 
> Hello,
> 
> This patch introduces significant changes in the vb2 streamon operation,
> so all vb2 clients need to be checked and updated. Right now I didn't
> update mx3_camera and sh_mobile_ceu_camera drivers. Once we agree that
> this patch can be merged, I will update it to include all the required
> changes to these two drivers as well.
> 
> Best regards
> -- 
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> diff --git a/drivers/media/video/mem2mem_testdev.c 
b/drivers/media/video/mem2mem_testdev.c
> index b03d74e..65fb4ad 100644
> --- a/drivers/media/video/mem2mem_testdev.c
> +++ b/drivers/media/video/mem2mem_testdev.c
> @@ -808,7 +808,7 @@ static int queue_init(void *priv, struct vb2_queue 
*src_vq, struct vb2_queue *ds
>  
>  	memset(src_vq, 0, sizeof(*src_vq));
>  	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> -	src_vq->io_modes = VB2_MMAP;
> +	src_vq->io_modes = VB2_MMAP | VB2_STREAMON_WITHOUT_BUFFERS;
>  	src_vq->drv_priv = ctx;
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &m2mtest_qops;
> @@ -820,7 +820,7 @@ static int queue_init(void *priv, struct vb2_queue 
*src_vq, struct vb2_queue *ds
>  
>  	memset(dst_vq, 0, sizeof(*dst_vq));
>  	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	dst_vq->io_modes = VB2_MMAP;
> +	dst_vq->io_modes = VB2_MMAP | VB2_STREAMON_WITHOUT_BUFFERS;
>  	dst_vq->drv_priv = ctx;
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &m2mtest_qops;
> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c 
b/drivers/media/video/s5p-fimc/fimc-capture.c
> index d142b40..20a5bd4 100644
> --- a/drivers/media/video/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> @@ -152,27 +152,11 @@ static int fimc_isp_subdev_init(struct fimc_dev *fimc, 
unsigned int index)
>  	return ret;
>  }
>  
> -static int fimc_stop_capture(struct fimc_dev *fimc)
> +static void fimc_capture_state_cleanup(struct fimc_dev *fimc)
>  {
> -	unsigned long flags;
> -	struct fimc_vid_cap *cap;
> +	struct fimc_vid_cap *cap = &fimc->vid_cap;
>  	struct fimc_vid_buffer *buf;
> -
> -	cap = &fimc->vid_cap;
> -
> -	if (!fimc_capture_active(fimc))
> -		return 0;
> -
> -	spin_lock_irqsave(&fimc->slock, flags);
> -	set_bit(ST_CAPT_SHUT, &fimc->state);
> -	fimc_deactivate_capture(fimc);
> -	spin_unlock_irqrestore(&fimc->slock, flags);
> -
> -	wait_event_timeout(fimc->irq_queue,
> -			   !test_bit(ST_CAPT_SHUT, &fimc->state),
> -			   FIMC_SHUTDOWN_TIMEOUT);
> -
> -	v4l2_subdev_call(cap->sd, video, s_stream, 0);
> +	unsigned long flags;
>  
>  	spin_lock_irqsave(&fimc->slock, flags);
>  	fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_PEND |
> @@ -192,27 +176,50 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
>  	}
>  
>  	spin_unlock_irqrestore(&fimc->slock, flags);
> +}
> +
> +static int fimc_stop_capture(struct fimc_dev *fimc)
> +{
> +	struct fimc_vid_cap *cap = &fimc->vid_cap;
> +	unsigned long flags;
> +
> +	if (!fimc_capture_active(fimc))
> +		return 0;
> +
> +	spin_lock_irqsave(&fimc->slock, flags);
> +	set_bit(ST_CAPT_SHUT, &fimc->state);
> +	fimc_deactivate_capture(fimc);
> +	spin_unlock_irqrestore(&fimc->slock, flags);
> +
> +	wait_event_timeout(fimc->irq_queue,
> +			   !test_bit(ST_CAPT_SHUT, &fimc->state),
> +			   FIMC_SHUTDOWN_TIMEOUT);
>  
> +	v4l2_subdev_call(cap->sd, video, s_stream, 0);
> +
> +	fimc_capture_state_cleanup(fimc);
>  	dbg("state: 0x%lx", fimc->state);
>  	return 0;
>  }
>  
> +
>  static int start_streaming(struct vb2_queue *q)
>  {
>  	struct fimc_ctx *ctx = q->drv_priv;
>  	struct fimc_dev *fimc = ctx->fimc_dev;
>  	struct s5p_fimc_isp_info *isp_info;
> +	int min_bufs;
>  	int ret;
>  
>  	fimc_hw_reset(fimc);
>  
>  	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
>  	if (ret && ret != -ENOIOCTLCMD)
> -		return ret;
> +		goto error;
>  
>  	ret = fimc_prepare_config(ctx, ctx->state);
>  	if (ret)
> -		return ret;
> +		goto error;
>  
>  	isp_info = &fimc->pdata->isp_info[fimc->vid_cap.input_index];
>  	fimc_hw_set_camera_type(fimc, isp_info);
> @@ -223,7 +230,7 @@ static int start_streaming(struct vb2_queue *q)
>  		ret = fimc_set_scaler_info(ctx);
>  		if (ret) {
>  			err("Scaler setup error");
> -			return ret;
> +			goto error;
>  		}
>  		fimc_hw_set_input_path(ctx);
>  		fimc_hw_set_prescaler(ctx);
> @@ -238,13 +245,20 @@ static int start_streaming(struct vb2_queue *q)
>  
>  	INIT_LIST_HEAD(&fimc->vid_cap.pending_buf_q);
>  	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
> -	fimc->vid_cap.active_buf_cnt = 0;
>  	fimc->vid_cap.frame_count = 0;
>  	fimc->vid_cap.buf_index = 0;
>  
>  	set_bit(ST_CAPT_PEND, &fimc->state);
>  
> +	min_bufs = fimc->vid_cap.reqbufs_count > 1 ? 2 : 1;
> +
> +	if (fimc->vid_cap.active_buf_cnt >= min_bufs)
> +		fimc_activate_capture(ctx);
> +
>  	return 0;
> +error:
> +	fimc_capture_state_cleanup(fimc);
> +	return ret;
>  }
>  
>  static int stop_streaming(struct vb2_queue *q)
> @@ -357,7 +371,8 @@ static void buffer_queue(struct vb2_buffer *vb)
>  
>  	min_bufs = vid_cap->reqbufs_count > 1 ? 2 : 1;
>  
> -	if (vid_cap->active_buf_cnt >= min_bufs &&
> +	if (vb2_is_streaming(vb->vb2_queue) &&
> +	    vid_cap->active_buf_cnt >= min_bufs &&
>  	    !test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
>  		fimc_activate_capture(ctx);
>  
> @@ -878,7 +893,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
>  	q = &fimc->vid_cap.vbq;
>  	memset(q, 0, sizeof(*q));
>  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> -	q->io_modes = VB2_MMAP | VB2_USERPTR;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_STREAMON_WITHOUT_BUFFERS;
>  	q->drv_priv = fimc->vid_cap.ctx;
>  	q->ops = &fimc_capture_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c 
b/drivers/media/video/s5p-fimc/fimc-core.c
> index dc91a85..6a405c8 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -1386,7 +1386,7 @@ static int queue_init(void *priv, struct vb2_queue 
*src_vq,
>  
>  	memset(src_vq, 0, sizeof(*src_vq));
>  	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> -	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_STREAMON_WITHOUT_BUFFERS;
>  	src_vq->drv_priv = ctx;
>  	src_vq->ops = &fimc_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
> @@ -1398,7 +1398,7 @@ static int queue_init(void *priv, struct vb2_queue 
*src_vq,
>  
>  	memset(dst_vq, 0, sizeof(*dst_vq));
>  	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> -	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
> +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_STREAMON_WITHOUT_BUFFERS;
>  	dst_vq->drv_priv = ctx;
>  	dst_vq->ops = &fimc_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
> diff --git a/drivers/media/video/videobuf2-core.c 
b/drivers/media/video/videobuf2-core.c
> index 5517913..911e2eb 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1136,17 +1136,23 @@ int vb2_streamon(struct vb2_queue *q, enum 
v4l2_buf_type type)
>  	}
>  
>  	/*
> -	 * Cannot start streaming on an OUTPUT device if no buffers have
> -	 * been queued yet.
> +	 * Cannot start streaming if driver requires queued buffers.
>  	 */
> -	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> +	if (!(q->io_flags & VB2_STREAMON_WITHOUT_BUFFERS)) {
>  		if (list_empty(&q->queued_list)) {
> -			dprintk(1, "streamon: no output buffers queued\n");
> +			dprintk(1, "streamon: no buffers queued\n");
>  			return -EINVAL;
>  		}
>  	}
>  
>  	/*
> +	 * If any buffers were queued before streamon,
> +	 * we can now pass them to driver for processing.
> +	 */
> +	list_for_each_entry(vb, &q->queued_list, queued_entry)
> +		__enqueue_in_driver(vb);
> +
> +	/*
>  	 * Let driver notice that streaming state has been enabled.
>  	 */
>  	ret = call_qop(q, start_streaming, q);
> @@ -1157,13 +1163,6 @@ int vb2_streamon(struct vb2_queue *q, enum 
v4l2_buf_type type)
>  
>  	q->streaming = 1;
>  
> -	/*
> -	 * If any buffers were queued before streamon,
> -	 * we can now pass them to driver for processing.
> -	 */
> -	list_for_each_entry(vb, &q->queued_list, queued_entry)
> -		__enqueue_in_driver(vb);
> -
>  	dprintk(3, "Streamon successful\n");
>  	return 0;
>  }
> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> index 2238a61..e740a44 100644
> --- a/drivers/media/video/vivi.c
> +++ b/drivers/media/video/vivi.c
> @@ -1232,7 +1232,7 @@ static int __init vivi_create_instance(int inst)
>  	q = &dev->vb_vidq;
>  	memset(q, 0, sizeof(dev->vb_vidq));
>  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
> +	q->io_modes = VB2_MMAP | VB2_READ | VB2_STREAMON_WITHOUT_BUFFERS;
>  	q->drv_priv = dev;
>  	q->buf_struct_size = sizeof(struct vivi_buffer);
>  	q->ops = &vivi_video_qops;
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index f87472a..cdc0558 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -84,12 +84,15 @@ struct vb2_plane {
>   * @VB2_USERPTR:	driver supports USERPTR with streaming API
>   * @VB2_READ:		driver supports read() style access
>   * @VB2_WRITE:		driver supports write() style access
> + * @VB2_STREAMON_WITHOUT_BUFFERS: driver supports stream_on() without 
buffers
> + *			queued
>   */
>  enum vb2_io_modes {
> -	VB2_MMAP	= (1 << 0),
> -	VB2_USERPTR	= (1 << 1),
> -	VB2_READ	= (1 << 2),
> -	VB2_WRITE	= (1 << 3),
> +	VB2_MMAP			= (1 << 0),
> +	VB2_USERPTR			= (1 << 1),
> +	VB2_READ			= (1 << 2),
> +	VB2_WRITE			= (1 << 3),
> +	VB2_STREAMON_WITHOUT_BUFFERS	= (1 << 16),
>  };
>  
>  /**
> -- 
> 1.7.1.569.g6f426
> 
