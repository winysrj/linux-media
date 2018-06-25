Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50586 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755345AbeFYNtA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 09:49:00 -0400
Message-ID: <0d20a3159ea710f47d1860a83b7c027116e8e97c.camel@bootlin.com>
Subject: Re: [PATCH 6/9] media: cedrus: Add ops structure
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date: Mon, 25 Jun 2018 15:48:48 +0200
In-Reply-To: <20180625132933.tzr36vsucqsq3mmb@flea>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-7-maxime.ripard@bootlin.com>
         <939381a854760b1d54984ae0f534ec03312ec8e0.camel@bootlin.com>
         <20180625132933.tzr36vsucqsq3mmb@flea>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0NIUE1z8vrsnfV1Gs03l"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-0NIUE1z8vrsnfV1Gs03l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-06-25 at 15:29 +0200, Maxime Ripard wrote:
> Hi!
>=20
> On Thu, Jun 21, 2018 at 11:49:54AM +0200, Paul Kocialkowski wrote:
> > Hi,
> >=20
> > On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > > In order to increase the number of codecs supported, we need to decou=
ple
> > > the MPEG2 only code that was there up until now and turn it into some=
thing
> > > a bit more generic.
> > >=20
> > > Do that by introducing an intermediate ops structure that would need =
to be
> > > filled by each supported codec. Start by implementing in that structu=
re the
> > > setup and trigger hooks that are currently the only functions being
> > > implemented by codecs support.
> > >=20
> > > To do so, we need to store the current codec in use, which we do at
> > > start_streaming time.
> >=20
> > With the comments below taken in account, this is:
> >=20
> > Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>=20
> Thanks!
>=20
> > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > ---
> > >  .../platform/sunxi/cedrus/sunxi_cedrus.c      |  2 ++
> > >  .../sunxi/cedrus/sunxi_cedrus_common.h        | 11 +++++++
> > >  .../platform/sunxi/cedrus/sunxi_cedrus_dec.c  | 10 +++---
> > >  .../sunxi/cedrus/sunxi_cedrus_mpeg2.c         | 11 +++++--
> > >  .../sunxi/cedrus/sunxi_cedrus_mpeg2.h         | 33 -----------------=
--
> > >  .../sunxi/cedrus/sunxi_cedrus_video.c         | 17 +++++++++-
> > >  6 files changed, 42 insertions(+), 42 deletions(-)
> > >  delete mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_=
mpeg2.h
> > >=20
> > > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c b/dri=
vers/media/platform/sunxi/cedrus/sunxi_cedrus.c
> > > index ccd41d9a3e41..bc80480f5dfd 100644
> > > --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
> > > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
> > > @@ -244,6 +244,8 @@ static int sunxi_cedrus_probe(struct platform_dev=
ice *pdev)
> > >  	if (ret)
> > >  		return ret;
> > > =20
> > > +	dev->dec_ops[SUNXI_CEDRUS_CODEC_MPEG2] =3D &sunxi_cedrus_dec_ops_mp=
eg2;
> > > +
> > >  	ret =3D v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> > >  	if (ret)
> > >  		goto unreg_media;
> > > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.=
h b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > > index a5f83c452006..c2e2c92d103b 100644
> > > --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > > @@ -75,6 +75,7 @@ struct sunxi_cedrus_ctx {
> > >  	struct v4l2_pix_format_mplane src_fmt;
> > >  	struct sunxi_cedrus_fmt *vpu_dst_fmt;
> > >  	struct v4l2_pix_format_mplane dst_fmt;
> > > +	enum sunxi_cedrus_codec current_codec;
> >=20
> > Nit: for consistency with the way things are named, "codec_current"
> > probably makes more sense.
>=20
> I'm not quite sure what you mean by consitency here. This structure
> has 5 other variables with two words: vpu_src_fmt, src_fmt,
> vpu_dst_fmt, dst_fmt and dst_bufs. codec_current would be going
> against the consistency of that structure.

Mhh, not sure what I meant after all regarding consistency. I was
thinking in terms of name/qualifier, but it's clear that the structure
for the names of already-existing elements has qualifiers first and name
at the end, so "curent_codec" indeed fits best.

Sorry for the noise!

> > IMO using the natural English order is fine for temporary variables, bu=
t
> >  less so for variables used in common parts like structures. This allow=
s
> > seeing "_" as a logical hierarchical delimiter that automatically makes
> > us end up with consistent prefixes that can easily be grepped for and
> > derived.
> >=20
> > But that's just my 2 cents, it's really not a big deal, especially in
> > this case!
> >=20
> > >  	struct v4l2_ctrl_handler hdl;
> > >  	struct v4l2_ctrl *ctrls[SUNXI_CEDRUS_CTRL_MAX];
> > > @@ -107,6 +108,14 @@ struct sunxi_cedrus_buffer *vb2_to_cedrus_buffer=
(const struct vb2_buffer *p)
> > >  	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
> > >  }
> > > =20
> > > +struct sunxi_cedrus_dec_ops {
> > > +	void (*setup)(struct sunxi_cedrus_ctx *ctx,
> > > +		      struct sunxi_cedrus_run *run);
> > > +	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
> >=20
> > By the way, are we sure that these functions won't ever fail?
> > I think this is the case for MPEG2 (there is virtually nothing to check
> > for errors) but perhaps it's different for H264.
>=20
> It won't fail either, and if we need to change it somewhere down the
> line, it's quite easy to do.

Right, let's keep it that way then.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-0NIUE1z8vrsnfV1Gs03l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlsw8sAACgkQ3cLmz3+f
v9FkwAf/fw1tjLwFGOghickXiQz7CRqbY7gepneYN3d5MLmEk0/SeK9bNpHW7oXE
aLJYa8YptZeuP00DzB59dNAgQPSvz7q+/ZpCFPsp6F9kQh4fToSvK+BLZihmbgTJ
E6fmHW8uO6iOcdkTI5TfsDmyHyg5Zgv0pYunnb4uiLSEKUsrbTdOZOtCVm6SlCQJ
x5QpRGRzAAHF9pk2zK/ZMtL2ygj99Vnis6n9RGymnGZ5j/LkN+9dW700HZ6F5THx
JLKEZtvo/Ktxt9b3cZwyRuZXJbus3t7JX6DzJR31ZfcdTGweu1IPSS1jq6tqjRY2
29tcnDNT7jStdYsrLfJfNzxP8XLL1A==
=qfoR
-----END PGP SIGNATURE-----

--=-0NIUE1z8vrsnfV1Gs03l--
