Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:56378 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751443AbeDBQfz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Apr 2018 12:35:55 -0400
Date: Tue, 3 Apr 2018 00:35:13 +0800
From: kbuild test robot <lkp@intel.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: kbuild-all@01.org, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Nicolas Pitre <nico@fluxnic.net>,
        Samuel Ortiz <samuel@sortiz.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 12/15] dmaengine: pxa: make the filter function internal
Message-ID: <201804030025.FmWPyArN%fengguang.wu@intel.com>
References: <20180402142656.26815-13-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180402142656.26815-13-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.16]
[cannot apply to arm-soc/for-next next-20180329]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Robert-Jarzmik/ARM-pxa-switch-to-DMA-slave-maps/20180402-233029
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/mtd/nand/marvell_nand.c:2621:17: sparse: undefined identifier 'pxad_filter_fn'
>> drivers/mtd/nand/marvell_nand.c:2621:17: sparse: call with no type!
   In file included from drivers/mtd/nand/marvell_nand.c:21:0:
   drivers/mtd/nand/marvell_nand.c: In function 'marvell_nfc_init_dma':
   drivers/mtd/nand/marvell_nand.c:2621:42: error: 'pxad_filter_fn' undeclared (first use in this function); did you mean 'dma_filter_fn'?
      dma_request_slave_channel_compat(mask, pxad_filter_fn,
                                             ^
   include/linux/dmaengine.h:1408:46: note: in definition of macro 'dma_request_slave_channel_compat'
     __dma_request_slave_channel_compat(&(mask), x, y, dev, name)
                                                 ^
   drivers/mtd/nand/marvell_nand.c:2621:42: note: each undeclared identifier is reported only once for each function it appears in
      dma_request_slave_channel_compat(mask, pxad_filter_fn,
                                             ^
   include/linux/dmaengine.h:1408:46: note: in definition of macro 'dma_request_slave_channel_compat'
     __dma_request_slave_channel_compat(&(mask), x, y, dev, name)
                                                 ^

vim +2621 drivers/mtd/nand/marvell_nand.c

02f26ecf Miquel Raynal 2018-01-09  2588  
02f26ecf Miquel Raynal 2018-01-09  2589  static int marvell_nfc_init_dma(struct marvell_nfc *nfc)
02f26ecf Miquel Raynal 2018-01-09  2590  {
02f26ecf Miquel Raynal 2018-01-09  2591  	struct platform_device *pdev = container_of(nfc->dev,
02f26ecf Miquel Raynal 2018-01-09  2592  						    struct platform_device,
02f26ecf Miquel Raynal 2018-01-09  2593  						    dev);
02f26ecf Miquel Raynal 2018-01-09  2594  	struct dma_slave_config config = {};
02f26ecf Miquel Raynal 2018-01-09  2595  	struct resource *r;
02f26ecf Miquel Raynal 2018-01-09  2596  	dma_cap_mask_t mask;
02f26ecf Miquel Raynal 2018-01-09  2597  	struct pxad_param param;
02f26ecf Miquel Raynal 2018-01-09  2598  	int ret;
02f26ecf Miquel Raynal 2018-01-09  2599  
02f26ecf Miquel Raynal 2018-01-09  2600  	if (!IS_ENABLED(CONFIG_PXA_DMA)) {
02f26ecf Miquel Raynal 2018-01-09  2601  		dev_warn(nfc->dev,
02f26ecf Miquel Raynal 2018-01-09  2602  			 "DMA not enabled in configuration\n");
02f26ecf Miquel Raynal 2018-01-09  2603  		return -ENOTSUPP;
02f26ecf Miquel Raynal 2018-01-09  2604  	}
02f26ecf Miquel Raynal 2018-01-09  2605  
02f26ecf Miquel Raynal 2018-01-09  2606  	ret = dma_set_mask_and_coherent(nfc->dev, DMA_BIT_MASK(32));
02f26ecf Miquel Raynal 2018-01-09  2607  	if (ret)
02f26ecf Miquel Raynal 2018-01-09  2608  		return ret;
02f26ecf Miquel Raynal 2018-01-09  2609  
02f26ecf Miquel Raynal 2018-01-09  2610  	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
02f26ecf Miquel Raynal 2018-01-09  2611  	if (!r) {
02f26ecf Miquel Raynal 2018-01-09  2612  		dev_err(nfc->dev, "No resource defined for data DMA\n");
02f26ecf Miquel Raynal 2018-01-09  2613  		return -ENXIO;
02f26ecf Miquel Raynal 2018-01-09  2614  	}
02f26ecf Miquel Raynal 2018-01-09  2615  
02f26ecf Miquel Raynal 2018-01-09  2616  	param.drcmr = r->start;
02f26ecf Miquel Raynal 2018-01-09  2617  	param.prio = PXAD_PRIO_LOWEST;
02f26ecf Miquel Raynal 2018-01-09  2618  	dma_cap_zero(mask);
02f26ecf Miquel Raynal 2018-01-09  2619  	dma_cap_set(DMA_SLAVE, mask);
02f26ecf Miquel Raynal 2018-01-09  2620  	nfc->dma_chan =
02f26ecf Miquel Raynal 2018-01-09 @2621  		dma_request_slave_channel_compat(mask, pxad_filter_fn,
02f26ecf Miquel Raynal 2018-01-09  2622  						 &param, nfc->dev,
02f26ecf Miquel Raynal 2018-01-09  2623  						 "data");
02f26ecf Miquel Raynal 2018-01-09  2624  	if (!nfc->dma_chan) {
02f26ecf Miquel Raynal 2018-01-09  2625  		dev_err(nfc->dev,
02f26ecf Miquel Raynal 2018-01-09  2626  			"Unable to request data DMA channel\n");
02f26ecf Miquel Raynal 2018-01-09  2627  		return -ENODEV;
02f26ecf Miquel Raynal 2018-01-09  2628  	}
02f26ecf Miquel Raynal 2018-01-09  2629  
02f26ecf Miquel Raynal 2018-01-09  2630  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
02f26ecf Miquel Raynal 2018-01-09  2631  	if (!r)
02f26ecf Miquel Raynal 2018-01-09  2632  		return -ENXIO;
02f26ecf Miquel Raynal 2018-01-09  2633  
02f26ecf Miquel Raynal 2018-01-09  2634  	config.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
02f26ecf Miquel Raynal 2018-01-09  2635  	config.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
02f26ecf Miquel Raynal 2018-01-09  2636  	config.src_addr = r->start + NDDB;
02f26ecf Miquel Raynal 2018-01-09  2637  	config.dst_addr = r->start + NDDB;
02f26ecf Miquel Raynal 2018-01-09  2638  	config.src_maxburst = 32;
02f26ecf Miquel Raynal 2018-01-09  2639  	config.dst_maxburst = 32;
02f26ecf Miquel Raynal 2018-01-09  2640  	ret = dmaengine_slave_config(nfc->dma_chan, &config);
02f26ecf Miquel Raynal 2018-01-09  2641  	if (ret < 0) {
02f26ecf Miquel Raynal 2018-01-09  2642  		dev_err(nfc->dev, "Failed to configure DMA channel\n");
02f26ecf Miquel Raynal 2018-01-09  2643  		return ret;
02f26ecf Miquel Raynal 2018-01-09  2644  	}
02f26ecf Miquel Raynal 2018-01-09  2645  
02f26ecf Miquel Raynal 2018-01-09  2646  	/*
02f26ecf Miquel Raynal 2018-01-09  2647  	 * DMA must act on length multiple of 32 and this length may be
02f26ecf Miquel Raynal 2018-01-09  2648  	 * bigger than the destination buffer. Use this buffer instead
02f26ecf Miquel Raynal 2018-01-09  2649  	 * for DMA transfers and then copy the desired amount of data to
02f26ecf Miquel Raynal 2018-01-09  2650  	 * the provided buffer.
02f26ecf Miquel Raynal 2018-01-09  2651  	 */
c495a927 Miquel Raynal 2018-01-19  2652  	nfc->dma_buf = kmalloc(MAX_CHUNK_SIZE, GFP_KERNEL | GFP_DMA);
02f26ecf Miquel Raynal 2018-01-09  2653  	if (!nfc->dma_buf)
02f26ecf Miquel Raynal 2018-01-09  2654  		return -ENOMEM;
02f26ecf Miquel Raynal 2018-01-09  2655  
02f26ecf Miquel Raynal 2018-01-09  2656  	nfc->use_dma = true;
02f26ecf Miquel Raynal 2018-01-09  2657  
02f26ecf Miquel Raynal 2018-01-09  2658  	return 0;
02f26ecf Miquel Raynal 2018-01-09  2659  }
02f26ecf Miquel Raynal 2018-01-09  2660  

:::::: The code at line 2621 was first introduced by commit
:::::: 02f26ecf8c772751d4b24744d487f6b1b20e75d4 mtd: nand: add reworked Marvell NAND controller driver

:::::: TO: Miquel Raynal <miquel.raynal@free-electrons.com>
:::::: CC: Boris Brezillon <boris.brezillon@free-electrons.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
