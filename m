Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:48919 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932677AbeFUJuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 05:50:13 -0400
Message-ID: <939381a854760b1d54984ae0f534ec03312ec8e0.camel@bootlin.com>
Subject: Re: [PATCH 6/9] media: cedrus: Add ops structure
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: tfiga@chromium.org, posciak@chromium.org,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date: Thu, 21 Jun 2018 11:49:54 +0200
In-Reply-To: <20180613140714.1686-7-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-7-maxime.ripard@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-6KNc3m/0MdpjtCFVHVXX"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-6KNc3m/0MdpjtCFVHVXX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> In order to increase the number of codecs supported, we need to decouple
> the MPEG2 only code that was there up until now and turn it into somethin=
g
> a bit more generic.
>=20
> Do that by introducing an intermediate ops structure that would need to b=
e
> filled by each supported codec. Start by implementing in that structure t=
he
> setup and trigger hooks that are currently the only functions being
> implemented by codecs support.
>=20
> To do so, we need to store the current codec in use, which we do at
> start_streaming time.

With the comments below taken in account, this is:

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  .../platform/sunxi/cedrus/sunxi_cedrus.c      |  2 ++
>  .../sunxi/cedrus/sunxi_cedrus_common.h        | 11 +++++++
>  .../platform/sunxi/cedrus/sunxi_cedrus_dec.c  | 10 +++---
>  .../sunxi/cedrus/sunxi_cedrus_mpeg2.c         | 11 +++++--
>  .../sunxi/cedrus/sunxi_cedrus_mpeg2.h         | 33 -------------------
>  .../sunxi/cedrus/sunxi_cedrus_video.c         | 17 +++++++++-
>  6 files changed, 42 insertions(+), 42 deletions(-)
>  delete mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg=
2.h
>=20
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c b/drivers=
/media/platform/sunxi/cedrus/sunxi_cedrus.c
> index ccd41d9a3e41..bc80480f5dfd 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
> @@ -244,6 +244,8 @@ static int sunxi_cedrus_probe(struct platform_device =
*pdev)
>  	if (ret)
>  		return ret;
> =20
> +	dev->dec_ops[SUNXI_CEDRUS_CODEC_MPEG2] =3D &sunxi_cedrus_dec_ops_mpeg2;
> +
>  	ret =3D v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
>  	if (ret)
>  		goto unreg_media;
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h b/=
drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> index a5f83c452006..c2e2c92d103b 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> @@ -75,6 +75,7 @@ struct sunxi_cedrus_ctx {
>  	struct v4l2_pix_format_mplane src_fmt;
>  	struct sunxi_cedrus_fmt *vpu_dst_fmt;
>  	struct v4l2_pix_format_mplane dst_fmt;
> +	enum sunxi_cedrus_codec current_codec;

Nit: for consistency with the way things are named, "codec_current"
probably makes more sense.

IMO using the natural English order is fine for temporary variables, but
 less so for variables used in common parts like structures. This allows
seeing "_" as a logical hierarchical delimiter that automatically makes
us end up with consistent prefixes that can easily be grepped for and
derived.

But that's just my 2 cents, it's really not a big deal, especially in
this case!

>  	struct v4l2_ctrl_handler hdl;
>  	struct v4l2_ctrl *ctrls[SUNXI_CEDRUS_CTRL_MAX];
> @@ -107,6 +108,14 @@ struct sunxi_cedrus_buffer *vb2_to_cedrus_buffer(con=
st struct vb2_buffer *p)
>  	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
>  }
> =20
> +struct sunxi_cedrus_dec_ops {
> +	void (*setup)(struct sunxi_cedrus_ctx *ctx,
> +		      struct sunxi_cedrus_run *run);
> +	void (*trigger)(struct sunxi_cedrus_ctx *ctx);

By the way, are we sure that these functions won't ever fail?
I think this is the case for MPEG2 (there is virtually nothing to check
for errors) but perhaps it's different for H264.

> +};
> +
> +extern struct sunxi_cedrus_dec_ops sunxi_cedrus_dec_ops_mpeg2;
> +
>  struct sunxi_cedrus_dev {
>  	struct v4l2_device v4l2_dev;
>  	struct video_device vfd;
> @@ -130,6 +139,8 @@ struct sunxi_cedrus_dev {
>  	struct reset_control *rstc;
> =20
>  	struct regmap *syscon;
> +
> +	struct sunxi_cedrus_dec_ops	*dec_ops[SUNXI_CEDRUS_CODEC_LAST];
>  };
> =20
>  static inline void sunxi_cedrus_write(struct sunxi_cedrus_dev *dev,
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c b/dri=
vers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
> index f274408ab5a7..5e552fa05274 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
> @@ -28,7 +28,6 @@
>  #include <media/v4l2-mem2mem.h>
> =20
>  #include "sunxi_cedrus_common.h"
> -#include "sunxi_cedrus_mpeg2.h"
>  #include "sunxi_cedrus_dec.h"
>  #include "sunxi_cedrus_hw.h"
> =20
> @@ -77,6 +76,7 @@ void sunxi_cedrus_device_work(struct work_struct *work)
>  void sunxi_cedrus_device_run(void *priv)
>  {
>  	struct sunxi_cedrus_ctx *ctx =3D priv;
> +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
>  	struct sunxi_cedrus_run run =3D { 0 };
>  	struct media_request *src_req, *dst_req;
>  	unsigned long flags;
> @@ -120,8 +120,6 @@ void sunxi_cedrus_device_run(void *priv)
>  	case V4L2_PIX_FMT_MPEG2_FRAME:
>  		CHECK_CONTROL(ctx, SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR);
>  		run.mpeg2.hdr =3D get_ctrl_ptr(ctx, SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_=
HDR);
> -		sunxi_cedrus_mpeg2_setup(ctx, &run);
> -
>  		break;
> =20
>  	default:
> @@ -129,6 +127,9 @@ void sunxi_cedrus_device_run(void *priv)
>  	}
>  #undef CHECK_CONTROL
> =20
> +	if (!ctx->job_abort)
> +		dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
> +
>  unlock_complete:
>  	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> =20
> @@ -143,8 +144,7 @@ void sunxi_cedrus_device_run(void *priv)
>  	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> =20
>  	if (!ctx->job_abort) {
> -		if (ctx->vpu_src_fmt->fourcc =3D=3D V4L2_PIX_FMT_MPEG2_FRAME)
> -			sunxi_cedrus_mpeg2_trigger(ctx);
> +		dev->dec_ops[ctx->current_codec]->trigger(ctx);
>  	} else {
>  		v4l2_m2m_buf_done(run.src, VB2_BUF_STATE_ERROR);
>  		v4l2_m2m_buf_done(run.dst, VB2_BUF_STATE_ERROR);
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c b/d=
rivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> index d1d7a3cfce0d..e25075bb5779 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> @@ -52,8 +52,8 @@ static const u8 mpeg_default_non_intra_quant[64] =3D {
> =20
>  #define m_niq(i) ((i << 8) | mpeg_default_non_intra_quant[i])
> =20
> -void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
> -			      struct sunxi_cedrus_run *run)
> +static void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
> +				     struct sunxi_cedrus_run *run)
>  {
>  	struct sunxi_cedrus_dev *dev =3D ctx->dev;
>  	const struct v4l2_ctrl_mpeg2_frame_hdr *frame_hdr =3D run->mpeg2.hdr;
> @@ -148,9 +148,14 @@ void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ct=
x *ctx,
>  	sunxi_cedrus_write(dev, src_buf_addr + VBV_SIZE - 1, VE_MPEG_VLD_END);
>  }
> =20
> -void sunxi_cedrus_mpeg2_trigger(struct sunxi_cedrus_ctx *ctx)
> +static void sunxi_cedrus_mpeg2_trigger(struct sunxi_cedrus_ctx *ctx)
>  {
>  	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> =20
>  	sunxi_cedrus_write(dev, VE_TRIG_MPEG2, VE_MPEG_TRIGGER);
>  }
> +
> +struct sunxi_cedrus_dec_ops sunxi_cedrus_dec_ops_mpeg2 =3D {
> +	.setup		=3D sunxi_cedrus_mpeg2_setup,
> +	.trigger	=3D sunxi_cedrus_mpeg2_trigger,
> +};
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h b/d=
rivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h
> deleted file mode 100644
> index 4c380becfa1a..000000000000
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h
> +++ /dev/null
> @@ -1,33 +0,0 @@
> -/*
> - * Sunxi-Cedrus VPU driver
> - *
> - * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> - * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
> - *
> - * Based on the vim2m driver, that is:
> - *
> - * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> - * Pawel Osciak, <pawel@osciak.com>
> - * Marek Szyprowski, <m.szyprowski@samsung.com>
> - *
> - * This software is licensed under the terms of the GNU General Public
> - * License version 2, as published by the Free Software Foundation, and
> - * may be copied, distributed, and modified under those terms.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#ifndef _SUNXI_CEDRUS_MPEG2_H_
> -#define _SUNXI_CEDRUS_MPEG2_H_
> -
> -struct sunxi_cedrus_ctx;
> -struct sunxi_cedrus_run;
> -
> -void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
> -			      struct sunxi_cedrus_run *run);
> -void sunxi_cedrus_mpeg2_trigger(struct sunxi_cedrus_ctx *ctx);
> -
> -#endif
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c b/d=
rivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> index 089abfe6bfeb..fb7b081a5bb7 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> @@ -28,7 +28,6 @@
>  #include <media/v4l2-mem2mem.h>
> =20
>  #include "sunxi_cedrus_common.h"
> -#include "sunxi_cedrus_mpeg2.h"
>  #include "sunxi_cedrus_dec.h"
>  #include "sunxi_cedrus_hw.h"
> =20
> @@ -414,6 +413,21 @@ static int sunxi_cedrus_buf_prepare(struct vb2_buffe=
r *vb)
>  	return 0;
>  }
> =20
> +static int sunxi_cedrus_start_streaming(struct vb2_queue *q, unsigned in=
t count)
> +{
> +	struct sunxi_cedrus_ctx *ctx =3D vb2_get_drv_priv(q);
> +
> +	switch (ctx->vpu_src_fmt->fourcc) {
> +	case V4L2_PIX_FMT_MPEG2_FRAME:
> +		ctx->current_codec =3D SUNXI_CEDRUS_CODEC_MPEG2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static void sunxi_cedrus_stop_streaming(struct vb2_queue *q)
>  {
>  	struct sunxi_cedrus_ctx *ctx =3D vb2_get_drv_priv(q);
> @@ -462,6 +476,7 @@ static struct vb2_ops sunxi_cedrus_qops =3D {
>  	.buf_cleanup		=3D sunxi_cedrus_buf_cleanup,
>  	.buf_queue		=3D sunxi_cedrus_buf_queue,
>  	.buf_request_complete	=3D sunxi_cedrus_buf_request_complete,
> +	.start_streaming	=3D sunxi_cedrus_start_streaming,
>  	.stop_streaming		=3D sunxi_cedrus_stop_streaming,
>  	.wait_prepare		=3D vb2_ops_wait_prepare,
>  	.wait_finish		=3D vb2_ops_wait_finish,
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-6KNc3m/0MdpjtCFVHVXX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlsrdMIACgkQ3cLmz3+f
v9EUpwf8DbkpESzqfpCMqWGZPq5WV0aMEFU7tQ6wqFGVxwTWzt4iqNj5//vUhvP8
siezcg0A3HWxJ6WawOqoqWn7QzwBF9aE9lZsLOTrmUdHmYJPRMLRGDZ0Nn9zCXdy
dfjxgh9a6rnUAZAg5AvI6BsPhrPDH2o4X759/u02Z6DIR6ZBN4PlyBOsUhzYpf9l
/Sh1m233O8XLzNyiMVF+ANQL1LWr8dmkwrIXzTmknXnhm+/tQkMSPJ8zM7FBH9xU
RCr9xcJhZ6H+jvhyAQzbRiH9gFrRxyv31VXENCJIaRpf+lHnlxlSfOW0q96AV/pu
J0pA+EU6lC1T46+T8JNrrPeTKDXgng==
=BxNG
-----END PGP SIGNATURE-----

--=-6KNc3m/0MdpjtCFVHVXX--
