Return-path: <linux-media-owner@vger.kernel.org>
Received: from powered.by.root24.eu ([91.121.20.142]:38481 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZCOWGe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 18:06:34 -0400
Message-ID: <49BD7BDF.6060105@ionic.de>
Date: Sun, 15 Mar 2009 23:06:23 +0100
From: Mihai Moldovan <ionic@ionic.de>
MIME-Version: 1.0
To: =?UTF-8?B?TWF0ZXVzeiBKxJlkcmFzaWs=?= <m.jedrasik@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Pinnacle PCTV Hybrid Pro Card (310c)... once again...
References: <49BC3DEE.9050307@ionic.de>	 <d9def9db0903141641g457b9cdar317b0d8e5f132150@mail.gmail.com>	 <49BC4535.6090700@ionic.de>	 <d9def9db0903141725q86476e9i7fdf97d9198484ac@mail.gmail.com>	 <49BC5788.50207@ionic.de> <1237082593.1970.2.camel@compal> <49BCD9BC.8070702@ionic.de>
In-Reply-To: <49BCD9BC.8070702@ionic.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig2C43EEC2D31B4CB496AC1356"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2C43EEC2D31B4CB496AC1356
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

* On 15.03.2009 11:34, I myself wrote:
> * On 15.03.2009 03:03, Mateusz J=C4=99drasik wrote:
>> To answer any questions that were posed at me, I have not been
>> using the card much, but were able to get analog picture (no
>> sound) with it using Ubuntu 8.10 stock kernel - I'm guessing
>> 2.6.27 at the time.
>
> Cool, this would be a great start, really! I will switch to
> in-kernel drivers again, too (thought 2.6.28.7 ones.) Let's see
> whether this does work...
Tried out the stock Kernel drivers and experienced following:

  - DVB-T is working fine, at least with VLC... Kaffeine leaves the
card in an unusable state sometimes which can be only solved be
re-plugging the card, really weird stuff...

  - radio is still not working and it actually does break analog TV
output (obviously? Needs further investigation!)

  - analog TV is working fine now in picture but the sound fails on
full scale - can this problem be addressed by anyone here? What
exactly is wrong with it? I read about sound working with this
usbaudio.sh script, but it's ALSA only... could OSS support be
possibly integrated?


>> Stay tuned.
>
> But I cannot tune anything! ;-)
Done - tuned in correctly now. :-)

Best regards,


Mihai



--------------enig2C43EEC2D31B4CB496AC1356
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBCgAGBQJJvXviAAoJEB/WLtluJTqHOM4P/0lh1I+ktExBIN0U4IAr4nPt
nf+FfupAz1wb+ssgG1F94TJAvcb/gxewAJKSkcYoVeoJrWJmS2F0eFjywcAcEWJj
ZD4hg4YHWCFUwwmUNmfDvoa5x5CMu90KJFadHIiMwxyrKKVA12llEe+ROye7xO/E
mrgd3fysLbP8OkEyjzbBU+vKJFnUfuQr1m+njQnU/b3OK+X2eoKsyACVmgsaJ6ul
7G9OQT912t06KfdvvXg5ZOyPyBbYJG4IzDhKHefXzYdASkFA7EYofOOJj27ldiqx
89vU5l8wr+WXljiHvs2e4e1ieInyeOGOUDCVIAt6FmwwwWoPw9qAty0H9D+Y6dzp
W0DAKB9sEW2RRIKD8NJVFa5IWXvqNFvb5BBqmWfAih5mM+sGA9VTkVWFwxH4nzng
E5KUYIkK1VzbCd0g/DxeEnbNAdErgh2fjEdJR+QSNdloioU8I4yWU0KOlSPkn1tZ
SkPB1cgLjr4cI4z/C1Hh/HQU+LoDOtcvxvp7ZDFiJIpO4A3c8gnVaSJ0/iMVhDD5
Ef48hSoyL9ZjW+zAamoZvOgxajJbPxczwJmr7mDUhKLb8W8GjjhHhy+eRwBFrr9+
vRv1hqKuSI2TpTsZ7+S3SYXnjsn7JT1ARpU86O1OYxEDYTrkfkzhErl8IhqKyMmA
9alEoh9cSUyHdqc9NwHH
=lYg3
-----END PGP SIGNATURE-----

--------------enig2C43EEC2D31B4CB496AC1356--
