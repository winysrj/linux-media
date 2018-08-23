Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:59409 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbeHWLd6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 07:33:58 -0400
Message-ID: <0f947768d8e982fcc591112c43cf40d618df2233.camel@bootlin.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Thu, 23 Aug 2018 10:05:22 +0200
In-Reply-To: <8a4dba99d73e46eb6885b852110d9eac2b041db7.camel@collabora.com>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
         <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl>
         <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
         <186fd3ca-7759-7648-6870-4e5274a9680d@xs4all.nl>
         <05d52a4a3ed33a057e050d1f79dc0d873f31f21e.camel@bootlin.com>
         <CAAFQd5C0bwbZ74rpCTmXVNGPdp2TDJcb+YzRfevwuxvvK7Lbzg@mail.gmail.com>
         <8b603c5a27c55e30e4ac3f1b9bb6b6d8515e2331.camel@bootlin.com>
         <8a4dba99d73e46eb6885b852110d9eac2b041db7.camel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Gh8TeR8aBH3LkCYz9cJd"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Gh8TeR8aBH3LkCYz9cJd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-08-22 at 14:33 -0300, Ezequiel Garcia wrote:
> On Wed, 2018-08-22 at 16:10 +0200, Paul Kocialkowski wrote:
> > Hi,
> >=20
> > On Tue, 2018-08-21 at 17:52 +0900, Tomasz Figa wrote:
> > > Hi Hans, Paul,
> > >=20
> > > On Mon, Aug 6, 2018 at 6:29 PM Paul Kocialkowski
> > > <paul.kocialkowski@bootlin.com> wrote:
> > > >=20
> > > > On Mon, 2018-08-06 at 11:23 +0200, Hans Verkuil wrote:
> > > > > On 08/06/2018 11:13 AM, Paul Kocialkowski wrote:
> > > > > > Hi,
> > > > > >=20
> > > > > > On Mon, 2018-08-06 at 10:32 +0200, Hans Verkuil wrote:
> > > > > > > On 08/06/2018 10:16 AM, Paul Kocialkowski wrote:
> > > > > > > > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> > > > > > > > > Regarding point 3: I think this should be documented next=
 to the pixel format. I.e.
> > > > > > > > > the MPEG-2 Slice format used by the stateless cedrus code=
c requires the request API
> > > > > > > > > and that two MPEG-2 controls (slice params and quantizati=
on matrices) must be present
> > > > > > > > > in each request.
> > > > > > > > >=20
> > > > > > > > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRE=
D_IN_REQ) is needed here.
> > > > > > > > > It's really implied by the fact that you use a stateless =
codec. It doesn't help
> > > > > > > > > generic applications like v4l2-ctl or qv4l2 either since =
in order to support
> > > > > > > > > stateless codecs they will have to know about the details=
 of these controls anyway.
> > > > > > > > >=20
> > > > > > > > > So I am inclined to say that it is not necessary to expos=
e this information in
> > > > > > > > > the API, but it has to be documented together with the pi=
xel format documentation.
> > > > > > > >=20
> > > > > > > > I think this is affected by considerations about codec prof=
ile/level
> > > > > > > > support. More specifically, some controls will only be requ=
ired for
> > > > > > > > supporting advanced codec profiles/levels, so they can only=
 be
> > > > > > > > explicitly marked with appropriate flags by the driver when=
 the target
> > > > > > > > profile/level is known. And I don't think it would be sane =
for userspace
> > > > > > > > to explicitly set what profile/level it's aiming at. As a r=
esult, I
> > > > > > > > don't think we can explicitly mark controls as required or =
optional.
> > >=20
> > > I'm not sure this is entirely true. The hardware may need to be
> > > explicitly told what profile the video is. It may even not be the
> > > hardware, but the driver itself too, given that the profile may imply
> > > the CAPTURE pixel format, e.g. for VP9 profiles:
> > >=20
> > > profile 0
> > > color depth: 8 bit/sample, chroma subsampling: 4:2:0
> > > profile 1
> > > color depth: 8 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4
> > > profile 2
> > > color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0
> > > profile 3
> > > color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4=
:4
> > >=20
> > > (reference: https://en.wikipedia.org/wiki/VP9#Profiles)
> >=20
> > I think it would be fair to expect userspace to select the right
> > destination format (and maybe have the driver error if there's a
> > mismatch with the meta-data) instead of having the driver somewhat
> > expose what format should be used.
> >=20
> > But maybe this would be an API violation, since all the enumerated
> > formats are probably supposed to be selectable?
> >=20
> > We could also look at it the other way round and consider that selectin=
g
> > an exposed format is always legit, but that it implies passing a
> > bitstream that matches it or the driver will error (because of an
> > invalid bitstream passed, not because of a "wrong" selected format).
> >=20
>=20
> The API requires the user to negotiate via TRY_FMT/S_FMT. The driver
> usually does not return error on invalid formats, and simply return
> a format it can work with. I think the kernel-user contract has to
> guarantee if the driver accepted a given format, it won't fail to
> encoder or decode.

Well, the issue here is that in order to correctly enumerate the
formats, the driver needs to be aware of:
1. in what destination format the bitstream data is decoded to;
2. what format convesions the VPU can do.

Step 1 is known by userspace but is only passed to the driver with the
bitstream metadata from controls. This is much too late for trimming the
list of supported formats.

I'm not sure that passing an extra information to the driver early to
trim the list would make sense, because it comes to down to telling the
driver what format to target and then asking the driver was format it
supports, which is rather redundant.

I think the information we need to expose to userspace is whether the
driver supports a destination format that does not match the bitstream
format. We could make it part of the spec that, by lack of this
indication, the provided bitstream is expected to match the format that
was selected.

> I think that's why it makes sense for stateless drivers to set the
> profile/levels for a given job, in order to properly negotiate
> the input and output formats (for both encoders and decoders). =20

I still fail to follow this logic. As far as I understood, profile/level
are indications of hardware capabilities required to decode the video,
not an indication of the precise features selected for decoding,
especially when it comes the format. As Tomasz mentionned in the
previous email, various formats may be supported by the same profile, so
setting the profile/level does not indicate which format is appropriate
for decoding the bitstream.

> [1] https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-g-fmt.html
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-Gh8TeR8aBH3LkCYz9cJd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlt+asIACgkQ3cLmz3+f
v9Frdwf/bcVvdejF8Rdvj7SlwYYdpL0liNiuvdor2yYrcSuyzqoV5Jg6GzaKoVqN
IRlWOzDiM/pRHBUeKYKCCEnBkmhW1n+OR4kdNUpW8m4ZuZva70P4TcyeciDtLCpu
mLnp791SahMX+W7y0Ndvu2nv6CTqfLRDAZRi2F3pi8D20yTZkbl/sxHPdy5ZW1wu
T/IaxPilDwaAfbzeSHE0PWAE5sSTrEyGKj0VD09+XfaSKJatOWNm7SYPQ+756zjy
jN2IqUOBGVyqRolANGu/AAOzJlQMVpxC+nc4vkl4rz1+4cpr/hv/MROCWx2E3o4p
dcy183N31cQgKpyIYL/LMHgGsb8p5Q==
=qNhi
-----END PGP SIGNATURE-----

--=-Gh8TeR8aBH3LkCYz9cJd--
