Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:64794 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbbEJRVy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2015 13:21:54 -0400
Received: from shodan ([217.246.198.151]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0LfXmv-1ZbJ3R19yL-00p6rX for
 <linux-media@vger.kernel.org>; Sun, 10 May 2015 19:21:52 +0200
From: Dexter Filmore <Dexter.Filmore@gmx.de>
To: linux-media@vger.kernel.org
Subject: Build LinuxTV on Raspbian?
Date: Sun, 10 May 2015 19:21:49 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1643777.O7cN05dW3R";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201505101921.49294.Dexter.Filmore@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1643777.O7cN05dW3R
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Raspbian/wheezy with 3.18.7 kernel I ran the basic approach and end up=20
somewhere here:

=2E..
v4l-cx231xx-avcore-01.fw
v4l-cx23418-apu.fw
v4l-cx23418-cpu.fw
v4l-cx23418-dig.fw
v4l-cx23885-avcore-01.fw
v4l-cx23885-enc-broken.fw
v4l-cx25840.fw
******************
* Start building *
******************
make -C /home/pi/media_build/v4l allyesconfig
make[1]: Entering directory '/home/pi/media_build/v4l'
make[2]: Entering directory '/home/pi/media_build/linux'
Applying patches for kernel 3.18.7-v7+
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
patch -s -f -N -p1 -i ../backports/debug.patch
patch -s -f -N -p1 -i ../backports/drx39xxj.patch
patch -s -f -N -p1 -i ../backports/v4.0_dma_buf_export.patch
patch -s -f -N -p1 -i ../backports/v4.0_drop_trace.patch
Patched drivers/media/dvb-core/dvbdev.c
Patched drivers/media/v4l2-core/v4l2-dev.c
Patched drivers/media/rc/rc-main.c
make[2]: Leaving directory '/home/pi/media_build/linux'
=2E/scripts/make_kconfig.pl /lib/modules/3.18.7-v7+/build /lib/modules/3.18=
=2E7-v7+/build=20
1
Preparing to compile for kernel version 3.18.7
=46ile not found: /lib/modules/3.18.7-v7+/build/.config=20
at ./scripts/make_kconfig.pl line 33, <IN> line 4.
Makefile:366: recipe for target 'allyesconfig' failed
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory '/home/pi/media_build/v4l'
Makefile:26: recipe for target 'allyesconfig' failed
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 490.


I am clueless what goes wrong, pointers appreciated.
A generic google search regarding kernel module compiles on RasPis=20
points some kernel config files are not in place where they should be,=20
but I don't know how to tackle the issue.

Dex




=2D-=20
=2D----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@=20
b++(+++) DI+++ D- G++ e* h>++ r* y?
=2D-----END GEEK CODE BLOCK------

--nextPart1643777.O7cN05dW3R
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlVPk60ACgkQm6TdMk9WhQ38eQCfcLnzsDMm/CmbXmrE7i+EF+8U
w0QAoOLX3iEXOmk0ygi2LMrZOmEXwlKq
=PThx
-----END PGP SIGNATURE-----

--nextPart1643777.O7cN05dW3R--
