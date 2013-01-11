Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34041 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3AKMhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 07:37:13 -0500
Message-ID: <1357907830.24751.2.camel@thor.lan>
Subject: Re: FIMC/CAMIF V4L2 driver
From: Sebastian =?ISO-8859-1?Q?Dr=F6ge?=
	<sebastian.droege@collabora.co.uk>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: sylvester.nawrocki@gmail.com, LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Date: Fri, 11 Jan 2013 13:37:10 +0100
In-Reply-To: <50EFF6E3.4090302@samsung.com>
References: <1356685333.4296.92.camel@thor.lan>
	 <50EFEBF7.4080801@samsung.com> <1357902525.6914.139.camel@thor.lan>
	 <50EFF6E3.4090302@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-J7p/USEgbf1uHe2dijJc"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-J7p/USEgbf1uHe2dijJc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fr, 2013-01-11 at 12:26 +0100, Sylwester Nawrocki wrote:
> Hi,
>=20
> On 01/11/2013 12:08 PM, Sebastian Dr=C3=B6ge wrote:
> > I can't test the patch right now but it should do almost the right
> > thing. IMHO for the chroma planes the bytesperline should be (width
> > +1)/2, otherwise you'll miss one chroma value per line for odd widths.
>=20
> Odd widths are not allowed, the driver will adjust width to be multiple
> of 16 pixels. However, you can adjust the usable area more precisely with
> VIDIOC_S_CROP or VIDIOC_S_SELECTION ioctl. I still need to do some work t=
o
> define properly the selection ioctl on mem-to-mem devices in the V4L2
> documentation.

Ok, thanks for the information :)

> > However I also noticed another bug. Currently S_FMT happily allows
> > V4L2_PIX_FMT_BGR32, V4L2_PIX_FMT_BGR24, V4L2_PIX_FMT_RGB24 and probably
> > others. But the output will be distorted and useless.
> > (V4L2_PIX_FMT_RGB32 works perfectly fine)
>=20
> This shouldn't really happen. Are you checking pixelformat after VIDIOC_S=
_FMT
> call ? Isn't it adjusted to some valid and supported by the driver format=
 ?

Good point, I didn't check it... but was assuming that the ioctl() would
instead fail. Thanks a lot!

--=-J7p/USEgbf1uHe2dijJc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlDwB3YACgkQBsBdh1vkHyH87gCgq8TfIl163lqeLPOYyXSJWgB3
AN0An2YS78lJYBuIZTd2ULzeXF5YRAPF
=3N0+
-----END PGP SIGNATURE-----

--=-J7p/USEgbf1uHe2dijJc--

