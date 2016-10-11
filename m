Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31887 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752077AbcJKNXl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 09:23:41 -0400
Date: Tue, 11 Oct 2016 21:22:08 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        0day robot <fengguang.wu@intel.com>
Subject: [linux-review:Mauro-Carvalho-Chehab/Don-t-use-stack-for-DMA-transers-on-media-usb-drivers/20161011-182408
 22/31] drivers/media/usb/dvb-usb/pctv452e.c:115:2-3: Unneeded semicolon
Message-ID: <201610112102.ELbcEl2x%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://github.com/0day-ci/linux Mauro-Carvalho-Chehab/Don-t-use-stack-for-DMA-transers-on-media-usb-drivers/20161011-182408
head:   ff49f775552fe4ebe2944527cf882073679cb1e5
commit: 4bafb476079bf7e4aa258248cfa853f130c46c8c [22/31] pctv452e: don't call BUG_ON() on non-fatal error


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/usb/dvb-usb/pctv452e.c:115:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
