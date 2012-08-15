Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35243 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2HOSfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 14:35:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, dmitriyz@google.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv8 10/26] v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator
Date: Wed, 15 Aug 2012 20:35:28 +0200
Message-ID: <19239574.EXIJbKbmPC@avalon>
In-Reply-To: <1344958496-9373-11-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-11-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 14 August 2012 17:34:40 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Add prepare/finish callbacks to vb2-dma-contig allocator.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

As for v7,

Laurent Pinchart <laurent.pinchart@ideasonboard.com>

:-)

> ---
>  drivers/media/video/videobuf2-dma-contig.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index 8486e06..494a824 100644
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
> @@ -366,6 +388,8 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
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

