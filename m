Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22895 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751628AbeBAJRQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Feb 2018 04:17:16 -0500
Date: Thu, 01 Feb 2018 17:16:49 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [ragnatech:media-tree] BUILD SUCCESS
 273caa260035c03d89ad63d72d8cd3d9e5c5e3f1
Message-ID: <5a72db01.oG0rBQh4BE3Z2Qtb%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree/branch: git://git.ragnatech.se/linux  media-tree
branch HEAD: 273caa260035c03d89ad63d72d8cd3d9e5c5e3f1  media: v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs

elapsed time: 283m

configs tested: 131

The following configs have been built successfully.
More configs may be tested in the coming days.

x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
i386                   randconfig-x019-201804
i386                   randconfig-x010-201804
i386                   randconfig-x015-201804
i386                   randconfig-x014-201804
i386                   randconfig-x012-201804
i386                   randconfig-x011-201804
i386                   randconfig-x017-201804
i386                   randconfig-x016-201804
i386                   randconfig-x018-201804
i386                   randconfig-x013-201804
i386                     randconfig-n0-201804
x86_64                 randconfig-x008-201804
x86_64                 randconfig-x000-201804
x86_64                 randconfig-x005-201804
x86_64                 randconfig-x002-201804
x86_64                 randconfig-x007-201804
x86_64                 randconfig-x009-201804
x86_64                 randconfig-x006-201804
x86_64                 randconfig-x001-201804
x86_64                 randconfig-x003-201804
x86_64                 randconfig-x004-201804
i386                     randconfig-i0-201804
i386                     randconfig-i1-201804
alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
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
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
cris                 etrax-100lx_v2_defconfig
powerpc                      katmai_defconfig
sparc64                          allyesconfig
x86_64                 randconfig-g0-02011358
frv                                 defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
tile                         tilegx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
i386                             allmodconfig
i386                     randconfig-a0-201804
i386                     randconfig-a1-201804
x86_64                 randconfig-s0-02011538
x86_64                 randconfig-s1-02011538
x86_64                 randconfig-s2-02011538
x86_64                 randconfig-x010-201804
x86_64                 randconfig-x011-201804
x86_64                 randconfig-x012-201804
x86_64                 randconfig-x013-201804
x86_64                 randconfig-x014-201804
x86_64                 randconfig-x015-201804
x86_64                 randconfig-x016-201804
x86_64                 randconfig-x017-201804
x86_64                 randconfig-x018-201804
x86_64                 randconfig-x019-201804
i386                             alldefconfig
i386                              allnoconfig
i386                                defconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
m68k                           sun3_defconfig
i386                     randconfig-s0-201804
i386                     randconfig-s1-201804
x86_64                 randconfig-s3-02011549
x86_64                 randconfig-s4-02011549
x86_64                 randconfig-s5-02011549
arm                  colibri_pxa270_defconfig
mips                           jazz_defconfig
sh                        dreamcast_defconfig
x86_64                 randconfig-u0-02011532
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
s390                        default_defconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
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
x86_64                              federa-25
x86_64                                  kexec
x86_64                                   rhel
x86_64                               rhel-7.2
x86_64                randconfig-ws0-02011240
ia64                             alldefconfig
ia64                              allnoconfig
ia64                                defconfig
x86_64                 randconfig-r0-02011337
i386                   randconfig-x000-201804
i386                   randconfig-x001-201804
i386                   randconfig-x002-201804
i386                   randconfig-x003-201804
i386                   randconfig-x004-201804
i386                   randconfig-x005-201804
i386                   randconfig-x006-201804
i386                   randconfig-x007-201804
i386                   randconfig-x008-201804
i386                   randconfig-x009-201804
mips                           32r2_defconfig
mips                         64r6el_defconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                   jz4740
mips                      malta_kvm_defconfig
mips                                     txx9

Thanks,
Fengguang
