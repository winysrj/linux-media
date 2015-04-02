Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60814 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbbDBQJw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 12:09:52 -0400
Date: Thu, 2 Apr 2015 18:09:48 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] rc-core: use an IDA rather than a bitmap
Message-ID: <20150402180948.220b705d@mir>
In-Reply-To: <20150402101855.5223.5158.stgit@zeus.muc.hardeman.nu>
References: <20150402101855.5223.5158.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/WDIFgW7BmFJpDv1dB80Uvxd"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/WDIFgW7BmFJpDv1dB80Uvxd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

On 2015-04-02, David H=C3=A4rdeman wrote:
> This patch changes rc-core to use the kernel facilities that are already
> available for handling unique numbers instead of rolling its own bitmap
> stuff.
>=20
> Stefan, this should apply cleanly to the media git tree...could you test =
it?

Thanks, I've applied this patch to my kernel and have started testing=20
it. As the race conditions between both (well, three, the TeVii s480 v2.1
exposes two rc_core devices) doesn't trigger all the time, it might take
a while before I can report back.

Thanks a lot
	Stefan Lippers-Hollmann

--Sig_/WDIFgW7BmFJpDv1dB80Uvxd
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVHWnMAAoJEL/gLWWx0ULtPM0QALcWzmyNvZ2iMhfhW03SSZWp
bVotGl+6UvA+Q7xTFdgLPfMN/ktsmBQmowmRKuqEmKCD0V7RHs2dnB/tEqiWbJAN
aTZrvjMxp66GbOighi69xxyzPEYcRypI+q3Ok1CnU0QPTT//kZrfK61F3N8L+6lO
Gn1FGDweK0MPs1mg7qoKe/7aOVMH1Gy4Xt5wj4Z+kvFBdz8bQRLDVUTSgXWjls0l
p20K36w3a2qIPiyeDH/lpTshHfyQXvQS9rmkJl+rvDu5E7s4LLAGig3fabXZO5xg
/gDZ/OZAvWqcS6tY3zg/luEEXsJVK4jRxA144DbvmfAMLh733VGDjl4mOykNlALm
yG5ofklmWy3XD1GtfrNqRvzAZYhGmCi6Ws66jJVWi++GEkjuPAvfick0d2dcP1bB
o37ABCAUsOE03CrK8tCTDz6RmogqkGAO2IR9z6ooD8RioraklO/AeGVb112Gkc7f
S69IzPkoJyadEmKeEGXlFJ1VP+pLPmKoxW988tfCAw1zuLwhtEkGa90L5RG90b8c
X8wdrUKT29Cw3CqUoX8ckzewpz7UbvyGtSw7KWQzrRLjUduowJu2FP81KakJO6Ar
sxDqFHA8Fz4Yqs9lQsVENb8AWnTXDFxIMC5U4TeQ6kVxe/WkQLa+BSZ9hEWBuh2Y
x1jtDQI62XVZxSNLw3DH
=cQ8Q
-----END PGP SIGNATURE-----

--Sig_/WDIFgW7BmFJpDv1dB80Uvxd--
