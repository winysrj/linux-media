Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from boh-84-242-76-108.karneval.cz ([84.242.91.163]
	helo=ip-89-102-161-185.karneval.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ondrej@holecek.eu>) id 1JT7Ca-00019M-RO
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 04:06:56 +0100
Received: from [10.162.61.87] (ip-85-160-0-18.eurotel.cz [85.160.0.18])
	by ip-89-102-161-185.karneval.cz (Postfix) with ESMTP id 545A89DA6F
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 04:06:32 +0100 (CET)
Message-ID: <47C0DF27.7010407@holecek.eu>
Date: Sun, 24 Feb 2008 04:06:15 +0100
From: Ondrej Holecek <ondrej@holecek.eu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] experimental drivers and 2.6.24 kernel
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1677405119=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============1677405119==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7A267DD181F98FD18BAE7714"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7A267DD181F98FD18BAE7714
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

hello,

i have problems with compiling experimental drivers from
http://mcentral.de/hg/~mrec/v4l-dvb-experimental/ with kernel 2.6.24

i need it for my eb1a:e323 eMPIA Technology, Inc. (digivox a/d II)

non experimental drivers compile without problems, am I doing something
wrong?

this is what i get:

chaos:/home/oho/tmp/dvb# cd v4l-dvb-experimental-6c81945e4403/
chaos:/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403# make
make -C /usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l
make[1]: Entering directory
`/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l'
creating symbolic links...
make -C /lib/modules/2.6.24/build
SUBDIRS=3D/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l  mo=
dules
make[2]: Entering directory `/usr/src/linux-2.6.24'
  CC [M]
/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l/flexcop-pci.o=

In file included from
/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l/flexcop-commo=
n.h:23,
                 from
/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l/flexcop-pci.c=
:10:
/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l/dvb_frontend.=
h:42:33:
error: media/v4l_dvb_tuner.h: No such file or directory
In file included from
/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l/flexcop-commo=
n.h:23,
                 from
/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l/flexcop-pci.c=
:10:
/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l/dvb_frontend.=
h:165:
error: field 'tuner_ops' has incomplete type
make[3]: ***
[/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l/flexcop-pci.=
o]
Error 1
make[2]: ***
[_module_/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l]
Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.24'
make[1]: *** [default] Error 2
make[1]: Leaving directory
`/usr/home/oho/tmp/dvb/v4l-dvb-experimental-6c81945e4403/v4l'
make: *** [all] Error 2


--------------enig7A267DD181F98FD18BAE7714
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUBR8DfK7+9cGMV5qZXAQLcXQf+LvfzDhgUiRVF1k5DeWafvAQ0kc1XK5SX
IH9VbtP9d+YJ4QCmhvKBBtQG8PD3HmHydHf2le52Zvz5EQZxnfvDc7sbh2uwkbED
/PR2naktbwVSPjs8nMOfcgNo5PwRVl0nJeygkwWLt+zSKVrLYMLxXOtaAiKJrXbH
Gu/fDuAT+/2nIH6ZyGuqcrAJ1v1jqZEVY/iGtUIgZ5H4OdzaU/ViHQ0ltmwN7D3t
61OHLBDUZ8eNf5MxYR/m6iwndg11d9664Ptz3n0zkFyL2gCEmA06jCRW3bALsfCw
cBLbfVDkNR/d1QSEZLUrVI9yQTJ17C1iPKc+3PADokUUaIgLmFEIWQ==
=nASo
-----END PGP SIGNATURE-----

--------------enig7A267DD181F98FD18BAE7714--


--===============1677405119==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1677405119==--
