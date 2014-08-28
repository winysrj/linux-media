Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49903 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaH1OsW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 10:48:22 -0400
Date: Thu, 28 Aug 2014 09:48:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_uvc fix transition to video_ioctl2
Message-ID: <20140828144803.GK16689@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408381577-31901-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <1409152598-21046-1-git-send-email-andrzej.p@samsung.com>
 <3446993.TiqE0KXHj7@avalon>
 <53FF3F1F.6090806@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sU4rRG038CsJurvk"
Content-Disposition: inline
In-Reply-To: <53FF3F1F.6090806@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--sU4rRG038CsJurvk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2014 at 04:39:27PM +0200, Andrzej Pietrasiewicz wrote:
> W dniu 28.08.2014 o 13:28, Laurent Pinchart pisze:
>=20
> <snip>
>=20
> >>diff --git a/drivers/usb/gadget/function/f_uvc.c
> >>b/drivers/usb/gadget/function/f_uvc.c index 5209105..95dc1c6 100644
> >>--- a/drivers/usb/gadget/function/f_uvc.c
> >>+++ b/drivers/usb/gadget/function/f_uvc.c
> >>@@ -411,6 +411,7 @@ uvc_register_video(struct uvc_device *uvc)
> >>  	video->fops =3D &uvc_v4l2_fops;
> >>  	video->ioctl_ops =3D &uvc_v4l2_ioctl_ops;
> >>  	video->release =3D video_device_release;
> >>+	video->vfl_dir =3D VFL_DIR_TX;
> >
> >Do you have any objection against squashing this patch into "usb: gadget:
> >f_uvc: Move to video_ioctl2" ?
> >
> Not at all. Feel free to squash it.

This is in my testing/fixes, though. I'll drop it from there.

--=20
balbi

--sU4rRG038CsJurvk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/0EjAAoJEIaOsuA1yqREkEQQALaTKIX1fO1iqeJXqXdRlmzC
fYAxR0/Cpt1/9VAEU2/ybzTu6QRf/08P/y9WDW4NfFVEd1LS8CQV0muag2yYpPf+
oEzZUZ3KUx6GGVH/RvHO2ENiQEa5bWFuJnZ1f2xS3+kywtH5s4Y+2ypq/z+CiX99
BthVNJi0FdBIf6tl1UJweS0olCpuBRGmGL8f7Jie2+p7uRJfNRqJj0hDZRezjsqV
+b9dq40rmRBfaZU7fMlsqTKCAcJoh3G6kJeoVzAusOKP0wrXBwODcaj3lCI+XC0C
5Dk8FjP011bda1bVto9GEJk5gknDPYBSkr3Lore80csc099BN56N5rCzDGtUBsDM
qvVVXK761K2GHyb5qbboJI/K3j2/ysXswIAkGF7En72fF89w+1h0gAzwZ9CkkQX8
GSjSYkGP/pD6gYwj4SBunbk+fFhsNSatJ+2+aTHub2MiwWuzgdF9UygiQr3zyJGj
McaApUXPfvhgyMqmE44G5TQqXeoRSMI8nprRQbmL5haOeQiVtbirU1swexSMLPaj
3kV+QZavafPnDmXiV1g/d37V6O/bZoyFqUW05NhzpJeVTF9zCdWZfKGvu/bAsr9d
4QayYSrTIqxyltv6Gny3HSUjACXpo2zitKpKWzS/+uvqREEmJ3cULywC9xM3Q8ei
FfOJfDrRILyVbg5Zq9hx
=N0j2
-----END PGP SIGNATURE-----

--sU4rRG038CsJurvk--
