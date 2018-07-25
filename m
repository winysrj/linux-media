Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:33701 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728631AbeGYQIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 12:08:21 -0400
Date: Wed, 25 Jul 2018 19:38:39 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [ragnatech:media-tree] BUILD INCOMPLETE
 231783073ebfc4acf02a45cb78a52ffa16e4e6d3
Message-ID: <5b58613f./05tW6VJqt1IqXCK%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree/branch: git://git.ragnatech.se/linux  media-tree
branch HEAD: 231783073ebfc4acf02a45cb78a52ffa16e4e6d3  media: v4l: rcar_fdp1: Enable compilation on Gen2 platforms

TIMEOUT after 600m


Sorry we cannot finish the testset for your branch within a reasonable time.
It's our fault -- either some build server is down or some build worker is busy
doing bisects for _other_ trees. The branch will get more complete coverage and
possible error reports when our build infrastructure is restored or catches up.
There will be no more build success notification for this branch head, but you
can expect reasonably good test coverage after waiting for 1 day.

configs tested: 50

i386                               tinyconfig
i386                   randconfig-x012-201829
i386                   randconfig-x017-201829
i386                   randconfig-x014-201829
i386                   randconfig-x016-201829
i386                   randconfig-x013-201829
i386                   randconfig-x011-201829
i386                   randconfig-x018-201829
i386                   randconfig-x010-201829
i386                   randconfig-x015-201829
i386                   randconfig-x019-201829
x86_64                 randconfig-x007-201829
x86_64                 randconfig-x003-201829
x86_64                 randconfig-x000-201829
x86_64                 randconfig-x005-201829
x86_64                 randconfig-x004-201829
x86_64                 randconfig-x008-201829
x86_64                 randconfig-x001-201829
x86_64                 randconfig-x009-201829
x86_64                 randconfig-x002-201829
x86_64                 randconfig-x006-201829
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
x86_64                 randconfig-x010-201829
x86_64                 randconfig-x011-201829
x86_64                 randconfig-x012-201829
x86_64                 randconfig-x013-201829
x86_64                 randconfig-x014-201829
x86_64                 randconfig-x015-201829
x86_64                 randconfig-x016-201829
x86_64                 randconfig-x017-201829
x86_64                 randconfig-x018-201829
x86_64                 randconfig-x019-201829
ia64                             alldefconfig
ia64                              allnoconfig
ia64                                defconfig
openrisc                    or1ksim_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
c6x                        evmc6678_defconfig
h8300                    h8300h-sim_defconfig
nios2                         10m50_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
