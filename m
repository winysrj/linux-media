Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab1H2WKd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 18:10:33 -0400
Date: Tue, 30 Aug 2011 00:10:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH] media: vb2: dma contig allocator: use dma_addr instread
 of paddr
In-Reply-To: <1314602908-5815-1-git-send-email-m.szyprowski@samsung.com>
Message-ID: <Pine.LNX.4.64.1108300009440.5065@axis700.grange>
References: <1314602908-5815-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Aug 2011, Marek Szyprowski wrote:

> Use the correct 'dma_addr' name for the buffer address. 'paddr' suggested
> that this is the physical address in system memory. For most ARM platforms
> these two are the same, but this is not a generic rule. 'dma_addr' will
> also point better to dma-mapping api.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>

For atmel-isi.c, mx3_camera.c, sh_mobile_ceu_camera.c:

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/video/atmel-isi.c              |    2 +-
>  drivers/media/video/marvell-ccic/mcam-core.c |    4 +-
>  drivers/media/video/mx3_camera.c             |    2 +-
>  drivers/media/video/s5p-fimc/fimc-core.c     |    6 ++--
>  drivers/media/video/s5p-mfc/s5p_mfc.c        |    4 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |   10 ++++----
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |   30 +++++++++++++-------------
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |   14 ++++++------
>  drivers/media/video/s5p-tv/mixer_grp_layer.c |    2 +-
>  drivers/media/video/s5p-tv/mixer_vp_layer.c  |    4 +-
>  drivers/media/video/sh_mobile_ceu_camera.c   |    2 +-
>  drivers/media/video/videobuf2-dma-contig.c   |   16 +++++++-------
>  include/media/videobuf2-dma-contig.h         |    6 ++--
>  13 files changed, 51 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
> index 5a4b2d7..7e1d789 100644
> --- a/drivers/media/video/atmel-isi.c
> +++ b/drivers/media/video/atmel-isi.c
> @@ -341,7 +341,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
>  
>  			/* Initialize the dma descriptor */
>  			desc->p_fbd->fb_address =
> -					vb2_dma_contig_plane_paddr(vb, 0);
> +					vb2_dma_contig_plane_dma_addr(vb, 0);
>  			desc->p_fbd->next_fbd_address = 0;
>  			set_dma_ctrl(desc->p_fbd, ISI_DMA_CTRL_WB);
>  
> diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
> index 744cf37..7abe503 100644
> --- a/drivers/media/video/marvell-ccic/mcam-core.c
> +++ b/drivers/media/video/marvell-ccic/mcam-core.c
> @@ -450,7 +450,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
>  		buf = cam->vb_bufs[frame ^ 0x1];
>  		cam->vb_bufs[frame] = buf;
>  		mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
> -				vb2_dma_contig_plane_paddr(&buf->vb_buf, 0));
> +				vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
>  		set_bit(CF_SINGLE_BUFFER, &cam->flags);
>  		singles++;
>  		return;
> @@ -461,7 +461,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
>  	buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer, queue);
>  	list_del_init(&buf->queue);
>  	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
> -			vb2_dma_contig_plane_paddr(&buf->vb_buf, 0));
> +			vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
>  	cam->vb_bufs[frame] = buf;
>  	clear_bit(CF_SINGLE_BUFFER, &cam->flags);
>  }
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index 9ae7785..c8e958a 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -247,7 +247,7 @@ static int mx3_videobuf_prepare(struct vb2_buffer *vb)
>  	}
>  
>  	if (buf->state == CSI_BUF_NEEDS_INIT) {
> -		sg_dma_address(sg)	= vb2_dma_contig_plane_paddr(vb, 0);
> +		sg_dma_address(sg)	= vb2_dma_contig_plane_dma_addr(vb, 0);
>  		sg_dma_len(sg)		= new_size;
>  
>  		buf->txd = ichan->dma_chan.device->device_prep_slave_sg(
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
> index 8152756..266d6b9 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -457,7 +457,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
>  	dbg("memplanes= %d, colplanes= %d, pix_size= %d",
>  		frame->fmt->memplanes, frame->fmt->colplanes, pix_size);
>  
> -	paddr->y = vb2_dma_contig_plane_paddr(vb, 0);
> +	paddr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
>  
>  	if (frame->fmt->memplanes == 1) {
>  		switch (frame->fmt->colplanes) {
> @@ -485,10 +485,10 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
>  		}
>  	} else {
>  		if (frame->fmt->memplanes >= 2)
> -			paddr->cb = vb2_dma_contig_plane_paddr(vb, 1);
> +			paddr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
>  
>  		if (frame->fmt->memplanes == 3)
> -			paddr->cr = vb2_dma_contig_plane_paddr(vb, 2);
> +			paddr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
>  	}
>  
>  	dbg("PHYS_ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
> index 7dc7eab..af32e02 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -202,7 +202,7 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
>  	   appropraite flags */
>  	src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
>  	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
> -		if (vb2_dma_contig_plane_paddr(dst_buf->b, 0) == dec_y_addr) {
> +		if (vb2_dma_contig_plane_dma_addr(dst_buf->b, 0) == dec_y_addr) {
>  			memcpy(&dst_buf->b->v4l2_buf.timecode,
>  				&src_buf->b->v4l2_buf.timecode,
>  				sizeof(struct v4l2_timecode));
> @@ -248,7 +248,7 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
>  	 * check which videobuf does it correspond to */
>  	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
>  		/* Check if this is the buffer we're looking for */
> -		if (vb2_dma_contig_plane_paddr(dst_buf->b, 0) == dspl_y_addr) {
> +		if (vb2_dma_contig_plane_dma_addr(dst_buf->b, 0) == dspl_y_addr) {
>  			list_del(&dst_buf->list);
>  			ctx->dst_queue_cnt--;
>  			dst_buf->b->v4l2_buf.sequence = ctx->sequence;
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> index 13099b8..feac53f 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> @@ -824,7 +824,7 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
>  			return 0;
>  		for (i = 0; i <= ctx->src_fmt->num_planes ; i++) {
>  			if (IS_ERR_OR_NULL(ERR_PTR(
> -					vb2_dma_contig_plane_paddr(vb, i)))) {
> +					vb2_dma_contig_plane_dma_addr(vb, i)))) {
>  				mfc_err("Plane mem not allocated\n");
>  				return -EINVAL;
>  			}
> @@ -837,13 +837,13 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
>  		i = vb->v4l2_buf.index;
>  		ctx->dst_bufs[i].b = vb;
>  		ctx->dst_bufs[i].cookie.raw.luma =
> -					vb2_dma_contig_plane_paddr(vb, 0);
> +					vb2_dma_contig_plane_dma_addr(vb, 0);
>  		ctx->dst_bufs[i].cookie.raw.chroma =
> -					vb2_dma_contig_plane_paddr(vb, 1);
> +					vb2_dma_contig_plane_dma_addr(vb, 1);
>  		ctx->dst_bufs_cnt++;
>  	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>  		if (IS_ERR_OR_NULL(ERR_PTR(
> -					vb2_dma_contig_plane_paddr(vb, 0)))) {
> +					vb2_dma_contig_plane_dma_addr(vb, 0)))) {
>  			mfc_err("Plane memory not allocated\n");
>  			return -EINVAL;
>  		}
> @@ -855,7 +855,7 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
>  		i = vb->v4l2_buf.index;
>  		ctx->src_bufs[i].b = vb;
>  		ctx->src_bufs[i].cookie.stream =
> -					vb2_dma_contig_plane_paddr(vb, 0);
> +					vb2_dma_contig_plane_dma_addr(vb, 0);
>  		ctx->src_bufs_cnt++;
>  	} else {
>  		mfc_err("s5p_mfc_buf_init: unknown queue type\n");
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> index 593ff41..321cdfe 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> @@ -599,8 +599,8 @@ static void cleanup_ref_queue(struct s5p_mfc_ctx *ctx)
>  	while (!list_empty(&ctx->ref_queue)) {
>  		mb_entry = list_entry((&ctx->ref_queue)->next,
>  						struct s5p_mfc_buf, list);
> -		mb_y_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 0);
> -		mb_c_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 1);
> +		mb_y_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 0);
> +		mb_c_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 1);
>  		list_del(&mb_entry->list);
>  		ctx->ref_queue_cnt--;
>  		list_add_tail(&mb_entry->list, &ctx->src_queue);
> @@ -622,7 +622,7 @@ static int enc_pre_seq_start(struct s5p_mfc_ctx *ctx)
>  
>  	spin_lock_irqsave(&dev->irqlock, flags);
>  	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
> -	dst_addr = vb2_dma_contig_plane_paddr(dst_mb->b, 0);
> +	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
>  	dst_size = vb2_plane_size(dst_mb->b, 0);
>  	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
> @@ -668,14 +668,14 @@ static int enc_pre_frame_start(struct s5p_mfc_ctx *ctx)
>  
>  	spin_lock_irqsave(&dev->irqlock, flags);
>  	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
> -	src_y_addr = vb2_dma_contig_plane_paddr(src_mb->b, 0);
> -	src_c_addr = vb2_dma_contig_plane_paddr(src_mb->b, 1);
> +	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
> +	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
>  	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
>  
>  	spin_lock_irqsave(&dev->irqlock, flags);
>  	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
> -	dst_addr = vb2_dma_contig_plane_paddr(dst_mb->b, 0);
> +	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
>  	dst_size = vb2_plane_size(dst_mb->b, 0);
>  	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
> @@ -703,8 +703,8 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
>  	if (slice_type >= 0) {
>  		s5p_mfc_get_enc_frame_buffer(ctx, &enc_y_addr, &enc_c_addr);
>  		list_for_each_entry(mb_entry, &ctx->src_queue, list) {
> -			mb_y_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 0);
> -			mb_c_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 1);
> +			mb_y_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 0);
> +			mb_c_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 1);
>  			if ((enc_y_addr == mb_y_addr) &&
>  						(enc_c_addr == mb_c_addr)) {
>  				list_del(&mb_entry->list);
> @@ -715,8 +715,8 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
>  			}
>  		}
>  		list_for_each_entry(mb_entry, &ctx->ref_queue, list) {
> -			mb_y_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 0);
> -			mb_c_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 1);
> +			mb_y_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 0);
> +			mb_c_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 1);
>  			if ((enc_y_addr == mb_y_addr) &&
>  						(enc_c_addr == mb_c_addr)) {
>  				list_del(&mb_entry->list);
> @@ -1501,13 +1501,13 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
>  		return -EINVAL;
>  	}
>  	for (i = 0; i < fmt->num_planes; i++) {
> -		if (!vb2_dma_contig_plane_paddr(vb, i)) {
> +		if (!vb2_dma_contig_plane_dma_addr(vb, i)) {
>  			mfc_err("failed to get plane cookie\n");
>  			return -EINVAL;
>  		}
>  		mfc_debug(2, "index: %d, plane[%d] cookie: 0x%08zx",
>  				vb->v4l2_buf.index, i,
> -				vb2_dma_contig_plane_paddr(vb, i));
> +				vb2_dma_contig_plane_dma_addr(vb, i));
>  	}
>  	return 0;
>  }
> @@ -1584,7 +1584,7 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
>  		i = vb->v4l2_buf.index;
>  		ctx->dst_bufs[i].b = vb;
>  		ctx->dst_bufs[i].cookie.stream =
> -					vb2_dma_contig_plane_paddr(vb, 0);
> +					vb2_dma_contig_plane_dma_addr(vb, 0);
>  		ctx->dst_bufs_cnt++;
>  	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>  		ret = check_vb_with_fmt(ctx->src_fmt, vb);
> @@ -1593,9 +1593,9 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
>  		i = vb->v4l2_buf.index;
>  		ctx->src_bufs[i].b = vb;
>  		ctx->src_bufs[i].cookie.raw.luma =
> -					vb2_dma_contig_plane_paddr(vb, 0);
> +					vb2_dma_contig_plane_dma_addr(vb, 0);
>  		ctx->src_bufs[i].cookie.raw.chroma =
> -					vb2_dma_contig_plane_paddr(vb, 1);
> +					vb2_dma_contig_plane_dma_addr(vb, 1);
>  		ctx->src_bufs_cnt++;
>  	} else {
>  		mfc_err("inavlid queue type: %d\n", vq->type);
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> index 7b23916..e08b21c 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> @@ -1135,7 +1135,7 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
>  	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
>  	temp_vb->used = 1;
>  	s5p_mfc_set_dec_stream_buffer(ctx,
> -		vb2_dma_contig_plane_paddr(temp_vb->b, 0), ctx->consumed_stream,
> +		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), ctx->consumed_stream,
>  					temp_vb->b->v4l2_planes[0].bytesused);
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
>  	index = temp_vb->b->v4l2_buf.index;
> @@ -1172,12 +1172,12 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
>  	}
>  	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
>  	src_mb->used = 1;
> -	src_y_addr = vb2_dma_contig_plane_paddr(src_mb->b, 0);
> -	src_c_addr = vb2_dma_contig_plane_paddr(src_mb->b, 1);
> +	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
> +	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
>  	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
>  	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
>  	dst_mb->used = 1;
> -	dst_addr = vb2_dma_contig_plane_paddr(dst_mb->b, 0);
> +	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
>  	dst_size = vb2_plane_size(dst_mb->b, 0);
>  	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
> @@ -1200,7 +1200,7 @@ static void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
>  	s5p_mfc_set_dec_desc_buffer(ctx);
>  	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
>  	s5p_mfc_set_dec_stream_buffer(ctx,
> -				vb2_dma_contig_plane_paddr(temp_vb->b, 0),
> +				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
>  				0, temp_vb->b->v4l2_planes[0].bytesused);
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
>  	dev->curr_ctx = ctx->num;
> @@ -1219,7 +1219,7 @@ static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
>  	s5p_mfc_set_enc_ref_buffer(ctx);
>  	spin_lock_irqsave(&dev->irqlock, flags);
>  	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
> -	dst_addr = vb2_dma_contig_plane_paddr(dst_mb->b, 0);
> +	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
>  	dst_size = vb2_plane_size(dst_mb->b, 0);
>  	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
> @@ -1255,7 +1255,7 @@ static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
>  	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
>  	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
>  	s5p_mfc_set_dec_stream_buffer(ctx,
> -				vb2_dma_contig_plane_paddr(temp_vb->b, 0),
> +				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
>  				0, temp_vb->b->v4l2_planes[0].bytesused);
>  	spin_unlock_irqrestore(&dev->irqlock, flags);
>  	dev->curr_ctx = ctx->num;
> diff --git a/drivers/media/video/s5p-tv/mixer_grp_layer.c b/drivers/media/video/s5p-tv/mixer_grp_layer.c
> index 58f0ba4..de8270c 100644
> --- a/drivers/media/video/s5p-tv/mixer_grp_layer.c
> +++ b/drivers/media/video/s5p-tv/mixer_grp_layer.c
> @@ -86,7 +86,7 @@ static void mxr_graph_buffer_set(struct mxr_layer *layer,
>  	dma_addr_t addr = 0;
>  
>  	if (buf)
> -		addr = vb2_dma_contig_plane_paddr(&buf->vb, 0);
> +		addr = vb2_dma_contig_plane_dma_addr(&buf->vb, 0);
>  	mxr_reg_graph_buffer(layer->mdev, layer->idx, addr);
>  }
>  
> diff --git a/drivers/media/video/s5p-tv/mixer_vp_layer.c b/drivers/media/video/s5p-tv/mixer_vp_layer.c
> index 6950ed8..f3bb2e3 100644
> --- a/drivers/media/video/s5p-tv/mixer_vp_layer.c
> +++ b/drivers/media/video/s5p-tv/mixer_vp_layer.c
> @@ -97,9 +97,9 @@ static void mxr_vp_buffer_set(struct mxr_layer *layer,
>  		mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
>  		return;
>  	}
> -	luma_addr[0] = vb2_dma_contig_plane_paddr(&buf->vb, 0);
> +	luma_addr[0] = vb2_dma_contig_plane_dma_addr(&buf->vb, 0);
>  	if (layer->fmt->num_subframes == 2) {
> -		chroma_addr[0] = vb2_dma_contig_plane_paddr(&buf->vb, 1);
> +		chroma_addr[0] = vb2_dma_contig_plane_dma_addr(&buf->vb, 1);
>  	} else {
>  		/* FIXME: mxr_get_plane_size compute integer division,
>  		 * which is slow and should not be performed in interrupt */
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 8298c89..8615fb8 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -312,7 +312,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  		bottom2	= CDBCR;
>  	}
>  
> -	phys_addr_top = vb2_dma_contig_plane_paddr(pcdev->active, 0);
> +	phys_addr_top = vb2_dma_contig_plane_dma_addr(pcdev->active, 0);
>  
>  	ceu_write(pcdev, top1, phys_addr_top);
>  	if (V4L2_FIELD_NONE != pcdev->field) {
> diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
> index a790a5f..f17ad98 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -24,7 +24,7 @@ struct vb2_dc_conf {
>  struct vb2_dc_buf {
>  	struct vb2_dc_conf		*conf;
>  	void				*vaddr;
> -	dma_addr_t			paddr;
> +	dma_addr_t			dma_addr;
>  	unsigned long			size;
>  	struct vm_area_struct		*vma;
>  	atomic_t			refcount;
> @@ -42,7 +42,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
>  	if (!buf)
>  		return ERR_PTR(-ENOMEM);
>  
> -	buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->paddr,
> +	buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->dma_addr,
>  					GFP_KERNEL);
>  	if (!buf->vaddr) {
>  		dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
> @@ -69,7 +69,7 @@ static void vb2_dma_contig_put(void *buf_priv)
>  
>  	if (atomic_dec_and_test(&buf->refcount)) {
>  		dma_free_coherent(buf->conf->dev, buf->size, buf->vaddr,
> -				  buf->paddr);
> +				  buf->dma_addr);
>  		kfree(buf);
>  	}
>  }
> @@ -78,7 +78,7 @@ static void *vb2_dma_contig_cookie(void *buf_priv)
>  {
>  	struct vb2_dc_buf *buf = buf_priv;
>  
> -	return &buf->paddr;
> +	return &buf->dma_addr;
>  }
>  
>  static void *vb2_dma_contig_vaddr(void *buf_priv)
> @@ -106,7 +106,7 @@ static int vb2_dma_contig_mmap(void *buf_priv, struct vm_area_struct *vma)
>  		return -EINVAL;
>  	}
>  
> -	return vb2_mmap_pfn_range(vma, buf->paddr, buf->size,
> +	return vb2_mmap_pfn_range(vma, buf->dma_addr, buf->size,
>  				  &vb2_common_vm_ops, &buf->handler);
>  }
>  
> @@ -115,14 +115,14 @@ static void *vb2_dma_contig_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  {
>  	struct vb2_dc_buf *buf;
>  	struct vm_area_struct *vma;
> -	dma_addr_t paddr = 0;
> +	dma_addr_t dma_addr = 0;
>  	int ret;
>  
>  	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>  	if (!buf)
>  		return ERR_PTR(-ENOMEM);
>  
> -	ret = vb2_get_contig_userptr(vaddr, size, &vma, &paddr);
> +	ret = vb2_get_contig_userptr(vaddr, size, &vma, &dma_addr);
>  	if (ret) {
>  		printk(KERN_ERR "Failed acquiring VMA for vaddr 0x%08lx\n",
>  				vaddr);
> @@ -131,7 +131,7 @@ static void *vb2_dma_contig_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  	}
>  
>  	buf->size = size;
> -	buf->paddr = paddr;
> +	buf->dma_addr = dma_addr;
>  	buf->vma = vma;
>  
>  	return buf;
> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
> index 7e6c68b..19ae1e3 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -17,11 +17,11 @@
>  #include <linux/dma-mapping.h>
>  
>  static inline dma_addr_t
> -vb2_dma_contig_plane_paddr(struct vb2_buffer *vb, unsigned int plane_no)
> +vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>  {
> -	dma_addr_t *paddr = vb2_plane_cookie(vb, plane_no);
> +	dma_addr_t *addr = vb2_plane_cookie(vb, plane_no);
>  
> -	return *paddr;
> +	return *addr;
>  }
>  
>  void *vb2_dma_contig_init_ctx(struct device *dev);
> -- 
> 1.7.1.569.g6f426
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
