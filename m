Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34404 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1FGMeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 08:34:08 -0400
Received: by gyd10 with SMTP id 10so1898247gyd.19
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2011 05:34:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTim6Jp6Uh7Fnb4rNgHQNNhsuyBQWvA@mail.gmail.com>
References: <1306934205-15154-1-git-send-email-ygli@marvell.com>
	<Pine.LNX.4.64.1106012219350.29934@axis700.grange>
	<BANLkTim6Jp6Uh7Fnb4rNgHQNNhsuyBQWvA@mail.gmail.com>
Date: Tue, 7 Jun 2011 13:46:44 +0800
Message-ID: <BANLkTimdM+Fhv4AS0uNrXPNGVn98=cUomg@mail.gmail.com>
Subject: Re: [PATCH V2] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
From: Kassey Lee <kassey1216@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kassey Lee <ygli@marvell.com>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, qingx@marvell.com, ytang5@marvell.com,
	leiwen@marvell.com, jwan@marvell.com, hzhuang1@marvell.com,
	njun@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

response for Guennadi comments.
thanks

On Tue, Jun 7, 2011 at 1:42 PM, Kassey Lee <kassey1216@gmail.com> wrote:
> Guennadi
>
>          thanks for your comments very much! I will update the V3 patch  later.
>
>
> On Fri, Jun 3, 2011 at 6:22 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
>> Ok, this will be converted to use a common "cafe" code, but I'll comment
>> on this version anyway, for your future reference.
>>
>> On Wed, 1 Jun 2011, Kassey Lee wrote:
>>
>>> This driver exports a video device node per each CCIC
>>> (CMOS Camera Interface Controller)
>>> device contained in Marvell Mobile PXA910 SoC
>>> The driver is based on soc-camera + videobuf2 frame
>>> work, and only USERPTR is supported.
>>>
>>> Signed-off-by: Kassey Lee <ygli@marvell.com>
>>> ---
>>>  arch/arm/mach-mmp/include/mach/camera.h |   37 ++
>>>  drivers/media/video/Kconfig             |    7 +
>>>  drivers/media/video/Makefile            |    1 +
>>>  drivers/media/video/mv_camera.c         | 1067 +++++++++++++++++++++++++++++++
>>>  4 files changed, 1112 insertions(+), 0 deletions(-)
>>>  create mode 100644 arch/arm/mach-mmp/include/mach/camera.h
>>>  create mode 100644 drivers/media/video/mv_camera.c
>>>
>>> diff --git a/arch/arm/mach-mmp/include/mach/camera.h b/arch/arm/mach-mmp/include/mach/camera.h
>>> new file mode 100644
>>> index 0000000..ff8cde1
>>> --- /dev/null
>>> +++ b/arch/arm/mach-mmp/include/mach/camera.h
>>> @@ -0,0 +1,37 @@
>>> +/*
>>> + * Copyright (C) 2011, Marvell International Ltd.
>>> + *   Kassey Lee <ygli@marvell.com>
>>> + *   Angela Wan <jwan@marvell.com>
>>> + *   Lei Wen <leiwen@marvell.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + */
>>> +
>>> +#ifndef __ASM_ARCH_CAMERA_H__
>>> +#define __ASM_ARCH_CAMERA_H__
>>> +
>>> +#define MV_CAMERA_MASTER       1
>>> +#define MV_CAMERA_DATAWIDTH_8  8
>>> +#define MV_CAMERA_DATAWIDTH_10 0x20
>>> +#define MV_CAMERA_PCLK_EN      0x40
>>> +#define MV_CAMERA_MCLK_EN      0x80
>>> +#define MV_CAMERA_PCP          0x100
>>> +#define MV_CAMERA_HSP          0x200
>>> +#define MV_CAMERA_VSP          0x400
>>> +
>>> +struct mv_cam_pdata {
>>> +     int dphy[3];
>>> +     unsigned long flags;
>>> +     int dma_burst;
>>> +     int mclk_min;
>>> +     int mclk_src;
>>> +     int (*init_clk) (struct device *dev, int init);
>>> +     void (*enable_clk) (struct device *dev, int on);
>>> +     int (*get_mclk_src) (int src);
>>> +};
>>> +
>>> +#endif
>>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>>> index 3be180b..18ab3a5 100644
>>> --- a/drivers/media/video/Kconfig
>>> +++ b/drivers/media/video/Kconfig
>>> @@ -891,6 +891,13 @@ config VIDEO_MX3
>>>       ---help---
>>>         This is a v4l2 driver for the i.MX3x Camera Sensor Interface
>>>
>>> +config VIDEO_MV_CCIC
>>> +     tristate "Marvell CMOS Camera Interface Controller driver"
>>> +     depends on VIDEO_DEV && CPU_PXA910 && SOC_CAMERA
>>> +     select VIDEOBUF2_DMA_CONTIG
>>> +     ---help---
>>> +       This is a v4l2 driver for the Marvell CCIC Interface
>>> +
>>>  config VIDEO_PXA27x
>>>       tristate "PXA27x Quick Capture Interface driver"
>>>       depends on VIDEO_DEV && PXA27x && SOC_CAMERA
>>> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>>> index 9519160..e3251c3 100644
>>> --- a/drivers/media/video/Makefile
>>> +++ b/drivers/media/video/Makefile
>>> @@ -161,6 +161,7 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM) += soc_camera_platform.o
>>>  obj-$(CONFIG_VIDEO_MX1)                      += mx1_camera.o
>>>  obj-$(CONFIG_VIDEO_MX2)                      += mx2_camera.o
>>>  obj-$(CONFIG_VIDEO_MX3)                      += mx3_camera.o
>>> +obj-$(CONFIG_VIDEO_MV_CCIC)          += mv_camera.o
>>
>> Ok, I still _think_, "mv_camera" is too generic a name for this driver,
>> but it's up to you, really, just my thought.
>>
> we has mv_gadget(usb), that is Marvell's preferred name. thanks
>>>  obj-$(CONFIG_VIDEO_PXA27x)           += pxa_camera.o
>>>  obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)   += sh_mobile_csi2.o
>>>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)    += sh_mobile_ceu_camera.o
>>> diff --git a/drivers/media/video/mv_camera.c b/drivers/media/video/mv_camera.c
>>> new file mode 100644
>>> index 0000000..f19c43d
>>> --- /dev/null
>>> +++ b/drivers/media/video/mv_camera.c
>>> @@ -0,0 +1,1067 @@
>>> +/*
>>> + * V4L2 Driver for Marvell Mobile SoC PXA910 CCIC
>>> + * (CMOS Capture Interface Controller)
>>> + *
>>> + * Copyright (C) 2011, Marvell International Ltd.
>>> + *   Kassey Lee <ygli@marvell.com>
>>> + *   Angela Wan <jwan@marvell.com>
>>> + *   Lei Wen <leiwen@marvell.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + */
>>> +
>>> +#include <linux/clk.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/device.h>
>>> +#include <linux/dma-mapping.h>
>>> +#include <linux/errno.h>
>>> +#include <linux/fs.h>
>>> +#include <linux/init.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/io.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/mm.h>
>>> +#include <linux/module.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/time.h>
>>> +#include <linux/videodev2.h>
>>> +
>>> +#include <media/soc_camera.h>
>>> +#include <media/soc_mediabus.h>
>>> +#include <media/v4l2-common.h>
>>> +#include <media/v4l2-dev.h>
>>> +#include <media/videobuf2-dma-contig.h>
>>> +
>>> +#include <mach/camera.h>
>>
>> Are you really-really-really sure, you need this one???
>>
Yes, we need this, the struct mv_cam_pdata is defined here.
which is used to pass the board-specific info to mv_camera
>>> +#include "cafe_ccic-regs.h"
>>> +
>>> +/* Register definition for PXA910 */
>>> +
>>> +#define REG_U0BAR       0x0c
>>> +#define REG_U1BAR       0x10
>>> +#define REG_U2BAR       0x14
>>> +#define REG_V0BAR       0x18
>>> +#define REG_V1BAR       0x1C
>>> +#define REG_V2BAR       0x20
>>> +
>>> +/* for MIPI enable */
>>> +#define REG_CSI2_CTRL0  0x100
>>> +#define REG_CSI2_DPHY0  0x120
>>> +#define REG_CSI2_DPHY1  0x124
>>> +#define REG_CSI2_DPHY2  0x128
>>> +#define REG_CSI2_DPHY3  0x12c
>>> +#define REG_CSI2_DPHY4  0x130
>>> +#define REG_CSI2_DPHY5  0x134
>>> +#define REG_CSI2_DPHY6  0x138
>>> +/* REG_CTRL0 */
>>> +#define   CO_EOF_VSYNC    (1 << 22)  /*generate eof by VSYNC */
>>> +#define   C0_VEDGE_CTRL   (1 << 23)  /*VYSNC polarity */
>>
>> Please, add spaces in comments.
>>
OK
>>> +/* hiden register ? */
>>
>> typo: "hidden"
>>
OK
>>> +#define REG_CTRL2    0x1EC
>>> +
>>> +/* IRQ FLAG */
>>> +#define   FRAMEIRQS_EOF        (IRQ_EOF0|IRQ_EOF1|IRQ_EOF2 | IRQ_OVERFLOW)
>>
>> Spaces around "|"
>>
Added.
>>> +
>>> +#define MV_CAM_DRV_NAME "mv-camera"
>>> +
>>> +#define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
>>> +     ((x) >> 24) & 0xff
>>> +
>>> +#define MAX_DMABUF_SIZE   (480 * 720 * 2)    /* D1 size */
>>> +
>>> +struct yuv_pointer_t {
>>> +     dma_addr_t y;
>>> +     dma_addr_t u;
>>> +     dma_addr_t v;
>>> +};
>>> +
>>> +/* buffer for one video frame */
>>> +struct mv_buffer {
>>> +     /* common v4l buffer stuff -- must be first */
>>> +     struct vb2_buffer vb;
>>> +     struct yuv_pointer_t yuv_p;
>>> +     struct list_head queue;
>>> +     size_t bsize;
>>> +};
>>> +
>>> +struct mv_camera_dev {
>>> +     struct soc_camera_host soc_host;
>>> +
>>> +     struct soc_camera_device *icd;
>>> +     u32 irq;
>>
>> No, this is not a value, you're writing to some hardware register, this is
>> a purely "software" value, so, unsigned int from your previous version was
>> ok.
>>
>  change it to unsigned int irq
>>> +     void __iomem *base;
>>> +
>>> +     struct platform_device *pdev;
>>> +     struct resource *res;
>>> +
>>> +     struct list_head capture;
>>> +     /* buf in DMA list  */
>>> +     struct list_head sb_dma;
>>> +     /* protect list capture and sb_dma */
>>> +     spinlock_t list_lock;
>>> +     struct v4l2_pix_format pix_format;
>>> +     /*
>>> +      * internal use only
>>> +      * dummy buffer is used when available
>>> +      * buffer for DMA is fewer than 3
>>> +      */
>>> +     dma_addr_t dummy_buf_phy;
>>> +     void *dummy_buf_virt;
>>> +     unsigned long platform_flags;
>>> +};
>>> +
>>> +/*
>>> + * Device register I/O
>>> + */
>>> +static void ccic_reg_write(struct mv_camera_dev *pcdev, u32 reg, u32 val)
>>> +{
>>
>> Ok, since you anyway will be doing another revision, let's do this right:
>> "val" should be u32, but "reg" can well stay unsigned int - just as I
>> suggested in my review.
>>
> OK, change it to unsigned int reg
>>> +     iowrite32(val, pcdev->base + reg);
>>> +}
>>> +
>>> +static u32 ccic_reg_read(struct mv_camera_dev *pcdev, u32 reg)
>>> +{
>>> +     return ioread32(pcdev->base + reg);
>>> +}
>>> +
>>> +static void ccic_reg_write_mask(struct mv_camera_dev *pcdev,
>>> +                             u32 reg, u32 val, u32 mask)
>>> +{
>>> +     u32 v = ccic_reg_read(pcdev, reg);
>>> +
>>> +     v = (v & ~mask) | (val & mask);
>>> +     ccic_reg_write(pcdev, reg, v);
>>> +}
>>> +
>>> +static void ccic_reg_clear_bit(struct mv_camera_dev *pcdev, u32 reg, u32 val)
>>> +{
>>> +     ccic_reg_write_mask(pcdev, reg, 0, val);
>>> +}
>>> +
>>> +static void ccic_reg_set_bit(struct mv_camera_dev *pcdev, u32 reg, u32 val)
>>> +{
>>> +     ccic_reg_write_mask(pcdev, reg, val, val);
>>> +}
>>> +
>>> +static void ccic_enable_clk(struct mv_camera_dev *pcdev)
>>> +{
>>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>>> +     int div, ctrl1;
>>> +
>>> +     mcam->enable_clk(&pcdev->pdev->dev, 1);
>>> +     div = mcam->get_mclk_src(mcam->mclk_src) / mcam->mclk_min;
>>> +     ccic_reg_write(pcdev, REG_CLKCTRL, (mcam->mclk_src << 29) | div);
>>> +     ctrl1 = 0x800003c;
>>> +     switch (mcam->dma_burst) {
>>> +     case 128:
>>> +             ctrl1 |= 1 << 25;
>>> +             break;
>>> +     case 256:
>>> +             ctrl1 |= 2 << 25;
>>> +             break;
>>> +     }
>>> +     ccic_reg_write(pcdev, REG_CTRL1, ctrl1);
>>> +     if (!(mcam->flags & SOCAM_MIPI))
>>> +             ccic_reg_write(pcdev, REG_CTRL2, 0x00004);
>>> +}
>>> +
>>> +static void ccic_disable_clk(struct mv_camera_dev *pcdev)
>>> +{
>>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>>> +
>>> +     mcam->enable_clk(&pcdev->pdev->dev, 0);
>>> +     ccic_reg_write(pcdev, REG_CLKCTRL, 0x0);
>>> +     ccic_reg_write(pcdev, REG_CTRL1, 0x0);
>>> +}
>>> +
>>> +static void ccic_config_image(struct mv_camera_dev *pcdev)
>>> +{
>>> +     u32 imgsz_h;
>>> +     u32 imgsz_w;
>>> +     struct v4l2_pix_format *fmt = &pcdev->pix_format;
>>> +     u32 widthy, widthuv;
>>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>>> +     struct device *dev = &pcdev->icd->dev;
>>> +
>>> +     dev_dbg(dev, " %s %d bytesperline %d height %d\n", __func__, __LINE__,
>>> +             fmt->bytesperline, fmt->sizeimage / fmt->bytesperline);
>>> +     imgsz_h = (fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK;
>>> +
>>> +     if (fmt->pixelformat == V4L2_PIX_FMT_YUV420)
>>> +             imgsz_w = (fmt->bytesperline * 4 / 3) & IMGSZ_H_MASK;
>>> +     else
>>> +             imgsz_w = fmt->bytesperline & IMGSZ_H_MASK;
>>> +
>>> +     switch (fmt->pixelformat) {
>>> +     case V4L2_PIX_FMT_YUYV:
>>> +     case V4L2_PIX_FMT_UYVY:
>>> +             widthy = fmt->width * 2;
>>> +             widthuv = fmt->width * 2;
>>> +             break;
>>> +     case V4L2_PIX_FMT_RGB565:
>>> +             widthy = fmt->width * 2;
>>> +             widthuv = 0;
>>> +             break;
>>> +     case V4L2_PIX_FMT_JPEG:
>>> +             widthy = fmt->bytesperline;
>>> +             widthuv = fmt->bytesperline;
>>> +             break;
>>> +     case V4L2_PIX_FMT_YUV422P:
>>> +             widthy = fmt->width;
>>> +             widthuv = fmt->width / 2;
>>> +             break;
>>> +     case V4L2_PIX_FMT_YUV420:
>>> +             widthy = fmt->width;
>>> +             widthuv = fmt->width / 2;
>>> +             break;
>>> +     default:
>>> +             break;
>>> +     }
>>> +
>>> +     ccic_reg_write(pcdev, REG_IMGPITCH, widthuv << 16 | widthy);
>>> +     ccic_reg_write(pcdev, REG_IMGSIZE, imgsz_h | imgsz_w);
>>> +     ccic_reg_write(pcdev, REG_IMGOFFSET, 0x0);
>>> +     /*
>>> +      * Tell the controller about the image format we are using.
>>> +      */
>>> +     switch (fmt->pixelformat) {
>>> +     case V4L2_PIX_FMT_YUV422P:
>>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>>> +                     C0_DF_YUV | C0_YUV_PLANAR |
>>> +                     C0_YUVE_YVYU, C0_DF_MASK);
>>> +             break;
>>> +     case V4L2_PIX_FMT_YUV420:
>>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>>> +                     C0_DF_YUV | C0_YUV_420PL |
>>> +                     C0_YUVE_YVYU, C0_DF_MASK);
>>> +             break;
>>> +     case V4L2_PIX_FMT_YUYV:
>>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>>> +                     C0_DF_YUV | C0_YUV_PACKED |
>>> +                     C0_YUVE_YUYV, C0_DF_MASK);
>>> +             break;
>>> +     case V4L2_PIX_FMT_UYVY:
>>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>>> +                     C0_DF_YUV | C0_YUV_PACKED |
>>> +                     C0_YUVE_UYVY, C0_DF_MASK);
>>> +                     break;
>>
>> misaligned break
>>
> aligned
>>> +     case V4L2_PIX_FMT_JPEG:
>>> +             if (mcam->flags & SOCAM_MIPI)
>>> +                     ccic_reg_write_mask(pcdev, REG_CTRL0,
>>> +                                     C0_DF_RGB | C0_RGB_BGR |
>>> +                                     C0_RGB4_BGRX, C0_DF_MASK);
>>> +             else
>>> +                     ccic_reg_write_mask(pcdev, REG_CTRL0,
>>> +                                     C0_DF_YUV | C0_YUV_PACKED |
>>> +                                     C0_YUVE_YUYV, C0_DF_MASK);
>>> +             break;
>>> +     case V4L2_PIX_FMT_RGB444:
>>> +                     ccic_reg_write_mask(pcdev, REG_CTRL0,
>>> +                             C0_DF_RGB | C0_RGBF_444 |
>>> +                             C0_RGB4_XRGB, C0_DF_MASK);
>>> +                     break;
>>
>> too deep indentation
>>
> delete the unneeded indentation
>
>>> +     case V4L2_PIX_FMT_RGB565:
>>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>>> +                             C0_DF_RGB | C0_RGBF_565 |
>>> +                             C0_RGB5_BGGR, C0_DF_MASK);
>>> +             break;
>>> +     default:
>>> +             dev_err(dev, "Unknown format %c%c%c%c\n",
>>> +                      pixfmtstr(fmt->pixelformat));
>>> +             break;
>>> +     }
>>> +}
>>> +
>>> +static void ccic_irq_enable(struct mv_camera_dev *pcdev)
>>> +{
>>> +     ccic_reg_write(pcdev, REG_IRQSTAT, FRAMEIRQS_EOF);
>>> +     ccic_reg_set_bit(pcdev, REG_IRQMASK, FRAMEIRQS_EOF);
>>> +}
>>> +
>>> +static void ccic_irq_disable(struct mv_camera_dev *pcdev)
>>> +{
>>> +     ccic_reg_clear_bit(pcdev, REG_IRQMASK, FRAMEIRQS_EOF);
>>> +}
>>> +
>>> +static void ccic_start(struct mv_camera_dev *pcdev)
>>> +{
>>> +     ccic_reg_set_bit(pcdev, REG_CTRL0, C0_ENABLE);
>>> +}
>>> +
>>> +static void ccic_stop(struct mv_camera_dev *pcdev)
>>> +{
>>> +     ccic_reg_clear_bit(pcdev, REG_CTRL0, C0_ENABLE);
>>> +}
>>> +
>>> +static void ccic_init(struct mv_camera_dev *pcdev)
>>> +{
>>> +     /*
>>> +      * Make sure it's not powered down.
>>> +      */
>>> +     ccic_reg_clear_bit(pcdev, REG_CTRL1, C1_PWRDWN);
>>> +     /*
>>> +      * Turn off the enable bit.  It sure should be off anyway,
>>> +      * but it's good to be sure.
>>> +      */
>>> +     ccic_reg_clear_bit(pcdev, REG_CTRL0, C0_ENABLE);
>>> +     /*
>>> +      * Mask all interrupts.
>>> +      */
>>> +     ccic_reg_write(pcdev, REG_IRQMASK, 0);
>>> +}
>>> +
>>> +static void ccic_stop_dma(struct mv_camera_dev *pcdev)
>>> +{
>>> +     ccic_stop(pcdev);
>>> +     /*
>>> +      * CSI2/DPHY need to be cleared, or no EOF will be received
>>> +      */
>>> +     ccic_reg_write(pcdev, REG_CSI2_DPHY3, 0x0);
>>> +     ccic_reg_write(pcdev, REG_CSI2_DPHY6, 0x0);
>>> +     ccic_reg_write(pcdev, REG_CSI2_DPHY5, 0x0);
>>> +     ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x0);
>>> +     /*
>>> +      * workaround when stop DMA controller!!!
>>> +      * 1) ccic controller must be stopped first,
>>> +      * and it shoud delay for one frame transfer time at least
>>> +      * 2)and then stop the camera sensor's output
>>> +      *
>>> +      * FIXME! need sillcion to add DMA stop/start bit
>>> +      */
>>> +     ccic_irq_disable(pcdev);
>>> +     mdelay(200);
>>> +}
>>> +
>>> +static void ccic_power_up(struct mv_camera_dev *pcdev)
>>> +{
>>> +     ccic_reg_clear_bit(pcdev, REG_CTRL1, C1_PWRDWN);
>>> +}
>>> +
>>> +static void ccic_power_down(struct mv_camera_dev *pcdev)
>>> +{
>>> +     ccic_reg_set_bit(pcdev, REG_CTRL1, C1_PWRDWN);
>>> +}
>>> +
>>> +static void ccic_config_phy(struct mv_camera_dev *pcdev)
>>> +{
>>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>>> +
>>> +     if (SOCAM_MIPI & mcam->flags) {
>>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY3, mcam->dphy[0]);
>>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY6, mcam->dphy[2]);
>>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY5, mcam->dphy[1]);
>>> +             ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x43);
>>> +     } else {
>>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY3, 0x0);
>>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY6, 0x0);
>>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY5, 0x0);
>>> +             ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x0);
>>> +     }
>>> +}
>>> +
>>> +static int mv_videobuf_setup(struct vb2_queue *vq,
>>> +                          u32 *count, u32 *num_planes,
>>> +                          unsigned long sizes[], void *alloc_ctxs[])
>>> +{
>>> +     struct soc_camera_device *icd = container_of(vq,
>>> +             struct soc_camera_device, vb2_vidq);
>>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>> +     struct mv_camera_dev *pcdev = ici->priv;
>>> +     int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>>> +             icd->current_fmt->host_fmt);
>>> +
>>> +     if (bytes_per_line < 0)
>>> +             return bytes_per_line;
>>> +
>>> +     *num_planes = 1;
>>> +     sizes[0] = pcdev->pix_format.sizeimage;
>>> +
>>> +     dev_dbg(icd->dev.parent, "count=%d, size=%lu\n", *count, sizes[0]);
>>> +     return 0;
>>> +}
>>> +
>>> +static int mv_videobuf_prepare(struct vb2_buffer *vb)
>>> +{
>>> +     struct soc_camera_device *icd = container_of(vb->vb2_queue,
>>> +             struct soc_camera_device, vb2_vidq);
>>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>> +     struct mv_camera_dev *pcdev = ici->priv;
>>> +     struct device *dev = pcdev->soc_host.v4l2_dev.dev;
>>> +     struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
>>> +     unsigned long size;
>>> +     int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>>> +             icd->current_fmt->host_fmt);
>>> +
>>> +     dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__, vb,
>>> +             vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
>>> +
>>> +     if (bytes_per_line < 0)
>>> +             return bytes_per_line;
>>> +
>>> +     if (vb->v4l2_buf.length & 31) {
>>> +             dev_err(dev, "buffer size is not 32 bytes aligned\n");
>>> +             BUG_ON(1);
>>> +     }
>>
>> No, that's not what I meant. I didn't mean, that your use of
>> vb2_plane_size() was wrong, I meant, that I didn't understand, why you
>> want to BUG() in this unaligned case. In your mv_videobuf_setup() you just
>> use whatever image size has been configured for buffer size, and it might
>> well be not 32-byte aligned. If this is a hardware requirement, you should
>> enforce it in mv_videobuf_setup(). Then I don't think you need this check
>> at all. In either case, I think, this check should go.
>>
> OK, remove this check.
>>> +
>>> +     /* Added list head initialization on alloc */
>>> +     WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
>>> +
>>> +     BUG_ON(NULL == icd->current_fmt);
>>> +     size = icd->user_height * bytes_per_line;
>>> +     if (vb2_plane_size(vb, 0) < size) {
>>> +             dev_err(icd->dev.parent, "Buffer too small (%lu < %lu)\n",
>>> +                     vb2_plane_size(vb, 0), size);
>>> +             return -ENOBUFS;
>>> +     }
>>> +
>>> +     vb2_set_plane_payload(vb, 0, size);
>>> +     return 0;
>>> +}
>>> +
>>> +static void mv_videobuf_queue(struct vb2_buffer *vb)
>>> +{
>>> +     struct soc_camera_device *icd = container_of(vb->vb2_queue,
>>> +             struct soc_camera_device, vb2_vidq);
>>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>> +     struct mv_camera_dev *pcdev = ici->priv;
>>> +     struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
>>> +     unsigned long flags;
>>> +     dma_addr_t dma_handles;
>>
>> Make it singular - dma_handle
>>
> OK
>>> +     u32 base_size = icd->user_width * icd->user_height;
>>> +
>>> +     dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
>>> +             vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
>>> +     dma_handles = vb2_dma_contig_plane_paddr(vb, 0);
>>> +     if (!dma_handles)
>>> +             BUG_ON(1);
>>
>> BUG_ON(!dma_handle), and I've commented on this one already...
>>
> OK
>>> +
>>> +     if (pcdev->pix_format.pixelformat == V4L2_PIX_FMT_YUV422P) {
>>> +             buf->yuv_p.y = dma_handles;
>>> +             buf->yuv_p.u = buf->yuv_p.y + base_size;
>>> +             buf->yuv_p.v = buf->yuv_p.u + base_size / 2;
>>> +     } else if (pcdev->pix_format.pixelformat == V4L2_PIX_FMT_YUV420) {
>>> +             buf->yuv_p.y = dma_handles;
>>> +             buf->yuv_p.u = buf->yuv_p.y + base_size;
>>> +             buf->yuv_p.v = buf->yuv_p.u + base_size / 4;
>>> +     } else {
>>> +             buf->yuv_p.y = dma_handles;
>>> +             buf->yuv_p.u = pcdev->dummy_buf_phy;
>>> +             buf->yuv_p.v = pcdev->dummy_buf_phy;
>>> +     }
>>> +
>>> +     spin_lock_irqsave(&pcdev->list_lock, flags);
>>> +     list_add_tail(&buf->queue, &pcdev->capture);
>>> +     spin_unlock_irqrestore(&pcdev->list_lock, flags);
>>> +}
>>> +
>>> +static void mv_videobuf_cleanup(struct vb2_buffer *vb)
>>> +{
>>> +     struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
>>> +     struct soc_camera_device *icd = container_of(vb->vb2_queue,
>>> +             struct soc_camera_device, vb2_vidq);
>>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>> +     struct mv_camera_dev *pcdev = ici->priv;
>>> +     unsigned long flags;
>>> +
>>> +     spin_lock_irqsave(&pcdev->list_lock, flags);
>>> +     list_del_init(&buf->queue);
>>> +     spin_unlock_irqrestore(&pcdev->list_lock, flags);
>>> +}
>>> +
>>> +static int mv_videobuf_init(struct vb2_buffer *vb)
>>> +{
>>> +     struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
>>> +     INIT_LIST_HEAD(&buf->queue);
>>> +     return 0;
>>> +}
>>> +
>>> +static int mv_start_streaming(struct vb2_queue *vq)
>>> +{
>>> +     struct soc_camera_device *icd = container_of(vq,
>>> +             struct soc_camera_device, vb2_vidq);
>>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>> +     struct mv_camera_dev *pcdev = ici->priv;
>>> +
>>> +     ccic_config_phy(pcdev);
>>> +     ccic_irq_enable(pcdev);
>>> +     ccic_start(pcdev);
>>> +     return 0;
>>> +}
>>> +
>>> +static int mv_stop_streaming(struct vb2_queue *vq)
>>> +{
>>> +     struct soc_camera_device *icd = container_of(vq,
>>> +             struct soc_camera_device, vb2_vidq);
>>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>> +     struct mv_camera_dev *pcdev = ici->priv;
>>> +
>>> +     ccic_stop_dma(pcdev);
>>> +     return 0;
>>> +}
>>> +
>>> +static struct vb2_ops mv_videobuf_ops = {
>>> +     .queue_setup = mv_videobuf_setup,
>>> +     .buf_prepare = mv_videobuf_prepare,
>>> +     .buf_queue = mv_videobuf_queue,
>>> +     .buf_cleanup = mv_videobuf_cleanup,
>>> +     .buf_init = mv_videobuf_init,
>>> +     .start_streaming = mv_start_streaming,
>>> +     .stop_streaming = mv_stop_streaming,
>>> +     .wait_prepare = soc_camera_unlock,
>>> +     .wait_finish = soc_camera_lock,
>>> +};
>>> +
>>> +static int mv_camera_init_videobuf(struct vb2_queue *q,
>>> +                                struct soc_camera_device *icd)
>>> +{
>>> +     q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> +     q->io_modes = VB2_USERPTR;
>>> +     q->drv_priv = icd;
>>> +     q->ops = &mv_videobuf_ops;
>>> +     q->mem_ops = &vb2_dma_contig_memops;
>>> +     q->buf_struct_size = sizeof(struct mv_buffer);
>>> +
>>> +     return vb2_queue_init(q);
>>> +}
>>> +
>>> +static inline void ccic_dma_done(struct mv_camera_dev *pcdev, u32 frame)
>>> +{
>>> +     unsigned long flags;
>>> +     dma_addr_t dma_base_reg;
>>> +     unsigned long y, u, v;
>>> +
>>> +     spin_lock_irqsave(&pcdev->list_lock, flags);
>>> +     dma_base_reg = ccic_reg_read(pcdev, REG_Y0BAR + (frame << 2));
>>> +
>>> +     /* video buffer done */
>>> +     if (dma_base_reg != pcdev->dummy_buf_phy) {
>>> +             struct mv_buffer *buf;
>>> +
>>> +             list_for_each_entry(buf, &pcdev->sb_dma, queue) {
>>> +                     if (dma_base_reg == buf->yuv_p.y) {
>>> +                             list_del_init(&buf->queue);
>>> +                             vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
>>> +                             break;
>>> +                     }
>>> +             }
>>> +     }
>>> +
>>> +     if (list_empty(&pcdev->capture)) {
>>> +             /* use dummy buffer when no video buffer available */
>>> +             y = u = v = pcdev->dummy_buf_phy;
>>> +     } else {
>>> +             struct mv_buffer *newbuf = list_entry(pcdev->capture.next,
>>> +                                                   struct mv_buffer, queue);
>>> +
>>> +             list_move_tail(&newbuf->queue, &pcdev->sb_dma);
>>> +
>>> +             y = newbuf->yuv_p.y;
>>> +             u = newbuf->yuv_p.u;
>>> +             v = newbuf->yuv_p.v;
>>> +     }
>>> +
>>> +     /* Setup DMA */
>>> +     ccic_reg_write(pcdev, REG_Y0BAR + (frame << 2), y);
>>> +     ccic_reg_write(pcdev, REG_U0BAR + (frame << 2), u);
>>> +     ccic_reg_write(pcdev, REG_V0BAR + (frame << 2), v);
>>> +
>>> +     spin_unlock_irqrestore(&pcdev->list_lock, flags);
>>> +}
>>> +
>>> +static irqreturn_t mv_camera_irq(int irq, void *data)
>>> +{
>>> +     struct mv_camera_dev *pcdev = data;
>>> +     u32 irqs;
>>> +     u32 frame;
>>> +
>>> +     irqs = ccic_reg_read(pcdev, REG_IRQSTAT);
>>> +     ccic_reg_write(pcdev, REG_IRQSTAT, irqs);
>>> +
>>> +     if (irqs & IRQ_EOF0)
>>> +             frame = 0;
>>> +     else if (irqs & IRQ_EOF1)
>>> +             frame = 1;
>>> +     else if (irqs & IRQ_EOF2)
>>> +             frame = 2;
>>> +     else
>>> +             frame = 0x0f;
>>> +     if (0x0f != frame)
>>> +             ccic_dma_done(pcdev, frame);
>>> +     return IRQ_HANDLED;
>>> +}
>>> +
>>> +static int mv_camera_add_device(struct soc_camera_device *icd)
>>> +{
>>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>> +     struct mv_camera_dev *pcdev = ici->priv;
>>> +
>>> +     if (pcdev->icd)
>>> +             return -EBUSY;
>>> +
>>> +     pcdev->icd = icd;
>>> +     ccic_enable_clk(pcdev);
>>> +     ccic_init(pcdev);
>>> +     ccic_power_up(pcdev);
>>> +     return 0;
>>> +}
>>> +
>>> +static void mv_camera_remove_device(struct soc_camera_device
>>> +                                 *icd)
>>> +{
>>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>> +     struct mv_camera_dev *pcdev = ici->priv;
>>> +
>>> +     BUG_ON(icd != pcdev->icd);
>>> +
>>> +     ccic_disable_clk(pcdev);
>>> +     pcdev->icd = NULL;
>>> +}
>>> +
>>> +static unsigned long make_bus_param(struct mv_camera_dev *pcdev)
>>> +{
>>> +     unsigned long flags;
>>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>>> +
>>> +     flags = SOCAM_MASTER |
>>> +         SOCAM_PCLK_SAMPLE_RISING |
>>> +         SOCAM_HSYNC_ACTIVE_HIGH |
>>> +         SOCAM_HSYNC_ACTIVE_LOW |
>>> +         SOCAM_VSYNC_ACTIVE_HIGH |
>>> +         SOCAM_VSYNC_ACTIVE_LOW | SOCAM_DATA_ACTIVE_HIGH;
>>> +
>>> +     if (mcam->flags & MV_CAMERA_DATAWIDTH_8)
>>> +             flags |= SOCAM_DATAWIDTH_8;
>>> +
>>> +     if (mcam->flags & MV_CAMERA_DATAWIDTH_10)
>>> +             flags |= SOCAM_DATAWIDTH_10;
>>> +
>>> +     if (flags & SOCAM_DATAWIDTH_MASK)
>>> +             return flags;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int mv_camera_set_bus_param(struct soc_camera_device
>>> +                                *icd, __u32 pixfmt)
>>> +{
>>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>> +     struct mv_camera_dev *pcdev = ici->priv;
>>> +     int ret;
>>> +     unsigned long camera_flags, common_flags;
>>> +     u32 value;
>>> +
>>> +     camera_flags = icd->ops->query_bus_param(icd);
>>> +     common_flags = soc_camera_bus_param_compatible(camera_flags,
>>> +                                                    make_bus_param(pcdev));
>>> +
>>> +     if (!common_flags)
>>> +             return -EINVAL;
>>> +
>>> +     /* Make choises, based on platform preferences */
>>
>> typo: choices
>>
> sorry, corrected.
>>> +     if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
>>> +         (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
>>> +             if (pcdev->platform_flags & MV_CAMERA_HSP)
>>> +                     common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
>>> +             else
>>> +                     common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
>>> +     }
>>
>> This I don't understand: above you do say, that you support HSYNC low and
>> high, and here you select which one the platform wants to have, but then
>> you only send this down to the sensor, but you don't use this yourself to
>> configure the host? Normally, either your host only supports one polarity,
>> or you have to tell it which one to use - just like you do it for VSYNC at
>> the bottom of this function.
>>
> updated, check PCLK, VSYNC, HSYNC all.
>>> +
>>> +     if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
>>> +         (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
>>> +             if (pcdev->platform_flags & MV_CAMERA_VSP)
>>> +                     common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
>>> +             else
>>> +                     common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
>>> +     }
>>> +
>>> +     if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
>>> +         (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
>>> +             if (pcdev->platform_flags & MV_CAMERA_PCP)
>>> +                     common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
>>> +             else
>>> +                     common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
>>> +     }
>>
>> This is unneeded - above you say, that you only support
>> SOCAM_PCLK_SAMPLE_RISING, so, common_flags cannot contain
>> SOCAM_PCLK_SAMPLE_FALLING.
>>
>>> +
>>> +     ccic_reg_write_mask(pcdev, REG_CTRL0, C0_SIF_HVSYNC, C0_SIFM_MASK);
>>> +     if (common_flags & SOCAM_VSYNC_ACTIVE_LOW) {
>>> +             value = ccic_reg_read(pcdev, REG_CTRL0);
>>> +             value |= CO_EOF_VSYNC | C0_VEDGE_CTRL;
>>> +             ccic_reg_write(pcdev, REG_CTRL0, value);
>>> +     }
>>
>> Yes, I would expect something similar for HSYNC.
>>
> OK
>>> +
>>> +     ret = icd->ops->set_bus_param(icd, common_flags);
>>> +     return ret;
>>> +}
>>> +
>>> +static int mv_camera_set_fmt(struct soc_camera_device *icd,
>>> +                          struct v4l2_format *f)
>>> +{
>>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>> +     struct mv_camera_dev *pcdev = ici->priv;
>>> +     struct device *dev = icd->dev.parent;
>>> +     struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>>> +     const struct soc_camera_format_xlate *xlate = NULL;
>>> +     struct v4l2_mbus_framefmt mf;
>>> +     int ret;
>>> +     struct v4l2_pix_format *pix = &f->fmt.pix;
>>> +
>>> +     dev_dbg(dev, "S_FMT %c%c%c%c, %ux%u\n",
>>> +             pixfmtstr(pix->pixelformat), pix->width, pix->height);
>>> +     xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
>>> +     if (!xlate) {
>>> +             dev_err(dev, "Format %c%c%c%c not found\n",
>>> +                     pixfmtstr(pix->pixelformat));
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     mf.width = pix->width;
>>> +     mf.height = pix->height;
>>> +     mf.field = V4L2_FIELD_NONE;
>>> +     mf.colorspace = pix->colorspace;
>>> +     mf.code = xlate->code;
>>> +
>>> +     ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
>>> +     if (ret < 0) {
>>> +             dev_err(dev, "s_mbus_fmt failed %s %d\n", __func__, __LINE__);
>>> +             return ret;
>>> +     }
>>> +     if (mf.code != xlate->code) {
>>> +             dev_err(dev, "wrong code %s %d\n", __func__, __LINE__);
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     pix->width = mf.width;
>>> +     pix->height = mf.height;
>>> +     pix->field = mf.field;
>>> +     pix->colorspace = mf.colorspace;
>>> +     icd->current_fmt = xlate;
>>> +
>>> +     memcpy(&(pcdev->pix_format), pix, sizeof(struct v4l2_pix_format));
>>> +     ccic_config_image(pcdev);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static int mv_camera_try_fmt(struct soc_camera_device *icd,
>>> +                          struct v4l2_format *f)
>>> +{
>>> +     struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>>> +     struct device *dev = icd->dev.parent;
>>> +     const struct soc_camera_format_xlate *xlate;
>>> +     struct v4l2_pix_format *pix = &f->fmt.pix;
>>> +     struct v4l2_mbus_framefmt mf;
>>> +     __u32 pixfmt = pix->pixelformat;
>>> +     int ret;
>>> +
>>> +     xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>>> +     if (!xlate) {
>>> +             dev_err(dev, "Format %c%c%c%c not found\n",
>>> +                     pixfmtstr(pix->pixelformat));
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
>>> +                                                 xlate->host_fmt);
>>> +     if (pix->bytesperline < 0)
>>> +             return pix->bytesperline;
>>
>> As I mentioned in my first review, the above 4 lines shouldn't be needed
>> either.
>>
> OK, removed
>>> +
>>> +     /* limit to sensor capabilities */
>>> +     mf.width = pix->width;
>>> +     mf.height = pix->height;
>>> +     mf.field = pix->field;
>>
>> Also here V4L2_FIELD_NONE
>>
> OK
>>> +     mf.colorspace = pix->colorspace;
>>> +     mf.code = xlate->code;
>>> +
>>> +     ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     pix->width = mf.width;
>>> +     pix->height = mf.height;
>>> +     pix->colorspace = mf.colorspace;
>>> +
>>> +     switch (mf.field) {
>>> +     case V4L2_FIELD_ANY:
>>> +     case V4L2_FIELD_NONE:
>>> +             pix->field = V4L2_FIELD_NONE;
>>> +             break;
>>> +     default:
>>> +             dev_err(icd->dev.parent, "Field type %d unsupported.\n",
>>> +                     mf.field);
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static unsigned int mv_camera_poll(struct file *file, poll_table * pt)
>>> +{
>>> +     struct soc_camera_device *icd = file->private_data;
>>> +
>>> +     return vb2_poll(&icd->vb2_vidq, file, pt);
>>> +}
>>> +
>>> +static int mv_camera_querycap(struct soc_camera_host *ici,
>>> +                           struct v4l2_capability *cap)
>>> +{
>>> +     cap->version = KERNEL_VERSION(0, 2, 2);
>>> +     cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>>> +     strlcpy(cap->card, "Marvell.CCIC", sizeof(cap->card));
>>> +     return 0;
>>> +}
>>> +
>>> +static const struct soc_mbus_pixelfmt ccic_formats[] = {
>>> +     {
>>> +             .fourcc = V4L2_PIX_FMT_YUV422P,
>>> +             .name = "YUV422PLANAR",
>>> +             .bits_per_sample = 8,
>>> +             .packing = SOC_MBUS_PACKING_2X8_PADLO,
>>> +             .order = SOC_MBUS_ORDER_LE,
>>> +     },
>>> +     {
>>> +             .fourcc = V4L2_PIX_FMT_YUV420,
>>> +             .name = "YUV420PLANAR",
>>> +             .bits_per_sample = 12,
>>> +             .packing = SOC_MBUS_PACKING_NONE,
>>> +             .order = SOC_MBUS_ORDER_LE,
>>> +     },
>>> +     {
>>> +             .fourcc = V4L2_PIX_FMT_UYVY,
>>> +             .name = "YUV422PACKED",
>>> +             .bits_per_sample = 8,
>>> +             .packing = SOC_MBUS_PACKING_2X8_PADLO,
>>> +             .order = SOC_MBUS_ORDER_LE,
>>> +     },
>>> +};
>>> +
>>> +static int mv_camera_get_formats(struct soc_camera_device *icd, u32 idx,
>>> +             struct soc_camera_format_xlate  *xlate)
>>> +{
>>> +     struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>>> +     struct device *dev = icd->dev.parent;
>>> +     int formats, ret;
>>> +     enum v4l2_mbus_pixelcode code;
>>> +     const struct soc_mbus_pixelfmt *fmt;
>>> +
>>> +     ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
>>> +     if (ret < 0)
>>> +             /* No more formats */
>>> +             return 0;
>>> +
>>> +     fmt = soc_mbus_get_fmtdesc(code);
>>> +     if (!fmt) {
>>> +             dev_err(dev, "Invalid format code #%u: %d\n", idx, code);
>>> +             return 0;
>>> +     }
>>> +
>>> +     switch (code) {
>>> +             /* refer to mbus_fmt struct */
>>> +     case V4L2_MBUS_FMT_YUYV8_2X8:
>>> +             /* TODO: add support for YUV420 and YUV422P */
>>> +             formats = ARRAY_SIZE(ccic_formats);
>>> +
>>> +             if (xlate) {
>>> +                     int i;
>>> +                     for (i = 0; i < ARRAY_SIZE(ccic_formats); i++) {
>>> +                             xlate->host_fmt = &ccic_formats[i];
>>> +                             xlate->code = code;
>>> +                             xlate++;
>>> +                     }
>>> +             }
>>> +
>>> +             break;
>>> +     default:
>>> +             /*
>>> +              * camera controller can not support
>>> +              * this format, which might supported by the sensor
>>> +              */
>>> +             dev_warn(dev, "Not support fmt %s\n", fmt->name);
>>> +             return 0;
>>> +     }
>>
>> Did you remove your pass-through code here on purpose or because you
>> misunderstood my comment? I meant, that in your original code
>>
> Sorry, I misunderstood your comment, do you mean remove the wrong comment only ?
>  > +       /* Generic pass-through */
>> +       formats++;
>> +       if (xlate) {
>> +               xlate->host_fmt = fmt;
>> +               xlate->code = code;
>> +               xlate++;
>> +       }
>>
>> the comment "generic" was wrong, because in generic case you run on
>> default case above and bail out. However, that block allowed you to use
>> the "standard" V4L2_MBUS_FMT_YUYV8_2X8 -> V4L2_PIX_FMT_YUYV conversion, or
>> is it not supported by your hardware / driver?
>>
> it is supported.
>>> +
>>> +     return formats;
>>> +}
>>> +
>>> +static struct soc_camera_host_ops mv_soc_camera_host_ops = {
>>> +     .owner = THIS_MODULE,
>>> +     .add = mv_camera_add_device,
>>> +     .remove = mv_camera_remove_device,
>>> +     .set_fmt = mv_camera_set_fmt,
>>> +     .try_fmt = mv_camera_try_fmt,
>>> +     .init_videobuf2 = mv_camera_init_videobuf,
>>> +     .poll = mv_camera_poll,
>>> +     .querycap = mv_camera_querycap,
>>> +     .set_bus_param = mv_camera_set_bus_param,
>>> +     .get_formats = mv_camera_get_formats,
>>> +};
>>> +
>>> +static int __devinit mv_camera_probe(struct platform_device *pdev)
>>> +{
>>> +     struct mv_camera_dev *pcdev;
>>> +     struct mv_cam_pdata *mcam;
>>> +     struct resource *res;
>>> +     void __iomem *base;
>>> +     int irq, i;
>>> +     int err = 0;
>>> +
>>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +     irq = platform_get_irq(pdev, 0);
>>> +     if (!res || irq < 0)
>>> +             return -ENODEV;
>>> +
>>> +     pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
>>> +     if (!pcdev) {
>>> +             dev_err(&pdev->dev, "Could not allocate pcdev\n");
>>> +             return -ENOMEM;
>>> +     }
>>> +
>>> +     pcdev->res = res;
>>> +     pcdev->pdev = pdev;
>>> +
>>> +     /* allocate dummy buffer */
>>> +     pcdev->dummy_buf_virt = dma_alloc_coherent(&pdev->dev,
>>> +        MAX_DMABUF_SIZE, &pcdev->dummy_buf_phy, GFP_KERNEL);
>>
>> TABs for indentation, please
>>
> OK
>>> +     if (!pcdev->dummy_buf_virt) {
>>> +             dev_err(&pdev->dev, "Can't get memory for dummy buffer\n");
>>> +             err = -ENOMEM;
>>> +             goto exit_kfree;
>>> +     }
>>> +
>>> +     mcam = (struct mv_cam_pdata *)pdev->dev.platform_data;
>>
>> Again: no need to type-cast!
>>
> removed
>>> +     if (!mcam || !mcam->init_clk || !mcam->enable_clk
>>> +         || !mcam->get_mclk_src)
>>> +             goto exit_clk;
>>
>> Please, move these 4 lines to the top of this function, then you can just
>> "return -EINVAL" in the error case.
>>
> OK, thanks
>>> +
>>> +     err = mcam->init_clk(&pdev->dev, 1);
>>> +     if (err)
>>> +             goto exit_clk;
>>> +
>>> +     INIT_LIST_HEAD(&pcdev->capture);
>>> +     INIT_LIST_HEAD(&pcdev->sb_dma);
>>> +
>>> +     spin_lock_init(&pcdev->list_lock);
>>> +
>>> +     /*
>>> +      * Request the regions.
>>> +      */
>>> +     if (!request_mem_region(res->start, resource_size(res),
>>> +                             MV_CAM_DRV_NAME)) {
>>> +             err = -EBUSY;
>>> +             dev_err(&pdev->dev, "request_mem_region resource failed\n");
>>> +             goto exit_release;
>>> +     }
>>> +
>>> +     base = ioremap(res->start, resource_size(res));
>>> +     if (!base) {
>>> +             err = -ENOMEM;
>>> +             dev_err(&pdev->dev, "ioremap resource failed\n");
>>> +             goto exit_iounmap;
>>> +     }
>>> +     pcdev->irq = irq;
>>> +     pcdev->base = base;
>>> +     /* request irq */
>>> +     err = request_irq(pcdev->irq, mv_camera_irq, 0, MV_CAM_DRV_NAME, pcdev);
>>> +     if (err) {
>>> +             dev_err(&pdev->dev, "Camera interrupt register failed\n");
>>> +             goto exit_free_irq;
>>> +     }
>>> +
>>> +     /* setup dma with dummy_buf_phy firstly */
>>> +     for (i = 0; i < 3; i++) {
>>> +             ccic_reg_write(pcdev, REG_Y0BAR + (i << 2),
>>> +                            pcdev->dummy_buf_phy);
>>> +             ccic_reg_write(pcdev, REG_U0BAR + (i << 2),
>>> +                            pcdev->dummy_buf_phy);
>>> +             ccic_reg_write(pcdev, REG_V0BAR + (i << 2),
>>> +                            pcdev->dummy_buf_phy);
>>> +     }
>>
>> Let me ask again - you _really_ need these? Without any limitations - how
>> much data can fit in there?
>>
> we want to fix it maxim resolution to D1 size, the data size 720 * 480 * 2,
>
>>> +
>>> +     pcdev->soc_host.drv_name = MV_CAM_DRV_NAME;
>>> +     pcdev->soc_host.ops = &mv_soc_camera_host_ops;
>>> +     pcdev->soc_host.priv = pcdev;
>>> +     pcdev->soc_host.v4l2_dev.dev = &pdev->dev;
>>> +     pcdev->soc_host.nr = pdev->id;
>>> +     err = soc_camera_host_register(&pcdev->soc_host);
>>> +     if (err)
>>> +             goto exit_free_irq;
>>> +     return 0;
>>> +
>>> +exit_free_irq:
>>> +     free_irq(pcdev->irq, pcdev);
>>> +     ccic_power_down(pcdev);
>>> +exit_iounmap:
>>> +     iounmap(base);
>>> +exit_release:
>>> +     release_mem_region(res->start, resource_size(res));
>>> +exit_clk:
>>> +     mcam->init_clk(&pdev->dev, 0);
>>> +exit_kfree:
>>> +     /* free dummy buffer */
>>> +     if (pcdev->dummy_buf_virt)
>>> +             dma_free_coherent(&pdev->dev, MAX_DMABUF_SIZE,
>>> +                       pcdev->dummy_buf_virt, pcdev->dummy_buf_phy);
>>> +     kfree(pcdev);
>>> +
>>> +     return err;
>>> +}
>>> +
>>> +static int mv_camera_remove(struct platform_device *pdev)
>>
>> Again: __devexit
>>
> OK added.
>>
>>> +{
>>> +
>>> +     struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
>>> +     struct mv_camera_dev *pcdev = container_of(soc_host,
>>> +             struct mv_camera_dev, soc_host);
>>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>>> +     struct resource *res;
>>> +
>>> +     mcam->init_clk(&pdev->dev, 0);
>>> +     ccic_power_down(pcdev);
>>> +     free_irq(pcdev->irq, pcdev);
>>> +
>>> +     soc_camera_host_unregister(soc_host);
>>> +
>>> +     iounmap(pcdev->base);
>>> +
>>> +     res = pcdev->res;
>>> +     release_mem_region(res->start, resource_size(res));
>>> +
>>> +     kfree(pcdev);
>>> +
>>> +     /* free dummy buffer */
>>> +     if (pcdev->dummy_buf_virt)
>>> +             dma_free_coherent(&pdev->dev, MAX_DMABUF_SIZE,
>>> +                               pcdev->dummy_buf_virt, pcdev->dummy_buf_phy);
>>> +
>>> +     dev_info(&pdev->dev, "MV Camera driver unloaded\n");
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static struct platform_driver mv_camera_driver = {
>>> +     .driver = {
>>> +             .name = MV_CAM_DRV_NAME,
>>> +     },
>>> +     .probe = mv_camera_probe,
>>> +     .remove = mv_camera_remove,
>>
>> Again:
>> +       .remove = __devexit_p(mv_camera_remove),
>>
>> Please, try not to discard my comments, at least not without an
>> explanation.
>>
> Sorry, i don't mean that.
>>> +};
>>> +
>>> +static int __init mv_camera_init(void)
>>> +{
>>> +     return platform_driver_register(&mv_camera_driver);
>>> +}
>>> +
>>> +static void __exit mv_camera_exit(void)
>>> +{
>>> +     platform_driver_unregister(&mv_camera_driver);
>>> +}
>>> +
>>> +module_init(mv_camera_init);
>>> +module_exit(mv_camera_exit);
>>> +
>>> +MODULE_DESCRIPTION("Marvell CCIC driver");
>>> +MODULE_AUTHOR("Kassey Lee <ygli@marvell.com>");
>>> +MODULE_LICENSE("GPL");
>>> --
>>> 1.7.4.1
>>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> thank you very much!
>
> --
> Best regards
> Kassey
> Application Processor Systems Engineering, Marvell Technology Group Ltd.
> Shanghai, China.
>



-- 
Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.
