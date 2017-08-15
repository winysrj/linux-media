Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:54940 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753419AbdHOKFG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 06:05:06 -0400
Subject: Re: [RFC PATCH] media: vb2: add bidirectional flag in vb2_queue
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170814084155.10770-1-stanimir.varbanov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <19b203a8-fdaa-b171-2e96-d1d8075b0e49@xs4all.nl>
Date: Tue, 15 Aug 2017 12:04:59 +0200
MIME-Version: 1.0
In-Reply-To: <20170814084155.10770-1-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/17 10:41, Stanimir Varbanov wrote:
> Hi,
> 
> This RFC patch is intended to give to the drivers a choice to change
> the default behavior of the v4l2-core DMA mapping direction from
> DMA_TO/FROM_DEVICE (depending on the buffer type CAPTURE or OUTPUT)
> to DMA_BIDIRECTIONAL during queue_init time.
> 
> Initially the issue with DMA mapping direction has been found in
> Venus encoder driver where the firmware side of the driver adds few
> lines padding on bottom of the image buffer, and the consequence was
> triggering of IOMMU protection faults. 
> 
> Probably other drivers could also has a benefit of this feature (hint)
> in the future.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |  3 +++
>  include/media/videobuf2-core.h           | 11 +++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 14f83cecfa92..17d07fda4cdc 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -200,6 +200,9 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  	int plane;
>  	int ret = -ENOMEM;
>  
> +	if (q->bidirectional)
> +		dma_dir = DMA_BIDIRECTIONAL;
> +

Does this only have to be used in mem_alloc? In the __prepare_*() it is still using
DMA_TO/FROM_DEVICE.

I don't know enough of the low-level handling to be able to tell whether that is
a problem or not, but even if it is not then a comment somewhere to explain that
it is OK is probably a good idea.

Regards,

	Hans

>  	/*
>  	 * Allocate memory for all planes in this buffer
>  	 * NOTE: mmapped areas should be page aligned
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index cb97c224be73..0b6e88e1aa79 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -427,6 +427,16 @@ struct vb2_buf_ops {
>   * @dev:	device to use for the default allocation context if the driver
>   *		doesn't fill in the @alloc_devs array.
>   * @dma_attrs:	DMA attributes to use for the DMA.
> + * @bidirectional: when this flag is set the DMA direction for the buffers of
> + *		this queue will be overridden with DMA_BIDIRECTIONAL direction.
> + *		This is useful in cases where the hardware (firmware) writes to
> + *		a buffer which is mapped as read (DMA_TO_DEVICE), or reads from
> + *		buffer which is mapped for write (DMA_FROM_DEVICE) in order
> + *		to satisfy some internal hardware restrictions or adds a padding
> + *		needed by the processing algorithm. In case the DMA mapping is
> + *		not bidirectional but the hardware (firmware) trying to access
> + *		the buffer (in the opposite direction) this could lead to an
> + *		IOMMU protection faults.
>   * @fileio_read_once:		report EOF after reading the first buffer
>   * @fileio_write_immediately:	queue buffer after each write() call
>   * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
> @@ -495,6 +505,7 @@ struct vb2_queue {
>  	unsigned int			io_modes;
>  	struct device			*dev;
>  	unsigned long			dma_attrs;
> +	unsigned			bidirectional:1;
>  	unsigned			fileio_read_once:1;
>  	unsigned			fileio_write_immediately:1;
>  	unsigned			allow_zero_bytesused:1;
> 
