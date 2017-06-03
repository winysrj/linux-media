Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:34500 "EHLO
        dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdFCKIG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Jun 2017 06:08:06 -0400
Message-ID: <1496484116.2018.8.camel@winder.org.uk>
Subject: Duplicate line in dvb-fe.h
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Sat, 03 Jun 2017 11:01:56 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-UgLH4jXnNrssSrYepsmr"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-UgLH4jXnNrssSrYepsmr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I am wondering what the right reporting/fixing approach is for the
following.

In the file /usr/include/libdvbv5/dvb-fe.h (on Debian Sid anyway, comes
in the libdvbv5-dev package) there are two lines:

    extern const unsigned fe_bandwidth_name[8];

In some sense this doesn't matter as it is just a redundant
redeclaration of the same symbol with the same type. However, a
stricter compiler might object to the redeclaration.

(My actual problem is automated generation of adapter files from other
programming languages, in the case D, where the duplication is a
compiler error.) =20

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
--=-UgLH4jXnNrssSrYepsmr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEETwDs1X+Beyaiaer41L3V0s7Np7gFAlkyiRQACgkQ1L3V0s7N
p7j/Vw//W5xysYDXU421cko0KdPP3GKWtZeOsRNqB4oGjs5UWwLBUAagQdRLVobP
ESnV72NfQ1bO9TDxqFwuuS8d09h0AZAHScAM6yfeU6/YpFrrgTVs9n8BIJZk1j1A
PPVfFHrmeigl/A2lS5iokPC6ke5mdEFnrjpD+MaQ1Mogop/BNg/88n4r7QsOHqRZ
2dWU3AWyhL36UbB2bznRjN+Jcwk3l/QNlAKNb/27Z7wWjKMYuPAIrfl/QAGmKie1
A+I3/56EdeLhlD8oFCU7bO1ckoTX8GvhFlfuaVKH41zmJFkIjsLMHRoBt1b37Fiv
ne03IPNWaMYErHoNp/Ta3Al1a+A+JkYTgj3gp86nlwEIP6rb42fk6Vu7Wxm7QgZb
zQPcYcYi/LhXd45I7HzbGXmuAMyGsUJRxyP2e0u2ltLBQ6bgEv0EeBaP3XUa8h4s
4XHYFZVACUB/HYv/l7MEkp8HZQbRiQhW+hL9IC9VD8RcsqDykF9QoCzBdgYFrbVp
xDq6SX7Ic7SD1XfRIzCqYWMMsuJbk2wWF/uHrjbhFUUIould1MOxm1O7hrM8O9Y4
Vd4enNKJFLqBauQK6czzpJAFHqojwrAvXDgsvp4ArZUKw/sO2uJkap+INkHJ7jb7
joVyLNN07wJc0WvI0eXJIbEPzwYTmT7LNGN87fgv9caKWzAzz9s=
=4gqf
-----END PGP SIGNATURE-----

--=-UgLH4jXnNrssSrYepsmr--
