Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:38916 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964908AbeFYTBD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 15:01:03 -0400
Date: Mon, 25 Jun 2018 21:01:00 +0200
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
Message-ID: <20180625190100.rlqbcafhktypotgj@flea>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-8-maxime.ripard@bootlin.com>
 <d8e471608643a014d0961c82256753e5fd0c5060.camel@bootlin.com>
 <03f66b80b1a60c4fe62822b08eb5d97c0539aac0.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="korxkvl2ni3lg3ka"
Content-Disposition: inline
In-Reply-To: <03f66b80b1a60c4fe62822b08eb5d97c0539aac0.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--korxkvl2ni3lg3ka
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 25, 2018 at 05:49:58PM +0200, Paul Kocialkowski wrote:
> On Mon, 2018-06-25 at 17:38 +0200, Paul Kocialkowski wrote:
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
> > Here's another comment about an issue I just figured out.
> >=20
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
> >=20
> > This call was dropped from the code reorganization. What it intentional?
> >=20
> > IMO, it should be brought back to the irq_disable ops for MPEG2 (and the
> > same probably applies to H264).
>=20
> Actually, this doesn't seem like the right place to put it.
>=20
> Looking at the sunxi_engine_enable function, explicitly passing the
> codec as an argument and calling that function from each codec's code
> feels strange.
>=20
> We should probably break down these functions
> (sunxi_engine_enable/sunxi_engine_disable) into codec ops. The
> start/stop couple seems like a good fit, but it brings up the following
> question: do we want to disable the engine between each frame or not?
>=20
> I really don't know how significant the power saving benefits are and
> what downsides there might be.
>=20
> What do you think?

If we don't need to disable it between each frames, then let's keep it
enabled.

Without any number, and considering the current state of power
management (which is inexistent on this driver, and close to for the
whole platform), wasting a bit of power if we do isn't really a big
deal.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--korxkvl2ni3lg3ka
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsxO+sACgkQ0rTAlCFN
r3Qg1w/+N913dfkZ13U/wsthm2EbOh2cvc6XHCyyBuXu9tXGFs/dGBD+ZfBAkqFJ
U0xqV3+b8QM/CDSessCouy7A3vDJOX1mTk6/KuygmppUpZ+MSzOVie9izTaZm1Hb
qgdMWsYO7F6j6HjS9E8cz0Cf+IE324a0//23kx9QycUyKEAKGGzQWjIfuHf/WsMc
10EFXGRE5WXHrPxvwDyFxRgFveG2aFoVa8aS2w4CrhQrUn+cvpIcBmQgFcrw+fbO
YPV90ZOK95U24htjliwalwB/OhNu7lfAjz6HbFbbv9uF6NAaFzhP0VolpvAhgCOu
CiXJ9SUHIJCp5FIPHbBO5OTkbo65O09gBKGndT5wZbm2YzPYKrpsmlyuORoejhMY
zvwGFmB0/4noFQYN22yJrLql+fDXxFLjXtxgiAqLguYXciY8rc6QV/c6NAWQCotH
9TcYCW1mGEz3th6VNZt2sYRxMpWhZmNkNbjdPRAqDgAWYkfxfHG0sn4rmQPRVuyQ
LdZRiw2Mhkt2PBCOL57pEufY62KbSS879UOfcrI/MzAryU239JoxfP8pPBEq9S0W
RGkNxVECK4pJDRamM0FhLgZSkCRKaNbZbwbBjjtRs96uyjoiqFWk5qZy7VrT6oYF
BewN1Ww/TLl9mbrENOWhf6DO2H3MqkO22WVwaAb+4yzzNaK/3Ak=
=0Y6Z
-----END PGP SIGNATURE-----

--korxkvl2ni3lg3ka--
