Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29764 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751266AbdG3GcE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 02:32:04 -0400
Date: Sun, 30 Jul 2017 14:31:51 +0800
From: kbuild test robot <lkp@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: Re: [PATCH 5/6 v5] uvcvideo: send a control event when a Control
 Change interrupt arrives
Message-ID: <201707301426.vKSguE4n%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1501245205-15802-6-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.13-rc2 next-20170728]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Guennadi-Liakhovetski/UVC-fix-queue_setup-to-check-the-number-of-planes/20170730-123108
base:   git://linuxtv.org/media_tree.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/usb/uvc/uvc_ctrl.c:1327:2-7: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
