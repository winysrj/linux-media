Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E485C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 18:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6244217D6
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 18:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfBESyx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 13:54:53 -0500
Received: from mga05.intel.com ([192.55.52.43]:34642 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbfBESyx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 13:54:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2019 10:54:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,336,1544515200"; 
   d="gz'50?scan'50,208,50";a="140925539"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 05 Feb 2019 10:54:50 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gr5ru-0005Ww-GG; Wed, 06 Feb 2019 02:54:50 +0800
Date:   Wed, 6 Feb 2019 02:54:11 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [linux-next:master 2650/6329]
 arch/sh/boards/mach-migor/setup.c:605:2: error: implicit declaration of
 function 'dma_declare_coherent_memory'
Message-ID: <201902060204.mKay0P61%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   1ff5403385648b1554fd1aeffffdeec71d9cd41c
commit: 386a35eb70569b3158392eb573fe42589a669da4 [2650/6329] media: tw9910.h: remove obsolete soc_camera.h include.
config: sh-migor_defconfig (attached as .config)
compiler: sh4-linux-gnu-gcc (Debian 8.2.0-11) 8.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 386a35eb70569b3158392eb573fe42589a669da4
        # save the attached .config to linux build tree
        GCC_VERSION=8.2.0 make.cross ARCH=sh 

All errors (new ones prefixed by >>):

   arch/sh/boards/mach-migor/setup.c: In function 'migor_devices_setup':
>> arch/sh/boards/mach-migor/setup.c:605:2: error: implicit declaration of function 'dma_declare_coherent_memory' [-Werror=implicit-function-declaration]
     dma_declare_coherent_memory(&migor_ceu_device.dev,
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/sh/boards/mach-migor/setup.c:608:9: error: 'DMA_MEMORY_EXCLUSIVE' undeclared (first use in this function); did you mean 'WQ_FLAG_EXCLUSIVE'?
            DMA_MEMORY_EXCLUSIVE);
            ^~~~~~~~~~~~~~~~~~~~
            WQ_FLAG_EXCLUSIVE
   arch/sh/boards/mach-migor/setup.c:608:9: note: each undeclared identifier is reported only once for each function it appears in
   cc1: some warnings being treated as errors

vim +/dma_declare_coherent_memory +605 arch/sh/boards/mach-migor/setup.c

91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  551  
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  552  	/* CEU */
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  553  	gpio_request(GPIO_FN_VIO_CLK2, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  554  	gpio_request(GPIO_FN_VIO_VD2, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  555  	gpio_request(GPIO_FN_VIO_HD2, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  556  	gpio_request(GPIO_FN_VIO_FLD, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  557  	gpio_request(GPIO_FN_VIO_CKO, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  558  	gpio_request(GPIO_FN_VIO_D15, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  559  	gpio_request(GPIO_FN_VIO_D14, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  560  	gpio_request(GPIO_FN_VIO_D13, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  561  	gpio_request(GPIO_FN_VIO_D12, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  562  	gpio_request(GPIO_FN_VIO_D11, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  563  	gpio_request(GPIO_FN_VIO_D10, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  564  	gpio_request(GPIO_FN_VIO_D9, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  565  	gpio_request(GPIO_FN_VIO_D8, NULL);
91b6f3c525 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2008-10-08  566  
9d56dd3b08 arch/sh/boards/mach-migor/setup.c    Paul Mundt            2010-01-26  567  	__raw_writew(__raw_readw(PORT_MSELCRB) | 0x2000, PORT_MSELCRB); /* D15->D8 */
1765534c23 arch/sh/boards/renesas/migor/setup.c Magnus Damm           2008-07-28  568  
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  569  	/* SIU: Port B */
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  570  	gpio_request(GPIO_FN_SIUBOLR, NULL);
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  571  	gpio_request(GPIO_FN_SIUBOBT, NULL);
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  572  	gpio_request(GPIO_FN_SIUBISLD, NULL);
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  573  	gpio_request(GPIO_FN_SIUBOSLD, NULL);
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  574  	gpio_request(GPIO_FN_SIUMCKB, NULL);
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  575  
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  576  	/*
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  577  	 * The original driver sets SIUB OLR/OBT, ILR/IBT, and SIUA OLR/OBT to
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  578  	 * output. Need only SIUB, set to output for master mode (table 34.2)
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  579  	 */
7d0b0a4434 arch/sh/boards/mach-migor/setup.c    Paul Mundt            2010-03-02  580  	__raw_writew(__raw_readw(PORT_MSELCRA) | 1, PORT_MSELCRA);
920925f90f arch/sh/boards/mach-migor/setup.c    Guennadi Liakhovetski 2010-01-19  581  
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  582  	 /*
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  583  	  * Use 10 MHz VIO_CKO instead of 24 MHz to work around signal quality
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  584  	  * issues on Panel Board V2.1.
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  585  	  */
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  586  	video_clk = clk_get(NULL, "video_clk");
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  587  	if (!IS_ERR(video_clk)) {
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  588  		clk_set_rate(video_clk, clk_round_rate(video_clk, 10000000));
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  589  		clk_put(video_clk);
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  590  	}
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  591  
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  592  	/* Add a clock alias for ov7725 xclk source. */
89ce93fd5b arch/sh/boards/mach-migor/setup.c    Akinobu Mita          2018-05-06  593  	clk_add_alias(NULL, "0-0021", "video_clk", NULL);
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  594  
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  595  	/* Register GPIOs for video sources. */
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  596  	gpiod_add_lookup_table(&ov7725_gpios);
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  597  	gpiod_add_lookup_table(&tw9910_gpios);
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  598  
0c6111eccc arch/sh/boards/renesas/migor/setup.c Magnus Damm           2008-03-25  599  	i2c_register_board_info(0, migor_i2c_devices,
0c6111eccc arch/sh/boards/renesas/migor/setup.c Magnus Damm           2008-03-25  600  				ARRAY_SIZE(migor_i2c_devices));
0c6111eccc arch/sh/boards/renesas/migor/setup.c Magnus Damm           2008-03-25  601  
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  602  	/* Initialize CEU platform device separately to map memory first */
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  603  	device_initialize(&migor_ceu_device.dev);
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  604  	arch_setup_pdev_archdata(&migor_ceu_device);
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21 @605  	dma_declare_coherent_memory(&migor_ceu_device.dev,
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  606  				    ceu_dma_membase, ceu_dma_membase,
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  607  				    ceu_dma_membase + CEU_BUFFER_MEMORY_SIZE - 1,
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21 @608  				    DMA_MEMORY_EXCLUSIVE);
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  609  
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  610  	platform_device_add(&migor_ceu_device);
186c446f4b arch/sh/boards/mach-migor/setup.c    Jacopo Mondi          2018-02-21  611  
70f784ec1d arch/sh/boards/renesas/migor/setup.c Magnus Damm           2008-02-07  612  	return platform_add_devices(migor_devices, ARRAY_SIZE(migor_devices));
70f784ec1d arch/sh/boards/renesas/migor/setup.c Magnus Damm           2008-02-07  613  }
ba3a170191 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2009-08-13  614  arch_initcall(migor_devices_setup);
0ec80fddf1 arch/sh/boards/mach-migor/setup.c    Magnus Damm           2009-06-03  615  

:::::: The code at line 605 was first introduced by commit
:::::: 186c446f4b840bd77b79d3dc951ca436cb8abe79 media: arch: sh: migor: Use new renesas-ceu camera driver

:::::: TO: Jacopo Mondi <jacopo+renesas@jmondi.org>
:::::: CC: Mauro Carvalho Chehab <mchehab@s-opensource.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--ZGiS0Q5IWpPtfppv
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--ZGiS0Q5IWpPtfppv--
