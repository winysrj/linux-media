Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:58372 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631Ab3JQTbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 15:31:10 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: Add BCM2048 radio driver
Date: Thu, 17 Oct 2013 21:31:04 +0200
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
	Nils Faerber <nils.faerber@kernelconcepts.de>,
	Joni Lapilainen <joni.lapilainen@gmail.com>
References: <1381847218-8408-1-git-send-email-pali.rohar@gmail.com> <525D5A77.4050704@xs4all.nl>
In-Reply-To: <525D5A77.4050704@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2126331.EpyfVm5nKJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201310172131.05106@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart2126331.EpyfVm5nKJ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

so what do you suggest? Add it to staging for now (or not)?

On Tuesday 15 October 2013 17:08:39 Hans Verkuil wrote:
> Hi Pali,
>=20
> Thanks for the patch, but I am afraid it will need some work
> to make this acceptable for inclusion into the kernel.
>=20
> The main thing you need to do is to implement all the controls
> using the control framework (see
> Documentation/video4linux/v4l2-controls.txt). Most drivers
> are by now converted to the control framework, so you will
> find many examples of how to do this in drivers/media/radio.
>=20
> The sysfs stuff should be replaced by controls as well. A lot
> of the RDS support is now available as controls (although
> there may well be some missing features, but that is easy
> enough to add). Since the RDS data is actually read() from
> the device I am not sure whether the RDS properties/controls
> should be there at all.
>=20
> Finally this driver should probably be split up into two
> parts: one v4l2_subdev-based core driver and one platform
> driver. See e.g. radio-si4713/si4713-i2c.c as a good example.
> But I would wait with that until the rest of the driver is
> cleaned up. Then I have a better idea of whether this is
> necessary or not.
>=20
> It's also very useful to run v4l2-compliance (available in the
> v4l-utils.git repo on git.linuxtv.org). That does lots of
> sanity checks.
>=20
> Another option is to add the driver as-is to
> drivers/staging/media, and clean it up bit by bit.
>=20
> Regards,
>=20
> 	Hans
>=20
> On 10/15/2013 04:26 PM, Pali Roh=C3=A1r wrote:
> > This adds support for the BCM2048 radio module found in
> > Nokia N900
> >=20
> > Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
> > Signed-off-by: Nils Faerber <nils.faerber@kernelconcepts.de>
> > Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >  drivers/media/radio/Kconfig         |   10 +
> >  drivers/media/radio/Makefile        |    1 +
> >  drivers/media/radio/radio-bcm2048.c | 2744
> >  +++++++++++++++++++++++++++++++++++
> >  include/media/radio-bcm2048.h       |   30 +
> >  4 files changed, 2785 insertions(+)
> >  create mode 100644 drivers/media/radio/radio-bcm2048.c
> >  create mode 100644 include/media/radio-bcm2048.h
> >=20

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2126331.EpyfVm5nKJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlJgOvkACgkQi/DJPQPkQ1JXvgCdGFp6l+xrq5y10srybawMUOlI
iuUAoIAIJmy932MYACnEuwjZ9OTwTyOJ
=/Nhc
-----END PGP SIGNATURE-----

--nextPart2126331.EpyfVm5nKJ--
