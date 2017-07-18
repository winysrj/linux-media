Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36866 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751379AbdGRQDv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 12:03:51 -0400
Date: Wed, 19 Jul 2017 00:03:10 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [ragnatech:media-tree] BUILD INCOMPLETE
 a3db9d60a118571e696b684a6e8c692a2b064941
Message-ID: <596e313e.rYHUqI/+qz78Z+dO%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

git://git.ragnatech.se/linux  media-tree
a3db9d60a118571e696b684a6e8c692a2b064941  Merge tag 'v4.13-rc1' into patchwork

TIMEOUT after 1349m


Sorry we cannot finish the testset for your branch within a reasonable time.
It's our fault -- either some build server is down or some build worker is busy
doing bisects for _other_ trees. The branch will get more complete coverage and
possible error reports when our build infrastructure is restored or catches up.
There will be no more build success notification for this branch head, but you
can expect reasonably good test coverage after waiting for 1 day.

configs timed out: 135

alpha                            allmodconfig
alpha                            allyesconfig
alpha                               defconfig
arm64                             allnoconfig
arm64                          customconfig-0
arm64                          customconfig-1
arm64                          customconfig-2
arm64                               defconfig
arm                               allnoconfig
arm                         at91_dt_defconfig
arm                            customconfig-0
arm                            customconfig-1
arm                            customconfig-2
arm                           efm32_defconfig
arm                          exynos_defconfig
arm                        multi_v5_defconfig
arm                        multi_v7_defconfig
arm                        shmobile_defconfig
arm                           sunxi_defconfig
blackfin                         allmodconfig
blackfin                         allyesconfig
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
cris                             allmodconfig
cris                             allyesconfig
cris                 etrax-100lx_v2_defconfig
frv                                 defconfig
i386                             alldefconfig
i386                             allmodconfig
i386                              allnoconfig
i386                           customconfig-0
i386                           customconfig-1
i386                           customconfig-2
i386                                defconfig
i386                            randconfig-a0
i386                            randconfig-a1
i386                            randconfig-i0
i386                            randconfig-i1
i386                            randconfig-n0
i386                            randconfig-s0
i386                            randconfig-s1
i386                          randconfig-x000
i386                          randconfig-x001
i386                          randconfig-x002
i386                          randconfig-x003
i386                          randconfig-x004
i386                          randconfig-x005
i386                          randconfig-x006
i386                          randconfig-x007
i386                          randconfig-x008
i386                          randconfig-x009
i386                          randconfig-x070
i386                          randconfig-x071
i386                          randconfig-x072
i386                          randconfig-x073
i386                          randconfig-x074
i386                          randconfig-x075
i386                          randconfig-x076
i386                          randconfig-x077
i386                          randconfig-x078
i386                          randconfig-x079
ia64                             alldefconfig
ia64                             allmodconfig
ia64                              allnoconfig
ia64                             allyesconfig
ia64                                defconfig
m68k                             allmodconfig
m68k                             allyesconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
m68k                           sun3_defconfig
mips                           32r2_defconfig
mips                         64r6el_defconfig
mips                             allmodconfig
mips                              allnoconfig
mips                             allyesconfig
mips                      fuloong2e_defconfig
mips                                   jz4740
mips                      malta_kvm_defconfig
mips                                     txx9
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
parisc                           allmodconfig
parisc                            allnoconfig
parisc                           allyesconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
powerpc                          allyesconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
s390                             allmodconfig
s390                             allyesconfig
s390                        default_defconfig
sh                               allmodconfig
sh                                allnoconfig
sh                               allyesconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
sparc64                          allmodconfig
sparc64                           allnoconfig
sparc64                          allyesconfig
sparc64                             defconfig
sparc                            allmodconfig
sparc                            allyesconfig
sparc                               defconfig
tile                             allmodconfig
tile                             allyesconfig
tile                         tilegx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           allmodconfig
x86_64                           allyesconfig
x86_64                         customconfig-0
x86_64                         customconfig-1
x86_64                         customconfig-2
x86_64                                  kexec
x86_64                          randconfig-i0
x86_64                        randconfig-x000
x86_64                        randconfig-x001
x86_64                        randconfig-x002
x86_64                        randconfig-x003
x86_64                        randconfig-x004
x86_64                        randconfig-x005
x86_64                        randconfig-x006
x86_64                        randconfig-x007
x86_64                        randconfig-x008
x86_64                        randconfig-x009
xtensa                           allmodconfig
xtensa                           allyesconfig

configs tested: 38

i386                   randconfig-x012-201729
i386                   randconfig-x018-201729
i386                   randconfig-x016-201729
i386                   randconfig-x017-201729
i386                   randconfig-x013-201729
i386                   randconfig-x010-201729
i386                   randconfig-x019-201729
i386                   randconfig-x014-201729
i386                   randconfig-x015-201729
i386                   randconfig-x011-201729
x86_64                                    lkp
x86_64                                   rhel
x86_64                               rhel-7.2
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
x86_64                 randconfig-x019-201729
x86_64                 randconfig-x010-201729
x86_64                 randconfig-x015-201729
x86_64                 randconfig-x017-201729
x86_64                 randconfig-x018-201729
x86_64                 randconfig-x016-201729
x86_64                 randconfig-x014-201729
x86_64                 randconfig-x012-201729
x86_64                 randconfig-x011-201729
x86_64                 randconfig-x013-201729
c6x                        evmc6678_defconfig
xtensa                       common_defconfig
m32r                       m32104ut_defconfig
score                      spct6600_defconfig
xtensa                          iss_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
m32r                     mappi3.smp_defconfig
nios2                         10m50_defconfig
h8300                    h8300h-sim_defconfig

Thanks,
Fengguang
