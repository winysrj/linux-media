Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:56982 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933262AbeFUPfG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 11:35:06 -0400
Message-ID: <a2e1e0a85e0cd650d27eb02dc58d438d6a750929.camel@bootlin.com>
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
Date: Thu, 21 Jun 2018 17:35:03 +0200
In-Reply-To: <20180613140714.1686-8-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-8-maxime.ripard@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-CZTYWBu0xl+VuYEU4hti"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-CZTYWBu0xl+VuYEU4hti
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

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

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
> -
>  	ctx =3D v4l2_m2m_get_curr_priv(dev->m2m_dev);
>  	if (!ctx) {
>  		pr_err("Instance released before the end of transaction\n");
>  		spin_unlock_irqrestore(&dev->irq_lock, flags);
> =20
> -		return IRQ_HANDLED;
> +		return IRQ_NONE;
>  	}
> =20
> +	status =3D dev->dec_ops[ctx->current_codec]->irq_status(ctx);
> +	if (status =3D=3D SUNXI_CEDRUS_IRQ_NONE) {
> +		spin_unlock_irqrestore(&dev->irq_lock, flags);
> +		return IRQ_NONE;
> +	}
> +
> +	dev->dec_ops[ctx->current_codec]->irq_disable(ctx);
> +	dev->dec_ops[ctx->current_codec]->irq_clear(ctx);
> +
>  	src_vb =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
>  	dst_vb =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> =20
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c b/d=
rivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> index e25075bb5779..51fa0c0f9bf2 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> @@ -52,6 +52,36 @@ static const u8 mpeg_default_non_intra_quant[64] =3D {
> =20
>  #define m_niq(i) ((i << 8) | mpeg_default_non_intra_quant[i])
> =20
> +static enum sunxi_cedrus_irq_status
> +sunxi_cedrus_mpeg2_irq_status(struct sunxi_cedrus_ctx *ctx)
> +{
> +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> +	u32 reg =3D sunxi_cedrus_read(dev, VE_MPEG_STATUS) & 0x7;
> +
> +	if (!reg)
> +		return SUNXI_CEDRUS_IRQ_NONE;
> +
> +	if (reg & (BIT(1) | BIT(2)))
> +		return SUNXI_CEDRUS_IRQ_ERROR;
> +
> +	return SUNXI_CEDRUS_IRQ_OK;
> +}
> +
> +static void sunxi_cedrus_mpeg2_irq_clear(struct sunxi_cedrus_ctx *ctx)
> +{
> +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> +
> +	sunxi_cedrus_write(dev, GENMASK(2, 0), VE_MPEG_STATUS);
> +}
> +
> +static void sunxi_cedrus_mpeg2_irq_disable(struct sunxi_cedrus_ctx *ctx)
> +{
> +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> +	u32 reg =3D sunxi_cedrus_read(dev, VE_MPEG_CTRL) & ~BIT(3);
> +
> +	sunxi_cedrus_write(dev, reg, VE_MPEG_CTRL);
> +}
> +
>  static void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
>  				     struct sunxi_cedrus_run *run)
>  {
> @@ -156,6 +186,9 @@ static void sunxi_cedrus_mpeg2_trigger(struct sunxi_c=
edrus_ctx *ctx)
>  }
> =20
>  struct sunxi_cedrus_dec_ops sunxi_cedrus_dec_ops_mpeg2 =3D {
> +	.irq_clear	=3D sunxi_cedrus_mpeg2_irq_clear,
> +	.irq_disable	=3D sunxi_cedrus_mpeg2_irq_disable,
> +	.irq_status	=3D sunxi_cedrus_mpeg2_irq_status,
>  	.setup		=3D sunxi_cedrus_mpeg2_setup,
>  	.trigger	=3D sunxi_cedrus_mpeg2_trigger,
>  };
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-CZTYWBu0xl+VuYEU4hti
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlsrxacACgkQ3cLmz3+f
v9GSeQf/bWMUdojpRZ0kiiqT7ZwylIwLahgsrAq4r1GTrtcJlJPsE9Dk2BN4Zu2v
slOk4HcQkq7mj8SVoZhV1OLWJt6ldCJRblCB4h29RWmZ51gIb574KL+3no1w/1ia
n+b91Cvjy4JMLWv492TgKoMD4A7MxlqnROgpZibi6/ynqOU/epD4aapX5eC2R9jD
XeC1rSfCTqOghFEXrqI7Db7/0mTKt2szwasVjwOMo8Ap7KoZa0FCoy/Y6d/DzJGd
Y3PMX8yvPdeV5tzeZhfBYIdUKl+gtRyxTsbSlhyHeyX5dlz3NULXolnu/Szss2cO
HqLZE2QvgYJQj9EluoRxJNkCEAWWKg==
=lRqs
-----END PGP SIGNATURE-----

--=-CZTYWBu0xl+VuYEU4hti--
