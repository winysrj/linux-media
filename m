Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35024 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbcD0Q7d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 12:59:33 -0400
Date: Wed, 27 Apr 2016 18:59:29 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sakari.ailus@iki.fi,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160427165928.GB8156@earth>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <572048AC.7050700@gmail.com>
 <572062EF.7060502@gmail.com>
 <20160427164256.GA8156@earth>
 <20160427164529.GB11779@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <20160427164529.GB11779@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 27, 2016 at 06:45:29PM +0200, Pavel Machek wrote:
> > I don't have pre-production N900s. The phone I use for development
> > is HW revision 2101 with Finish keyboard layout. Apart from that
> > I have my productive phone, which is rev 2204 with German layout.
>=20
> How do you check hw revision?

0xFFFF tells you the HW revision (e.g. when executed with -I, but
also during normal kernel loading operation). Apart from that there
is /proc/cpuinfo.

-- Sebastian

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXIO/uAAoJENju1/PIO/qaq/4P/Rgz6umecOkrc1hpnfg2fm66
76VjcRR9Ytmd3RMJtnqYOyZnLs8bOKgTvP/NHFjYwwpN+39vjstg8u7hoW48mLwa
ztBCv9OPyKP94B+OO7jp1r7OKxb/AbWpI9P/he7uaG62ZUTz31+vTMuRetzKl5uT
bYNvbhMwLJcnoucHc0kYeHeDOJDU13+kRURzguIrxqmU0AuGsgj4WrQ0XFs9xCgw
3T6Yxg602T65Cqaw3Zf8SqOufQ5ketTbo1HkBjJy8SDTNMawEKICBV2g7QxGmf80
AGT49haWuBKxU0PUE4qHF7RSFff5s7ESthKk+vfGpTa++8w2+n2D3DNCf0niExYZ
L3rtbgsrrNp13VNGLH5h5kxcDkCcJNWA+rUvKFKF4NfwecM2urFAs9Xdpwwbw4VH
kUYViUsPFLFpU11Bcuggb2OgZNU1oXjNKt9RnAGzYCz64wKdU3E0hT3fYJ/ilQhn
t91sQ4cRuOds/zgjQ9TSMdgZOQnJGMicSIyj45ucRT3Kb6g0Xb+WxIhn6bybYlkt
JVCQGrjVQHTypsf/2cflqQJFLOKEbCeB/4+q1fdFK/J6DTrpqbYTfmlmDHWW3zqI
TbjlDFvS2S01fo9YpJayznNWUk+wHRKGHpzMHoOjLPoBJ94Gj7QG/Jlfy99LJXKN
UlXvSMN7xtH0+GYRXhgV
=JDT9
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
