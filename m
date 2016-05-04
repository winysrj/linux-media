Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62249 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbcEDT3D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 15:29:03 -0400
Date: Wed, 4 May 2016 21:28:45 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.6-rc1] media updates
Message-ID: <20160504212845.21dab7c8@mir>
In-Reply-To: <CA+55aFyE82Hi29az_MG9oG0=AEg1o++Wng_DO2RvNHQsSOz87g@mail.gmail.com>
References: <20160315080552.3cc5d146@recife.lan>
	<20160503233859.0f6506fa@mir>
	<CA+55aFxAor=MJSGFkynu72AQN75bNTh9kewLR4xe8CpjHQQvZQ@mail.gmail.com>
	<20160504063902.0af2f4d7@mir>
	<CA+55aFyE82Hi29az_MG9oG0=AEg1o++Wng_DO2RvNHQsSOz87g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//D.fC5zdrxpwRT1/mvrnY+K"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_//D.fC5zdrxpwRT1/mvrnY+K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi

On 2016-05-04, Linus Torvalds wrote:
> On Tue, May 3, 2016 at 9:39 PM, Stefan Lippers-Hollmann <s.l-h@gmx.de> wr=
ote:
> >
> > Just as a cross-check, this (incomplete, but au0828, cx231xx and em28xx
> > aren't needed/ loaded on my system) crude revert avoids the problem for
> > me on v4.6-rc6-113-g83858a7. =20
>=20
> Hmm.
>=20
> That just open-codes __media_device_usb_init().
>=20
> The main difference seems to be that __media_device_usb_init() ends up
> having that
>=20
>      #ifdef CONFIG_USB
>      #endif
>=20
> around it.
>=20
> I think that is bogus.
>=20
> What happens if you replace that #ifdef CONFIG_USB in
> __media_device_usb_init() with
>=20
>     #if CONFIG_USB || (MODULE && CONFIG_USB_MODULE)
[...]

that throws

drivers/media/media-device.c: In function '__media_device_usb_init':
drivers/media/media-device.c:878:5: warning: "CONFIG_USB" is not defined [-=
Wundef]
 #if CONFIG_USB || (MODULE && CONFIG_USB_MODULE)
     ^

however, taking arch/arm/mach-omap1/include/mach/usb.h as example,=20
changing it to=20

--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -875,7 +875,7 @@ void __media_device_usb_init(struct medi
 			     const char *board_name,
 			     const char *driver_name)
 {
-#ifdef CONFIG_USB
+#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
 	mdev->dev =3D &udev->dev;
=20
 	if (driver_name)

indeed fixes the problem for me

Thanks a lot!

Regards
	Stefan Lippers-Hollmann

--Sig_//D.fC5zdrxpwRT1/mvrnY+K
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXKk1tAAoJEL/gLWWx0ULtYs8P/0c/OtHC22oIJzs8bEoQSZiG
nsnlkJZr8SVlYg2qOtPmvaZC8ajYuGQOH0UGMIADZ+A30Vs/wN092cN/93/sO/O+
v1W3ExIy1Rzwj7naZXPTC4EUlI+vCPjqHWnlCHNoTgqC/xnAFwr42aON6HyGZ94k
nxYFxJ76WyfnutEA48rYFDXG46njN01RJXQV4iYfhUL6aMNEGffBncyp/E2NHVV+
luUiCLFFg5R49bzh9YOk4KbrXtdaJm2zRFwPukN+oZ05nMvgt3FIohaML0ZoCHQ2
9HuICcFV6wwmMuPMr3d/NF8OreRAucxu5UMcyQlx0jRRuWHJh1pkQWt9CaAhEQUf
nJRuSaa8cgzcJGrtxVm8SafGfPdJ0eDjpcg7WDWvEEqH344emIiHXTmd8stBChvE
aH462t300y8zXvNTCPDMcloI9kOExKJOJXGTjpS6TMs60RT6EB5ofkzLZvfzWlrq
g3YLas5me0MYxs5cb6uA+aUitWADq2XHGKxj7Fn6Ae8Cua19xpLe2BRQPQlg97wm
OvaKPh97LGnuLxb36jKgnUfK9woUmPB1FiiCW28srEm84MaZaNK5knJ9053lv258
XNsrFXal+sWOXhlP8xMrwuzGNoKXU9FJht0tQnB2Ep0WmS7x3Fi0ZHNMbycrJgOg
O4um+d0uYKPprW0WRgA6
=YlDY
-----END PGP SIGNATURE-----

--Sig_//D.fC5zdrxpwRT1/mvrnY+K--
