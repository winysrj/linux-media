Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:59485 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752338AbeFYPuL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 11:50:11 -0400
Message-ID: <03f66b80b1a60c4fe62822b08eb5d97c0539aac0.camel@bootlin.com>
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
Date: Mon, 25 Jun 2018 17:49:58 +0200
In-Reply-To: <d8e471608643a014d0961c82256753e5fd0c5060.camel@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-8-maxime.ripard@bootlin.com>
         <d8e471608643a014d0961c82256753e5fd0c5060.camel@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-S/93xppYbRSGq2ywkVtP"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-S/93xppYbRSGq2ywkVtP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-06-25 at 17:38 +0200, Paul Kocialkowski wrote:
> Hi,
>=20
> On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > The IRQ handler up until now was hardcoding the use of the MPEG engine =
to
> > read the interrupt status, clear it and disable the interrupts.
> >=20
> > Obviously, that won't work really well with the introduction of new cod=
ecs
> > that use a separate engine with a separate register set.
> >=20
> > In order to make this more future proof, introduce new decodec operatio=
ns
> > to deal with the interrupt management. The only one missing is the one =
to
> > enable the interrupts in the first place, but that's taken care of by t=
he
> > trigger hook for now.
>=20
> Here's another comment about an issue I just figured out.
>=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  .../sunxi/cedrus/sunxi_cedrus_common.h        |  9 +++++
> >  .../platform/sunxi/cedrus/sunxi_cedrus_hw.c   | 21 ++++++------
> >  .../sunxi/cedrus/sunxi_cedrus_mpeg2.c         | 33 +++++++++++++++++++
> >  3 files changed, 53 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h =
b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > index c2e2c92d103b..a2a507eb9fc9 100644
> > --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > @@ -108,7 +108,16 @@ struct sunxi_cedrus_buffer *vb2_to_cedrus_buffer(c=
onst struct vb2_buffer *p)
> >  	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
> >  }
> > =20
> > +enum sunxi_cedrus_irq_status {
> > +	SUNXI_CEDRUS_IRQ_NONE,
> > +	SUNXI_CEDRUS_IRQ_ERROR,
> > +	SUNXI_CEDRUS_IRQ_OK,
> > +};
> > +
> >  struct sunxi_cedrus_dec_ops {
> > +	void (*irq_clear)(struct sunxi_cedrus_ctx *ctx);
> > +	void (*irq_disable)(struct sunxi_cedrus_ctx *ctx);
> > +	enum sunxi_cedrus_irq_status (*irq_status)(struct sunxi_cedrus_ctx *c=
tx);
> >  	void (*setup)(struct sunxi_cedrus_ctx *ctx,
> >  		      struct sunxi_cedrus_run *run);
> >  	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c b/dr=
ivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> > index bb46a01214e0..6b97cbd2834e 100644
> > --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> > @@ -77,27 +77,28 @@ static irqreturn_t sunxi_cedrus_ve_irq(int irq, voi=
d *dev_id)
> >  	struct sunxi_cedrus_ctx *ctx;
> >  	struct sunxi_cedrus_buffer *src_buffer, *dst_buffer;
> >  	struct vb2_v4l2_buffer *src_vb, *dst_vb;
> > +	enum sunxi_cedrus_irq_status status;
> >  	unsigned long flags;
> > -	unsigned int value, status;
> > =20
> >  	spin_lock_irqsave(&dev->irq_lock, flags);
> > =20
> > -	/* Disable MPEG interrupts and stop the MPEG engine */
> > -	value =3D sunxi_cedrus_read(dev, VE_MPEG_CTRL);
> > -	sunxi_cedrus_write(dev, value & (~0xf), VE_MPEG_CTRL);
> > -
> > -	status =3D sunxi_cedrus_read(dev, VE_MPEG_STATUS);
> > -	sunxi_cedrus_write(dev, 0x0000c00f, VE_MPEG_STATUS);
> > -	sunxi_cedrus_engine_disable(dev);
>=20
> This call was dropped from the code reorganization. What it intentional?
>=20
> IMO, it should be brought back to the irq_disable ops for MPEG2 (and the
> same probably applies to H264).

Actually, this doesn't seem like the right place to put it.

Looking at the sunxi_engine_enable function, explicitly passing the
codec as an argument and calling that function from each codec's code
feels strange.

We should probably break down these functions
(sunxi_engine_enable/sunxi_engine_disable) into codec ops. The
start/stop couple seems like a good fit, but it brings up the following
question: do we want to disable the engine between each frame or not?

I really don't know how significant the power saving benefits are and
what downsides there might be.

What do you think?

>  Things still seem to work without it,
> though, but there might be a difference in terms of standby VPU power
> consumption.
>=20
> Cheers,
>=20
> Paul
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-S/93xppYbRSGq2ywkVtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlsxDyYACgkQ3cLmz3+f
v9EZIgf+KKr9aOA1Xzp33X+1o0igIfsRgBxlH/SisTL5M8kutZpvTQOIqsobpEd0
0Ji6yXQT1/oiFMJ2NAhcxEc2UGLzPLl67GrqP2cbTsPYfU6d03Br2ZSpvwoEErDW
Jfy8svJqsPpuJWNMzcj+wbwd5e5IkiX/8QcMMlMvZ29AToSfxczUF9snu3CiYlvY
PUXd/q/lkGqAqCpQ4G349m/ivc0papnMt3OO+GSUg0oDlLdQpiqVJa7qn56o08MK
tQeI0kLR4zpxcFFZyHlFCwNby7z1Uvs/3hqNEf5XwKRSP93sQS9/8gW4ISr3a5Yg
6VtX3iT7OJjFKl2CAIBZbntCskvYDA==
=AYNb
-----END PGP SIGNATURE-----

--=-S/93xppYbRSGq2ywkVtP--
