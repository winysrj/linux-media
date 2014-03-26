Return-path: <linux-media-owner@vger.kernel.org>
Received: from [217.156.133.130] ([217.156.133.130]:55847 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751054AbaCZKCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 06:02:49 -0400
Message-ID: <53329DD2.3080105@imgtec.com>
Date: Wed, 26 Mar 2014 09:28:50 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 00/10] media: rc: ImgTec IR decoder driver
References: <1393630140-31765-1-git-send-email-james.hogan@imgtec.com> <20140325235314.GB2515@hardeman.nu>
In-Reply-To: <20140325235314.GB2515@hardeman.nu>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="lbqpEWUcqG694h7F28cCdQiuokDjh0xbK"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--lbqpEWUcqG694h7F28cCdQiuokDjh0xbK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25/03/14 23:53, David H=E4rdeman wrote:
> On Fri, Feb 28, 2014 at 11:28:50PM +0000, James Hogan wrote:
>> Add a driver for the ImgTec Infrared decoder block. Two separate rc
>> input devices are exposed depending on kernel configuration. One uses
>> the hardware decoder which is set up with timings for a specific
>> protocol and supports mask/value filtering and wake events. The other
>> uses raw edge interrupts and the generic software protocol decoders to=

>> allow multiple protocols to be supported, including those not supporte=
d
>> by the hardware decoder.
>=20
> One thing I just noticed...your copyright headers throughout the driver=

> seems a bit...sparse? :)

True, I can add the basic:

 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.

to each of the files if you think it's necessary.

Cheers
James


--lbqpEWUcqG694h7F28cCdQiuokDjh0xbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTMp3YAAoJEGwLaZPeOHZ65I8P/RaaT8RVewmeq/3JsPBEVO+z
dM+j7ndPTNzVDu3eqBMl/2EYvnQjLVQHlRDV22IkBf7cFX+xzLPrjIK3HHIK4WOv
rPqmMAGNojZXPk2LRD50JKlT7klNi91leXQXlzjCWEualnpXimYXHSI+Xscx/Yq1
V4VoZWidJO16E/+0tH5gTGAGGYBBO1o5bpKaK2oIqL3V9sE3eUtB8o1Frd44zrN3
Dx1BevEibGCTbuDzAGNH+jQfKTLGKJLnqnTmKJOCPgryKKHnW5+wEKaHcR967GoV
/ikwbcxgazdII6aNbksihlVMokKalIwPHVmOtqtyHEcwzz79luTVSQX9w6F+6yK7
cnbXwy0+Dtr3+aru2n9PDW1Q62bZhZ1LR184VxQGT7vW+nB5Rqv2ztTPK7zgstGR
aP6AA+UgXOih+6b6QC2Ogg26otNsyzKxg7furK4lexVSvasFpHICd6UQjNhDZXHy
U6d/1pwTzaY/VZktlomhtzapTVCKtyeCKPBVBCmJyCF5ejysdrRG/FLfQOGe8TyJ
+6eUOAhw7YBYSHSWKb8QRkHcZHYuaJJOK3ZSXZs0Pr4dxTEtQIplR7aktWD+yzpz
PCbPfx49geDxpjFXoFFxjnwYzaNMTJIO4LZiuM1ARw9nVSEF1nhfyf5yrknNBuiZ
D+3Ussu3vz8S8Y3AWN+H
=MO0l
-----END PGP SIGNATURE-----

--lbqpEWUcqG694h7F28cCdQiuokDjh0xbK--
