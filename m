Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50839 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754828AbeDWMTr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:19:47 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20180423121944euoutp02e6a22ec6cbc1216f519211ae60e2c326~oD_0X7Eng1899018990euoutp029
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:19:44 +0000 (GMT)
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
Date: Mon, 23 Apr 2018 14:19:31 +0200
Message-ID: <5323943.SkjzUNBk3k@amdc3058>
In-Reply-To: <20180420160321.4ecefa00@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
References: <cover.1524245455.git.mchehab@s-opensource.com>
        <396bfb33e763c31ead093ac1035b2ecf7311b5bc.1524245455.git.mchehab@s-opensource.com>
        <20180420160321.4ecefa00@vento.lan>
        <CGME20180423121932eucas1p212eb6412ff8df511047c3afa782db6e0@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro,

On Friday, April 20, 2018 04:03:21 PM Mauro Carvalho Chehab wrote:
> This driver depends on FB_VIA for lots of things. Provide stubs
> for the functions it needs, in order to allow building it with
> COMPILE_TEST outside x86 architecture.

Please cc: me on fbdev related patches (patch adding new FB_VIA
ifdefs _is_ definitely fbdev related).

> Signed-off-by: Mauro Carvalho Chehab <mchehab=40s-opensource.com>
>=20
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kcon=
fig
> index e3229f7baed1..abaaed98a044 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> =40=40 -15,7 +15,7 =40=40 source =22drivers/media/platform/marvell-ccic/K=
config=22
> =20
>  config VIDEO_VIA_CAMERA
>  	tristate =22VIAFB camera controller support=22
> -	depends on FB_VIA
> +	depends on FB_VIA =7C=7C COMPILE_TEST

This is incorrect (too simple), please take a look at FB_VIA entry:

config FB_VIA
       tristate =22VIA UniChrome (Pro) and Chrome9 display support=22
       depends on FB && PCI && X86 && GPIOLIB && I2C
       select FB_CFB_FILLRECT
       select FB_CFB_COPYAREA
       select FB_CFB_IMAGEBLIT
       select I2C_ALGOBIT
       help

Therefore you also need to check PCI, GPIOLIB && I2C dependencies.

* For PCI=3Dn:

drivers/media/platform/via-camera.c: In function =E2=80=98viacam_serial_is_=
enabled=E2=80=99:=0D=0Adrivers/media/platform/via-camera.c:1286:9:=20error:=
=20implicit=20declaration=20of=20function=20=E2=80=98pci_find_bus=E2=80=99=
=20=5B-Werror=3Dimplicit-function-declaration=5D=0D=0Adrivers/media/platfor=
m/via-camera.c:1286:25:=20warning:=20initialization=20makes=20pointer=20fro=
m=20integer=20without=20a=20cast=20=5Benabled=20by=20default=5D=0D=0Adriver=
s/media/platform/via-camera.c:1296:2:=20error:=20implicit=20declaration=20o=
f=20function=20=E2=80=98pci_bus_read_config_byte=E2=80=99=20=5B-Werror=3Dim=
plicit-function-declaration=5D=0D=0Adrivers/media/platform/via-camera.c:130=
8:2:=20error:=20implicit=20declaration=20of=20function=20=E2=80=98pci_bus_w=
rite_config_byte=E2=80=99=20=5B-Werror=3Dimplicit-function-declaration=5D=
=0D=0Acc1:=20some=20warnings=20being=20treated=20as=20errors=0D=0Amake=5B3=
=5D:=20***=20=5Bdrivers/media/platform/via-camera.o=5D=20Error=201=0D=0A=0D=
=0A*=20For=20I2C=3Dn:=0D=0A=0D=0AWARNING:=20unmet=20direct=20dependencies=
=20detected=20for=20VIDEO_OV7670=0D=0A=20=20Depends=20on=20=5Bn=5D:=20MEDIA=
_SUPPORT=20=5B=3Dy=5D=20&&=20I2C=20=5B=3Dn=5D=20&&=20VIDEO_V4L2=20=5B=3Dy=
=5D=20&&=20MEDIA_CAMERA_SUPPORT=20=5B=3Dy=5D=0D=0A=20=20Selected=20by=20=5B=
y=5D:=0D=0A=20=20-=20VIDEO_VIA_CAMERA=20=5B=3Dy=5D=20&&=20MEDIA_SUPPORT=20=
=5B=3Dy=5D=20&&=20V4L_PLATFORM_DRIVERS=20=5B=3Dy=5D=20&&=20(FB_VIA=20=5B=3D=
n=5D=20=7C=7C=20COMPILE_TEST=20=5B=3Dy=5D)=0D=0A=0D=0Adrivers/media/i2c/ov7=
670.c:=20In=20function=20=E2=80=98ov7670_read_smbus=E2=80=99:=0D=0Adrivers/=
media/i2c/ov7670.c:483:2:=20error:=20implicit=20declaration=20of=20function=
=20=E2=80=98i2c_smbus_read_byte_data=E2=80=99=20=5B-Werror=3Dimplicit-funct=
ion-declaration=5D=0D=0A=20=20ret=20=3D=20i2c_smbus_read_byte_data(client,=
=20reg);=0D=0A=20=20=5E=0D=0Adrivers/media/i2c/ov7670.c:=20In=20function=20=
=E2=80=98ov7670_write_smbus=E2=80=99:=0D=0Adrivers/media/i2c/ov7670.c:496:2=
:=20error:=20implicit=20declaration=20of=20function=20=E2=80=98i2c_smbus_wr=
ite_byte_data=E2=80=99=20=5B-Werror=3Dimplicit-function-declaration=5D=0D=
=0A=20=20int=20ret=20=3D=20i2c_smbus_write_byte_data(client,=20reg,=20value=
);=0D=0A=20=20=5E=0D=0Adrivers/media/i2c/ov7670.c:=20In=20function=20=E2=80=
=98ov7670_read_i2c=E2=80=99:=0D=0Adrivers/media/i2c/ov7670.c:521:2:=20error=
:=20implicit=20declaration=20of=20function=20=E2=80=98i2c_transfer=E2=80=99=
=20=5B-Werror=3Dimplicit-function-declaration=5D=0D=0A=20=20ret=20=3D=20i2c=
_transfer(client->adapter,=20&msg,=201);=0D=0A=20=20=5E=0D=0Adrivers/media/=
i2c/ov7670.c:=20In=20function=20=E2=80=98ov7670_probe=E2=80=99:=0D=0Adriver=
s/media/i2c/ov7670.c:1835:3:=20error:=20implicit=20declaration=20of=20funct=
ion=20=E2=80=98i2c_adapter_id=E2=80=99=20=5B-Werror=3Dimplicit-function-dec=
laration=5D=0D=0A=20=20=20v4l_dbg(1,=20debug,=20client,=0D=0A=20=20=20=5E=
=0D=0Adrivers/media/i2c/ov7670.c:=20At=20top=20level:=0D=0Adrivers/media/i2=
c/ov7670.c:1962:1:=20warning:=20data=20definition=20has=20no=20type=20or=20=
storage=20class=20=5Benabled=20by=20default=5D=0D=0A=20module_i2c_driver(ov=
7670_driver);=0D=0A=20=5E=0D=0Adrivers/media/i2c/ov7670.c:1962:1:=20error:=
=20type=20defaults=20to=20=E2=80=98int=E2=80=99=20in=20declaration=20of=20=
=E2=80=98module_i2c_driver=E2=80=99=20=5B-Werror=3Dimplicit-int=5D=0D=0Adri=
vers/media/i2c/ov7670.c:1962:1:=20warning:=20parameter=20names=20(without=
=20types)=20in=20function=20declaration=20=5Benabled=20by=20default=5D=0D=
=0Adrivers/media/i2c/ov7670.c:1952:26:=20warning:=20=E2=80=98ov7670_driver=
=E2=80=99=20defined=20but=20not=20used=20=5B-Wunused-variable=5D=0D=0A=20st=
atic=20struct=20i2c_driver=20ov7670_driver=20=3D=20=7B=0D=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=5E=0D=0Acc1=
:=20some=20warnings=20being=20treated=20as=20errors=0D=0Amake=5B3=5D:=20***=
=20=5Bdrivers/media/i2c/ov7670.o=5D=20Error=201=0D=0A=0D=0A*=20For=20GPIOLI=
B=3Dn=20it=20builds=20fine.=0D=0A=0D=0A>=20=20=09select=20VIDEOBUF_DMA_SG=
=0D=0A>=20=20=09select=20VIDEO_OV7670=0D=0A>=20=20=09help=0D=0A>=20diff=20-=
-git=20a/drivers/media/platform/via-camera.c=20b/drivers/media/platform/via=
-camera.c=0D=0A>=20index=20e9a02639554b..4ab1695b33af=20100644=0D=0A>=20---=
=20a/drivers/media/platform/via-camera.c=0D=0A>=20+++=20b/drivers/media/pla=
tform/via-camera.c=0D=0A>=20=40=40=20-27,7=20+27,10=20=40=40=0D=0A>=20=20=
=23include=20<linux/via-core.h>=0D=0A>=20=20=23include=20<linux/via-gpio.h>=
=0D=0A>=20=20=23include=20<linux/via_i2c.h>=0D=0A>=20+=0D=0A>=20+=23ifdef=
=20CONFIG_FB_VIA=0D=0A=0D=0AThis=20should=20be=20CONFIG_X86.=0D=0A=0D=0A>=
=20=20=23include=20<asm/olpc.h>=0D=0A>=20+=23endif=0D=0A>=20=20=0D=0A>=20=
=20=23include=20=22via-camera.h=22=0D=0A>=20=20=0D=0A>=20=40=40=20-1283,6=
=20+1286,11=20=40=40=20static=20bool=20viacam_serial_is_enabled(void)=0D=0A=
>=20=20=09struct=20pci_bus=20*pbus=20=3D=20pci_find_bus(0,=200);=0D=0A>=20=
=20=09u8=20cbyte;=0D=0A>=20=20=0D=0A>=20+=23ifdef=20CONFIG_FB_VIA=0D=0A=0D=
=0Aditto=0D=0A=0D=0A>=20+=09if=20(=21machine_is_olpc())=0D=0A>=20+=09=09ret=
urn=20false;=0D=0A>=20+=23endif=0D=0A>=20+=0D=0A>=20=20=09if=20(=21pbus)=0D=
=0A>=20=20=09=09return=20false;=0D=0A>=20=20=09pci_bus_read_config_byte(pbu=
s,=20VIACAM_SERIAL_DEVFN,=0D=0A>=20=40=40=20-1343,7=20+1351,7=20=40=40=20st=
atic=20int=20viacam_probe(struct=20platform_device=20*pdev)=0D=0A>=20=20=09=
=09return=20-ENOMEM;=0D=0A>=20=20=09=7D=0D=0A>=20=20=0D=0A>=20-=09if=20(mac=
hine_is_olpc()=20&&=20viacam_serial_is_enabled())=0D=0A>=20+=09if=20(viacam=
_serial_is_enabled())=0D=0A>=20=20=09=09return=20-EBUSY;=0D=0A>=20=20=0D=0A=
>=20=20=09/*=0D=0A>=20diff=20--git=20a/include/linux/via-core.h=20b/include=
/linux/via-core.h=0D=0A>=20index=209c21cdf3e3b3..ced4419baef8=20100644=0D=
=0A>=20---=20a/include/linux/via-core.h=0D=0A>=20+++=20b/include/linux/via-=
core.h=0D=0A>=20=40=40=20-70,8=20+70,12=20=40=40=20struct=20viafb_pm_hooks=
=20=7B=0D=0A>=20=20=09void=20*private;=0D=0A>=20=20=7D;=0D=0A>=20=20=0D=0A>=
=20+=23ifdef=20CONFIG_FB_VIA=0D=0A>=20=20void=20viafb_pm_register(struct=20=
viafb_pm_hooks=20*hooks);=0D=0A>=20=20void=20viafb_pm_unregister(struct=20v=
iafb_pm_hooks=20*hooks);=0D=0A>=20+=23else=0D=0A>=20+static=20inline=20void=
=20viafb_pm_register(struct=20viafb_pm_hooks=20*hooks)=20=7B=7D=0D=0A>=20+=
=23endif=20/*=20CONFIG_FB_VIA=20*/=0D=0A>=20=20=23endif=20/*=20CONFIG_PM=20=
*/=0D=0A>=20=20=0D=0A>=20=20/*=0D=0A>=20=40=40=20-113,8=20+117,13=20=40=40=
=20struct=20viafb_dev=20=7B=0D=0A>=20=20=20*=20Interrupt=20management.=0D=
=0A>=20=20=20*/=0D=0A>=20=20=0D=0A>=20+=23ifdef=20CONFIG_FB_VIA=0D=0A>=20=
=20void=20viafb_irq_enable(u32=20mask);=0D=0A>=20=20void=20viafb_irq_disabl=
e(u32=20mask);=0D=0A>=20+=23else=0D=0A>=20+static=20inline=20void=20viafb_i=
rq_enable(u32=20mask)=20=7B=7D=0D=0A>=20+static=20inline=20void=20viafb_irq=
_disable(u32=20mask)=20=7B=7D=0D=0A>=20+=23endif=0D=0A>=20=20=0D=0A>=20=20/=
*=0D=0A>=20=20=20*=20The=20global=20interrupt=20control=20register=20and=20=
its=20bits.=0D=0A>=20=40=40=20-157,10=20+166,18=20=40=40=20void=20viafb_irq=
_disable(u32=20mask);=0D=0A>=20=20/*=0D=0A>=20=20=20*=20DMA=20management.=
=0D=0A>=20=20=20*/=0D=0A>=20+=23ifdef=20CONFIG_FB_VIA=0D=0A>=20=20int=20via=
fb_request_dma(void);=0D=0A>=20=20void=20viafb_release_dma(void);=0D=0A>=20=
=20/*=20void=20viafb_dma_copy_out(unsigned=20int=20offset,=20dma_addr_t=20p=
addr,=20int=20len);=20*/=0D=0A>=20=20int=20viafb_dma_copy_out_sg(unsigned=
=20int=20offset,=20struct=20scatterlist=20*sg,=20int=20nsg);=0D=0A>=20+=23e=
lse=0D=0A>=20+static=20inline=20int=20viafb_request_dma(void)=20=7B=20retur=
n=200;=20=7D=0D=0A>=20+static=20inline=20void=20viafb_release_dma(void)=20=
=7B=7D=0D=0A>=20+static=20inline=20int=20viafb_dma_copy_out_sg(unsigned=20i=
nt=20offset,=0D=0A>=20+=09=09=09=09=09struct=20scatterlist=20*sg,=20int=20n=
sg)=0D=0A>=20+=7B=20return=200;=20=7D=0D=0A>=20+=23endif=0D=0A>=20=20=0D=0A=
>=20=20/*=0D=0A>=20=20=20*=20DMA=20Controller=20registers.=0D=0A>=20diff=20=
--git=20a/include/linux/via-gpio.h=20b/include/linux/via-gpio.h=0D=0A>=20in=
dex=208281aea3dd6d..b5a96cf7a874=20100644=0D=0A>=20---=20a/include/linux/vi=
a-gpio.h=0D=0A>=20+++=20b/include/linux/via-gpio.h=0D=0A>=20=40=40=20-8,7=
=20+8,11=20=40=40=0D=0A>=20=20=23ifndef=20__VIA_GPIO_H__=0D=0A>=20=20=23def=
ine=20__VIA_GPIO_H__=0D=0A>=20=20=0D=0A>=20+=23ifdef=20CONFIG_FB_VIA=0D=0A>=
=20=20extern=20int=20viafb_gpio_lookup(const=20char=20*name);=0D=0A>=20=20e=
xtern=20int=20viafb_gpio_init(void);=0D=0A>=20=20extern=20void=20viafb_gpio=
_exit(void);=0D=0A>=20+=23else=0D=0A>=20+static=20inline=20int=20viafb_gpio=
_lookup(const=20char=20*name)=20=7B=20return=200;=20=7D=0D=0A>=20+=23endif=
=0D=0A>=20=20=23endif=0D=0A>=20diff=20--git=20a/include/linux/via_i2c.h=20b=
/include/linux/via_i2c.h=0D=0A>=20index=2044532e468c05..209bff950e22=201006=
44=0D=0A>=20---=20a/include/linux/via_i2c.h=0D=0A>=20+++=20b/include/linux/=
via_i2c.h=0D=0A>=20=40=40=20-32,6=20+32,7=20=40=40=20struct=20via_i2c_stuff=
=20=7B=0D=0A>=20=20=7D;=0D=0A>=20=20=0D=0A>=20=20=0D=0A>=20+=23ifdef=20CONF=
IG_FB_VIA=0D=0A>=20=20int=20viafb_i2c_readbyte(u8=20adap,=20u8=20slave_addr=
,=20u8=20index,=20u8=20*pdata);=0D=0A>=20=20int=20viafb_i2c_writebyte(u8=20=
adap,=20u8=20slave_addr,=20u8=20index,=20u8=20data);=0D=0A>=20=20int=20viaf=
b_i2c_readbytes(u8=20adap,=20u8=20slave_addr,=20u8=20index,=20u8=20*buff,=
=20int=20buff_len);=0D=0A>=20=40=40=20-39,4=20+40,9=20=40=40=20struct=20i2c=
_adapter=20*viafb_find_i2c_adapter(enum=20viafb_i2c_adap=20which);=0D=0A>=
=20=20=0D=0A>=20=20extern=20int=20viafb_i2c_init(void);=0D=0A>=20=20extern=
=20void=20viafb_i2c_exit(void);=0D=0A>=20+=23else=0D=0A>=20+static=20inline=
=0D=0A>=20+struct=20i2c_adapter=20*viafb_find_i2c_adapter(enum=20viafb_i2c_=
adap=20which)=0D=0A>=20+=7B=20return=20NULL;=20=7D=0D=0A>=20+=23endif=0D=0A=
>=20=20=23endif=20/*=20__VIA_I2C_H__=20*/=0D=0A=0D=0AHow's=20about=20just=
=20allowing=20COMPILE_TEST=20for=20FB_VIA=20instead=20of=20adding=0D=0Aall=
=20these=20stubs?=0D=0A=0D=0A=0D=0AFrom:=20Bartlomiej=20Zolnierkiewicz=20<b=
.zolnierkie=40samsung.com>=0D=0ASubject:=20=5BPATCH=5D=20video:=20fbdev:=20=
via:=20allow=20COMPILE_TEST=20build=0D=0A=0D=0AThis=20patch=20allows=20viaf=
b=20driver=20to=20be=20build=20on=20=21X86=20archs=0D=0Ausing=20COMPILE_TES=
T=20config=20option.=0D=0A=0D=0ASince=20via-camera=20driver=20(VIDEO_VIA_CA=
MERA)=20depends=20on=20viafb=0D=0Ait=20also=20needs=20a=20little=20fixup.=
=0D=0A=0D=0ACc:=20Florian=20Tobias=20Schandinat=20<FlorianSchandinat=40gmx.=
de>=0D=0ACc:=20Mauro=20Carvalho=20Chehab=20<mchehab=40s-opensource.com>=0D=
=0ASigned-off-by:=20Bartlomiej=20Zolnierkiewicz=20<b.zolnierkie=40samsung.c=
om>=0D=0A---=0D=0A=20drivers/media/platform/via-camera.c=20=7C=20=20=20=205=
=20+++++=0D=0A=20drivers/video/fbdev/Kconfig=20=20=20=20=20=20=20=20=20=7C=
=20=20=20=202=20+-=0D=0A=20drivers/video/fbdev/via/global.h=20=20=20=20=7C=
=20=20=20=206=20++++++=0D=0A=20drivers/video/fbdev/via/hw.c=20=20=20=20=20=
=20=20=20=7C=20=20=20=201=20-=0D=0A=20drivers/video/fbdev/via/via-core.c=20=
=20=7C=20=20=20=201=20-=0D=0A=20drivers/video/fbdev/via/via_clock.c=20=7C=
=20=20=20=202=20+-=0D=0A=20drivers/video/fbdev/via/viafbdev.c=20=20=7C=20=
=20=20=201=20-=0D=0A=207=20files=20changed,=2013=20insertions(+),=205=20del=
etions(-)=0D=0A=0D=0AIndex:=20b/drivers/media/platform/via-camera.c=0D=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A---=20a/drivers/me=
dia/platform/via-camera.c=092018-04-23=2013:46:37.000000000=20+0200=0D=0A++=
+=20b/drivers/media/platform/via-camera.c=092018-04-23=2014:01:07.873322815=
=20+0200=0D=0A=40=40=20-27,7=20+27,12=20=40=40=0D=0A=20=23include=20<linux/=
via-core.h>=0D=0A=20=23include=20<linux/via-gpio.h>=0D=0A=20=23include=20<l=
inux/via_i2c.h>=0D=0A+=0D=0A+=23ifdef=20CONFIG_X86=0D=0A=20=23include=20<as=
m/olpc.h>=0D=0A+=23else=0D=0A+=23define=20machine_is_olpc(x)=200=0D=0A+=23e=
ndif=0D=0A=20=0D=0A=20=23include=20=22via-camera.h=22=0D=0A=20=0D=0AIndex:=
=20b/drivers/video/fbdev/Kconfig=0D=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=0D=0A---=20a/drivers/video/fbdev/Kconfig=092018-04-10=2012:=
34:26.618867549=20+0200=0D=0A+++=20b/drivers/video/fbdev/Kconfig=092018-04-=
23=2013:55:41.389314593=20+0200=0D=0A=40=40=20-1437,7=20+1437,7=20=40=40=20=
config=20FB_SIS_315=0D=0A=20=0D=0A=20config=20FB_VIA=0D=0A=20=20=20=20=20=
=20=20=20tristate=20=22VIA=20UniChrome=20(Pro)=20and=20Chrome9=20display=20=
support=22=0D=0A-=20=20=20=20=20=20=20depends=20on=20FB=20&&=20PCI=20&&=20X=
86=20&&=20GPIOLIB=20&&=20I2C=0D=0A+=20=20=20=20=20=20=20depends=20on=20FB=
=20&&=20PCI=20&&=20GPIOLIB=20&&=20I2C=20&&=20(X86=20=7C=7C=20COMPILE_TEST)=
=0D=0A=20=20=20=20=20=20=20=20select=20FB_CFB_FILLRECT=0D=0A=20=20=20=20=20=
=20=20=20select=20FB_CFB_COPYAREA=0D=0A=20=20=20=20=20=20=20=20select=20FB_=
CFB_IMAGEBLIT=0D=0AIndex:=20b/drivers/video/fbdev/via/global.h=0D=0A=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A---=20a/drivers/video/fb=
dev/via/global.h=092017-10-18=2014:35:22.079448310=20+0200=0D=0A+++=20b/dri=
vers/video/fbdev/via/global.h=092018-04-23=2013:52:57.121310456=20+0200=0D=
=0A=40=40=20-33,6=20+33,12=20=40=40=0D=0A=20=23include=20<linux/console.h>=
=0D=0A=20=23include=20<linux/timer.h>=0D=0A=20=0D=0A+=23ifdef=20CONFIG_X86=
=0D=0A+=23include=20<asm/olpc.h>=0D=0A+=23else=0D=0A+=23define=20machine_is=
_olpc(x)=200=0D=0A+=23endif=0D=0A+=0D=0A=20=23include=20=22debug.h=22=0D=0A=
=20=0D=0A=20=23include=20=22viafbdev.h=22=0D=0AIndex:=20b/drivers/video/fbd=
ev/via/hw.c=0D=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A=
---=20a/drivers/video/fbdev/via/hw.c=092017-10-18=2014:35:22.079448310=20+0=
200=0D=0A+++=20b/drivers/video/fbdev/via/hw.c=092018-04-23=2013:54:24.88131=
2666=20+0200=0D=0A=40=40=20-20,7=20+20,6=20=40=40=0D=0A=20=20*/=0D=0A=20=0D=
=0A=20=23include=20<linux/via-core.h>=0D=0A-=23include=20<asm/olpc.h>=0D=0A=
=20=23include=20=22global.h=22=0D=0A=20=23include=20=22via_clock.h=22=0D=0A=
=20=0D=0AIndex:=20b/drivers/video/fbdev/via/via-core.c=0D=0A=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A---=20a/drivers/video/fbdev/via/v=
ia-core.c=092017-11-22=2014:11:59.852728679=20+0100=0D=0A+++=20b/drivers/vi=
deo/fbdev/via/via-core.c=092018-04-23=2013:53:24.893311156=20+0200=0D=0A=40=
=40=20-17,7=20+17,6=20=40=40=0D=0A=20=23include=20<linux/platform_device.h>=
=0D=0A=20=23include=20<linux/list.h>=0D=0A=20=23include=20<linux/pm.h>=0D=
=0A-=23include=20<asm/olpc.h>=0D=0A=20=0D=0A=20/*=0D=0A=20=20*=20The=20defa=
ult=20port=20config.=0D=0AIndex:=20b/drivers/video/fbdev/via/via_clock.c=0D=
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A---=20a/drivers=
/video/fbdev/via/via_clock.c=092017-10-18=2014:35:22.083448309=20+0200=0D=
=0A+++=20b/drivers/video/fbdev/via/via_clock.c=092018-04-23=2013:53:45.3893=
11672=20+0200=0D=0A=40=40=20-25,7=20+25,7=20=40=40=0D=0A=20=0D=0A=20=23incl=
ude=20<linux/kernel.h>=0D=0A=20=23include=20<linux/via-core.h>=0D=0A-=23inc=
lude=20<asm/olpc.h>=0D=0A+=0D=0A=20=23include=20=22via_clock.h=22=0D=0A=20=
=23include=20=22global.h=22=0D=0A=20=23include=20=22debug.h=22=0D=0AIndex:=
=20b/drivers/video/fbdev/via/viafbdev.c=0D=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=0D=0A---=20a/drivers/video/fbdev/via/viafbdev.c=09201=
7-11-22=2014:11:59.852728679=20+0100=0D=0A+++=20b/drivers/video/fbdev/via/v=
iafbdev.c=092018-04-23=2013:53:55.325311922=20+0200=0D=0A=40=40=20-25,7=20+=
25,6=20=40=40=0D=0A=20=23include=20<linux/stat.h>=0D=0A=20=23include=20<lin=
ux/via-core.h>=0D=0A=20=23include=20<linux/via_i2c.h>=0D=0A-=23include=20<a=
sm/olpc.h>=0D=0A=20=0D=0A=20=23define=20_MASTER_FILE=0D=0A=20=23include=20=
=22global.h=22=0D=0A=0D=0A
