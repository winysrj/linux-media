Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:2365 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752524AbeESQxz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 May 2018 12:53:55 -0400
Date: Sun, 20 May 2018 00:53:38 +0800
From: kbuild test robot <lkp@intel.com>
To: bingbu.cao@intel.com
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@linux.intel.com, rajmohan.mani@intel.com,
        mchehab@kernel.org
Subject: Re: [PATCH] media: imx319: Add imx319 camera sensor driver
Message-ID: <201805200038.956SLTlo%fengguang.wu@intel.com>
References: <1526529744-25446-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526529744-25446-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bingbu,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.17-rc5 next-20180517]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/bingbu-cao-intel-com/media-imx319-Add-imx319-camera-sensor-driver/20180519-213616
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/i2c/imx319.c:219:24: sparse: symbol 'imx319_global_setting' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
