Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933412AbaGQPgg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 11:36:36 -0400
Date: Fri, 18 Jul 2014 07:29:47 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [linuxtv-media:master] 2181d142707a2cf5df44840ac7112ac4568b03c9
 BUILD DONE
Message-ID: <53c85c6b.O9v+IptjMgCtA699%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

git://linuxtv.org/media_tree.git  master
2181d142707a2cf5df44840ac7112ac4568b03c9  Merge branch 'sched_warn_fix' into patchwork

(.text+0x281c8b0): undefined reference to `__divdi3'
ERROR: "__udivdi3" [drivers/media/v4l2-core/videodev.ko] undefined!
ERROR: "__umoddi3" [drivers/media/v4l2-core/videodev.ko] undefined!
mt9m001.c:(.text+0x2424def): undefined reference to `__divdi3'
mt9t031.c:(.text+0x2427d22): undefined reference to `__divdi3'
pac7302.c:(.text+0x283d216): undefined reference to `__divdi3'
radio-keene.c:(.text+0x294c621): undefined reference to `__udivdi3'
rtl2832_sdr.c:(.text+0x3079b82): undefined reference to `__udivdi3'
sonixb.c:(.text+0x2846fd8): undefined reference to `__divdi3'
v4l2-ctrls.c:(.text+0x1ea2df): undefined reference to `__udivdi3'
v4l2-ctrls.c:(.text+0x1ea33c): undefined reference to `__umoddi3'

elapsed time: 587m

configs tested: 75

alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
mips                             allmodconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                   jz4740
mips                                     txx9
sh                               allmodconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
i386                      randconfig-ha4-0718
i386                      randconfig-ha2-0718
i386                      randconfig-ha0-0718
i386                      randconfig-ha3-0718
i386                      randconfig-ha1-0718
i386                      randconfig-ha5-0718
ia64                             alldefconfig
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
microblaze                       allyesconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
x86_64                    randconfig-ha0-0718
x86_64                    randconfig-ha1-0718
x86_64                    randconfig-ha2-0718
x86_64                    randconfig-ha3-0718
x86_64                    randconfig-ha4-0718
x86_64                    randconfig-ha5-0718
sparc                               defconfig
sparc64                          allmodconfig
sparc64                           allnoconfig
sparc64                             defconfig
m32r                       m32104ut_defconfig
m32r                     mappi3.smp_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
i386                             allyesconfig
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
cris                 etrax-100lx_v2_defconfig
i386                       randconfig-r0-0717
i386                       randconfig-r1-0717
i386                       randconfig-r2-0717
i386                       randconfig-r3-0717
s390                             allmodconfig
s390                              allnoconfig
s390                                defconfig
x86_64                           allmodconfig
avr32                      atngw100_defconfig
avr32                     atstk1006_defconfig
frv                                 defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
tile                         tilegx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                                    lkp
x86_64                                   rhel
powerpc                          allmodconfig
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot

Thanks,
Fengguang
