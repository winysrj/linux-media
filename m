Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44365 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763059Ab3IECDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Sep 2013 22:03:55 -0400
Message-ID: <1378346623.27597.13.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 0/4] [media] Make lirc_bt829 a well-behaved PCI driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Thu, 05 Sep 2013 03:03:43 +0100
In-Reply-To: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
References: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-7bCOXC2NigCGr2S7a8+K"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-7bCOXC2NigCGr2S7a8+K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-09-02 at 01:36 +0100, Ben Hutchings wrote:
> I noticed lirc_bt829 didn't have a module device ID table, so I set out
> to fix that and ended up with this series.
>=20
> It still appears to do everything else wrong (like reinventing
> i2c-algo-bit) though...
>=20
> This is compile-tested only.

On reflection, I think it might be better to leave this driver 'badly
behaved'.  It wants to use registers on a Mach64 VT, which has a
separate kernel framebuffer driver (atyfb) and userland X driver
(mach64).  If this driver is compatible with them now, changing it is
liable to break that.

I'll repost the minor fixes.

Ben.

--=20
Ben Hutchings
Knowledge is power.  France is bacon.

--=-7bCOXC2NigCGr2S7a8+K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUifmf+e/yOyVhhEJAQrJvg//fY/f1KQ4pV71FmswLCC2U2i2S8rhikrk
etzB57f50jXMvVv7ZAucvhv6Q5hzI6+adM/iKFrg9gxY67i8IPSRhzN91tOr/DXW
1nIyb/VUewPF/tev6EbCo1RnH1+ST+/cRahnnmiQwfxzHw+HXYhsPYYN9hQ+u8tj
3zCf2YWuT1Mxv0+EcwLX64JREYiB7qgErf11+4Ky09tqnzBlB5m7dl8xv0ZLJOUw
CnSVi90eeE6Soli8LpnfZSaXc7d2jvKfT2iMG13c7ErGo033WU+hxMhaXx8Edy84
F+APaqAc9P6UqA7zVRYoxyvzqemv8Kvh2QBMwh7yIKG8kx2ZxLNDDm9wjU57CrnI
vfNff6f0eeKcjgLXLeOBrVe0YO3jgHuBL1LbrDk+gYPEPM1T6KR6XGVND4lGXrKU
FRb54iUsPosMuVi7iSaNRGEBZWj6ofivbcL7MVYhEWxA3qCAevYbAeHBp7clM4/2
YmxourNve9Emr7dWSrHlVV2s7E2bjnEyEaz/+hUYu5gwHKFEtau8Tu5I8A6LttuN
Uxu9MPvModfG6Y7Zppo8HoyPh6QzbAffMyuL0ap2bWe+AAMJmryh5M3bgyU5O74B
QokgDn56nV7QA7m5gseD7/jIYJPY4aI2aPyb6lAGujAEnsOclg9FpBFgXMZHVipv
SBJXX/569Go=
=KIb8
-----END PGP SIGNATURE-----

--=-7bCOXC2NigCGr2S7a8+K--
