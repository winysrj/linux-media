Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44537 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbeLCPtH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 10:49:07 -0500
Message-ID: <5df9a57241039cacf9d7131dd4c358f8d733f2db.camel@bootlin.com>
Subject: Re: [PATCHv3 9/9] cedrus: add tag support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, tfiga@chromium.org,
        nicolas@ndufresne.ca, sakari.ailus@linux.intel.com
Date: Mon, 03 Dec 2018 16:49:03 +0100
In-Reply-To: <20181203135143.45487-10-hverkuil-cisco@xs4all.nl>
References: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
         <20181203135143.45487-10-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, 2018-12-03 at 14:51 +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Replace old reference frame indices by new tag method.

> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

I missed it earlier, but we should remember to update the MPEG-2
controls documentation to mention the use of tags instead of buffer
indices.

Cheers,

Paul

> Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  9 --------
>  drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 +++++---
>  .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 ++
>  .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++++++-----------
>  .../staging/media/sunxi/cedrus/cedrus_video.c |  2 ++
>  include/uapi/linux/v4l2-controls.h            | 14 +++++--------
>  6 files changed, 24 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 5f2b033a7a42..b854cceb19dc 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1660,15 +1660,6 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  			return -EINVAL;
>  		}
>  
> -		if (p_mpeg2_slice_params->backward_ref_index >= VIDEO_MAX_FRAME ||
> -		    p_mpeg2_slice_params->forward_ref_index >= VIDEO_MAX_FRAME)
> -			return -EINVAL;
> -
> -		if (p_mpeg2_slice_params->pad ||
> -		    p_mpeg2_slice_params->picture.pad ||
> -		    p_mpeg2_slice_params->sequence.pad)
> -			return -EINVAL;
> -
>  		return 0;
>  
>  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h b/drivers/staging/media/sunxi/cedrus/cedrus.h
> index 3f61248c57ac..781676b55a1b 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus.h
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
> @@ -142,11 +142,14 @@ static inline dma_addr_t cedrus_buf_addr(struct vb2_buffer *buf,
>  }
>  
>  static inline dma_addr_t cedrus_dst_buf_addr(struct cedrus_ctx *ctx,
> -					     unsigned int index,
> -					     unsigned int plane)
> +					     int index, unsigned int plane)
>  {
> -	struct vb2_buffer *buf = ctx->dst_bufs[index];
> +	struct vb2_buffer *buf;
>  
> +	if (index < 0)
> +		return 0;
> +
> +	buf = ctx->dst_bufs[index];
>  	return buf ? cedrus_buf_addr(buf, &ctx->dst_fmt, plane) : 0;
>  }
>  
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> index e40180a33951..0cfd6036d0cd 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> @@ -53,6 +53,8 @@ void cedrus_device_run(void *priv)
>  		break;
>  	}
>  
> +	v4l2_m2m_buf_copy_data(run.src, run.dst, true);
> +
>  	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
>  
>  	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> index 9abd39cae38c..fdde9a099153 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> @@ -82,7 +82,10 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
>  	dma_addr_t fwd_luma_addr, fwd_chroma_addr;
>  	dma_addr_t bwd_luma_addr, bwd_chroma_addr;
>  	struct cedrus_dev *dev = ctx->dev;
> +	struct vb2_queue *cap_q = &ctx->fh.m2m_ctx->cap_q_ctx.q;
>  	const u8 *matrix;
> +	int forward_idx;
> +	int backward_idx;
>  	unsigned int i;
>  	u32 reg;
>  
> @@ -156,23 +159,17 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
>  	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
>  
>  	/* Forward and backward prediction reference buffers. */
> +	forward_idx = vb2_find_tag(cap_q, slice_params->forward_ref_tag, 0);
>  
> -	fwd_luma_addr = cedrus_dst_buf_addr(ctx,
> -					    slice_params->forward_ref_index,
> -					    0);
> -	fwd_chroma_addr = cedrus_dst_buf_addr(ctx,
> -					      slice_params->forward_ref_index,
> -					      1);
> +	fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
> +	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
>  
>  	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
>  	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
>  
> -	bwd_luma_addr = cedrus_dst_buf_addr(ctx,
> -					    slice_params->backward_ref_index,
> -					    0);
> -	bwd_chroma_addr = cedrus_dst_buf_addr(ctx,
> -					      slice_params->backward_ref_index,
> -					      1);
> +	backward_idx = vb2_find_tag(cap_q, slice_params->backward_ref_tag, 0);
> +	bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
> +	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
>  
>  	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_LUMA_ADDR, bwd_luma_addr);
>  	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_CHROMA_ADDR, bwd_chroma_addr);
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> index 5c5fce678b93..293df48326cc 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> @@ -522,6 +522,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->lock = &ctx->dev->dev_mutex;
>  	src_vq->dev = ctx->dev->dev;
>  	src_vq->supports_requests = true;
> +	src_vq->supports_tags = true;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -537,6 +538,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	dst_vq->lock = &ctx->dev->dev_mutex;
>  	dst_vq->dev = ctx->dev->dev;
> +	dst_vq->supports_tags = true;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 998983a6e6b7..45a55bb27e5a 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -1109,10 +1109,9 @@ struct v4l2_mpeg2_sequence {
>  	__u32	vbv_buffer_size;
>  
>  	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Sequence extension */
> -	__u8	profile_and_level_indication;
> +	__u16	profile_and_level_indication;
>  	__u8	progressive_sequence;
>  	__u8	chroma_format;
> -	__u8	pad;
>  };
>  
>  struct v4l2_mpeg2_picture {
> @@ -1130,23 +1129,20 @@ struct v4l2_mpeg2_picture {
>  	__u8	intra_vlc_format;
>  	__u8	alternate_scan;
>  	__u8	repeat_first_field;
> -	__u8	progressive_frame;
> -	__u8	pad;
> +	__u16	progressive_frame;
>  };
>  
>  struct v4l2_ctrl_mpeg2_slice_params {
>  	__u32	bit_size;
>  	__u32	data_bit_offset;
> +	__u32	backward_ref_tag;
> +	__u32	forward_ref_tag;
>  
>  	struct v4l2_mpeg2_sequence sequence;
>  	struct v4l2_mpeg2_picture picture;
>  
>  	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Slice */
> -	__u8	quantiser_scale_code;
> -
> -	__u8	backward_ref_index;
> -	__u8	forward_ref_index;
> -	__u8	pad;
> +	__u32	quantiser_scale_code;
>  };
>  
>  struct v4l2_ctrl_mpeg2_quantization {
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
