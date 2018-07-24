Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:34275 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388132AbeGXBN2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 21:13:28 -0400
From: "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com>
To: "'kbuild test robot'" <lkp@intel.com>
Cc: <kbuild-all@01.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        <linux-media@vger.kernel.org>,
        "Masami Hiramatsu" <masami.hiramatsu@linaro.org>,
        "Jassi Brar" <jaswinder.singh@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        =?iso-2022-jp?B?U3V6dWtpLCBLYXRzdWhpcm8vGyRCTmtMWhsoQiAbJEI+IUduGyhC?=
        <suzuki.katsuhiro@socionext.com>
References: <20180723085150.24266-1-suzuki.katsuhiro@socionext.com> <201807240508.gpMy7uIR%fengguang.wu@intel.com>
In-Reply-To: <201807240508.gpMy7uIR%fengguang.wu@intel.com>
Subject: Re: [PATCH v5] media: dvb-frontends: add Socionext MN88443x ISDB-S/T demodulator driver
Date: Tue, 24 Jul 2018 09:09:42 +0900
Message-ID: <000001d422e2$9f695260$de3bf720$@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Language: ja
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ugh, sorry. I'll fix it...

Regards,
--
Katsuhiro Suzuki


> -----Original Message-----
> From: kbuild test robot <lkp@intel.com>
> Sent: Tuesday, July 24, 2018 7:15 AM
> To: Suzuki, Katsuhiro/鈴木 勝博 <suzuki.katsuhiro@socionext.com>
> Cc: kbuild-all@01.org; Mauro Carvalho Chehab <mchehab+samsung@kernel.org>;
> linux-media@vger.kernel.org; Masami Hiramatsu <masami.hiramatsu@linaro.org>;
> Jassi Brar <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; Suzuki, Katsuhiro/鈴木 勝博
> <suzuki.katsuhiro@socionext.com>
> Subject: Re: [PATCH v5] media: dvb-frontends: add Socionext MN88443x ISDB-S/T
> demodulator driver
> 
> Hi Katsuhiro,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on v4.18-rc6 next-20180723]
> [if your patch is applied to the wrong git tree, please drop us a note to help
improve
> the system]
> 
> url:
> https://github.com/0day-ci/linux/commits/Katsuhiro-Suzuki/media-dvb-frontends-a
> dd-Socionext-MN88443x-ISDB-S-T-demodulator-driver/20180724-050011
> base:   git://linuxtv.org/media_tree.git master
> config: i386-randconfig-i1-201829 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/media/dvb-frontends/mn88443x.c:15:10: fatal error: sc1501a.h: No
such
> file or directory
>     #include "sc1501a.h"
>              ^~~~~~~~~~~
>    compilation terminated.
> 
> vim +15 drivers/media/dvb-frontends/mn88443x.c
> 
>     14
>   > 15	#include "sc1501a.h"
>     16
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
