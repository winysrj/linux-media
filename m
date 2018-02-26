Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47308 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbeBZRum (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 12:50:42 -0500
Date: Tue, 27 Feb 2018 01:49:45 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [ragnatech:media-tree] BUILD SUCCESS
 52e17089d1850774d2ef583cdef2b060b84fca8c
Message-ID: <5a9448b9.92++OzGi0o+hxfKH%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree/branch: git://git.ragnatech.se/linux  media-tree
branch HEAD: 52e17089d1850774d2ef583cdef2b060b84fca8c  media: imx: Don't initialize vars that won't be used

elapsed time: 203m

configs tested: 133

The following configs have been built successfully.
More configs may be tested in the coming days.

parisc                        c3000_defconfig
parisc                         b180_defconfig
parisc                              defconfig
alpha                               defconfig
parisc                            allnoconfig
cris                 etrax-100lx_v2_defconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
powerpc                      arches_defconfig
powerpc                       ep405_defconfig
powerpc                    sam440ep_defconfig
i386                               tinyconfig
x86_64                                    lkp
x86_64                                   rhel
x86_64                               rhel-7.2
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
s390                        default_defconfig
i386                     randconfig-i0-201808
i386                     randconfig-i1-201808
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
x86_64                                  kexec
x86_64                              federa-25
i386                             allmodconfig
x86_64                 randconfig-x017-201808
x86_64                 randconfig-x013-201808
x86_64                 randconfig-x016-201808
x86_64                 randconfig-x018-201808
x86_64                 randconfig-x015-201808
x86_64                 randconfig-x012-201808
x86_64                 randconfig-x014-201808
x86_64                 randconfig-x011-201808
x86_64                 randconfig-x010-201808
x86_64                 randconfig-x019-201808
ia64                             alldefconfig
ia64                              allnoconfig
ia64                                defconfig
i386                     randconfig-a1-201808
i386                     randconfig-a0-201808
x86_64                 randconfig-s0-02270100
x86_64                 randconfig-s1-02270100
x86_64                 randconfig-s2-02270100
frv                                 defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
tile                         tilegx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
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
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
m68k                           sun3_defconfig
m68k                          multi_defconfig
m68k                       m5475evb_defconfig
i386                     randconfig-s0-201808
i386                     randconfig-s1-201808
x86_64                 randconfig-s3-02270045
x86_64                 randconfig-s4-02270045
x86_64                 randconfig-s5-02270045
x86_64                   randconfig-i0-201808
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
i386                   randconfig-x015-201808
i386                   randconfig-x019-201808
i386                   randconfig-x010-201808
i386                   randconfig-x014-201808
i386                   randconfig-x016-201808
i386                   randconfig-x012-201808
i386                   randconfig-x011-201808
i386                   randconfig-x017-201808
i386                   randconfig-x013-201808
i386                   randconfig-x018-201808
mn10300                          alldefconfig
powerpc                      obs600_defconfig
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
arm                         at91_dt_defconfig
arm                               allnoconfig
arm                           efm32_defconfig
arm64                               defconfig
arm                        multi_v5_defconfig
arm                           sunxi_defconfig
arm64                             allnoconfig
arm                          exynos_defconfig
arm                        shmobile_defconfig
arm                        multi_v7_defconfig
i386                              allnoconfig
i386                                defconfig
i386                             alldefconfig
x86_64                 randconfig-x000-201808
x86_64                 randconfig-x005-201808
x86_64                 randconfig-x008-201808
x86_64                 randconfig-x006-201808
x86_64                 randconfig-x001-201808
x86_64                 randconfig-x007-201808
x86_64                 randconfig-x009-201808
x86_64                 randconfig-x002-201808
x86_64                 randconfig-x003-201808
x86_64                 randconfig-x004-201808
i386                   randconfig-x004-201808
i386                   randconfig-x002-201808
i386                   randconfig-x007-201808
i386                   randconfig-x009-201808
i386                   randconfig-x003-201808
i386                   randconfig-x001-201808
i386                   randconfig-x008-201808
i386                   randconfig-x005-201808
i386                   randconfig-x006-201808
i386                   randconfig-x000-201808
mips                           32r2_defconfig
mips                         64r6el_defconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                   jz4740
mips                      malta_kvm_defconfig
mips                                     txx9

Thanks,
Fengguang
