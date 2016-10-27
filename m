Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:11786 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942947AbcJ0Wfx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 18:35:53 -0400
Date: Fri, 28 Oct 2016 06:34:37 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [linux-next:master 1988/3208]
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c:284:3-8: No need to set .owner
 here. The core will do it.
Message-ID: <201610280623.yEQ4DZSc%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   58308d9377de18c554d801cb6ff4e0a4750da921
commit: c8eb2d7e8202fd9cb912f5d33cc34ede66dcb24a [1988/3208] [media] media: Add Mediatek MDP Driver


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/platform/mtk-mdp/mtk_mdp_core.c:284:3-8: No need to set .owner here. The core will do it.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
