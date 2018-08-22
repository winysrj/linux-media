Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43669 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbeHVSRn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 14:17:43 -0400
Message-ID: <1b16fd04fb9731b001353d58daa2d1050b02b1df.camel@bootlin.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Wed, 22 Aug 2018 16:52:18 +0200
In-Reply-To: <cf009ffba4f9245ea42510aec54a422ca976d4d4.camel@ndufresne.ca>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
         <cf009ffba4f9245ea42510aec54a422ca976d4d4.camel@ndufresne.ca>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-wn1A9vKUuSOX7srZ9XWg"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-wn1A9vKUuSOX7srZ9XWg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-08-15 at 09:57 -0400, Nicolas Dufresne wrote:
> Le lundi 06 ao=C3=BBt 2018 =C3=A0 10:16 +0200, Paul Kocialkowski a =C3=A9=
crit :
> > Hi Hans and all,
> >=20
> > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> > > Hi all,
> > >=20
> > > While the Request API patch series addresses all the core API issues,=
 there
> > > are some high-level considerations as well:
> > >=20
> > > 1) How can the application tell that the Request API is supported and=
 for
> > >    which buffer types (capture/output) and pixel formats?
> > >=20
> > > 2) How can the application tell if the Request API is required as opp=
osed to being
> > >    optional?
> > >=20
> > > 3) Some controls may be required in each request, how to let userspac=
e know this?
> > >    Is it even necessary to inform userspace?
> > >=20
> > > 4) (For bonus points): How to let the application know which streamin=
g I/O modes
> > >    are available? That's never been possible before, but it would be =
very nice
> > >    indeed if that's made explicit.
> >=20
> > Thanks for bringing up these considerations and questions, which perhap=
s
> > cover the last missing bits for streamlined use of the request API by
> > userspace. I would suggest another item, related to 3):
> >=20
> > 5) How can applications tell whether the driver supports a specific
> > codec profile/level, not only for encoding but also for decoding? It's
> > common for low-end embedded hardware to not support the most advanced
> > profiles (e.g. H264 high profile).
>=20
> Hi Paul, after some discussion with Philip, he sent a proposal patch
> that enables profile/level extended CID support to decoders too. The
> control is made read-only, the point is not really the CID get/set but
> that the controls allow enumerating the supported values. This seems
> quite straightforward and easy to use.
>=20
> This enumeration is already provided this way some of the existing
> sate-full encoders.=20

Sounds great, thanks for looking into it! I looked for the patch in the
list, but couldn't find it off-hand. Do you have a link to it? I would
like to bind it to the Cedrus VPU driver eventually.

Cheers,

Paul

> > > Since the Request API associates data with frame buffers it makes sen=
se to expose
> > > this as a new capability field in struct v4l2_requestbuffers and stru=
ct v4l2_create_buffers.
> > >=20
> > > The first struct has 2 reserved fields, the second has 8, so it's not=
 a problem to
> > > take one for a capability field. Both structs also have a buffer type=
, so we know
> > > if this is requested for a capture or output buffer type. The pixel f=
ormat is known
> > > in the driver, so HAS/REQUIRES_REQUESTS can be set based on that. I d=
oubt we'll have
> > > drivers where the request caps would actually depend on the pixel for=
mat, but it
> > > theoretically possible. For both ioctls you can call them with count=
=3D0 at the start
> > > of the application. REQBUFS has of course the side-effect of deleting=
 all buffers,
> > > but at the start of your application you don't have any yet. CREATE_B=
UFS has no
> > > side-effects.
> >=20
> > My initial thoughts on this point were to have flags exposed in
> > v4l2_capability, but now that you're saying it, it does make sense for
> > the flag to be associated with a buffer rather than the global device.
> >=20
> > In addition, I've heard of cases (IIRC it was some Rockchip platforms)
> > where the platform has both stateless and stateful VPUs (I think it was
> > stateless up to H264 and stateful for H265). This would allow supportin=
g
> > these two hardware blocks under the same video device (if that makes
> > sense anyway). And even if there's no immediate need, it's always good
> > to have this level of granularity (with little drawbacks).
> >=20
> > > I propose adding these capabilities:
> > >=20
> > > #define V4L2_BUF_CAP_HAS_REQUESTS	0x00000001
> > > #define V4L2_BUF_CAP_REQUIRES_REQUESTS	0x00000002
> > > #define V4L2_BUF_CAP_HAS_MMAP		0x00000100
> > > #define V4L2_BUF_CAP_HAS_USERPTR	0x00000200
> > > #define V4L2_BUF_CAP_HAS_DMABUF		0x00000400
> > >=20
> > > If REQUIRES_REQUESTS is set, then HAS_REQUESTS is also set.
> > >=20
> > > At this time I think that REQUIRES_REQUESTS would only need to be set=
 for the
> > > output queue of stateless codecs.
> > >=20
> > > If capabilities is 0, then it's from an old kernel and all you know i=
s that
> > > requests are certainly not supported, and that MMAP is supported. Whe=
ther USERPTR
> > > or DMABUF are supported isn't known in that case (just try it :-) ).
> >=20
> > Sounds good to me!
> >=20
> > > Strictly speaking we do not need these HAS_MMAP/USERPTR/DMABUF caps, =
but it is very
> > > easy to add if we create a new capability field anyway, and it has al=
ways annoyed
> > > the hell out of me that we didn't have a good way to let userspace kn=
ow what
> > > streaming I/O modes we support. And with vb2 it's easy to implement.
> >=20
> > I totally agree here, it would be very nice to take the occasion to
> > expose to userspace what I/O modes are available. The current try-and-
> > see approach works, but this feels much better indeed.
> >=20
> > > Regarding point 3: I think this should be documented next to the pixe=
l format. I.e.
> > > the MPEG-2 Slice format used by the stateless cedrus codec requires t=
he request API
> > > and that two MPEG-2 controls (slice params and quantization matrices)=
 must be present
> > > in each request.
> > >=20
> > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ) is=
 needed here.
> > > It's really implied by the fact that you use a stateless codec. It do=
esn't help
> > > generic applications like v4l2-ctl or qv4l2 either since in order to =
support
> > > stateless codecs they will have to know about the details of these co=
ntrols anyway.
> > >=20
> > > So I am inclined to say that it is not necessary to expose this infor=
mation in
> > > the API, but it has to be documented together with the pixel format d=
ocumentation.
> >=20
> > I think this is affected by considerations about codec profile/level
> > support. More specifically, some controls will only be required for
> > supporting advanced codec profiles/levels, so they can only be
> > explicitly marked with appropriate flags by the driver when the target
> > profile/level is known. And I don't think it would be sane for userspac=
e
> > to explicitly set what profile/level it's aiming at. As a result, I
> > don't think we can explicitly mark controls as required or optional.
> >=20
> > I also like the idea that it should instead be implicit and that the
> > documentation should detail which specific stateless metadata controls
> > are required for a given profile/level.
> >=20
> > As for controls validation, the approach followed in the Cedrus driver
> > is to check that the most basic controls are filled and allow having
> > missing controls for those that match advanced profiles.
> >=20
> > Since this approach feels somewhat generic enough to be applied to all
> > stateless VPU drivers, maybe this should be made a helper in the
> > framework?
> >=20
> > In addition, I see a need for exposing the maximum profile/level that
> > the driver supports for decoding. I would suggest reusing the already-
> > existing dedicated controls used for encoding for this purpose. For
> > decoders, they would be used to expose the (read-only) maximum
> > profile/level that is supported by the hardware and keep using them as =
a
> > settable value in a range (matching the level of support) for encoders.
> >=20
> > This is necessary for userspace to determine whether a given video can
> > be decoded in hardware or not. Instead of half-way decoding the video
> > (ending up in funky results), this would easily allow skipping hardware
> > decoding and e.g. falling back on software decoding.
> >=20
> > What do you think?
> >=20
> > Cheers,
> >=20
> > Paul
> >=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-wn1A9vKUuSOX7srZ9XWg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlt9eKIACgkQ3cLmz3+f
v9FTpQf/QtiwiQZanNyYUPEqxEl6Kntu37DiUxgZKIeJMwNDKpQsTV1H8qxCoGwK
RmwTpRmVJ0GVl3WXBMO8q+SRnFgrfg6TJT3+FfZaybA1blFnGO8m7pNnU1XsYXIw
yRuD+w199m3oju2Njz4WIWBVsPZtPMaT67ZLgAfukzxKAak98mz4nirq3IB3PGJF
em0J3vRCfWF9VICk7kExdlqOD+BO+7TjGPlFw28uktefJJrCZ6fEU50DoVyET5sU
8MAfRhtmP8HvfDM0b/ib1ptRy7+VAe98Ks8sKMjvnfFdg97mQDi7WN+rpwk1APrS
YGQTI92Ll0YEsou4UOqUc9uZytOrFA==
=dbtx
-----END PGP SIGNATURE-----

--=-wn1A9vKUuSOX7srZ9XWg--
