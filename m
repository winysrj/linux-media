Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48032 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751839AbcJUHtX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 03:49:23 -0400
Date: Fri, 21 Oct 2016 10:48:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v3] [media] vb2: Add support for
 capture_dma_bidirectional queue flag
Message-ID: <20161021074845.GZ9460@valkosipuli.retiisi.org.uk>
References: <1477034705-5829-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477034705-5829-1-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On Fri, Oct 21, 2016 at 09:25:05AM +0200, Thierry Escande wrote:
> From: Pawel Osciak <posciak@chromium.org>
> 
> When this flag is set for CAPTURE queues by the driver on calling
> vb2_queue_init(), it forces the buffers on the queue to be
> allocated/mapped with DMA_BIDIRECTIONAL direction flag instead of
> DMA_FROM_DEVICE. This allows the device not only to write to the
> buffers, but also read out from them. This may be useful e.g. for codec
> hardware which may be using CAPTURE buffers as reference to decode
> other buffers.
> 
> This flag is ignored for OUTPUT queues as we don't want to allow HW to
> be able to write to OUTPUT buffers.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Tested-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 21900202..22d6105 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -194,8 +194,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
>  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	enum dma_data_direction dma_dir = VB2_DMA_DIR(q);
>  	void *mem_priv;
>  	int plane;
>  	int ret = -ENOMEM;
> @@ -978,8 +977,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
>  	void *mem_priv;
>  	unsigned int plane;
>  	int ret = 0;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	enum dma_data_direction dma_dir = VB2_DMA_DIR(q);
>  	bool reacquired = vb->planes[0].mem_priv == NULL;
>  
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
> @@ -1096,8 +1094,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
>  	void *mem_priv;
>  	unsigned int plane;
>  	int ret = 0;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	enum dma_data_direction dma_dir = VB2_DMA_DIR(q);
>  	bool reacquired = vb->planes[0].mem_priv == NULL;
>  
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);

Please also check where dma_dir is being used especially in memory type
implementation. There are several comparisons to DMA_FROM_DEVICE which will
have a different result if DMA_BIDIRECTIONAL is used instead.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
