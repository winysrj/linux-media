Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44439 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809Ab3IECa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Sep 2013 22:30:28 -0400
Message-ID: <1378348215.27597.14.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH v2 0/4] lirc_bt829 fixes, second try
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Thu, 05 Sep 2013 03:30:15 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-V5qWgMDdVCJ0PX1qge3/"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-V5qWgMDdVCJ0PX1qge3/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

A less ambitious set of fixes for the lirc_bt829 driver.

Ben.

Ben Hutchings (4):
  [media] lirc_bt829: Fix physical address type
  [media] lirc_bt829: Fix iomap and PCI device leaks
  [media] lirc_bt829: Enable and disable device
  [media] lirc_bt829: Note in TODO why it can't be a normal PCI driver
    yet

 drivers/staging/media/lirc/TODO         |  5 +++++
 drivers/staging/media/lirc/lirc_bt829.c | 33 +++++++++++++++++++++++++++--=
----
 2 files changed, 32 insertions(+), 6 deletions(-)



--=-V5qWgMDdVCJ0PX1qge3/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUifst+e/yOyVhhEJAQp/gg/9EZjYCEp5WoaAaZXfjPdHBCq1d6/1bvxF
GE+r7JhjSxt+Un98cJOwF18WcaLcZUCGzlkwiizVrZ0cRjToyFRTvtv1nAUNeyJn
FSK+v6WHcR/GG65ycEMqK9vJA39qsVFI7Aa5urC2cjXoMZ/86D0Aao8UKoYB67dC
zGC4XQMxj2kSwA/Vu4PAOHJ6iLJYjdvXjCa+0zjE4Y8PqHStBsHYtE14typbNL0M
g6iuyRW6dWnXWrKO7nL0d1HvcH2IHhIjkvLuP0y1OhH8OZIGigm551yci/F2/lZE
eGuff1PGpT+k0J2GZ9WKWpQJRev9RE4kPv16GDnC3gHjics2jQK4hSFsEAxGHuKP
s5GCZYvcwUlZ2S6MeisEznXFHWlXbO0P1l+N1ADeTUE3qFqi4gz49srzspXSx1Dr
NSND9+6MnCbrpzjNHM7j5Hs8at6FG9vS07ANoBuufnQs+dPKg8iK6diccMg2sxNx
N5YHCq+VtRQv/y7cErQYS7fVb5o97WpLPM/tX9loMKnmFcT121kT8eufEqkk+hp6
u+kb5UwWFa6VCg6PJs5hjt49DE4vjKYLzhZwMAe+IklFLljpevp2XJh2Zd+BtPTW
FS5AiWJhMBuvkChi2hpji/XOTu+Y9qBVYj+wLdAoV9vvKtcCE0jlwGSPhK0e6Qj6
Ds9BC/yOVPQ=
=nuMU
-----END PGP SIGNATURE-----

--=-V5qWgMDdVCJ0PX1qge3/--
