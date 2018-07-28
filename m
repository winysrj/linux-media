Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28738 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731024AbeG1XwO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Jul 2018 19:52:14 -0400
Date: Sun, 29 Jul 2018 06:24:05 +0800
From: kbuild test robot <lkp@intel.com>
To: Sean Young <sean@mess.org>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Matthias Reichl <hias@horus.com>
Subject: Re: [PATCH] media: rc: read out of bounds if bpf reports high
 protocol number
Message-ID: <201807290603.OICyWNqi%fengguang.wu@intel.com>
References: <20180728091115.16971-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180728091115.16971-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.18-rc6 next-20180727]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sean-Young/media-rc-read-out-of-bounds-if-bpf-reports-high-protocol-number/20180729-035942
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/rc/rc-main.c:682:14: sparse: symbol 'repeat_period' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
