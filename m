Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57201 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933188AbeFUPiZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 11:38:25 -0400
Message-ID: <f37f23580c92728bbcd5bfe3fff506b5bb2bdfd0.camel@bootlin.com>
Subject: Re: [PATCH 8/9] media: cedrus: Add start and stop decoder operations
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
Date: Thu, 21 Jun 2018 17:38:23 +0200
In-Reply-To: <20180613140714.1686-9-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-9-maxime.ripard@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ni+hXRL3y8E4UMCwvjZ0"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ni+hXRL3y8E4UMCwvjZ0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> Some codec needs to perform some additional task when a decoding is start=
ed
> and stopped, and not only at every frame.
>=20
> For example, the H264 decoding support needs to allocate buffers that wil=
l
> be used in the decoding process, but do not need to change over time, or =
at
> each frame.
>=20
> In order to allow that for codecs, introduce a start and stop hook that
> will be called if present at start_streaming and stop_streaming time.
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  .../platform/sunxi/cedrus/sunxi_cedrus_common.h    |  2 ++
>  .../platform/sunxi/cedrus/sunxi_cedrus_video.c     | 14 +++++++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h b/=
drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> index a2a507eb9fc9..20c78ec1f037 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> @@ -120,6 +120,8 @@ struct sunxi_cedrus_dec_ops {
>  	enum sunxi_cedrus_irq_status (*irq_status)(struct sunxi_cedrus_ctx *ctx=
);
>  	void (*setup)(struct sunxi_cedrus_ctx *ctx,
>  		      struct sunxi_cedrus_run *run);
> +	int (*start)(struct sunxi_cedrus_ctx *ctx);
> +	void (*stop)(struct sunxi_cedrus_ctx *ctx);
>  	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
>  };
> =20
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c b/d=
rivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> index fb7b081a5bb7..d93461178857 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> @@ -416,6 +416,8 @@ static int sunxi_cedrus_buf_prepare(struct vb2_buffer=
 *vb)
>  static int sunxi_cedrus_start_streaming(struct vb2_queue *q, unsigned in=
t count)
>  {
>  	struct sunxi_cedrus_ctx *ctx =3D vb2_get_drv_priv(q);
> +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> +	int ret =3D 0;
> =20
>  	switch (ctx->vpu_src_fmt->fourcc) {
>  	case V4L2_PIX_FMT_MPEG2_FRAME:
> @@ -425,16 +427,26 @@ static int sunxi_cedrus_start_streaming(struct vb2_=
queue *q, unsigned int count)
>  		return -EINVAL;
>  	}
> =20
> -	return 0;
> +	if (V4L2_TYPE_IS_OUTPUT(q->type) &&

I suppose this check was put in place to ensure that ->start is only
called once, but what if start_streaming is called multiple times on
output? Am I totally unsure about whether the API guarantees that we
only get one start_streaming call per buffer queue, regardless of how
many userspace issues.

If we don't have such a guarantee, we probably need an internal
mechanism to avoid having ->start called more than once.

> +	    dev->dec_ops[ctx->current_codec]->start)
> +		ret =3D dev->dec_ops[ctx->current_codec]->start(ctx);
> +
> +	return ret;
>  }
> =20
>  static void sunxi_cedrus_stop_streaming(struct vb2_queue *q)
>  {
>  	struct sunxi_cedrus_ctx *ctx =3D vb2_get_drv_priv(q);
> +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
>  	struct vb2_v4l2_buffer *vbuf;
>  	unsigned long flags;
> =20
>  	flush_scheduled_work();
> +
> +	if (V4L2_TYPE_IS_OUTPUT(q->type) &&

Ditto.

Cheers,

Paul

> +	    dev->dec_ops[ctx->current_codec]->stop)
> +		dev->dec_ops[ctx->current_codec]->stop(ctx);
> +
>  	for (;;) {
>  		spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> =20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-ni+hXRL3y8E4UMCwvjZ0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlsrxm8ACgkQ3cLmz3+f
v9G/PAf/TkeDe68tjgtNF820SRelVCY6scJMhqkEY8dsvauKOhKNE9y4yRrRoWFS
INc3FukkeeIPcwLG6Q+H3T37p93+ml8EXeEjpJIMvvPP+hWRiWJywSoLw4CeQW/I
ChxY5q/h/XVHydQoUhWHK+905iJCA5d6Vub9vwjNaY5NdtGOM6YFcyAr+pcY/afK
HTRYtpnkCgX75jGvlbMcrT6Ncjda5DXXsNMctbroH3YGZdiBry+JAIR2RRVQePl+
4oAf1eU1MlKuxGkoKzeHFL9MjiA2UQxirKtRV8doLzlxUyBtuy7HQ3IC7vL9JONg
VIS48xrU5XGgkbsj3sw1ddW96t+FCw==
=Uu7e
-----END PGP SIGNATURE-----

--=-ni+hXRL3y8E4UMCwvjZ0--
