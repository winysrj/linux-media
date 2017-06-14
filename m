Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:61012 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdFNNry (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 09:47:54 -0400
Date: Wed, 14 Jun 2017 21:47:15 +0800
From: kbuild test robot <lkp@intel.com>
To: chiranjeevi.rapolu@intel.com
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, tfiga@chromium.org,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: Re: [PATCH v3 1/1] i2c: Add Omnivision OV5670 5M sensor support
Message-ID: <201706142129.jedNMTfn%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497404348-16255-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chiranjeevi,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.12-rc5 next-20170614]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/chiranjeevi-rapolu-intel-com/i2c-Add-Omnivision-OV5670-5M-sensor-support/20170614-195050
base:   git://linuxtv.org/media_tree.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/i2c/ov5670.c:2577:3-8: No need to set .owner here. The core will do it.
--
>> drivers/media/i2c/ov5670.c:2001:2-3: Unneeded semicolon
   drivers/media/i2c/ov5670.c:2033:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
