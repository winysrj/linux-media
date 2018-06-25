Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58526 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752224AbeFYPiM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 11:38:12 -0400
Message-ID: <d8e471608643a014d0961c82256753e5fd0c5060.camel@bootlin.com>
Subject: Re: [PATCH 7/9] media: cedrus: Move IRQ maintainance to
 cedrus_dec_ops
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
Date: Mon, 25 Jun 2018 17:38:10 +0200
In-Reply-To: <20180613140714.1686-8-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-8-maxime.ripard@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-IEAekvlujL4VhhCQES3c"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-IEAekvlujL4VhhCQES3c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> The IRQ handler up until now was hardcoding the use of the MPEG engine to
> read the interrupt status, clear it and disable the interrupts.
>=20
> Obviously, that won't work really well with the introduction of new codec=
s
> that use a separate engine with a separate register set.
>=20
> In order to make this more future proof, introduce new decodec operations
> to deal with the interrupt management. The only one missing is the one to
> enable the interrupts in the first place, but that's taken care of by the
> trigger hook for now.

Here's another comment about an issue I just figured out.

> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  .../sunxi/cedrus/sunxi_cedrus_common.h        |  9 +++++
>  .../platform/sunxi/cedrus/sunxi_cedrus_hw.c   | 21 ++++++------
>  .../sunxi/cedrus/sunxi_cedrus_mpeg2.c         | 33 +++++++++++++++++++
>  3 files changed, 53 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h b/=
drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> index c2e2c92d103b..a2a507eb9fc9 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> @@ -108,7 +108,16 @@ struct sunxi_cedrus_buffer *vb2_to_cedrus_buffer(con=
st struct vb2_buffer *p)
>  	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
>  }
> =20
> +enum sunxi_cedrus_irq_status {
> +	SUNXI_CEDRUS_IRQ_NONE,
> +	SUNXI_CEDRUS_IRQ_ERROR,
> +	SUNXI_CEDRUS_IRQ_OK,
> +};
> +
>  struct sunxi_cedrus_dec_ops {
> +	void (*irq_clear)(struct sunxi_cedrus_ctx *ctx);
> +	void (*irq_disable)(struct sunxi_cedrus_ctx *ctx);
> +	enum sunxi_cedrus_irq_status (*irq_status)(struct sunxi_cedrus_ctx *ctx=
);
>  	void (*setup)(struct sunxi_cedrus_ctx *ctx,
>  		      struct sunxi_cedrus_run *run);
>  	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c b/driv=
ers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> index bb46a01214e0..6b97cbd2834e 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> @@ -77,27 +77,28 @@ static irqreturn_t sunxi_cedrus_ve_irq(int irq, void =
*dev_id)
>  	struct sunxi_cedrus_ctx *ctx;
>  	struct sunxi_cedrus_buffer *src_buffer, *dst_buffer;
>  	struct vb2_v4l2_buffer *src_vb, *dst_vb;
> +	enum sunxi_cedrus_irq_status status;
>  	unsigned long flags;
> -	unsigned int value, status;
> =20
>  	spin_lock_irqsave(&dev->irq_lock, flags);
> =20
> -	/* Disable MPEG interrupts and stop the MPEG engine */
> -	value =3D sunxi_cedrus_read(dev, VE_MPEG_CTRL);
> -	sunxi_cedrus_write(dev, value & (~0xf), VE_MPEG_CTRL);
> -
> -	status =3D sunxi_cedrus_read(dev, VE_MPEG_STATUS);
> -	sunxi_cedrus_write(dev, 0x0000c00f, VE_MPEG_STATUS);
> -	sunxi_cedrus_engine_disable(dev);

This call was dropped from the code reorganization. What it intentional?

IMO, it should be brought back to the irq_disable ops for MPEG2 (and the
same probably applies to H264). Things still seem to work without it,
though, but there might be a difference in terms of standby VPU power
consumption.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-IEAekvlujL4VhhCQES3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlsxDGIACgkQ3cLmz3+f
v9HJ1wf/e87b7B3R3TQcw7qgwoyI20Zd9HMG+A4Ow7MFZnuYfnPT+Y6odRkUn1Tu
XL/Cg4KAFBLuIq/qQnFvIJCW+MErhX8iW/KlW23xZzzhPxzxRDR//j2iEru8Rj3H
l/XqxhoaMUpGj29QEaHAlH2Fjdxj9xxYcq6dzUPEhRmNVAdVeUuIXtmAlOzsIFbi
jP6U3cnOcW4MX9QP6NN+Q3Aoh5FlwHEHJbRTrSOMb5vgP464m8Rjv14o+SiS8lke
aedm+Hyi1bCH1o8/mHObDA55ByoN2EYIgY0gcJu5YuOcR0IJis5akZuSMukq+Z1a
fgTM04NVSRLoMEgcdTcNCFtdQpBnLg==
=kGSx
-----END PGP SIGNATURE-----

--=-IEAekvlujL4VhhCQES3c--
