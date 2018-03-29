Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:37238 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750774AbeC2Fdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 01:33:49 -0400
Message-ID: <874lkz78j2.wl%kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: kbuild test robot <lkp@intel.com>
Cc: <kbuild-all@01.org>, Mark Brown <broonie@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: i2c: wm9090: replace codec to component
In-Reply-To: <201803291001.I8YzGJLc%fengguang.wu@intel.com>
References: <87370l560w.wl%kuninori.morimoto.gx@renesas.com>
        <201803291001.I8YzGJLc%fengguang.wu@intel.com>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
Date: Thu, 29 Mar 2018 05:33:43 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Thank you for this report.
I will post v2 patch, soon

kbuild test robot wrote:
> 
> [1  <text/plain; us-ascii (7bit)>]
> Hi Kuninori,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on next-20180328]
> [cannot apply to v4.16-rc7]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Kuninori-Morimoto/media-i2c-wm9090-replace-codec-to-component/20180329-082843
> base:   git://linuxtv.org/media_tree.git master
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/media/i2c/tda1997x.c:2494:12: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
>      .remove = tda1997x_codec_remove,
>                ^~~~~~~~~~~~~~~~~~~~~
>    drivers/media/i2c/tda1997x.c:2494:12: note: (near initialization for 'tda1997x_codec_driver.remove')
>    cc1: some warnings being treated as errors
> 
> vim +2494 drivers/media/i2c/tda1997x.c
> 
> 9ac0038d Tim Harvey        2018-02-15  2491  
> b534b135 Kuninori Morimoto 2018-03-28  2492  static struct snd_soc_component_driver tda1997x_codec_driver = {
> 9ac0038d Tim Harvey        2018-02-15  2493  	.probe = tda1997x_codec_probe,
> 9ac0038d Tim Harvey        2018-02-15 @2494  	.remove = tda1997x_codec_remove,
> b534b135 Kuninori Morimoto 2018-03-28  2495  	.idle_bias_on		= 1,
> b534b135 Kuninori Morimoto 2018-03-28  2496  	.use_pmdown_time	= 1,
> b534b135 Kuninori Morimoto 2018-03-28  2497  	.endianness		= 1,
> b534b135 Kuninori Morimoto 2018-03-28  2498  	.non_legacy_dai_naming	= 1,
> 9ac0038d Tim Harvey        2018-02-15  2499  };
> 9ac0038d Tim Harvey        2018-02-15  2500  
> 
> :::::: The code at line 2494 was first introduced by commit
> :::::: 9ac0038db9a7e10fc8f425010ec98b7afc2ff621 media: i2c: Add TDA1997x HDMI receiver driver
> 
> :::::: TO: Tim Harvey <tharvey@gateworks.com>
> :::::: CC: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> [2 .config.gz <application/gzip (base64)>]
> 
