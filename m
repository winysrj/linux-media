Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50924 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbdKVHwF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 02:52:05 -0500
Subject: Re: [PATCH] media: mtk-vcodec: add missing MODULE_LICENSE/DESCRIPTION
To: kbuild test robot <lkp@intel.com>, Jesse Chan <jc@linux.com>
Cc: kbuild-all@01.org, Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20171120062607.124734-1-jc@linux.com>
 <201711221521.lmq1l8ci%fengguang.wu@intel.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <835d88de-989e-03c7-e647-819f8f200f1b@infradead.org>
Date: Tue, 21 Nov 2017 23:51:57 -0800
MIME-Version: 1.0
In-Reply-To: <201711221521.lmq1l8ci%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/21/17 23:41, kbuild test robot wrote:
> Hi Jesse,
> 
> Thank you for the patch! Yet something to improve:

missing
#include <linux/module.h>

Jesse, did you build all of these driver changes?


> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on v4.14 next-20171121]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Jesse-Chan/media-mtk-vcodec-add-missing-MODULE_LICENSE-DESCRIPTION/20171122-124620
> base:   git://linuxtv.org/media_tree.git master
> config: xtensa-allmodconfig (attached as .config)
> compiler: xtensa-linux-gcc (GCC) 4.9.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=xtensa 
> 
> All errors (new ones prefixed by >>):
> 
>>> drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c:55:16: error: expected declaration specifiers or '...' before string constant
>     MODULE_LICENSE("GPL v2");
>                    ^
>    drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c:56:20: error: expected declaration specifiers or '...' before string constant
>     MODULE_DESCRIPTION("Mediatek video codec driver");
>                        ^
> 
> vim +55 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
> 
>     54	
>   > 55	MODULE_LICENSE("GPL v2");
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 


-- 
~Randy
