Return-path: <mchehab@pedra>
Received: from mailout11.t-online.de ([194.25.134.85]:55113 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab1CVLdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 07:33:44 -0400
Message-ID: <4D8888F7.6010903@t-online.de>
Date: Tue, 22 Mar 2011 12:33:11 +0100
From: Rico Tzschichholz <ricotz@t-online.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-media@vger.kernel.org
Subject: Re: S2-3200 switching-timeouts on 2.6.38
References: <4D87AB0F.4040908@t-online.de>	<20110321131602.36d146b1.rdunlap@xenotime.net> <AANLkTik22=YE-2W4AtO9w_kVm=oro_YM7hJ52Rj83Fmt@mail.gmail.com>
In-Reply-To: <AANLkTik22=YE-2W4AtO9w_kVm=oro_YM7hJ52Rj83Fmt@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig717CA81270FFF50F5FC3EE7F"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig717CA81270FFF50F5FC3EE7F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Manu,

> Actually, quite a lot of effort was put in to get that part right. It
> does the reverse thing that's to be done.
> The revamped version is here [1] If the issue persists still, then it
> needs to be investigated further.
>
> [1] http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg09214.ht=
ml

I am not sure how this is related to stb6100?

Does that mean the current stb0899 patch [2] isnt ready to be proposed
for 2.6.39 yet? Or does the stb6100 patch has a better design to solve
this issue which should be adapted for stb0899 then?
I was hoping to see it included before the merge window is closed again.

[2] https://patchwork.kernel.org/patch/244201/

Best regards,
Rico


--------------enig717CA81270FFF50F5FC3EE7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJNiIj6AAoJEF3s26iScOcjUzwP+wTkx2HI0+wJk03V1xDZjgik
6A3VbMYN7Ed4F7Z0cZY9tvf6saluI8fJ4jfGYUazTMSYA8gDPlTYdiD7pPArrVVt
cg2mYtROIEo2JMm6+QG8bZ9Xv5ly0dRBeO7bItrOBalw+n5Wk2hbHHQD4CJTnYnB
FeX1uEdYBsCnoEIl1zvsyV+Myy+oEr9d8+JCTBricV8FeBQakwAIa2WVpdA56Xme
Lqt5LeFZnxP6fmtQQr1KPk+NiZW9PGVv6BFxlhgWDh1S+WLBIRIbT6PSji9eI/d6
Oq1hhIKZNJlN1as5qGxBP5ci8MfYcYGszxqqDFxGnjv+k8gkIle/nPCubZU3Afsd
kPR81n8nts3gWgaROS8wTCSMIuLtYlgjnpoaeV1yYuYjhNCE3Fn+ElHVNXwHDSCr
og49XyUm6H8RrKMtqg57XKEwzAqwUHNnb2eLJqxeIPtBSSuM9Ik70nmojBvJDaOO
2l4fZWqGd+Qz0GltvwDYofkkHFf4TYZzAwTHGZJOLs0g4IaaeY6OFiYtBhcr21LN
NWnK2AZCwS4f1tC4opGF7dtVDpjB4yzm8Sbo7VGPCWm7bfThq1mAw+CZaHwuPWuA
sVUuQWXMOMh9zbo0QBIZ09SPKYq01K38f/ud7EOdE4Or0x/xRYc20ftmZ2YUqtaG
+gf+vTfh0ZHU5ekKlCtB
=jHTk
-----END PGP SIGNATURE-----

--------------enig717CA81270FFF50F5FC3EE7F--
