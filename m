Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4400 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752557AbeC0PSx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 11:18:53 -0400
Date: Tue, 27 Mar 2018 23:18:11 +0800
From: kbuild test robot <lkp@intel.com>
To: tskd08@gmail.com
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: Re: [PATCH v3 3/5] dvb-usb/friio, dvb-usb-v2/gl861: decompose friio
Message-ID: <201803272324.AviPXumn%fengguang.wu@intel.com>
References: <20180326180652.5385-4-tskd08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326180652.5385-4-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akihiro,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.16-rc7 next-20180327]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/tskd08-gmail-com/dvb-frontends-dvb-pll-add-i2c-driver-support/20180327-194533
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/usb/dvb-usb-v2/gl861.c:575:34: sparse: symbol 'friio_props' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
