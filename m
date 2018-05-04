Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:34568 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbeEDGpB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 02:45:01 -0400
Date: Fri, 4 May 2018 14:44:52 +0800
From: kbuild test robot <lkp@intel.com>
To: Jan Luebbe <jlu@pengutronix.de>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Jan Luebbe <jlu@pengutronix.de>, slongerbeam@gmail.com,
        p.zabel@pengutronix.de
Subject: Re: [PATCH 2/2] media: imx: add support for RGB565_2X8 on parallel
 bus
Message-ID: <201805041448.Ykn27Qt9%fengguang.wu@intel.com>
References: <20180503164120.9912-3-jlu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503164120.9912-3-jlu@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.17-rc3 next-20180503]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jan-Luebbe/media-imx-add-capture-support-for-RGB565_2X8-on-parallel-bus/20180504-120003
base:   git://linuxtv.org/media_tree.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/staging/media/imx/imx-media-csi.c:443:3-4: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
