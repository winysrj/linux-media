Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1KrAZV-0004wV-MD
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 14:06:19 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sat, 18 Oct 2008 14:05:42 +0200
MIME-Version: 1.0
Message-Id: <200810181405.42620.dkuhlen@gmx.net>
Subject: [linux-dvb] S2API pctv452e stb0899 simples2apitune
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2116752662=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2116752662==
Content-Type: multipart/signed;
  boundary="nextPart8113657.Jn6x0BDhpF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart8113657.Jn6x0BDhpF
Content-Type: multipart/mixed;
  boundary="Boundary-01=_WEd+Iihrc/fuTF7"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_WEd+Iihrc/fuTF7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Attached patch makes the pct452e working for me with S2API
based on changeset 9263
http://mercurial.intuxication.org/hg/s2-liplianin

=2D mostly cleanup (remove commented code)
=2D proper frequency reporting for stb0899 (dvb-s and dvb-s2)
=2D fast and always lock for DVB-S (up to 8MHz frequency offset allowed) (o=
nly tested with symrates: 22 and 27.5)
=2D DVB-S2 checked 19.2E 11915 H 27500 only (I cant test others)
=2D PCTV452e LED  green: FE open    orange: FE closed
  does the TT S2 3600 (3650CI) also have this led and is it attached to the=
 same GPIO?

What I still dislike is the very long blocking if no signal is found or wro=
ng parameters were specified.
This could be easily avoid: if there were a signal locking would be quite f=
ast ;)
But i haven't had time to search for the solution to speed up...=20

also attached simples2apitune which is same as simpledvbtune but for S2API

happy testing,
 Dominik

--Boundary-01=_WEd+Iihrc/fuTF7
Content-Type: application/x-bzip2;
  name="simples2apitune.c.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="simples2apitune.c.bz2"

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
rwlCKgcv/i7kinChINRRni4=

--Boundary-01=_WEd+Iihrc/fuTF7
Content-Type: application/x-bzip2;
  name="my_s2api_pctv452e.patch.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="my_s2api_pctv452e.patch.bz2"

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

--Boundary-01=_WEd+Iihrc/fuTF7--

--nextPart8113657.Jn6x0BDhpF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkj50RYACgkQ6OXrfqftMKKDVwCfceCC2/ugqhV48Kvoxzkwm01Y
jYsAmwdn5Zaq4C/RYU2ab3gpbtzLa983
=gx3H
-----END PGP SIGNATURE-----

--nextPart8113657.Jn6x0BDhpF--


--===============2116752662==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2116752662==--
