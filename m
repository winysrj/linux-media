Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp20.orange.fr ([193.252.22.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.bercot@wanadoo.fr>) id 1JXxWe-0008OM-Po
	for linux-dvb@linuxtv.org; Sat, 08 Mar 2008 12:47:41 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2016.orange.fr (SMTP Server) with ESMTP id 2B5A11C0009F
	for <linux-dvb@linuxtv.org>; Sat,  8 Mar 2008 12:47:07 +0100 (CET)
Received: from localhost (ANantes-252-1-38-218.w82-126.abo.wanadoo.fr
	[82.126.25.218])
	by mwinf2016.orange.fr (SMTP Server) with ESMTP id EBD8C1C00097
	for <linux-dvb@linuxtv.org>; Sat,  8 Mar 2008 12:47:06 +0100 (CET)
Date: Sat, 8 Mar 2008 12:47:00 +0100
From: David BERCOT <david.bercot@wanadoo.fr>
To: linux-dvb@linuxtv.org
Message-ID: <20080308124700.581313bc@wanadoo.fr>
Mime-Version: 1.0
Subject: [linux-dvb] Patching MythTV in order to use it with multiproto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1210110486=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1210110486==
Content-Type: multipart/signed; boundary="Sig_/sUZ9Uu3I2r6CFCbu_0yhBXg";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/sUZ9Uu3I2r6CFCbu_0yhBXg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Debian, I've downloaded the source version of MythTV :
v0.20.2.svn20080126. Then, I've downloaded the patch from
http://pansy.at/gernot/mythtv-multiproto-hack.diff.gz

But, when I try to apply it, I have these errors :
# patch <./mythtv-multiproto-hack.diff -p0
patching file libs/libmythtv/dvbchannel.cpp
Hunk #1 FAILED at 138.
Hunk #2 succeeded at 146 (offset -11 lines).
Hunk #3 FAILED at 452.
Hunk #4 FAILED at 509.
Hunk #5 succeeded at 586 with fuzz 1 (offset 19 lines).
Hunk #6 FAILED at 625.
Hunk #7 succeeded at 670 (offset 19 lines).
Hunk #8 succeeded at 800 (offset -33 lines).
Hunk #9 FAILED at 850.
5 out of 9 hunks FAILED -- saving rejects to file libs/libmythtv/dvbchannel=
.cpp.rej

Do have any idea to resolve these errors ?

Thank you very much.

David.

--Sig_/sUZ9Uu3I2r6CFCbu_0yhBXg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH0ny6vSnthbGI8ygRAg8HAJ0YDUho0cq0bB1KdFqTmxoneKiWeACgj/bB
WTIvOdNhVnqqpyshc+vP1eE=
=oI9D
-----END PGP SIGNATURE-----

--Sig_/sUZ9Uu3I2r6CFCbu_0yhBXg--



--===============1210110486==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1210110486==--
