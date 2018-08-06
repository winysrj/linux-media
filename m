Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:46538 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbeHFLh5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Aug 2018 07:37:57 -0400
Message-ID: <05d52a4a3ed33a057e050d1f79dc0d873f31f21e.camel@bootlin.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Mon, 06 Aug 2018 11:29:44 +0200
In-Reply-To: <186fd3ca-7759-7648-6870-4e5274a9680d@xs4all.nl>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
         <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl>
         <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
         <186fd3ca-7759-7648-6870-4e5274a9680d@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-28/NxM+OACrq7HvoD4C/"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-28/NxM+OACrq7HvoD4C/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-08-06 at 11:23 +0200, Hans Verkuil wrote:
> On 08/06/2018 11:13 AM, Paul Kocialkowski wrote:
> > Hi,
> >=20
> > On Mon, 2018-08-06 at 10:32 +0200, Hans Verkuil wrote:
> > > On 08/06/2018 10:16 AM, Paul Kocialkowski wrote:
> > > > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> > > > > Regarding point 3: I think this should be documented next to the =
pixel format. I.e.
> > > > > the MPEG-2 Slice format used by the stateless cedrus codec requir=
es the request API
> > > > > and that two MPEG-2 controls (slice params and quantization matri=
ces) must be present
> > > > > in each request.
> > > > >=20
> > > > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ=
) is needed here.
> > > > > It's really implied by the fact that you use a stateless codec. I=
t doesn't help
> > > > > generic applications like v4l2-ctl or qv4l2 either since in order=
 to support
> > > > > stateless codecs they will have to know about the details of thes=
e controls anyway.
> > > > >=20
> > > > > So I am inclined to say that it is not necessary to expose this i=
nformation in
> > > > > the API, but it has to be documented together with the pixel form=
at documentation.
> > > >=20
> > > > I think this is affected by considerations about codec profile/leve=
l
> > > > support. More specifically, some controls will only be required for
> > > > supporting advanced codec profiles/levels, so they can only be
> > > > explicitly marked with appropriate flags by the driver when the tar=
get
> > > > profile/level is known. And I don't think it would be sane for user=
space
> > > > to explicitly set what profile/level it's aiming at. As a result, I
> > > > don't think we can explicitly mark controls as required or optional=
.
> > > >=20
> > > > I also like the idea that it should instead be implicit and that th=
e
> > > > documentation should detail which specific stateless metadata contr=
ols
> > > > are required for a given profile/level.
> > > >=20
> > > > As for controls validation, the approach followed in the Cedrus dri=
ver
> > > > is to check that the most basic controls are filled and allow havin=
g
> > > > missing controls for those that match advanced profiles.
> > > >=20
> > > > Since this approach feels somewhat generic enough to be applied to =
all
> > > > stateless VPU drivers, maybe this should be made a helper in the
> > > > framework?
> > >=20
> > > Sounds reasonable. Not sure if it will be in the first version, but i=
t is
> > > easy to add later.
> >=20
> > Definitely, I don't think this is such a high priority for now either.
> >=20
> > > > In addition, I see a need for exposing the maximum profile/level th=
at
> > > > the driver supports for decoding. I would suggest reusing the alrea=
dy-
> > > > existing dedicated controls used for encoding for this purpose. For
> > > > decoders, they would be used to expose the (read-only) maximum
> > > > profile/level that is supported by the hardware and keep using them=
 as a
> > > > settable value in a range (matching the level of support) for encod=
ers.
> > > >=20
> > > > This is necessary for userspace to determine whether a given video =
can
> > > > be decoded in hardware or not. Instead of half-way decoding the vid=
eo
> > > > (ending up in funky results), this would easily allow skipping hard=
ware
> > > > decoding and e.g. falling back on software decoding.
> > >=20
> > > I think it might be better to expose this through new read-only bitma=
sk
> > > controls: i.e. a bitmask containing the supported profiles and levels=
.
> >=20
> > It seems that this is more or less what the coda driver is doing for
> > decoding actually, although it uses a menu control between min/max
> > supported profile/levels, with a mask to "blacklist" the unsupported
> > values. Then, the V4L2_CTRL_FLAG_READ_ONLY flag is set to keep the
> > control read-only.
> >=20
> > > Reusing the existing controls for a decoder is odd since there is not
> > > really a concept of a 'current' value since you just want to report w=
hat
> > > is supported. And I am not sure if all decoders can report the profil=
e
> > > or level that they detect.
> >=20
> > Is that really a problem when the READ_ONLY flag is set? I thought it
> > was designed to fit this specific case, when the driver reports a value
> > that userspace cannot affect.
>=20
> Well, for read-only menu controls the current value of the control would
> have to indicate what the current profile/level is that is being decoded.
>
> That's not really relevant since what you want is just to query the
> supported profiles/levels. A read-only bitmask control is the fastest
> method (if only because using a menu control requires the application to
> enumerate all possibilities with QUERYMENU).

Ah yes, I finally understand the issue with what the current control
value represents here. Since I don't think the driver should have to
bother with figuring out the profile in use (as expressed earlier, I
think it should be implicit, through the codec metadata controls and
features used), I no longer believe it's best to have the same control
for both encoding and decoding.

> > Otherwise, I agree that having a bitmask type would be a better fit, bu=
t
> > I think it would be beneficial to keep the already-defined control and
> > associated values, which implies using the menu control type for both
> > encoders and decoders.
> >=20
> > If this is not an option, I would be in favour of adding per-codec read=
-
> > only bitmask controls (e.g. for H264 something like
> > V4L2_CID_MPEG_VIDEO_H264_PROFILE_SUPPORT) that expose the already-
> > existing profile/level definitions as bit identifiers (a bit like coda
> > is using them to craft a mask for the menu items to blacklist) for
> > decoding only.
>=20
> That's what I have in mind, yes. I'd like Tomasz' input as well, though.

Okay, so this sounds good to me at this point!

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-28/NxM+OACrq7HvoD4C/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltoFQgACgkQ3cLmz3+f
v9HmGgf+NMg+UIgJb+FQv6T2FVBs3Zb9nQlfa4jCcNl47OhrQY6h5ebnBq5LBUM/
EB8TkRbUQCntDSOrz/sYBLCC4Gc94ckkn9MNfwR0HyILDsfCtI3vDUnmfSoIwq6O
E19RAYt7HPG2XV6xo/ae6q9+BFUuJPNbme1cSkJuVS7GnFRIJXleFxLUl52cDndR
hAjv71LIInaj9SIM8ks/n4lAlDw0lUtzv9wVPs9uN1OO10eUrJKJ/gX5eo8gWc4/
j3woHWtJbuqLLSG9UeLjKodd8K1VCRplWSsuGT5X4BiF0SRsQCmtR9LLG2dHQCNr
jWQBuH2zaoeIb7KYz3xKruGMlKIpWw==
=SKVk
-----END PGP SIGNATURE-----

--=-28/NxM+OACrq7HvoD4C/--
