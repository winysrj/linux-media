Return-path: <linux-media-owner@vger.kernel.org>
Received: from b186.blue.fastwebserver.de ([62.141.42.186]:48885 "EHLO
	mail.gw90.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbZH0L3F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 07:29:05 -0400
Received: from f053036086.adsl.alicedsl.de ([78.53.36.86] helo=[192.168.178.25])
	by mail.gw90.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <paulepanter@users.sourceforge.net>)
	id 1MgdA8-0004ha-1d
	for linux-media@vger.kernel.org; Thu, 27 Aug 2009 11:29:04 +0000
Subject: Compile modules on 64-bit Linux kernel system for 686 Linux kernel
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zYBYshO5CIEM/s0x4B4K"
Date: Thu, 27 Aug 2009 13:28:57 +0200
Message-Id: <1251372537.5593.22.camel@mattotaupa.wohnung.familie-menzel.net>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-zYBYshO5CIEM/s0x4B4K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi guys,

( please CC )


I am running Debian Sid/unstable with a 32-bit userspace with a 64-bit
kernel [1]. I want to compile the v4l-dvb modules for a 686 kernel [2]
on this system.

I installed the header files for the 686 kernel [3], but running

$ ARCH=3D686 make
make -C /tmp/v4l-dvb/v4l=20
make[1]: Entering directory `/tmp/v4l-dvb/v4l'
perl
scripts/make_config_compat.pl /lib/modules/2.6.30-1-amd64/source ./.myconfi=
g ./config-compat.h
creating symbolic links...
make -C firmware prep
make[2]: Entering directory `/tmp/v4l-dvb/v4l/firmware'
make[2]: Leaving directory `/tmp/v4l-dvb/v4l/firmware'
make -C firmware
make[2]: Entering directory `/tmp/v4l-dvb/v4l/firmware'
  CC  ihex2fw
Generating vicam/firmware.fw
Generating dabusb/firmware.fw
Generating dabusb/bitstream.bin
Generating ttusb-budget/dspbootcode.bin
Generating cpia2/stv0672_vp4.bin
Generating av7110/bootcode.bin
make[2]: Leaving directory `/tmp/v4l-dvb/v4l/firmware'
Kernel build directory is /lib/modules/2.6.30-1-amd64/build
make -C /lib/modules/2.6.30-1-amd64/build SUBDIRS=3D/tmp/v4l-dvb/v4l
modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.30-1-amd64'
[=E2=80=A6]

still uses the 64-bit modules in /lib/modules/2.6.30-1-amd64 and the
files in /usr/src/linux-headers-2.6.30-1-amd64.

I do not even know if this is the correct way.

Can someone of you please enlighten me?


Thanks,

Paul


[1] http://packages.debian.org/de/sid/linux-image-2.6.30-1-amd64
[2] http://packages.debian.org/de/sid/linux-image-2.6.30-1-686
[3] http://packages.debian.org/de/sid/linux-headers-2.6.30-1-686

--=-zYBYshO5CIEM/s0x4B4K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqWbfkACgkQPX1aK2wOHVh22wCdEx/nuLPO3MiGskPF2D6dcUk+
7e4An0MNeL2r10eX1Edg1IDtYfeTrAaZ
=fszL
-----END PGP SIGNATURE-----

--=-zYBYshO5CIEM/s0x4B4K--

