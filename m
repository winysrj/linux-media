Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A6CC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 15:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3E4E21871
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 15:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernelci-org.20150623.gappssmtp.com header.i=@kernelci-org.20150623.gappssmtp.com header.b="yIohHMEQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbeLRP3f (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 10:29:35 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:37253 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbeLRP3f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 10:29:35 -0500
Received: by mail-wm1-f46.google.com with SMTP id g67so3228144wmd.2
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 07:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zCECyUd7tMUk5swKF5tF+QaKBKbAW9L1pmgEsx1kdek=;
        b=yIohHMEQMHtmnqTNjcDgmqyNetYSfKe+ji+pjObxyk39T193AllUFH8L4ARqWuEsGj
         dCKCSxAS1TtdnmaTRMCWRAmw4etba/QDKicNvl3+nEKoj9kx6ni0wGk8oTUfoOU7VeFf
         em1TonJjiUlFgWR3LJld/xhhlRHTq8mcs34z3x+opbE5X2AneQBFWdWtp4S/YQI3GQDq
         9CzElqebQq278jWcIX+Sr7GAlSHWLbaIKLHno3zIrvUk7Y2JEV6/skArl2viidlz72l0
         29LJNQPe13Ex1UxqBSUZkvVjyb+2ThEfeUuB2cwqI9EjFuCKnKG7hd2MromyxoJTkvdo
         m7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zCECyUd7tMUk5swKF5tF+QaKBKbAW9L1pmgEsx1kdek=;
        b=E+VYOsfXvLdI5pDYu4gR+mZkPKfjv0S5yL5EahBHgCCViumKlytDfE/6aQd3m7DllD
         X5ZZMw1Sn8uVCBfrUFNe9nzOIEcimk4OHBHpQ5F4AnVaAEvAZE4nfqr+1jrd921fkfW9
         cm5nBpZj2R7p8JmWtyU4koeOR7ahuSP2KiXJ+Ow2nvFoTt5K1uAnVpDIQG811yrYCFN9
         Koes06oCo248qvTb8qnH3FgZiTr5z8RP51108/er6bDy+CLbNgW3XI6D7KLySQNJRCfB
         /C+GSD6FAgSeSPkxcMRrNE89sb6hVSSrSCbmRIIhOzxWH55R4aQGp0YmzlUh2Zd6Wbr+
         YUhg==
X-Gm-Message-State: AA+aEWbN4hZZmlYKbIlRj4P0cErkjbFigHS/8/teXVwfmf05y7vS8ohQ
        k5mkVpQ0B61BXx4i+nqoEXQL33Ob6t9xfQ==
X-Google-Smtp-Source: AFSGD/WHuNIET4Aw9ibIHefIvRYM8+TFOk7PETjBdk/hNe579b2BbzfXIUG9xBwpYFXWNMV+D1Uhng==
X-Received: by 2002:a1c:f8f:: with SMTP id 137mr3565632wmp.96.1545146968990;
        Tue, 18 Dec 2018 07:29:28 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f187sm2300704wma.4.2018.12.18.07.29.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 07:29:28 -0800 (PST)
Message-ID: <5c191258.1c69fb81.947a9.ca29@mx.google.com>
Date:   Tue, 18 Dec 2018 07:29:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: media
X-Kernelci-Kernel: v4.20-rc5-281-gd2b4387f3bdf
X-Kernelci-Report-Type: build
X-Kernelci-Branch: master
Subject: media/master build: 227 builds: 2 failed, 225 passed, 2 errors,
 90 warnings (v4.20-rc5-281-gd2b4387f3bdf)
To:     linux-media@vger.kernel.org, ezequiel@collabora.com,
        guillaume.tucker@collabora.com, ana.guerrero@collabora.com
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

media/master build: 227 builds: 2 failed, 225 passed, 2 errors, 90 warnings=
 (v4.20-rc5-281-gd2b4387f3bdf)

Full Build Summary: https://kernelci.org/build/media/branch/master/kernel/v=
4.20-rc5-281-gd2b4387f3bdf/

Tree: media
Branch: master
Git Describe: v4.20-rc5-281-gd2b4387f3bdf
Git Commit: d2b4387f3bdf016e266d23cf657465f557721488
Git URL: https://git.linuxtv.org/media_tree.git
Built: 7 unique architectures

Build Failures Detected:

arc:    gcc version 7.1.1 20170710 (ARCv2 ISA Linux uClibc toolchain 2017.0=
9)

    allnoconfig: FAIL
    tinyconfig: FAIL

Errors and Warnings Detected:

arc:    gcc version 7.1.1 20170710 (ARCv2 ISA Linux uClibc toolchain 2017.0=
9)

    allnoconfig: 1 error, 2 warnings
    axs103_defconfig: 6 warnings
    axs103_smp_defconfig: 6 warnings
    haps_hs_defconfig: 4 warnings
    haps_hs_smp_defconfig: 4 warnings
    hsdk_defconfig: 4 warnings
    nsim_hs_defconfig: 4 warnings
    nsim_hs_defconfig+kselftest: 5 warnings
    nsim_hs_defconfig+virtualvideo: 4 warnings
    nsim_hs_smp_defconfig: 4 warnings
    nsimosci_hs_defconfig: 4 warnings
    nsimosci_hs_smp_defconfig: 4 warnings
    tinyconfig: 1 error, 2 warnings
    vdk_hs38_defconfig: 5 warnings
    vdk_hs38_smp_defconfig: 5 warnings

arm64:    gcc version 7.3.0 (Debian 7.3.0-28)

    allmodconfig: 1 warning

arm:    gcc version 7.3.0 (Debian 7.3.0-28)

    cm_x300_defconfig: 1 warning
    em_x270_defconfig: 1 warning
    eseries_pxa_defconfig: 1 warning
    multi_v7_defconfig: 1 warning
    multi_v7_defconfig+CONFIG_CPU_BIG_ENDIAN=3Dy: 1 warning
    multi_v7_defconfig+CONFIG_EFI=3Dy+CONFIG_ARM_LPAE=3Dy: 1 warning
    multi_v7_defconfig+CONFIG_SMP=3Dn: 1 warning
    multi_v7_defconfig+kselftest: 1 warning
    multi_v7_defconfig+virtualvideo: 1 warning
    pxa_defconfig: 4 warnings
    qcom_defconfig: 1 warning

mips:    gcc version 6.3.0 (GCC)

    db1xxx_defconfig: 2 warnings
    decstation_defconfig: 1 warning
    defconfig: 1 warning
    defconfig+kselftest: 1 warning
    defconfig+virtualvideo: 1 warning
    lemote2f_defconfig: 1 warning
    loongson3_defconfig: 2 warnings
    nlm_xlp_defconfig: 1 warning

riscv:    gcc version 7.3.0 (Debian 7.3.0-27)

    defconfig+kselftest: 1 warning

x86_64:    gcc version 7.3.0 (Debian 7.3.0-30)

    tinyconfig: 1 warning

Errors summary:

    2    arc-linux-ld: error: vmlinux.o: unable to merge ISA extension attr=
ibutes code-density.

Warnings summary:

    15   include/linux/kernel.h:845:29: warning: comparison of distinct poi=
nter types lacks a cast
    15   arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length =
array 'pd0' [-Wvla]
    14   arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is n=
ot used [-Wunused-value]
    13   net/ipv4/tcp_input.c:4315:49: warning: array subscript is above ar=
ray bounds [-Warray-bounds]
    7    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (grap=
h_endpoint): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to no=
de '/soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional
    4    sound/soc/codecs/wm9712.c:666:2: warning: 'regmap' may be used uni=
nitialized in this function [-Wmaybe-uninitialized]
    3    net/core/rtnetlink.c:3224:1: warning: the frame size of 1328 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    3    arch/mips/boot/dts/xilfpga/nexys4ddr.dtb: Warning (i2c_bus_reg): /=
i2c@10A00000/ad7420@4B: I2C bus unit address format error, expected "4b"
    2    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined =
but not used [-Wunused-function]
    2    WARNING: sound/ac97_bus: 'snd_ac97_reset' exported twice. Previous=
 export was in sound/ac97/ac97.ko
    1    sound/soc/codecs/wm9705.c:346:2: warning: 'regmap' may be used uni=
nitialized in this function [-Wmaybe-uninitialized]
    1    include/linux/list.h:63:13: warning: 'head' may be used uninitiali=
zed in this function [-Wmaybe-uninitialized]
    1    drivers/net/ethernet/amd/declance.c:1232:2: warning: 'desc' may be=
 used uninitialized in this function [-Wmaybe-uninitialized]
    1    drivers/mtd/nand/raw/au1550nd.c:447:57: warning: pointer type mism=
atch in conditional expression
    1    drivers/isdn/hardware/eicon/message.c:5985:1: warning: the frame s=
ize of 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=3D]
    1    arch/riscv/kernel/ftrace.c:135:6: warning: unused variable 'err' [=
-Wunused-variable]
    1    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm'=
 invalid for HOTPLUG_PCI_SHPC
    1    arch/arc/boot/dts/axs103_idu.dtb: Warning (i2c_bus_reg): /axs10x_m=
b/i2c@0x1f000/eeprom@0x57: I2C bus unit address format error, expected "57"
    1    arch/arc/boot/dts/axs103_idu.dtb: Warning (i2c_bus_reg): /axs10x_m=
b/i2c@0x1f000/eeprom@0x54: I2C bus unit address format error, expected "54"
    1    arch/arc/boot/dts/axs103.dtb: Warning (i2c_bus_reg): /axs10x_mb/i2=
c@0x1f000/eeprom@0x57: I2C bus unit address format error, expected "57"
    1    arch/arc/boot/dts/axs103.dtb: Warning (i2c_bus_reg): /axs10x_mb/i2=
c@0x1f000/eeprom@0x54: I2C bus unit address format error, expected "54"
    1    .config:1008:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allmodconfig (arm64) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mismatc=
hes

Warnings:
    drivers/isdn/hardware/eicon/message.c:5985:1: warning: the frame size o=
f 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
allnoconfig (i386) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatch=
es

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatc=
hes

---------------------------------------------------------------------------=
-----
allnoconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatch=
es

---------------------------------------------------------------------------=
-----
allnoconfig (arc) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section mismatches

Errors:
    arc-linux-ld: error: vmlinux.o: unable to merge ISA extension attribute=
s code-density.

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast

---------------------------------------------------------------------------=
-----
allnoconfig (riscv) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatc=
hes

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc) =E2=80=94 PASS, 0 errors, 6 warnings, 0 section mism=
atches

Warnings:
    arch/arc/boot/dts/axs103.dtb: Warning (i2c_bus_reg): /axs10x_mb/i2c@0x1=
f000/eeprom@0x54: I2C bus unit address format error, expected "54"
    arch/arc/boot/dts/axs103.dtb: Warning (i2c_bus_reg): /axs10x_mb/i2c@0x1=
f000/eeprom@0x57: I2C bus unit address format error, expected "57"
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc) =E2=80=94 PASS, 0 errors, 6 warnings, 0 section =
mismatches

Warnings:
    arch/arc/boot/dts/axs103_idu.dtb: Warning (i2c_bus_reg): /axs10x_mb/i2c=
@0x1f000/eeprom@0x54: I2C bus unit address format error, expected "54"
    arch/arc/boot/dts/axs103_idu.dtb: Warning (i2c_bus_reg): /axs10x_mb/i2c=
@0x1f000/eeprom@0x57: I2C bus unit address format error, expected "57"
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mism=
atches

Warnings:
    sound/soc/codecs/wm9712.c:666:2: warning: 'regmap' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section mis=
matches

Warnings:
    include/linux/list.h:63:13: warning: 'head' may be used uninitialized i=
n this function [-Wmaybe-uninitialized]
    drivers/mtd/nand/raw/au1550nd.c:447:57: warning: pointer type mismatch =
in conditional expression

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    drivers/net/ethernet/amd/declance.c:1232:2: warning: 'desc' may be used=
 uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
defconfig (i386) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (x86_64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatch=
es

---------------------------------------------------------------------------=
-----
defconfig (arm64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mismatches

Warnings:
    arch/mips/boot/dts/xilfpga/nexys4ddr.dtb: Warning (i2c_bus_reg): /i2c@1=
0A00000/ad7420@4B: I2C bus unit address format error, expected "4b"

---------------------------------------------------------------------------=
-----
defconfig (riscv) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig+CONFIG_CPU_BIG_ENDIAN=3Dy (arm64) =E2=80=94 PASS, 0 errors, 0 war=
nings, 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig+CONFIG_RANDOMIZE_BASE=3Dy (arm64) =E2=80=94 PASS, 0 errors, 0 war=
nings, 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig+kselftest (x86_64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
defconfig+kselftest (i386) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
defconfig+kselftest (arm64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
defconfig+kselftest (riscv) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    arch/riscv/kernel/ftrace.c:135:6: warning: unused variable 'err' [-Wunu=
sed-variable]

---------------------------------------------------------------------------=
-----
defconfig+kselftest (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    arch/mips/boot/dts/xilfpga/nexys4ddr.dtb: Warning (i2c_bus_reg): /i2c@1=
0A00000/ad7420@4B: I2C bus unit address format error, expected "4b"

---------------------------------------------------------------------------=
-----
defconfig+virtualvideo (x86_64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
defconfig+virtualvideo (i386) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
defconfig+virtualvideo (arm64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
defconfig+virtualvideo (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/mips/boot/dts/xilfpga/nexys4ddr.dtb: Warning (i2c_bus_reg): /i2c@1=
0A00000/ad7420@4B: I2C bus unit address format error, expected "4b"

---------------------------------------------------------------------------=
-----
defconfig+virtualvideo (riscv) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mism=
atches

Warnings:
    sound/soc/codecs/wm9712.c:666:2: warning: 'regmap' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    sound/soc/codecs/wm9712.c:666:2: warning: 'regmap' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatc=
hes

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section mis=
matches

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section=
 mismatches

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section mismat=
ches

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    net/core/rtnetlink.c:3224:1: warning: the frame size of 1328 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm' inva=
lid for HOTPLUG_PCI_SHPC
    net/core/rtnetlink.c:3224:1: warning: the frame size of 1328 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_end=
point): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node '/=
soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional

---------------------------------------------------------------------------=
-----
multi_v7_defconfig+CONFIG_CPU_BIG_ENDIAN=3Dy (arm) =E2=80=94 PASS, 0 errors=
, 1 warning, 0 section mismatches

Warnings:
    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_end=
point): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node '/=
soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional

---------------------------------------------------------------------------=
-----
multi_v7_defconfig+CONFIG_EFI=3Dy+CONFIG_ARM_LPAE=3Dy (arm) =E2=80=94 PASS,=
 0 errors, 1 warning, 0 section mismatches

Warnings:
    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_end=
point): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node '/=
soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional

---------------------------------------------------------------------------=
-----
multi_v7_defconfig+CONFIG_SMP=3Dn (arm) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_end=
point): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node '/=
soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional

---------------------------------------------------------------------------=
-----
multi_v7_defconfig+kselftest (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_end=
point): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node '/=
soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional

---------------------------------------------------------------------------=
-----
multi_v7_defconfig+virtualvideo (arm) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_end=
point): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node '/=
soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig+CONFIG_CPU_BIG_ENDIAN=3Dy (arm) =E2=80=94 PASS, 0 errors=
, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatc=
hes

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
netx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    net/core/rtnetlink.c:3224:1: warning: the frame size of 1328 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section mis=
matches

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig+kselftest (arc) =E2=80=94 PASS, 0 errors, 5 warnings, 0 s=
ection mismatches

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig+virtualvideo (arc) =E2=80=94 PASS, 0 errors, 4 warnings, =
0 section mismatches

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section=
 mismatches

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section=
 mismatches

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sec=
tion mismatches

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section mismatc=
hes

Warnings:
    sound/soc/codecs/wm9705.c:346:2: warning: 'regmap' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
    sound/soc/codecs/wm9712.c:666:2: warning: 'regmap' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
    WARNING: sound/ac97_bus: 'snd_ac97_reset' exported twice. Previous expo=
rt was in sound/ac97/ac97.ko
    WARNING: sound/ac97_bus: 'snd_ac97_reset' exported twice. Previous expo=
rt was in sound/ac97/ac97.ko

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mismatc=
hes

Warnings:
    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_end=
point): /soc/mdp@5100000/ports/port@3/endpoint: graph connection to node '/=
soc/hdmi-tx@4a00000/ports/port@0/endpoint' is not bidirectional

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatc=
hes

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mism=
atches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mismatch=
es

Warnings:
    .config:1008:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (i386) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatch=
es

---------------------------------------------------------------------------=
-----
tinyconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section mismatches

Errors:
    arc-linux-ld: error: vmlinux.o: unable to merge ISA extension attribute=
s code-density.

Warnings:
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast

---------------------------------------------------------------------------=
-----
tinyconfig (riscv) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatch=
es

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc) =E2=80=94 PASS, 0 errors, 5 warnings, 0 section mi=
smatches

Warnings:
    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc) =E2=80=94 PASS, 0 errors, 5 warnings, 0 sectio=
n mismatches

Warnings:
    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    arch/arc/mm/tlb.c:914:2: warning: ISO C90 forbids variable length array=
 'pd0' [-Wvla]
    include/linux/kernel.h:845:29: warning: comparison of distinct pointer =
types lacks a cast
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4315:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
xway_defconfig (mips) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section misma=
tches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismat=
ches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatch=
es

---
For more info write to <info@kernelci.org>
