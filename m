Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:52406 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbcAXG4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 01:56:08 -0500
Message-ID: <1453618564.2497.51.camel@winder.org.uk>
Subject: Re: SV: PCTV 292e support
From: Russel Winder <russel@winder.org.uk>
To: Peter =?ISO-8859-1?Q?F=E4ssberg?= <pf@leissner.se>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Sun, 24 Jan 2016 06:56:04 +0000
In-Reply-To: <1453615078.2497.29.camel@winder.org.uk>
References: <1453613292.2497.26.camel@winder.org.uk>
	 <ijvkgaod4jhqyaoroevcea7f.1453613737402@email.android.com>
	 <1453615078.2497.29.camel@winder.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qvRg2QPdhLMqKpu3Gc9s"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-qvRg2QPdhLMqKpu3Gc9s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I followed the instructions at=C2=A0http://blog.palosaari.fi/2014/04/naked-=
h
ardware-15-pctv-triplestick-292e.html

|> md5sum dvb-demod-si2168-01.fw=C2=A0
87c317e0b75ad49c2f2cbf35572a8093=C2=A0=C2=A0dvb-demod-si2168-01.fw

which is as expected, and put a symbolic link to this file in
/lib/firmware. Sadly this is not the file the driver is expecting:

[68031.899042] si2168 2-0064: found a 'Silicon Labs Si2168-B40'
[68031.899069] si2168 2-0064: firmware: failed to load dvb-demod-si2168-b40=
-01.fw (-2)
[68031.899073] si2168 2-0064: Direct firmware load for dvb-demod-si2168-b40=
-01.fw failed with error -2
[68031.899084] si2168 2-0064: firmware: failed to load dvb-demod-si2168-02.=
fw (-2)
[68031.899086] si2168 2-0064: Direct firmware load for dvb-demod-si2168-02.=
fw failed with error -2
[68031.899089] si2168 2-0064: firmware file 'dvb-demod-si2168-02.fw' not fo=
und

I am assuming that it is not a question of renaming the file (*), but
that some other firmware needs to be extracted from the discs.

(*) I did try that and it attempted to load the firmware but got an
error -121.

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


--=-qvRg2QPdhLMqKpu3Gc9s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlakdYQACgkQ+ooS3F10Be9tWgCeJQPGtXdjAD8ZcpW+Xu7QHHc1
0Q0AoOs7BDUvHIVc0H4v/pKh2t3tc/0b
=zut3
-----END PGP SIGNATURE-----

--=-qvRg2QPdhLMqKpu3Gc9s--

