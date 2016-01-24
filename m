Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:52100 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbcAXF2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 00:28:14 -0500
Message-ID: <1453613292.2497.26.camel@winder.org.uk>
Subject: PCTV 292e support
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Sun, 24 Jan 2016 05:28:12 +0000
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-0JpMxsx+Eb4t41VLeSfy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-0JpMxsx+Eb4t41VLeSfy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom the material on the LinuxTV webpages, there is support for PCTV
292e, and in emails it appears others are using this device. I find
that on Debian Sid and Fedora Rawhide using the distributed kernels and
libdvbv5, dvbv5-scan fails to get activity from the device. PCTV 282e
works fine.

Fedora Rawhide has kernels 4.4 and 4.5, Debian Sid 4.3.

Debian Sid distributes dvb-tools as well as libdvbv5 (1.8.0). Fedora
Rawhide only distributed libdvbv5 as far as I can tell, but I compiled
dvbv5-scao from source from a git repository clone, but it behaves the
same.

On Debian Sid with PCTV292e:

|> dvbv5-scan /usr/share/dvb/dvb-t/uk-CrystalPalace=C2=A0
Cannot calc frequency shift. Either bandwidth/symbol-rate is
unavailable (yet).
Scanning frequency #1 490000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D 0.00dBm
Scanning frequency #2 514000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D 0.00dBm
Scanning frequency #3 570000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D 0.00dBm
Scanning frequency #4 506000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D 0.00dBm
Scanning frequency #5 482000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D 0.00dBm
Scanning frequency #6 529833000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D 0.00dBm
Scanning frequency #7 545833000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D 0.00dBm

Swapping to the PCTV 282e, scanning works entirely as expected: if
there is a lock it happens immediately and the channels are shown after
a while; if there is no immediate lock there is a spinning of the
signal strength value =E2=80=93 definitely not just a solid zero.

I note that PCTV 282e has a green light on permanently and works fine.
PCTV 292e lights up blue when plugged in and then the light goes out.
On Linux it never comes on again. Trying the device on Windows with the
distributed software the blue light comes on every so often as activity
happens. The hypothesis is that the device is not being driven
properly. And yet people appear to be using the device?

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


--=-0JpMxsx+Eb4t41VLeSfy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlakYOwACgkQ+ooS3F10Be8boQCfXUxPuqS/IEGWQSqpmN60BERu
HaIAoKrVlHJwkt0Z+LPC9KPogM7dCzTQ
=S/hn
-----END PGP SIGNATURE-----

--=-0JpMxsx+Eb4t41VLeSfy--

