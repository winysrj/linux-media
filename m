Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42589 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728197AbeHVRfg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 13:35:36 -0400
Message-ID: <8b603c5a27c55e30e4ac3f1b9bb6b6d8515e2331.camel@bootlin.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Tomasz Figa <tfiga@chromium.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Wed, 22 Aug 2018 16:10:20 +0200
In-Reply-To: <CAAFQd5C0bwbZ74rpCTmXVNGPdp2TDJcb+YzRfevwuxvvK7Lbzg@mail.gmail.com>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
         <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl>
         <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
         <186fd3ca-7759-7648-6870-4e5274a9680d@xs4all.nl>
         <05d52a4a3ed33a057e050d1f79dc0d873f31f21e.camel@bootlin.com>
         <CAAFQd5C0bwbZ74rpCTmXVNGPdp2TDJcb+YzRfevwuxvvK7Lbzg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-VHIGgrZFWYviSSSmKkcM"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-VHIGgrZFWYviSSSmKkcM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-08-21 at 17:52 +0900, Tomasz Figa wrote:
> Hi Hans, Paul,
>=20
> On Mon, Aug 6, 2018 at 6:29 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> >=20
> > On Mon, 2018-08-06 at 11:23 +0200, Hans Verkuil wrote:
> > > On 08/06/2018 11:13 AM, Paul Kocialkowski wrote:
> > > > Hi,
> > > >=20
> > > > On Mon, 2018-08-06 at 10:32 +0200, Hans Verkuil wrote:
> > > > > On 08/06/2018 10:16 AM, Paul Kocialkowski wrote:
> > > > > > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> > > > > > > Regarding point 3: I think this should be documented next to =
the pixel format. I.e.
> > > > > > > the MPEG-2 Slice format used by the stateless cedrus codec re=
quires the request API
> > > > > > > and that two MPEG-2 controls (slice params and quantization m=
atrices) must be present
> > > > > > > in each request.
> > > > > > >=20
> > > > > > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN=
_REQ) is needed here.
> > > > > > > It's really implied by the fact that you use a stateless code=
c. It doesn't help
> > > > > > > generic applications like v4l2-ctl or qv4l2 either since in o=
rder to support
> > > > > > > stateless codecs they will have to know about the details of =
these controls anyway.
> > > > > > >=20
> > > > > > > So I am inclined to say that it is not necessary to expose th=
is information in
> > > > > > > the API, but it has to be documented together with the pixel =
format documentation.
> > > > > >=20
> > > > > > I think this is affected by considerations about codec profile/=
level
> > > > > > support. More specifically, some controls will only be required=
 for
> > > > > > supporting advanced codec profiles/levels, so they can only be
> > > > > > explicitly marked with appropriate flags by the driver when the=
 target
> > > > > > profile/level is known. And I don't think it would be sane for =
userspace
> > > > > > to explicitly set what profile/level it's aiming at. As a resul=
t, I
> > > > > > don't think we can explicitly mark controls as required or opti=
onal.
>=20
> I'm not sure this is entirely true. The hardware may need to be
> explicitly told what profile the video is. It may even not be the
> hardware, but the driver itself too, given that the profile may imply
> the CAPTURE pixel format, e.g. for VP9 profiles:
>=20
> profile 0
> color depth: 8 bit/sample, chroma subsampling: 4:2:0
> profile 1
> color depth: 8 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4
> profile 2
> color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0
> profile 3
> color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4
>=20
> (reference: https://en.wikipedia.org/wiki/VP9#Profiles)

I think it would be fair to expect userspace to select the right
destination format (and maybe have the driver error if there's a
mismatch with the meta-data) instead of having the driver somewhat
expose what format should be used.

But maybe this would be an API violation, since all the enumerated
formats are probably supposed to be selectable?

We could also look at it the other way round and consider that selecting
an exposed format is always legit, but that it implies passing a
bitstream that matches it or the driver will error (because of an
invalid bitstream passed, not because of a "wrong" selected format).

As far as I understood, the profile/level information is there to
indicate a set of supported features by the decoder, not as an
information used for the decoding process. Each corresponding feature is
enabled or not in the bitstream meta-data and that's all the information
the decoder really needs.

This is why I think that setting the profile/level explicitly is not
justified by the nature of the process and adding it only for
convenience or marking whether controls are optional doesn't seem
justified at this point, in my opinion.

> > > > > > I also like the idea that it should instead be implicit and tha=
t the
> > > > > > documentation should detail which specific stateless metadata c=
ontrols
> > > > > > are required for a given profile/level.
> > > > > >=20
> > > > > > As for controls validation, the approach followed in the Cedrus=
 driver
> > > > > > is to check that the most basic controls are filled and allow h=
aving
> > > > > > missing controls for those that match advanced profiles.
> > > > > >=20
> > > > > > Since this approach feels somewhat generic enough to be applied=
 to all
> > > > > > stateless VPU drivers, maybe this should be made a helper in th=
e
> > > > > > framework?
> > > > >=20
> > > > > Sounds reasonable. Not sure if it will be in the first version, b=
ut it is
> > > > > easy to add later.
> > > >=20
> > > > Definitely, I don't think this is such a high priority for now eith=
er.
> > > >=20
>=20
> We may want to put strict requirements on what controls are provided
> for given codec+profile/level. Otherwise we might get some user space
> that doesn't provide some of them and works only by luck, e.g. because
> some hardware defaults on initial drivers luckily match the needed
> values. Even if we don't validate it in the code yet, we should put a
> big warning saying that not providing the required controls would
> result in undefined behavior.

I don't think having such strict requirements are a good thing. Even
with the level/profile made explicit, what if the video under-uses its
features and thus legitimately doesn't need to have all the controls
that could be supported with the level/profile? This can probably also
be frame-specific, so some frames could require more controls than
others.

This also leads me to believe that the profile/level indication should
be used as a support indication to userspace, not as a way to expose the
required features for decoding to the kernel

We could still enforce checks for the most basic controls (that are used
for all types of slices to decode) and error if they are missing. We
could also check the bits that indicate more advanced features in these
basic controls and decide what other controls are required from that.

> > > > > > In addition, I see a need for exposing the maximum profile/leve=
l that
> > > > > > the driver supports for decoding. I would suggest reusing the a=
lready-
> > > > > > existing dedicated controls used for encoding for this purpose.=
 For
> > > > > > decoders, they would be used to expose the (read-only) maximum
> > > > > > profile/level that is supported by the hardware and keep using =
them as a
> > > > > > settable value in a range (matching the level of support) for e=
ncoders.
> > > > > >=20
> > > > > > This is necessary for userspace to determine whether a given vi=
deo can
> > > > > > be decoded in hardware or not. Instead of half-way decoding the=
 video
> > > > > > (ending up in funky results), this would easily allow skipping =
hardware
> > > > > > decoding and e.g. falling back on software decoding.
> > > > >=20
> > > > > I think it might be better to expose this through new read-only b=
itmask
> > > > > controls: i.e. a bitmask containing the supported profiles and le=
vels.
> > > >=20
> > > > It seems that this is more or less what the coda driver is doing fo=
r
> > > > decoding actually, although it uses a menu control between min/max
> > > > supported profile/levels, with a mask to "blacklist" the unsupporte=
d
> > > > values. Then, the V4L2_CTRL_FLAG_READ_ONLY flag is set to keep the
> > > > control read-only.
> > > >=20
> > > > > Reusing the existing controls for a decoder is odd since there is=
 not
> > > > > really a concept of a 'current' value since you just want to repo=
rt what
> > > > > is supported. And I am not sure if all decoders can report the pr=
ofile
> > > > > or level that they detect.
> > > >=20
> > > > Is that really a problem when the READ_ONLY flag is set? I thought =
it
> > > > was designed to fit this specific case, when the driver reports a v=
alue
> > > > that userspace cannot affect.
> > >=20
> > > Well, for read-only menu controls the current value of the control wo=
uld
> > > have to indicate what the current profile/level is that is being deco=
ded.
> > >=20
> > > That's not really relevant since what you want is just to query the
> > > supported profiles/levels. A read-only bitmask control is the fastest
> > > method (if only because using a menu control requires the application=
 to
> > > enumerate all possibilities with QUERYMENU).
>=20
> Besides querying for supported profiles,
>  - For stateless codecs we also need to set the profile, since the
> codec itself does only the number crunching.

I disagree here, see above.

>  - For stateful codecs, the decoder would also report the detected
> profile after parsing the bitstream (although this is possibly not of
> a big importance to the user space).

I don't follow the logic behind this. This means informing userspace of
the capabilities required to decode the video that the VPU is currently
decoding... so that it can decided whether to decode it?

> As for querying itself, there is still more to it than could be
> handled with just a read only control. To detect what CAPTURE formats
> are supported for given profile, one would have to set the profile
> control first and then use ENUM_FMT.

Or consider that the bitstream is invalid if it doesn't match the
selected format and let userspace pick the appropriate format.

> > Ah yes, I finally understand the issue with what the current control
> > value represents here. Since I don't think the driver should have to
> > bother with figuring out the profile in use (as expressed earlier, I
> > think it should be implicit, through the codec metadata controls and
> > features used), I no longer believe it's best to have the same control
> > for both encoding and decoding.
> >=20
> > > > Otherwise, I agree that having a bitmask type would be a better fit=
, but
> > > > I think it would be beneficial to keep the already-defined control =
and
> > > > associated values, which implies using the menu control type for bo=
th
> > > > encoders and decoders.
> > > >=20
> > > > If this is not an option, I would be in favour of adding per-codec =
read-
> > > > only bitmask controls (e.g. for H264 something like
> > > > V4L2_CID_MPEG_VIDEO_H264_PROFILE_SUPPORT) that expose the already-
> > > > existing profile/level definitions as bit identifiers (a bit like c=
oda
> > > > is using them to craft a mask for the menu items to blacklist) for
> > > > decoding only.
> > >=20
> > > That's what I have in mind, yes. I'd like Tomasz' input as well, thou=
gh.
>=20
> Thanks for valuing my input! Hopefully the comments don't turn that
> into overestimation. ;) Sorry for being terribly late to the party,
> last 2 weeks have been extremely busy.

Taking the occasion to note that I have also been slow to respond here,
with ongoing work on H265 support.

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-VHIGgrZFWYviSSSmKkcM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlt9bswACgkQ3cLmz3+f
v9F+ogf/RCeg01C2Y6gVmAoa8VVaj7dBFNHhSKh2bnNjTiCyYwpJFIpIJ+NMYTQG
v6QHVj7oSWv/p+gPmhU2+csp+OKZMfckUOG74cEbhRntXyhtlCWikjOQG5PIW9+J
wbNHWJJ/4Vt7dgOEa539jdGWBjJt9Zoks8AILDef4/AgCIGMU19h6UPULzeRc3Lq
LjF9+mlWBYPyfGvujpOb7eUE/DMAyO++SLOFg+cMMLnIT1NMJZyHKyAGBCtW70zN
GiZ/PJym0GkDpOzCwlxt/at4iNTZQiPMH7wcbXOp4yVWrd0DnQ9t1X+EeK93153L
GhiVEwKR/zOFU/rcKWjrt14/1GHA2A==
=FsQK
-----END PGP SIGNATURE-----

--=-VHIGgrZFWYviSSSmKkcM--
