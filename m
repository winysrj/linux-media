Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40366 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab1FAD0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 23:26:34 -0400
Received: by gyd10 with SMTP id 10so2049315gyd.19
        for <linux-media@vger.kernel.org>; Tue, 31 May 2011 20:26:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1105291545410.18788@axis700.grange>
References: <1306505267-4050-1-git-send-email-ygli@marvell.com>
	<Pine.LNX.4.64.1105291545410.18788@axis700.grange>
Date: Wed, 1 Jun 2011 11:26:32 +0800
Message-ID: <BANLkTi=REqn5BiS_gby5AEZ87t+i2O6A6Q@mail.gmail.com>
Subject: Re: [PATCH] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
From: Kassey Lee <kassey1216@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kassey Lee <ygli@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, qingx@marvell.com,
	hzhuang1@marvell.com, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Guennadi:
     thanks for your detail review and comments.
     I updated one by one, and will send out the patch later.
    thanks

2011/5/31 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Fri, 27 May 2011, Kassey Lee wrote:
>
>> This driver exports a video device node per each CCIC
>> (CMOS Camera Interface Controller)
>> device contained in Marvell Mobile PXA910 SoC
>> The driver is based on v4l2-mem2mem framework, and only
>
> What does it have to do with mem2mem?
> [kassey] sorry, I will change it to "this driver is based on soc-camera and videobuf2 framework"
>> USERPTR is supported.
>>
>> Signed-off-by: Kassey Lee <ygli@marvell.com>
>> ---
>>  arch/arm/mach-mmp/include/mach/camera.h |   33 +
>>  drivers/media/video/Kconfig             |    7 +
>>  drivers/media/video/Makefile            |    1 +
>>  drivers/media/video/mv_camera.c         | 1120 +++++++++++++++++++++++++++++++
>>  4 files changed, 1161 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm/mach-mmp/include/mach/camera.h
>>  create mode 100644 drivers/media/video/mv_camera.c
>>
>> diff --git a/arch/arm/mach-mmp/include/mach/camera.h b/arch/arm/mach-mmp/include/mach/camera.h
>> new file mode 100644
>> index 0000000..b008f3f
>> --- /dev/null
>> +++ b/arch/arm/mach-mmp/include/mach/camera.h
>> @@ -0,0 +1,33 @@
>> +/*
>> + * Copyright (C) 2011, Marvell International Ltd.
>> + *   Kassey Lee <ygli@marvell.com>
>> + *   Angela Wan <jwan@marvell.com>
>> + *   Lei Wen <leiwen@marvell.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + */
>> +
>> +#ifndef __ASM_ARCH_CAMERA_H__
>> +#define __ASM_ARCH_CAMERA_H__
>> +
>> +#define MAX_CAM_CLK 3
>> +struct mv_cam_pdata {
>> +     struct clk *clk[MAX_CAM_CLK];
>> +     char *name;
>> +     int clk_enabled;
>
> None of the above fields seem to be used
> [kassey] OK, i will remove them.
>
>> +     int dphy[3];
>> +     int bus_type;
>
> Hm, you're running a bit ahead of time with this one;) SOCAM_MIPI is _not_
> a bus-type, but yes, I'm thinking about adding a bus_type field to struct
> soc_camera_device, in fact, I've been doing that just a couple of hours
> before reviewing this code:) So far I forsee having 3 bus-types: "normal"
> PARALLEL, BT656 and MIPI_CSI2, sounds reasonable? Even though I don't
> think we explicitly support BT656 anywhere in soc-camera yet.
>
> [kassey]appreciate your patch for the bus_type, for now, how about change it to flags, where the platform will define the but attribute that this board supports ?
>> +     int dma_burst;
>> +     int qos_req_min;
>
> Unused?
> [kassey] qos_req_min removed.
>> +     int mclk_min;
>> +     int mclk_src;
>> +     int (*clk_init) (struct device *dev, int init);
>> +     void (*set_clock) (struct device *dev, int on);
>> +     int (*get_mclk_src) (int src);
>> +};
>> +
>> +#endif
>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> index 3be180b..3b7a70e 100644
>> --- a/drivers/media/video/Kconfig
>> +++ b/drivers/media/video/Kconfig
>> @@ -891,6 +891,13 @@ config VIDEO_MX3
>>       ---help---
>>         This is a v4l2 driver for the i.MX3x Camera Sensor Interface
>>
>> +config VIDEO_MV
>
> Maybe choose a more specific name? Either with CCIC or with PXA910 in it -
> whatever you feel is more appropriate. Same holds for the filename and,
> ideally, for the whole used namespace. We hope this is not the last V4L2
> driver from Marvell:-)
>  [kassey] OK, how aboutVIDEO_MV_CCIC ?
>> +     tristate "Marvell CMOS Camera Interface Controller driver"
>> +     depends on VIDEO_DEV && CPU_PXA910 && SOC_CAMERA
>> +     select VIDEOBUF2_DMA_CONTIG
>> +     ---help---
>> +       This is a v4l2 driver for the Marvell CCIC Interface
>> +
>>  config VIDEO_PXA27x
>>       tristate "PXA27x Quick Capture Interface driver"
>>       depends on VIDEO_DEV && PXA27x && SOC_CAMERA
>> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>> index 9519160..373b706 100644
>> --- a/drivers/media/video/Makefile
>> +++ b/drivers/media/video/Makefile
>> @@ -161,6 +161,7 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM) += soc_camera_platform.o
>>  obj-$(CONFIG_VIDEO_MX1)                      += mx1_camera.o
>>  obj-$(CONFIG_VIDEO_MX2)                      += mx2_camera.o
>>  obj-$(CONFIG_VIDEO_MX3)                      += mx3_camera.o
>> +obj-$(CONFIG_VIDEO_MV)                       += mv_camera.o
>>  obj-$(CONFIG_VIDEO_PXA27x)           += pxa_camera.o
>>  obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)   += sh_mobile_csi2.o
>>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)    += sh_mobile_ceu_camera.o
>> diff --git a/drivers/media/video/mv_camera.c b/drivers/media/video/mv_camera.c
>> new file mode 100644
>> index 0000000..1a8f73e
>> --- /dev/null
>> +++ b/drivers/media/video/mv_camera.c
>> @@ -0,0 +1,1120 @@
>> +/*
>> + * V4L2 Driver for Marvell Mobile SoC PXA910 CCIC
>> + * (CMOS Capture Interface Controller)
>> + *
>> + * Copyright (C) 2011, Marvell International Ltd.
>> + *   Kassey Lee <ygli@marvell.com>
>> + *   Angela Wan <jwan@marvell.com>
>> + *   Lei Wen <leiwen@marvell.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/io.h>
>> +#include <linux/delay.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/errno.h>
>> +#include <linux/fs.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/kernel.h>
>> +#include <linux/mm.h>
>> +#include <linux/time.h>
>> +#include <linux/device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/clk.h>
>> +#include <linux/slab.h>
>> +#include <linux/videodev2.h>
>
> Would be good to sort headers alphabetically
> [kassey] OK
>> +
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-dev.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/soc_camera.h>
>> +#include <media/soc_mediabus.h>
>
> ditto
> [kassey] OK
>> +
>> +#include <mach/camera.h>
>
> Hm, this one is for pxa270, you really need it here?
> [kassey] this is for pxa910(arch/arm/mach-mmp/include/mach/) , and pxa270's is in another folder. it is different.
>> +#include "cafe_ccic-regs.h"
>> +
>> +/* Register definition for PXA910 */
>> +
>> +#define REG_U0BAR       0x0c
>> +#define REG_U1BAR       0x10
>> +#define REG_U2BAR       0x14
>> +#define REG_V0BAR       0x18
>> +#define REG_V1BAR       0x1C
>> +#define REG_V2BAR       0x20
>> +
>> +/* for MIPI enable */
>> +#define REG_CSI2_CTRL0  0x100
>> +#define REG_CSI2_DPHY0  0x120
>> +#define REG_CSI2_DPHY1  0x124
>> +#define REG_CSI2_DPHY2  0x128
>> +#define REG_CSI2_DPHY3  0x12c
>> +#define REG_CSI2_DPHY4  0x130
>> +#define REG_CSI2_DPHY5  0x134
>> +#define REG_CSI2_DPHY6  0x138
>> +/* REG_CTRL0 */
>> +#define   CO_EOF_VSYNC    (1 << 22)  /*generate eof by VSYNC */
>> +#define   C0_VEDGE_CTRL   (1 << 23)  /*VYSNC polarity */
>> +/* IRQ FLAG */
>> +#define   FRAMEIRQS_EOF        (IRQ_EOF0|IRQ_EOF1|IRQ_EOF2 | IRQ_OVERFLOW)
>
> All these registers are pxa910-specific and are irrelevant for 88alp01?
>  [kassey] Yes
>> +
>> +#define MV_CAM_DRV_NAME "mv-camera"
>> +
>> +#define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
>> +     ((x) >> 24) & 0xff
>
> Hm, maybe we should put this macro in a header somewhere
>   [kassey] currently, it is  defined in soc_camera.c, i just copied it and this Macro is very useful.
>    how about move it to soc_camera.h , what do you think ?
>> +
>> +static int dma_buf_size = 480 * 720 * 2;     /* D1 size */
>
> Make this a macro. Is this for a maximum of 480p? Is this an absolute
> hardware limit (unlikely) or only for the dummy buffer? At a first glance
> I don't see other size restrictions in the driver, which is, probably,
> wrong. There are maximum width and height values, that your hardware can
> process, right? And then, every time you switch to using the dummy buffer
> you want to make sure, it doesn't overflow.
>  [kassey] currently, we want to only support 480p. it is not the hardware limit.
>   we will make sure the it doesn't overflow.
>> +
>> +struct yuv_pointer_t {
>> +     dma_addr_t y;
>> +     dma_addr_t u;
>> +     dma_addr_t v;
>> +};
>> +
>> +/* buffer for one video frame */
>> +struct mv_buffer {
>> +     /* common v4l buffer stuff -- must be first */
>> +     struct vb2_buffer vb;
>> +     struct yuv_pointer_t yuv_p;
>> +     dma_addr_t dma_handles;
>
> This field is only used in one function and is always recalculated there,
> so, you don't need to keep it. And it's singular - dma_handle.
> [Kassey] OK, move it to the function where it is used.
>> +     struct list_head queue;
>> +     size_t bsize;
>
> Unused
>  [Kassey] removed.
>> +};
>> +
>> +struct mv_camera_dev {
>> +     struct soc_camera_host soc_host;
>> +
>> +     struct soc_camera_device *icd;
>> +     unsigned int irq;
>> +     void __iomem *base;
>> +
>> +     struct platform_device *pdev;
>> +     struct resource *res;
>> +
>> +     struct list_head capture;
>> +     struct list_head sb_dma;        /* dma list (dev_lock) */
>> +
>> +     spinlock_t list_lock;
>
> Locks need a comment
>  [Kassey] it is for the two lists. OK, added.
>> +     struct v4l2_pix_format pix_format;
>> +     /*
>> +      * internal use only
>> +      * dummy buffer is used when available
>> +      * buffer for DMA is less than 3
>
> less than 3 what? You mean fewer than 3 buffers?
>[kassey]yes, fewer than 3.
>> +      */
>> +     void *dummy_buf_virt;
>> +     dma_addr_t dummy_buf_phy;
>> +
>> +     unsigned int width;
>> +     unsigned int height;
>
> Looks like you should be able to use icd->user_width and _height directly
> instead of caching them in these variables?
>[kassey] OK, removed.
>> +};
>> +
>> +/*
>> + * Device register I/O
>> + */
>> +static inline void ccic_reg_write(struct mv_camera_dev *pcdev,
>
> These "inline"s are not needed - trust the compiler:)
>
>> +                               unsigned int reg, unsigned int val)
>
> Better use fixed width types for hardware-specific values, i.e., make it
> "u32 val" - similar below.
>[kassey] OK
>> +{
>> +     iowrite32(val, pcdev->base + reg);
>> +}
>> +
>> +static inline unsigned int ccic_reg_read(struct mv_camera_dev *pcdev,
>> +                                      unsigned int reg)
>> +{
>> +     return ioread32(pcdev->base + reg);
>> +}
>> +
>> +static inline void ccic_reg_write_mask(struct mv_camera_dev *pcdev,
>> +                                    unsigned int reg, unsigned int val,
>> +                                    unsigned int mask)
>> +{
>> +     unsigned int v = ccic_reg_read(pcdev, reg);
>
> u32 v
>[kassey] OK
>> +
>> +     v = (v & ~mask) | (val & mask);
>> +     ccic_reg_write(pcdev, reg, v);
>> +}
>> +
>> +static inline void ccic_reg_clear_bit(struct mv_camera_dev *pcdev,
>> +                                   unsigned int reg, unsigned int val)
>> +{
>> +     ccic_reg_write_mask(pcdev, reg, 0, val);
>> +}
>> +
>> +static inline void ccic_reg_set_bit(struct mv_camera_dev *pcdev,
>> +                                 unsigned int reg, unsigned int val)
>> +{
>> +     ccic_reg_write_mask(pcdev, reg, val, val);
>> +}
>> +
>> +static void ccic_set_clock(struct mv_camera_dev *pcdev, unsigned int reg,
>> +                        unsigned int val)
>> +{
>> +     ccic_reg_write(pcdev, reg, val);
>
> Hm, this function doesn't seem to add much value to ccic_reg_write().
> Maybe remove it and use reg_write() directly?
>[kassey] OK, use ccic_reg_write directly.
>> +}
>> +
>> +static int ccic_enable_clk(struct mv_camera_dev *pcdev)
>> +{
>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>> +     int div, ctrl1;
>> +
>> +     mcam->set_clock(&pcdev->pdev->dev, 1);
>> +     div = mcam->get_mclk_src(mcam->mclk_src) / mcam->mclk_min;
>
> These two platform callbacks cannot be NULL?
>[kassey] these callbacks check will be added in probe, then cannot be NULL.
>
>> +     ccic_set_clock(pcdev, REG_CLKCTRL, (mcam->mclk_src << 29 | div));
>
> You probably meant "(mcam->mclk_src << 29) | div" for readability,
> otherwise you can remove parenthesis completely.
>[kassey]  you are right.
>> +     ctrl1 = 0x800003c;
>> +     switch (mcam->dma_burst) {
>> +     case 128:
>> +             ctrl1 |= 1 << 25;
>> +             break;
>> +     case 256:
>> +             ctrl1 |= 2 << 25;
>> +             break;
>> +     }
>> +     ccic_set_clock(pcdev, REG_CTRL1, ctrl1);
>> +     if (mcam->bus_type != SOCAM_MIPI)
>> +             ccic_set_clock(pcdev, 0x1ec, 0x00004);
>
> Can we have a name for the 0x1ec register?:-)
>[kassey] this is a hidden register for PXA910, I will name it as REG_CTRL2 for now.
>> +
>> +     return 0;
>
> Return value always 0 and never checked - make void, please.
> [kassey] OK
>> +}
>> +
>> +static void ccic_disable_clk(struct mv_camera_dev *pcdev)
>> +{
>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>> +
>> +     mcam->set_clock(&pcdev->pdev->dev, 0);
>> +     ccic_set_clock(pcdev, REG_CLKCTRL, 0x0);
>> +     ccic_set_clock(pcdev, REG_CTRL1, 0x0);
>> +}
>> +
>> +static int ccic_config_image(struct mv_camera_dev *pcdev)
>> +{
>
> Make it void - it never fails
>[kassey] OK
>> +     int ret = 0;
>> +     int imgsz;
>> +     unsigned int temp;
>> +     struct v4l2_pix_format *fmt = &pcdev->pix_format;
>> +     int widthy = 0, widthuv = 0;
>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>> +
>> +     dev_dbg(pcdev->soc_host.v4l2_dev.dev,
>> +             KERN_ERR " %s %d bytesperline %d height %d\n", __func__,
>
> You don't want KERN_ERR here.
>[kassey] OK
>> +             __LINE__, fmt->bytesperline,
>> +             fmt->sizeimage / fmt->bytesperline);
>> +     if (fmt->pixelformat == V4L2_PIX_FMT_YUV420) {
>
> No braces needed
>[kassey] OK
>> +             imgsz =
>> +                 ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
>> +                 (((fmt->bytesperline)
>
> Superfluous parenthesis
>  [Kassey] OK, I will simplify this.
>> +                   * 4 / 3) & IMGSZ_H_MASK);
>> +     } else if (fmt->pixelformat == V4L2_PIX_FMT_JPEG) {
>> +             imgsz =
>> +                 (((fmt->sizeimage /
>> +                    fmt->bytesperline) << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
>> +                 (fmt->bytesperline & IMGSZ_H_MASK);
>
> In JPEG case your bytesperline always == 2048. Do user-space applications
> actually need it? If not - you could just leave it at 0 and use your
> constant directly, maybe defining a macro.
> [Kassey] remove it, since we only support preview as you suggested. user-space do not need it.
>> +
>
> Superfluous empty line
>
>> +     } else {
>> +             imgsz =
>> +                 ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
>> +                 (fmt->bytesperline & IMGSZ_H_MASK);
>> +     }
>> +     switch (fmt->pixelformat) {
>> +     case V4L2_PIX_FMT_YUYV:
>> +     case V4L2_PIX_FMT_UYVY:
>> +             widthy = fmt->width * 2;
>> +             widthuv = fmt->width * 2;
>> +             break;
>> +     case V4L2_PIX_FMT_RGB565:
>> +             widthy = fmt->width * 2;
>> +             widthuv = 0;
>> +             break;
>> +     case V4L2_PIX_FMT_JPEG:
>> +             widthy = fmt->bytesperline;
>> +             widthuv = fmt->bytesperline;
>> +             break;
>> +     case V4L2_PIX_FMT_YUV422P:
>> +             widthy = fmt->width;
>> +             widthuv = fmt->width / 2;
>> +             break;
>> +     case V4L2_PIX_FMT_YUV420:
>> +             widthy = fmt->width;
>> +             widthuv = fmt->width / 2;
>> +             break;
>> +     default:
>> +             break;
>> +     }
>> +
>> +     ccic_reg_write(pcdev, REG_IMGPITCH, widthuv << 16 | widthy);
>> +     ccic_reg_write(pcdev, REG_IMGSIZE, imgsz);
>> +     ccic_reg_write(pcdev, REG_IMGOFFSET, 0x0);
>> +     /*
>> +      * Tell the controller about the image format we are using.
>> +      */
>> +     switch (pcdev->pix_format.pixelformat) {
>
> you already have "fmt" - use it.
>[Kassey] OK
>> +     case V4L2_PIX_FMT_YUV422P:
>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>> +                                 C0_DF_YUV | C0_YUV_PLANAR |
>> +                                 C0_YUVE_YVYU, C0_DF_MASK);
>> +             break;
>> +     case V4L2_PIX_FMT_YUV420:
>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>> +                                 C0_DF_YUV | C0_YUV_420PL |
>> +                                 C0_YUVE_YVYU, C0_DF_MASK);
>> +             break;
>> +
>
> empty line
>[Kassey] OK, removed.
>> +     case V4L2_PIX_FMT_YUYV:
>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>> +                                 C0_DF_YUV | C0_YUV_PACKED |
>> +                                 C0_YUVE_YUYV, C0_DF_MASK);
>> +             break;
>> +     case V4L2_PIX_FMT_UYVY:
>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>> +                                 C0_DF_YUV | C0_YUV_PACKED |
>> +                                 C0_YUVE_UYVY, C0_DF_MASK);
>> +             break;
>> +     case V4L2_PIX_FMT_JPEG:
>> +             if (mcam->bus_type == SOCAM_MIPI)
>> +                     ccic_reg_write_mask(pcdev, REG_CTRL0,
>> +                                         C0_DF_RGB | C0_RGB_BGR |
>> +                                         C0_RGB4_BGRX, C0_DF_MASK);
>> +             else
>> +                     ccic_reg_write_mask(pcdev, REG_CTRL0,
>> +                                         C0_DF_YUV | C0_YUV_PACKED |
>> +                                         C0_YUVE_YUYV, C0_DF_MASK);
>> +             break;
>> +     case V4L2_PIX_FMT_RGB444:
>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>> +                                 C0_DF_RGB | C0_RGBF_444 |
>> +                                 C0_RGB4_XRGB, C0_DF_MASK);
>> +             break;
>> +
>
> ditto
>
>> +     case V4L2_PIX_FMT_RGB565:
>> +             ccic_reg_write_mask(pcdev, REG_CTRL0,
>> +                                 C0_DF_RGB | C0_RGBF_565 |
>> +                                 C0_RGB5_BGGR, C0_DF_MASK);
>> +             break;
>> +
>
> ditto
>
>> +     default:
>> +             dev_dbg(pcdev->soc_host.v4l2_dev.dev, "Unknown format %x\n",
>> +                     pcdev->pix_format.pixelformat);
>
> Since you've defined pixfmtstr(), you can use it here too. And use "fmt."
> [Kassey]OK
>> +             break;
>> +     }
>> +     ccic_reg_write_mask(pcdev, REG_CTRL0, C0_SIF_HVSYNC, C0_SIFM_MASK);
>> +     /*
>> +      * This field controls the generation of EOF(DVP only)
>> +      */
>> +     if (mcam->bus_type != SOCAM_MIPI) {
>> +             temp = ccic_reg_read(pcdev, REG_CTRL0);
>> +             temp |= CO_EOF_VSYNC | C0_VEDGE_CTRL;
>> +             ccic_reg_write(pcdev, REG_CTRL0, temp);
>> +     }
>> +
>> +     return ret;
>> +}
>> +
>> +static void ccic_irq_enable(struct mv_camera_dev *pcdev)
>> +{
>> +     ccic_reg_write(pcdev, REG_IRQSTAT, FRAMEIRQS_EOF);
>> +     ccic_reg_set_bit(pcdev, REG_IRQMASK, FRAMEIRQS_EOF);
>> +}
>> +
>> +static void ccic_irq_disable(struct mv_camera_dev *pcdev)
>> +{
>> +     ccic_reg_clear_bit(pcdev, REG_IRQMASK, FRAMEIRQS_EOF);
>> +}
>> +
>> +static void ccic_start(struct mv_camera_dev *pcdev)
>> +{
>> +     ccic_reg_set_bit(pcdev, REG_CTRL0, C0_ENABLE);
>> +}
>> +
>> +static void ccic_stop(struct mv_camera_dev *pcdev)
>> +{
>> +     ccic_reg_clear_bit(pcdev, REG_CTRL0, C0_ENABLE);
>> +}
>> +
>> +void ccic_init(struct mv_camera_dev *pcdev)
>
> static missing
> [kassey] added.
>> +{
>> +     /*
>> +      * Make sure it's not powered down.
>> +      */
>> +     ccic_reg_clear_bit(pcdev, REG_CTRL1, C1_PWRDWN);
>> +     /*
>> +      * Turn off the enable bit.  It sure should be off anyway,
>> +      * but it's good to be sure.
>> +      */
>> +     ccic_reg_clear_bit(pcdev, REG_CTRL0, C0_ENABLE);
>> +     /*
>> +      * Mask all interrupts.
>> +      */
>> +     ccic_reg_write(pcdev, REG_IRQMASK, 0);
>> +}
>> +
>> +static void ccic_stop_dma(struct mv_camera_dev *pcdev)
>> +{
>> +     ccic_stop(pcdev);
>> +     /*CSI2/DPHY need to be cleared, or no EOF will be received */
>
> Space missing in comment
>[kassey] added
>> +     ccic_reg_write(pcdev, REG_CSI2_DPHY3, 0x0);
>> +     ccic_reg_write(pcdev, REG_CSI2_DPHY6, 0x0);
>> +     ccic_reg_write(pcdev, REG_CSI2_DPHY5, 0x0);
>> +     ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x0);
>> +     /*
>> +      * workaround when stop DMA controller!!!
>> +      * 1) ccic controller must be stopped first,
>> +      * and it shoud delay for one frame transfer time at least
>> +      * 2)and then stop the camera sensor's output
>> +      *
>> +      * FIXME! need sillcion to add DMA stop/start bit
>> +      */
>> +     ccic_irq_disable(pcdev);
>> +     mdelay(200);
>> +}
>> +
>> +/*
>> +* Power up and down.
>> +*/
>
> Multi-line comment style
>[kassey] this comment can be remove, since the function readable from the name.
>> +void ccic_power_up(struct mv_camera_dev *pcdev)
>
> static
>[kassey] added.
>> +{
>> +     ccic_reg_clear_bit(pcdev, REG_CTRL1, C1_PWRDWN);
>> +}
>> +
>> +static void ccic_power_down(struct mv_camera_dev *pcdev)
>
> Don't you want to call this in mv_camera_remove() too?
>  [Kassey] No, we need to call this in remove.
>> +{
>> +     ccic_reg_set_bit(pcdev, REG_CTRL1, C1_PWRDWN);
>> +}
>> +
>> +static void ccic_config_phy(struct mv_camera_dev *pcdev)
>> +{
>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>> +
>> +     if (SOCAM_MIPI & mcam->bus_type) {
>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY3, mcam->dphy[0]);
>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY6, mcam->dphy[2]);
>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY5, mcam->dphy[1]);
>> +             ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x43);
>> +     } else {
>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY3, 0x0);
>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY6, 0x0);
>> +             ccic_reg_write(pcdev, REG_CSI2_DPHY5, 0x0);
>> +             ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x0);
>> +     }
>> +}
>> +
>> +static int mv_videobuf_setup(struct vb2_queue *vq,
>> +                          unsigned int *count, unsigned int *num_planes,
>> +                          unsigned long sizes[], void *alloc_ctxs[])
>> +{
>> +     struct soc_camera_device *icd =
>> +         container_of(vq, struct soc_camera_device, vb2_vidq);
>
> Please, use TABS for indentation, if not aligning with the line above.
>[Kassey]OK, this is added by scripts/Lindent
>> +     int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>> +                                                  icd->
>> +                                                  current_fmt->host_fmt);
>
> No need to break after "->" here, if you really want to stay < 80, you
> could shift the line to the left
>[kassey ]OK
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +     struct mv_camera_dev *pcdev = ici->priv;
>> +
>> +     if (bytes_per_line < 0)
>> +             return bytes_per_line;
>> +
>> +     *num_planes = 1;
>> +     sizes[0] = bytes_per_line * icd->user_height;
>
> You've cached pix_format, cannot you just re-use sizeimage here too? Why
> do you need to recalculate it?
>  [kassey], Ok ,use the cached value.
>> +
>> +     if (icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_JPEG) {
>> +             sizes[0] = pcdev->pix_format.sizeimage;
>
> Hm, correct me if I'm wrong - but I don't see where and how .sizeimage is
> calculated in the JPEG case. Are you relying upon the soc-camera core to
> calculate it as bytesperline * height? I just have no idea what it should
> be in this case.
>[Kassey] Remove jpeg case, since there still some internal discussion on JPEG case.
>> +             bytes_per_line = pcdev->pix_format.bytesperline;
>
> This is not needed anymore.
>[Kassey] OK
>> +     }
>> +
>> +     dev_dbg(icd->dev.parent, "count=%d, size=%lu\n", *count, sizes[0]);
>> +     return 0;
>> +}
>> +
>> +static int mv_videobuf_prepare(struct vb2_buffer *vb)
>> +{
>> +     struct soc_camera_device *icd = container_of(vb->vb2_queue,
>> +                                                  struct soc_camera_device,
>> +                                                  vb2_vidq);
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +     struct mv_camera_dev *pcdev = ici->priv;
>> +     struct device *dev = pcdev->soc_host.v4l2_dev.dev;
>> +     struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
>> +     unsigned long size;
>> +     int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>> +                                                  icd->
>> +                                                  current_fmt->host_fmt);
>
> Same - put on one line, please
>[Kassey] OK
>> +
>> +     dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__, vb,
>> +             vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
>> +     if (icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_JPEG)
>> +             bytes_per_line = pcdev->pix_format.bytesperline;
>> +
>> +     if (bytes_per_line < 0)
>> +             return bytes_per_line;
>> +
>> +     if (vb2_plane_size(vb, 0) & 31) {
>> +             dev_err(dev, "buffer size is not 32 bytes aligned\n");
>> +             BUG_ON(1);
>
> Wow, that's cruel, don't you find? And I don't see where you're protecting
> against this? Where you're aligning image sizes etc?
>[kassey] change it to check vb->v4l2_buf.length ,this is from user space.
>> +     }
>> +
>> +     /* Added list head initialization on alloc */
>> +     WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
>> +
>> +     BUG_ON(NULL == icd->current_fmt);
>> +     size = icd->user_height * bytes_per_line;
>> +     pcdev->height = icd->user_height;
>> +     pcdev->width = icd->user_width;
>
> See above - you don't need to store these.
>  [Kassey] OK
>> +     if (vb2_plane_size(vb, 0) < size) {
>> +             dev_err(icd->dev.parent, "Buffer too small (%lu < %lu)\n",
>> +                     vb2_plane_size(vb, 0), size);
>> +             return -ENOBUFS;
>> +     }
>> +
>> +     buf->bsize = vb2_plane_size(vb, 0);
>> +     vb2_set_plane_payload(vb, 0, size);
>> +     return 0;
>> +}
>> +
>> +static void mv_videobuf_queue(struct vb2_buffer *vb)
>> +{
>> +     struct soc_camera_device *icd =
>> +         container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
>
> TAB for indentation
> [Kassey] OK
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +     struct mv_camera_dev *pcdev = ici->priv;
>> +     struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
>> +     unsigned long flags;
>> +
>> +     dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
>> +             vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
>> +     buf->dma_handles = vb2_dma_contig_plane_paddr(vb, 0);
>> +     if (!buf->dma_handles)
>> +             BUG_ON(1);
>
> BUG_ON(!buf->dma_handles)
>
>> +
>> +     if (pcdev->pix_format.pixelformat == V4L2_PIX_FMT_YUV422P) {
>> +             buf->yuv_p.y = buf->dma_handles;
>> +             buf->yuv_p.u = buf->yuv_p.y + pcdev->width * pcdev->height;
>> +             buf->yuv_p.v = buf->yuv_p.u + pcdev->width * pcdev->height / 2;
>> +     } else if (pcdev->pix_format.pixelformat == V4L2_PIX_FMT_YUV420) {
>> +             buf->yuv_p.y = buf->dma_handles;
>> +             buf->yuv_p.u = buf->yuv_p.y + pcdev->width * pcdev->height;
>> +             buf->yuv_p.v = buf->yuv_p.u + pcdev->width * pcdev->height / 4;
>> +     } else {
>> +             buf->yuv_p.y = buf->dma_handles;
>> +             buf->yuv_p.u = pcdev->dummy_buf_phy;
>> +             buf->yuv_p.v = pcdev->dummy_buf_phy;
>> +     }
>> +
>> +     spin_lock_irqsave(&pcdev->list_lock, flags);
>> +     list_add_tail(&buf->queue, &pcdev->capture);
>> +     spin_unlock_irqrestore(&pcdev->list_lock, flags);
>> +}
>> +
>> +static void mv_videobuf_release(struct vb2_buffer *vb)
>> +{
>> +     struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
>> +     struct soc_camera_device *icd =
>> +         container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
>
> TAB
> [Kassey] OK
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +     struct mv_camera_dev *pcdev = ici->priv;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&pcdev->list_lock, flags);
>> +     if (!list_empty(&buf->queue))
>> +             list_del_init(&buf->queue);
>> +     spin_unlock_irqrestore(&pcdev->list_lock, flags);
>> +}
>> +
>> +static int mv_videobuf_init(struct vb2_buffer *vb)
>> +{
>> +     struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
>> +     INIT_LIST_HEAD(&buf->queue);
>> +     return 0;
>> +}
>> +
>> +static int mv_start_streaming(struct vb2_queue *vq)
>> +{
>> +     struct soc_camera_device *icd =
>> +         container_of(vq, struct soc_camera_device, vb2_vidq);
>
> TAB
> [Kassey] OK
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +     struct mv_camera_dev *pcdev = ici->priv;
>> +
>> +     ccic_config_phy(pcdev);
>> +     ccic_irq_enable(pcdev);
>> +     ccic_start(pcdev);
>> +     return 0;
>> +}
>> +
>> +static int mv_stop_streaming(struct vb2_queue *vq)
>> +{
>> +     struct soc_camera_device *icd =
>> +         container_of(vq, struct soc_camera_device, vb2_vidq);
>
> ditto
>
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +     struct mv_camera_dev *pcdev = ici->priv;
>> +
>> +     ccic_stop_dma(pcdev);
>> +     return 0;
>> +}
>> +
>> +static struct vb2_ops mv_videobuf_ops = {
>> +     .queue_setup = mv_videobuf_setup,
>> +     .buf_prepare = mv_videobuf_prepare,
>> +     .buf_queue = mv_videobuf_queue,
>> +     .buf_cleanup = mv_videobuf_release,
>> +     .buf_init = mv_videobuf_init,
>> +     .start_streaming = mv_start_streaming,
>> +     .stop_streaming = mv_stop_streaming,
>> +     .wait_prepare = soc_camera_unlock,
>> +     .wait_finish = soc_camera_lock,
>> +};
>> +
>> +static int mv_camera_init_videobuf(struct vb2_queue *q,
>> +                                struct soc_camera_device *icd)
>> +{
>> +     int ret = 0;
>> +     struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +
>> +     ret = v4l2_subdev_call(sd, core, load_fw);
>> +     if (ret < 0)
>> +             BUG_ON(1);
>
> ??? You certainly don't really mean this. This will return an error on all
> subdevice drivers, that don't need any firmware and don't implement this
> method. And I really don't understand what this is doint here. Why doesn't
> the subdev driver load its firmware itself??? Please, remove.
>   [Kassey] OK, I will remove it.
>> +
>> +     q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     q->io_modes = VB2_USERPTR;
>> +     q->drv_priv = icd;
>> +     q->ops = &mv_videobuf_ops;
>> +     q->mem_ops = &vb2_dma_contig_memops;
>> +     q->buf_struct_size = sizeof(struct mv_buffer);
>> +
>> +     return vb2_queue_init(q);
>> +}
>> +
>> +static inline void ccic_dma_done(struct mv_camera_dev *pcdev, short frame)
>> +{
>> +     struct mv_buffer *buf = NULL;
>
> No need to initialise, and you can move this under the "if" below.
>    [Kassey] OK
>> +     unsigned long flags = 0;
>
> No need to initialise
> [Kassey] OK
>> +     dma_addr_t dma_base_reg = 0;
>
> ditto
>
>> +     struct mv_buffer *newbuf = NULL;
>
> ditto and move under the "else."
>
>> +     unsigned long y, u, v;
>> +
>> +     spin_lock_irqsave(&pcdev->list_lock, flags);
>> +     dma_base_reg = ccic_reg_read(pcdev, REG_Y0BAR + (frame << 2));
>> +
>> +     /* video buffer done */
>> +     if (dma_base_reg != pcdev->dummy_buf_phy)
>> +             list_for_each_entry(buf, &pcdev->sb_dma, queue) {
>> +             if (dma_base_reg == buf->yuv_p.y) {
>
> Indent one more level - like in a for loop, which it also is.
>
>> +                     list_del_init(&buf->queue);
>> +                     vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
>> +                     break;
>> +             }
>> +             }
>> +
>> +     if (list_empty(&pcdev->capture)) {
>> +             /* use dummy buffer when no video buffer available */
>> +             y = u = v = pcdev->dummy_buf_phy;
>> +     } else {
>> +             newbuf =
>> +                 list_entry(pcdev->capture.next, struct mv_buffer, queue);
>
> Maybe better break it as
> [Kassey] OK
> +               newbuf = list_entry(pcdev->capture.next,
> +                                   struct mv_buffer, queue);
>
>> +             list_move_tail(&newbuf->queue, &pcdev->sb_dma);
>> +
>> +             y = newbuf->yuv_p.y;
>> +             u = newbuf->yuv_p.u;
>> +             v = newbuf->yuv_p.v;
>> +     }
>> +
>> +     /* Setup DMA */
>> +     ccic_reg_write(pcdev, REG_Y0BAR + (frame << 2), y);
>> +     ccic_reg_write(pcdev, REG_U0BAR + (frame << 2), u);
>> +     ccic_reg_write(pcdev, REG_V0BAR + (frame << 2), v);
>> +
>> +     spin_unlock_irqrestore(&pcdev->list_lock, flags);
>> +}
>> +
>> +static irqreturn_t mv_camera_irq(int irq, void *data)
>> +{
>> +     struct mv_camera_dev *pcdev = data;
>> +     unsigned int irqs;
>> +     short frame = 0x0f;
>
> No need to initialise
> [Kassey] OK
>> +
>> +     irqs = ccic_reg_read(pcdev, REG_IRQSTAT);
>> +     ccic_reg_write(pcdev, REG_IRQSTAT, irqs);
>> +
>> +     if (irqs & IRQ_EOF0)
>> +             frame = 0;
>> +     else if (irqs & IRQ_EOF1)
>> +             frame = 1;
>> +     else if (irqs & IRQ_EOF2)
>> +             frame = 2;
>> +     else
>> +             frame = 0x0f;
>> +     if (0x0f != frame)
>> +             ccic_dma_done(pcdev, frame);
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int mv_camera_add_device(struct soc_camera_device *icd)
>> +{
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +     struct mv_camera_dev *pcdev = ici->priv;
>> +
>> +     if (pcdev->icd)
>> +             return -EBUSY;
>> +
>> +     pcdev->icd = icd;
>> +     ccic_enable_clk(pcdev);
>> +
>> +     return 0;
>> +}
>> +
>> +static void mv_camera_remove_device(struct soc_camera_device
>> +                                 *icd)
>> +{
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +     struct mv_camera_dev *pcdev = ici->priv;
>> +
>> +     BUG_ON(icd != pcdev->icd);
>> +
>> +     ccic_disable_clk(pcdev);
>> +     pcdev->icd = NULL;
>> +}
>> +
>> +static int mv_camera_set_bus_param(struct soc_camera_device
>> +                                *icd, __u32 pixfmt)
>> +{
>> +     struct device *dev = icd->dev.parent;
>> +     int ret = 0;
>> +     unsigned long common_flags = 0;
>
> No need to initialise
> [Kassey] OK
>> +
>> +     common_flags = icd->ops->query_bus_param(icd);
>> +
>> +     ret = icd->ops->set_bus_param(icd, common_flags);
>> +     if (ret < 0) {
>> +             dev_err(dev, "%s %d\n", __func__, __LINE__);
>> +             return ret;
>> +     }
>
> Ouch, no, I don't think your hardware supports all possible bus parameters
> automatically, and you shouldn't send ambiguous parameters to the
> subdevice driver.
> [Kassey] OK, I will add the platform bus attribute and, check with sensor side.
>> +     return 0;
>> +}
>> +
>> +static int mv_camera_set_fmt(struct soc_camera_device *icd,
>> +                          struct v4l2_format *f)
>> +{
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +     struct mv_camera_dev *pcdev = ici->priv;
>> +     struct device *dev = icd->dev.parent;
>> +     struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +     const struct soc_camera_format_xlate *xlate = NULL;
>> +     struct v4l2_mbus_framefmt mf;
>> +     int ret = 0;
>
> No need to initialise
> [Kassey] OK
>> +     struct v4l2_pix_format *pix = &f->fmt.pix;
>> +
>> +     memcpy(&(pcdev->pix_format), pix, sizeof(struct v4l2_pix_format));
>
> Superfluous parenthesis, and better do this in the end - just before
> calling ccic_config_image().
>
>> +     dev_err(dev, "S_FMT %c%c%c%c, %ux%u\n",
>> +             pixfmtstr(pix->pixelformat), pix->width, pix->height);
>
> dev_dbg
> [Kassey] OK
>> +     xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
>> +     if (!xlate) {
>> +             dev_err(dev, "Format %c%c%c%c not found\n",
>> +                     pixfmtstr(pix->pixelformat));
>> +             return -EINVAL;
>> +     }
>> +
>> +     mf.width = pix->width;
>> +     mf.height = pix->height;
>> +     mf.field = pix->field;
>> +     mf.colorspace = pix->colorspace;
>> +     mf.code = xlate->code;
>> +
>> +     ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
>> +     if (ret < 0) {
>> +             dev_err(dev, "%s %d\n", __func__, __LINE__);
>> +             return ret;
>> +     }
>> +     if (mf.code != xlate->code) {
>> +             dev_err(dev, "%s %d\n", __func__, __LINE__);
>> +             return -EINVAL;
>
> Both above dev_err calls should be a bit more informative.
> [Kassey] OK
>> +     }
>> +
>> +     icd->sense = NULL;
>
> You don't need to set ->sense to NULL, if you never use it.
> [Kassey] OK, remove it
>> +
>> +     pix->width = mf.width;
>> +     pix->height = mf.height;
>> +     pix->field = mf.field;
>> +     pix->colorspace = mf.colorspace;
>> +     icd->current_fmt = xlate;
>> +
>> +     ret = ccic_config_image(pcdev);
>> +
>> +     return ret;
>> +}
>> +
>> +static int mv_camera_try_fmt(struct soc_camera_device *icd,
>> +                          struct v4l2_format *f)
>> +{
>> +     struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +     struct device *dev = icd->dev.parent;
>> +     const struct soc_camera_format_xlate *xlate;
>> +     struct v4l2_pix_format *pix = &f->fmt.pix;
>> +     struct v4l2_mbus_framefmt mf;
>> +     __u32 pixfmt = pix->pixelformat;
>> +     int ret;
>> +
>> +     xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>> +     if (!xlate) {
>> +             dev_err(dev, "Format %c%c%c%c not found\n",
>> +                     pixfmtstr(pix->pixelformat));
>> +             return -EINVAL;
>> +     }
>> +
>> +     pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
>> +                                                 xlate->host_fmt);
>> +     if (pix->bytesperline < 0)
>> +             return pix->bytesperline;
>> +     if (pix->pixelformat == V4L2_PIX_FMT_JPEG)
>> +             pix->bytesperline = 2048;
>
> Does user-space really need it?
> [Kassey] remove JPEG case.
>> +     else
>> +             pix->sizeimage = pix->height * pix->bytesperline;
>
> In non-JPEG case you don't have to calculate bytesperline and sizeimage,
> as lone as what you need is the same, as what soc_camera_try_fmt()
> calculates for you.
>[Kassey] remove JPEG case, until we figure  out  a better idea.
>> +
>> +     /* limit to sensor capabilities */
>> +     mf.width = pix->width;
>> +     mf.height = pix->height;
>> +     mf.field = pix->field;
>
> If your driver only supports progressive video, do
>
>        mf.field        = V4L2_FIELD_NONE;
>
> here, then, if the client forces it again to an interlaced type, you'll
> know for sure, that you cannot work with this client.
>[Kassey] Yes. updated as you suggested.
>> +     mf.colorspace = pix->colorspace;
>> +     mf.code = xlate->code;
>> +
>> +     ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     pix->width = mf.width;
>> +     pix->height = mf.height;
>> +     pix->colorspace = mf.colorspace;
>> +
>> +     switch (mf.field) {
>> +     case V4L2_FIELD_ANY:
>> +     case V4L2_FIELD_NONE:
>> +             pix->field = V4L2_FIELD_NONE;
>> +             break;
>> +     default:
>> +             dev_err(icd->dev.parent, "Field type %d unsupported.\n",
>> +                     mf.field);
>> +             return -EINVAL;
>> +     }
>> +
>> +     return ret;
>> +
>
> remove empty line
>[kassey] OK
>> +}
>> +
>> +static unsigned int mv_camera_poll(struct file *file, poll_table * pt)
>> +{
>> +     struct soc_camera_device *icd = file->private_data;
>> +
>> +     return vb2_poll(&icd->vb2_vidq, file, pt);
>> +}
>> +
>> +static int mv_camera_querycap(struct soc_camera_host *ici,
>> +                           struct v4l2_capability *cap)
>> +{
>> +     cap->version = KERNEL_VERSION(0, 2, 2);
>> +     cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>> +     strlcpy(cap->card, "Marvell.CCIC", sizeof(cap->card));
>> +     return 0;
>> +}
>> +
>> +static const struct soc_mbus_pixelfmt ccic_formats[] = {
>> +     {
>> +      .fourcc = V4L2_PIX_FMT_YUV422P,
>> +      .name = "YUV422PLANAR",
>> +      .bits_per_sample = 8,
>> +      .packing = SOC_MBUS_PACKING_2X8_PADLO,
>> +      .order = SOC_MBUS_ORDER_LE,
>> +      },
>
> Fix indentation, look at other drivers.
>[kassey] OK
>> +     {
>> +      .fourcc = V4L2_PIX_FMT_YUV420,
>> +      .name = "YUV420PLANAR",
>> +      .bits_per_sample = 12,
>> +      .packing = SOC_MBUS_PACKING_NONE,
>> +      .order = SOC_MBUS_ORDER_LE,
>> +      },
>> +     {
>> +      .fourcc = V4L2_PIX_FMT_UYVY,
>> +      .name = "YUV422PACKED",
>> +      .bits_per_sample = 8,
>> +      .packing = SOC_MBUS_PACKING_2X8_PADLO,
>> +      .order = SOC_MBUS_ORDER_LE,
>> +      },
>> +
>> +};
>> +
>> +static int mv_camera_get_formats(struct soc_camera_device *icd,
>> +                              unsigned int idx,
>> +                              struct soc_camera_format_xlate
>> +                              *xlate)
>> +{
>> +     struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +     struct device *dev = icd->dev.parent;
>> +     int formats = 0, ret;
>> +     enum v4l2_mbus_pixelcode code;
>> +     const struct soc_mbus_pixelfmt *fmt;
>> +     int i = 0;
>
> Move it to the "if (xlate)" block, where it's only used, and remove
> initialisation.
>[kassey] OK
>> +
>> +     ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
>> +     if (ret < 0)
>> +             /* No more formats */
>> +             return 0;
>> +
>> +     fmt = soc_mbus_get_fmtdesc(code);
>> +     if (!fmt) {
>> +             dev_err(dev, "Invalid format code #%u: %d\n", idx, code);
>
> dev_warn() is enough here, it's not a severe failure
>[kassey] OK
>> +             return 0;
>> +     }
>> +
>> +     switch (code) {
>> +             /* refer to mbus_fmt struct */
>> +     case V4L2_MBUS_FMT_YUYV8_2X8:
>> +             /* TODO: add support for YUV420 and YUV422P */
>> +             formats = ARRAY_SIZE(ccic_formats);
>> +
>> +             if (xlate) {
>> +                     for (i = 0; i < ARRAY_SIZE(ccic_formats); i++) {
>> +                             xlate->host_fmt = &ccic_formats[i];
>> +                             xlate->code = code;
>> +                             xlate++;
>> +                     }
>> +             }
>> +
>> +             break;
>> +     default:
>> +             /* camera controller can not support
>> +                this format, which might supported by the sensor
>> +              */
>
> multi-line comment
>[kassey] OK, updated.
>> +             dev_err(dev, "Not support fmt %s\n", fmt->name);
>> +             return 0;
>
> Hm, you don't support any pass-through formats? Only YUYV8_2X8? Then what
> is all that JPEG code about? If you don't support it, please, remove it
> completely.
>[kassey] OK
>> +     }
>> +
>> +     /* Generic pass-through */
>
> This is not a generic pass-through in your case - it just adds the
> standard YUYV8_2X8 to V4L2_PIX_FMT_YUYV conversion.
>[Kassey] Yes, you are right. do you mean remove this comments ?
>> +     formats++;
>> +     if (xlate) {
>> +             xlate->host_fmt = fmt;
>> +             xlate->code = code;
>> +             xlate++;
>> +     }
>> +
>> +     return formats;
>> +}
>> +
>> +static int mv_camera_enum_fsizes(struct soc_camera_device *icd,
>> +                              struct v4l2_frmsizeenum *fsizes)
>> +{
>> +     int ret;
>> +     struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +     const struct soc_camera_format_xlate *xlate;
>> +     __u32 pixfmt = fsizes->pixel_format;
>> +     struct v4l2_frmsizeenum *fsize_mbus = fsizes;
>> +
>> +     xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>> +     if (!xlate)
>> +             return -EINVAL;
>> +
>> +     /* map xlate-code to pixel_format, sensor only handle xlate-code */
>> +     fsize_mbus->pixel_format = xlate->code;
>> +
>> +     ret = v4l2_subdev_call(sd, video, enum_mbus_fsizes, fsize_mbus);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     fsizes->pixel_format = pixfmt;
>> +
>> +     return 0;
>> +}
>
> This seems to be an (almost) exact copy of default_enum_fsizes(), so, you
> don't need it, please, remove
>[kassey] OK, remove
>> +
>> +static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
>> +     .owner = THIS_MODULE,
>> +     .add = mv_camera_add_device,
>> +     .remove = mv_camera_remove_device,
>> +     .set_fmt = mv_camera_set_fmt,
>> +     .try_fmt = mv_camera_try_fmt,
>> +     .init_videobuf2 = mv_camera_init_videobuf,
>> +     .poll = mv_camera_poll,
>> +     .querycap = mv_camera_querycap,
>> +     .set_bus_param = mv_camera_set_bus_param,
>> +     .get_formats = mv_camera_get_formats,
>> +     .enum_fsizes = mv_camera_enum_fsizes,
>> +};
>> +
>> +static int __devinit mv_camera_probe(struct platform_device
>> +                                  *pdev)
>
> No need to break the line
>[kassey] OK
>> +{
>> +     struct mv_camera_dev *pcdev;
>> +     struct mv_cam_pdata *mcam;
>> +     struct resource *res;
>> +     void __iomem *base;
>> +     int irq;
>> +     int err = 0;
>
> After a slight code reorganisation, this "= 0" is unneeded
>
>> +     int i = 0;
>
> unneeded init
>[kassey] OK
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     irq = platform_get_irq(pdev, 0);
>> +     if (!res || irq < 0) {
>> +             err = -ENODEV;
>> +             goto exit;
>
> Just return -ENODEV here.
>[kassey] OK
>> +     }
>> +     pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
>> +     if (!pcdev) {
>> +             dev_err(&pdev->dev, "Could not allocate pcdev\n");
>> +             err = -ENOMEM;
>> +             goto exit;
>
> return -ENOMEM
>[kassey] OK
>> +     }
>> +
>> +     /* allocate dummy buffer */
>> +     pcdev->dummy_buf_virt =
>> +         (void *)__get_free_pages(GFP_KERNEL, get_order(dma_buf_size));
>> +     if (!pcdev->dummy_buf_virt) {
>> +             dev_err(&pdev->dev, "Can't get memory for dummy buffer\n");
>> +             err = -ENOMEM;
>> +             goto exit_kfree;
>> +     } else {
>> +             pcdev->dummy_buf_phy = __pa(pcdev->dummy_buf_virt);
>> +     }
>
> Please, use dma_alloc_coherent()
>[kassey] OK
>> +
>> +     pcdev->res = res;
>> +     pcdev->pdev = pdev;
>> +
>> +     mcam = (struct mv_cam_pdata *)pdev->dev.platform_data;
>
> Superfluous cast, and you can (and should) check
>
>        if (!mcam || !mcam->clk_init)
>                return -EINVAL;
>
> at the very beginning of this function. Although, do all platforms really
> have to provide a clock-init callback?
>[kassey] OK, check the callback here.
>> +     if (mcam->clk_init)
>> +             err = mcam->clk_init(&pdev->dev, 1);
>> +     else
>> +             goto exit_clk;
>> +
>> +     if (err)
>> +             goto exit_clk;
>> +
>> +     INIT_LIST_HEAD(&pcdev->capture);
>> +     INIT_LIST_HEAD(&pcdev->sb_dma);
>> +
>> +     spin_lock_init(&pcdev->list_lock);
>> +
>> +     /*
>> +      * Request the regions.
>> +      */
>> +     if (!request_mem_region
>> +         (res->start, resource_size(res), MV_CAM_DRV_NAME)) {
>
> hmm, this might be a matter of taste, but I really would much prefer
> something like
>
> +       if (!request_mem_region(res->start, resource_size(res),
> +                               MV_CAM_DRV_NAME)) {
>
> is easier to read imho
>[kassey] OK
>> +             err = -EBUSY;
>> +             dev_err(&pdev->dev, "request_mem_region resource failed\n");
>> +             goto exit_release;
>> +     }
>> +
>> +     base = ioremap(res->start, resource_size(res));
>> +     if (!base) {
>> +             err = -ENOMEM;
>> +             dev_err(&pdev->dev, "ioremap resource failed\n");
>> +             goto exit_iounmap;
>> +     }
>> +     pcdev->irq = irq;
>> +     pcdev->base = base;
>> +     /* request irq */
>> +     err = request_irq(pcdev->irq, mv_camera_irq, 0, MV_CAM_DRV_NAME, pcdev);
>> +     if (err) {
>> +             dev_err(&pdev->dev, "Camera interrupt register failed\n");
>> +             goto exit_free_irq;
>> +     }
>> +
>> +     /* setup dma with dummy_buf_phy firstly */
>> +     for (i = 0; i < 3; i++) {
>> +             ccic_reg_write(pcdev, REG_Y0BAR + (i << 2),
>> +                            pcdev->dummy_buf_phy);
>> +             ccic_reg_write(pcdev, REG_U0BAR + (i << 2),
>> +                            pcdev->dummy_buf_phy);
>> +             ccic_reg_write(pcdev, REG_V0BAR + (i << 2),
>> +                            pcdev->dummy_buf_phy);
>> +     }
>
> Do these buffers get used immediately? If so, don't you also have to
> configure sizes?
>[kassey]No, they will be use after streamon, then the size is already configured.
>> +
>> +     ccic_enable_clk(pcdev);
>> +     /*
>> +      * Initialize the controller and leave it powered up.  It will
>> +      * stay that way until the sensor driver shows up.
>> +      */
>
> hm, why this? it should suffice to power up in mv_camera_add_device().
>[kassey] OK moved
>> +     ccic_init(pcdev);
>> +     ccic_power_up(pcdev);
>> +     pcdev->soc_host.drv_name = MV_CAM_DRV_NAME;
>> +     pcdev->soc_host.ops = &pxa_soc_camera_host_ops;
>> +     pcdev->soc_host.priv = pcdev;
>> +     pcdev->soc_host.v4l2_dev.dev = &pdev->dev;
>> +     pcdev->soc_host.nr = pdev->id;
>> +     err = soc_camera_host_register(&pcdev->soc_host);
>> +     if (err)
>> +             goto exit_free_irq;
>> +     return 0;
>> +
>> +exit_free_irq:
>> +     free_irq(pcdev->irq, pcdev);
>> +     ccic_power_down(pcdev);
>> +exit_iounmap:
>> +     iounmap(base);
>> +exit_release:
>> +     release_mem_region(res->start, resource_size(res));
>> +exit_clk:
>> +     mcam->clk_init(&pdev->dev, 0);
>> +exit_kfree:
>> +     /* free dummy buffer */
>> +     if (pcdev->dummy_buf_virt)
>> +             free_pages((unsigned long)pcdev->dummy_buf_virt,
>> +                        get_order(dma_buf_size));
>
> dma_free_coherent()
>[kassey] OK
>> +     kfree(pcdev);
>> +exit:
>> +     return err;
>> +}
>> +
>> +static int mv_camera_remove(struct platform_device
>
> __devexit
>
>> +                         *pdev)
>
> Same line
>[kassey] OK
>> +{
>> +
>> +     struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
>> +     struct mv_camera_dev *pcdev = container_of(soc_host,
>> +                                                struct
>> +                                                mv_camera_dev,
>> +                                                soc_host);
>
> Also, just make two lines
>[kassey] OK
>> +     struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
>> +     struct resource *res;
>> +
>> +     mcam->clk_init(&pdev->dev, 0);
>> +     free_irq(pcdev->irq, pcdev);
>> +
>> +     soc_camera_host_unregister(soc_host);
>> +
>> +     iounmap(pcdev->base);
>> +
>> +     res = pcdev->res;
>> +     release_mem_region(res->start, resource_size(res));
>> +
>> +     kfree(pcdev);
>> +
>> +     /* free dummy buffer */
>> +     if (pcdev->dummy_buf_virt)
>> +             free_pages((unsigned long)pcdev->dummy_buf_virt,
>> +                        get_order(dma_buf_size));
>> +
>> +     dev_info(&pdev->dev, "MV Camera driver unloaded\n");
>> +
>> +     return 0;
>> +}
>> +
>> +static struct platform_driver mv_camera_driver = {
>> +     .driver = {
>> +                .name = MV_CAM_DRV_NAME,
>> +                },
>
> The usual alignment would be
>[kassey] OK
> +       .driver = {
> +               .name = MV_CAM_DRV_NAME,
> +       },
>
>> +     .probe = mv_camera_probe,
>> +     .remove = mv_camera_remove,
>
> +       .remove = __devexit_p(mv_camera_remove),
>
>> +};
>> +
>> +static int __init mv_camera_init(void)
>> +{
>> +     return platform_driver_register(&mv_camera_driver);
>> +}
>> +
>> +static void __exit mv_camera_exit(void)
>> +{
>> +     platform_driver_unregister(&mv_camera_driver);
>> +}
>> +
>> +module_init(mv_camera_init);
>> +module_exit(mv_camera_exit);
>> +
>> +MODULE_DESCRIPTION("Marvell CCIC driver");
>> +MODULE_AUTHOR("Kassey Lee <ygli@marvell.com>");
>> +MODULE_LICENSE("GPL");
>> --
>> 1.7.4.1
>>
>
> Looking forward to v2!
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
