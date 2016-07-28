Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35212 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbcG1Ev0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2016 00:51:26 -0400
Received: by mail-pf0-f180.google.com with SMTP id x72so17889539pfd.2
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2016 21:51:25 -0700 (PDT)
Received: from [10.171.1.6] ([107.152.98.150])
        by smtp.gmail.com with ESMTPSA id ph12sm12847418pab.21.2016.07.27.21.51.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Jul 2016 21:51:24 -0700 (PDT)
From: Marty Plummer <netz.kernel@gmail.com>
Subject: TW2866 i2c driver and solo6x10
To: linux-media@vger.kernel.org
Message-ID: <d5269058-c953-5b3e-7b19-0b4c6474714c@gmail.com>
Date: Wed, 27 Jul 2016 23:51:22 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r7AiGaGB7VF0r6kQdisSNBTjjx87clfVc"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r7AiGaGB7VF0r6kQdisSNBTjjx87clfVc
Content-Type: multipart/mixed; boundary="kLhX9GStd1xChIFV4bGXlhWKq5grIdjGB"
From: Marty Plummer <netz.kernel@gmail.com>
To: linux-media@vger.kernel.org
Message-ID: <d5269058-c953-5b3e-7b19-0b4c6474714c@gmail.com>
Subject: TW2866 i2c driver and solo6x10

--kLhX9GStd1xChIFV4bGXlhWKq5grIdjGB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I have one of those rebranded chinese security dvrs, the ones with all th=
e gaping
security holes. I'd like to fix that up and setup a good rtsp server on i=
t, but
first comes low-level stuff, drivers and such. I've been squinting at the=
 pcb and
ID'ing chips for a bit now, and I've figured most of them out. Looks like=
 the actual
video processing is done on 4 tw2866 chips, though the kernel module has =
symbols
referring to tw2865. I've seen another driver in the kernel tree, the blu=
echerry
solo6x10, but that's on the pci bus. as far as I can figure, the dvr uses=
 i2c for
them. So, what I'm wondering is would it be feasible to factor out some o=
f the solo
functionality into a generic tw2865 driver and be able to pull from that =
for an i2c
kernel module? I'd really hate to have to rewrite the whole thing, duplic=
ated code
and overworking are generally a bad idea, even if I do have a datasheet f=
or the chip
in question


--kLhX9GStd1xChIFV4bGXlhWKq5grIdjGB--

--r7AiGaGB7VF0r6kQdisSNBTjjx87clfVc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXmY9LAAoJEHWEtN3AMJGNVeMP/i9XMXY3ryV+62IZ8RgNWNbe
j7/P4YyzgGj3R/5tblXsbw43HroC5uzhjXcCG4fzs8uQE8q48YxKB8Nskoi25qJh
At77LMNK4Jcc/x0KiJKINa66I0Qd/5OSTmb1gIuXWEeh4uSb+cIyIZq4FyOdgM1a
tsaNTdO9a4o6mSIjCtHkT/LVt51b1Sx/sUx6G6R+QelaTmeofWMeRZGJIbEy4EyD
uvEnmeyWXCPeazARAw83tH3x5RQ2w+Uxri3Mgu1/LESshWQtcZ6e6/ITCRy8RcNv
8StQK51XPwYNZwV+xLR3FNtJg75oeiuVjid+GzNdVtL0HHSMjxf+AHwcEVfdhbtf
XLjeSZyvVtN7AMDhzcnqF/XBik3kEbIn4whgbp39GlIAGmDJYD9SCtG//5zmc86o
fQBxbDUJ3gPbq87ZZatgBVEnWUpCiKhAMZTz7uKTj69yLWYkN3BXCX2e9zEtDuG5
/CYX+sjPbrJwzJ1NXb/bH+NxbiBTV0kHEuzQUzc07ia/uWLUfpqXbJWOesv803L1
r4BjeOzoMtk5GMLX1gUqt3oAIODTUmFqT3e1Ak1mKhvo/c2NZ88Mqo2pD5qj/cO5
wdwPEBWX/5KdyKGgulFRfsmaYNltrX0zbqvbwwVOh1XQFrnTXxHjAh+pKnEKIF64
+XGtxsQl5S/qQu6cclzp
=DEfa
-----END PGP SIGNATURE-----

--r7AiGaGB7VF0r6kQdisSNBTjjx87clfVc--
