Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:48455 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab2JEPLm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 11:11:42 -0400
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Fri, 5 Oct 2012 08:09:10 -0700
Subject: RE: [PATCH 3/4] [media] marvell-ccic: mmp: add soc camera support
 on marvell-ccic mmp-driver
Message-ID: <477F20668A386D41ADCC57781B1F7043083B6575E1@SC-VEXCH1.marvell.com>
References: <1348840048-21423-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1210011053500.3573@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210011053500.3573@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Monday, 01 October, 2012 18:09
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH 3/4] [media] marvell-ccic: mmp: add soc camera support on
>marvell-ccic mmp-driver
>
>Hi Albert
>
>On Fri, 28 Sep 2012, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the support of Soc Camera on marvell-ccic mmp-driver.
>> The Soc Camera mode does not compatible with current mode.
>> Only one mode can be used at one time.
>
>Again, once these patches are split into smaller ones reviewing them should become
>easier and new issues will likely arise, but please take a look at these comments so far.
>
Yes, I understand your concern.
We will continue to discuss how to split them.

>>
>> To enable Soc Camera on mmp:
>> In Device Drivers --> Multimedia support:
>>   select Cameras/video grabbers support Then in Video capture adapters
>> --> V4L platform devices --> Camera support on Marvell MMP:
>>   select Marvell MMP camera driver based on SOC_CAMERA Also in Video
>> capture adapters --> V4L platform devices:
>>   select SoC camera support
>>   select the relevant sensor in target platform
>>
>> Also add MIPI interface and dual CCICs support in Soc Camera mode.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> ---
>>  drivers/media/platform/Makefile                  |    4 +-
>>  drivers/media/platform/marvell-ccic/Kconfig      |   22 +++
>>  drivers/media/platform/marvell-ccic/Makefile     |    1 +
>>  drivers/media/platform/marvell-ccic/mmp-driver.c |  253 +++++++++++++++++++------
>>  include/media/mmp-camera.h                    |   13 ++
>>  5 files changed, 233 insertions(+), 60 deletions(-)
>>
>> diff --git a/drivers/media/platform/Makefile
>> b/drivers/media/platform/Makefile index b7da9fa..ca60607 100755
>> --- a/drivers/media/platform/Makefile
>> +++ b/drivers/media/platform/Makefile
>> @@ -146,9 +146,6 @@ obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
>>
>>  obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
>>
>> -obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
>> -obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
>> -
>>  obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
>>
>>  obj-$(CONFIG_VIDEO_OMAP3)   += omap3isp/
>> @@ -182,6 +179,7 @@ obj-$(CONFIG_VIDEO_MX1)                  +=
>mx1_camera.o
>>  obj-$(CONFIG_VIDEO_MX2)                     += mx2_camera.o
>>  obj-$(CONFIG_VIDEO_MX3)                     += mx3_camera.o
>>  obj-$(CONFIG_VIDEO_PXA27x)          += pxa_camera.o
>> +obj-$(CONFIG_VIDEO_MARVELL_CCIC)    += marvell-ccic/
>>  obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)  += sh_mobile_csi2.o
>>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)   += sh_mobile_ceu_camera.o
>>  obj-$(CONFIG_VIDEO_OMAP1)           += omap1_camera.o
>> diff --git a/drivers/media/platform/marvell-ccic/Kconfig
>> b/drivers/media/platform/marvell-ccic/Kconfig
>> index bf739e3..6e3eaa0 100755
>> --- a/drivers/media/platform/marvell-ccic/Kconfig
>> +++ b/drivers/media/platform/marvell-ccic/Kconfig
>> @@ -1,23 +1,45 @@
>> +config VIDEO_MARVELL_CCIC
>> +       tristate
>> +config VIDEO_MRVL_SOC_CAMERA
>> +       tristate
>> +
>>  config VIDEO_CAFE_CCIC
>>      tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
>>      depends on PCI && I2C && VIDEO_V4L2
>>      select VIDEO_OV7670
>>      select VIDEOBUF2_VMALLOC
>>      select VIDEOBUF2_DMA_CONTIG
>> +    select VIDEO_MARVELL_CCIC
>>      ---help---
>>        This is a video4linux2 driver for the Marvell 88ALP01 integrated
>>        CMOS camera controller.  This is the controller found on first-
>>        generation OLPC systems.
>>
>> +choice
>> +    prompt "Camera support on Marvell MMP"
>> +    depends on ARCH_MMP && VIDEO_V4L2
>> +    optional
>>  config VIDEO_MMP_CAMERA
>>      tristate "Marvell Armada 610 integrated camera controller support"
>>      depends on ARCH_MMP && I2C && VIDEO_V4L2
>>      select VIDEO_OV7670
>>      select I2C_GPIO
>>      select VIDEOBUF2_DMA_SG
>> +    select VIDEO_MARVELL_CCIC
>>      ---help---
>>        This is a Video4Linux2 driver for the integrated camera
>>        controller found on Marvell Armada 610 application
>>        processors (and likely beyond).  This is the controller found
>>        in OLPC XO 1.75 systems.
>>
>> +config VIDEO_MMP_SOC_CAMERA
>> +    bool "Marvell MMP camera driver based on SOC_CAMERA"
>> +    depends on VIDEO_DEV && SOC_CAMERA && ARCH_MMP && VIDEO_V4L2
>> +    select VIDEOBUF2_DMA_CONTIG
>> +    select VIDEO_MARVELL_CCIC
>> +    select VIDEO_MRVL_SOC_CAMERA
>> +    ---help---
>> +      This is a Video4Linux2 driver for the Marvell Mobile Soc
>> +      PXA910/PXA688/PXA2128/PXA988 CCIC
>> +      (CMOS Camera Interface Controller) endchoice
>> diff --git a/drivers/media/platform/marvell-ccic/Makefile
>> b/drivers/media/platform/marvell-ccic/Makefile
>> index 05a792c..d6ffd16 100755
>> --- a/drivers/media/platform/marvell-ccic/Makefile
>> +++ b/drivers/media/platform/marvell-ccic/Makefile
>> @@ -2,5 +2,6 @@ obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
>> cafe_ccic-y := cafe-driver.o mcam-core.o
>>
>>  obj-$(CONFIG_VIDEO_MMP_CAMERA) += mmp_camera.o
>> +obj-$(CONFIG_VIDEO_MMP_SOC_CAMERA) += mmp_camera.o
>>  mmp_camera-y := mmp-driver.o mcam-core.o
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> index c4c17fe..afdd702 100755
>> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> @@ -4,6 +4,12 @@
>>   *
>>   * Copyright 2011 Jonathan Corbet <corbet@lwn.net>
>>   *
>> + * History:
>> + * Support Soc Camera
>> + * Support MIPI interface and Dual CCICs in Soc Camera mode
>> + * Sep-2012: Libin Yang <lbyang@marvell.com>
>> + *           Albert Wang <twang13@marvell.com>
>> + *
>>   * This file may be distributed under the terms of the GNU General
>>   * Public License, version 2.
>>   */
>> @@ -17,9 +23,6 @@
>>  #include <linux/spinlock.h>
>>  #include <linux/slab.h>
>>  #include <linux/videodev2.h>
>> -#include <media/v4l2-device.h>
>> -#include <media/v4l2-chip-ident.h>
>> -#include <media/mmp-camera.h>
>>  #include <linux/device.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/gpio.h>
>> @@ -27,6 +30,19 @@
>>  #include <linux/delay.h>
>>  #include <linux/list.h>
>>  #include <linux/pm.h>
>> +#include <linux/clk.h>
>> +#include <linux/regulator/consumer.h> #include <media/v4l2-device.h>
>> +#include <media/v4l2-chip-ident.h> #include
>> +<media/videobuf2-dma-contig.h> #include <media/mmp-camera.h> #ifdef
>> +CONFIG_VIDEO_MMP_SOC_CAMERA
>
>Like in #2/4: no need for an ifdef.
>
Yes.

>> +#include <media/soc_camera.h>
>> +#include <media/soc_mediabus.h>
>> +#endif
>> +
>> +#include <mach/regs-apmu.h>
>> +#include <plat/mfp.h>
>>
>>  #include "mcam-core.h"
>>
>> @@ -39,6 +55,7 @@ struct mmp_camera {
>>      struct platform_device *pdev;
>>      struct mcam_camera mcam;
>>      struct list_head devlist;
>> +    struct clk *clk[3];     /* CCIC_GATE, CCIC_RST, CCIC_DBG clocks */
>
>I don't see clk[1] amd clk[2] used anywhere in your patches. If they are indeed needed
>and unless you really want to address them as an array, it might be better to use a
>descriptive name for each clock instead of the array.
>
Actually, we used all clocks in our soc platform files.
For this patch, maybe we need find a better method to handle it.

>>      int irq;
>>  };
>>
>> @@ -90,15 +107,7 @@ static struct mmp_camera *mmpcam_find_device(struct
>platform_device *pdev)
>>      return NULL;
>>  }
>>
>> -
>> -
>> -
>> -/*
>> - * Power-related registers; this almost certainly belongs
>> - * somewhere else.
>> - *
>> - * ARMADA 610 register manual, sec 7.2.1, p1842.
>> - */
>
>Why are you removing this comment?
>
Actually, these regs address are same in both ARMADA 610 and other MMP SOC family.
We think it is out-dated.
But of course, we can keep these comments.

>> +#ifdef CONFIG_VIDEO_MMP_CAMERA
>>  #define CPU_SUBSYS_PMU_BASE 0xd4282800
>>  #define REG_CCIC_DCGCR              0x28    /* CCIC dyn clock gate ctrl reg */
>>  #define REG_CCIC_CRCR               0x50    /* CCIC clk reset ctrl reg      */
>> @@ -117,13 +126,13 @@ static void mmpcam_power_up(struct mcam_camera
>> *mcam)  {
>>      struct mmp_camera *cam = mcam_to_cam(mcam);
>>      struct mmp_camera_platform_data *pdata;
>> -/*
>> - * Turn on power and clocks to the controller.
>> - */
>> +    /*
>> +     * Turn on power and clocks to the controller.
>> +     */
>>      mmpcam_power_up_ctlr(cam);
>> -/*
>> - * Provide power to the sensor.
>> - */
>> +    /*
>> +     * Provide power to the sensor.
>> +     */
>>      mcam_reg_write(mcam, REG_CLKCTRL, 0x60000002);
>>      pdata = cam->pdev->dev.platform_data;
>>      gpio_set_value(pdata->sensor_power_gpio, 1); @@ -139,19 +148,91 @@
>> static void mmpcam_power_down(struct mcam_camera *mcam)  {
>>      struct mmp_camera *cam = mcam_to_cam(mcam);
>>      struct mmp_camera_platform_data *pdata;
>> -/*
>> - * Turn off clocks and set reset lines
>> - */
>> +    /*
>> +     * Turn off clocks and set reset lines
>> +     */
>>      iowrite32(0, cam->power_regs + REG_CCIC_DCGCR);
>>      iowrite32(0, cam->power_regs + REG_CCIC_CRCR);
>> -/*
>> - * Shut down the sensor.
>> - */
>> +    /*
>> +     * Shut down the sensor.
>> +     */
>
>These comment indentation changes do not belong in this patch.
>
OK.

>>      pdata = cam->pdev->dev.platform_data;
>>      gpio_set_value(pdata->sensor_power_gpio, 0);
>>      gpio_set_value(pdata->sensor_reset_gpio, 0);  }
>>
>> +void mmpcam_calc_dphy(struct mcam_camera *mcam,
>> +                    struct v4l2_subdev_frame_interval *inter) {
>> +    return;
>> +}
>> +#else
>> +/* setup the camera clk gate in APMU */ static void
>> +mmpcam_island_clk(struct mmp_camera *cam, int on) {
>> +    if (on)
>> +            clk_enable(cam->clk[0]);
>> +    else
>> +            clk_disable(cam->clk[0]);
>
>I would remove this function and inline clk_enable() / clk_disable() directly below.
>
OK, we can think about your suggestion after review code again.

>> +}
>> +
>> +static void mmpcam_power_up(struct mcam_camera *mcam) {
>> +    struct mmp_camera *cam = mcam_to_cam(mcam);
>> +    mmpcam_island_clk(cam, 1);
>> +}
>> +
>> +static void mmpcam_power_up_ctlr(struct mmp_camera *cam) {
>> +    mmpcam_power_up(&cam->mcam);
>> +}
>> +
>> +static void mmpcam_power_down(struct mcam_camera *mcam) {
>> +    struct mmp_camera *cam = mcam_to_cam(mcam);
>> +    mmpcam_island_clk(cam, 0);
>> +}
>> +
>> +void mmpcam_calc_dphy(struct mcam_camera *mcam,
>> +                    struct v4l2_subdev_frame_interval *inter) {
>> +    struct mmp_camera *cam = mcam_to_cam(mcam);
>> +    struct mmp_camera_platform_data *pdata = cam->pdev->dev.platform_data;
>> +    struct device *dev = &cam->pdev->dev;
>> +    unsigned long tx_clk_esc;
>> +    struct clk *pll1;
>> +
>> +    if (pdata->dphy3_algo == 1)
>> +            /*
>> +             * dphy3_algo == 1
>> +             * Calculate CSI2_DPHY3 algo for PXA910
>> +             */
>> +            pdata->dphy[0] = ((1 + inter->pad * 80 / 1000) & 0xff) << 8
>
>Ouch, this looks like an abuse to me. The pad API isn't yet supported by soc-camera,
>nor by the ccic driver, AFAICS. Your use of struct v4l2_subdev_frame_interval::pad here
>doesn't seem valid. I think using struct v4l2_fract directly for this function would be
>better. In patch 2/4 in mcam_camera_set_fmt() you assign
>
>+      inter.pad = mcam->mclk_min;
>
>and then call
>
>+      mcam->calc_dphy(mcam, &inter);
>
>where .mclk_min is anyway coming from mmpcam_probe() as
>
>+      mcam->mclk_min = pdata->mclk_min;
>
>so, looks like you don't need to pass .mclk_min to mmpcam_calc_dphy() at all. As for
>calling subdevice .g_frame_interval() method with that struct
>
>+      ret = v4l2_subdev_call(sd, video, g_frame_interval, &inter);
>
>that's an abuse too - the clock frequency has nothing to do with the pad number. The
>clock frequency should be passed to the sensor by different means. I think, this is an
>example of the problem, that has been discussed at the media mini-summit a month ago.
>The correct way to solve it would be to have your bridge driver export a clock for the
>sensor. If you cannot do that yet, we have to think about a different way to achieve this,
>please, let us know.
>
OK, we need an internal discussion for this usage.

>> +                    | (1 + inter->pad * 35 / 1000);
>> +    else if (pdata->dphy3_algo == 2)
>> +            /*
>> +             * dphy3_algo == 2
>> +             * Calculate CSI2_DPHY3 algo for PXA2128
>> +             */
>> +            pdata->dphy[0] = ((2 + inter->pad * 110 / 1000) & 0xff) << 8
>> +                    | (1 + inter->pad * 35 / 1000);
>> +
>> +    pll1 = clk_get(dev, "pll1");
>> +    if (IS_ERR(pll1)) {
>> +            dev_err(dev, "Could not get pll1 clock\n");
>> +            return;
>> +    }
>> +
>> +    tx_clk_esc = clk_get_rate(pll1) / 1000000 / 12;
>> +    clk_put(pll1);
>
>You are jeeping the clock frequency value around, so, you probably assume, that it will
>stay constant. However, as soon as you release the clock by calling clk_put() its
>frequency can be changed by another user. So, I think you should hold a reference to
>the clock for as long as you're using it.
>
Yes, maybe we need change it.

>> +
>> +    /*
>> +     * Update dphy6 according to current tx_clk_esc
>> +     */
>> +    pdata->dphy[2] = ((534 * tx_clk_esc / 2000 - 1) & 0xff) << 8
>> +                    | ((38 * tx_clk_esc / 1000 - 1) & 0xff);
>> +}
>> +#endif
>>
>>  static irqreturn_t mmpcam_irq(int irq, void *data)
>>  {
>> @@ -160,12 +241,15 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
>>
>>      spin_lock(&mcam->dev_lock);
>>      irqs = mcam_reg_read(mcam, REG_IRQSTAT);
>> +    if (!(irqs & FRAMEIRQS)) {
>> +            spin_unlock(&mcam->dev_lock);
>> +            return IRQ_NONE;
>> +    }
>
>This is a change in behaviour of the original driver and has to be
>submitted and tested on the original hardware separately.
>
Yes.

>>      handled = mccic_irq(mcam, irqs);
>>      spin_unlock(&mcam->dev_lock);
>>      return IRQ_RETVAL(handled);
>>  }
>>
>> -
>>  static int mmpcam_probe(struct platform_device *pdev)
>>  {
>>      struct mmp_camera *cam;
>> @@ -174,35 +258,76 @@ static int mmpcam_probe(struct platform_device *pdev)
>>      struct mmp_camera_platform_data *pdata;
>>      int ret;
>>
>> -    cam = kzalloc(sizeof(*cam), GFP_KERNEL);
>> +    pdata = pdev->dev.platform_data;
>> +
>> +    cam = devm_kzalloc(&pdev->dev, sizeof(*cam), GFP_KERNEL);
>
>Switching to managed allocations is nice, but should also be a separate
>patch.
>
OK, we will prepare another patch to do that.

>>      if (cam == NULL)
>>              return -ENOMEM;
>> +
>>      cam->pdev = pdev;
>>      INIT_LIST_HEAD(&cam->devlist);
>> -
>> +    spin_lock_init(&mcam->dev_lock);
>> +    cam->clk[0] = clk_get(&pdev->dev, pdata->clk_name[0]);
>>      mcam = &cam->mcam;
>>      mcam->plat_power_up = mmpcam_power_up;
>>      mcam->plat_power_down = mmpcam_power_down;
>> +    mcam->calc_dphy = mmpcam_calc_dphy;
>>      mcam->dev = &pdev->dev;
>>      mcam->use_smbus = 0;
>> +    mcam->bus_type = pdata->bus_type;
>> +    mcam->ccic_id = pdev->id;
>> +    mcam->card_name = pdata->name;
>> +    mcam->mclk_min = pdata->mclk_min;
>> +    mcam->mclk_src = pdata->mclk_src;
>> +    mcam->mclk_div = pdata->mclk_div;
>> +    mcam->dphy = &(pdata->dphy);
>> +    mcam->mipi_enabled = 0;
>> +    mcam->lane = pdata->lane;
>> +#ifdef CONFIG_VIDEO_MMP_SOC_CAMERA
>> +    mcam->chip_id = pdata->chip_id;
>> +    mcam->buffer_mode = B_DMA_contig;
>> +#else
>>      mcam->chip_id = V4L2_IDENT_ARMADA610;
>>      mcam->buffer_mode = B_DMA_sg;
>> -    spin_lock_init(&mcam->dev_lock);
>> +#endif
>> +    switch (pdata->dma_burst) {
>> +    case 128:
>> +            mcam->burst = C1_DMAB128;
>> +            break;
>> +    case 256:
>> +            mcam->burst = C1_DMAB256;
>> +            break;
>> +    default:
>> +            mcam->burst = C1_DMAB64;
>> +            break;
>> +    }
>> +    INIT_LIST_HEAD(&mcam->buffers);
>>      /*
>>       * Get our I/O memory.
>>       */
>>      res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>      if (res == NULL) {
>>              dev_err(&pdev->dev, "no iomem resource!\n");
>> -            ret = -ENODEV;
>> -            goto out_free;
>> +            return -ENODEV;
>>      }
>> -    mcam->regs = ioremap(res->start, resource_size(res));
>> +    mcam->regs = devm_request_and_ioremap(&pdev->dev, res);
>>      if (mcam->regs == NULL) {
>>              dev_err(&pdev->dev, "MMIO ioremap fail\n");
>> -            ret = -ENODEV;
>> -            goto out_free;
>> +            return -ENODEV;
>>      }
>> +
>> +#ifdef CONFIG_VIDEO_MMP_SOC_CAMERA
>> +    mcam->vb_alloc_ctx = (struct vb2_alloc_ctx *)
>> +            vb2_dma_contig_init_ctx(&pdev->dev);
>
>No need for a type-cast. In fact, cannot you use vb2_dma_contig support,
>already implemented in mcam-core.c::mcam_setup_vb2()?
>
It seems we need review code again.

>> +    if (IS_ERR(mcam->vb_alloc_ctx))
>> +            return PTR_ERR(mcam->vb_alloc_ctx);
>> +
>> +    ret = mcam_soc_camera_host_register(mcam);
>> +    if (ret)
>> +            goto out_free_ctx;
>> +#endif
>> +
>> +#ifdef CONFIG_VIDEO_MMP_CAMERA
>>      /*
>>       * Power/clock memory is elsewhere; get it too.  Perhaps this
>>       * should really be managed outside of this driver?
>> @@ -211,24 +336,25 @@ static int mmpcam_probe(struct platform_device *pdev)
>>      if (res == NULL) {
>>              dev_err(&pdev->dev, "no power resource!\n");
>>              ret = -ENODEV;
>> -            goto out_unmap1;
>> +            goto out_host_unregister;
>>      }
>> -    cam->power_regs = ioremap(res->start, resource_size(res));
>> +    cam->power_regs = devm_request_and_ioremap(&pdev->dev, res);
>>      if (cam->power_regs == NULL) {
>>              dev_err(&pdev->dev, "power MMIO ioremap fail\n");
>>              ret = -ENODEV;
>> -            goto out_unmap1;
>> +            goto out_host_unregister;
>>      }
>> +
>>      /*
>>       * Find the i2c adapter.  This assumes, of course, that the
>>       * i2c bus is already up and functioning.
>> +     * soc-camera manages i2c interface in sensor side
>>       */
>> -    pdata = pdev->dev.platform_data;
>>      mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
>>      if (mcam->i2c_adapter == NULL) {
>>              ret = -ENODEV;
>>              dev_err(&pdev->dev, "No i2c adapter\n");
>> -            goto out_unmap2;
>> +            goto out_host_unregister;
>>      }
>>      /*
>>       * Sensor GPIO pins.
>> @@ -237,23 +363,26 @@ static int mmpcam_probe(struct platform_device *pdev)
>>      if (ret) {
>>              dev_err(&pdev->dev, "Can't get sensor power gpio %d",
>>                              pdata->sensor_power_gpio);
>> -            goto out_unmap2;
>> +            goto out_host_unregister;
>>      }
>>      gpio_direction_output(pdata->sensor_power_gpio, 0);
>>      ret = gpio_request(pdata->sensor_reset_gpio, "cam-reset");
>>      if (ret) {
>>              dev_err(&pdev->dev, "Can't get sensor reset gpio %d",
>>                              pdata->sensor_reset_gpio);
>> -            goto out_gpio;
>> +            goto out_gpio1;
>>      }
>>      gpio_direction_output(pdata->sensor_reset_gpio, 0);
>> +
>>      /*
>>       * Power the device up and hand it off to the core.
>>       */
>>      mmpcam_power_up(mcam);
>> +#endif
>>      ret = mccic_register(mcam);
>>      if (ret)
>>              goto out_gpio2;
>> +
>>      /*
>>       * Finally, set up our IRQ now that the core is ready to
>>       * deal with it.
>> @@ -264,7 +393,7 @@ static int mmpcam_probe(struct platform_device *pdev)
>>              goto out_unregister;
>>      }
>>      cam->irq = res->start;
>> -    ret = request_irq(cam->irq, mmpcam_irq, IRQF_SHARED,
>> +    ret = devm_request_irq(&pdev->dev, cam->irq, mmpcam_irq, IRQF_SHARED,
>>                      "mmp-camera", mcam);
>>      if (ret == 0) {
>>              mmpcam_add_device(cam);
>> @@ -274,35 +403,46 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  out_unregister:
>>      mccic_shutdown(mcam);
>>  out_gpio2:
>> +#ifdef CONFIG_VIDEO_MMP_CAMERA
>>      mmpcam_power_down(mcam);
>>      gpio_free(pdata->sensor_reset_gpio);
>> -out_gpio:
>> +out_gpio1:
>>      gpio_free(pdata->sensor_power_gpio);
>> -out_unmap2:
>> -    iounmap(cam->power_regs);
>> -out_unmap1:
>> -    iounmap(mcam->regs);
>> -out_free:
>> -    kfree(cam);
>> +out_host_unregister:
>> +#endif
>> +#ifdef CONFIG_VIDEO_MMP_SOC_CAMERA
>> +    soc_camera_host_unregister(&mcam->soc_host);
>> +out_free_ctx:
>> +    vb2_dma_contig_cleanup_ctx(mcam->vb_alloc_ctx);
>> +    mcam->vb_alloc_ctx = NULL;
>> +#endif
>>      return ret;
>>  }
>>
>> -
>>  static int mmpcam_remove(struct mmp_camera *cam)
>>  {
>>      struct mcam_camera *mcam = &cam->mcam;
>> -    struct mmp_camera_platform_data *pdata;
>> +#ifdef CONFIG_VIDEO_MMP_SOC_CAMERA
>> +    struct soc_camera_host *soc_host = &mcam->soc_host;
>> +#else
>> +    struct mmp_camera_platform_data *pdata = cam->pdev->dev.platform_data;
>> +#endif
>>
>>      mmpcam_remove_device(cam);
>> -    free_irq(cam->irq, mcam);
>> +    devm_free_irq(&cam->pdev->dev, cam->irq, mcam);
>
>Why is this needed? This should happen automatically.
>
Yes, maybe it's our fault.

>>      mccic_shutdown(mcam);
>>      mmpcam_power_down(mcam);
>> -    pdata = cam->pdev->dev.platform_data;
>> +#ifdef CONFIG_VIDEO_MMP_SOC_CAMERA
>> +    soc_camera_host_unregister(soc_host);
>> +    vb2_dma_contig_cleanup_ctx(mcam->vb_alloc_ctx);
>> +    mcam->vb_alloc_ctx = NULL;
>> +#else
>>      gpio_free(pdata->sensor_reset_gpio);
>>      gpio_free(pdata->sensor_power_gpio);
>> -    iounmap(cam->power_regs);
>> -    iounmap(mcam->regs);
>> -    kfree(cam);
>> +    devm_iounmap(&cam->pdev->dev, cam->power_regs);
>> +#endif
>> +    devm_iounmap(&cam->pdev->dev, mcam->regs);
>> +    devm_kfree(&cam->pdev->dev, cam);
>
>Same holds for these - device managed resources are freed upon driver
>unbinding.
>
Yes.
devm_kfree do nothing, maybe it just pair for passing original mem leak check tool. :)
Anyway, we can remove the free operation.

>>      return 0;
>>  }
>>
>> @@ -312,6 +452,7 @@ static int mmpcam_platform_remove(struct platform_device
>*pdev)
>>
>>      if (cam == NULL)
>>              return -ENODEV;
>> +
>>      return mmpcam_remove(cam);
>>  }
>>
>> @@ -345,7 +486,6 @@ static int mmpcam_resume(struct platform_device *pdev)
>>
>>  #endif
>>
>> -
>>  static struct platform_driver mmpcam_driver = {
>>      .probe          = mmpcam_probe,
>>      .remove         = mmpcam_platform_remove,
>> @@ -359,7 +499,6 @@ static struct platform_driver mmpcam_driver = {
>>      }
>>  };
>>
>> -
>>  static int __init mmpcam_init_module(void)
>>  {
>>      mutex_init(&mmpcam_devices_lock);
>> diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
>> index 7611963..f90f8c4 100755
>> --- a/include/media/mmp-camera.h
>> +++ b/include/media/mmp-camera.h
>> @@ -6,4 +6,17 @@ struct mmp_camera_platform_data {
>>      struct platform_device *i2c_device;
>>      int sensor_power_gpio;
>>      int sensor_reset_gpio;
>> +    char *clk_name[3];
>> +    char name[16];
>> +    int clk_enabled;
>> +    int dphy[3];            /* DPHY: CSI2_DPHY3, CSI2_DPHY5, CSI2_DPHY6 */
>> +    int dphy3_algo;         /* Exist 2 algos for calculate CSI2_DPHY3 */
>> +    int bus_type;
>> +    int mipi_enabled;       /* MIPI enabled flag */
>> +    int lane;               /* ccic used lane number; 0 means DVP mode */
>> +    int dma_burst;
>> +    int mclk_min;
>> +    int mclk_src;
>> +    int mclk_div;
>> +    int chip_id;
>>  };
>> --
>> 1.7.0.4
>>
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Thanks
Albert Wang
86-21-61092656
