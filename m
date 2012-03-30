Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:40181 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935831Ab2C3WPK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Mar 2012 18:15:10 -0400
Date: Sat, 31 Mar 2012 00:14:58 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120331001458.33f12d82@milhouse>
In-Reply-To: <4F762CF5.9010303@iki.fi>
References: <4F75A7FE.8090405@iki.fi>
	<20120330234545.45f4e2e8@milhouse>
	<4F762CF5.9010303@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m1nDapiDvQDR.MCb/tzvCgk"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/m1nDapiDvQDR.MCb/tzvCgk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Mar 2012 01:00:21 +0300
Antti Palosaari <crope@iki.fi> wrote:

> Feel free to do that. Actually, I just tried it about 2 hours ago. But I=
=20
> failed, since there callbacks given as a param for tuner attach and it=20
> is wrong. There is frontend callback defined just for that. Look example=
=20
> from some Xceive tuners also hd29l2 demod driver contains one example.=20
> Use git grep DVB_FRONTEND_COMPONENT_ drivers/media/ to see all those=20
> existing callbacks.

Cool. Thanks for the hint. I'll fix this.

> My short term plans are now
> * fix af9033 IF freq control (now Zero-IF only)
> * change firmware download to use new firmware syntax
> * dual tuner support
> * check if IT9035 is enough similar (My personal suspicion is that=20
> integrated tuner is only main difference, whilst USB-interface and demod=
=20
> are same. But someone has told that it is quite different design though.)
> * implement SNR, BER and USB counters
> * implement remote controller

Sounds good.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/m1nDapiDvQDR.MCb/tzvCgk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPdjBiAAoJEPUyvh2QjYsOio4P/RwfiTUMsIWlvjrSaFOT5Hv9
zdekEJuup+zRaYxVUcG1ErVT2eyK6/Y7d7AYLtJcoBPcrEpny1hiUvDH223UlcPr
4lGFsEBVSR7z59cqdT6HGGntF4Ky/HQMfiMhauzOYR414YuhzQ+OMDL5TzRq4GLa
TpWDWiZR+NKVUGP67aJuArV4SbVeIeo9KnZ0TkjpoMRhIDce5N41pA8CmtXLf9ZU
bgX53L25tdX/+V7jbmqYJErL9bRQL3OTfmFzVhVxjNJ0pMUPZKATv8dMY+15vGJq
T4WRDEXiu4v4vN3WVdm2KN8hRWElOWGyydOyVkAwZgtlN8IoOMublwOvtYY0XIlU
9P0fFSkXDfTaQxZoQE5udaiqfvsW9sQqchOoGpoyxgjqIb+0xb71hmSgflDflTxG
3TFisntoEfldrYAqaM+kLHWya3jUheQu5/iCRJJ7Nxgre/SmgXz5rX5DxYZCeLm2
0aUbd7TSEg3aiLg0fmMCdPS0wcVWpxW4+wAqT8Y6MbIXNj8JUKnoUngTb1h7eKAP
EGDT8SZnsrR2Cf2/4zjxdoNA6p8Rav6Jxt+2nAW8QdfCR9FUj43TLYkvPJba4nUG
hgyuCoiPgWO0+tTS3qyiqzueaPFEpy3y77uRSlNk3xkbVWRNIk9ikbdAiggSiQHa
ykDtok9wU+4QKkI8kzcO
=dMK2
-----END PGP SIGNATURE-----

--Sig_/m1nDapiDvQDR.MCb/tzvCgk--
