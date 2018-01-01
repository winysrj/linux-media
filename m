Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56869 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751315AbeAASBv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Jan 2018 13:01:51 -0500
Date: Tue, 2 Jan 2018 02:01:18 +0800
From: kbuild test robot <lkp@intel.com>
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: kbuild-all@01.org, mturquette@baylibre.com, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        uclinux-h8-devel@lists.sourceforge.jp, linux-mips@linux-mips.org,
        linux-samsung-soc@vger.kernel.org, patches@opensource.cirrus.com,
        linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
        linux-rtc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-tegra@vger.kernel.org,
        pure.logic@nexus-software.ie, linux-omap@vger.kernel.org,
        linux-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 01/33] clk_ops: change round_rate() to return unsigned
 long
Message-ID: <201801020112.PEMNifTo%fengguang.wu@intel.com>
References: <1514596392-22270-2-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514596392-22270-2-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

I love your patch! Perhaps something to improve:

[auto build test WARNING on tegra/for-next]
[also build test WARNING on v4.15-rc6]
[cannot apply to clk/clk-next next-20171222]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Bryan-O-Donoghue/change-clk_ops-round_rate-to-scale-past-LONG_MAX/20180101-212907
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tegra/linux.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


vim +321 drivers/clk/clk-versaclock5.c

8c1ebe97 Marek Vasut 2017-07-09  318  
8c1ebe97 Marek Vasut 2017-07-09  319  static const struct clk_ops vc5_dbl_ops = {
8c1ebe97 Marek Vasut 2017-07-09  320  	.recalc_rate	= vc5_dbl_recalc_rate,
8c1ebe97 Marek Vasut 2017-07-09 @321  	.round_rate	= vc5_dbl_round_rate,
8c1ebe97 Marek Vasut 2017-07-09  322  	.set_rate	= vc5_dbl_set_rate,
8c1ebe97 Marek Vasut 2017-07-09  323  };
8c1ebe97 Marek Vasut 2017-07-09  324  

:::::: The code at line 321 was first introduced by commit
:::::: 8c1ebe9762670159ca982167131af63c94ff1571 clk: vc5: Add support for the input frequency doubler

:::::: TO: Marek Vasut <marek.vasut@gmail.com>
:::::: CC: Stephen Boyd <sboyd@codeaurora.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
