Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20690 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932672AbeEUV1G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 17:27:06 -0400
Date: Tue, 22 May 2018 05:27:02 +0800
From: kbuild test robot <lkp@intel.com>
To: bingbu.cao@intel.com
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@linux.intel.com, rajmohan.mani@intel.com,
        mchehab@kernel.org
Subject: Re: [PATCH v2] media: imx319: Add imx319 camera sensor driver
Message-ID: <201805220310.AscHsDtA%fengguang.wu@intel.com>
References: <1526886658-14417-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526886658-14417-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bingbu,

I love your patch! Perhaps something to improve:

[auto build test WARNING on next-20180517]
[also build test WARNING on v4.17-rc6]
[cannot apply to linuxtv-media/master linus/master v4.17-rc6 v4.17-rc5 v4.17-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/bingbu-cao-intel-com/media-imx319-Add-imx319-camera-sensor-driver/20180522-020817


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/i2c/imx319.c:1874:2-3: Unneeded semicolon
   drivers/media/i2c/imx319.c:1917:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
