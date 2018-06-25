Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:33045 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753170AbeFYQPe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 12:15:34 -0400
Date: Mon, 25 Jun 2018 18:15:22 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH 7/9] media: cedrus: Move IRQ maintainance to
 cedrus_dec_ops
Message-ID: <20180625161522.mwl3bhiuly4bkdsh@flea>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-8-maxime.ripard@bootlin.com>
 <a2e1e0a85e0cd650d27eb02dc58d438d6a750929.camel@bootlin.com>
 <b222fae80b1b212fdc5171a39b9a761527931eb0.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qyx4ykt4a7rmjdmf"
Content-Disposition: inline
In-Reply-To: <b222fae80b1b212fdc5171a39b9a761527931eb0.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qyx4ykt4a7rmjdmf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 25, 2018 at 04:18:51PM +0200, Paul Kocialkowski wrote:
> Hi,
>=20
> On Thu, 2018-06-21 at 17:35 +0200, Paul Kocialkowski wrote:
> > Hi,
> >=20
> > On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > > The IRQ handler up until now was hardcoding the use of the MPEG engin=
e to
> > > read the interrupt status, clear it and disable the interrupts.
> > >=20
> > > Obviously, that won't work really well with the introduction of new c=
odecs
> > > that use a separate engine with a separate register set.
> > >=20
> > > In order to make this more future proof, introduce new decodec operat=
ions
> > > to deal with the interrupt management. The only one missing is the on=
e to
> > > enable the interrupts in the first place, but that's taken care of by=
 the
> > > trigger hook for now.
> >=20
> > Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>=20
> Scratch that for now, I just thought of something here (see below).
>=20
> > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > ---
> > >  .../sunxi/cedrus/sunxi_cedrus_common.h        |  9 +++++
> > >  .../platform/sunxi/cedrus/sunxi_cedrus_hw.c   | 21 ++++++------
> > >  .../sunxi/cedrus/sunxi_cedrus_mpeg2.c         | 33 +++++++++++++++++=
++
> > >  3 files changed, 53 insertions(+), 10 deletions(-)
> > >=20
> > > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.=
h b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > > index c2e2c92d103b..a2a507eb9fc9 100644
> > > --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > > @@ -108,7 +108,16 @@ struct sunxi_cedrus_buffer *vb2_to_cedrus_buffer=
(const struct vb2_buffer *p)
> > >  	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
> > >  }
> > > =20
> > > +enum sunxi_cedrus_irq_status {
> > > +	SUNXI_CEDRUS_IRQ_NONE,
> > > +	SUNXI_CEDRUS_IRQ_ERROR,
> > > +	SUNXI_CEDRUS_IRQ_OK,
> > > +};
> > > +
> > >  struct sunxi_cedrus_dec_ops {
> > > +	void (*irq_clear)(struct sunxi_cedrus_ctx *ctx);
> > > +	void (*irq_disable)(struct sunxi_cedrus_ctx *ctx);
> > > +	enum sunxi_cedrus_irq_status (*irq_status)(struct sunxi_cedrus_ctx =
*ctx);
> > >  	void (*setup)(struct sunxi_cedrus_ctx *ctx,
> > >  		      struct sunxi_cedrus_run *run);
> > >  	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
> > > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c b/=
drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> > > index bb46a01214e0..6b97cbd2834e 100644
> > > --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> > > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> > > @@ -77,27 +77,28 @@ static irqreturn_t sunxi_cedrus_ve_irq(int irq, v=
oid *dev_id)
> > >  	struct sunxi_cedrus_ctx *ctx;
> > >  	struct sunxi_cedrus_buffer *src_buffer, *dst_buffer;
> > >  	struct vb2_v4l2_buffer *src_vb, *dst_vb;
> > > +	enum sunxi_cedrus_irq_status status;
> > >  	unsigned long flags;
> > > -	unsigned int value, status;
> > > =20
> > >  	spin_lock_irqsave(&dev->irq_lock, flags);
> > > =20
> > > -	/* Disable MPEG interrupts and stop the MPEG engine */
> > > -	value =3D sunxi_cedrus_read(dev, VE_MPEG_CTRL);
> > > -	sunxi_cedrus_write(dev, value & (~0xf), VE_MPEG_CTRL);
> > > -
> > > -	status =3D sunxi_cedrus_read(dev, VE_MPEG_STATUS);
> > > -	sunxi_cedrus_write(dev, 0x0000c00f, VE_MPEG_STATUS);
> > > -	sunxi_cedrus_engine_disable(dev);
> > > -
> > >  	ctx =3D v4l2_m2m_get_curr_priv(dev->m2m_dev);
> > >  	if (!ctx) {
> > >  		pr_err("Instance released before the end of transaction\n");
> > >  		spin_unlock_irqrestore(&dev->irq_lock, flags);
> > > =20
> > > -		return IRQ_HANDLED;
> > > +		return IRQ_NONE;
> > >  	}
> > > =20
> > > +	status =3D dev->dec_ops[ctx->current_codec]->irq_status(ctx);
> > > +	if (status =3D=3D SUNXI_CEDRUS_IRQ_NONE) {
> > > +		spin_unlock_irqrestore(&dev->irq_lock, flags);
> > > +		return IRQ_NONE;
> > > +	}
> > > +
> > > +	dev->dec_ops[ctx->current_codec]->irq_disable(ctx);
> > > +	dev->dec_ops[ctx->current_codec]->irq_clear(ctx);
> > > +
> > >  	src_vb =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > >  	dst_vb =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
>=20
> Later in that file, there is still some checking that the first bit of
> status is set:
>=20
> 	/* First bit of MPEG_STATUS indicates success. */
> 	if (ctx->job_abort || !(status & 0x01))
>=20
> So !(status & 0x01) must be replaced with status !=3D CEDRUS_IRQ_OK.
>=20
> It seems that was working "by accident", with CEDRUS_IRQ_OK probably
> being set by the compiler to 0x03.

Yeah, I noticed this already and this was fixed for the v2 :)

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--qyx4ykt4a7rmjdmf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsxFRkACgkQ0rTAlCFN
r3SrMw/9HmqawhTZFcHTcROC+crAmaUslZ8EeAaPttZqq8nYOralYl13u+igSKED
O8Vcp2+wil1g1SlepwQY8i+ddUdmOjrweO6WVyMD95L7h5NpwCFdf0ylCc/0GtUO
05to9TIjfaOI7RBwja9hp7DUqu4rZSy9r65Jo02SuNpKVTEAxgZrtsdwlLekYggn
kWubslA9Rb340V4LD6IN0bUMvMKLtoro5vOjchcoVR8iDfdX8lq49dAKaI/kihgY
iJbyDBRUtws4petqYLQ7oEurT5L0a0EfP1dXaevpo+zIhGAuFdEqFHYGvycpeB9S
O9XiG3qUcZD70mq+I6OZ1B+PqFX9gL56H7sl+Z7rThWUG3c7FEtKQ3oN1LjmFPk9
MMNTGhy2DsqvlaZCr5eX6P6B6Sl2HxLtrji+GchOX7y7jcswCH1G1XqsQQxISCwB
zGGj3dcHh8BifTn5+bWVE0asSLgYZFIlv41k8pbO7Rk2kELtj5tFewyVBWi1wUcA
HAdHFGCml9EctSZe0SWAUZlkKPd4UI6mNPdsg5bnzO0tmQzB0RYBgVj+Zf+6ejfW
v8St2CCkLdAFr9EzA/ft3QUWqbowimf+m69KCAJX14tBvlw006MvWRg8fDDcHJsL
r7vqoelpJxxdUe+GeO9MTf2O5CbKOu65z9bv5jgCslrwPuMdtXg=
=IHma
-----END PGP SIGNATURE-----

--qyx4ykt4a7rmjdmf--
