Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from koos.idefix.net ([82.95.196.202] helo=kzdoos.xs4all.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <koos@kzdoos.xs4all.nl>) id 1LFRnf-0004X2-65
	for linux-dvb@linuxtv.org; Wed, 24 Dec 2008 12:21:19 +0100
Received: from kzdoos.xs4all.nl (ip6-localhost [IPv6:::1])
	by kzdoos.xs4all.nl (8.13.4/8.13.4/Debian-3sarge3) with ESMTP id
	mBOBLBfm015301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Wed, 24 Dec 2008 12:21:11 +0100
Received: (from koos@localhost)
	by kzdoos.xs4all.nl (8.13.4/8.13.4/KH20080312-submit) id mBOBLBKI015300
	for linux-dvb@linuxtv.org; Wed, 24 Dec 2008 12:21:11 +0100
Date: Wed, 24 Dec 2008 12:21:11 +0100
From: Koos van den Hout <koos@kzdoos.xs4all.nl>
To: linux-dvb@linuxtv.org
Message-ID: <20081224112111.GA15004@kzdoos.xs4all.nl>
Mime-Version: 1.0
Subject: [linux-dvb] Scan file dvb-t nl-Utrecht
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1585324069=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1585324069==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline


--8P1HSweYDcXXzwPJ
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


As attached, tested yesterday evening with scan from Ubuntu dvb-utils
1.1.1-3.

I see fec values in nl-Randstad and nl-AlphenaandenRijn that aren't valid
(anymore) compared to the information source I have. Should I send those
in with my 'theoretical' fixes or should I wait until I can try them (or
ask people to try them).

                                          Koos van den Hout

--=20
Koos van den Hout                         Homepage: http://idefix.net/~koos/
                        PGP keyid DSS/1024 0xF0D7C263 or RSA/1024 0xCA845CB5
Webprojects:              Camp Wireless        http://www.camp-wireless.org/
                      The Virtual Bookcase   http://www.virtualbookcase.com/

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=nl-Utrecht

# Digitenne (Utrecht, The Netherlands)
# Transmitters:
# Utrecht, Maarssen, Lopik, Amersfoort
# Source of channels/info: http://www.radio.nl/fmtv
#
# by Koos van den Hout <koos@kzdoos.xs4all.nl>
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 706000000 8MHz 1/2 NONE QAM64 8k 1/4 NONE  # UHF 50
T 818000000 8MHz 1/2 NONE QAM64 8k 1/4 NONE  # UHF 64
T 762000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE  # UHF 57
T 498000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE  # UHF 24

--GvXjxJ+pjyke8COw--

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJUhsnLGY7XfDXwmMRAuLTAJ9GSKLqeNhxI203VcZ/27icxoU9ZwCfTdz6
pNrepsyk/DvM2/hqRHRaTVo=
=xR0Q
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--


--===============1585324069==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1585324069==--
