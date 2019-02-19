Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C298BC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 946082183F
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfBSOUB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:20:01 -0500
Received: from mga04.intel.com ([192.55.52.120]:46965 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfBSOUA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 09:20:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2019 06:19:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,388,1544515200"; 
   d="scan'208";a="123587128"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 19 Feb 2019 06:19:58 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gw6Fa-0001Cm-9U; Tue, 19 Feb 2019 22:19:58 +0800
Date:   Tue, 19 Feb 2019 19:27:43 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org
Subject: [ragnatech:media-tree] BUILD SUCCESS
 b3c786566d8f3f69b9f4144c2707db74158caf9a
Message-ID: <5c6be82f.dOFtVKTtmboDQKfV%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

tree/branch: git://git.ragnatech.se/linux  media-tree
branch HEAD: b3c786566d8f3f69b9f4144c2707db74158caf9a  media: MAINTAINERS: add entry for Freescale i.MX7 media driver

elapsed time: 836m

configs tested: 143

The following configs have been built successfully.
More configs may be tested in the coming days.

parisc                        c3000_defconfig
um                                  defconfig
parisc                         b180_defconfig
parisc                              defconfig
alpha                               defconfig
parisc                            allnoconfig
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
x86_64                                    lkp
x86_64                                   rhel
x86_64                               rhel-7.2
x86_64                              fedora-25
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
i386                   randconfig-a3-02181146
i386                   randconfig-a2-02181146
i386                   randconfig-a1-02181146
i386                   randconfig-a0-02181146
c6x                        evmc6678_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
nios2                         10m50_defconfig
h8300                    h8300h-sim_defconfig
arm                              allmodconfig
arm64                            allyesconfig
arm                         at91_dt_defconfig
arm                               allnoconfig
arm                           efm32_defconfig
arm64                               defconfig
arm                        multi_v5_defconfig
arm                           sunxi_defconfig
arm64                             allnoconfig
arm64                            allmodconfig
arm                          exynos_defconfig
arm                        shmobile_defconfig
arm                        multi_v7_defconfig
i386                              allnoconfig
i386                                defconfig
i386                             alldefconfig
i386                   randconfig-s0-02172359
i386                   randconfig-s1-02172359
i386                   randconfig-s3-02172359
i386                   randconfig-s2-02172359
i386                             allmodconfig
arm                       omap2plus_defconfig
arm                        mvebu_v7_defconfig
arm                          ixp4xx_defconfig
arm                       imx_v6_v7_defconfig
arm                           tegra_defconfig
arm64                            alldefconfig
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
mips                             allmodconfig
mips                      malta_kvm_defconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
riscv                             allnoconfig
riscv                               defconfig
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
ia64                             alldefconfig
x86_64                 randconfig-l0-02190616
x86_64                 randconfig-l1-02190616
i386                   randconfig-l2-02190616
i386                   randconfig-l3-02190616
x86_64                 randconfig-l3-02190616
x86_64                 randconfig-l2-02190616
i386                   randconfig-l0-02190616
i386                   randconfig-l1-02190616
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
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
x86_64                           allmodconfig
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
sparc64                          allmodconfig
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
m68k                           sun3_defconfig
m68k                          multi_defconfig
m68k                       m5475evb_defconfig
m68k                             allmodconfig
riscv                              tinyconfig
i386                               tinyconfig

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
