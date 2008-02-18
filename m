Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp27.orange.fr ([80.12.242.96])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.bercot@wanadoo.fr>) id 1JR5Sa-0006wq-Ca
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 13:51:04 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2716.orange.fr (SMTP Server) with ESMTP id AA4261C00093
	for <linux-dvb@linuxtv.org>; Mon, 18 Feb 2008 13:50:30 +0100 (CET)
Received: from localhost (ANantes-252-1-77-76.w86-195.abo.wanadoo.fr
	[86.195.216.76])
	by mwinf2716.orange.fr (SMTP Server) with ESMTP id 4A99C1C00082
	for <linux-dvb@linuxtv.org>; Mon, 18 Feb 2008 13:50:30 +0100 (CET)
Date: Mon, 18 Feb 2008 13:50:27 +0100
From: David BERCOT <david.bercot@wanadoo.fr>
To: linux-dvb@linuxtv.org
Message-ID: <20080218135027.2b6a10e7@wanadoo.fr>
Mime-Version: 1.0
Subject: [linux-dvb] Error compiling multiproto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1562928845=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1562928845==
Content-Type: multipart/signed; boundary="Sig_/CgAB0NpyroRaApr.T=d/JJ.";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/CgAB0NpyroRaApr.T=d/JJ.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

After a clean install, I try to compile multiproto. But, after the
"make", I have this error :
In file included from /opt/dvb/multiproto/v4l/em28xx-audio.c:39:
include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in
a function) /opt/dvb/multiproto/v4l/em28xx-audio.c:58: error: array
index in initializer not of integer
type /opt/dvb/multiproto/v4l/em28xx-audio.c:58: error: (near
initialization for 'index') make[3]: ***
[/opt/dvb/multiproto/v4l/em28xx-audio.o] Error 1 make[2]: ***
[_module_/opt/dvb/multiproto/v4l] Error 2 make[2]: Leaving directory
`/usr/src/linux-headers-2.6.24-1-amd64' make[1]: *** [default] Erreur 2
make[1]: quittant le r=C3=A9pertoire =C2=AB /opt/dvb/multiproto/v4l =C2=BB =
make: ***
[all] Erreur 2

Google is not very helpful, so, if you have any idea ?

Thank you very much.

David.

--Sig_/CgAB0NpyroRaApr.T=d/JJ.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHuX8TvSnthbGI8ygRAlnaAJ4qn0QGFHkuwQ0Ot2OpkXTz22HJ1QCfcEbY
/l6mXLBpbyrXpn5MBOveOrc=
=EV0D
-----END PGP SIGNATURE-----

--Sig_/CgAB0NpyroRaApr.T=d/JJ.--



--===============1562928845==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1562928845==--
