Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40181 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754473AbdA3V63 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 16:58:29 -0500
Date: Mon, 30 Jan 2017 21:58:26 +0000
From: Sean Young <sean@mess.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [linuxtv-media:master 1071/1091]
 arch/arm/mach-omap2/pdata-quirks.c:536:49: error: 'rx51_lirc_data'
 undeclared here (not in a function)
Message-ID: <20170130215826.GA20904@gofer.mess.org>
References: <201701310347.zJE5nRX4%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201701310347.zJE5nRX4%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 31, 2017 at 03:53:54AM +0800, kbuild test robot wrote:
> tree:   git://linuxtv.org/media_tree.git master
> head:   a052af2a548decf1da5cccf9e777aa02321e3ffb
> commit: a92def1becf33e91fc460c7ae575aa9210ba8f40 [1071/1091] [media] ir-rx51: port to rc-core
> config: arm-multi_v7_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout a92def1becf33e91fc460c7ae575aa9210ba8f40
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm 
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/arm/mach-omap2/pdata-quirks.c:15:0:
> >> arch/arm/mach-omap2/pdata-quirks.c:536:49: error: 'rx51_lirc_data' undeclared here (not in a function)
>      OF_DEV_AUXDATA("nokia,n900-ir", 0, "n900-ir", &rx51_lirc_data),
>                                                     ^
>    include/linux/of_platform.h:52:21: note: in definition of macro 'OF_DEV_AUXDATA'
>        .platform_data = _pdata }

Oh dear, that should have been rx51_ir_data. The patch below fixes it.


Sean

>From 7813bce59dca0eb7f9af1626fc9cd6ef1ddea9a5 Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Mon, 30 Jan 2017 19:58:19 +0000
Subject: [PATCH] [media] rx51: broken build

Since "a92def1 [media] ir-rx51: port to rc-core" the build fails on
some arm configurations.

Signed-off-by: Sean Young <sean@mess.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 9f06074..dc3b6c8 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -533,7 +533,7 @@ static struct of_dev_auxdata omap_auxdata_lookup[] __initdata = {
 		       &omap3_iommu_pdata),
 	OF_DEV_AUXDATA("ti,omap3-hsmmc", 0x4809c000, "4809c000.mmc", &mmc_pdata[0]),
 	OF_DEV_AUXDATA("ti,omap3-hsmmc", 0x480b4000, "480b4000.mmc", &mmc_pdata[1]),
-	OF_DEV_AUXDATA("nokia,n900-ir", 0, "n900-ir", &rx51_lirc_data),
+	OF_DEV_AUXDATA("nokia,n900-ir", 0, "n900-ir", &rx51_ir_data),
 	/* Only on am3517 */
 	OF_DEV_AUXDATA("ti,davinci_mdio", 0x5c030000, "davinci_mdio.0", NULL),
 	OF_DEV_AUXDATA("ti,am3517-emac", 0x5c000000, "davinci_emac.0",
-- 
2.9.3

