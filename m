Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48768 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422800AbdEXN6y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 09:58:54 -0400
Date: Wed, 24 May 2017 21:58:49 +0800
From: kbuild test robot <lkp@intel.com>
To: Hyungwoo Yang <hyungwoo.yang@intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        hyungwoo.yang@intel.com
Subject: Re: [PATCH 1/1] [media] i2c: add support for OV13858 sensor
Message-ID: <201705242154.G3cmvxX9%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495583908-2479-1-git-send-email-hyungwoo.yang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hyungwoo,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.12-rc2 next-20170524]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hyungwoo-Yang/i2c-add-support-for-OV13858-sensor/20170524-201204
base:   git://linuxtv.org/media_tree.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/i2c/ov13858.c:1838:3-8: No need to set .owner here. The core will do it.
--
>> drivers/media/i2c/ov13858.c:1319:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
