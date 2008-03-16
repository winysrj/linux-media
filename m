Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1JauFl-0004Jf-NY
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 15:54:30 +0100
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sun, 16 Mar 2008 15:53:49 +0100
References: <A33C77E06C9E924F8E6D796CA3D635D102397B@w2k3sbs.glcdomain.local>
In-Reply-To: <A33C77E06C9E924F8E6D796CA3D635D102397B@w2k3sbs.glcdomain.local>
MIME-Version: 1.0
Message-Id: <200803161553.49113.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] DVB-S DVB-S2 and CI cards working on Linux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1416367783=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1416367783==
Content-Type: multipart/signed;
  boundary="nextPart1698777.p4fruI9qvb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1698777.p4fruI9qvb
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 16 March 2008, Michael Curtis wrote:
> First of all my thanks to all those engaged in developing drivers for
> the various cards for the Linux OS and my apologies for repeating this
> question previously asked by others
>=20
>=20
> Are there any DVB-S/S2/CI cards that work at present on Linux? If so I
> would really appreciate knowing which ones they are
>=20
>=20
> I have had a TT3200 DVB-S2/CI card for more than a year and I have still
> not got this to work using the Multiproto drivers on Linux, in fact it
> seem that I am going backwards with this card with the latest errors
> appearing in dmesg:
>=20
> stb0899_search: Unsupported delivery system
There has been an api update. make sure you're tuning application does a=20

dvbfe_delsys delsys =3D DVBFE_DELSYS_DVBS;
ioctl(front, DVBFE_SET_DELSYS, &delsys);

before other tuning ioctls.

>=20
> This is with the latest drivers from "http://jusst.de/hg/multiproto"
>=20
> Changeset 7212:b5a34b6a209d
>=20
> I will gladly offer up the log/dmesg/lsmod information if someone can
> help
>=20
> At the moment, I feel frustrated and lack the confidence that working
> drivers are are going to be available for this card
>=20
> Kind Regards
>=20
> Mike Curtis
>=20
>=20
>=20
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>=20



Dominik

--nextPart1698777.p4fruI9qvb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBH3TR96OXrfqftMKIRAtnWAJ4k38bNj4tpWuha8zS4GpdaGn1ivQCfd8cw
JIq9S5Q5Pais1B+GKDbvR0I=
=GEZh
-----END PGP SIGNATURE-----

--nextPart1698777.p4fruI9qvb--


--===============1416367783==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1416367783==--
