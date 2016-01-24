Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:52072 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbcAXFZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 00:25:07 -0500
Message-ID: <1453612624.2497.15.camel@winder.org.uk>
Subject: dvbv5-zap: getting pmt-pid
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Sun, 24 Jan 2016 05:17:04 +0000
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8OuE2r6JsZEr5BMw1l2s"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-8OuE2r6JsZEr5BMw1l2s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In the middle of last year, there was an email exchange about dvbv5-zap=20
and the -p option not working. As far as I can tell this is still a
problem for Debian Sid and Fedora Rawhide with PCTV 292e, PCTV 282e,
and Terratec XXS. Is there a fix pending?

Debian Sid: kernel 4.3, libdvbv5 and dvb-tools 1.8.0
Fedora Rawhide: kernel 4.4 and 4.5, libdvbv5 1.8.1

(Fedora appears not to package dvb-tools :-(, but compiling the source
of dvbv5-zap from a clone of the repository behaves in the same way as
the version distributed on Debian Sid.)

For example on Debian Sid with PCTV 282e:

|> dvbv5-zap -p -r -c ~/.local/share/me-tv/virtual_channels.conf "BBC NEWS"
using demux '/dev/dvb/adapter0/demux0'
reading channels from file '/home/users/russel/.local/share/me-tv/virtual_c=
hannels.conf'
service has pid type 05:=C2=A0=C2=A07270
tuning to 490000000 Hz
read_sections: read error: Resource temporarily unavailable
couldn't find pmt-pid for sid 1100


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


--=-8OuE2r6JsZEr5BMw1l2s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlakXlAACgkQ+ooS3F10Be9hSgCeJPkYQgTqDCj5u7H+lgmCIi4Y
+hQAnRJv3eqTU7+pvKC6aHdInJJPCLAA
=CTHi
-----END PGP SIGNATURE-----

--=-8OuE2r6JsZEr5BMw1l2s--

