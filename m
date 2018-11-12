Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52810 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbeKMClG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 21:41:06 -0500
Message-ID: <4df33c01d77815f5c72769ccb7f7f7f98d58b4c8.camel@bootlin.com>
Subject: Re: [RFC PATCHv2 5/5] cedrus: add tag support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, tfiga@chromium.org
Date: Mon, 12 Nov 2018 17:47:01 +0100
In-Reply-To: <20181112083305.22618-6-hverkuil@xs4all.nl>
References: <20181112083305.22618-1-hverkuil@xs4all.nl>
         <20181112083305.22618-6-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-jVDLx3sJ3OlgvHgS473v"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-jVDLx3sJ3OlgvHgS473v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-11-12 at 09:33 +0100, Hans Verkuil wrote:
> Replace old reference frame indices by new tag method.

I tested this for the cedrus driver and it works properly!
Thanks a lot for implementating this for our driver.
I have one minor cosmetic comment below.

Regarding the padding concerns, I am wondering if we should convert some
of the fields to flags (as it's done in the proposed H264 spec) when
they are binary. We could then use this flags element as padding,
instead of picking the last item and increasing its size.

What do you think?

> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  9 --------
>  drivers/staging/media/sunxi/cedrus/cedrus.h   |  8 ++++---
>  .../staging/media/sunxi/cedrus/cedrus_dec.c   | 10 +++++++++
>  .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++++++-----------
>  include/uapi/linux/v4l2-controls.h            | 14 +++++--------
>  5 files changed, 29 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-co=
re/v4l2-ctrls.c
> index 5f2b033a7a42..b854cceb19dc 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1660,15 +1660,6 @@ static int std_validate(const struct v4l2_ctrl *ct=
rl, u32 idx,
>  			return -EINVAL;
>  		}
> =20
> -		if (p_mpeg2_slice_params->backward_ref_index >=3D VIDEO_MAX_FRAME ||
> -		    p_mpeg2_slice_params->forward_ref_index >=3D VIDEO_MAX_FRAME)
> -			return -EINVAL;
> -
> -		if (p_mpeg2_slice_params->pad ||
> -		    p_mpeg2_slice_params->picture.pad ||
> -		    p_mpeg2_slice_params->sequence.pad)
> -			return -EINVAL;
> -
>  		return 0;
> =20
>  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h b/drivers/stagin=
g/media/sunxi/cedrus/cedrus.h
> index 3f61248c57ac..a4bc19ae6bcc 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus.h
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
> @@ -142,11 +142,13 @@ static inline dma_addr_t cedrus_buf_addr(struct vb2=
_buffer *buf,
>  }
> =20
>  static inline dma_addr_t cedrus_dst_buf_addr(struct cedrus_ctx *ctx,
> -					     unsigned int index,
> -					     unsigned int plane)
> +					     int index, unsigned int plane)
>  {
> -	struct vb2_buffer *buf =3D ctx->dst_bufs[index];
> +	struct vb2_buffer *buf;
> =20
> +	if (index < 0)
> +		return 0;

Maybe adding a new line here would increase readability?

Cheers,

Paul

> +	buf =3D ctx->dst_bufs[index];
>  	return buf ? cedrus_buf_addr(buf, &ctx->dst_fmt, plane) : 0;
>  }
> =20
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/st=
aging/media/sunxi/cedrus/cedrus_dec.c
> index e40180a33951..76fed2f1f5e2 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> @@ -53,6 +53,16 @@ void cedrus_device_run(void *priv)
>  		break;
>  	}
> =20
> +	run.dst->vb2_buf.timestamp =3D run.src->vb2_buf.timestamp;
> +	if (run.src->flags & V4L2_BUF_FLAG_TIMECODE)
> +		run.dst->timecode =3D run.src->timecode;
> +	else if (run.src->flags & V4L2_BUF_FLAG_TAG)
> +		run.dst->tag =3D run.src->tag;
> +	run.dst->flags =3D run.src->flags &
> +		(V4L2_BUF_FLAG_TIMECODE |
> +		 V4L2_BUF_FLAG_TAG |
> +		 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
> +
>  	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
> =20
>  	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/=
staging/media/sunxi/cedrus/cedrus_mpeg2.c
> index 9abd39cae38c..fdde9a099153 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> @@ -82,7 +82,10 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx,=
 struct cedrus_run *run)
>  	dma_addr_t fwd_luma_addr, fwd_chroma_addr;
>  	dma_addr_t bwd_luma_addr, bwd_chroma_addr;
>  	struct cedrus_dev *dev =3D ctx->dev;
> +	struct vb2_queue *cap_q =3D &ctx->fh.m2m_ctx->cap_q_ctx.q;
>  	const u8 *matrix;
> +	int forward_idx;
> +	int backward_idx;
>  	unsigned int i;
>  	u32 reg;
> =20
> @@ -156,23 +159,17 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *c=
tx, struct cedrus_run *run)
>  	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
> =20
>  	/* Forward and backward prediction reference buffers. */
> +	forward_idx =3D vb2_find_tag(cap_q, slice_params->forward_ref_tag, 0);
> =20
> -	fwd_luma_addr =3D cedrus_dst_buf_addr(ctx,
> -					    slice_params->forward_ref_index,
> -					    0);
> -	fwd_chroma_addr =3D cedrus_dst_buf_addr(ctx,
> -					      slice_params->forward_ref_index,
> -					      1);
> +	fwd_luma_addr =3D cedrus_dst_buf_addr(ctx, forward_idx, 0);
> +	fwd_chroma_addr =3D cedrus_dst_buf_addr(ctx, forward_idx, 1);
> =20
>  	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
>  	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
> =20
> -	bwd_luma_addr =3D cedrus_dst_buf_addr(ctx,
> -					    slice_params->backward_ref_index,
> -					    0);
> -	bwd_chroma_addr =3D cedrus_dst_buf_addr(ctx,
> -					      slice_params->backward_ref_index,
> -					      1);
> +	backward_idx =3D vb2_find_tag(cap_q, slice_params->backward_ref_tag, 0)=
;
> +	bwd_luma_addr =3D cedrus_dst_buf_addr(ctx, backward_idx, 0);
> +	bwd_chroma_addr =3D cedrus_dst_buf_addr(ctx, backward_idx, 1);
> =20
>  	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_LUMA_ADDR, bwd_luma_addr);
>  	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_CHROMA_ADDR, bwd_chroma_addr);
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2=
-controls.h
> index 998983a6e6b7..43f2f9148b3c 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -1109,10 +1109,9 @@ struct v4l2_mpeg2_sequence {
>  	__u32	vbv_buffer_size;
> =20
>  	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Sequence extension */
> -	__u8	profile_and_level_indication;
> +	__u16	profile_and_level_indication;
>  	__u8	progressive_sequence;
>  	__u8	chroma_format;
> -	__u8	pad;
>  };
> =20
>  struct v4l2_mpeg2_picture {
> @@ -1130,23 +1129,20 @@ struct v4l2_mpeg2_picture {
>  	__u8	intra_vlc_format;
>  	__u8	alternate_scan;
>  	__u8	repeat_first_field;
> -	__u8	progressive_frame;
> -	__u8	pad;
> +	__u16	progressive_frame;
>  };
> =20
>  struct v4l2_ctrl_mpeg2_slice_params {
>  	__u32	bit_size;
>  	__u32	data_bit_offset;
> +	__u64	backward_ref_tag;
> +	__u64	forward_ref_tag;
> =20
>  	struct v4l2_mpeg2_sequence sequence;
>  	struct v4l2_mpeg2_picture picture;
> =20
>  	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Slice */
> -	__u8	quantiser_scale_code;
> -
> -	__u8	backward_ref_index;
> -	__u8	forward_ref_index;
> -	__u8	pad;
> +	__u32	quantiser_scale_code;
>  };
> =20
>  struct v4l2_ctrl_mpeg2_quantization {
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-jVDLx3sJ3OlgvHgS473v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlvproUACgkQ3cLmz3+f
v9H1xAf+Lu1hIIgLkl55pNf6BfgCe4arwOcIZoC8O5Az2tJCNFWQr/zHA9Ds9azD
Z7W881ovEsaAz1vRufHeHQ7qFG/1Ps2wnQH7P5jS+0m+pgUBnADg2njHiFQmmyQC
TL0qblwTuTzb27u0obWhPUOhG2gp1kjFLdzwbPg2yldXtFgzylpAU+skoYMWg/lH
00WqalorEaahk9VayvePlDoyaGTnWY7DT+PSFQaetqhM8livaTrRauQr3rZfLGil
hd3DimpBXezk5SAnQbg87PRbDw7cxqeuckPFfVOeieUp+0YzWZWflMoaLFPlAWC7
6gQitCXuc07P/SZcTmhm8lI4NEHAxA==
=1BkA
-----END PGP SIGNATURE-----

--=-jVDLx3sJ3OlgvHgS473v--
