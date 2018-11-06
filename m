Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58283 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730358AbeKFU7C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 15:59:02 -0500
Date: Tue, 6 Nov 2018 19:33:19 +0800
From: kbuild test robot <lkp@intel.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: drivers/staging/media/sunxi/cedrus/cedrus.c:421:3-8: No need to set
 .owner here. The core will do it.
Message-ID: <201811061917.7LMfScZW%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   163c8d54a997153ee1a1e07fcac087492ad85b37
commit: 50e761516f2b8c0cdeb31a8c6ca1b4ef98cd13f1 media: platform: Add Cedrus VPU decoder driver
date:   6 weeks ago


coccinelle warnings: (new ones prefixed by >>)

>> drivers/staging/media/sunxi/cedrus/cedrus.c:421:3-8: No need to set .owner here. The core will do it.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
