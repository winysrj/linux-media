Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:12902 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728913AbeGYTJy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 15:09:54 -0400
Date: Thu, 26 Jul 2018 01:56:59 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: drivers/video/fbdev/omap2/omapfb/omapfb-main.c:290:9-10: WARNING:
 return of 0/1 in function 'cmp_var_to_colormode' with return type bool
Message-ID: <201807260144.q4WK2PMA%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   9981b4fb8684883dcc0daf088891ff32260b9794
commit: 7378f1149884b183631c6c16c0f1c62bcd7d759d media: omap2: omapfb: allow building it with COMPILE_TEST
date:   3 months ago


coccinelle warnings: (new ones prefixed by >>)

>> drivers/video/fbdev/omap2/omapfb/omapfb-main.c:290:9-10: WARNING: return of 0/1 in function 'cmp_var_to_colormode' with return type bool
--
>> drivers/video/fbdev/omap2/omapfb/dss/dss_features.c:895:2-5: WARNING: Use BUG_ON instead of if condition followed by BUG.
   Please make sure the condition has no side effects (see conditional BUG_ON definition in include/asm-generic/bug.h)
--
>> drivers/video/fbdev/omap2/omapfb/dss/core.c:141:2-26: WARNING: NULL check before some freeing functions is not needed.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
