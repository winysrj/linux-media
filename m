Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:42178 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbeJXTLa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Oct 2018 15:11:30 -0400
Message-ID: <6ec9238a952c428b07da5a1e392e4d7b600fac37.camel@paulk.fr>
Subject: Re: [RFC] Stateless codecs: how to refer to reference frames
From: Paul Kocialkowski <contact@paulk.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 24 Oct 2018 12:44:28 +0200
In-Reply-To: <a02b50ee-37e1-0202-b999-8e32b7bd1a96@xs4all.nl>
References: <20181019080928.208446-1-acourbot@chromium.org>
         <a02b50ee-37e1-0202-b999-8e32b7bd1a96@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ZDbRHXgDOFbsTxIYZqiK"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ZDbRHXgDOFbsTxIYZqiK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 19 octobre 2018 =C3=A0 11:40 +0200, Hans Verkuil a =C3=A9crit :
> From Alexandre's '[RFC PATCH v3] media: docs-rst: Document m2m stateless
> video decoder interface':
>=20
> On 10/19/18 10:09, Alexandre Courbot wrote:
> > Two points being currently discussed have not been changed in this
> > revision due to lack of better idea. Of course this is open to change:
>=20
> <snip>
>=20
> > * The other hot topic is the use of capture buffer indexes in order to
> >   reference frames. I understand the concerns, but I doesn't seem like
> >   we have come with a better proposal so far - and since capture buffer=
s
> >   are essentially well, frames, using their buffer index to directly
> >   reference them doesn't sound too inappropriate to me. There is also
> >   the restriction that drivers must return capture buffers in queue
> >   order. Do we have any concrete example where this scenario would not
> >   work?
>=20
> I'll stick to decoders in describing the issue. Stateless encoders probab=
ly
> do not have this issue.
>=20
> To recap: the application provides a buffer with compressed data to the
> decoder. After the request is finished the application can dequeue the
> decompressed frame from the capture queue.
>=20
> In order to decompress the decoder needs to access previously decoded
> reference frames. The request passed to the decoder contained state
> information containing the buffer index (or indices) of capture buffers
> that contain the reference frame(s).
>=20
> This approach puts restrictions on the framework and the application:
>=20
> 1) It assumes that the application can predict the capture indices.
> This works as long as there is a simple relationship between the
> buffer passed to the decoder and the buffer you get back.
>=20
> But that may not be true for future codecs. And what if one buffer
> produces multiple capture buffers? (E.g. if you want to get back
> decompressed slices instead of full frames to reduce output latency).

I don't really understand how there could be multiple capture buffers
for the same frame used as reference here. I believe the stateless VPU
API should make it a hard requirement that reference frames must be
fully held in a single capture buffer. This is because the hardware
will generally expect one address for the reference frame (that's
definitely the case for Cedrus: we cannot deal with reference frames if
each reference is scattered accross multiple buffers).

So I don't believe it's a problem to associate a reference frame and a
single capture buffer for the stateless VPU case. Rather that it should
be specified as a requriement of the API.

I don't see any problem with allowing multiple output buffers though
(that should then be rendered to the same capture buffer), so the 1:1
relationship between output and capture cannot be assumed either way.

> This API should be designed to be future-proof (within reason of course),
> and I am not at all convinced that future codecs will be just as easy
> to predict.
>=20
> 2) It assumes that neither drivers nor applications mess with the buffers=
.
> One case that might happen today is if the DMA fails and a buffer is
> returned marked ERROR and the DMA is retried with the next buffer. There
> is nothing in the spec that prevents you from doing that, but it will mes=
s
> up the capture index numbering. And does the application always know in
> what order capture buffers are queued? Perhaps there are two threads: one
> queueing buffers with compressed data, and the other dequeueing the
> decompressed buffers, and they are running mostly independently.
>=20
> I believe that assuming that you can always predict the indices of the
> capture queue is dangerous and asking for problems in the future.

I agree, assuming that userspace can predict the matching capture
buffer index seems very fragile.=20

> I am very much in favor of using a dedicated cookie. The application sets
> it for the compressed buffer and the driver copies it to the uncompressed
> capture buffer. It keeps track of the association between capture index
> and cookie. If a compressed buffer decompresses into multiple capture
> buffers, then they will all be associated with the same cookie, so
> that simplifies how you refer to reference frames if they are split
> over multiple buffers.

This seems like a great idea, I'm all for it!

> The codec controls refer to reference frames by cookie(s).
>=20
> For existing applications that use the capture index all you need to do
> is to set the capture index as the cookie value in the output buffer.
>=20
> It is my understanding that ChromeOS was using the timestamp as the
> cookie value.
>=20
> I have thought about that, but I am not in favor of doing that. One
> reason is that struct timeval comes in various flavors (32 bit, 64 bit,
> and a y2038-compatible 32-bit type in the future).
>=20
> The y2038 compat code that we will need concerns me in particular since
> it will mean that the timeval is converted from 32 to 64 bit and back
> again, and that might well mangle the data. I'm not so sure if you can
> stick a 64-bit pointer in the timeval (e.g. the high 32 bits go to into
> the tv_sec field, the low 32 bits go to the usecs). The y2038 conversion
> might mangle the tv_usec field (e.g. divide by 1000000 and add the second=
s
> to the tv_sec field).
>=20
> I would really prefer an independent 64-bit cookie value that the applica=
tion
> can set instead of abusing something else.
>=20
> I propose to make a union with v4l2_timecode (which nobody uses) and a
> new V4L2_BUF_FLAG_COOKIE flag.
>=20
> struct v4l2_buffer_cookie {
> 	__u32 high;
> 	__u32 low;
> };
>=20
> And in v4l2_buffer:
>=20
> 	union {
> 		struct v4l2_timecode timecode;
> 		struct v4l2_buffer_cookie cookie;
> 	};
>=20
> And static inlines:
>=20
> void v4l2_buffer_set_cookie(struct v4l2_buffer *buf, __u64 cookie)
> {
> 	buf->cookie.high =3D cookie >> 32;
> 	buf->cookie.low =3D cookie & 0xffffffffULL;
> 	buf->flags |=3D V4L2_BUF_FLAG_COOKIE;
> }
>=20
> void v4l2_buffer_set_cookie_ptr(struct v4l2_buffer *buf, void *cookie)
> {
> 	v4l2_buffer_set_cookie(buf, (__u64)cookie);
> }
>=20
> __u64 v4l2_buffer_get_cookie(struct v4l2_buffer *buf)
> {
> 	if (!(buf->flags & V4L2_BUF_FLAG_COOKIE))
> 		return 0;
> 	return (((__u64)buf->cookie.high) << 32) | (__u64)buf->cookie.low;
> }
>=20
> void *v4l2_buffer_get_cookie_ptr(struct v4l2_buffer *buf)
> {
> 	return (void *)v4l2_buffer_get_cookie(buf);
> }
>=20
> Why not just use __u64? Because the alignment in v4l2_buffer is a nightma=
re.
> Using __u64 would create holes, made even worse by different struct timev=
al
> sizes depending on the architecture.
>=20
> I'm proposing a struct v4l2_ext_buffer together with new streaming ioctls
> during the media summit that has a clean layout and there this can be jus=
t
> a __u64.
>=20
> I'm calling it a 'cookie' here, but that's just a suggestion. Better
> names are welcome.

Cheers,

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-ZDbRHXgDOFbsTxIYZqiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAlvQTQwACgkQhP3B6o/u
lQyR6A//YZ2aTeJcgGKBMV/PdqAnWjnxTSD0MRcq1McM5htWM+MZDEdM64z3Kv/P
2AqWFflRimc63Bd+fl/H0YdmSlINj/j79SLy0+bPK8AjFr+kF4dXADMnbZKVV9fZ
emlzulu/pzNhf3IWEaeqA1zOw9TQ0b6gaf3l7jTuMgtsBgXyLJaEMFVBRhhIYNU7
iOXW681DuJzvp8ylnPOrhyzdalAqy0ANxKk9mqU9PXWXB8+1YZyK1gj4ZOl3CBiS
iH9hpEi5fF2jsm7Hpb7CHq4kTaVDa5XFd8+r43RFI1rXHqtCnMD7D2iw/oeWPJw8
uy+0RgmeZolyP2CbiaH1cQBl9FBWaH/6V29BA53ecyTS+t3UlAJKmrRZ1ALMm6m2
8nB/pJh9T3BfZCFZ1ehY1eAYbKNIEJwvkrrIrrXAbUHnBBq5GOXyyLD4hyB9lzTl
S/Yg9KofCTszhSI4ZLWyZUpChO/COKu+KyTbacMEGbnBLnPpjZpLtD+18yce2A5b
xRhHpEMSPCYea1lDtnzPs7cpi2Su62ANNfsLjU+5fNDNDmzJiUHUioyBMTs/5T2Q
sL16TAKUnSO5fdDIk6nYfg7oS8ZS60oJLmDmZarB7bqjHnQFOs89FsQrfbjbnSFJ
TE7+4qDNRQee5IwM16m+GZ7vMoL6B3DN4oyZtX3ZF5fKNHrGCz0=
=MB8T
-----END PGP SIGNATURE-----

--=-ZDbRHXgDOFbsTxIYZqiK--
