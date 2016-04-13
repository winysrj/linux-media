Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47607 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbcDMP5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 11:57:41 -0400
Message-ID: <1460563054.18956.4.camel@collabora.com>
Subject: Re: [PATCH] uvc: Fix bytesperline calculation for planar YUV
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Date: Wed, 13 Apr 2016 11:57:34 -0400
In-Reply-To: <4325164.Ph5FqXt1zq@avalon>
References: <1452199428-3513-1-git-send-email-nicolas.dufresne@collabora.com>
	 <4325164.Ph5FqXt1zq@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-JqhcbHOE2ggzrvamo3Sd"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-JqhcbHOE2ggzrvamo3Sd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 13 avril 2016 =C3=A0 17:36 +0300, Laurent Pinchart a =C3=A9crit=
=C2=A0:
> Hi Nicolas,
>=20
> Thank you for the patch.
>=20
> On Thursday 07 Jan 2016 15:43:48 Nicolas Dufresne wrote:
> >=20
> > The formula used to calculate bytesperline only works for packed
> > format.
> > So far, all planar format we support have their bytesperline equal
> > to
> > the image width (stride of the Y plane or a line of Y for M420).
> >=20
> > Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > ---
> > =C2=A0drivers/media/usb/uvc/uvc_v4l2.c | 18 ++++++++++++++++--
> > =C2=A01 file changed, 16 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > b/drivers/media/usb/uvc/uvc_v4l2.c index d7723ce..ceb1d1b 100644
> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > @@ -142,6 +142,20 @@ static __u32 uvc_try_frame_interval(struct
> > uvc_frame
> > *frame, __u32 interval) return interval;
> > =C2=A0}
> >=20
> > +static __u32 uvc_v4l2_get_bytesperline(struct uvc_format *format,
> > +	struct uvc_frame *frame)
> I'd make the two parameters const.

I agree.

>=20
> >=20
> > +{
> > +	switch (format->fcc) {
> > +	case V4L2_PIX_FMT_NV12:
> > +	case V4L2_PIX_FMT_YVU420:
> > +	case V4L2_PIX_FMT_YUV420:
> > +	case V4L2_PIX_FMT_M420:
> > +		return frame->wWidth;
> > +	default:
> > +		return format->bpp * frame->wWidth / 8;
> > +	}
> > +}
> > +
> > =C2=A0static int uvc_v4l2_try_format(struct uvc_streaming *stream,
> > =C2=A0	struct v4l2_format *fmt, struct uvc_streaming_control
> > *probe,
> > =C2=A0	struct uvc_format **uvc_format, struct uvc_frame
> > **uvc_frame)
> > @@ -245,7 +259,7 @@ static int uvc_v4l2_try_format(struct
> > uvc_streaming
> > *stream, fmt->fmt.pix.width =3D frame->wWidth;
> > =C2=A0	fmt->fmt.pix.height =3D frame->wHeight;
> > =C2=A0	fmt->fmt.pix.field =3D V4L2_FIELD_NONE;
> > -	fmt->fmt.pix.bytesperline =3D format->bpp * frame->wWidth /
> > 8;
> > +	fmt->fmt.pix.bytesperline =3D
> > uvc_v4l2_get_bytesperline(format, frame);
> > =C2=A0	fmt->fmt.pix.sizeimage =3D probe->dwMaxVideoFrameSize;
> > =C2=A0	fmt->fmt.pix.colorspace =3D format->colorspace;
> > =C2=A0	fmt->fmt.pix.priv =3D 0;
> > @@ -282,7 +296,7 @@ static int uvc_v4l2_get_format(struct
> > uvc_streaming
> > *stream, fmt->fmt.pix.width =3D frame->wWidth;
> > =C2=A0	fmt->fmt.pix.height =3D frame->wHeight;
> > =C2=A0	fmt->fmt.pix.field =3D V4L2_FIELD_NONE;
> > -	fmt->fmt.pix.bytesperline =3D format->bpp * frame->wWidth /
> > 8;
> > +	fmt->fmt.pix.bytesperline =3D
> > uvc_v4l2_get_bytesperline(format, frame);
> > =C2=A0	fmt->fmt.pix.sizeimage =3D stream->ctrl.dwMaxVideoFrameSize;
> > =C2=A0	fmt->fmt.pix.colorspace =3D format->colorspace;
> > =C2=A0	fmt->fmt.pix.priv =3D 0;
> This looks good to me otherwise.
>=20
> If it's fine with you I can fix the above issue while applying.

That would be really nice.

thanks,
Nicolas
--=-JqhcbHOE2ggzrvamo3Sd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlcObG4ACgkQcVMCLawGqBwCSQCePq6DOwwyGerOuXKfk8n/uaoO
gasAoIZDrtRefaRBx7fcs+BAZNDqwGTq
=C7ia
-----END PGP SIGNATURE-----

--=-JqhcbHOE2ggzrvamo3Sd--

