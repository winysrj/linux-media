Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:47746 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932482AbeFUJNb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 05:13:31 -0400
Message-ID: <18ffd09bf91908886aebbad127e612775b7f0bf8.camel@bootlin.com>
Subject: Re: [PATCH 3/9] media: cedrus: Add a macro to check for the
 validity of a control
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
Date: Thu, 21 Jun 2018 11:13:19 +0200
In-Reply-To: <20180613140714.1686-4-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-4-maxime.ripard@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-VQE9UU1GTYaO8ZSYHoUI"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-VQE9UU1GTYaO8ZSYHoUI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> During our frame decoding setup, we need to check a number of controls to
> make sure that they are properly filled before trying to access them.
>=20
> It's not too bad with MPEG2 since there's just a single one, but with the
> upcoming increase of codecs, and the integration of more complex codecs,
> this logic will be duplicated a significant number of times. H264 for
> example uses 4 different controls.
>=20
> Add a macro that expands to the proper check in order to reduce the
> duplication.
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  .../platform/sunxi/cedrus/sunxi_cedrus_dec.c     | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c b/dri=
vers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
> index 8c92af34ebeb..c19acf9626c4 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
> @@ -110,15 +110,16 @@ void sunxi_cedrus_device_run(void *priv)
> =20
>  	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> =20
> +#define CHECK_CONTROL(ctx, ctrl)					\
> +	if (!ctx->ctrls[(ctrl)]) {					\

Although this was not introduced in this patch, I believe this approach
won't work since ctx->ctrls[i] is a pointer returned from
v4l2_ctrl_new_custom(hdl, &cfg, NULL), which will always be non-null
after calling cedrus_init_ctrls.

Perhaps checking ctx->ctrls[i].p_cur.p would be the right thing to
check, but I'm unsure about that.

> +		v4l2_err(&(ctx)->dev->v4l2_dev, "Invalid " #ctrl " control\n"); \
> +		(ctx)->job_abort =3D 1;					\
> +		goto unlock_complete;					\
> +	}
> +
>  	switch (ctx->vpu_src_fmt->fourcc) {
>  	case V4L2_PIX_FMT_MPEG2_FRAME:
> -		if (!ctx->ctrls[SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR]) {
> -			v4l2_err(&ctx->dev->v4l2_dev,
> -				 "Invalid MPEG2 frame header control\n");
> -			ctx->job_abort =3D 1;
> -			goto unlock_complete;
> -		}
> -
> +		CHECK_CONTROL(ctx, SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR);
>  		run.mpeg2.hdr =3D get_ctrl_ptr(ctx, SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_=
HDR);
>  		sunxi_cedrus_mpeg2_setup(ctx, &run);
> =20
> @@ -128,6 +129,7 @@ void sunxi_cedrus_device_run(void *priv)
>  	default:
>  		ctx->job_abort =3D 1;
>  	}

Maybe add a newline here?

Cheers,

Paul

> +#undef CHECK_CONTROL
> =20
>  unlock_complete:
>  	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-VQE9UU1GTYaO8ZSYHoUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlsrbC8ACgkQ3cLmz3+f
v9FWTwgAlcGN1gPoncx1y38kxL7Z7K0/XVu2lLjn2+n2fSHP6WJj+QtBUuQEfa1y
IX+/UBeXFrZvx49GH9A9fmXsbGRME56ocRDLR4koNopdaQrWdbgNx6NACEUgEK3A
zWimSjS18/qJj6js1OyRVsnZpU7hfuL7yfTt5e9a03ybYPQ7BtVfJsh0MXSxyDur
z6evE9taF3d37tMkCuf81y7l5qlvbKu1menzn9CT9+M5HbUDysdpDcuMOBdnmLXd
+zICme6Abs7UZfPE6sEMSBPkAUwpG4/M8LrfOF7lUGOZ3RZ9K9XwcUhQeeMfjeXH
BHvWvyDJEzmMAtszIlu6eVArR+KsgA==
=uWyX
-----END PGP SIGNATURE-----

--=-VQE9UU1GTYaO8ZSYHoUI--
