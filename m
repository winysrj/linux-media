Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38315 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753718AbcKNKS1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 05:18:27 -0500
Subject: Re: [RFC 07/10] sunxi-cedrus: Add a MPEG 2 codec
To: Florent Revest <florent.revest@free-electrons.com>,
        linux-media@vger.kernel.org
References: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
 <1472117989-21455-8-git-send-email-florent.revest@free-electrons.com>
Cc: linux-sunxi@googlegroups.com, maxime.ripard@free-electrons.com,
        posciak@chromium.org, hans.verkuil@cisco.com,
        thomas.petazzoni@free-electrons.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, wens@csie.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ff07bec7-1bc5-2a68-772c-f294daadef78@xs4all.nl>
Date: Mon, 14 Nov 2016 11:18:17 +0100
MIME-Version: 1.0
In-Reply-To: <1472117989-21455-8-git-send-email-florent.revest@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/2016 11:39 AM, Florent Revest wrote:
> This patch introduces the support of MPEG2 video decoding to the
> sunxi-cedrus video decoder driver.
> 
> Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
> ---
>  drivers/media/platform/sunxi-cedrus/Makefile       |   2 +-
>  drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c |  26 +++-
>  .../platform/sunxi-cedrus/sunxi_cedrus_common.h    |   2 +
>  .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.c |  15 +-
>  .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.c  |  17 ++-
>  .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.h  |   4 +
>  .../platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c     | 152 +++++++++++++++++++++
>  7 files changed, 211 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c
> 
> diff --git a/drivers/media/platform/sunxi-cedrus/Makefile b/drivers/media/platform/sunxi-cedrus/Makefile
> index 14c2f7a..2d495a2 100644
> --- a/drivers/media/platform/sunxi-cedrus/Makefile
> +++ b/drivers/media/platform/sunxi-cedrus/Makefile
> @@ -1,2 +1,2 @@
>  obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) += sunxi_cedrus.o sunxi_cedrus_hw.o \
> -				    sunxi_cedrus_dec.o
> +				    sunxi_cedrus_dec.o sunxi_cedrus_mpeg2.o
> diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
> index 17af34c..d1c957a 100644
> --- a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
> +++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
> @@ -46,14 +46,31 @@ static int sunxi_cedrus_s_ctrl(struct v4l2_ctrl *ctrl)
>  	struct sunxi_cedrus_ctx *ctx =
>  		container_of(ctrl->handler, struct sunxi_cedrus_ctx, hdl);
>  
> -	v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
> -	return -EINVAL;
> +	switch (ctrl->id) {
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
> +		/* This is kept in memory and used directly. */
> +		break;
> +	default:
> +		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");

Drop this, it's pointless since this cannot happen, and even if it could, there
is nothing wrong about userspace passing an unknown control, that should just result in
-EINVAL.

> +		return -EINVAL;
> +	}
> +
> +	return 0;
>  }
>  
>  static const struct v4l2_ctrl_ops sunxi_cedrus_ctrl_ops = {
>  	.s_ctrl = sunxi_cedrus_s_ctrl,
>  };
>  
> +static const struct v4l2_ctrl_config sunxi_cedrus_ctrl_mpeg2_frame_hdr = {
> +	.ops = &sunxi_cedrus_ctrl_ops,
> +	.id = V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR,
> +	.type = V4L2_CTRL_TYPE_PRIVATE,
> +	.name = "MPEG2 Frame Header Parameters",
> +	.max_reqs = VIDEO_MAX_FRAME,
> +	.elem_size = sizeof(struct v4l2_ctrl_mpeg2_frame_hdr),
> +};
> +

I understand that this is not yet finalized. In any case, what should happen is
that we have standard compound controls for the MPEG2 and MPEG4 headers that are
based on the MPEG-2 and MPEG-4 standards. Any HW specific information should be
done through driver-specific controls.

I am not sure if V4L2_CTRL_TYPE_PRIVATE is the way to go for private compound
controls, but it may not be needed at all once these MPEG controls are standardized.

>  /*
>   * File operations
>   */
> @@ -78,6 +95,10 @@ static int sunxi_cedrus_open(struct file *file)
>  	hdl = &ctx->hdl;
>  	v4l2_ctrl_handler_init(hdl, 1);
>  
> +	ctx->mpeg2_frame_hdr_ctrl = v4l2_ctrl_new_custom(hdl,
> +			&sunxi_cedrus_ctrl_mpeg2_frame_hdr, NULL);
> +	ctx->mpeg2_frame_hdr_ctrl->flags |= V4L2_CTRL_FLAG_REQ_KEEP;
> +
>  	if (hdl->error) {
>  		rc = hdl->error;
>  		v4l2_ctrl_handler_free(hdl);
> @@ -117,6 +138,7 @@ static int sunxi_cedrus_release(struct file *file)
>  	v4l2_fh_del(&ctx->fh);
>  	v4l2_fh_exit(&ctx->fh);
>  	v4l2_ctrl_handler_free(&ctx->hdl);
> +	ctx->mpeg2_frame_hdr_ctrl = NULL;
>  	mutex_lock(&dev->dev_mutex);
>  	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
>  	mutex_unlock(&dev->dev_mutex);
> diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h
> index 6b8d87a..e715184 100644
> --- a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h
> +++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h
> @@ -70,6 +70,8 @@ struct sunxi_cedrus_ctx {
>  	struct v4l2_ctrl_handler hdl;
>  
>  	struct vb2_buffer *dst_bufs[VIDEO_MAX_FRAME];
> +
> +	struct v4l2_ctrl *mpeg2_frame_hdr_ctrl;
>  };
>  
>  static inline void sunxi_cedrus_write(struct sunxi_cedrus_dev *vpu,
> diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c
> index 71ef34b..38e8a3a 100644
> --- a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c
> +++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c
> @@ -48,6 +48,11 @@ static struct sunxi_cedrus_fmt formats[] = {
>  		.depth = 8,
>  		.num_planes = 2,
>  	},
> +	{
> +		.fourcc = V4L2_PIX_FMT_MPEG2_FRAME,
> +		.types	= SUNXI_CEDRUS_OUTPUT,
> +		.num_planes = 1,
> +	},
>  };
>  
>  #define NUM_FORMATS ARRAY_SIZE(formats)
> @@ -120,8 +125,14 @@ void device_run(void *priv)
>  		 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_PFRAME |
>  		 V4L2_BUF_FLAG_BFRAME   | V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
>  
> -	v4l2_m2m_buf_done(in_vb, VB2_BUF_STATE_ERROR);
> -	v4l2_m2m_buf_done(out_vb, VB2_BUF_STATE_ERROR);
> +	if (ctx->vpu_src_fmt->fourcc == V4L2_PIX_FMT_MPEG2_FRAME) {
> +		struct v4l2_ctrl_mpeg2_frame_hdr *frame_hdr =
> +				ctx->mpeg2_frame_hdr_ctrl->p_new.p;
> +		process_mpeg2(ctx, in_buf, out_luma, out_chroma, frame_hdr);
> +	} else {
> +		v4l2_m2m_buf_done(in_vb, VB2_BUF_STATE_ERROR);
> +		v4l2_m2m_buf_done(out_vb, VB2_BUF_STATE_ERROR);
> +	}
>  }
>  
>  /*
> diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.c b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.c
> index 72b9df4..160de17 100644
> --- a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.c
> +++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.c
> @@ -47,6 +47,13 @@ static irqreturn_t sunxi_cedrus_ve_irq(int irq, void *dev_id)
>  	int val;
>  	unsigned long flags;
>  
> +	/* Disable MPEG interrupts and stop the MPEG engine */
> +	val = sunxi_cedrus_read(vpu, VE_MPEG_CTRL);
> +	sunxi_cedrus_write(vpu, val & (~0xf), VE_MPEG_CTRL);
> +	val = sunxi_cedrus_read(vpu, VE_MPEG_STATUS);
> +	sunxi_cedrus_write(vpu, 0x0000c00f, VE_MPEG_STATUS);
> +	sunxi_cedrus_write(vpu, VE_CTRL_REINIT, VE_CTRL);
> +
>  	curr_ctx = v4l2_m2m_get_curr_priv(vpu->m2m_dev);
>  
>  	if (!curr_ctx) {
> @@ -57,9 +64,15 @@ static irqreturn_t sunxi_cedrus_ve_irq(int irq, void *dev_id)
>  	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
>  	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
>  
> +	/* First bit of MPEG_STATUS means success */
>  	spin_lock_irqsave(&vpu->irqlock, flags);
> -	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_ERROR);
> -	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_ERROR);
> +	if (val & 0x1) {
> +		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
> +		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
> +	} else {
> +		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_ERROR);
> +		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_ERROR);
> +	}
>  	spin_unlock_irqrestore(&vpu->irqlock, flags);
>  
>  	v4l2_m2m_job_finish(vpu->m2m_dev, curr_ctx->fh.m2m_ctx);
> diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h
> index 3c9199b..78625e5 100644
> --- a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h
> +++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h
> @@ -29,4 +29,8 @@ struct sunxi_cedrus_ctx;
>  int sunxi_cedrus_hw_probe(struct sunxi_cedrus_dev *vpu);
>  void sunxi_cedrus_hw_remove(struct sunxi_cedrus_dev *vpu);
>  
> +void process_mpeg2(struct sunxi_cedrus_ctx *ctx, dma_addr_t in_buf,
> +		   dma_addr_t out_luma, dma_addr_t out_chroma,
> +		   struct v4l2_ctrl_mpeg2_frame_hdr *frame_hdr);
> +
>  #endif /* SUNXI_CEDRUS_HW_H_ */
> diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c
> new file mode 100644
> index 0000000..9381c63
> --- /dev/null
> +++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c
> @@ -0,0 +1,152 @@
> +/*
> + * Sunxi Cedrus codec driver
> + *
> + * Copyright (C) 2016 Florent Revest
> + * Florent Revest <florent.revest@free-electrons.com>
> + *
> + * Based on reverse engineering efforts of the 'Cedrus' project
> + * Copyright (c) 2013-2014 Jens Kuske <jenskuske@gmail.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "sunxi_cedrus_common.h"
> +
> +#include <media/videobuf2-dma-contig.h>
> +
> +static const u8 mpeg_default_intra_quant[64] = {
> +	 8, 16, 16, 19, 16, 19, 22, 22,
> +	22, 22, 22, 22, 26, 24, 26, 27,
> +	27, 27, 26, 26, 26, 26, 27, 27,
> +	27, 29, 29, 29, 34, 34, 34, 29,
> +	29, 29, 27, 27, 29, 29, 32, 32,
> +	34, 34, 37, 38, 37, 35, 35, 34,
> +	35, 38, 38, 40, 40, 40, 48, 48,
> +	46, 46, 56, 56, 58, 69, 69, 83
> +};
> +
> +#define m_iq(i) (((64 + i) << 8) | mpeg_default_intra_quant[i])
> +
> +static const u8 mpeg_default_non_intra_quant[64] = {
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16
> +};
> +
> +#define m_niq(i) ((i << 8) | mpeg_default_non_intra_quant[i])
> +
> +void process_mpeg2(struct sunxi_cedrus_ctx *ctx, dma_addr_t in_buf,
> +		   dma_addr_t out_luma, dma_addr_t out_chroma,
> +		   struct v4l2_ctrl_mpeg2_frame_hdr *frame_hdr)
> +{
> +	struct sunxi_cedrus_dev *dev = ctx->dev;
> +
> +	u16 width = DIV_ROUND_UP(frame_hdr->width, 16);
> +	u16 height = DIV_ROUND_UP(frame_hdr->height, 16);
> +
> +	u32 pic_header = 0;
> +	u32 vld_len = frame_hdr->slice_len - frame_hdr->slice_pos;
> +	int i;
> +
> +	struct vb2_buffer *fwd_vb2_buf, *bwd_vb2_buf;
> +	dma_addr_t fwd_luma = 0, fwd_chroma = 0, bwd_luma = 0, bwd_chroma = 0;
> +
> +	/*
> +	 * The VPU is only able to handle bus addresses so we have to subtract
> +	 * the RAM offset to the physcal addresses
> +	 */
> +	fwd_vb2_buf = ctx->dst_bufs[frame_hdr->forward_index];
> +	if (fwd_vb2_buf) {
> +		fwd_luma   = vb2_dma_contig_plane_dma_addr(fwd_vb2_buf, 0);
> +		fwd_chroma = vb2_dma_contig_plane_dma_addr(fwd_vb2_buf, 1);
> +		fwd_luma   -= PHYS_OFFSET;
> +		fwd_chroma -= PHYS_OFFSET;
> +	}
> +
> +	bwd_vb2_buf = ctx->dst_bufs[frame_hdr->backward_index];
> +	if (bwd_vb2_buf) {
> +		bwd_luma   = vb2_dma_contig_plane_dma_addr(bwd_vb2_buf, 0);
> +		bwd_chroma = vb2_dma_contig_plane_dma_addr(bwd_vb2_buf, 1);
> +		bwd_chroma -= PHYS_OFFSET;
> +		bwd_luma   -= PHYS_OFFSET;
> +	}
> +
> +	/* Activates MPEG engine */
> +	sunxi_cedrus_write(dev, VE_CTRL_MPEG, VE_CTRL);
> +
> +	/* Upload quantization matrices */
> +	for (i = 0; i < 64; i++) {
> +		sunxi_cedrus_write(dev, m_iq(i),  VE_MPEG_IQ_MIN_INPUT);
> +		sunxi_cedrus_write(dev, m_niq(i), VE_MPEG_IQ_MIN_INPUT);
> +	}
> +
> +	/* Image's dimensions */
> +	sunxi_cedrus_write(dev, width << 8  | height,      VE_MPEG_SIZE);
> +	sunxi_cedrus_write(dev, width << 20 | height << 4, VE_MPEG_FRAME_SIZE);
> +
> +	/* MPEG picture's header */
> +	pic_header |= (frame_hdr->picture_coding_type        & 0xf) << 28;
> +	pic_header |= (frame_hdr->f_code[0][0]               & 0xf) << 24;
> +	pic_header |= (frame_hdr->f_code[0][1]               & 0xf) << 20;
> +	pic_header |= (frame_hdr->f_code[1][0]               & 0xf) << 16;
> +	pic_header |= (frame_hdr->f_code[1][1]               & 0xf) << 12;
> +	pic_header |= (frame_hdr->intra_dc_precision         & 0x3) << 10;
> +	pic_header |= (frame_hdr->picture_structure          & 0x3) << 8;
> +	pic_header |= (frame_hdr->top_field_first            & 0x1) << 7;
> +	pic_header |= (frame_hdr->frame_pred_frame_dct       & 0x1) << 6;
> +	pic_header |= (frame_hdr->concealment_motion_vectors & 0x1) << 5;
> +	pic_header |= (frame_hdr->q_scale_type               & 0x1) << 4;
> +	pic_header |= (frame_hdr->intra_vlc_format           & 0x1) << 3;
> +	pic_header |= (frame_hdr->alternate_scan             & 0x1) << 2;
> +	sunxi_cedrus_write(dev, pic_header, VE_MPEG_PIC_HDR);
> +
> +	/* Enable interrupt and an unknown control flag */
> +	sunxi_cedrus_write(dev, VE_MPEG_CTRL_MPEG2, VE_MPEG_CTRL);
> +
> +	/* Macroblock address */
> +	sunxi_cedrus_write(dev, 0, VE_MPEG_MBA);
> +
> +	/* Clear previous errors */
> +	sunxi_cedrus_write(dev, 0, VE_MPEG_ERROR);
> +
> +	/* Unknown register */
> +	sunxi_cedrus_write(dev, 0, VE_MPEG_CTR_MB);
> +
> +	/* Forward and backward prediction buffers (cached in dst_bufs) */
> +	sunxi_cedrus_write(dev, fwd_luma,   VE_MPEG_FWD_LUMA);
> +	sunxi_cedrus_write(dev, fwd_chroma, VE_MPEG_FWD_CHROMA);
> +	sunxi_cedrus_write(dev, bwd_luma,   VE_MPEG_BACK_LUMA);
> +	sunxi_cedrus_write(dev, bwd_chroma, VE_MPEG_BACK_CHROMA);
> +
> +	/* Output luma and chroma buffers */
> +	sunxi_cedrus_write(dev, out_luma,   VE_MPEG_REC_LUMA);
> +	sunxi_cedrus_write(dev, out_chroma, VE_MPEG_REC_CHROMA);
> +	sunxi_cedrus_write(dev, out_luma,   VE_MPEG_ROT_LUMA);
> +	sunxi_cedrus_write(dev, out_chroma, VE_MPEG_ROT_CHROMA);
> +
> +	/* Input offset and length in bits */
> +	sunxi_cedrus_write(dev, frame_hdr->slice_pos, VE_MPEG_VLD_OFFSET);
> +	sunxi_cedrus_write(dev, vld_len, VE_MPEG_VLD_LEN);
> +
> +	/* Input beginning and end addresses */
> +	sunxi_cedrus_write(dev, VE_MPEG_VLD_ADDR_VAL(in_buf), VE_MPEG_VLD_ADDR);
> +	sunxi_cedrus_write(dev, in_buf + VBV_SIZE - 1, VE_MPEG_VLD_END);
> +
> +	/* Starts the MPEG engine */
> +	if (frame_hdr->type == MPEG2)
> +		sunxi_cedrus_write(dev, VE_TRIG_MPEG2, VE_MPEG_TRIGGER);
> +	else
> +		sunxi_cedrus_write(dev, VE_TRIG_MPEG1, VE_MPEG_TRIGGER);
> +}
> 

Regards,

	Hans
