Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <dexter.filmore@gmx.de>) id 1UN95d-0001cy-VM
	for linux-dvb@linuxtv.org; Tue, 02 Apr 2013 23:50:26 +0200
Received: from mout.gmx.net ([212.227.17.21])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1UN95d-00053k-F4; Tue, 02 Apr 2013 23:50:01 +0200
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
	(mrigmx002) with ESMTP (Nemesis) id 0Llskg-1UwTqC49hI-00ZRNP for
	<linux-dvb@linuxtv.org>; Tue, 02 Apr 2013 23:50:01 +0200
From: Dexter Filmore <Dexter.Filmore@gmx.de>
To: linux-dvb@linuxtv.org
Date: Tue, 2 Apr 2013 23:49:59 +0200
MIME-Version: 1.0
Message-Id: <201304022350.00017.Dexter.Filmore@gmx.de>
Subject: [linux-dvb] TT-4600 lost most channels for no good reason
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0435498552=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0435498552==
Content-Type: multipart/signed;
  boundary="nextPart1692672.XBnpC33urV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1692672.XBnpC33urV
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Debian testing 64 bit on intel core i5, TechnoTrend s2-4600 DVB-S2 USB, wor=
ked=20
a charm for 3 months with xbmc 12.1, tvheadend.

Then all of a sudden lost about 3 of 4 stations. No pattern visible like hi=
/lo=20
band or such. The stations that work work alright, all others not at all.

Tried anything from new kernel (including backporting from deb/sid and=20
compiling a fresh one from 3.8.5 source), noticed the last day before it=20
stopped working the firmware file in /lib/formware got overwritten, don't=20
know by whom, re-installed the one from TT, still the same.

Tried the box on a win7 machine, connected to the same LNB output: works=20
perfectly.

Tried various versions of liplianin drivers from v35 to v37, v39, git on 3.=
2=20
kernels from debian.

I'm all out of ideas.

Help?=20

Dex


=2D-=20
=2D----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@=20
b++(+++) DI+++ D- G++ e* h>++ r* y?
=2D-----END GEEK CODE BLOCK------

--nextPart1692672.XBnpC33urV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlFbUogACgkQm6TdMk9WhQ0L1gCcDv/RJXP2c9u/EEF3QWrnCwWw
0XgAn3qnVj7lPAkqU711qG7Dai0OsNqa
=jUA5
-----END PGP SIGNATURE-----

--nextPart1692672.XBnpC33urV--


--===============0435498552==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0435498552==--
