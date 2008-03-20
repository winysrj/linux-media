Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp23.orange.fr ([80.12.242.50])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.bercot@wanadoo.fr>) id 1JcHyI-0005DT-0H
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 11:26:06 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2347.orange.fr (SMTP Server) with ESMTP id C33B61C00092
	for <linux-dvb@linuxtv.org>; Thu, 20 Mar 2008 11:25:31 +0100 (CET)
Received: from localhost (ANantes-252-1-56-159.w82-126.abo.wanadoo.fr
	[82.126.76.159])
	by mwinf2347.orange.fr (SMTP Server) with ESMTP id 534D71C00088
	for <linux-dvb@linuxtv.org>; Thu, 20 Mar 2008 11:25:31 +0100 (CET)
Date: Thu, 20 Mar 2008 11:25:20 +0100
From: David BERCOT <david.bercot@wanadoo.fr>
To: linux-dvb@linuxtv.org
Message-ID: <20080320112520.72b210f1@wanadoo.fr>
Mime-Version: 1.0
Subject: [linux-dvb] Error when compiling patched version of 'scan'
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2079030354=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2079030354==
Content-Type: multipart/signed; boundary="Sig_/wMHYqfTXMpMLU9ePE4YxX4w";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/wMHYqfTXMpMLU9ePE4YxX4w
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I've already compiled many times the patched version of 'scan' (from
http://jusst.de/manu/scan.tar.bz2) and, today, it does errors...

I've installed the multiproto drivers, the dvb-apps (from linuxtv.org)
[last versions, this morning] and then, I've downloaded 'scan'. I've
added in its Makefile :
CPPFLAGS +=3D -I/opt/dvb/multiproto/linux/include
(like I usually do) and launched 'make' :
perl section_generate.pl atsc_psip_section.pl
CC scan.o
scan.c:414: warning: unused parameter =E2=80=98buf=E2=80=99
scan.c:415: warning: unused parameter =E2=80=98t=E2=80=99
scan.c:449: warning: unused parameter =E2=80=98buf=E2=80=99
scan.c:518: warning: unused parameter =E2=80=98buf=E2=80=99
scan.c:519: warning: unused parameter =E2=80=98t=E2=80=99
scan.c: In function =E2=80=98tune_to_transponder=E2=80=99:
scan.c:1682: error: =E2=80=98struct dvbfe_info=E2=80=99 has no member named=
 =E2=80=98delivery=E2=80=99
scan.c:1684: error: =E2=80=98struct dvbfe_info=E2=80=99 has no member named=
 =E2=80=98delivery=E2=80=99
scan.c:1693: error: =E2=80=98struct dvbfe_info=E2=80=99 has no member named=
 =E2=80=98delivery=E2=80=99
scan.c:1704: error: =E2=80=98struct dvbfe_info=E2=80=99 has no member named=
 =E2=80=98delivery=E2=80=99
scan.c: In function =E2=80=98tune_initial=E2=80=99:
scan.c:1889: warning: unused variable =E2=80=98hier=E2=80=99
scan.c:1889: warning: unused variable =E2=80=98guard=E2=80=99
scan.c:1889: warning: unused variable =E2=80=98mode=E2=80=99
scan.c:1889: warning: unused variable =E2=80=98fec2=E2=80=99
scan.c:1889: warning: unused variable =E2=80=98bw=E2=80=99
scan.c:1889: warning: unused variable =E2=80=98qam=E2=80=99
make: *** [scan.o] Erreur 1

It is the first time I have this error...

Do you have any idea ?

Thank you very much.

David.

--Sig_/wMHYqfTXMpMLU9ePE4YxX4w
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH4juZvSnthbGI8ygRAtr8AJ4+5ULtsdT2Bb8NAEWw7iLlJ0HqVQCfT7Hj
eIFUa2k9zkaGksFS/r67h1M=
=cEEh
-----END PGP SIGNATURE-----

--Sig_/wMHYqfTXMpMLU9ePE4YxX4w--



--===============2079030354==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2079030354==--
