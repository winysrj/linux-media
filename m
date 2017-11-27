Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:60179 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751237AbdK0J00 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 04:26:26 -0500
Date: Mon, 27 Nov 2017 17:25:29 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: drivers/media/dvb-core/dvb_frontend.c:154:2-7: WARNING: NULL check
 before freeing functions like kfree, debugfs_remove,
 debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider
 reorganizing relevant code to avoid passing NULL values.
Message-ID: <201711271722.IU7xlxg2%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323
commit: b1cb7372fa822af6c06c8045963571d13ad6348b dvb_frontend: don't use-after-free the frontend struct
date:   3 weeks ago


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/dvb-core/dvb_frontend.c:154:2-7: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
