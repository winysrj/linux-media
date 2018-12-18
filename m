Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243ABC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 17:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C10A021873
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 17:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545154830;
	bh=Cazgmu1UoBZ+6D5OMduw+9JNVl3c+EmNRkixDtsw3AA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=Y2sbjTgonHJ+Fmc4JEDFcIPKXoeFVnpQf9TEQPK/JN9GQFHGXtm32vPy+8PujOOuu
	 xu9/K8/76rWUybt23KOL9oVfnp1T3yxK5x72l54fkH/sbeq/R5OkgzCA7OoPdFxysN
	 MXZNUbY+Cw1izQZDSS/vMvQpQpeGsQFlw/b3cp2g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbeLRRk3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 12:40:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:40718 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbeLRRk2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 12:40:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v01MCFuBqDq0QSQoPMftejquCeoBpFT9HWwZkLT8fVg=; b=qSwY4J4XOYPy4cwMLtSC8dYaDK
        OOkSsQLPXIcLC8iWL1YCOUoRTVm0O+7++iyjWA3fwqmpQGkmJuxeQnym4tVtj8onLca9jv4fwo6tr
        4MfPcicV08YmYmRe4qxQS4+PC/JBQJPZPH3u7utQUab9XaKB7Eu2Lff1VduUG0AEMmR5SO3IW1P+2
        xQ7dkeZfMWb1G014TXR2meJc66cMDNy9PzBpp6wW+8Uu3zBOAiH5SCQgh/qrYZGoMJwiuo21/gbvA
        inSiVH/w6sGb6vKTEmDF4RwJsf50WIgXMOSTfjqsjOmjOIRBkQhBv/v65yh10OGf5a2uxQ3t3nnbC
        yprRg8jA==;
Received: from 177.205.112.95.dynamic.adsl.gvt.net.br ([177.205.112.95] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZJLz-0003qb-Lx; Tue, 18 Dec 2018 17:40:24 +0000
Date:   Tue, 18 Dec 2018 15:40:18 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     ezequiel@collabora.com
Cc:     linux-media@vger.kernel.org, guillaume.tucker@collabora.com,
        ana.guerrero@collabora.com
Subject: Re: media/master build: 227 builds: 2 failed, 225 passed, 2 errors,
 90 warnings (v4.20-rc5-281-gd2b4387f3bdf)
Message-ID: <20181218154018.66a61a1c@coco.lan>
In-Reply-To: <5c191258.1c69fb81.947a9.ca29@mx.google.com>
References: <5c191258.1c69fb81.947a9.ca29@mx.google.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ezequiel,

Thanks for setting this. I have a few comments. See below:

Em Tue, 18 Dec 2018 07:29:28 -0800 (PST)
"kernelci.org bot" <bot@kernelci.org> escreveu:

> media/master build: 227 builds: 2 failed, 225 passed, 2 errors, 90 warnin=
gs (v4.20-rc5-281-gd2b4387f3bdf)

This looked a lot uglier than it should be (see my comments below).

Looking at the output, I didn't see anything (build, warning, error)
related to media. On such case, please don't send any report.

The main issue I see is that, if we'll be starting to receive
bogus KernelCI reports, people will just ignore it.

The report should be as compact as possible, showing only what it is
relevant for the media subsystem developers, e. g. problems that it is
our responsibility to fix.

>=20
> Full Build Summary: https://kernelci.org/build/media/branch/master/kernel=
/v4.20-rc5-281-gd2b4387f3bdf/
>=20
> Tree: media
> Branch: master
> Git Describe: v4.20-rc5-281-gd2b4387f3bdf
> Git Commit: d2b4387f3bdf016e266d23cf657465f557721488
> Git URL: https://git.linuxtv.org/media_tree.git
> Built: 7 unique architectures
>=20
> Build Failures Detected:
>=20
> arc:    gcc version 7.1.1 20170710 (ARCv2 ISA Linux uClibc toolchain 2017=
.09)
>=20
>     allnoconfig: FAIL
>     tinyconfig: FAIL

I'm not aware of any arc media driver. Even if it had, for sure it won't
be build with 'allnoconfig', and almost sure it won't build with
tinyconfigs. So, for media, the above test cases sound irrelevant
and should not be reported to the media ML.

> Errors and Warnings Detected:
>=20
> arc:    gcc version 7.1.1 20170710 (ARCv2 ISA Linux uClibc toolchain 2017=
.09)
>=20
>     allnoconfig: 1 error, 2 warnings
>     axs103_defconfig: 6 warnings
>     axs103_smp_defconfig: 6 warnings
>     haps_hs_defconfig: 4 warnings
>     haps_hs_smp_defconfig: 4 warnings
>     hsdk_defconfig: 4 warnings
>     nsim_hs_defconfig: 4 warnings
>     nsim_hs_defconfig+kselftest: 5 warnings
>     nsim_hs_defconfig+virtualvideo: 4 warnings
>     nsim_hs_smp_defconfig: 4 warnings
>     nsimosci_hs_defconfig: 4 warnings
>     nsimosci_hs_smp_defconfig: 4 warnings
>     tinyconfig: 1 error, 2 warnings
>     vdk_hs38_defconfig: 5 warnings
>     vdk_hs38_smp_defconfig: 5 warnings

I'm also think that warnings should be reported only for x86. Lots of
archs generate bogus warnings (like signed/unsigned char kind of
warnings) and older gcc versions had issues properly detecting when
a variable is used or not.

Even on arm, depending how it is built, the signed/unsigned
char pops up.

So, please only send e-mails with warnings if those are present
with x86 (either 32 bits or 64 bits).

>=20
> arm64:    gcc version 7.3.0 (Debian 7.3.0-28)
>=20
>     allmodconfig: 1 warning
>=20
> arm:    gcc version 7.3.0 (Debian 7.3.0-28)
>=20
>     cm_x300_defconfig: 1 warning
>     em_x270_defconfig: 1 warning
>     eseries_pxa_defconfig: 1 warning
>     multi_v7_defconfig: 1 warning
>     multi_v7_defconfig+CONFIG_CPU_BIG_ENDIAN=3Dy: 1 warning
>     multi_v7_defconfig+CONFIG_EFI=3Dy+CONFIG_ARM_LPAE=3Dy: 1 warning
>     multi_v7_defconfig+CONFIG_SMP=3Dn: 1 warning
>     multi_v7_defconfig+kselftest: 1 warning
>     multi_v7_defconfig+virtualvideo: 1 warning
>     pxa_defconfig: 4 warnings
>     qcom_defconfig: 1 warning
>=20
> mips:    gcc version 6.3.0 (GCC)
>=20
>     db1xxx_defconfig: 2 warnings
>     decstation_defconfig: 1 warning
>     defconfig: 1 warning
>     defconfig+kselftest: 1 warning
>     defconfig+virtualvideo: 1 warning
>     lemote2f_defconfig: 1 warning
>     loongson3_defconfig: 2 warnings
>     nlm_xlp_defconfig: 1 warning
>=20
> riscv:    gcc version 7.3.0 (Debian 7.3.0-27)
>=20
>     defconfig+kselftest: 1 warning
>=20
> x86_64:    gcc version 7.3.0 (Debian 7.3.0-30)
>=20
>     tinyconfig: 1 warning
>=20
> Errors summary:
>=20
>     2    arc-linux-ld: error: vmlinux.o: unable to merge ISA extension at=
tributes code-density.
>=20
> Warnings summary:
>=20
>     15   include/linux/kernel.h:845:29: warning: comparison of distinct p=
ointer types lacks a cast
>     15   arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable lengt=
h array 'pd0' [-Wvla]
>     14   arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is=
 not used [-Wunused-value]
>     13   net/ipv4/tcp_input.c:4315:49: warning: array subscript is above =
array bounds [-Warray-bounds]
>     7    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (gr=
aph_endpoint): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to =
node '/soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional
>     4    sound/soc/codecs/wm9712.c:666:2: warning: 'regmap' may be used u=
ninitialized in this function [-Wmaybe-uninitialized]
>     3    net/core/rtnetlink.c:3224:1: warning: the frame size of 1328 byt=
es is larger than 1024 bytes [-Wframe-larger-than=3D]
>     3    arch/mips/boot/dts/xilfpga/nexys4ddr.dtb: Warning (i2c_bus_reg):=
 /i2c@10A00000/ad7420@4B: I2C bus unit address format error, expected "4b"
>     2    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' define=
d but not used [-Wunused-function]
>     2    WARNING: sound/ac97_bus: 'snd_ac97_reset' exported twice. Previo=
us export was in sound/ac97/ac97.ko
>     1    sound/soc/codecs/wm9705.c:346:2: warning: 'regmap' may be used u=
ninitialized in this function [-Wmaybe-uninitialized]
>     1    include/linux/list.h:63:13: warning: 'head' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
>     1    drivers/net/ethernet/amd/declance.c:1232:2: warning: 'desc' may =
be used uninitialized in this function [-Wmaybe-uninitialized]
>     1    drivers/mtd/nand/raw/au1550nd.c:447:57: warning: pointer type mi=
smatch in conditional expression
>     1    drivers/isdn/hardware/eicon/message.c:5985:1: warning: the frame=
 size of 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=3D]
>     1    arch/riscv/kernel/ftrace.c:135:6: warning: unused variable 'err'=
 [-Wunused-variable]
>     1    arch/mips/configs/loongson3_defconfig:55:warning: symbol value '=
m' invalid for HOTPLUG_PCI_SHPC
>     1    arch/arc/boot/dts/axs103_idu.dtb: Warning (i2c_bus_reg): /axs10x=
_mb/i2c@0x1f000/eeprom@0x57: I2C bus unit address format error, expected "5=
7"
>     1    arch/arc/boot/dts/axs103_idu.dtb: Warning (i2c_bus_reg): /axs10x=
_mb/i2c@0x1f000/eeprom@0x54: I2C bus unit address format error, expected "5=
4"
>     1    arch/arc/boot/dts/axs103.dtb: Warning (i2c_bus_reg): /axs10x_mb/=
i2c@0x1f000/eeprom@0x57: I2C bus unit address format error, expected "57"
>     1    arch/arc/boot/dts/axs103.dtb: Warning (i2c_bus_reg): /axs10x_mb/=
i2c@0x1f000/eeprom@0x54: I2C bus unit address format error, expected "54"
>     1    .config:1008:warning: override: UNWINDER_GUESS changes choice st=
ate

None of the warnings above are related to media. Please filter them out bef=
ore
sending the reports. We only care about media-specific warnings.

>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>=20
> Detailed per-defconfig build reports:
>=20
> -------------------------------------------------------------------------=
-------
> acs5k_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> acs5k_tiny_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> allmodconfig (arm64) =E2=80=94 PASS, 0 errors, 1 warning, 0 section misma=
tches
>=20
> Warnings:
>     drivers/isdn/hardware/eicon/message.c:5985:1: warning: the frame size=
 of 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=3D]
>=20

Same here.

> -------------------------------------------------------------------------=
-------
> allnoconfig (i386) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches
>=20
> -------------------------------------------------------------------------=
-------
> allnoconfig (x86_64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> allnoconfig (arm64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches
>=20
> -------------------------------------------------------------------------=
-------
> allnoconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatc=
hes
>=20
> -------------------------------------------------------------------------=
-------
> allnoconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches
>=20
> -------------------------------------------------------------------------=
-------
> allnoconfig (arc) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section mismatch=
es
>=20
> Errors:
>     arc-linux-ld: error: vmlinux.o: unable to merge ISA extension attribu=
tes code-density.
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast

Same here.

>=20
> -------------------------------------------------------------------------=
-------
> allnoconfig (riscv) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches
>=20
> -------------------------------------------------------------------------=
-------
> am200epdkit_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches
>=20
> -------------------------------------------------------------------------=
-------
> ar7_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> aspeed_g4_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> aspeed_g5_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> assabet_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> at91_dt_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> ath25_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> ath79_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> axm55xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> axs103_defconfig (arc) =E2=80=94 PASS, 0 errors, 6 warnings, 0 section mi=
smatches
>=20
> Warnings:
>     arch/arc/boot/dts/axs103.dtb: Warning (i2c_bus_reg): /axs10x_mb/i2c@0=
x1f000/eeprom@0x54: I2C bus unit address format error, expected "54"
>     arch/arc/boot/dts/axs103.dtb: Warning (i2c_bus_reg): /axs10x_mb/i2c@0=
x1f000/eeprom@0x57: I2C bus unit address format error, expected "57"
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]

Same here.

>=20
> -------------------------------------------------------------------------=
-------
> axs103_smp_defconfig (arc) =E2=80=94 PASS, 0 errors, 6 warnings, 0 sectio=
n mismatches
>=20
> Warnings:
>     arch/arc/boot/dts/axs103_idu.dtb: Warning (i2c_bus_reg): /axs10x_mb/i=
2c@0x1f000/eeprom@0x54: I2C bus unit address format error, expected "54"
>     arch/arc/boot/dts/axs103_idu.dtb: Warning (i2c_bus_reg): /axs10x_mb/i=
2c@0x1f000/eeprom@0x57: I2C bus unit address format error, expected "57"
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]

Same here.

>=20
> -------------------------------------------------------------------------=
-------
> badge4_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> bcm2835_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> bcm47xx_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> bcm63xx_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> bigsur_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> bmips_be_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> bmips_stb_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> capcella_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> cavium_octeon_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches
>=20
> -------------------------------------------------------------------------=
-------
> cerfcube_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> ci20_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> clps711x_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> cm_x2xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> cm_x300_defconfig (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches
>=20
> Warnings:
>     sound/soc/codecs/wm9712.c:666:2: warning: 'regmap' may be used uninit=
ialized in this function [-Wmaybe-uninitialized]
>=20
> -------------------------------------------------------------------------=
-------
> cns3420vb_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> cobalt_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> colibri_pxa270_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches
>=20
> -------------------------------------------------------------------------=
-------
> colibri_pxa300_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches
>=20
> -------------------------------------------------------------------------=
-------
> collie_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> corgi_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> davinci_all_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Please simplify the report. If it passed without warnings/errors/section mi=
smatches
related to media, there's no need to report.

>=20
> -------------------------------------------------------------------------=
-------
> db1xxx_defconfig (mips) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section m=
ismatches
>=20
> Warnings:
>     include/linux/list.h:63:13: warning: 'head' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]
>     drivers/mtd/nand/raw/au1550nd.c:447:57: warning: pointer type mismatc=
h in conditional expression

Again, none are related to media.

>=20
> -------------------------------------------------------------------------=
-------
> decstation_defconfig (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches
>=20
> Warnings:
>     drivers/net/ethernet/amd/declance.c:1232:2: warning: 'desc' may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

Same here.

>=20
> -------------------------------------------------------------------------=
-------
> defconfig (i386) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatch=
es
>=20
> -------------------------------------------------------------------------=
-------
> defconfig (x86_64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches
>=20
> -------------------------------------------------------------------------=
-------
> defconfig (arm64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatc=
hes
>=20
> -------------------------------------------------------------------------=
-------
> defconfig (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mismatches
>=20
> Warnings:
>     arch/mips/boot/dts/xilfpga/nexys4ddr.dtb: Warning (i2c_bus_reg): /i2c=
@10A00000/ad7420@4B: I2C bus unit address format error, expected "4b"

Same here.

>=20
> -------------------------------------------------------------------------=
-------
> defconfig (riscv) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatc=
hes
>=20
> -------------------------------------------------------------------------=
-------
> defconfig+CONFIG_CPU_BIG_ENDIAN=3Dy (arm64) =E2=80=94 PASS, 0 errors, 0 w=
arnings, 0 section mismatches
>=20
> -------------------------------------------------------------------------=
-------
> defconfig+CONFIG_RANDOMIZE_BASE=3Dy (arm64) =E2=80=94 PASS, 0 errors, 0 w=
arnings, 0 section mismatches
>=20
> -------------------------------------------------------------------------=
-------
> defconfig+kselftest (x86_64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches
>=20
> -------------------------------------------------------------------------=
-------
> defconfig+kselftest (i386) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> defconfig+kselftest (arm64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches
>=20
> -------------------------------------------------------------------------=
-------
> defconfig+kselftest (riscv) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches
>=20
> Warnings:
>     arch/riscv/kernel/ftrace.c:135:6: warning: unused variable 'err' [-Wu=
nused-variable]
>=20
> -------------------------------------------------------------------------=
-------
> defconfig+kselftest (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches
>=20
> Warnings:
>     arch/mips/boot/dts/xilfpga/nexys4ddr.dtb: Warning (i2c_bus_reg): /i2c=
@10A00000/ad7420@4B: I2C bus unit address format error, expected "4b"

Same here.

>=20
> -------------------------------------------------------------------------=
-------
> defconfig+virtualvideo (x86_64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches
>=20
> -------------------------------------------------------------------------=
-------
> defconfig+virtualvideo (i386) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches
>=20
> -------------------------------------------------------------------------=
-------
> defconfig+virtualvideo (arm64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches
>=20
> -------------------------------------------------------------------------=
-------
> defconfig+virtualvideo (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches
>=20
> Warnings:
>     arch/mips/boot/dts/xilfpga/nexys4ddr.dtb: Warning (i2c_bus_reg): /i2c=
@10A00000/ad7420@4B: I2C bus unit address format error, expected "4b"

Same here.

>=20
> -------------------------------------------------------------------------=
-------
> defconfig+virtualvideo (riscv) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches
>=20
> -------------------------------------------------------------------------=
-------
> dove_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> e55_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> ebsa110_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> efm32_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> em_x270_defconfig (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches
>=20
> Warnings:
>     sound/soc/codecs/wm9712.c:666:2: warning: 'regmap' may be used uninit=
ialized in this function [-Wmaybe-uninitialized]

Again, not related to media. I guess you got the idea.

>=20
> -------------------------------------------------------------------------=
-------
> ep93xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> eseries_pxa_defconfig (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches
>=20
> Warnings:
>     sound/soc/codecs/wm9712.c:666:2: warning: 'regmap' may be used uninit=
ialized in this function [-Wmaybe-uninitialized]
>=20
> -------------------------------------------------------------------------=
-------
> exynos_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> ezx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches
>=20
> -------------------------------------------------------------------------=
-------
> footbridge_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> fuloong2e_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> gcw0_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> gemini_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> gpr_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> h3600_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> h5000_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> hackkit_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> haps_hs_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section m=
ismatches
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>=20
> -------------------------------------------------------------------------=
-------
> haps_hs_smp_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 secti=
on mismatches
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>=20
> -------------------------------------------------------------------------=
-------
> hisi_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> hsdk_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section mism=
atches
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>=20
> -------------------------------------------------------------------------=
-------
> imote2_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> imx_v4_v5_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> imx_v6_v7_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> integrator_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> iop13xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> iop32x_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> iop33x_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> ip22_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> ip27_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> ip28_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> ip32_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> ixp4xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> jazz_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> jmr3927_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> jornada720_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> keystone_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> ks8695_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> lart_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> lasat_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> lemote2f_defconfig (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches
>=20
> Warnings:
>     net/core/rtnetlink.c:3224:1: warning: the frame size of 1328 bytes is=
 larger than 1024 bytes [-Wframe-larger-than=3D]
>=20
> -------------------------------------------------------------------------=
-------
> loongson1b_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches
>=20
> -------------------------------------------------------------------------=
-------
> loongson1c_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches
>=20
> -------------------------------------------------------------------------=
-------
> loongson3_defconfig (mips) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches
>=20
> Warnings:
>     arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm' in=
valid for HOTPLUG_PCI_SHPC
>     net/core/rtnetlink.c:3224:1: warning: the frame size of 1328 bytes is=
 larger than 1024 bytes [-Wframe-larger-than=3D]
>=20
> -------------------------------------------------------------------------=
-------
> lpc18xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> lpc32xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> lpd270_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> lubbock_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> magician_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> mainstone_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> malta_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> malta_kvm_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> malta_kvm_guest_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches
>=20
> -------------------------------------------------------------------------=
-------
> malta_qemu_32r6_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches
>=20
> -------------------------------------------------------------------------=
-------
> maltaaprp_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> maltasmvp_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> maltasmvp_eva_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches
>=20
> -------------------------------------------------------------------------=
-------
> maltaup_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> maltaup_xpa_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches
>=20
> -------------------------------------------------------------------------=
-------
> markeins_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> mini2440_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> mips_paravirt_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches
>=20
> -------------------------------------------------------------------------=
-------
> mmp2_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> moxart_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> mpc30x_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> mps2_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> msp71xx_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> mtx1_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> multi_v4t_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> multi_v5_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> multi_v7_defconfig (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches
>=20
> Warnings:
>     arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_e=
ndpoint): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node =
'/soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional
>=20
> -------------------------------------------------------------------------=
-------
> multi_v7_defconfig+CONFIG_CPU_BIG_ENDIAN=3Dy (arm) =E2=80=94 PASS, 0 erro=
rs, 1 warning, 0 section mismatches
>=20
> Warnings:
>     arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_e=
ndpoint): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node =
'/soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional
>=20
> -------------------------------------------------------------------------=
-------
> multi_v7_defconfig+CONFIG_EFI=3Dy+CONFIG_ARM_LPAE=3Dy (arm) =E2=80=94 PAS=
S, 0 errors, 1 warning, 0 section mismatches
>=20
> Warnings:
>     arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_e=
ndpoint): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node =
'/soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional
>=20
> -------------------------------------------------------------------------=
-------
> multi_v7_defconfig+CONFIG_SMP=3Dn (arm) =E2=80=94 PASS, 0 errors, 1 warni=
ng, 0 section mismatches
>=20
> Warnings:
>     arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_e=
ndpoint): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node =
'/soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional
>=20
> -------------------------------------------------------------------------=
-------
> multi_v7_defconfig+kselftest (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0=
 section mismatches
>=20
> Warnings:
>     arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_e=
ndpoint): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node =
'/soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional
>=20
> -------------------------------------------------------------------------=
-------
> multi_v7_defconfig+virtualvideo (arm) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches
>=20
> Warnings:
>     arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_e=
ndpoint): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node =
'/soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional
>=20
> -------------------------------------------------------------------------=
-------
> mv78xx0_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> mvebu_v5_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> mvebu_v7_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> mvebu_v7_defconfig+CONFIG_CPU_BIG_ENDIAN=3Dy (arm) =E2=80=94 PASS, 0 erro=
rs, 0 warnings, 0 section mismatches
>=20
> -------------------------------------------------------------------------=
-------
> mxs_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches
>=20
> -------------------------------------------------------------------------=
-------
> neponset_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> netwinder_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> netx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> nhk8815_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> nlm_xlp_defconfig (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches
>=20
> Warnings:
>     net/core/rtnetlink.c:3224:1: warning: the frame size of 1328 bytes is=
 larger than 1024 bytes [-Wframe-larger-than=3D]
>=20
> -------------------------------------------------------------------------=
-------
> nlm_xlr_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> nsim_hs_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section m=
ismatches
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>=20
> -------------------------------------------------------------------------=
-------
> nsim_hs_defconfig+kselftest (arc) =E2=80=94 PASS, 0 errors, 5 warnings, 0=
 section mismatches
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>=20
> -------------------------------------------------------------------------=
-------
> nsim_hs_defconfig+virtualvideo (arc) =E2=80=94 PASS, 0 errors, 4 warnings=
, 0 section mismatches
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>=20
> -------------------------------------------------------------------------=
-------
> nsim_hs_smp_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 secti=
on mismatches
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>=20
> -------------------------------------------------------------------------=
-------
> nsimosci_hs_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 secti=
on mismatches
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>=20
> -------------------------------------------------------------------------=
-------
> nsimosci_hs_smp_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 s=
ection mismatches
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>=20
> -------------------------------------------------------------------------=
-------
> nuc910_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> nuc950_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> nuc960_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> omap1_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> omap2plus_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> omega2p_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> orion5x_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> oxnas_v6_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> palmz72_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> pcm027_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> pic32mzda_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> pistachio_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> pleb_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> pnx8335_stb225_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches
>=20
> -------------------------------------------------------------------------=
-------
> prima2_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> pxa168_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> pxa255-idp_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> pxa3xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> pxa910_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> pxa_defconfig (arm) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section misma=
tches
>=20
> Warnings:
>     sound/soc/codecs/wm9705.c:346:2: warning: 'regmap' may be used uninit=
ialized in this function [-Wmaybe-uninitialized]
>     sound/soc/codecs/wm9712.c:666:2: warning: 'regmap' may be used uninit=
ialized in this function [-Wmaybe-uninitialized]
>     WARNING: sound/ac97_bus: 'snd_ac97_reset' exported twice. Previous ex=
port was in sound/ac97/ac97.ko
>     WARNING: sound/ac97_bus: 'snd_ac97_reset' exported twice. Previous ex=
port was in sound/ac97/ac97.ko
>=20
> -------------------------------------------------------------------------=
-------
> qcom_defconfig (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 section misma=
tches
>=20
> Warnings:
>     arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_e=
ndpoint): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node =
'/soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional
>=20
> -------------------------------------------------------------------------=
-------
> qi_lb60_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> raumfeld_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> rb532_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> rbtx49xx_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> realview_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> rm200_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> rpc_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches
>=20
> -------------------------------------------------------------------------=
-------
> rt305x_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> s3c2410_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> s3c6400_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> s5pv210_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> sama5_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> sb1250_swarm_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches
>=20
> -------------------------------------------------------------------------=
-------
> shannon_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> shmobile_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> simpad_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> socfpga_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> spear13xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> spear3xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> spear6xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> spitz_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> stm32_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> sunxi_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> tango4_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches
>=20
> -------------------------------------------------------------------------=
-------
> tb0219_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> tb0226_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> tb0287_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> tct_hammer_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches
>=20
> -------------------------------------------------------------------------=
-------
> tegra_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> tinyconfig (x86_64) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mismat=
ches
>=20
> Warnings:
>     .config:1008:warning: override: UNWINDER_GUESS changes choice state
>=20
> -------------------------------------------------------------------------=
-------
> tinyconfig (i386) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatc=
hes
>=20
> -------------------------------------------------------------------------=
-------
> tinyconfig (arm64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches
>=20
> -------------------------------------------------------------------------=
-------
> tinyconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatch=
es
>=20
> -------------------------------------------------------------------------=
-------
> tinyconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatc=
hes
>=20
> -------------------------------------------------------------------------=
-------
> tinyconfig (arc) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section mismatches
>=20
> Errors:
>     arc-linux-ld: error: vmlinux.o: unable to merge ISA extension attribu=
tes code-density.
>=20
> Warnings:
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>=20
> -------------------------------------------------------------------------=
-------
> tinyconfig (riscv) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches
>=20
> -------------------------------------------------------------------------=
-------
> trizeps4_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> u300_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> u8500_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> vdk_hs38_defconfig (arc) =E2=80=94 PASS, 0 errors, 5 warnings, 0 section =
mismatches
>=20
> Warnings:
>     arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but=
 not used [-Wunused-function]
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>=20
> -------------------------------------------------------------------------=
-------
> vdk_hs38_smp_defconfig (arc) =E2=80=94 PASS, 0 errors, 5 warnings, 0 sect=
ion mismatches
>=20
> Warnings:
>     arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but=
 not used [-Wunused-function]
>     arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length arr=
ay 'pd0' [-Wvla]
>     include/linux/kernel.h:845:29: warning: comparison of distinct pointe=
r types lacks a cast
>     arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not =
used [-Wunused-value]
>     net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array=
 bounds [-Warray-bounds]
>=20
> -------------------------------------------------------------------------=
-------
> versatile_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches
>=20
> -------------------------------------------------------------------------=
-------
> vexpress_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> vf610m4_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches
>=20
> -------------------------------------------------------------------------=
-------
> viper_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> vocore2_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> vt8500_v6_v7_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches
>=20
> -------------------------------------------------------------------------=
-------
> workpad_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches
>=20
> -------------------------------------------------------------------------=
-------
> xcep_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> xway_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches
>=20
> -------------------------------------------------------------------------=
-------
> zeus_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches
>=20
> -------------------------------------------------------------------------=
-------
> zx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches
>=20
> ---
> For more info write to <info@kernelci.org>



Thanks,
Mauro
