Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:38676 "EHLO
        dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbdAaR4j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 12:56:39 -0500
Message-ID: <1485885027.10632.13.camel@winder.org.uk>
Subject: rtl2832_sdr and /dev/swradio0
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Tue, 31 Jan 2017 17:50:27 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-lcBifY36dZPuwIedr3rH"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-lcBifY36dZPuwIedr3rH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Is anyone actively working on the rtl2832_sdr driver?

I am particularly interested in anyone who has code for turning the
byte stream from /dev/swradio0 into an ETI stream. Or failing that
getting enough data about the API for using /dev/swradio0 so as to
write a byte sequence to ETI driver based on the dab2eti program in
DABtool (which uses the librtlsdr mechanism instead of the
/dev/swradio0 one).

--=20
Russel.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Dr Russel Winder      t: +44 20 7585 2200   voip: sip:russel.winder@ekiga.n=
et
41 Buckmaster Road    m: +44 7770 465 077   xmpp: russel@winder.org.uk
London SW11 1EN, UK   w: www.russel.org.uk  skype: russel_winder
--=-lcBifY36dZPuwIedr3rH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEETwDs1X+Beyaiaer41L3V0s7Np7gFAliQzmQACgkQ1L3V0s7N
p7hLHQ/+K9g5drfbCoAlMJwSvUDsn+Vqb1hFhwEYcqOJpVskSUC01x6QmeIaa9jj
YNYfaZAlX2oV1HnwSmwPo4wRaFFrwXaMFBy3NgMPhP4LTKjWfUv8NuUznz51n8sI
6rurT1wPo8Ltx4MDjcNI0huW2tFNMDauJCHMo5owMA5yqR16Bn2XJtxmDvg2gElX
sEyoDJ2AQZNT1Diq73D+N6Sr6XQQccBZGJLUiYw7DMtbLQ/ZSmapadtoohkHMPhV
iH47HBGdYvDQzBe7M0Sh/aJ24lX/eY+Obj6AJ75RnH572/YK/Gq+bzCb7DspkXxw
ZlAHxqlQphC/Fc+bq8Bi4jGVw9I94jlgdXhEjfUlV5opGwQ+YedW4pNjzPiMGAQq
FZbvKlBA+q1bgsoH35Yrx1QIdAYmGvtcUVVHbQBk3Obop1oKJLyjhBcI7+TPON+o
JCUttDWB77iR8MxNrWKTh+l381syIOpMLOfU/3TwiIYK2/8m2aNdZ/bQ6AyLFFu1
9tafwOEfw5dbiXnueNuxjDcjiCMS9CxsfgsgdV/GftEwZlrXjIxec51bVE976z2t
Q+a1QIeffH/koZxV4px9DLK6PiZQY9fXEk3C6wSne1KUGAvYOqBHJmhmRsXw5X1D
OlsceFseqS0Cp1QbSQXhVtGOi5igSwr/g65+Prp+/2dE+0PmU9g=
=BhQa
-----END PGP SIGNATURE-----

--=-lcBifY36dZPuwIedr3rH--

