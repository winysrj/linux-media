Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:64642 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752496AbcKRVW1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 16:22:27 -0500
Date: Sat, 19 Nov 2016 05:21:28 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [linuxtv-media:master] BUILD REGRESSION
 c044170fcfca3783f7dd8eb69ff8b06d66fad5d8
Message-ID: <582f70d8.3MVMHhZwl8j4uGqz%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

git://linuxtv.org/media_tree.git  master
c044170fcfca3783f7dd8eb69ff8b06d66fad5d8  [media] media: rc: nuvoton: replace usage of spin_lock_irqsave in ISR

drivers/built-in.o:(.rodata+0x117278): undefined reference to `dvb_tuner_simple_release'
drivers/built-in.o:(.rodata+0x27638): undefined reference to `dvb_tuner_simple_release'
drivers/built-in.o:(.rodata+0x56358): undefined reference to `dvb_tuner_simple_release'
drivers/media/dvb-core/dvb_frontend.h:274: warning: No description found for parameter 'fe'
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/fc0011.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/fc0012.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/fc0013.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/mc44s803.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/mt2060.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/mt20xx.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/mt2266.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/qt1010.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/tda18218.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/tda827x.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/tea5761.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/tea5767.ko] undefined!
(.rodata+0x122cf8): undefined reference to `dvb_tuner_simple_release'
(.rodata+0xb8ef8): undefined reference to `dvb_tuner_simple_release'
(.text+0x15a35f): undefined reference to `dvb_tuner_simple_release'
(.text+0x52ce16): undefined reference to `dvb_tuner_simple_release'

Error ids grouped by kconfigs:

recent_errors
├── i386-allnoconfig
│   └── drivers-media-dvb-core-dvb_frontend.h:warning:No-description-found-for-parameter-fe
├── i386-randconfig-i1-201646
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-fc0011.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-mc44s803.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-mt2060.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-mt2x.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-tea5761.ko-undefined
│   └── ERROR:dvb_tuner_simple_release-drivers-media-tuners-tea5767.ko-undefined
├── i386-randconfig-r0-201646
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-fc0011.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-fc0012.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-fc0013.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-mc44s803.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-mt2060.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-mt2266.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-mt2x.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-qt1010.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-tda18218.ko-undefined
│   ├── ERROR:dvb_tuner_simple_release-drivers-media-tuners-tda827x.ko-undefined
│   └── ERROR:dvb_tuner_simple_release-drivers-media-tuners-tea5767.ko-undefined
├── i386-randconfig-s1-201646
│   └── drivers-built-in.o:(.rodata):undefined-reference-to-dvb_tuner_simple_release
├── x86_64-randconfig-g0-11181716
│   └── (.rodata):undefined-reference-to-dvb_tuner_simple_release
├── x86_64-randconfig-i0-201646
│   ├── drivers-built-in.o:(.rodata):undefined-reference-to-dvb_tuner_simple_release
│   └── (.text):undefined-reference-to-dvb_tuner_simple_release
├── x86_64-randconfig-s0-11190349
│   ├── drivers-built-in.o:(.rodata):undefined-reference-to-dvb_tuner_simple_release
│   └── (.text):undefined-reference-to-dvb_tuner_simple_release
└── x86_64-randconfig-s4-11190059
    └── (.rodata):undefined-reference-to-dvb_tuner_simple_release

elapsed time: 117m

configs tested: 166

alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
i386                     randconfig-a0-201646
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
cris                 etrax-100lx_v2_defconfig
arm                     davinci_all_defconfig
arm                            netx_defconfig
mips                        generic_defconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
i386                   randconfig-c0-11182335
microblaze                       allyesconfig
powerpc                    amigaone_defconfig
powerpc                     kmp204x_defconfig
x86_64                 randconfig-g0-11181716
c6x                        evmc6678_defconfig
h8300                    h8300h-sim_defconfig
m32r                       m32104ut_defconfig
m32r                     mappi3.smp_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
nios2                         10m50_defconfig
score                      spct6600_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
arm                              allyesconfig
arm                           h5000_defconfig
arm                       spear13xx_defconfig
mips                      loongson3_defconfig
sh                           se7751_defconfig
x86_64                 randconfig-x010-201646
x86_64                 randconfig-x011-201646
x86_64                 randconfig-x012-201646
x86_64                 randconfig-x013-201646
x86_64                 randconfig-x014-201646
x86_64                 randconfig-x015-201646
x86_64                 randconfig-x016-201646
x86_64                 randconfig-x017-201646
x86_64                 randconfig-x018-201646
x86_64                 randconfig-x019-201646
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
m68k                           sun3_defconfig
i386                     randconfig-s0-201646
i386                     randconfig-s1-201646
x86_64                 randconfig-s0-11190349
x86_64                 randconfig-s1-11190349
x86_64                 randconfig-s2-11190349
avr32                      atngw100_defconfig
avr32                     atstk1006_defconfig
frv                                 defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
tile                         tilegx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
i386                             allmodconfig
mips                           32r2_defconfig
mips                         64r6el_defconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                   jz4740
mips                      malta_kvm_defconfig
mips                                     txx9
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
s390                        default_defconfig
x86_64                   randconfig-i0-201646
mips                        nlm_xlp_defconfig
powerpc                     tqm8560_defconfig
s390                              allnoconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
i386                     randconfig-i0-201646
i386                     randconfig-i1-201646
x86_64                 randconfig-b0-11190034
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
x86_64                           allmodconfig
arm                         s3c6400_defconfig
sh                     sh7710voipgw_defconfig
xtensa                           allmodconfig
x86_64                 randconfig-u0-11190353
m68k                        mvme147_defconfig
x86_64                randconfig-ne0-11190411
arm                             pxa_defconfig
arm                         shannon_defconfig
mips                                defconfig
parisc                          712_defconfig
i386                   randconfig-x010-201646
i386                   randconfig-x011-201646
i386                   randconfig-x012-201646
i386                   randconfig-x013-201646
i386                   randconfig-x014-201646
i386                   randconfig-x015-201646
i386                   randconfig-x016-201646
i386                   randconfig-x017-201646
i386                   randconfig-x018-201646
i386                   randconfig-x019-201646
x86_64                                    lkp
x86_64                                   rhel
x86_64                               rhel-7.2
i386                     randconfig-n0-201646
ia64                             alldefconfig
ia64                              allnoconfig
ia64                                defconfig
i386                   randconfig-x070-201646
i386                   randconfig-x071-201646
i386                   randconfig-x072-201646
i386                   randconfig-x073-201646
i386                   randconfig-x074-201646
i386                   randconfig-x075-201646
i386                   randconfig-x076-201646
i386                   randconfig-x077-201646
i386                   randconfig-x078-201646
i386                   randconfig-x079-201646
x86_64                                  kexec
arm                               allnoconfig
arm                         at91_dt_defconfig
arm                           efm32_defconfig
arm                          exynos_defconfig
arm                        multi_v5_defconfig
arm                        multi_v7_defconfig
arm                        shmobile_defconfig
arm                           sunxi_defconfig
arm64                             allnoconfig
arm64                               defconfig
x86_64                 randconfig-x000-201646
x86_64                 randconfig-x001-201646
x86_64                 randconfig-x002-201646
x86_64                 randconfig-x003-201646
x86_64                 randconfig-x004-201646
x86_64                 randconfig-x005-201646
x86_64                 randconfig-x006-201646
x86_64                 randconfig-x007-201646
x86_64                 randconfig-x008-201646
x86_64                 randconfig-x009-201646
i386                     randconfig-r0-201646
x86_64                 randconfig-r0-11190044
i386                   randconfig-x000-201646
i386                   randconfig-x001-201646
i386                   randconfig-x002-201646
i386                   randconfig-x003-201646
i386                   randconfig-x004-201646
i386                   randconfig-x005-201646
i386                   randconfig-x006-201646
i386                   randconfig-x007-201646
i386                   randconfig-x008-201646
i386                   randconfig-x009-201646
i386                             alldefconfig
i386                              allnoconfig
i386                                defconfig
i386                   randconfig-x0-11190051

Thanks,
Fengguang
