Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:49536 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760671Ab2EKPB3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 11:01:29 -0400
Date: Fri, 11 May 2012 17:01:24 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v2 0/3] gspca - ov534: saturation and hue (using
 fixp-arith.h)
Message-Id: <20120511170124.5d6f2726c62dd67423f29a72@studenti.unina.it>
In-Reply-To: <1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
References: <20120505102614.31395c2979f0b7aac0c8a107@studenti.unina.it>
	<1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__11_May_2012_17_01_24_+0200_KE4lbiThZL9QMWOC"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__11_May_2012_17_01_24_+0200_KE4lbiThZL9QMWOC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun,  6 May 2012 12:14:55 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Hi,
>=20
> I am sending a second version of this patchset, changes since version 1 a=
re
> annotated per-patch.
>=20
> Just FYI I intend to work on porting ov534 to v4l2 framework too once the=
se
> ones go in and the gspca core changes about that settle a bit.
>=20
> Thanks,
>    Antonio
>

Ping.

Added HdG to CC.

Dmitry agreed to carry the small drivers/input changes through the media
tree.

> Antonio Ospite (3):
>   gspca - ov534: Add Saturation control
>   Input: move drivers/input/fixp-arith.h to include/linux
>   gspca - ov534: Add Hue control
>=20
>  drivers/input/ff-memless.c        |    3 +-
>  drivers/input/fixp-arith.h        |   87 ----------------------
>  drivers/media/video/gspca/ov534.c |  146 +++++++++++++++++++++++++++----=
------
>  include/linux/fixp-arith.h        |   87 ++++++++++++++++++++++
>  4 files changed, 195 insertions(+), 128 deletions(-)
>  delete mode 100644 drivers/input/fixp-arith.h
>  create mode 100644 include/linux/fixp-arith.h
>=20

--=20
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Fri__11_May_2012_17_01_24_+0200_KE4lbiThZL9QMWOC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+tKcQACgkQ5xr2akVTsAEv9gCgmb1Fh1jB6MHHhtkNjr+kEne9
1DwAoKBJH2DvZqVR64CSgrd4KaMidxNR
=Al57
-----END PGP SIGNATURE-----

--Signature=_Fri__11_May_2012_17_01_24_+0200_KE4lbiThZL9QMWOC--
