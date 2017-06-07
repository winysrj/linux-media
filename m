Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:51810 "EHLO
        dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdFGPXj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 11:23:39 -0400
Message-ID: <1496849016.10477.26.camel@winder.org.uk>
Subject: Problem using libdvbv5
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Wed, 07 Jun 2017 16:23:36 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ehyahqi60HeUIWHfm53T"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ehyahqi60HeUIWHfm53T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I am having some issues with dvb_scan_transponder in the Debian Sid
distribution of libdvbv5. I am sure the arguments I am giving it are
fine, but a function called within dvb_scan_transponder is causing a
SIGSEGV. The Debian Sid package appears to be only of a production
version, there is no debug symbols and/or package.

I am guessing that the official line is to build from source to create
a debugging shared object. I have cloned the V4L_Utils Git repository
from https://git.linuxtv.org/v4l-utils.git=C2=A0

What is the official sequence to get a build of libdvbv5.so and what
extra arguments are needed to get a version with all debug symbols in
place?
=20
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
--=-ehyahqi60HeUIWHfm53T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEETwDs1X+Beyaiaer41L3V0s7Np7gFAlk4GngACgkQ1L3V0s7N
p7icng//YXE4PX4nKOyUtrmbHYnLYbXPLWnrW9CXDo31VephlWIxHbaGzfUCJLG7
RLfYjv/nQ2HpCyJFeJLY9XichvO/THMwHq9G2L8s0mSxHj3FEe/d3c3ZLjoc79Wu
MgZm29Qo9OTkcpk69fXM0QR4QR28bHqMEG5COXYF2FinwtaGRqK/dUArlKl3mqvI
pJYyWTKwM/aidEVFM6bSVRcy1GsKhn6Ph+UYZ3OTMcJZBmtdaJcw+nSRb6odwACr
EZ9Iqhde7sw+YTKjqKyAowF63ZcxmF5p7SZvvmBo58vphhG/3SNuvfU7beTmpDU7
5gfXsvQa61RtPE/OyD6rh5kZ3mVDbaGiG4N1A8RHv08eVikEc1ZVt3L1KGX1RNa1
9G9yzuXKvQbSRtdhCbvQbCmsNx2DzVkzdP3ScqNxlj1pVWf5ZtJIBS6NpR3bJfqW
ynjfxhmkeIDV4CotxnJKyNGv5/918S1OCb0DRj2MW0MQt/LNVCFgbLEqeCtaJ0hW
oGTMqWcKxUu6RzPzTtWaGA3zURUng5JvqfYs4dL185cgkWTJPHxyjdNA0j0doAMh
W2omqnLQQHy68LhudSfGuro4a6swJCWPtw39hsbEIFrDG5ewmCoNYMLYv4aEZa2k
ibB/O0Dl4VWDDGHitFPWzHJd76mZ47u4RIvRUhAThL/ZV8azZyQ=
=xPKv
-----END PGP SIGNATURE-----

--=-ehyahqi60HeUIWHfm53T--
