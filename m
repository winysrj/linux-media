Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:55247 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754247AbeDKVPP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 17:15:15 -0400
Date: Thu, 12 Apr 2018 05:14:39 +0800
From: kbuild test robot <lkp@intel.com>
To: Ryder Lee <ryder.lee@mediatek.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1087:1-3: WARNING:
 PTR_ERR_OR_ZERO can be used
Message-ID: <201804120528.xhFwZKle%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   8837c70d531a1788f975c366c254a5cb973a5291
commit: 648a9576932a26e1c6a157b4c9345204de975957 media: vcodec: fix error return value from mtk_jpeg_clk_init()
date:   7 days ago


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1087:1-3: WARNING: PTR_ERR_OR_ZERO can be used

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
