Return-path: <mchehab@pedra>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:31494 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1F2LPV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 07:15:21 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH/RFC] media: vb2: change queue initialization order
Date: Wed, 29 Jun 2011 13:15:10 +0200
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"Uwe =?iso-8859-15?q?Kleine-K=F6nig?="
	<u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marin Mitov <mitov@issp.bas.bg>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291315.10611.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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

<snip>

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

Am I missing something? What is the purpose of this flag? Why not let the 
driver check in start_streaming whether any buffers have been queued and 
return -EINVAL if there aren't any? Between setting a flag or just doing the 
test in start_streaming I would prefer just doing the test.

To make it even easier you can perhaps add an extra argument to 
start_streaming with the number of buffers that are already queued.

I can't help thinking that this is made more difficult than it really is.

Regards,

	Hans

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
