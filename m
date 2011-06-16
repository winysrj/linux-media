Return-path: <mchehab@pedra>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38091 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1FPChi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 22:37:38 -0400
Received: by yia27 with SMTP id 27so583478yia.19
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2011 19:37:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307814409-46282-9-git-send-email-corbet@lwn.net>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
	<1307814409-46282-9-git-send-email-corbet@lwn.net>
Date: Thu, 16 Jun 2011 10:37:37 +0800
Message-ID: <BANLkTi=rZzEQp0iNBdrTBCeWM=h+nq49sw@mail.gmail.com>
Subject: Re: [PATCH 8/8] marvell-cam: Basic working MMP camera driver
From: Kassey Lee <kassey1216@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	qingx@marvell.com, ytang5@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/12 Jonathan Corbet <corbet@lwn.net>:
> Now we have a camera working over the marvell cam controller core.  It
> works like the cafe driver and has all the same limitations, contiguous DMA
> only being one of them.  But it's a start.
>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/video/Makefile                  |    1 +
>  drivers/media/video/marvell-ccic/Kconfig      |   11 +
>  drivers/media/video/marvell-ccic/Makefile     |    4 +
>  drivers/media/video/marvell-ccic/mcam-core.c  |   28 ++-
>  drivers/media/video/marvell-ccic/mmp-driver.c |  339 +++++++++++++++++++++++++
>  include/media/mmp-camera.h                    |    9 +
>  include/media/v4l2-chip-ident.h               |    3 +-
>  7 files changed, 386 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/media/video/marvell-ccic/mmp-driver.c
>  create mode 100644 include/media/mmp-camera.h
>
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 42b6a7a..89478f0 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -128,6 +128,7 @@ obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
>  obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
>
>  obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
> +obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
>
>  obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
>
> diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
> index 80136a8..b4f7260 100644
> --- a/drivers/media/video/marvell-ccic/Kconfig
> +++ b/drivers/media/video/marvell-ccic/Kconfig
> @@ -7,3 +7,14 @@ config VIDEO_CAFE_CCIC
>          CMOS camera controller.  This is the controller found on first-
>          generation OLPC systems.
>
> +config VIDEO_MMP_CAMERA
> +       tristate "Marvell Armada 610 integrated camera controller support"
> +       depends on ARCH_MMP && I2C && VIDEO_V4L2
> +       select VIDEO_OV7670
> +       select I2C_GPIO
> +       ---help---
> +         This is a Video4Linux2 driver for the integrated camera
> +         controller found on Marvell Armada 610 application
> +         processors (and likely beyond).  This is the controller found
> +         in OLPC XO 1.75 systems.
> +
> diff --git a/drivers/media/video/marvell-ccic/Makefile b/drivers/media/video/marvell-ccic/Makefile
> index 462b385c..05a792c 100644
> --- a/drivers/media/video/marvell-ccic/Makefile
> +++ b/drivers/media/video/marvell-ccic/Makefile
> @@ -1,2 +1,6 @@
>  obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
>  cafe_ccic-y := cafe-driver.o mcam-core.o
> +
> +obj-$(CONFIG_VIDEO_MMP_CAMERA) += mmp_camera.o
> +mmp_camera-y := mmp-driver.o mcam-core.o
> +
> diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
> index 014b70b..3e6a5e8 100644
> --- a/drivers/media/video/marvell-ccic/mcam-core.c
> +++ b/drivers/media/video/marvell-ccic/mcam-core.c
> @@ -167,7 +167,7 @@ static void mcam_set_config_needed(struct mcam_camera *cam, int needed)
>
>
>  /*
> - * Debugging and related.  FIXME these are broken
> + * Debugging and related.
>  */
>  #define cam_err(cam, fmt, arg...) \
>        dev_err((cam)->dev, fmt, ##arg);
> @@ -202,7 +202,8 @@ static void mcam_ctlr_dma(struct mcam_camera *cam)
>                mcam_reg_clear_bit(cam, REG_CTRL1, C1_TWOBUFS);
>        } else
>                mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
> -       mcam_reg_write(cam, REG_UBAR, 0); /* 32 bits only for now */
> +       if (cam->chip_id == V4L2_IDENT_CAFE)
> +               mcam_reg_write(cam, REG_UBAR, 0); /* 32 bits only */
>  }
>
>  static void mcam_ctlr_image(struct mcam_camera *cam)
> @@ -358,8 +359,8 @@ static void mcam_ctlr_power_up(struct mcam_camera *cam)
>        unsigned long flags;
>
>        spin_lock_irqsave(&cam->dev_lock, flags);
> -       mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
>        cam->plat_power_up(cam);
> +       mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
>        spin_unlock_irqrestore(&cam->dev_lock, flags);
>        msleep(5); /* Just to be sure */
>  }
> @@ -369,8 +370,13 @@ static void mcam_ctlr_power_down(struct mcam_camera *cam)
>        unsigned long flags;
>
>        spin_lock_irqsave(&cam->dev_lock, flags);
> -       cam->plat_power_down(cam);
> +       /*
> +        * School of hard knocks department: be sure we do any register
> +        * twiddling on the controller *before* calling the platform
> +        * power down routine.
> +        */
>        mcam_reg_set_bit(cam, REG_CTRL1, C1_PWRDWN);
> +       cam->plat_power_down(cam);
>        spin_unlock_irqrestore(&cam->dev_lock, flags);
>  }
>
> @@ -1622,14 +1628,20 @@ out_unregister:
>
>  void mccic_shutdown(struct mcam_camera *cam)
>  {
> -       if (cam->users > 0)
> +       /*
> +        * If we have no users (and we really, really should have no
> +        * users) the device will already be powered down.  Trying to
> +        * take it down again will wedge the machine, which is frowned
> +        * upon.
> +        */
> +       if (cam->users > 0) {
>                cam_warn(cam, "Removing a device with users!\n");
> +               mcam_ctlr_power_down(cam);
> +       }
> +       mcam_free_dma_bufs(cam);
>        if (cam->n_sbufs > 0)
>                /* What if they are still mapped?  Shouldn't be, but... */
>                mcam_free_sio_buffers(cam);
> -       mcam_ctlr_stop_dma(cam);
> -       mcam_ctlr_power_down(cam);
> -       mcam_free_dma_bufs(cam);
>        video_unregister_device(&cam->vdev);
>        v4l2_device_unregister(&cam->v4l2_dev);
>  }
> diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/video/marvell-ccic/mmp-driver.c
> new file mode 100644
> index 0000000..ac9976f
> --- /dev/null
> +++ b/drivers/media/video/marvell-ccic/mmp-driver.c
> @@ -0,0 +1,339 @@
> +/*
> + * Support for the camera device found on Marvell MMP processors; known
> + * to work with the Armada 610 as used in the OLPC 1.75 system.
> + *
> + * Copyright 2011 Jonathan Corbet <corbet@lwn.net>
> + *
> + * This file may be distributed under the terms of the GNU General
> + * Public License, version 2.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/slab.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/mmp-camera.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/list.h>
> +
> +#include "mcam-core.h"
> +
> +MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
> +MODULE_LICENSE("GPL");
> +
> +struct mmp_camera {
> +       void *power_regs;
> +       struct platform_device *pdev;
> +       struct mcam_camera mcam;
> +       struct list_head devlist;
> +       int irq;
> +};
> +
> +static inline struct mmp_camera *mcam_to_cam(struct mcam_camera *mcam)
> +{
> +       return container_of(mcam, struct mmp_camera, mcam);
> +}
> +
> +/*
> + * A silly little infrastructure so we can keep track of our devices.
> + * Chances are that we will never have more than one of them, but
> + * the Armada 610 *does* have two controllers...
> + */
> +
> +static LIST_HEAD(mmpcam_devices);
> +static struct mutex mmpcam_devices_lock;
> +
> +static void mmpcam_add_device(struct mmp_camera *cam)
> +{
> +       mutex_lock(&mmpcam_devices_lock);
> +       list_add(&cam->devlist, &mmpcam_devices);
> +       mutex_unlock(&mmpcam_devices_lock);
> +}
> +
> +static void mmpcam_remove_device(struct mmp_camera *cam)
> +{
> +       mutex_lock(&mmpcam_devices_lock);
> +       list_del(&cam->devlist);
> +       mutex_unlock(&mmpcam_devices_lock);
> +}
> +
> +/*
> + * Platform dev remove passes us a platform_device, and there's
> + * no handy unused drvdata to stash a backpointer in.  So just
> + * dig it out of our list.
> + */
> +static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
> +{
> +       struct mmp_camera *cam;
> +
> +       mutex_lock(&mmpcam_devices_lock);
> +       list_for_each_entry(cam, &mmpcam_devices, devlist) {
> +               if (cam->pdev == pdev) {
> +                       mutex_unlock(&mmpcam_devices_lock);
> +                       return cam;
> +               }
> +       }
> +       mutex_unlock(&mmpcam_devices_lock);
> +       return NULL;
> +}
> +
> +
> +
> +
> +/*
> + * Power-related registers; this almost certainly belongs
> + * somewhere else.
> + *
> + * ARMADA 610 register manual, sec 7.2.1, p1842.
> + */
> +#define CPU_SUBSYS_PMU_BASE    0xd4282800
> +#define REG_CCIC_DCGCR         0x28    /* CCIC dyn clock gate ctrl reg */
> +#define REG_CCIC_CRCR          0x50    /* CCIC clk reset ctrl reg      */
> +
> +/*
> + * Power control.
> + */
> +static void mmpcam_power_up(struct mcam_camera *mcam)
> +{
> +       struct mmp_camera *cam = mcam_to_cam(mcam);
> +       struct mmp_camera_platform_data *pdata;
> +/*
> + * Turn on power and clocks to the controller.
> + */
> +       iowrite32(0x3f, cam->power_regs + REG_CCIC_DCGCR);
> +       iowrite32(0x3805b, cam->power_regs + REG_CCIC_CRCR);
> +       mdelay(1);
> +/*
> + * Provide power to the sensor.
> + */
> +       mcam_reg_write(mcam, REG_CLKCTRL, 0x60000002);
> +       pdata = cam->pdev->dev.platform_data;
> +       gpio_set_value(pdata->sensor_power_gpio, 1);
> +       mdelay(5);
> +       mcam_reg_clear_bit(mcam, REG_CTRL1, 0x10000000);
> +       gpio_set_value(pdata->sensor_reset_gpio, 0); /* reset is active low */
> +       mdelay(5);
> +       gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
> +       mdelay(5);
> +}
> +
> +static void mmpcam_power_down(struct mcam_camera *mcam)
> +{
> +       struct mmp_camera *cam = mcam_to_cam(mcam);
> +       struct mmp_camera_platform_data *pdata;
> +/*
> + * Turn off clocks and set reset lines
> + */
> +       iowrite32(0, cam->power_regs + REG_CCIC_DCGCR);
> +       iowrite32(0, cam->power_regs + REG_CCIC_CRCR);
> +/*
> + * Shut down the sensor.
> + */
> +       pdata = cam->pdev->dev.platform_data;
> +       gpio_set_value(pdata->sensor_power_gpio, 0);
> +       gpio_set_value(pdata->sensor_reset_gpio, 0);
it is better to have a callback function to controller sensor power on/off.
and place the callback function in board.c
> +}
> +
> +
> +static irqreturn_t mmpcam_irq(int irq, void *data)
> +{
> +       struct mcam_camera *mcam = data;
> +       unsigned int irqs, handled;
> +
> +       spin_lock(&mcam->dev_lock);
> +       irqs = mcam_reg_read(mcam, REG_IRQSTAT);
> +       handled = mccic_irq(mcam, irqs);
> +       spin_unlock(&mcam->dev_lock);
> +       return IRQ_RETVAL(handled);
> +}
> +
> +
> +static int mmpcam_probe(struct platform_device *pdev)
> +{
> +       struct mmp_camera *cam;
> +       struct mcam_camera *mcam;
> +       struct resource *res;
> +       struct mmp_camera_platform_data *pdata;
> +       int ret;
> +
> +       cam = kzalloc(sizeof(*cam), GFP_KERNEL);
> +       if (cam == NULL)
> +               return -ENOMEM;
> +       cam->pdev = pdev;
> +       INIT_LIST_HEAD(&cam->devlist);
> +
> +       mcam = &cam->mcam;
> +       mcam->platform = MHP_Armada610;
> +       mcam->plat_power_up = mmpcam_power_up;
> +       mcam->plat_power_down = mmpcam_power_down;
> +       mcam->dev = &pdev->dev;
> +       mcam->use_smbus = 0;
> +       mcam->chip_id = V4L2_IDENT_ARMADA610;
> +       spin_lock_init(&mcam->dev_lock);
> +       /*
> +        * Get our I/O memory.
> +        */
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (res == NULL) {
> +               dev_err(&pdev->dev, "no iomem resource!\n");
> +               ret = -ENODEV;
> +               goto out_free;
> +       }
> +       mcam->regs = ioremap(res->start, resource_size(res));
> +       if (mcam->regs == NULL) {
> +               dev_err(&pdev->dev, "MMIO ioremap fail\n");
> +               ret = -ENODEV;
> +               goto out_free;
> +       }
> +       /*
> +        * Power/clock memory is elsewhere; get it too.  Perhaps this
> +        * should really be managed outside of this driver?
> +        */
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +       if (res == NULL) {
> +               dev_err(&pdev->dev, "no power resource!\n");
> +               ret = -ENODEV;
> +               goto out_unmap1;
> +       }
> +       cam->power_regs = ioremap(res->start, resource_size(res));
> +       if (cam->power_regs == NULL) {
> +               dev_err(&pdev->dev, "power MMIO ioremap fail\n");
> +               ret = -ENODEV;
> +               goto out_unmap1;
> +       }
> +       /*
> +        * Find the i2c adapter.  This assumes, of course, that the
> +        * i2c bus is already up and functioning.
> +        */
> +       pdata = pdev->dev.platform_data;
> +       mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
> +       if (mcam->i2c_adapter == NULL) {
> +               ret = -ENODEV;
> +               dev_err(&pdev->dev, "No i2c adapter\n");
> +               goto out_unmap2;
> +       }
> +       /*
> +        * Sensor GPIO pins.
> +        */
> +       ret = gpio_request(pdata->sensor_power_gpio, "cam-power");
> +       if (ret) {
> +               dev_err(&pdev->dev, "Can't get sensor power gpio %d",
> +                               pdata->sensor_power_gpio);
> +               goto out_unmap2;
> +       }
> +       gpio_direction_output(pdata->sensor_power_gpio, 0);
> +       ret = gpio_request(pdata->sensor_reset_gpio, "cam-reset");
> +       if (ret) {
> +               dev_err(&pdev->dev, "Can't get sensor reset gpio %d",
> +                               pdata->sensor_reset_gpio);
> +               goto out_gpio;
> +       }
> +       gpio_direction_output(pdata->sensor_reset_gpio, 0);
all these sensor related power on/off
can be abstract a callback function sensor_power, and define it in board.c
because to support different sensor on different board, the power
controller may be different, for example, the GPIO number.
> +       /*
> +        * Power the device up and hand it off to the core.
> +        */
> +       mmpcam_power_up(mcam);
> +       ret = mccic_register(mcam);
> +       if (ret)
> +               goto out_gpio2;
> +       /*
> +        * Finally, set up our IRQ now that the core is ready to
> +        * deal with it.
> +        */
> +       res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +       if (res == NULL) {
> +               ret = -ENODEV;
> +               goto out_unregister;
> +       }
> +       cam->irq = res->start;
> +       ret = request_irq(cam->irq, mmpcam_irq, IRQF_SHARED,
> +                       "mmp-camera", mcam);
> +       if (ret == 0) {
> +               mmpcam_add_device(cam);
> +               return 0;
> +       }
> +
> +out_unregister:
> +       mccic_shutdown(mcam);
> +       mmpcam_power_down(mcam);
> +out_gpio2:
> +       gpio_free(pdata->sensor_reset_gpio);
> +out_gpio:
> +       gpio_free(pdata->sensor_power_gpio);
> +out_unmap2:
> +       iounmap(cam->power_regs);
> +out_unmap1:
> +       iounmap(mcam->regs);
> +out_free:
> +       kfree(cam);
> +       return ret;
> +}
> +
> +
> +static int mmpcam_remove(struct mmp_camera *cam)
> +{
> +       struct mcam_camera *mcam = &cam->mcam;
> +       struct mmp_camera_platform_data *pdata;
> +
> +       mmpcam_remove_device(cam);
> +       free_irq(cam->irq, mcam);
> +       mccic_shutdown(mcam);
> +       mmpcam_power_down(mcam);
> +       pdata = cam->pdev->dev.platform_data;
> +       gpio_free(pdata->sensor_reset_gpio);
> +       gpio_free(pdata->sensor_power_gpio);
> +       iounmap(cam->power_regs);
> +       iounmap(mcam->regs);
> +       kfree(cam);
> +       return 0;
> +}
> +
> +static int mmpcam_platform_remove(struct platform_device *pdev)
> +{
> +       struct mmp_camera *cam = mmpcam_find_device(pdev);
> +
> +       if (cam == NULL)
> +               return -ENODEV;
> +       return mmpcam_remove(cam);
> +}
> +
> +
> +static struct platform_driver mmpcam_driver = {
> +       .probe          = mmpcam_probe,
> +       .remove         = mmpcam_platform_remove,
> +       .driver = {
> +               .name   = "mmp-camera",
> +               .owner  = THIS_MODULE
> +       }
> +};
> +
> +
> +static int __init mmpcam_init_module(void)
> +{
> +       mutex_init(&mmpcam_devices_lock);
> +       return platform_driver_register(&mmpcam_driver);
> +}
> +
> +static void __exit mmpcam_exit_module(void)
> +{
> +       platform_driver_unregister(&mmpcam_driver);
> +       /*
> +        * platform_driver_unregister() should have emptied the list
> +        */
> +       if (!list_empty(&mmpcam_devices))
> +               printk(KERN_ERR "mmp_camera leaving devices behind\n");
> +}
> +
> +module_init(mmpcam_init_module);
> +module_exit(mmpcam_exit_module);
> diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
> new file mode 100644
> index 0000000..7611963
> --- /dev/null
> +++ b/include/media/mmp-camera.h
> @@ -0,0 +1,9 @@
> +/*
> + * Information for the Marvell Armada MMP camera
> + */
> +
> +struct mmp_camera_platform_data {
> +       struct platform_device *i2c_device;
> +       int sensor_power_gpio;
> +       int sensor_reset_gpio;
> +};
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index b3edb67..8717045 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -185,8 +185,9 @@ enum {
>        /* module wm8775: just ident 8775 */
>        V4L2_IDENT_WM8775 = 8775,
>
> -       /* module cafe_ccic, just ident 8801 */
> +       /* Marvell controllers starting at 8801 */
>        V4L2_IDENT_CAFE = 8801,
> +       V4L2_IDENT_ARMADA610 = 8802,
>
>        /* AKM AK8813/AK8814 */
>        V4L2_IDENT_AK8813 = 8813,
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.
