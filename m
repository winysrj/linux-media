Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:35384 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121AbcBCSZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2016 13:25:53 -0500
Message-ID: <1454523447.1970.15.camel@itzinteractive.com>
Subject: PCTV 292e weirdness
From: Russel Winder <russel@itzinteractive.com>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Wed, 03 Feb 2016 18:17:27 +0000
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-B0b1xCqCyFRbe0Pt8Qno"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-B0b1xCqCyFRbe0Pt8Qno
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I am fairly sure I didn't see this before, but then I am not sure I
have a new kernel, libdvbv5 or dvbtools. Also people are bad witnesses.
However, if I plug the device in I can either scan with it or tune it,
but only once thereafter it goes into "won't do anything so there"
mode. For example:


|> dvbv5-zap -c save_channels.conf "BBC NEWS"
using demux '/dev/dvb/adapter0/demux0'
reading channels from file 'save_channels.conf'
service has pid type 05:=C2=A0=C2=A07270
tuning to 490000000 Hz
video pid 501
=C2=A0 dvb_set_pesfilter 501
audio pid 502
=C2=A0 dvb_set_pesfilter 502
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00)
Lock=C2=A0=C2=A0=C2=A0(0x1f) Signal=3D -51.00dBm C/N=3D 23.50dB
582 anglides:~/Repositories/Git/Git/Me-TV (git:master)
|> dvbv5-zap -c save_channels.conf "BBC NEWS"
using demux '/dev/dvb/adapter0/demux0'
reading channels from file 'save_channels.conf'
service has pid type 05:=C2=A0=C2=A07270
tuning to 490000000 Hz
video pid 501
=C2=A0 dvb_set_pesfilter 501
audio pid 502
=C2=A0 dvb_set_pesfilter 502
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) C/N=3D 23.50dB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -67.00dBm C/N=3D=
 23.50dB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -67.00dBm C/N=3D=
 23.50dB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB


If I use a PCTV 282e this does not happen. As far as I can tell there
has been no change of firmware either, and yet=E2=80=A6


--=20
Russel.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
Dr Russel Winder       Director
It'z Interactive Ltd   t: +44 20 7585 2200        voip: sip:russel.winder@e=
kiga.net
41 Buckmaster Road     m: +44 7770 465 077        xmpp: russel@winder.org.u=
k
London SW11 1EN, UK    w: www.itzinteractive.com  skype: russel_winder


--=-B0b1xCqCyFRbe0Pt8Qno
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlayRDcACgkQSN8tueOZ0k4YXQCgu5ZYdnQJLR/ba3Q2nsmcglMV
CDcAoKg8SvZ9Lr70KOPG3bQYzZn13lPI
=kDSR
-----END PGP SIGNATURE-----

--=-B0b1xCqCyFRbe0Pt8Qno--

