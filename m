Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49473 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964929AbeF0R6k (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 13:58:40 -0400
Date: Wed, 27 Jun 2018 19:58:28 +0200
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
Message-ID: <20180627175828.hvos5hxdk2cyvare@flea>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-8-maxime.ripard@bootlin.com>
 <d8e471608643a014d0961c82256753e5fd0c5060.camel@bootlin.com>
 <03f66b80b1a60c4fe62822b08eb5d97c0539aac0.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pjsqvp4fbnbe7rps"
Content-Disposition: inline
In-Reply-To: <03f66b80b1a60c4fe62822b08eb5d97c0539aac0.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pjsqvp4fbnbe7rps
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

This isn't what this code is doing. You have three engines, each of
them implementing a different set of codec. The JPEG engine implements
MPEG1, MPEG2 and MPEG4, the H264 engine H264 and VP8, and the H265
H265 and VP9.

So there is no direct match between a codec and an engine.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--pjsqvp4fbnbe7rps
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsz0EMACgkQ0rTAlCFN
r3RioA/+P4ZrkoBcH4haeFThQubgzhv1kXRTrj1pcngGHFsL+7Ps1juTBYEp7JvS
SxSBrhEMO3+bu7xwUbN0ifzzqGnWJIqO/Ng9xEuC09JfXzEl9qwslb6IgWAynW6w
jlXNFJuhWXEdKlVu5vYsV9IzMhMi0Jy/Ta3F4QEPtv2n2kobClf26uqJJIk04XwH
MmDrU9tu90Hi6/zP+HHGjCxOnZnLdJ8O4w4iiq97wowOnIdthoDcUCyMljAHr6w4
UutL42+zgFQ3BuMFBVLDYTJyDyyk0XWYGrVjae/LbPYEo0DqjxLn8ngdgCMNHjdU
bYELVvJ6uz+iOM6vZ9h8f5o7zl+wBPEgM9fBMo/Ou/wj2+d5NaGkz59AMTHKyjTN
TJ4VfUl8FyKdYY7eOTtZk6eFqi8l3w5o3esW4bP9/yMpt3O4V6imNtDO7fIlpBey
82BZwnRb31FmIUzfXoJU7YH1TA+78AYgAf2sQWX7/JpFmQuhv375siC/B4gDG4Z3
vco5hFWSkVBMAySHTvJXIvphP+v3ynV/eV54JVVV/dvzQjU3sKocOwbI3YwgzJCN
KJIyeoeGzci+hwowUx9M8W8Cj27ggByn01AbbsSuje8bRwy4CvTd/fnZRM55mr9w
8LrHId7QwxRiBfuTbITHnqYgnthBw91B7c6x4rjccBccylI59bI=
=OtEw
-----END PGP SIGNATURE-----

--pjsqvp4fbnbe7rps--
