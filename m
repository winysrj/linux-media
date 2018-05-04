Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36208 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbeEDODT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 10:03:19 -0400
Date: Fri, 4 May 2018 11:02:53 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 7/7] media: via-camera: allow build on non-x86 archs
 with COMPILE_TEST
Message-ID: <20180504110241.7a78263d@vento.lan>
In-Reply-To: <5323943.SkjzUNBk3k@amdc3058>
References: <cover.1524245455.git.mchehab@s-opensource.com>
        <396bfb33e763c31ead093ac1035b2ecf7311b5bc.1524245455.git.mchehab@s-opensource.com>
        <20180420160321.4ecefa00@vento.lan>
        <CGME20180423121932eucas1p212eb6412ff8df511047c3afa782db6e0@eucas1p2.samsung.com>
        <5323943.SkjzUNBk3k@amdc3058>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Apr 2018 14:19:31 +0200
Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> escreveu:

> Hi Mauro,
>=20
> On Friday, April 20, 2018 04:03:21 PM Mauro Carvalho Chehab wrote:
> > This driver depends on FB_VIA for lots of things. Provide stubs
> > for the functions it needs, in order to allow building it with
> > COMPILE_TEST outside x86 architecture. =20
>=20
> Please cc: me on fbdev related patches (patch adding new FB_VIA
> ifdefs _is_ definitely fbdev related).

Ok. Btw, get maintainer script only gets the fbdev ML:

$ ./scripts/get_maintainer.pl -f include/linux/via-core.h
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> (maintainer:VIA UNICHR=
OME(PRO)/CHROME9 FRAMEBUFFER DRIVER)
linux-fbdev@vger.kernel.org (open list:VIA UNICHROME(PRO)/CHROME9 FRAMEBUFF=
ER DRIVER)
linux-kernel@vger.kernel.org (open list)

It probably makes sense to add a:

R: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

At the MAINTAINERS' entry for VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER.


>=20
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >=20
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kc=
onfig
> > index e3229f7baed1..abaaed98a044 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -15,7 +15,7 @@ source "drivers/media/platform/marvell-ccic/Kconfig"
> > =20
> >  config VIDEO_VIA_CAMERA
> >  	tristate "VIAFB camera controller support"
> > -	depends on FB_VIA
> > +	depends on FB_VIA || COMPILE_TEST =20
>=20
> This is incorrect (too simple), please take a look at FB_VIA entry:
>=20
> config FB_VIA
>        tristate "VIA UniChrome (Pro) and Chrome9 display support"
>        depends on FB && PCI && X86 && GPIOLIB && I2C
>        select FB_CFB_FILLRECT
>        select FB_CFB_COPYAREA
>        select FB_CFB_IMAGEBLIT
>        select I2C_ALGOBIT
>        help
>=20
> Therefore you also need to check PCI, GPIOLIB && I2C dependencies.

OK. I'll add id, addressing the other issues you pointed and send
a version 2 of the patches on this series that weren't merged.

>=20
> * For PCI=3Dn:
>=20
> drivers/media/platform/via-camera.c: In function =E2=80=98viacam_serial_i=
s_enabled=E2=80=99:
> drivers/media/platform/via-camera.c:1286:9: error: implicit declaration o=
f function =E2=80=98pci_find_bus=E2=80=99 [-Werror=3Dimplicit-function-decl=
aration]
> drivers/media/platform/via-camera.c:1286:25: warning: initialization make=
s pointer from integer without a cast [enabled by default]
> drivers/media/platform/via-camera.c:1296:2: error: implicit declaration o=
f function =E2=80=98pci_bus_read_config_byte=E2=80=99 [-Werror=3Dimplicit-f=
unction-declaration]
> drivers/media/platform/via-camera.c:1308:2: error: implicit declaration o=
f function =E2=80=98pci_bus_write_config_byte=E2=80=99 [-Werror=3Dimplicit-=
function-declaration]
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/media/platform/via-camera.o] Error 1
>=20
> * For I2C=3Dn:
>=20
> WARNING: unmet direct dependencies detected for VIDEO_OV7670
>   Depends on [n]: MEDIA_SUPPORT [=3Dy] && I2C [=3Dn] && VIDEO_V4L2 [=3Dy]=
 && MEDIA_CAMERA_SUPPORT [=3Dy]
>   Selected by [y]:
>   - VIDEO_VIA_CAMERA [=3Dy] && MEDIA_SUPPORT [=3Dy] && V4L_PLATFORM_DRIVE=
RS [=3Dy] && (FB_VIA [=3Dn] || COMPILE_TEST [=3Dy])
>=20
> drivers/media/i2c/ov7670.c: In function =E2=80=98ov7670_read_smbus=E2=80=
=99:
> drivers/media/i2c/ov7670.c:483:2: error: implicit declaration of function=
 =E2=80=98i2c_smbus_read_byte_data=E2=80=99 [-Werror=3Dimplicit-function-de=
claration]
>   ret =3D i2c_smbus_read_byte_data(client, reg);
>   ^
> drivers/media/i2c/ov7670.c: In function =E2=80=98ov7670_write_smbus=E2=80=
=99:
> drivers/media/i2c/ov7670.c:496:2: error: implicit declaration of function=
 =E2=80=98i2c_smbus_write_byte_data=E2=80=99 [-Werror=3Dimplicit-function-d=
eclaration]
>   int ret =3D i2c_smbus_write_byte_data(client, reg, value);
>   ^
> drivers/media/i2c/ov7670.c: In function =E2=80=98ov7670_read_i2c=E2=80=99:
> drivers/media/i2c/ov7670.c:521:2: error: implicit declaration of function=
 =E2=80=98i2c_transfer=E2=80=99 [-Werror=3Dimplicit-function-declaration]
>   ret =3D i2c_transfer(client->adapter, &msg, 1);
>   ^
> drivers/media/i2c/ov7670.c: In function =E2=80=98ov7670_probe=E2=80=99:
> drivers/media/i2c/ov7670.c:1835:3: error: implicit declaration of functio=
n =E2=80=98i2c_adapter_id=E2=80=99 [-Werror=3Dimplicit-function-declaration]
>    v4l_dbg(1, debug, client,
>    ^
> drivers/media/i2c/ov7670.c: At top level:
> drivers/media/i2c/ov7670.c:1962:1: warning: data definition has no type o=
r storage class [enabled by default]
>  module_i2c_driver(ov7670_driver);
>  ^
> drivers/media/i2c/ov7670.c:1962:1: error: type defaults to =E2=80=98int=
=E2=80=99 in declaration of =E2=80=98module_i2c_driver=E2=80=99 [-Werror=3D=
implicit-int]
> drivers/media/i2c/ov7670.c:1962:1: warning: parameter names (without type=
s) in function declaration [enabled by default]
> drivers/media/i2c/ov7670.c:1952:26: warning: =E2=80=98ov7670_driver=E2=80=
=99 defined but not used [-Wunused-variable]
>  static struct i2c_driver ov7670_driver =3D {
>                           ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/media/i2c/ov7670.o] Error 1
>=20
> * For GPIOLIB=3Dn it builds fine.
>=20
> >  	select VIDEOBUF_DMA_SG
> >  	select VIDEO_OV7670
> >  	help
> > diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platfo=
rm/via-camera.c
> > index e9a02639554b..4ab1695b33af 100644
> > --- a/drivers/media/platform/via-camera.c
> > +++ b/drivers/media/platform/via-camera.c
> > @@ -27,7 +27,10 @@
> >  #include <linux/via-core.h>
> >  #include <linux/via-gpio.h>
> >  #include <linux/via_i2c.h>
> > +
> > +#ifdef CONFIG_FB_VIA =20
>=20
> This should be CONFIG_X86.
>=20
> >  #include <asm/olpc.h>
> > +#endif
> > =20
> >  #include "via-camera.h"
> > =20
> > @@ -1283,6 +1286,11 @@ static bool viacam_serial_is_enabled(void)
> >  	struct pci_bus *pbus =3D pci_find_bus(0, 0);
> >  	u8 cbyte;
> > =20
> > +#ifdef CONFIG_FB_VIA =20
>=20
> ditto
>=20
> > +	if (!machine_is_olpc())
> > +		return false;
> > +#endif
> > +
> >  	if (!pbus)
> >  		return false;
> >  	pci_bus_read_config_byte(pbus, VIACAM_SERIAL_DEVFN,
> > @@ -1343,7 +1351,7 @@ static int viacam_probe(struct platform_device *p=
dev)
> >  		return -ENOMEM;
> >  	}
> > =20
> > -	if (machine_is_olpc() && viacam_serial_is_enabled())
> > +	if (viacam_serial_is_enabled())
> >  		return -EBUSY;
> > =20
> >  	/*
> > diff --git a/include/linux/via-core.h b/include/linux/via-core.h
> > index 9c21cdf3e3b3..ced4419baef8 100644
> > --- a/include/linux/via-core.h
> > +++ b/include/linux/via-core.h
> > @@ -70,8 +70,12 @@ struct viafb_pm_hooks {
> >  	void *private;
> >  };
> > =20
> > +#ifdef CONFIG_FB_VIA
> >  void viafb_pm_register(struct viafb_pm_hooks *hooks);
> >  void viafb_pm_unregister(struct viafb_pm_hooks *hooks);
> > +#else
> > +static inline void viafb_pm_register(struct viafb_pm_hooks *hooks) {}
> > +#endif /* CONFIG_FB_VIA */
> >  #endif /* CONFIG_PM */
> > =20
> >  /*
> > @@ -113,8 +117,13 @@ struct viafb_dev {
> >   * Interrupt management.
> >   */
> > =20
> > +#ifdef CONFIG_FB_VIA
> >  void viafb_irq_enable(u32 mask);
> >  void viafb_irq_disable(u32 mask);
> > +#else
> > +static inline void viafb_irq_enable(u32 mask) {}
> > +static inline void viafb_irq_disable(u32 mask) {}
> > +#endif
> > =20
> >  /*
> >   * The global interrupt control register and its bits.
> > @@ -157,10 +166,18 @@ void viafb_irq_disable(u32 mask);
> >  /*
> >   * DMA management.
> >   */
> > +#ifdef CONFIG_FB_VIA
> >  int viafb_request_dma(void);
> >  void viafb_release_dma(void);
> >  /* void viafb_dma_copy_out(unsigned int offset, dma_addr_t paddr, int =
len); */
> >  int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg,=
 int nsg);
> > +#else
> > +static inline int viafb_request_dma(void) { return 0; }
> > +static inline void viafb_release_dma(void) {}
> > +static inline int viafb_dma_copy_out_sg(unsigned int offset,
> > +					struct scatterlist *sg, int nsg)
> > +{ return 0; }
> > +#endif
> > =20
> >  /*
> >   * DMA Controller registers.
> > diff --git a/include/linux/via-gpio.h b/include/linux/via-gpio.h
> > index 8281aea3dd6d..b5a96cf7a874 100644
> > --- a/include/linux/via-gpio.h
> > +++ b/include/linux/via-gpio.h
> > @@ -8,7 +8,11 @@
> >  #ifndef __VIA_GPIO_H__
> >  #define __VIA_GPIO_H__
> > =20
> > +#ifdef CONFIG_FB_VIA
> >  extern int viafb_gpio_lookup(const char *name);
> >  extern int viafb_gpio_init(void);
> >  extern void viafb_gpio_exit(void);
> > +#else
> > +static inline int viafb_gpio_lookup(const char *name) { return 0; }
> > +#endif
> >  #endif
> > diff --git a/include/linux/via_i2c.h b/include/linux/via_i2c.h
> > index 44532e468c05..209bff950e22 100644
> > --- a/include/linux/via_i2c.h
> > +++ b/include/linux/via_i2c.h
> > @@ -32,6 +32,7 @@ struct via_i2c_stuff {
> >  };
> > =20
> > =20
> > +#ifdef CONFIG_FB_VIA
> >  int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata);
> >  int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data);
> >  int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, in=
t buff_len);
> > @@ -39,4 +40,9 @@ struct i2c_adapter *viafb_find_i2c_adapter(enum viafb=
_i2c_adap which);
> > =20
> >  extern int viafb_i2c_init(void);
> >  extern void viafb_i2c_exit(void);
> > +#else
> > +static inline
> > +struct i2c_adapter *viafb_find_i2c_adapter(enum viafb_i2c_adap which)
> > +{ return NULL; }
> > +#endif
> >  #endif /* __VIA_I2C_H__ */ =20
>=20
> How's about just allowing COMPILE_TEST for FB_VIA instead of adding
> all these stubs?
>=20
>=20
> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Subject: [PATCH] video: fbdev: via: allow COMPILE_TEST build
>=20
> This patch allows viafb driver to be build on !X86 archs
> using COMPILE_TEST config option.
>=20
> Since via-camera driver (VIDEO_VIA_CAMERA) depends on viafb
> it also needs a little fixup.
>=20
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/media/platform/via-camera.c |    5 +++++
>  drivers/video/fbdev/Kconfig         |    2 +-
>  drivers/video/fbdev/via/global.h    |    6 ++++++
>  drivers/video/fbdev/via/hw.c        |    1 -
>  drivers/video/fbdev/via/via-core.c  |    1 -
>  drivers/video/fbdev/via/via_clock.c |    2 +-
>  drivers/video/fbdev/via/viafbdev.c  |    1 -
>  7 files changed, 13 insertions(+), 5 deletions(-)
>=20
> Index: b/drivers/media/platform/via-camera.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/media/platform/via-camera.c	2018-04-23 13:46:37.000000000 +=
0200
> +++ b/drivers/media/platform/via-camera.c	2018-04-23 14:01:07.873322815 +=
0200
> @@ -27,7 +27,12 @@
>  #include <linux/via-core.h>
>  #include <linux/via-gpio.h>
>  #include <linux/via_i2c.h>
> +
> +#ifdef CONFIG_X86
>  #include <asm/olpc.h>
> +#else
> +#define machine_is_olpc(x) 0
> +#endif
> =20
>  #include "via-camera.h"
> =20
> Index: b/drivers/video/fbdev/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/video/fbdev/Kconfig	2018-04-10 12:34:26.618867549 +0200
> +++ b/drivers/video/fbdev/Kconfig	2018-04-23 13:55:41.389314593 +0200
> @@ -1437,7 +1437,7 @@ config FB_SIS_315
> =20
>  config FB_VIA
>         tristate "VIA UniChrome (Pro) and Chrome9 display support"
> -       depends on FB && PCI && X86 && GPIOLIB && I2C
> +       depends on FB && PCI && GPIOLIB && I2C && (X86 || COMPILE_TEST)
>         select FB_CFB_FILLRECT
>         select FB_CFB_COPYAREA
>         select FB_CFB_IMAGEBLIT
> Index: b/drivers/video/fbdev/via/global.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/video/fbdev/via/global.h	2017-10-18 14:35:22.079448310 +0200
> +++ b/drivers/video/fbdev/via/global.h	2018-04-23 13:52:57.121310456 +0200
> @@ -33,6 +33,12 @@
>  #include <linux/console.h>
>  #include <linux/timer.h>
> =20
> +#ifdef CONFIG_X86
> +#include <asm/olpc.h>
> +#else
> +#define machine_is_olpc(x) 0
> +#endif
> +
>  #include "debug.h"
> =20
>  #include "viafbdev.h"
> Index: b/drivers/video/fbdev/via/hw.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/video/fbdev/via/hw.c	2017-10-18 14:35:22.079448310 +0200
> +++ b/drivers/video/fbdev/via/hw.c	2018-04-23 13:54:24.881312666 +0200
> @@ -20,7 +20,6 @@
>   */
> =20
>  #include <linux/via-core.h>
> -#include <asm/olpc.h>
>  #include "global.h"
>  #include "via_clock.h"
> =20
> Index: b/drivers/video/fbdev/via/via-core.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/video/fbdev/via/via-core.c	2017-11-22 14:11:59.852728679 +0=
100
> +++ b/drivers/video/fbdev/via/via-core.c	2018-04-23 13:53:24.893311156 +0=
200
> @@ -17,7 +17,6 @@
>  #include <linux/platform_device.h>
>  #include <linux/list.h>
>  #include <linux/pm.h>
> -#include <asm/olpc.h>
> =20
>  /*
>   * The default port config.
> Index: b/drivers/video/fbdev/via/via_clock.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/video/fbdev/via/via_clock.c	2017-10-18 14:35:22.083448309 +=
0200
> +++ b/drivers/video/fbdev/via/via_clock.c	2018-04-23 13:53:45.389311672 +=
0200
> @@ -25,7 +25,7 @@
> =20
>  #include <linux/kernel.h>
>  #include <linux/via-core.h>
> -#include <asm/olpc.h>
> +
>  #include "via_clock.h"
>  #include "global.h"
>  #include "debug.h"
> Index: b/drivers/video/fbdev/via/viafbdev.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/video/fbdev/via/viafbdev.c	2017-11-22 14:11:59.852728679 +0=
100
> +++ b/drivers/video/fbdev/via/viafbdev.c	2018-04-23 13:53:55.325311922 +0=
200
> @@ -25,7 +25,6 @@
>  #include <linux/stat.h>
>  #include <linux/via-core.h>
>  #include <linux/via_i2c.h>
> -#include <asm/olpc.h>
> =20
>  #define _MASTER_FILE
>  #include "global.h"
>=20
>=20



Thanks,
Mauro
