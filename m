Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49461 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754414AbdCHU71 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 15:59:27 -0500
Date: Thu, 9 Mar 2017 04:57:10 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Rick Chang <rick.chang@mediatek.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Ricky Liang <jcliang@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [ragnatech:media-tree 1271/1281]
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1296:3-8: No need to set
 .owner here. The core will do it.
Message-ID: <201703090447.gKuj4400%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.ragnatech.se/linux media-tree
head:   700ea5e0e0dd70420a04e703ff264cc133834cba
commit: b2f0d2724ba477d326e9d654d4db1c93e98f8b93 [1271/1281] [media] vcodec: mediatek: Add Mediatek JPEG Decoder Driver


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1296:3-8: No need to set .owner here. The core will do it.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
