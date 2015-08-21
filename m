Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53236 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbbHUUMj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 16:12:39 -0400
Date: Sat, 22 Aug 2015 04:12:20 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [linux-next:master 7080/10086]
 drivers/media/i2c/tc358743.c:1960:3-8: No need to set .owner here. The core
 will do it.
Message-ID: <201508220418.EFXIwRR6%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   1ef981bcd18de26dc78bc79f092d6f4bb25e0e8f
commit: 5cc596c66fe7c725ec049ae2093e7242034c97d6 [7080/10086] [media] i2c: Make all i2c devices visible if COMPILE_TEST=y


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/i2c/tc358743.c:1960:3-8: No need to set .owner here. The core will do it.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
