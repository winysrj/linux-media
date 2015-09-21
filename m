Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:44796 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbbIUNOF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 09:14:05 -0400
Subject: Re: [RESEND PATCH] media: vb2: Fix vb2_dc_prepare do not correct sync
 data to device
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1442838371-21484-1-git-send-email-tiffany.lin@mediatek.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56000293.9000802@xs4all.nl>
Date: Mon, 21 Sep 2015 15:13:55 +0200
MIME-Version: 1.0
In-Reply-To: <1442838371-21484-1-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany!

On 21-09-15 14:26, Tiffany Lin wrote:
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

I don't really understand it. I am assuming that this happens on an arm and that
the dma_map_sg_attrs and dma_sync_sg_* functions used are arm_iommu_map_sg() and
arm_iommu_sync_sg_* as implemented in arch/arm/mm/dma-mapping.c.

Now, as I understand it (and my understanding may very well be flawed!) the map_sg
function concatenates SG entries if possible, so it may return fewer entries. But
the dma_sync_sg functions use those updated SG entries, so the full buffer should
be covered by this. Using orig_nents will actually sync parts of the buffer twice!
The first nents entries already cover the full buffer so any remaining entries up
to orig_nents will just duplicate parts of the buffer.

So this patch makes no sense in the current code.

If I understand your log text correctly this patch goes on top of Sakari Ailus' vb2
sync patch series. So if it wasn't needed before, but it is needed after his patch
series, then the problem is in that patch series.

In any case, I need some help understanding this patch.

And *if* this patch is correct, then the same thing should likely be done for
videobuf2-dma-sg.c.

Regards,

	Hans

>  
>  /*********************************************/
> 
