Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34271 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029AbbJAO05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2015 10:26:57 -0400
Date: Thu, 1 Oct 2015 22:25:57 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: drivers/media/i2c/ml86v7667.c:430:3-8: No need to set .owner here.
 The core will do it.
Message-ID: <201510012253.SfwiqXQS%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   f97b870eced0ec562f953d32eda03906c7dacad6
commit: 5cc596c66fe7c725ec049ae2093e7242034c97d6 [media] i2c: Make all i2c devices visible if COMPILE_TEST=y
date:   7 weeks ago


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/i2c/ml86v7667.c:430:3-8: No need to set .owner here. The core will do it.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
