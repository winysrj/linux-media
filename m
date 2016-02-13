Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:56038 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbcBMLEk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 06:04:40 -0500
Message-ID: <1455361477.1704.11.camel@winder.org.uk>
Subject: Re: PCTV 292e weirdness
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Sat, 13 Feb 2016 11:04:37 +0000
In-Reply-To: <1454523447.1970.15.camel@itzinteractive.com>
References: <1454523447.1970.15.camel@itzinteractive.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-TGFYjutNWGks9CabOIld"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-TGFYjutNWGks9CabOIld
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom what I can see, this problem has gone away =E2=80=93 hopefully
permanently.

As far as I can tell the only change is that there has been a firmware
file update at=C2=A0git@github.com:OpenELEC/dvb-firmware.git that reverts
4.0.19 to 4.0.11

On Wed, 2016-02-03 at 18:17 +0000, Russel Winder wrote:
> I am fairly sure I didn't see this before, but then I am not sure I
> have a new kernel, libdvbv5 or dvbtools. Also people are bad
> witnesses.
> However, if I plug the device in I can either scan with it or tune
> it,
> but only once thereafter it goes into "won't do anything so there"
> mode. For example:
>=20
>=20
> > > dvbv5-zap -c save_channels.conf "BBC NEWS"
> using demux '/dev/dvb/adapter0/demux0'
> reading channels from file 'save_channels.conf'
> service has pid type 05:=C2=A0=C2=A07270
> tuning to 490000000 Hz
> video pid 501
> =C2=A0 dvb_set_pesfilter 501
> audio pid 502
> =C2=A0 dvb_set_pesfilter 502
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00)
> Lock=C2=A0=C2=A0=C2=A0(0x1f) Signal=3D -51.00dBm C/N=3D 23.50dB
> 582 anglides:~/Repositories/Git/Git/Me-TV (git:master)
> > > dvbv5-zap -c save_channels.conf "BBC NEWS"
> using demux '/dev/dvb/adapter0/demux0'
> reading channels from file 'save_channels.conf'
> service has pid type 05:=C2=A0=C2=A07270
> tuning to 490000000 Hz
> video pid 501
> =C2=A0 dvb_set_pesfilter 501
> audio pid 502
> =C2=A0 dvb_set_pesfilter 502
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) C/N=3D 23.50dB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -67.00dBm C/N=
=3D 23.50dB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -67.00dBm C/N=
=3D 23.50dB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(0x00) Signal=3D -109.00dBm C/N=
=3D 23.50dB
>=20
>=20
> If I use a PCTV 282e this does not happen. As far as I can tell there
> has been no change of firmware either, and yet=E2=80=A6
>=20
>=20
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


--=-TGFYjutNWGks9CabOIld
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAla/DcUACgkQ+ooS3F10Be+cxgCeJJWGH4QDEIEp4eEPHojzdLKJ
VfkAniP0OjZ0H9fDkBopK7T5hAtM0+ym
=fj3M
-----END PGP SIGNATURE-----

--=-TGFYjutNWGks9CabOIld--

