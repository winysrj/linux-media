Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49829 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932885AbeFYN3p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 09:29:45 -0400
Date: Mon, 25 Jun 2018 15:29:33 +0200
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
Subject: Re: [PATCH 6/9] media: cedrus: Add ops structure
Message-ID: <20180625132933.tzr36vsucqsq3mmb@flea>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-7-maxime.ripard@bootlin.com>
 <939381a854760b1d54984ae0f534ec03312ec8e0.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6dj7e7c23mamq72t"
Content-Disposition: inline
In-Reply-To: <939381a854760b1d54984ae0f534ec03312ec8e0.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6dj7e7c23mamq72t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Thu, Jun 21, 2018 at 11:49:54AM +0200, Paul Kocialkowski wrote:
> Hi,
>=20
> On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > In order to increase the number of codecs supported, we need to decouple
> > the MPEG2 only code that was there up until now and turn it into someth=
ing
> > a bit more generic.
> >=20
> > Do that by introducing an intermediate ops structure that would need to=
 be
> > filled by each supported codec. Start by implementing in that structure=
 the
> > setup and trigger hooks that are currently the only functions being
> > implemented by codecs support.
> >=20
> > To do so, we need to store the current codec in use, which we do at
> > start_streaming time.
>=20
> With the comments below taken in account, this is:
>=20
> Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Thanks!

> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  .../platform/sunxi/cedrus/sunxi_cedrus.c      |  2 ++
> >  .../sunxi/cedrus/sunxi_cedrus_common.h        | 11 +++++++
> >  .../platform/sunxi/cedrus/sunxi_cedrus_dec.c  | 10 +++---
> >  .../sunxi/cedrus/sunxi_cedrus_mpeg2.c         | 11 +++++--
> >  .../sunxi/cedrus/sunxi_cedrus_mpeg2.h         | 33 -------------------
> >  .../sunxi/cedrus/sunxi_cedrus_video.c         | 17 +++++++++-
> >  6 files changed, 42 insertions(+), 42 deletions(-)
> >  delete mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mp=
eg2.h
> >=20
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c b/drive=
rs/media/platform/sunxi/cedrus/sunxi_cedrus.c
> > index ccd41d9a3e41..bc80480f5dfd 100644
> > --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
> > @@ -244,6 +244,8 @@ static int sunxi_cedrus_probe(struct platform_devic=
e *pdev)
> >  	if (ret)
> >  		return ret;
> > =20
> > +	dev->dec_ops[SUNXI_CEDRUS_CODEC_MPEG2] =3D &sunxi_cedrus_dec_ops_mpeg=
2;
> > +
> >  	ret =3D v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> >  	if (ret)
> >  		goto unreg_media;
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h =
b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > index a5f83c452006..c2e2c92d103b 100644
> > --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > @@ -75,6 +75,7 @@ struct sunxi_cedrus_ctx {
> >  	struct v4l2_pix_format_mplane src_fmt;
> >  	struct sunxi_cedrus_fmt *vpu_dst_fmt;
> >  	struct v4l2_pix_format_mplane dst_fmt;
> > +	enum sunxi_cedrus_codec current_codec;
>=20
> Nit: for consistency with the way things are named, "codec_current"
> probably makes more sense.

I'm not quite sure what you mean by consitency here. This structure
has 5 other variables with two words: vpu_src_fmt, src_fmt,
vpu_dst_fmt, dst_fmt and dst_bufs. codec_current would be going
against the consistency of that structure.

> IMO using the natural English order is fine for temporary variables, but
>  less so for variables used in common parts like structures. This allows
> seeing "_" as a logical hierarchical delimiter that automatically makes
> us end up with consistent prefixes that can easily be grepped for and
> derived.
>=20
> But that's just my 2 cents, it's really not a big deal, especially in
> this case!
>=20
> >  	struct v4l2_ctrl_handler hdl;
> >  	struct v4l2_ctrl *ctrls[SUNXI_CEDRUS_CTRL_MAX];
> > @@ -107,6 +108,14 @@ struct sunxi_cedrus_buffer *vb2_to_cedrus_buffer(c=
onst struct vb2_buffer *p)
> >  	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
> >  }
> > =20
> > +struct sunxi_cedrus_dec_ops {
> > +	void (*setup)(struct sunxi_cedrus_ctx *ctx,
> > +		      struct sunxi_cedrus_run *run);
> > +	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
>=20
> By the way, are we sure that these functions won't ever fail?
> I think this is the case for MPEG2 (there is virtually nothing to check
> for errors) but perhaps it's different for H264.

It won't fail either, and if we need to change it somewhere down the
line, it's quite easy to do.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--6dj7e7c23mamq72t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsw7jwACgkQ0rTAlCFN
r3TTQg//f5av7XpKtjKhiTl/OXZ+zeyd1vEh3qWSVPnq8Qok7n5I3CkdAq9UjNwe
jUXFR9GefIrkDLcU9Ret36ZH1J/1A2/MqR9UGUSfvNAUkZqhZqzTshy6q/XeHeXK
LfCp22SXs+SLMacLeMi/x9jiR250IweU5DEnjbTtyKHlxNp8LHPYU60vyvOospov
FvMY3511XBao4yvKDKwE8CUZq4UOMa6JiWyvMmuygxAnmXwlayHWfAq2jgEU8NVH
kC/hM1gsjY+qswVMp8lyWyztP5FZ/R24xKsgNndwNQa2if1wyUKhQluhtRIHSlF/
wLlYgoL1nSMZNm+fPd217h9lz7Li9BiDnWWomnnGpEYRvsHSFYe+SGZw0eVX9BF/
0pzJ0if90UL0uniFcD9naTkVrzHJkNFqedq9ogU5Mb+MsSlyMoD3SHR5SKDRYA1a
jzeBaOajjSEMh3f+mXqTN2qi/6UGQNHFg0c2D+ah6WWF62KwvFak2/eRdYmfn3fh
BKjDxEdli8Xazy2tzh7H3bjETHX3q/TaCvcnn412IMhXPt/6e8YYq4wpZD0SoQ53
9N5W0fs3tIASNLRqWMyrDLKfehlUM1VrCtrR15y7JCh+AZda9l7RLgCa3VhPDGE1
zVXUxuwtksaK5Pi0c/MDlqPXSkotwAqmVUDS3WDFDihd5fG4t/Y=
=yGYd
-----END PGP SIGNATURE-----

--6dj7e7c23mamq72t--
