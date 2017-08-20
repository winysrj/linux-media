Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:15115 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752079AbdHTOR4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 10:17:56 -0400
Date: Sun, 20 Aug 2017 22:17:15 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Daniel Scheller <d.scheller@gmx.net>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [linuxtv-media:master 2274/2287]
 drivers/media/pci/ddbridge/ddbridge-maxs8.c:145:2-3: Unneeded semicolon
Message-ID: <201708202213.dNCnn2oJ%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   4fd67c4f282d1b076a0367a15425877f33b2fc56
commit: a43dbe430fb4177ba9960dd9fe47df15c3757939 [2274/2287] media: ddbridge: support MaxLinear MXL5xx based cards (MaxS4/8)


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/pci/ddbridge/ddbridge-maxs8.c:145:2-3: Unneeded semicolon
   drivers/media/pci/ddbridge/ddbridge-maxs8.c:173:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
