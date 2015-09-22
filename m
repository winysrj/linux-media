Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49855 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758878AbbIVVKt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 17:10:49 -0400
Date: Wed, 23 Sep 2015 00:10:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, robin.murphy@arm.com,
	hverkuil@xs4all.nl
Subject: Re: [RESEND PATCH] media: vb2: Fix vb2_dc_prepare do not correct
 sync data to device
Message-ID: <20150922211015.GT3175@valkosipuli.retiisi.org.uk>
References: <1442838371-21484-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1442838371-21484-1-git-send-email-tiffany.lin@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

(Robin and Hans cc'd.)

On Mon, Sep 21, 2015 at 08:26:11PM +0800, Tiffany Lin wrote:
> vb2_dc_prepare use the number of SG entries dma_map_sg_attrs return.
> But in dma_sync_sg_for_device, it use lengths of each SG entries
> before dma_map_sg_attrs. dma_map_sg_attrs will concatenate
> SGs until dma length > dma seg bundary. sgt->nents will less than
> sgt->orig_nents. Using SG entries after dma_map_sg_attrs
> in vb2_dc_prepare will make some SGs are not sync to device.
> After add DMA_ATTR_SKIP_CPU_SYNC in vb2_dc_get_userptr to remove
> sync data to device twice. Device randomly get incorrect data because
> some SGs are not sync to device. Change to use number of SG entries
> before dma_map_sg_attrs in vb2_dc_prepare to prevent this issue.
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 2397ceb..c5d00bd 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -100,7 +100,7 @@ static void vb2_dc_prepare(void *buf_priv)
>  	if (!sgt || buf->db_attach)
>  		return;
>  
> -	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> +	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
>  }
>  
>  static void vb2_dc_finish(void *buf_priv)
> @@ -112,7 +112,7 @@ static void vb2_dc_finish(void *buf_priv)
>  	if (!sgt || buf->db_attach)
>  		return;
>  
> -	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> +	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
>  }
>  
>  /*********************************************/

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Could you post a similar patch for videobuf2-dma-sg as well, please? This
should probably go to stable (since when?).

videobuf-dma-sg appears to be broken, too, but the fix is more changes
than one or two lines.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
