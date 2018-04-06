Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:39717 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754439AbeDFOxh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:53:37 -0400
Date: Fri, 6 Apr 2018 22:52:45 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 09/19] media: marvel-ccic: re-enable mmp-driver build
Message-ID: <201804062253.cAiGg4gJ%fengguang.wu@intel.com>
References: <829f94562d39e7d1a81c760e7615682c3038177c.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <829f94562d39e7d1a81c760e7615682c3038177c.1522959716.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.16 next-20180406]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/Make-all-media-drivers-build-with-COMPILE_TEST/20180406-163048
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/platform/marvell-ccic/mmp-driver.c:135:41: sparse: incorrect type in argument 2 (different address spaces) @@    expected void [noderef] <asn:2>*<noident> @@    got sn:2>*<noident> @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:135:41:    expected void [noderef] <asn:2>*<noident>
   drivers/media/platform/marvell-ccic/mmp-driver.c:135:41:    got void *
   drivers/media/platform/marvell-ccic/mmp-driver.c:136:44: sparse: incorrect type in argument 2 (different address spaces) @@    expected void [noderef] <asn:2>*<noident> @@    got sn:2>*<noident> @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:136:44:    expected void [noderef] <asn:2>*<noident>
   drivers/media/platform/marvell-ccic/mmp-driver.c:136:44:    got void *
   drivers/media/platform/marvell-ccic/mmp-driver.c:174:38: sparse: incorrect type in argument 2 (different address spaces) @@    expected void [noderef] <asn:2>*<noident> @@    got sn:2>*<noident> @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:174:38:    expected void [noderef] <asn:2>*<noident>
   drivers/media/platform/marvell-ccic/mmp-driver.c:174:38:    got void *
   drivers/media/platform/marvell-ccic/mmp-driver.c:175:38: sparse: incorrect type in argument 2 (different address spaces) @@    expected void [noderef] <asn:2>*<noident> @@    got sn:2>*<noident> @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:175:38:    expected void [noderef] <asn:2>*<noident>
   drivers/media/platform/marvell-ccic/mmp-driver.c:175:38:    got void *
   drivers/media/platform/marvell-ccic/mmp-driver.c:195:48: sparse: incorrect type in argument 1 (different address spaces) @@    expected void [noderef] <asn:2>*<noident> @@    got sn:2>*<noident> @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:195:48:    expected void [noderef] <asn:2>*<noident>
   drivers/media/platform/marvell-ccic/mmp-driver.c:195:48:    got void *
   drivers/media/platform/marvell-ccic/mmp-driver.c:196:55: sparse: incorrect type in argument 2 (different address spaces) @@    expected void [noderef] <asn:2>*<noident> @@    got sn:2>*<noident> @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:196:55:    expected void [noderef] <asn:2>*<noident>
   drivers/media/platform/marvell-ccic/mmp-driver.c:196:55:    got void *
   drivers/media/platform/marvell-ccic/mmp-driver.c:197:54: sparse: incorrect type in argument 2 (different address spaces) @@    expected void [noderef] <asn:2>*<noident> @@    got sn:2>*<noident> @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:197:54:    expected void [noderef] <asn:2>*<noident>
   drivers/media/platform/marvell-ccic/mmp-driver.c:197:54:    got void *
   drivers/media/platform/marvell-ccic/mmp-driver.c:202:48: sparse: incorrect type in argument 1 (different address spaces) @@    expected void [noderef] <asn:2>*<noident> @@    got sn:2>*<noident> @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:202:48:    expected void [noderef] <asn:2>*<noident>
   drivers/media/platform/marvell-ccic/mmp-driver.c:202:48:    got void *
   drivers/media/platform/marvell-ccic/mmp-driver.c:203:55: sparse: incorrect type in argument 2 (different address spaces) @@    expected void [noderef] <asn:2>*<noident> @@    got sn:2>*<noident> @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:203:55:    expected void [noderef] <asn:2>*<noident>
   drivers/media/platform/marvell-ccic/mmp-driver.c:203:55:    got void *
   drivers/media/platform/marvell-ccic/mmp-driver.c:204:54: sparse: incorrect type in argument 2 (different address spaces) @@    expected void [noderef] <asn:2>*<noident> @@    got sn:2>*<noident> @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:204:54:    expected void [noderef] <asn:2>*<noident>
   drivers/media/platform/marvell-ccic/mmp-driver.c:204:54:    got void *
   drivers/media/platform/marvell-ccic/mmp-driver.c:186:6: sparse: symbol 'mcam_ctlr_reset' was not declared. Should it be static?
   drivers/media/platform/marvell-ccic/mmp-driver.c:217:6: sparse: symbol 'mmpcam_calc_dphy' was not declared. Should it be static?
>> drivers/media/platform/marvell-ccic/mmp-driver.c:389:25: sparse: incorrect type in assignment (different address spaces) @@    expected void *power_regs @@    got void [noderef] <avoid *power_regs @@
   drivers/media/platform/marvell-ccic/mmp-driver.c:389:25:    expected void *power_regs
   drivers/media/platform/marvell-ccic/mmp-driver.c:389:25:    got void [noderef] <asn:2>*

vim +135 drivers/media/platform/marvell-ccic/mmp-driver.c

0e394f44f drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  129  
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  130  /*
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  131   * Power control.
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  132   */
4a0abfaa9 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2012-03-16  133  static void mmpcam_power_up_ctlr(struct mmp_camera *cam)
4a0abfaa9 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2012-03-16  134  {
4a0abfaa9 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2012-03-16 @135  	iowrite32(0x3f, cam->power_regs + REG_CCIC_DCGCR);
4a0abfaa9 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2012-03-16  136  	iowrite32(0x3805b, cam->power_regs + REG_CCIC_CRCR);
4a0abfaa9 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2012-03-16  137  	mdelay(1);
4a0abfaa9 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2012-03-16  138  }
4a0abfaa9 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2012-03-16  139  
05fed8162 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  140  static int mmpcam_power_up(struct mcam_camera *mcam)
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  141  {
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  142  	struct mmp_camera *cam = mcam_to_cam(mcam);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  143  	struct mmp_camera_platform_data *pdata;
05fed8162 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  144  
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  145  /*
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  146   * Turn on power and clocks to the controller.
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  147   */
4a0abfaa9 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2012-03-16  148  	mmpcam_power_up_ctlr(cam);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  149  /*
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  150   * Provide power to the sensor.
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  151   */
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  152  	mcam_reg_write(mcam, REG_CLKCTRL, 0x60000002);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  153  	pdata = cam->pdev->dev.platform_data;
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  154  	gpio_set_value(pdata->sensor_power_gpio, 1);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  155  	mdelay(5);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  156  	mcam_reg_clear_bit(mcam, REG_CTRL1, 0x10000000);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  157  	gpio_set_value(pdata->sensor_reset_gpio, 0); /* reset is active low */
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  158  	mdelay(5);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  159  	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  160  	mdelay(5);
0e394f44f drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  161  
0e394f44f drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  162  	mcam_clk_enable(mcam);
0e394f44f drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  163  
05fed8162 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  164  	return 0;
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  165  }
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  166  
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  167  static void mmpcam_power_down(struct mcam_camera *mcam)
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  168  {
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  169  	struct mmp_camera *cam = mcam_to_cam(mcam);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  170  	struct mmp_camera_platform_data *pdata;
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  171  /*
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  172   * Turn off clocks and set reset lines
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  173   */
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  174  	iowrite32(0, cam->power_regs + REG_CCIC_DCGCR);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  175  	iowrite32(0, cam->power_regs + REG_CCIC_CRCR);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  176  /*
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  177   * Shut down the sensor.
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  178   */
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  179  	pdata = cam->pdev->dev.platform_data;
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  180  	gpio_set_value(pdata->sensor_power_gpio, 0);
67a8dbbc4 drivers/media/video/marvell-ccic/mmp-driver.c    Jonathan Corbet 2011-06-11  181  	gpio_set_value(pdata->sensor_reset_gpio, 0);
05fed8162 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  182  
0e394f44f drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  183  	mcam_clk_disable(mcam);
05fed8162 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  184  }
05fed8162 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  185  
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  186  void mcam_ctlr_reset(struct mcam_camera *mcam)
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  187  {
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  188  	unsigned long val;
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  189  	struct mmp_camera *cam = mcam_to_cam(mcam);
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  190  
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  191  	if (mcam->ccic_id) {
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  192  		/*
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  193  		 * Using CCIC2
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  194  		 */
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  195  		val = ioread32(cam->power_regs + REG_CCIC2_CRCR);
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  196  		iowrite32(val & ~0x2, cam->power_regs + REG_CCIC2_CRCR);
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  197  		iowrite32(val | 0x2, cam->power_regs + REG_CCIC2_CRCR);
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  198  	} else {
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  199  		/*
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  200  		 * Using CCIC1
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  201  		 */
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03 @202  		val = ioread32(cam->power_regs + REG_CCIC_CRCR);
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  203  		iowrite32(val & ~0x2, cam->power_regs + REG_CCIC_CRCR);
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  204  		iowrite32(val | 0x2, cam->power_regs + REG_CCIC_CRCR);
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  205  	}
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  206  }
7c269f454 drivers/media/platform/marvell-ccic/mmp-driver.c Libin Yang      2013-07-03  207  

:::::: The code at line 135 was first introduced by commit
:::::: 4a0abfaa9662365303df2accf16383a2edb49a7b [media] mmp-camera: Don't power up the sensor on resume

:::::: TO: Jonathan Corbet <corbet@lwn.net>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
