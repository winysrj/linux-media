Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43065 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbeHFKYx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Aug 2018 06:24:53 -0400
Message-ID: <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Mon, 06 Aug 2018 10:16:57 +0200
In-Reply-To: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-cZ0BjPk2XGzN6ti5TVSG"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-cZ0BjPk2XGzN6ti5TVSG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hans and all,

On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> Hi all,
>=20
> While the Request API patch series addresses all the core API issues, the=
re
> are some high-level considerations as well:
>=20
> 1) How can the application tell that the Request API is supported and for
>    which buffer types (capture/output) and pixel formats?
>=20
> 2) How can the application tell if the Request API is required as opposed=
 to being
>    optional?
>=20
> 3) Some controls may be required in each request, how to let userspace kn=
ow this?
>    Is it even necessary to inform userspace?
>=20
> 4) (For bonus points): How to let the application know which streaming I/=
O modes
>    are available? That's never been possible before, but it would be very=
 nice
>    indeed if that's made explicit.

Thanks for bringing up these considerations and questions, which perhaps
cover the last missing bits for streamlined use of the request API by
userspace. I would suggest another item, related to 3):

5) How can applications tell whether the driver supports a specific
codec profile/level, not only for encoding but also for decoding? It's
common for low-end embedded hardware to not support the most advanced
profiles (e.g. H264 high profile).

> Since the Request API associates data with frame buffers it makes sense t=
o expose
> this as a new capability field in struct v4l2_requestbuffers and struct v=
4l2_create_buffers.
>=20
> The first struct has 2 reserved fields, the second has 8, so it's not a p=
roblem to
> take one for a capability field. Both structs also have a buffer type, so=
 we know
> if this is requested for a capture or output buffer type. The pixel forma=
t is known
> in the driver, so HAS/REQUIRES_REQUESTS can be set based on that. I doubt=
 we'll have
> drivers where the request caps would actually depend on the pixel format,=
 but it
> theoretically possible. For both ioctls you can call them with count=3D0 =
at the start
> of the application. REQBUFS has of course the side-effect of deleting all=
 buffers,
> but at the start of your application you don't have any yet. CREATE_BUFS =
has no
> side-effects.

My initial thoughts on this point were to have flags exposed in
v4l2_capability, but now that you're saying it, it does make sense for
the flag to be associated with a buffer rather than the global device.

In addition, I've heard of cases (IIRC it was some Rockchip platforms)
where the platform has both stateless and stateful VPUs (I think it was
stateless up to H264 and stateful for H265). This would allow supporting
these two hardware blocks under the same video device (if that makes
sense anyway). And even if there's no immediate need, it's always good
to have this level of granularity (with little drawbacks).

> I propose adding these capabilities:
>=20
> #define V4L2_BUF_CAP_HAS_REQUESTS	0x00000001
> #define V4L2_BUF_CAP_REQUIRES_REQUESTS	0x00000002
> #define V4L2_BUF_CAP_HAS_MMAP		0x00000100
> #define V4L2_BUF_CAP_HAS_USERPTR	0x00000200
> #define V4L2_BUF_CAP_HAS_DMABUF		0x00000400
>=20
> If REQUIRES_REQUESTS is set, then HAS_REQUESTS is also set.
>=20
> At this time I think that REQUIRES_REQUESTS would only need to be set for=
 the
> output queue of stateless codecs.
>=20
> If capabilities is 0, then it's from an old kernel and all you know is th=
at
> requests are certainly not supported, and that MMAP is supported. Whether=
 USERPTR
> or DMABUF are supported isn't known in that case (just try it :-) ).

Sounds good to me!

> Strictly speaking we do not need these HAS_MMAP/USERPTR/DMABUF caps, but =
it is very
> easy to add if we create a new capability field anyway, and it has always=
 annoyed
> the hell out of me that we didn't have a good way to let userspace know w=
hat
> streaming I/O modes we support. And with vb2 it's easy to implement.

I totally agree here, it would be very nice to take the occasion to
expose to userspace what I/O modes are available. The current try-and-
see approach works, but this feels much better indeed.

> Regarding point 3: I think this should be documented next to the pixel fo=
rmat. I.e.
> the MPEG-2 Slice format used by the stateless cedrus codec requires the r=
equest API
> and that two MPEG-2 controls (slice params and quantization matrices) mus=
t be present
> in each request.
>=20
> I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ) is nee=
ded here.
> It's really implied by the fact that you use a stateless codec. It doesn'=
t help
> generic applications like v4l2-ctl or qv4l2 either since in order to supp=
ort
> stateless codecs they will have to know about the details of these contro=
ls anyway.
>=20
> So I am inclined to say that it is not necessary to expose this informati=
on in
> the API, but it has to be documented together with the pixel format docum=
entation.

I think this is affected by considerations about codec profile/level
support. More specifically, some controls will only be required for
supporting advanced codec profiles/levels, so they can only be
explicitly marked with appropriate flags by the driver when the target
profile/level is known. And I don't think it would be sane for userspace
to explicitly set what profile/level it's aiming at. As a result, I
don't think we can explicitly mark controls as required or optional.

I also like the idea that it should instead be implicit and that the
documentation should detail which specific stateless metadata controls
are required for a given profile/level.

As for controls validation, the approach followed in the Cedrus driver
is to check that the most basic controls are filled and allow having
missing controls for those that match advanced profiles.

Since this approach feels somewhat generic enough to be applied to all
stateless VPU drivers, maybe this should be made a helper in the
framework?

In addition, I see a need for exposing the maximum profile/level that
the driver supports for decoding. I would suggest reusing the already-
existing dedicated controls used for encoding for this purpose. For
decoders, they would be used to expose the (read-only) maximum
profile/level that is supported by the hardware and keep using them as a
settable value in a range (matching the level of support) for encoders.

This is necessary for userspace to determine whether a given video can
be decoded in hardware or not. Instead of half-way decoding the video
(ending up in funky results), this would easily allow skipping hardware
decoding and e.g. falling back on software decoding.

What do you think?

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-cZ0BjPk2XGzN6ti5TVSG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltoA/kACgkQ3cLmz3+f
v9Fb8gf9F1B1ZsZXpPNbO42nK+nm3LJ0USDDQIOnODgai+imCgt8Fnbli3dLl3dy
HyJevch2aWbO0KdFfXtriGrDSI4kfBreSaMaL5eP/hqHBbWMCzmemHyriD9MOJiN
EQkY/mN2DZyhrp246CcB1wzRR0caPqOB7f1xqaomUB9uW5ZjyKg/wmY22K40GTUZ
z1vXiSJIqrC9TjywOO8EFIoTOjUYDkzJCmJJJS86Dp9lGmwDcNIWAdxEwc1Xa8a4
N0ZjsiGMGp8wZmtLOXLVLtbi8C8RUrScQ+rwrlqlCFoGqIlcHxCzg7ZTaXiCDRNZ
IJZJMcdp4htdwigLym4xs5aoKkM0qg==
=GKd0
-----END PGP SIGNATURE-----

--=-cZ0BjPk2XGzN6ti5TVSG--
