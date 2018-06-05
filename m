Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49684 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbeFEOHn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 10:07:43 -0400
Message-ID: <ffd6b9a1da2de45b6dc7298958a7d71bc5a22358.camel@collabora.com>
Subject: Re: [PATCH] uvcvideo: Also validate buffers in BULK mode
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Jun 2018 10:07:38 -0400
In-Reply-To: <2206409.jVpTcjFX6j@avalon>
References: <20180605002415.11421-1-nicolas.dufresne@collabora.com>
         <2206409.jVpTcjFX6j@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-Cl/GM62iaC0kqJcvIt3T"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Cl/GM62iaC0kqJcvIt3T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 05 juin 2018 =C3=A0 11:52 +0300, Laurent Pinchart a =C3=A9crit :
> Hi Nicolas,
>=20
> Thank you for the patch.
>=20
> On Tuesday, 5 June 2018 03:24:15 EEST Nicolas Dufresne wrote:
> > Just like for ISOC, validate the decoded BULK buffer size when possible=
.
> > This avoids sending corrupted or partial buffers to userspace, which ma=
y
> > lead to application crash or run-time failure.
> >=20
> > Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > ---
> >  drivers/media/usb/uvc/uvc_video.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c index aa0082fe5833..46df4d01e31b 10=
0644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -1307,8 +1307,10 @@ static void uvc_video_decode_bulk(struct urb *ur=
b,
> > struct uvc_streaming *stream, if (stream->bulk.header_size =3D=3D 0 &&
> > !stream->bulk.skip_payload) { do {
> >  			ret =3D uvc_video_decode_start(stream, buf, mem, len);
> > -			if (ret =3D=3D -EAGAIN)
> > +			if (ret =3D=3D -EAGAIN) {
> > +				uvc_video_validate_buffer(stream, buf);
> >  				uvc_video_next_buffers(stream, &buf, &meta_buf);
>=20
> Wouldn't it be simpler to move the uvc_video_validate_buffer() call to=
=20
> uvc_video_next_buffers() ?

Sounds like a good idea, it will prevent forgetting about it if this
code get extended.

>=20
> > +			}
> >  		} while (ret =3D=3D -EAGAIN);
> >=20
> >  		/* If an error occurred skip the rest of the payload. */
> > @@ -1342,8 +1344,10 @@ static void uvc_video_decode_bulk(struct urb *ur=
b,
> > struct uvc_streaming *stream, if (!stream->bulk.skip_payload && buf !=
=3D
> > NULL) {
> >  			uvc_video_decode_end(stream, buf, stream->bulk.header,
> >  				stream->bulk.payload_size);
> > -			if (buf->state =3D=3D UVC_BUF_STATE_READY)
> > +			if (buf->state =3D=3D UVC_BUF_STATE_READY) {
> > +				uvc_video_validate_buffer(stream, buf);
> >  				uvc_video_next_buffers(stream, &buf, &meta_buf);
> > +			}
> >  		}
> >=20
> >  		stream->bulk.header_size =3D 0;
>=20
>=20
--=-Cl/GM62iaC0kqJcvIt3T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWxaZKgAKCRBxUwItrAao
HO4aAJ461FpHH/Pbfo3HHoZJF6DMOs6USgCbB7ZSyvD3FaJ9c4pcYKU1zR9B70s=
=mc5c
-----END PGP SIGNATURE-----

--=-Cl/GM62iaC0kqJcvIt3T--
