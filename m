Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:26450 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390357AbeKVJbh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 04:31:37 -0500
Date: Thu, 22 Nov 2018 06:54:14 +0800
From: kbuild test robot <lkp@intel.com>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: kbuild-all@01.org, sakari.ailus@linux.intel.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: Re: [PATCH v8 04/12] media: staging/imx7: add MIPI CSI-2 receiver
 subdev for i.MX7
Message-ID: <201811220609.MIVjrYZv%fengguang.wu@intel.com>
References: <20181121111558.10838-5-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121111558.10838-5-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rui,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.20-rc3 next-20181121]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Rui-Miguel-Silva/media-staging-imx7-add-i-MX7-media-driver/20181122-024200
base:   git://linuxtv.org/media_tree.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/staging/media/imx/imx7-mipi-csis.c:1125:3-8: No need to set .owner here. The core will do it.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
