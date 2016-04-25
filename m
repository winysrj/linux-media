Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37210 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216AbcDYSYs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 14:24:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Florian Echtler <floe@butterbrot.org>,
	Federico Vaga <federico.vaga@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Benoit Parrot <bparrot@ti.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCHv4 02/13] vb2: add a dev field to use for the default allocation context
Date: Mon, 25 Apr 2016 21:25:07 +0300
Message-ID: <5405598.YbTDzQkcY4@avalon>
In-Reply-To: <1461409429-24995-3-git-send-email-hverkuil@xs4all.nl>
References: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl> <1461409429-24995-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Saturday 23 Apr 2016 13:03:38 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The allocation context is nothing more than a per-plane device pointer
> to use when allocating buffers. So just provide a dev pointer in vb2_queue
> for that purpose and drivers can skip allocating/releasing/filling in
> the allocation context unless they require different per-plane device
> pointers as used by some Samsung SoCs.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Cc: Florian Echtler <floe@butterbrot.org>
> Cc: Federico Vaga <federico.vaga@gmail.com>
> Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Fabien Dessenne <fabien.dessenne@st.com>
> Cc: Benoit Parrot <bparrot@ti.com>
> Cc: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 14 ++++++++------
>  include/media/videobuf2-core.h           |  3 +++
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index 234e71b..2f50a91 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -206,7 +206,8 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
>  		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> 
> -		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
> +		mem_priv = call_ptr_memop(vb, alloc,
> +				q->alloc_ctx[plane] ? : &q->dev,
>  				q->dma_attrs, size, dma_dir, q->gfp_flags);
>  		if (IS_ERR_OR_NULL(mem_priv))
>  			goto free;
> @@ -1131,9 +1132,10 @@ static int __qbuf_userptr(struct vb2_buffer *vb,
> const void *pb) vb->planes[plane].data_offset = 0;
> 
>  		/* Acquire each plane's memory */
> -		mem_priv = call_ptr_memop(vb, get_userptr, q->alloc_ctx[plane],
> -				      planes[plane].m.userptr,
> -				      planes[plane].length, dma_dir);
> +		mem_priv = call_ptr_memop(vb, get_userptr,
> +				q->alloc_ctx[plane] ? : &q->dev,
> +				planes[plane].m.userptr,
> +				planes[plane].length, dma_dir);
>  		if (IS_ERR_OR_NULL(mem_priv)) {
>  			dprintk(1, "failed acquiring userspace "
>  						"memory for plane %d\n", plane);
> @@ -1256,8 +1258,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const
> void *pb)
> 
>  		/* Acquire each plane's memory */
>  		mem_priv = call_ptr_memop(vb, attach_dmabuf,
> -			q->alloc_ctx[plane], dbuf, planes[plane].length,
> -			dma_dir);
> +				q->alloc_ctx[plane] ? : &q->dev,
> +				dbuf, planes[plane].length, dma_dir);
>  		if (IS_ERR(mem_priv)) {
>  			dprintk(1, "failed to attach dmabuf\n");
>  			ret = PTR_ERR(mem_priv);
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 48c489d..bf24c7f 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -396,6 +396,8 @@ struct vb2_buf_ops {
>   *		caller. For example, for V4L2, it should match
>   *		the V4L2_BUF_TYPE_* in include/uapi/linux/videodev2.h
>   * @io_modes:	supported io methods (see vb2_io_modes enum)
> + * @dev:	device to use for the default allocation context if the driver
> + *		doesn't fill in the @alloc_ctx array.
>   * @dma_attrs:	DMA attributes to use for the DMA. May be NULL.
>   * @fileio_read_once:		report EOF after reading the first buffer
>   * @fileio_write_immediately:	queue buffer after each write() call
> @@ -460,6 +462,7 @@ struct vb2_buf_ops {
>  struct vb2_queue {
>  	unsigned int			type;
>  	unsigned int			io_modes;
> +	struct device			*dev;
>  	const struct dma_attrs		*dma_attrs;
>  	unsigned			fileio_read_once:1;
>  	unsigned			fileio_write_immediately:1;

-- 
Regards,

Laurent Pinchart

