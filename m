Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35646 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbdJFKqs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Oct 2017 06:46:48 -0400
Subject: Re: [PATCH v2 1/2] staging: Introduce NVIDIA Tegra20 video decoder
 driver
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org
References: <201710061105.oOGaoiDu%fengguang.wu@intel.com>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <b9023559-b41a-9cbb-c0da-b95e3aff5b6f@gmail.com>
Date: Fri, 6 Oct 2017 13:46:42 +0300
MIME-Version: 1.0
In-Reply-To: <201710061105.oOGaoiDu%fengguang.wu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.10.2017 06:57, kbuild test robot wrote:
> Hi Dmitry,
> 
> [auto build test WARNING on staging/staging-testing]
> [also build test WARNING on v4.14-rc3 next-20170929]
> [cannot apply to tegra/for-next]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Dmitry-Osipenko/staging-Introduce-NVIDIA-Tegra20-video-decoder-driver/20171006-101015
> config: ia64-allmodconfig (attached as .config)
> compiler: ia64-linux-gcc (GCC) 6.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=ia64 
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/kernel.h:13:0,
>                     from include/linux/clk.h:16,
>                     from drivers/staging/tegra-vde/vde.c:11:
>    drivers/staging/tegra-vde/vde.c: In function 'tegra_vde_setup_hw_context':
>>> drivers/staging/tegra-vde/vde.c:51:11: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'long long unsigned int' [-Wformat=]
>      pr_debug("%s: %d: 0x%08X => " #__addr ")\n", \
>               ^
>    include/linux/printk.h:285:21: note: in definition of macro 'pr_fmt'
>     #define pr_fmt(fmt) fmt
>                         ^~~
>    include/linux/printk.h:333:2: note: in expansion of macro 'dynamic_pr_debug'
>      dynamic_pr_debug(fmt, ##__VA_ARGS__)
>      ^~~~~~~~~~~~~~~~
>    drivers/staging/tegra-vde/vde.c:51:2: note: in expansion of macro 'pr_debug'
>      pr_debug("%s: %d: 0x%08X => " #__addr ")\n", \
>      ^~~~~~~~
>    drivers/staging/tegra-vde/vde.c:362:2: note: in expansion of macro 'VDE_WR'
>      VDE_WR(bitstream_data_paddr + bitstream_data_size,
>      ^~~~~~
>>> drivers/staging/tegra-vde/vde.c:51:11: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'phys_addr_t {aka long long unsigned int}' [-Wformat=]
>      pr_debug("%s: %d: 0x%08X => " #__addr ")\n", \
>               ^
>    include/linux/printk.h:285:21: note: in definition of macro 'pr_fmt'
>     #define pr_fmt(fmt) fmt
>                         ^~~
>    include/linux/printk.h:333:2: note: in expansion of macro 'dynamic_pr_debug'
>      dynamic_pr_debug(fmt, ##__VA_ARGS__)
>      ^~~~~~~~~~~~~~~~
>    drivers/staging/tegra-vde/vde.c:51:2: note: in expansion of macro 'pr_debug'
>      pr_debug("%s: %d: 0x%08X => " #__addr ")\n", \
>      ^~~~~~~~
>    drivers/staging/tegra-vde/vde.c:435:2: note: in expansion of macro 'VDE_WR'
>      VDE_WR(bitstream_data_paddr, vde->regs + SXE(0x6C));
>      ^~~~~~
>    drivers/staging/tegra-vde/vde.c: In function 'tegra_vde_attach_dmabuf':
>    drivers/staging/tegra-vde/vde.c:531:40: warning: format '%d' expects argument of type 'int', but argument 3 has type 'size_t {aka long unsigned int}' [-Wformat=]
>       dev_err(dev, "Too small dmabuf size %d @0x%lX, "
>                                            ^
>    drivers/staging/tegra-vde/vde.c: In function 'tegra_vde_ioctl_decode_h264':
>    drivers/staging/tegra-vde/vde.c:855:16: warning: format '%X' expects argument of type 'unsigned int', but argument 3 has type 'phys_addr_t {aka long long unsigned int}' [-Wformat=]
>       dev_err(dev, "Decoding failed, "
>                    ^~~~~~~~~~~~~~~~~~~
> 
> vim +51 drivers/staging/tegra-vde/vde.c
> 
>   > 11	#include <linux/clk.h>
>     12	#include <linux/delay.h>
>     13	#include <linux/dma-buf.h>
>     14	#include <linux/interrupt.h>
>     15	#include <linux/io.h>
>     16	#include <linux/iopoll.h>
>     17	#include <linux/miscdevice.h>
>     18	#include <linux/module.h>
>     19	#include <linux/platform_device.h>
>     20	#include <linux/pm_runtime.h>
>     21	#include <linux/reset.h>
>     22	#include <linux/slab.h>
>     23	#include <linux/uaccess.h>
>     24	
>     25	#include <soc/tegra/pmc.h>
>     26	
>     27	#include "uapi.h"
>     28	
>     29	#define SXE(offt)		(0x0000 + (offt)) /* Syntax Engine */
>     30	#define BSEV(offt)		(0x1000 + (offt)) /* Video Bitstream Engine */
>     31	#define MBE(offt)		(0x2000 + (offt)) /* Macroblock Engine */
>     32	#define PPE(offt)		(0x2200 + (offt)) /* Post-processing Engine */
>     33	#define MCE(offt)		(0x2400 + (offt)) /* Motion Compensation Eng. */
>     34	#define TFE(offt)		(0x2600 + (offt)) /* Transform Engine */
>     35	#define VDMA(offt)		(0x2A00 + (offt)) /* Video DMA */
>     36	#define FRAMEID(offt)		(0x3800 + (offt))
>     37	
>     38	#define ICMDQUE_WR		0x00
>     39	#define CMDQUE_CONTROL		0x08
>     40	#define INTR_STATUS		0x18
>     41	#define BSE_INT_ENB		0x40
>     42	#define BSE_CONFIG		0x44
>     43	
>     44	#define BSE_ICMDQUE_EMPTY	BIT(3)
>     45	#define BSE_DMA_BUSY		BIT(23)
>     46	
>     47	#define TEGRA_VDE_TIMEOUT	msecs_to_jiffies(1000)
>     48	
>     49	#define VDE_WR(__data, __addr)				\
>     50	do {							\
>   > 51		pr_debug("%s: %d: 0x%08X => " #__addr ")\n",	\
>     52			  __func__, __LINE__, (__data));	\
>     53		writel_relaxed(__data, __addr);			\
>     54	} while (0)
>     55	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

I'll silence these warnings in v3.
