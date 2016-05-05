Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46360 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbcEELHw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2016 07:07:52 -0400
Date: Thu, 5 May 2016 08:07:37 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.6-rc1] media updates
Message-ID: <20160505080737.5961617e@recife.lan>
In-Reply-To: <20160505010051.5b4149c8@mir>
References: <20160315080552.3cc5d146@recife.lan>
	<20160503233859.0f6506fa@mir>
	<CA+55aFxAor=MJSGFkynu72AQN75bNTh9kewLR4xe8CpjHQQvZQ@mail.gmail.com>
	<20160504063902.0af2f4d7@mir>
	<CA+55aFyE82Hi29az_MG9oG0=AEg1o++Wng_DO2RvNHQsSOz87g@mail.gmail.com>
	<20160504212845.21dab7c8@mir>
	<CA+55aFxQSUHBvOSqyiqdt2faY6VZSXP0p-cPzRm+km=fk7z4kQ@mail.gmail.com>
	<20160504185112.70ea985b@recife.lan>
	<20160505010051.5b4149c8@mir>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/c_hFjJ+OhL5uwD=MLqlXuZC"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/c_hFjJ+OhL5uwD=MLqlXuZC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Em Thu, 5 May 2016 01:00:51 +0200
Stefan Lippers-Hollmann <s.l-h@gmx.de> escreveu:

> Hi
>=20
> On 2016-05-04, Mauro Carvalho Chehab wrote:
> > Em Wed, 4 May 2016 13:49:52 -0700
> > Linus Torvalds <torvalds@linux-foundation.org> escreveu: =20
> > > On Wed, May 4, 2016 at 12:28 PM, Stefan Lippers-Hollmann <s.l-h@gmx.d=
e> wrote:   =20
> [...]
> > Stefan,
> >=20
> > Could you please test the enclosed patch?
> >=20
> > Regards,
> > Mauro
> >=20
> > [media] media-device: fix builds when USB or PCI is compiled as module
> >=20
> > Just checking ifdef CONFIG_USB is not enough, if the USB is compiled
> > as module. The same applies to PCI.
> >=20
> > Compile-tested only.
> >=20
> > So, change the logic to use, instead, IS_REACHABLE.
> >=20
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >=20
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index b84825715f98..8c1f80ff33e3 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -842,11 +842,11 @@ struct media_device *media_device_find_devres(str=
uct device *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(media_device_find_devres);
> > =20
> > +#if IS_REACHABLE(CONFIG_PCI)
> >  void media_device_pci_init(struct media_device *mdev,
> >  			   struct pci_dev *pci_dev,
> >  			   const char *name)
> >  {
> > -#ifdef CONFIG_PCI
> >  	mdev->dev =3D &pci_dev->dev;
> > =20
> >  	if (name)
> > @@ -862,16 +862,16 @@ void media_device_pci_init(struct media_device *m=
dev,
> >  	mdev->driver_version =3D LINUX_VERSION_CODE;
> > =20
> >  	media_device_init(mdev);
> > -#endif
> >  }
> >  EXPORT_SYMBOL_GPL(media_device_pci_init);
> > +#endif
> > =20
> > +#if IS_REACHABLE(CONFIG_USB)
> >  void __media_device_usb_init(struct media_device *mdev,
> >  			     struct usb_device *udev,
> >  			     const char *board_name,
> >  			     const char *driver_name)
> >  {
> > -#ifdef CONFIG_USB
> >  	mdev->dev =3D &udev->dev;
> > =20
> >  	if (driver_name)
> > @@ -891,9 +891,9 @@ void __media_device_usb_init(struct media_device *m=
dev,
> >  	mdev->driver_version =3D LINUX_VERSION_CODE;
> > =20
> >  	media_device_init(mdev);
> > -#endif
> >  }
> >  EXPORT_SYMBOL_GPL(__media_device_usb_init);
> > +#endif
> > =20
> > =20
> >  #endif /* CONFIG_MEDIA_CONTROLLER */
> >=20
> >  =20
>=20
> This fails to build for me with:
>=20
> [...]
> Setup is 16348 bytes (padded to 16384 bytes).
> System is 3319 kB
> CRC a9178215
> Kernel: arch/x86/boot/bzImage is ready  (#1)
> ERROR: "__media_device_usb_init" [drivers/media/usb/siano/smsusb.ko] unde=
fined!
> ERROR: "__media_device_usb_init" [drivers/media/usb/em28xx/em28xx.ko] und=
efined!
> ERROR: "__media_device_usb_init" [drivers/media/usb/dvb-usb/dvb-usb.ko] u=
ndefined!
> ERROR: "__media_device_usb_init" [drivers/media/usb/dvb-usb-v2/dvb_usb_v2=
.ko] undefined!
> ERROR: "__media_device_usb_init" [drivers/media/usb/cx231xx/cx231xx.ko] u=
ndefined!
> ERROR: "__media_device_usb_init" [drivers/media/usb/au0828/au0828.ko] und=
efined!
> scripts/Makefile.modpost:91: recipe for target '__modpost' failed
> make[6]: *** [__modpost] Error 1
> Makefile:1147: recipe for target 'modules' failed
> [...]
>=20
> I've attached my gzipped kernel configs for amd64 and i386.
>=20
> Regards
> 	Stefan Lippers-Hollmann

Oh, in this case, it should be using IS_ENABLED() macro instead.
The following patch should fix it. I tested here with some different
setups, as described in the patch, and with your .i686 .config.

Please double-check and ack if it is ok for you.

Regards,
Mauro


[PATCH v2] [media] media-device: fix builds when USB or PCI is compiled
 as module

Just checking ifdef CONFIG_USB is not enough, if the USB is compiled
as module. The same applies to PCI.

Tested with the following .config alternatives:

CONFIG_USB=3Dm
CONFIG_MEDIA_CONTROLLER=3Dy
CONFIG_MEDIA_SUPPORT=3Dm
CONFIG_VIDEO_AU0828=3Dm

CONFIG_USB=3Dm
CONFIG_MEDIA_CONTROLLER=3Dy
CONFIG_MEDIA_SUPPORT=3Dy
CONFIG_VIDEO_AU0828=3Dm

CONFIG_USB=3Dy
CONFIG_MEDIA_CONTROLLER=3Dy
CONFIG_MEDIA_SUPPORT=3Dy
CONFIG_VIDEO_AU0828=3Dm

CONFIG_USB=3Dy
CONFIG_MEDIA_CONTROLLER=3Dy
CONFIG_MEDIA_SUPPORT=3Dy
CONFIG_VIDEO_AU0828=3Dy

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6e43c95629ea..3cfd7af8c5ca 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -846,11 +846,11 @@ struct media_device *media_device_find_devres(struct =
device *dev)
 }
 EXPORT_SYMBOL_GPL(media_device_find_devres);
=20
+#if IS_ENABLED(CONFIG_PCI)
 void media_device_pci_init(struct media_device *mdev,
 			   struct pci_dev *pci_dev,
 			   const char *name)
 {
-#ifdef CONFIG_PCI
 	mdev->dev =3D &pci_dev->dev;
=20
 	if (name)
@@ -866,16 +866,16 @@ void media_device_pci_init(struct media_device *mdev,
 	mdev->driver_version =3D LINUX_VERSION_CODE;
=20
 	media_device_init(mdev);
-#endif
 }
 EXPORT_SYMBOL_GPL(media_device_pci_init);
+#endif
=20
+#if IS_ENABLED(CONFIG_USB)
 void __media_device_usb_init(struct media_device *mdev,
 			     struct usb_device *udev,
 			     const char *board_name,
 			     const char *driver_name)
 {
-#ifdef CONFIG_USB
 	mdev->dev =3D &udev->dev;
=20
 	if (driver_name)
@@ -895,9 +895,9 @@ void __media_device_usb_init(struct media_device *mdev,
 	mdev->driver_version =3D LINUX_VERSION_CODE;
=20
 	media_device_init(mdev);
-#endif
 }
 EXPORT_SYMBOL_GPL(__media_device_usb_init);
+#endif
=20
=20
 #endif /* CONFIG_MEDIA_CONTROLLER */



Thanks,
Mauro

--Sig_/c_hFjJ+OhL5uwD=MLqlXuZC
Content-Type: application/pgp-signature
Content-Description: Assinatura digital OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXKyl7AAoJEAhfPr2O5OEVkxoQAJuQPSerr9y9mu9Yan1gwtIV
e7YZT7MBqkaUZOcD2oMWITQ6Y4L5eoZldqDtUQnH5hSzOxLVTtqfXY3wkNwZy24A
qX0/0m+6CkAXaW/VURb1JJQsxT0l63eogVBgX4Obh6mzGoNxmaO8Gdh3zY6IzsGd
bfoS+8UJSrNhXB5ZkhmgNX4EsqhgQ1rXqqHw2vFTLPDNQDm1QQkXpFUV5BBu6psA
b7nVRJF5Wf6Tb+rerzQojoxTZU1emsvSrayg/mBxsNfgpVpNjdY97RVa6XTRMhnq
+U11JfmafSR1trB/m2IO9rvAXE7WmW7woF31/lgF5notkKtSoWHeinPgXQWw6Ym/
wDzmM77bVftLcfN9l+4wgdNpvBBU9Y8qF7mdqm0J/S4YGiFVIiN1ENiBUjW12sEm
wpy7jdkCIPIq5CKh+cHrX6ioXGoJF5JMJB1LHU8k1FTKonx31YrpkD/Q1nLwQUd2
MEv5Sz7Lq9EYXoNjUCTIrLAy5bT/gUQ6U0oZrtlU/6B/wcE3FThMF2+FxwGQMK7g
V3HiKWaGKlmh/IpQXoedpHE6vtg6BdhH7wC5lup366iMNyTpUPe3nvqcdVx6hx0N
1kQmVEfTjsczEutaYhtc04SrDqUyenNj00eOELh3D2rGiQJqrYP/aQohBfvFIzZB
3n1L1eT1W/SeytQFtLRj
=A8wj
-----END PGP SIGNATURE-----

--Sig_/c_hFjJ+OhL5uwD=MLqlXuZC--
