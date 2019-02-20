Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAE3C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E0B72147A
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfBTMVO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:21:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:44810 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbfBTMVO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 07:21:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2019 04:21:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,390,1544515200"; 
   d="scan'208";a="145787256"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 20 Feb 2019 04:21:12 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gwQsB-000Cyf-KL; Wed, 20 Feb 2019 20:21:11 +0800
Date:   Wed, 20 Feb 2019 20:21:10 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org
Subject: [ragnatech:media-tree] BUILD SUCCESS
 9fabe1d108ca4755a880de43f751f1c054f8894d
Message-ID: <5c6d4636.e1OMSSYjb4Hi6yMy%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

tree/branch: git://git.ragnatech.se/linux  media-tree
branch HEAD: 9fabe1d108ca4755a880de43f751f1c054f8894d  media: ipu3-mmu: fix some kernel-doc macros

elapsed time: 383m

configs tested: 140

The following configs have been built successfully.
More configs may be tested in the coming days.

parisc                        c3000_defconfig
um                                  defconfig
parisc                         b180_defconfig
parisc                              defconfig
alpha                               defconfig
parisc                            allnoconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
x86_64                 randconfig-x005-201907
x86_64                 randconfig-x008-201907
x86_64                 randconfig-x009-201907
x86_64                 randconfig-x001-201907
x86_64                 randconfig-x002-201907
x86_64                 randconfig-x003-201907
x86_64                 randconfig-x006-201907
x86_64                 randconfig-x007-201907
x86_64                 randconfig-x000-201907
x86_64                 randconfig-x004-201907
i386                   randconfig-x007-201907
i386                   randconfig-x000-201907
i386                   randconfig-x006-201907
i386                   randconfig-x002-201907
i386                   randconfig-x001-201907
i386                   randconfig-x003-201907
i386                   randconfig-x009-201907
i386                   randconfig-x008-201907
i386                   randconfig-x005-201907
i386                   randconfig-x004-201907
x86_64                 randconfig-x013-201907
x86_64                 randconfig-x017-201907
x86_64                 randconfig-x016-201907
x86_64                 randconfig-x019-201907
x86_64                 randconfig-x012-201907
x86_64                 randconfig-x011-201907
x86_64                 randconfig-x018-201907
x86_64                 randconfig-x010-201907
x86_64                 randconfig-x015-201907
x86_64                 randconfig-x014-201907
arm                       omap2plus_defconfig
arm                              allmodconfig
arm                        mvebu_v7_defconfig
arm                          ixp4xx_defconfig
arm                       imx_v6_v7_defconfig
arm64                            allmodconfig
arm                           tegra_defconfig
arm64                            alldefconfig
i386                     randconfig-a2-201907
i386                     randconfig-a3-201907
i386                     randconfig-a0-201907
i386                     randconfig-a1-201907
i386                              allnoconfig
i386                                defconfig
i386                             alldefconfig
m68k                           sun3_defconfig
m68k                          multi_defconfig
m68k                       m5475evb_defconfig
m68k                             allmodconfig
i386                     randconfig-s0-201907
i386                     randconfig-s1-201907
i386                     randconfig-s2-201907
i386                     randconfig-s3-201907
x86_64                           allmodconfig
i386                             allmodconfig
x86_64                                    lkp
x86_64                                   rhel
x86_64                               rhel-7.2
riscv                              tinyconfig
i386                               tinyconfig
powerpc                             defconfig
s390                        default_defconfig
powerpc                       ppc64_defconfig
powerpc                           allnoconfig
sh                               allmodconfig
sh                            titan_defconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                                allnoconfig
openrisc                    or1ksim_defconfig
um                           x86_64_defconfig
um                             i386_defconfig
nds32                               defconfig
nds32                             allnoconfig
sparc64                          allmodconfig
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
c6x                        evmc6678_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
nios2                         10m50_defconfig
h8300                    h8300h-sim_defconfig
mips                             allmodconfig
mips                      malta_kvm_defconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
i386                     randconfig-m0-201907
x86_64                   randconfig-m0-201907
i386                     randconfig-m1-201907
x86_64                   randconfig-m3-201907
x86_64                   randconfig-m1-201907
i386                     randconfig-m2-201907
i386                     randconfig-m3-201907
x86_64                   randconfig-m2-201907
riscv                             allnoconfig
riscv                               defconfig
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
ia64                             alldefconfig
i386                     randconfig-l3-201907
x86_64                   randconfig-l0-201907
i386                     randconfig-l2-201907
x86_64                   randconfig-l2-201907
x86_64                   randconfig-l1-201907
x86_64                   randconfig-l3-201907
i386                     randconfig-l1-201907
i386                     randconfig-l0-201907
i386                   randconfig-x019-201907
i386                   randconfig-x015-201907
i386                   randconfig-x016-201907
i386                   randconfig-x014-201907
i386                   randconfig-x012-201907
i386                   randconfig-x013-201907
i386                   randconfig-x010-201907
i386                   randconfig-x018-201907
i386                   randconfig-x017-201907
i386                   randconfig-x011-201907
x86_64                                  kexec
x86_64                         rhel-7.2-clear
x86_64                              fedora-25
i386                   randconfig-x072-201907
i386                   randconfig-x079-201907
i386                   randconfig-x075-201907
i386                   randconfig-x073-201907
i386                   randconfig-x077-201907
i386                   randconfig-x078-201907
i386                   randconfig-x074-201907
i386                   randconfig-x076-201907
i386                   randconfig-x070-201907
i386                   randconfig-x071-201907

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
