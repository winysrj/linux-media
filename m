Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34466 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaCaWBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 18:01:13 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so5483329wes.33
        for <linux-media@vger.kernel.org>; Mon, 31 Mar 2014 15:01:12 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 06/11] rc-core: remove generic scancode filter
Date: Mon, 31 Mar 2014 23:01:02 +0100
Message-ID: <2637649.OvhTEs7Wbs@radagast>
In-Reply-To: <20140331193813.GC9610@hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu> <53393591.7060405@imgtec.com> <20140331193813.GC9610@hardeman.nu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1665380.8xFGl25Yo8"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1665380.8xFGl25Yo8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Monday 31 March 2014 21:38:13 David H=E4rdeman wrote:
> >The rest looks reasonable, though it could easily have been a separa=
te
> >patch (at least as long as the show/store callbacks don't assume the=

> >presence of the callbacks they use).
>=20
> Yes, I wanted to avoid there being more intermediary states than
> necessary (i.e. first a read/writable sysfs file, then one that can't=
 be
> read/written, then the file disappears...).

Fair enough

> Can still respin it on top of your patch if you prefer.

It doesn't particularly bother me tbh, so do what you think is best.

Cheers
James
--nextPart1665380.8xFGl25Yo8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTOeWlAAoJEKHZs+irPybfGnMP/i6vFTey174XJTydziMRMFec
kSOytHeWi8wQRcZ2zHVwbA8Ds/UTkEQ1GRPNjGmDbizNs4hjBS/gt5DSgRFrQR0X
cIfMnMJZaXrMmnGUcEx9buASx8GzNxd7nbp4kao6MRM79jfWWvW1S4bXPWNC2Tl4
BN7P0pXMBy7zHRl2fGvmrj/KOml+nzFS7lfJY0NmdTYi6CUiASyOENtyXwlB1bjl
IQW288aV38K6uR41MQJSKFJi9d0UwA91b9FgfCLxBWakix76yuM+RKixpbO2JPzC
tbXiwXhP/J2P2Pca2dxoTsiIwhCSdwsGRo9wcHhR98ChKdEKh9ee0v6+2IDIuhMK
CdqGcak0MdwvAOpbxTnI/qmeg3VzUOuLmnv6ZZA8+Gl5zr2PY9G+DiqYUmmqJ2SQ
E7peBE2/yGJQTDEOQmd4Ub9DgO3GebSqJzAoXX6ocscyLT9CaPh/VUxgi2kPxn94
zWPZfYSZq8aHVyjojJrOzMkX2CiKhY6x2oLNmI6eglQ4nl6PtFCdNq8A+kifSL8v
02OKDoeqW1YBHo2ZXV+9piZgHYGVIviW2oO2w4CXULpjbP6MtNXQtP5m0sRkLL6f
NLH/qFbD07GQwrboUHc45tGtPj1D2T+6R20ipSP8AX0i5KeEXNexjlkOVgEx88f7
TOK0XkWC9ALUOmH1RqTD
=xqSN
-----END PGP SIGNATURE-----

--nextPart1665380.8xFGl25Yo8--

