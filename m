Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1Ktkoc-0003KC-MU
	for linux-dvb@linuxtv.org; Sat, 25 Oct 2008 17:12:35 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sat, 25 Oct 2008 17:11:59 +0200
References: <20081025141920.87960@gmx.net>
In-Reply-To: <20081025141920.87960@gmx.net>
MIME-Version: 1.0
Message-Id: <200810251712.00078.dkuhlen@gmx.net>
Subject: [linux-dvb] cinergyT2 renamed drivers (was Re:  stb0899 drivers)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1745406361=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1745406361==
Content-Type: multipart/signed;
  boundary="nextPart3204528.ALnD5KBUtt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3204528.ALnD5KBUtt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Saturday 25 October 2008, Bitte_antworten@will-hier-weg.de wrote:
> Hi Igor,
>=20
> I tried your tree with my Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and i=
t works with the modified szap.
> Unfortunately my Terratec CinergyT2 doesn't work anymore. I can't load th=
e modul because of many undefined symbols. So I reverted everything to mult=
iproto and both devices are working again. What should I do?=20
the module name has changed to
dvb-usb-cinergyT2

> Thanks=20
> Dirk
>=20
=2D--snip---


Dominik

--nextPart3204528.ALnD5KBUtt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkDN0AACgkQ6OXrfqftMKJnFgCgkZacYcu2ff1A1tY+NJ93WsA8
TkQAmwYFVzbSue7feCF2Wet5Gf32SkJ1
=mH6v
-----END PGP SIGNATURE-----

--nextPart3204528.ALnD5KBUtt--


--===============1745406361==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1745406361==--
