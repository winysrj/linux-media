Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbbA3C1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 21:27:21 -0500
Date: Fri, 30 Jan 2015 10:26:10 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Darren Etheridge <detheridge@ti.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [linuxtv-media:master 66/173]
 drivers/media/platform/am437x/am437x-vpfe.c:2767:3-8: No need to set .owner
 here. The core will do it.
Message-ID: <201501301005.asa6DlE9%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   a5f43c18fceb2b96ec9fddb4348f5282a71cf2b0
commit: 417d2e507edcb5cf15eb344f86bd3dd28737f24e [66/173] [media] media: platform: add VPFE capture driver support for AM437X


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/platform/am437x/am437x-vpfe.c:2767:3-8: No need to set .owner here. The core will do it.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
