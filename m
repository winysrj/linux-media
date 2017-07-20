Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:54841 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936542AbdGTP4a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:56:30 -0400
Date: Thu, 20 Jul 2017 23:37:30 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [ragnatech:media-tree] BUILD INCOMPLETE
 8d935787d38f1c2bf689f64ecfe4581e05e5fe55
Message-ID: <5970ce3a.4LPulV0hA3ZJQK8m%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

git://git.ragnatech.se/linux  media-tree
8d935787d38f1c2bf689f64ecfe4581e05e5fe55  media: MAINTAINERS: Add ADV748x driver

TIMEOUT after 1125m


Sorry we cannot finish the testset for your branch within a reasonable time.
It's our fault -- either some build server is down or some build worker is busy
doing bisects for _other_ trees. The branch will get more complete coverage and
possible error reports when our build infrastructure is restored or catches up.
There will be no more build success notification for this branch head, but you
can expect reasonably good test coverage after waiting for 1 day.

configs tested: 154

parisc                        c3000_defconfig
parisc                         b180_defconfig
parisc                              defconfig
alpha                               defconfig
parisc                            allnoconfig
arm64                               defconfig
powerpc                      makalu_defconfig
sh                         ap325rxa_defconfig
x86_64                 randconfig-a0-07201854
blackfin                            defconfig
ia64                                defconfig
mips                                defconfig
i386                   randconfig-c0-07201940
i386                 randconfig-x010-07201658
i386                 randconfig-x011-07201658
i386                 randconfig-x012-07201658
i386                 randconfig-x013-07201658
i386                 randconfig-x014-07201658
i386                 randconfig-x015-07201658
i386                 randconfig-x016-07201658
i386                 randconfig-x017-07201658
i386                 randconfig-x018-07201658
i386                 randconfig-x019-07201658
x86_64                                    lkp
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
x86_64               randconfig-x005-07201609
x86_64               randconfig-x000-07201609
x86_64               randconfig-x004-07201609
x86_64               randconfig-x003-07201609
x86_64               randconfig-x002-07201609
x86_64               randconfig-x008-07201609
x86_64               randconfig-x006-07201609
x86_64               randconfig-x009-07201609
x86_64               randconfig-x007-07201609
x86_64               randconfig-x001-07201609
ia64                              allnoconfig
ia64                             alldefconfig
x86_64                                  kexec
x86_64                                   rhel
x86_64                               rhel-7.2
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
s390                        default_defconfig
i386                             allyesconfig
arm                              allmodconfig
arm                                      arm5
arm                                     arm67
arm                       imx_v6_v7_defconfig
arm                          ixp4xx_defconfig
arm                        mvebu_v7_defconfig
arm                       omap2plus_defconfig
arm                                    sa1100
arm                                   samsung
arm                                        sh
arm                           tegra_defconfig
arm64                            alldefconfig
arm64                            allmodconfig
i386                   randconfig-a0-07201704
i386                   randconfig-a1-07201704
x86_64                 randconfig-s0-07201906
x86_64                 randconfig-s1-07201906
x86_64                 randconfig-s2-07201906
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
cris                 etrax-100lx_v2_defconfig
sh                                  defconfig
x86_64               randconfig-x010-07201610
x86_64               randconfig-x011-07201610
x86_64               randconfig-x012-07201610
x86_64               randconfig-x013-07201610
x86_64               randconfig-x014-07201610
x86_64               randconfig-x015-07201610
x86_64               randconfig-x016-07201610
x86_64               randconfig-x017-07201610
x86_64               randconfig-x018-07201610
x86_64               randconfig-x019-07201610
i386                             alldefconfig
i386                              allnoconfig
i386                                defconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
m68k                           sun3_defconfig
i386                   randconfig-s0-07201610
i386                   randconfig-s1-07201610
x86_64                           allmodconfig
x86_64                 randconfig-s3-07201913
x86_64                 randconfig-s4-07201913
x86_64                 randconfig-s5-07201913
frv                                 defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
tile                         tilegx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
i386                   randconfig-b0-07201605
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
nios2                         10m50_defconfig
sh                          rsk7201_defconfig
sh                   sh7770_generic_defconfig
x86_64                 randconfig-u0-07201924
c6x                        evmc6678_defconfig
xtensa                       common_defconfig
m32r                       m32104ut_defconfig
score                      spct6600_defconfig
xtensa                          iss_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
m32r                     mappi3.smp_defconfig
h8300                    h8300h-sim_defconfig
mips                           jazz_defconfig
i386                             allmodconfig
x86_64                 randconfig-h0-07201704
ia64                            zx1_defconfig
i386                 randconfig-x070-07201611
i386                 randconfig-x071-07201611
i386                 randconfig-x072-07201611
i386                 randconfig-x073-07201611
i386                 randconfig-x074-07201611
i386                 randconfig-x075-07201611
i386                 randconfig-x076-07201611
i386                 randconfig-x077-07201611
i386                 randconfig-x078-07201611
i386                 randconfig-x079-07201611
x86_64                 randconfig-n0-07201916
arm                               allnoconfig
arm                         at91_dt_defconfig
arm                           efm32_defconfig
arm                          exynos_defconfig
arm                        multi_v5_defconfig
arm                        multi_v7_defconfig
arm                        shmobile_defconfig
arm                           sunxi_defconfig
arm64                             allnoconfig
x86_64                randconfig-ws0-07201051
x86_64               randconfig-x000-07201610
x86_64               randconfig-x001-07201610
x86_64               randconfig-x002-07201610
x86_64               randconfig-x003-07201610
x86_64               randconfig-x004-07201610
x86_64               randconfig-x005-07201610
x86_64               randconfig-x006-07201610
x86_64               randconfig-x007-07201610
x86_64               randconfig-x008-07201610
x86_64               randconfig-x009-07201610

Thanks,
Fengguang
