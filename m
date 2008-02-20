Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp28.orange.fr ([80.12.242.101])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.bercot@wanadoo.fr>) id 1JRsNv-00027X-6R
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 18:05:31 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2824.orange.fr (SMTP Server) with ESMTP id 7867670000B0
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 18:04:54 +0100 (CET)
Received: from localhost (ANantes-252-1-77-76.w86-195.abo.wanadoo.fr
	[86.195.216.76])
	by mwinf2824.orange.fr (SMTP Server) with ESMTP id 17B41700009A
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 18:04:53 +0100 (CET)
Date: Wed, 20 Feb 2008 18:04:51 +0100
From: David BERCOT <david.bercot@wanadoo.fr>
To: linux-dvb@linuxtv.org
Message-ID: <20080220180451.1425e22d@wanadoo.fr>
Mime-Version: 1.0
Subject: [linux-dvb] Scan patched...
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0026414245=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0026414245==
Content-Type: multipart/signed; boundary="Sig_/fKMncdwpAx_x_fkAqju1g2U";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/fKMncdwpAx_x_fkAqju1g2U
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi again,

I'm trying to compile scan.

First, I've downloaded dvb-apps :
# hg clone http://linuxtv.org/hg/dvb-apps
Then, I've downloaded scan package from :
http://jusst.de/manu/scan.tar.bz2
I've replaced dvb-apps/util/scan with files from this package.
I've added the 'include' folder from multiproto to the dvb-apps folder.
Then, in dvb-apps/util/scan, I've done :
# make clean
# make
and I have this error :
perl section_generate.pl atsc_psip_section.pl
CC scan.o
scan.c:449: warning: unused parameter =E2=80=98buf=E2=80=99
scan.c: In function =E2=80=98tune_to_transponder=E2=80=99:
scan.c:1676: error: storage size of =E2=80=98fe_info1=E2=80=99 isn=E2=80=99=
t known
scan.c:1679: error: invalid application of =E2=80=98sizeof=E2=80=99 to inco=
mplete type
=E2=80=98struct dvbfe_info=E2=80=99 scan.c:1682: error: =E2=80=98DVBFE_DELS=
YS_DVBS=E2=80=99 undeclared
(first use in this function) scan.c:1682: error: (Each undeclared
identifier is reported only once scan.c:1682: error: for each function
it appears in.) scan.c:1684: error: =E2=80=98DVBFE_DELSYS_DVBS2=E2=80=99 un=
declared
(first use in this function) scan.c:1686: error: =E2=80=98DVBFE_GET_INFO=E2=
=80=99
undeclared (first use in this function) scan.c:1697: error:
=E2=80=98DVBFE_DELSYS_DSS=E2=80=99 undeclared (first use in this function) =
scan.c:1676:
warning: unused variable =E2=80=98fe_info1=E2=80=99 make: *** [scan.o] Erre=
ur 1

To be honest, I'm lost...

Do you have any idea ?

Thank you.

David.

--Sig_/fKMncdwpAx_x_fkAqju1g2U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvF2zvSnthbGI8ygRAsXWAJwIoXXkfkEASBrc/XE/7mnrxK/gLwCgiiXH
/o8to5V00WppFfKcxwvkjfI=
=QWFm
-----END PGP SIGNATURE-----

--Sig_/fKMncdwpAx_x_fkAqju1g2U--



--===============0026414245==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0026414245==--
