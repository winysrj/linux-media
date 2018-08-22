Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:40138 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbeHVVTU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 17:19:20 -0400
Received: by mail-qt0-f178.google.com with SMTP id h4-v6so3116766qtj.7
        for <linux-media@vger.kernel.org>; Wed, 22 Aug 2018 10:53:28 -0700 (PDT)
Message-ID: <016dea64f7d373699b2c169e55219d2ba029ab16.camel@ndufresne.ca>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Wed, 22 Aug 2018 13:53:25 -0400
In-Reply-To: <1b16fd04fb9731b001353d58daa2d1050b02b1df.camel@bootlin.com>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
         <cf009ffba4f9245ea42510aec54a422ca976d4d4.camel@ndufresne.ca>
         <1b16fd04fb9731b001353d58daa2d1050b02b1df.camel@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-yHtZ3kVox31evukVE8tb"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-yHtZ3kVox31evukVE8tb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 22 ao=C3=BBt 2018 =C3=A0 16:52 +0200, Paul Kocialkowski a =C3=
=A9crit :
> Hi,
>=20
> On Wed, 2018-08-15 at 09:57 -0400, Nicolas Dufresne wrote:
> > Le lundi 06 ao=C3=BBt 2018 =C3=A0 10:16 +0200, Paul Kocialkowski a =C3=
=A9crit :
> > > Hi Hans and all,
> > >=20
> > > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> > > > Hi all,
> > > >=20
> > > > While the Request API patch series addresses all the core API issue=
s, there
> > > > are some high-level considerations as well:
> > > >=20
> > > > 1) How can the application tell that the Request API is supported a=
nd for
> > > >    which buffer types (capture/output) and pixel formats?
> > > >=20
> > > > 2) How can the application tell if the Request API is required as o=
pposed to being
> > > >    optional?
> > > >=20
> > > > 3) Some controls may be required in each request, how to let usersp=
ace know this?
> > > >    Is it even necessary to inform userspace?
> > > >=20
> > > > 4) (For bonus points): How to let the application know which stream=
ing I/O modes
> > > >    are available? That's never been possible before, but it would b=
e very nice
> > > >    indeed if that's made explicit.
> > >=20
> > > Thanks for bringing up these considerations and questions, which perh=
aps
> > > cover the last missing bits for streamlined use of the request API by
> > > userspace. I would suggest another item, related to 3):
> > >=20
> > > 5) How can applications tell whether the driver supports a specific
> > > codec profile/level, not only for encoding but also for decoding? It'=
s
> > > common for low-end embedded hardware to not support the most advanced
> > > profiles (e.g. H264 high profile).
> >=20
> > Hi Paul, after some discussion with Philip, he sent a proposal patch
> > that enables profile/level extended CID support to decoders too. The
> > control is made read-only, the point is not really the CID get/set but
> > that the controls allow enumerating the supported values. This seems
> > quite straightforward and easy to use.
> >=20
> > This enumeration is already provided this way some of the existing
> > sate-full encoders.=20
>=20
> Sounds great, thanks for looking into it! I looked for the patch in the
> list, but couldn't find it off-hand. Do you have a link to it? I would
> like to bind it to the Cedrus VPU driver eventually.

I believe it is that one:
https://patchwork.kernel.org/patch/10494379/



>=20
> Cheers,
>=20
> Paul
>=20
> > > > Since the Request API associates data with frame buffers it makes s=
ense to expose
> > > > this as a new capability field in struct v4l2_requestbuffers and st=
ruct v4l2_create_buffers.
> > > >=20
> > > > The first struct has 2 reserved fields, the second has 8, so it's n=
ot a problem to
> > > > take one for a capability field. Both structs also have a buffer ty=
pe, so we know
> > > > if this is requested for a capture or output buffer type. The pixel=
 format is known
> > > > in the driver, so HAS/REQUIRES_REQUESTS can be set based on that. I=
 doubt we'll have
> > > > drivers where the request caps would actually depend on the pixel f=
ormat, but it
> > > > theoretically possible. For both ioctls you can call them with coun=
t=3D0 at the start
> > > > of the application. REQBUFS has of course the side-effect of deleti=
ng all buffers,
> > > > but at the start of your application you don't have any yet. CREATE=
_BUFS has no
> > > > side-effects.
> > >=20
> > > My initial thoughts on this point were to have flags exposed in
> > > v4l2_capability, but now that you're saying it, it does make sense fo=
r
> > > the flag to be associated with a buffer rather than the global device=
.
> > >=20
> > > In addition, I've heard of cases (IIRC it was some Rockchip platforms=
)
> > > where the platform has both stateless and stateful VPUs (I think it w=
as
> > > stateless up to H264 and stateful for H265). This would allow support=
ing
> > > these two hardware blocks under the same video device (if that makes
> > > sense anyway). And even if there's no immediate need, it's always goo=
d
> > > to have this level of granularity (with little drawbacks).
> > >=20
> > > > I propose adding these capabilities:
> > > >=20
> > > > #define V4L2_BUF_CAP_HAS_REQUESTS	0x00000001
> > > > #define V4L2_BUF_CAP_REQUIRES_REQUESTS	0x00000002
> > > > #define V4L2_BUF_CAP_HAS_MMAP		0x00000100
> > > > #define V4L2_BUF_CAP_HAS_USERPTR	0x00000200
> > > > #define V4L2_BUF_CAP_HAS_DMABUF		0x00000400
> > > >=20
> > > > If REQUIRES_REQUESTS is set, then HAS_REQUESTS is also set.
> > > >=20
> > > > At this time I think that REQUIRES_REQUESTS would only need to be s=
et for the
> > > > output queue of stateless codecs.
> > > >=20
> > > > If capabilities is 0, then it's from an old kernel and all you know=
 is that
> > > > requests are certainly not supported, and that MMAP is supported. W=
hether USERPTR
> > > > or DMABUF are supported isn't known in that case (just try it :-) )=
.
> > >=20
> > > Sounds good to me!
> > >=20
> > > > Strictly speaking we do not need these HAS_MMAP/USERPTR/DMABUF caps=
, but it is very
> > > > easy to add if we create a new capability field anyway, and it has =
always annoyed
> > > > the hell out of me that we didn't have a good way to let userspace =
know what
> > > > streaming I/O modes we support. And with vb2 it's easy to implement=
.
> > >=20
> > > I totally agree here, it would be very nice to take the occasion to
> > > expose to userspace what I/O modes are available. The current try-and=
-
> > > see approach works, but this feels much better indeed.
> > >=20
> > > > Regarding point 3: I think this should be documented next to the pi=
xel format. I.e.
> > > > the MPEG-2 Slice format used by the stateless cedrus codec requires=
 the request API
> > > > and that two MPEG-2 controls (slice params and quantization matrice=
s) must be present
> > > > in each request.
> > > >=20
> > > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ) =
is needed here.
> > > > It's really implied by the fact that you use a stateless codec. It =
doesn't help
> > > > generic applications like v4l2-ctl or qv4l2 either since in order t=
o support
> > > > stateless codecs they will have to know about the details of these =
controls anyway.
> > > >=20
> > > > So I am inclined to say that it is not necessary to expose this inf=
ormation in
> > > > the API, but it has to be documented together with the pixel format=
 documentation.
> > >=20
> > > I think this is affected by considerations about codec profile/level
> > > support. More specifically, some controls will only be required for
> > > supporting advanced codec profiles/levels, so they can only be
> > > explicitly marked with appropriate flags by the driver when the targe=
t
> > > profile/level is known. And I don't think it would be sane for usersp=
ace
> > > to explicitly set what profile/level it's aiming at. As a result, I
> > > don't think we can explicitly mark controls as required or optional.
> > >=20
> > > I also like the idea that it should instead be implicit and that the
> > > documentation should detail which specific stateless metadata control=
s
> > > are required for a given profile/level.
> > >=20
> > > As for controls validation, the approach followed in the Cedrus drive=
r
> > > is to check that the most basic controls are filled and allow having
> > > missing controls for those that match advanced profiles.
> > >=20
> > > Since this approach feels somewhat generic enough to be applied to al=
l
> > > stateless VPU drivers, maybe this should be made a helper in the
> > > framework?
> > >=20
> > > In addition, I see a need for exposing the maximum profile/level that
> > > the driver supports for decoding. I would suggest reusing the already=
-
> > > existing dedicated controls used for encoding for this purpose. For
> > > decoders, they would be used to expose the (read-only) maximum
> > > profile/level that is supported by the hardware and keep using them a=
s a
> > > settable value in a range (matching the level of support) for encoder=
s.
> > >=20
> > > This is necessary for userspace to determine whether a given video ca=
n
> > > be decoded in hardware or not. Instead of half-way decoding the video
> > > (ending up in funky results), this would easily allow skipping hardwa=
re
> > > decoding and e.g. falling back on software decoding.
> > >=20
> > > What do you think?
> > >=20
> > > Cheers,
> > >=20
> > > Paul
> > >=20

--=-yHtZ3kVox31evukVE8tb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW32jFQAKCRBxUwItrAao
HAveAJ4rKRQ5pzJyYC57XCZNyXeSBjzR3gCfZtcRpwcLuR61jk800wp0/JRFGRI=
=kuMm
-----END PGP SIGNATURE-----

--=-yHtZ3kVox31evukVE8tb--
