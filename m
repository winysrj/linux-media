Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43970 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750778AbcJSV3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 17:29:16 -0400
Date: Thu, 20 Oct 2016 00:29:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] [media] vb2: Store dma_dir in vb2_queue
Message-ID: <20161019212907.GT9460@valkosipuli.retiisi.org.uk>
References: <1476865457-506-1-git-send-email-thierry.escande@collabora.com>
 <1476865457-506-2-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476865457-506-2-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On Wed, Oct 19, 2016 at 10:24:16AM +0200, Thierry Escande wrote:
> From: Pawel Osciak <posciak@chromium.org>
> 
> Store dma_dir in struct vb2_queue and reuse it, instead of recalculating
> it each time.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Tested-by: Pawel Osciak <posciak@chromium.org>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Reviewed-by: Owen Lin <owenlin@chromium.org>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 12 +++---------
>  drivers/media/v4l2-core/videobuf2-v4l2.c |  2 ++
>  include/media/videobuf2-core.h           |  2 ++
>  3 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 21900202..f12103c 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -194,8 +194,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
>  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>  	void *mem_priv;
>  	int plane;
>  	int ret = -ENOMEM;
> @@ -209,7 +207,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  
>  		mem_priv = call_ptr_memop(vb, alloc,
>  				q->alloc_devs[plane] ? : q->dev,
> -				q->dma_attrs, size, dma_dir, q->gfp_flags);
> +				q->dma_attrs, size, q->dma_dir, q->gfp_flags);

My bad, I guess I expressed myself unclearly.

Could you introduce the macro in this patch? You can then remove q->dma_dir
altogether.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
