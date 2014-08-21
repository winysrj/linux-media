Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:18533 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbaHUW2H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 18:28:07 -0400
Date: Fri, 22 Aug 2014 06:26:39 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 499/499] drivers/built-in.o:(.bss+0xc7ee2c): multiple definition of `debug'
Message-ID: <53f6721f.dF2Vb824H5VHU+SC%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   2558eeda5cd75649a1159aadca530a990b81c4ee
commit: 2558eeda5cd75649a1159aadca530a990b81c4ee [499/499] [media] enable COMPILE_TEST for media drivers
config: make ARCH=i386 allyesconfig

All error/warnings:

>> drivers/built-in.o:(.bss+0xc7ee2c): multiple definition of `debug'
   arch/x86/built-in.o:(.entry.text+0xf78): first defined here
   ld: Warning: size of symbol `debug' changed from 86 in arch/x86/built-in.o to 4 in drivers/built-in.o

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
