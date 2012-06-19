Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54055 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab2FSUH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 16:07:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCHv7 10/15] v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator
Date: Tue, 19 Jun 2012 22:07:34 +0200
Message-ID: <1791921.31CronkNdC@avalon>
In-Reply-To: <1339681069-8483-11-git-send-email-t.stanislaws@samsung.com>
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com> <1339681069-8483-11-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Thursday 14 June 2012 15:37:44 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Add prepare/finish callbacks to vb2-dma-contig allocator.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/videobuf2-dma-contig.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index 94f0874..f9286d7 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -103,6 +103,28 @@ static unsigned int vb2_dc_num_users(void *buf_priv)
>  	return atomic_read(&buf->refcount);
>  }
> 
> +static void vb2_dc_prepare(void *buf_priv)
> +{
> +	struct vb2_dc_buf *buf = buf_priv;
> +	struct sg_table *sgt = buf->dma_sgt;
> +
> +	if (!sgt)
> +		return;
> +
> +	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> +}
> +
> +static void vb2_dc_finish(void *buf_priv)
> +{
> +	struct vb2_dc_buf *buf = buf_priv;
> +	struct sg_table *sgt = buf->dma_sgt;
> +
> +	if (!sgt)
> +		return;
> +
> +	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> +}
> +
>  /*********************************************/
>  /*        callbacks for MMAP buffers         */
>  /*********************************************/
> @@ -369,6 +391,8 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
>  	.mmap		= vb2_dc_mmap,
>  	.get_userptr	= vb2_dc_get_userptr,
>  	.put_userptr	= vb2_dc_put_userptr,
> +	.prepare	= vb2_dc_prepare,
> +	.finish		= vb2_dc_finish,
>  	.num_users	= vb2_dc_num_users,
>  };
>  EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);

-- 
Regards,

Laurent Pinchart

