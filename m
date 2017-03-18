Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:42120 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751098AbdCRAek (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 20:34:40 -0400
From: Eric Anholt <eric@anholt.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Michael Zoran <mzoran@crowfest.net>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] staging: BCM2835 MMAL V4L2 camera driver
In-Reply-To: <20170316062900.0e835118@vento.lan>
References: <20170127215503.13208-1-eric@anholt.net> <20170315110128.37e2bc5a@vento.lan> <87a88m19om.fsf@eliezer.anholt.net> <20170315220834.7019fd8b@vento.lan> <1489628784.8127.1.camel@crowfest.net> <20170316062900.0e835118@vento.lan>
Date: Fri, 17 Mar 2017 17:34:36 -0700
Message-ID: <87shmbv2w3.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mauro Carvalho Chehab <mchehab@s-opensource.com> writes:

> Em Wed, 15 Mar 2017 18:46:24 -0700
> Michael Zoran <mzoran@crowfest.net> escreveu:
>
>> On Wed, 2017-03-15 at 22:08 -0300, Mauro Carvalho Chehab wrote:
>>=20
>> > No, I didn't. Thanks! Applied it but, unfortunately, didn't work.
>> > Perhaps I'm missing some other patch. I'm compiling it from
>> > the Greg's staging tree (branch staging-next):
>> > 	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.
>> > git/log/?h=3Dstaging-next
>> >=20
>> > Btw, as I'm running Raspbian, and didn't want to use compat32 bits,=C2=
=A0
>> > I'm compiling the Kernel as an arm32 bits Kernel.
>> >=20
>> > I did a small trick to build the DTB on arm32:
>> >=20
>> > 	ln -sf ../../../arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts
>> > arch/arm/boot/dts/bcm2837-rpi-3-b.dts
>> > 	ln -sf ../../../arm64/boot/dts/broadcom/bcm2837.dtsi
>> > arch/arm/boot/dts/bcm2837.dtsi
>> > 	git checkout arch/arm/boot/dts/Makefile
>> > 	sed "s,bcm2835-rpi-zero.dtb,bcm2835-rpi-zero.dtb bcm2837-rpi-3-
>> > b.dtb," a && mv a arch/arm/boot/dts/Makefile
>> >=20=20=20
>>=20
>> Two other hacks are currently needed to get the camera to work:
>>=20
>> 1. Add this to config.txt(This required to get the firmware to detect
>> the camera)
>>=20
>> start_x=3D1
>> gpu_mem=3D128
>
> I had this already.
>
>>=20
>> 2. VC4 is incompatible with the firmware at this time, so you need=20
>> to presently munge the build configuration. What you do is leave
>> simplefb in the build config(I'm assuming you already have that), but
>> you will need to remove VC4 from the config.
>>=20
>> The firmware currently adds a node for a simplefb for debugging
>> purposes to show the boot log.  Surprisingly, this is still good enough
>> for basic usage and testing.=20=20
>
> That solved the issue. Thanks! It would be good to add a notice
> about that at the TODO, not let it build if DRM_VC4.
>
> Please consider applying the enclosed path.

The VC4 incompatibility (camera firmware's AWB ends up briefly using the
GPU, without coordinating with the Linux driver) is supposed to be fixed
in current firmware
(https://github.com/raspberrypi/firmware/issues/760#issuecomment-287391025)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAljMgJwACgkQtdYpNtH8
nujtbQ//ZmDpjslTNf4wYCTi38oHCvBbClcub/AAhxyamHSUfas3yaAWY1IzZClK
5NO61WqIqTW/C/FldBGGA1xEl9kTUdCYYcskubtkVupsUv75Xm1cEUPjSmZI31HB
JnZFJEWyRksMs9NGhiyMbCqr8RJwBlZTy2G9z+N1bvGMmlhXr7jYZfLmQCYYmET3
TYj0rhsAv+A4yqCVAorwxPsCvq2aq1sw/qW4BsTXB87JfdIZFo7I2vANIporsdxm
awkmfwIMwCqOSSHNZ5Hn0Gtj57W3dNXqSVRI8hlKUPJveoL5u8vcLXNuusaBa0Uf
YGIZyGCdeTxKMjNjuX4c5pU8T22FkiL5rQTX4dmqz0Tac1LmoTlye6/ivq5SJNu0
pSpF2oB7bJbpphFemgnu/F3wK335mTIirEyHBZaNOAG9XVc6y2ACnroqCJEC7ucG
/hqa1w8ubOOBJRuBrDR2Yy2HfZiDi5YEqvUdY3LlifxuBit7bVxntbgesgKTzw7+
zYWJrXJx4+3nf/y3q9jdD2AkL3m3B5yQKu7cQQ/9e/EucMqEup2GDwxQolKWbyY8
xeNQAtsoRxt9lpoblTo/Pyqr+CMCRwK5SYqU+u6+Z4Q+k9d5ZV9n5fgvobJ2bh/W
CxcUuvNrFPc04nr/5msac94ihxFfs3kf8n7+QxjQ7lrruqPD59Y=
=Sk3u
-----END PGP SIGNATURE-----
--=-=-=--
