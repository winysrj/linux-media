Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:33772 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbeHORUJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 13:20:09 -0400
Received: by mail-qt0-f174.google.com with SMTP id c15-v6so1359379qtp.0
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2018 07:27:46 -0700 (PDT)
Message-ID: <f3cc7684a8ff9c0a34131cfd3fd8f979b5dd82f5.camel@ndufresne.ca>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Wed, 15 Aug 2018 10:27:43 -0400
In-Reply-To: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-xgdt7wZcN6LZJf4u/AJy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-xgdt7wZcN6LZJf4u/AJy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le samedi 04 ao=C3=BBt 2018 =C3=A0 15:50 +0200, Hans Verkuil a =C3=A9crit :
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

For state-less codec, there is a very strict set of controls that must
be supported / filled. The data format pretty much dictate this.

For complex camera's and video transformation m2m devices, there is a
gap indeed. Duplicating the formats for this case does not seem like
the right approach.

>=20
> 4) (For bonus points): How to let the application know which streaming I/=
O modes
>    are available? That's never been possible before, but it would be very=
 nice
>    indeed if that's made explicit.

In GStreamer, we call REQBUFS(type, count=3D0) for each types we support.
This call should never fail, unless the type is not supported. We build
a list of supported I/O mode this way. It's also a no-op, because we
didn't allocate any buffers yet.

>=20
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
>=20
> I propose adding these capabilities:
>=20
> #define V4L2_BUF_CAP_HAS_REQUESTS	0x00000001
> #define V4L2_BUF_CAP_REQUIRES_REQUESTS	0x00000002
> #define V4L2_BUF_CAP_HAS_MMAP		0x00000100
> #define V4L2_BUF_CAP_HAS_USERPTR	0x00000200
> #define V4L2_BUF_CAP_HAS_DMABUF		0x00000400

Looks similar to the bit map we create inside GStreamer using the
described technique. Though we also add HAS_CREATE_BUFS to the lot.

My main concern is in userspace like GStreamer, the difficulty is to
sort drivers that we support, from the ones that we don't. So if we
don't support requests yet, we would like to detect this early. As
CODEC don't really have an initial format, I believe that before S_FMT,
any kind of call to REQBUFS might fail at the moment. So detection
would be very late.

Thoughm be aware this is a totally artificial issue in the short term
since state-less CODEC uses dedicated formats.

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

Just a clarification, the doc is pretty clear the MMAP is supported if
the device capability have STREAMING in it.

>=20
> Strictly speaking we do not need these HAS_MMAP/USERPTR/DMABUF caps, but =
it is very
> easy to add if we create a new capability field anyway, and it has always=
 annoyed
> the hell out of me that we didn't have a good way to let userspace know w=
hat
> streaming I/O modes we support. And with vb2 it's easy to implement.
>=20
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

Right, I don't think this is needed in the short term, as we target
only stateless CODEC. But this is important use case for let's say
request to cameras. When we get there, we will need a mechnism to
list all the controls that can be included in a request, and also all
the only the must be present (if any).

>=20
> So I am inclined to say that it is not necessary to expose this informati=
on in
> the API, but it has to be documented together with the pixel format docum=
entation.

I'd prefer to say it's not urgent.

>=20
> Comments? Ideas?
>=20
> Regards,
>=20
> 	Hans

--=-xgdt7wZcN6LZJf4u/AJy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW3Q4YAAKCRBxUwItrAao
HJgmAKCckTOfxuw1dUQFw7o8D5iDyYOPiQCg1XyBXwBXKFzAk9otLckG4Yj4Jgw=
=8a1O
-----END PGP SIGNATURE-----

--=-xgdt7wZcN6LZJf4u/AJy--
