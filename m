Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43910 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdHPM2C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:28:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC PATCH] media: vb2: add bidirectional flag in vb2_queue
Date: Wed, 16 Aug 2017 15:28:25 +0300
Message-ID: <24640227.TDiF9DF693@avalon>
In-Reply-To: <00f355f6-33d6-f16d-3935-51a42c4a2fee@linaro.org>
References: <20170814084155.10770-1-stanimir.varbanov@linaro.org> <19b203a8-fdaa-b171-2e96-d1d8075b0e49@xs4all.nl> <00f355f6-33d6-f16d-3935-51a42c4a2fee@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stan,

On Wednesday 16 Aug 2017 14:46:50 Stanimir Varbanov wrote:
> On 08/15/2017 01:04 PM, Hans Verkuil wrote:
> > On 08/14/17 10:41, Stanimir Varbanov wrote:
> >> Hi,
> >> 
> >> This RFC patch is intended to give to the drivers a choice to change
> >> the default behavior of the v4l2-core DMA mapping direction from
> >> DMA_TO/FROM_DEVICE (depending on the buffer type CAPTURE or OUTPUT)
> >> to DMA_BIDIRECTIONAL during queue_init time.
> >> 
> >> Initially the issue with DMA mapping direction has been found in
> >> Venus encoder driver where the firmware side of the driver adds few
> >> lines padding on bottom of the image buffer, and the consequence was
> >> triggering of IOMMU protection faults.
> >> 
> >> Probably other drivers could also has a benefit of this feature (hint)
> >> in the future.
> >> 
> >> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> >> ---
> >> 
> >>  drivers/media/v4l2-core/videobuf2-core.c |  3 +++
> >>  include/media/videobuf2-core.h           | 11 +++++++++++
> >>  2 files changed, 14 insertions(+)
> >> 
> >> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> >> b/drivers/media/v4l2-core/videobuf2-core.c index
> >> 14f83cecfa92..17d07fda4cdc 100644
> >> --- a/drivers/media/v4l2-core/videobuf2-core.c
> >> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> >> @@ -200,6 +200,9 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> >> 
> >>  	int plane;
> >>  	int ret = -ENOMEM;
> >> 
> >> +	if (q->bidirectional)
> >> +		dma_dir = DMA_BIDIRECTIONAL;
> >> +
> > 
> > Does this only have to be used in mem_alloc? In the __prepare_*() it is
> > still using DMA_TO/FROM_DEVICE.
> 
> Yes, it looks like the DMA direction should be covered in the
> __prepare_* too. Thus the patch should look like below:
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c
> index 14f83cecfa92..0089e7dac7dd 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -188,14 +188,21 @@ module_param(debug, int, 0644);
>  static void __vb2_queue_cancel(struct vb2_queue *q);
>  static void __enqueue_in_driver(struct vb2_buffer *vb);
> 
> +static enum dma_data_direction __get_dma_dir(struct vb2_queue *q)
> +{
> +	if (q->bidirectional)
> +		return DMA_BIDIRECTIONAL;
> +
> +	return q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;

We could also compute the DMA direction once only and store it in the queue. I 
have no big preference at the moment.

> +}
> +
>  /**
>   * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
>   */
>  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	enum dma_data_direction dma_dir = __get_dma_dir(q);
>  	void *mem_priv;
>  	int plane;
>  	int ret = -ENOMEM;
> @@ -978,8 +985,7 @@ static int __prepare_userptr(struct vb2_buffer *vb,
> const void *pb)
>  	void *mem_priv;
>  	unsigned int plane;
>  	int ret = 0;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	enum dma_data_direction dma_dir = __get_dma_dir(q);
>  	bool reacquired = vb->planes[0].mem_priv == NULL;
> 
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
> @@ -1096,8 +1102,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb,
> const void *pb)
>  	void *mem_priv;
>  	unsigned int plane;
>  	int ret = 0;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	enum dma_data_direction dma_dir = __get_dma_dir(q);
>  	bool reacquired = vb->planes[0].mem_priv == NULL;
> 
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);

-- 
Regards,

Laurent Pinchart
