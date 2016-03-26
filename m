Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:38902 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbcCZGNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2016 02:13:13 -0400
Message-ID: <1458972788.3344.8.camel@winder.org.uk>
Subject: libdvbv5 licencing
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Sat, 26 Mar 2016 06:13:08 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-aEKa47tdtL+pACBMcA4B"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-aEKa47tdtL+pACBMcA4B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I hadn't noticed previously, but it has been brought to my attention
that libdvbv5 is licenced as GPLv2. This makes it impossible
(effectively) for any non-GPL code to make use of libdvbv5. This seems
to undermine the whole point of libdvbv5.=C2=A0

In particular, I wanted to rip out all the Linux API based code from
the GStreamer DVB plugins and replace it with use of libdvbv5. However
because of the licencing (GStreamer is LGPL and must only use LGPL or
more liberal licenced code), this is going to be impossible.

Instead of ripping out the current code (which is DVBv3) and using
libdvbv5, it looks like I will be forced to recreate libdvbv5 but as
LGPL code.

Is there any chance of relicencing libdvbv5 as LGPL code so that others
may use it?

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
--=-aEKa47tdtL+pACBMcA4B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJW9ih2AAoJENS91dLOzae4iEsQALGYwQLdtadvPfpVJtYjlsiE
kMGCB9H+klqf5yaqJ0qa5OMwCQbqO+N39zdIy3Gzfe+ku/4Apu4hU/1RxFb4A6y5
mdfq40WzKRyiadBaG2yuAZ9JKyAVh5V9l+wlK6+tgGidR0Tnlt/5YYC085m3ikFS
JXzdrmFfN6nL1n9V3TZ33CDvuxjuD2/D7s5775CZ7qqFMnQ3KNlilWURsYIs1eqW
xEGbXAuXx57Ic1JgYjxZJAO5W2AsL8Rw8NUKFWSxpnq1hYatssoQaBNvw2gRkYKn
H3n+52y3YzX96Vy8uPAC51oFem7xFW0bXc8UoIqikOziOv8soKSlckmGrwzOuYm6
Cwjhb/VRPd2sUBt3vuqm77EWVAai41SePPpyOC07jb6TVy+0oTSSbMqldkvVeMx8
dQ3oRFnAw0ECoNLK+AJBAG0tpINQQ0MwgKF2EY3Bkxcg4i3hX+tXb8+B+TKDKTdJ
i/m92jHZJiUNVNcUMPrKFBH+sZEWX5/A81ZeCA+QhLvfPluGo3wQIaV6iAi/iej+
/weIe97/p2jViAbnm5AgdhK5PBxwXPziH1xa52ANvAXkRwrmzhMjq35oGE8HT6mo
AfqsmKgLWlGfKFK/OVlZL+F8J1P85K9Hn5D3Q6ov7vpJa/8Vl99gEJD7z6n8vlJJ
wppwH7G3zJATRQuazE+/
=ybz2
-----END PGP SIGNATURE-----

--=-aEKa47tdtL+pACBMcA4B--

