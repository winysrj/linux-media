Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21043 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbaHUV6F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 17:58:05 -0400
Date: Fri, 22 Aug 2014 05:57:02 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 499/499]
 drivers/media/platform/soc_camera/atmel-isi.c:981:26: warning: passing
 argument 3 of 'dma_alloc_attrs' from incompatible pointer type
Message-ID: <53f66b2e.OVxc6I6+egM8u1rb%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   2558eeda5cd75649a1159aadca530a990b81c4ee
commit: 2558eeda5cd75649a1159aadca530a990b81c4ee [499/499] [media] enable COMPILE_TEST for media drivers
config: make ARCH=powerpc allmodconfig

All warnings:

   drivers/media/platform/soc_camera/atmel-isi.c: In function 'start_streaming':
   drivers/media/platform/soc_camera/atmel-isi.c:397:26: warning: large integer implicitly truncated to unsigned type [-Woverflow]
     isi_writel(isi, ISI_INTDIS, ~0UL);
                             ^
   drivers/media/platform/soc_camera/atmel-isi.c: In function 'atmel_isi_probe':
>> drivers/media/platform/soc_camera/atmel-isi.c:981:26: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type
     isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
                             ^
   In file included from include/linux/dma-mapping.h:82:0,
                    from include/linux/dma-buf.h:31,
                    from include/media/videobuf2-core.h:19,
                    from include/media/soc_camera.h:21,
                    from drivers/media/platform/soc_camera/atmel-isi.c:26:
   arch/powerpc/include/asm/dma-mapping.h:141:92: note: expected 'dma_addr_t *' but argument is of type 'u32 *'
    static inline void *dma_alloc_attrs(struct device *dev, size_t size,
                                                                                               ^

vim +/dma_alloc_attrs +981 drivers/media/platform/soc_camera/atmel-isi.c

195ebc43 drivers/media/video/atmel-isi.c               Josh Wu          2011-06-07  965  
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  966  	/* ISI_MCK is the sensor master clock. It should be handled by the
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  967  	 * sensor driver directly, as the ISI has no use for that clock. Make
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  968  	 * the clock optional here while platforms transition to the correct
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  969  	 * model.
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  970  	 */
c52c0cbf drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-25  971  	isi->mck = devm_clk_get(dev, "isi_mck");
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  972  	if (!IS_ERR(isi->mck)) {
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  973  		/* Set ISI_MCK's frequency, it should be faster than pixel
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  974  		 * clock.
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  975  		 */
833e1063 drivers/media/platform/soc_camera/atmel-isi.c Josh Wu          2014-07-25  976  		ret = clk_set_rate(isi->mck, isi->pdata.mck_hz);
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  977  		if (ret < 0)
f389e89c drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-22  978  			return ret;
d8ec0961 drivers/media/video/atmel-isi.c               Josh Wu          2011-12-08  979  	}
d8ec0961 drivers/media/video/atmel-isi.c               Josh Wu          2011-12-08  980  
195ebc43 drivers/media/video/atmel-isi.c               Josh Wu          2011-06-07 @981  	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
195ebc43 drivers/media/video/atmel-isi.c               Josh Wu          2011-06-07  982  				sizeof(struct fbd) * MAX_BUFFER_NUM,
195ebc43 drivers/media/video/atmel-isi.c               Josh Wu          2011-06-07  983  				&isi->fb_descriptors_phys,
195ebc43 drivers/media/video/atmel-isi.c               Josh Wu          2011-06-07  984  				GFP_KERNEL);
195ebc43 drivers/media/video/atmel-isi.c               Josh Wu          2011-06-07  985  	if (!isi->p_fb_descriptors) {
195ebc43 drivers/media/video/atmel-isi.c               Josh Wu          2011-06-07  986  		dev_err(&pdev->dev, "Can't allocate descriptors!\n");
c01d568e drivers/media/platform/soc_camera/atmel-isi.c Laurent Pinchart 2013-11-25  987  		return -ENOMEM;
195ebc43 drivers/media/video/atmel-isi.c               Josh Wu          2011-06-07  988  	}
195ebc43 drivers/media/video/atmel-isi.c               Josh Wu          2011-06-07  989  

:::::: The code at line 981 was first introduced by commit
:::::: 195ebc43bf76df2232d8c55ae284725e73d7a80e [media] V4L: at91: add Atmel Image Sensor Interface (ISI) support

:::::: TO: Josh Wu <josh.wu@atmel.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
