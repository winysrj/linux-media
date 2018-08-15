Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:39678 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729265AbeHOR3c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 13:29:32 -0400
Received: by mail-qt0-f179.google.com with SMTP id q12-v6so1373835qtp.6
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2018 07:37:07 -0700 (PDT)
Message-ID: <9ecc3c7a03dde92b3a684f729587c0abede9277a.camel@ndufresne.ca>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Wed, 15 Aug 2018 10:37:04 -0400
In-Reply-To: <20180815091115.1abd814d@coco.lan>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <20180815091115.1abd814d@coco.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-C8UXFm+/O4j5wQZW/st6"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-C8UXFm+/O4j5wQZW/st6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 15 ao=C3=BBt 2018 =C3=A0 09:11 -0300, Mauro Carvalho Chehab a =
=C3=A9crit :
> Em Sat, 4 Aug 2018 15:50:04 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>=20
> > Hi all,
> >=20
> > While the Request API patch series addresses all the core API
> > issues, there
> > are some high-level considerations as well:
> >=20
> > 1) How can the application tell that the Request API is supported
> > and for
> >    which buffer types (capture/output) and pixel formats?
> >=20
> > 2) How can the application tell if the Request API is required as
> > opposed to being
> >    optional?
>=20
> Huh? Why would it be mandatory?
>=20
> >=20
> > 3) Some controls may be required in each request, how to let
> > userspace know this?
> >    Is it even necessary to inform userspace?
>=20
> Again, why would it need to have a set of mandatory controls for
> requests
> to work? If this is really required,  it should have a way to send
> such
> list to userspace.
>=20
> >=20
> > 4) (For bonus points): How to let the application know which
> > streaming I/O modes
> >    are available? That's never been possible before, but it would
> > be very nice
> >    indeed if that's made explicit.
> >=20
> > Since the Request API associates data with frame buffers it makes
> > sense to expose
> > this as a new capability field in struct v4l2_requestbuffers and
> > struct v4l2_create_buffers.
> >=20
> > The first struct has 2 reserved fields, the second has 8, so it's
> > not a problem to
> > take one for a capability field. Both structs also have a buffer
> > type, so we know
> > if this is requested for a capture or output buffer type. The pixel
> > format is known
> > in the driver, so HAS/REQUIRES_REQUESTS can be set based on that. I
> > doubt we'll have
> > drivers where the request caps would actually depend on the pixel
> > format, but it
> > theoretically possible. For both ioctls you can call them with
> > count=3D0 at the start
> > of the application. REQBUFS has of course the side-effect of
> > deleting all buffers,
> > but at the start of your application you don't have any yet.
> > CREATE_BUFS has no
> > side-effects.
> >=20
> > I propose adding these capabilities:
> >=20
> > #define V4L2_BUF_CAP_HAS_REQUESTS	0x00000001
>=20
> I'm OK with that.
>=20
> > #define V4L2_BUF_CAP_REQUIRES_REQUESTS	0x00000002
>=20
> But I'm not ok with breaking even more userspace support by forcing=20
> requests.

This is not breaking userspace, not in regard to state-less CODEC.
Stateless CODECs uses a set of new pixel formats specifically designed
for driving an accelerator rather then a full CODEC.

The controls are needed to provide a state to the accelerator, so the
accelerator knows what to do. Though, because of the nature of CODECs,
queuing multiple buffers is strictly needed. Without the request, there
is no way to figure-out which CID changes goes with which picture.

There is no way an existing userspace will break as there is no way it
can support these drivers as a) the formats aren't defined yet b) the
CIDs didn't exist.=20

>=20
> > #define V4L2_BUF_CAP_HAS_MMAP		0x00000100
> > #define V4L2_BUF_CAP_HAS_USERPTR	0x00000200
> > #define V4L2_BUF_CAP_HAS_DMABUF		0x00000400
>=20
> Those sounds ok to me too.
>=20
> >=20
> > If REQUIRES_REQUESTS is set, then HAS_REQUESTS is also set.
> >=20
> > At this time I think that REQUIRES_REQUESTS would only need to be
> > set for the
> > output queue of stateless codecs.
>=20
> Same as before: I don't see the need of support a request-only
> driver.
>=20
> >=20
> > If capabilities is 0, then it's from an old kernel and all you know
> > is that
> > requests are certainly not supported, and that MMAP is supported.
> > Whether USERPTR
> > or DMABUF are supported isn't known in that case (just try it :-)
> > ).
> >=20
> > Strictly speaking we do not need these HAS_MMAP/USERPTR/DMABUF
> > caps, but it is very
> > easy to add if we create a new capability field anyway, and it has
> > always annoyed
> > the hell out of me that we didn't have a good way to let userspace
> > know what
> > streaming I/O modes we support. And with vb2 it's easy to
> > implement.
>=20
> Yeah, that sounds a bonus to me too.
>=20
> > Regarding point 3: I think this should be documented next to the
> > pixel format. I.e.
> > the MPEG-2 Slice format used by the stateless cedrus codec requires
> > the request API
> > and that two MPEG-2 controls (slice params and quantization
> > matrices) must be present
> > in each request.
>=20
> Makes sense to document with the pixel format...
>=20
> > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ)
> > is needed here.
>=20
> but it sounds worth to also have a flag.
>=20
> > It's really implied by the fact that you use a stateless codec. It
> > doesn't help
> > generic applications like v4l2-ctl or qv4l2 either since in order
> > to support
> > stateless codecs they will have to know about the details of these
> > controls anyway.
>=20
> Yeah, but they could skip enum those ioctls if they see one marked
> with
> V4L2_CTRL_FLAG_REQUIRED_IN_REQ and don't know how to use. Then,
> default
> to not use request API.=20
>=20
> Then, the driver would use a default that would work (even not
> providing
> the best possible compression).
>=20
> > So I am inclined to say that it is not necessary to expose this
> > information in
> > the API, but it has to be documented together with the pixel format
> > documentation.
> >=20
> > Comments? Ideas?
> >=20
> > Regards,
> >=20
> > 	Hans
>=20
> Thanks,
> Mauro

--=-C8UXFm+/O4j5wQZW/st6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW3Q6kAAKCRBxUwItrAao
HKSqAKCtnVkjZLUFopLychXxe4HRs6ZWogCeOFPJeWO24czQovFwOF8xMrcRF/0=
=n1cG
-----END PGP SIGNATURE-----

--=-C8UXFm+/O4j5wQZW/st6--
