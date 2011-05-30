Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50329 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1E3Gsv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 02:48:51 -0400
Received: by gwaa18 with SMTP id a18so1322103gwa.19
        for <linux-media@vger.kernel.org>; Sun, 29 May 2011 23:48:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306505267-4050-1-git-send-email-ygli@marvell.com>
References: <1306505267-4050-1-git-send-email-ygli@marvell.com>
Date: Mon, 30 May 2011 14:48:50 +0800
Message-ID: <BANLkTi=qSpxdsRVAkYU3y57ti33OBSt1gQ@mail.gmail.com>
Subject: Re: [PATCH] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
From: Kassey Lee <kassey1216@gmail.com>
To: hverkuil@xs4all.nl, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	arnd@arndb.de, laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, qingx@marvell.com,
	hzhuang1@marvell.com, leiwen@marvell.com,
	Kassey Lee <ygli@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch is to enable Marvell Mobile SoC PXA910 CMOS Cmera Interface
Controller driver support.
- Using soc-camera framework with videobuf2 dma-contig allocator
- Supporting video streaming of YUV packed format
- Tested on PXA910 TTC_DKB board  with OV5642

hi, Guennadi, Hans,
         as you suggested to prefer improved videobuf2, we converted
the Marvell SoC PXA910 CCIC driver from videobuf to videobuf2, and
verified OK.  would you please help to review ?
          thanks!



2011/5/27 Kassey Lee <ygli@marvell.com>:
> This driver exports a video device node per each CCIC
> (CMOS Camera Interface Controller)
> device contained in Marvell Mobile PXA910 SoC
> The driver is based on v4l2-mem2mem framework, and only
> USERPTR is supported.
>
> Signed-off-by: Kassey Lee <ygli@marvell.com>
> ---
>  arch/arm/mach-mmp/include/mach/camera.h |   33 +
>  drivers/media/video/Kconfig             |    7 +
>  drivers/media/video/Makefile            |    1 +
>  drivers/media/video/mv_camera.c         | 1120 +++++++++++++++++++++++++++++++
>  4 files changed, 1161 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mmp/include/mach/camera.h
>  create mode 100644 drivers/media/video/mv_camera.c
>
> diff --git a/arch/arm/mach-mmp/include/mach/camera.h b/arch/arm/mach-mmp/include/mach/camera.h
> new file mode 100644
> index 0000000..b008f3f
> --- /dev/null
> +++ b/arch/arm/mach-mmp/include/mach/camera.h
> @@ -0,0 +1,33 @@
> +/*
> + * Copyright (C) 2011, Marvell International Ltd.
> + *     Kassey Lee <ygli@marvell.com>
> + *     Angela Wan <jwan@marvell.com>
> + *     Lei Wen <leiwen@marvell.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#ifndef __ASM_ARCH_CAMERA_H__
> +#define __ASM_ARCH_CAMERA_H__
> +
> +#define MAX_CAM_CLK 3
> +struct mv_cam_pdata {
> +       struct clk *clk[MAX_CAM_CLK];
> +       char *name;
> +       int clk_enabled;
> +       int dphy[3];
> +       int bus_type;
> +       int dma_burst;
> +       int qos_req_min;
> +       int mclk_min;
> +       int mclk_src;
> +       int (*clk_init) (struct device *dev, int init);
> +       void (*set_clock) (struct device *dev, int on);
> +       int (*get_mclk_src) (int src);
> +};
> +
> +#endif
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 3be180b..3b7a70e 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -891,6 +891,13 @@ config VIDEO_MX3
>        ---help---
>          This is a v4l2 driver for the i.MX3x Camera Sensor Interface
>
> +config VIDEO_MV
> +       tristate "Marvell CMOS Camera Interface Controller driver"
> +       depends on VIDEO_DEV && CPU_PXA910 && SOC_CAMERA
> +       select VIDEOBUF2_DMA_CONTIG
> +       ---help---
> +         This is a v4l2 driver for the Marvell CCIC Interface
> +
>  config VIDEO_PXA27x
>        tristate "PXA27x Quick Capture Interface driver"
>        depends on VIDEO_DEV && PXA27x && SOC_CAMERA
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 9519160..373b706 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -161,6 +161,7 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM)   += soc_camera_platform.o
>  obj-$(CONFIG_VIDEO_MX1)                        += mx1_camera.o
>  obj-$(CONFIG_VIDEO_MX2)                        += mx2_camera.o
>  obj-$(CONFIG_VIDEO_MX3)                        += mx3_camera.o
> +obj-$(CONFIG_VIDEO_MV)                 += mv_camera.o
>  obj-$(CONFIG_VIDEO_PXA27x)             += pxa_camera.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)     += sh_mobile_csi2.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)      += sh_mobile_ceu_camera.o
> diff --git a/drivers/media/video/mv_camera.c b/drivers/media/video/mv_camera.c
> new file mode 100644
> index 0000000..1a8f73e
> --- /dev/null
> +++ b/drivers/media/video/mv_camera.c
> @@ -0,0 +1,1120 @@
> +/*
> + * V4L2 Driver for Marvell Mobile SoC PXA910 CCIC
> + * (CMOS Capture Interface Controller)
> + *
> + * Copyright (C) 2011, Marvell International Ltd.
> + *     Kassey Lee <ygli@marvell.com>
> + *     Angela Wan <jwan@marvell.com>
> + *     Lei Wen <leiwen@marvell.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/errno.h>
> +#include <linux/fs.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/mm.h>
> +#include <linux/time.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/slab.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-dev.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/soc_camera.h>
> +#include <media/soc_mediabus.h>
> +
> +#include <mach/camera.h>
> +#include "cafe_ccic-regs.h"
> +
> +/* Register definition for PXA910 */
> +
> +#define REG_U0BAR       0x0c
> +#define REG_U1BAR       0x10
> +#define REG_U2BAR       0x14
> +#define REG_V0BAR       0x18
> +#define REG_V1BAR       0x1C
> +#define REG_V2BAR       0x20
> +
> +/* for MIPI enable */
> +#define REG_CSI2_CTRL0  0x100
> +#define REG_CSI2_DPHY0  0x120
> +#define REG_CSI2_DPHY1  0x124
> +#define REG_CSI2_DPHY2  0x128
> +#define REG_CSI2_DPHY3  0x12c
> +#define REG_CSI2_DPHY4  0x130
> +#define REG_CSI2_DPHY5  0x134
> +#define REG_CSI2_DPHY6  0x138
> +/* REG_CTRL0 */
> +#define   CO_EOF_VSYNC    (1 << 22)    /*generate eof by VSYNC */
> +#define   C0_VEDGE_CTRL   (1 << 23)    /*VYSNC polarity */
> +/* IRQ FLAG */
> +#define   FRAMEIRQS_EOF          (IRQ_EOF0|IRQ_EOF1|IRQ_EOF2 | IRQ_OVERFLOW)
> +
> +#define MV_CAM_DRV_NAME "mv-camera"
> +
> +#define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
> +       ((x) >> 24) & 0xff
> +
> +static int dma_buf_size = 480 * 720 * 2;       /* D1 size */
> +
> +struct yuv_pointer_t {
> +       dma_addr_t y;
> +       dma_addr_t u;
> +       dma_addr_t v;
> +};
> +
> +/* buffer for one video frame */
> +struct mv_buffer {
> +       /* common v4l buffer stuff -- must be first */
> +       struct vb2_buffer vb;
> +       struct yuv_pointer_t yuv_p;
> +       dma_addr_t dma_handles;
> +       struct list_head queue;
> +       size_t bsize;
> +};
> +
> +struct mv_camera_dev {
> +       struct soc_camera_host soc_host;
> +
> +       struct soc_camera_device *icd;
> +       unsigned int irq;
> +       void __iomem *base;
> +
> +       struct platform_device *pdev;
> +       struct resource *res;
> +
> +       struct list_head capture;
> +       struct list_head sb_dma;        /* dma list (dev_lock) */
> +
> +       spinlock_t list_lock;
> +       struct v4l2_pix_format pix_format;
> +       /*
> +        * internal use only
> +        * dummy buffer is used when available
> +        * buffer for DMA is less than 3
> +        */
> +       void *dummy_buf_virt;
> +       dma_addr_t dummy_buf_phy;
> +
> +       unsigned int width;
> +       unsigned int height;
> +};
> +
> +/*
> + * Device register I/O
> + */
> +static inline void ccic_reg_write(struct mv_camera_dev *pcdev,
> +                                 unsigned int reg, unsigned int val)
> +{
> +       iowrite32(val, pcdev->base + reg);
> +}
> +
> +static inline unsigned int ccic_reg_read(struct mv_camera_dev *pcdev,
> +                                        unsigned int reg)
> +{
> +       return ioread32(pcdev->base + reg);
> +}
> +
> +static inline void ccic_reg_write_mask(struct mv_camera_dev *pcdev,
> +                                      unsigned int reg, unsigned int val,
> +                                      unsigned int mask)
> +{
> +       unsigned int v = ccic_reg_read(pcdev, reg);
> +
> +       v = (v & ~mask) | (val & mask);
> +       ccic_reg_write(pcdev, reg, v);
> +}
> +
> +static inline void ccic_reg_clear_bit(struct mv_camera_dev *pcdev,
> +                                     unsigned int reg, unsigned int val)
> +{
> +       ccic_reg_write_mask(pcdev, reg, 0, val);
> +}
> +
> +static inline void ccic_reg_set_bit(struct mv_camera_dev *pcdev,
> +                                   unsigned int reg, unsigned int val)
> +{
> +       ccic_reg_write_mask(pcdev, reg, val, val);
> +}
> +
> +static void ccic_set_clock(struct mv_camera_dev *pcdev, unsigned int reg,
> +                          unsigned int val)
> +{
> +       ccic_reg_write(pcdev, reg, val);
> +}
> +
> +static int ccic_enable_clk(struct mv_camera_dev *pcdev)
> +{
> +       struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
> +       int div, ctrl1;
> +
> +       mcam->set_clock(&pcdev->pdev->dev, 1);
> +       div = mcam->get_mclk_src(mcam->mclk_src) / mcam->mclk_min;
> +       ccic_set_clock(pcdev, REG_CLKCTRL, (mcam->mclk_src << 29 | div));
> +       ctrl1 = 0x800003c;
> +       switch (mcam->dma_burst) {
> +       case 128:
> +               ctrl1 |= 1 << 25;
> +               break;
> +       case 256:
> +               ctrl1 |= 2 << 25;
> +               break;
> +       }
> +       ccic_set_clock(pcdev, REG_CTRL1, ctrl1);
> +       if (mcam->bus_type != SOCAM_MIPI)
> +               ccic_set_clock(pcdev, 0x1ec, 0x00004);
> +
> +       return 0;
> +}
> +
> +static void ccic_disable_clk(struct mv_camera_dev *pcdev)
> +{
> +       struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
> +
> +       mcam->set_clock(&pcdev->pdev->dev, 0);
> +       ccic_set_clock(pcdev, REG_CLKCTRL, 0x0);
> +       ccic_set_clock(pcdev, REG_CTRL1, 0x0);
> +}
> +
> +static int ccic_config_image(struct mv_camera_dev *pcdev)
> +{
> +       int ret = 0;
> +       int imgsz;
> +       unsigned int temp;
> +       struct v4l2_pix_format *fmt = &pcdev->pix_format;
> +       int widthy = 0, widthuv = 0;
> +       struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
> +
> +       dev_dbg(pcdev->soc_host.v4l2_dev.dev,
> +               KERN_ERR " %s %d bytesperline %d height %d\n", __func__,
> +               __LINE__, fmt->bytesperline,
> +               fmt->sizeimage / fmt->bytesperline);
> +       if (fmt->pixelformat == V4L2_PIX_FMT_YUV420) {
> +               imgsz =
> +                   ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
> +                   (((fmt->bytesperline)
> +                     * 4 / 3) & IMGSZ_H_MASK);
> +       } else if (fmt->pixelformat == V4L2_PIX_FMT_JPEG) {
> +               imgsz =
> +                   (((fmt->sizeimage /
> +                      fmt->bytesperline) << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
> +                   (fmt->bytesperline & IMGSZ_H_MASK);
> +
> +       } else {
> +               imgsz =
> +                   ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
> +                   (fmt->bytesperline & IMGSZ_H_MASK);
> +       }
> +       switch (fmt->pixelformat) {
> +       case V4L2_PIX_FMT_YUYV:
> +       case V4L2_PIX_FMT_UYVY:
> +               widthy = fmt->width * 2;
> +               widthuv = fmt->width * 2;
> +               break;
> +       case V4L2_PIX_FMT_RGB565:
> +               widthy = fmt->width * 2;
> +               widthuv = 0;
> +               break;
> +       case V4L2_PIX_FMT_JPEG:
> +               widthy = fmt->bytesperline;
> +               widthuv = fmt->bytesperline;
> +               break;
> +       case V4L2_PIX_FMT_YUV422P:
> +               widthy = fmt->width;
> +               widthuv = fmt->width / 2;
> +               break;
> +       case V4L2_PIX_FMT_YUV420:
> +               widthy = fmt->width;
> +               widthuv = fmt->width / 2;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       ccic_reg_write(pcdev, REG_IMGPITCH, widthuv << 16 | widthy);
> +       ccic_reg_write(pcdev, REG_IMGSIZE, imgsz);
> +       ccic_reg_write(pcdev, REG_IMGOFFSET, 0x0);
> +       /*
> +        * Tell the controller about the image format we are using.
> +        */
> +       switch (pcdev->pix_format.pixelformat) {
> +       case V4L2_PIX_FMT_YUV422P:
> +               ccic_reg_write_mask(pcdev, REG_CTRL0,
> +                                   C0_DF_YUV | C0_YUV_PLANAR |
> +                                   C0_YUVE_YVYU, C0_DF_MASK);
> +               break;
> +       case V4L2_PIX_FMT_YUV420:
> +               ccic_reg_write_mask(pcdev, REG_CTRL0,
> +                                   C0_DF_YUV | C0_YUV_420PL |
> +                                   C0_YUVE_YVYU, C0_DF_MASK);
> +               break;
> +
> +       case V4L2_PIX_FMT_YUYV:
> +               ccic_reg_write_mask(pcdev, REG_CTRL0,
> +                                   C0_DF_YUV | C0_YUV_PACKED |
> +                                   C0_YUVE_YUYV, C0_DF_MASK);
> +               break;
> +       case V4L2_PIX_FMT_UYVY:
> +               ccic_reg_write_mask(pcdev, REG_CTRL0,
> +                                   C0_DF_YUV | C0_YUV_PACKED |
> +                                   C0_YUVE_UYVY, C0_DF_MASK);
> +               break;
> +       case V4L2_PIX_FMT_JPEG:
> +               if (mcam->bus_type == SOCAM_MIPI)
> +                       ccic_reg_write_mask(pcdev, REG_CTRL0,
> +                                           C0_DF_RGB | C0_RGB_BGR |
> +                                           C0_RGB4_BGRX, C0_DF_MASK);
> +               else
> +                       ccic_reg_write_mask(pcdev, REG_CTRL0,
> +                                           C0_DF_YUV | C0_YUV_PACKED |
> +                                           C0_YUVE_YUYV, C0_DF_MASK);
> +               break;
> +       case V4L2_PIX_FMT_RGB444:
> +               ccic_reg_write_mask(pcdev, REG_CTRL0,
> +                                   C0_DF_RGB | C0_RGBF_444 |
> +                                   C0_RGB4_XRGB, C0_DF_MASK);
> +               break;
> +
> +       case V4L2_PIX_FMT_RGB565:
> +               ccic_reg_write_mask(pcdev, REG_CTRL0,
> +                                   C0_DF_RGB | C0_RGBF_565 |
> +                                   C0_RGB5_BGGR, C0_DF_MASK);
> +               break;
> +
> +       default:
> +               dev_dbg(pcdev->soc_host.v4l2_dev.dev, "Unknown format %x\n",
> +                       pcdev->pix_format.pixelformat);
> +               break;
> +       }
> +       ccic_reg_write_mask(pcdev, REG_CTRL0, C0_SIF_HVSYNC, C0_SIFM_MASK);
> +       /*
> +        * This field controls the generation of EOF(DVP only)
> +        */
> +       if (mcam->bus_type != SOCAM_MIPI) {
> +               temp = ccic_reg_read(pcdev, REG_CTRL0);
> +               temp |= CO_EOF_VSYNC | C0_VEDGE_CTRL;
> +               ccic_reg_write(pcdev, REG_CTRL0, temp);
> +       }
> +
> +       return ret;
> +}
> +
> +static void ccic_irq_enable(struct mv_camera_dev *pcdev)
> +{
> +       ccic_reg_write(pcdev, REG_IRQSTAT, FRAMEIRQS_EOF);
> +       ccic_reg_set_bit(pcdev, REG_IRQMASK, FRAMEIRQS_EOF);
> +}
> +
> +static void ccic_irq_disable(struct mv_camera_dev *pcdev)
> +{
> +       ccic_reg_clear_bit(pcdev, REG_IRQMASK, FRAMEIRQS_EOF);
> +}
> +
> +static void ccic_start(struct mv_camera_dev *pcdev)
> +{
> +       ccic_reg_set_bit(pcdev, REG_CTRL0, C0_ENABLE);
> +}
> +
> +static void ccic_stop(struct mv_camera_dev *pcdev)
> +{
> +       ccic_reg_clear_bit(pcdev, REG_CTRL0, C0_ENABLE);
> +}
> +
> +void ccic_init(struct mv_camera_dev *pcdev)
> +{
> +       /*
> +        * Make sure it's not powered down.
> +        */
> +       ccic_reg_clear_bit(pcdev, REG_CTRL1, C1_PWRDWN);
> +       /*
> +        * Turn off the enable bit.  It sure should be off anyway,
> +        * but it's good to be sure.
> +        */
> +       ccic_reg_clear_bit(pcdev, REG_CTRL0, C0_ENABLE);
> +       /*
> +        * Mask all interrupts.
> +        */
> +       ccic_reg_write(pcdev, REG_IRQMASK, 0);
> +}
> +
> +static void ccic_stop_dma(struct mv_camera_dev *pcdev)
> +{
> +       ccic_stop(pcdev);
> +       /*CSI2/DPHY need to be cleared, or no EOF will be received */
> +       ccic_reg_write(pcdev, REG_CSI2_DPHY3, 0x0);
> +       ccic_reg_write(pcdev, REG_CSI2_DPHY6, 0x0);
> +       ccic_reg_write(pcdev, REG_CSI2_DPHY5, 0x0);
> +       ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x0);
> +       /*
> +        * workaround when stop DMA controller!!!
> +        * 1) ccic controller must be stopped first,
> +        * and it shoud delay for one frame transfer time at least
> +        * 2)and then stop the camera sensor's output
> +        *
> +        * FIXME! need sillcion to add DMA stop/start bit
> +        */
> +       ccic_irq_disable(pcdev);
> +       mdelay(200);
> +}
> +
> +/*
> +* Power up and down.
> +*/
> +void ccic_power_up(struct mv_camera_dev *pcdev)
> +{
> +       ccic_reg_clear_bit(pcdev, REG_CTRL1, C1_PWRDWN);
> +}
> +
> +static void ccic_power_down(struct mv_camera_dev *pcdev)
> +{
> +       ccic_reg_set_bit(pcdev, REG_CTRL1, C1_PWRDWN);
> +}
> +
> +static void ccic_config_phy(struct mv_camera_dev *pcdev)
> +{
> +       struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
> +
> +       if (SOCAM_MIPI & mcam->bus_type) {
> +               ccic_reg_write(pcdev, REG_CSI2_DPHY3, mcam->dphy[0]);
> +               ccic_reg_write(pcdev, REG_CSI2_DPHY6, mcam->dphy[2]);
> +               ccic_reg_write(pcdev, REG_CSI2_DPHY5, mcam->dphy[1]);
> +               ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x43);
> +       } else {
> +               ccic_reg_write(pcdev, REG_CSI2_DPHY3, 0x0);
> +               ccic_reg_write(pcdev, REG_CSI2_DPHY6, 0x0);
> +               ccic_reg_write(pcdev, REG_CSI2_DPHY5, 0x0);
> +               ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x0);
> +       }
> +}
> +
> +static int mv_videobuf_setup(struct vb2_queue *vq,
> +                            unsigned int *count, unsigned int *num_planes,
> +                            unsigned long sizes[], void *alloc_ctxs[])
> +{
> +       struct soc_camera_device *icd =
> +           container_of(vq, struct soc_camera_device, vb2_vidq);
> +       int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +                                                    icd->
> +                                                    current_fmt->host_fmt);
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       struct mv_camera_dev *pcdev = ici->priv;
> +
> +       if (bytes_per_line < 0)
> +               return bytes_per_line;
> +
> +       *num_planes = 1;
> +       sizes[0] = bytes_per_line * icd->user_height;
> +
> +       if (icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_JPEG) {
> +               sizes[0] = pcdev->pix_format.sizeimage;
> +               bytes_per_line = pcdev->pix_format.bytesperline;
> +       }
> +
> +       dev_dbg(icd->dev.parent, "count=%d, size=%lu\n", *count, sizes[0]);
> +       return 0;
> +}
> +
> +static int mv_videobuf_prepare(struct vb2_buffer *vb)
> +{
> +       struct soc_camera_device *icd = container_of(vb->vb2_queue,
> +                                                    struct soc_camera_device,
> +                                                    vb2_vidq);
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       struct mv_camera_dev *pcdev = ici->priv;
> +       struct device *dev = pcdev->soc_host.v4l2_dev.dev;
> +       struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
> +       unsigned long size;
> +       int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +                                                    icd->
> +                                                    current_fmt->host_fmt);
> +
> +       dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__, vb,
> +               vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
> +       if (icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_JPEG)
> +               bytes_per_line = pcdev->pix_format.bytesperline;
> +
> +       if (bytes_per_line < 0)
> +               return bytes_per_line;
> +
> +       if (vb2_plane_size(vb, 0) & 31) {
> +               dev_err(dev, "buffer size is not 32 bytes aligned\n");
> +               BUG_ON(1);
> +       }
> +
> +       /* Added list head initialization on alloc */
> +       WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
> +
> +       BUG_ON(NULL == icd->current_fmt);
> +       size = icd->user_height * bytes_per_line;
> +       pcdev->height = icd->user_height;
> +       pcdev->width = icd->user_width;
> +       if (vb2_plane_size(vb, 0) < size) {
> +               dev_err(icd->dev.parent, "Buffer too small (%lu < %lu)\n",
> +                       vb2_plane_size(vb, 0), size);
> +               return -ENOBUFS;
> +       }
> +
> +       buf->bsize = vb2_plane_size(vb, 0);
> +       vb2_set_plane_payload(vb, 0, size);
> +       return 0;
> +}
> +
> +static void mv_videobuf_queue(struct vb2_buffer *vb)
> +{
> +       struct soc_camera_device *icd =
> +           container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       struct mv_camera_dev *pcdev = ici->priv;
> +       struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
> +       unsigned long flags;
> +
> +       dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
> +               vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
> +       buf->dma_handles = vb2_dma_contig_plane_paddr(vb, 0);
> +       if (!buf->dma_handles)
> +               BUG_ON(1);
> +
> +       if (pcdev->pix_format.pixelformat == V4L2_PIX_FMT_YUV422P) {
> +               buf->yuv_p.y = buf->dma_handles;
> +               buf->yuv_p.u = buf->yuv_p.y + pcdev->width * pcdev->height;
> +               buf->yuv_p.v = buf->yuv_p.u + pcdev->width * pcdev->height / 2;
> +       } else if (pcdev->pix_format.pixelformat == V4L2_PIX_FMT_YUV420) {
> +               buf->yuv_p.y = buf->dma_handles;
> +               buf->yuv_p.u = buf->yuv_p.y + pcdev->width * pcdev->height;
> +               buf->yuv_p.v = buf->yuv_p.u + pcdev->width * pcdev->height / 4;
> +       } else {
> +               buf->yuv_p.y = buf->dma_handles;
> +               buf->yuv_p.u = pcdev->dummy_buf_phy;
> +               buf->yuv_p.v = pcdev->dummy_buf_phy;
> +       }
> +
> +       spin_lock_irqsave(&pcdev->list_lock, flags);
> +       list_add_tail(&buf->queue, &pcdev->capture);
> +       spin_unlock_irqrestore(&pcdev->list_lock, flags);
> +}
> +
> +static void mv_videobuf_release(struct vb2_buffer *vb)
> +{
> +       struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
> +       struct soc_camera_device *icd =
> +           container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       struct mv_camera_dev *pcdev = ici->priv;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&pcdev->list_lock, flags);
> +       if (!list_empty(&buf->queue))
> +               list_del_init(&buf->queue);
> +       spin_unlock_irqrestore(&pcdev->list_lock, flags);
> +}
> +
> +static int mv_videobuf_init(struct vb2_buffer *vb)
> +{
> +       struct mv_buffer *buf = container_of(vb, struct mv_buffer, vb);
> +       INIT_LIST_HEAD(&buf->queue);
> +       return 0;
> +}
> +
> +static int mv_start_streaming(struct vb2_queue *vq)
> +{
> +       struct soc_camera_device *icd =
> +           container_of(vq, struct soc_camera_device, vb2_vidq);
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       struct mv_camera_dev *pcdev = ici->priv;
> +
> +       ccic_config_phy(pcdev);
> +       ccic_irq_enable(pcdev);
> +       ccic_start(pcdev);
> +       return 0;
> +}
> +
> +static int mv_stop_streaming(struct vb2_queue *vq)
> +{
> +       struct soc_camera_device *icd =
> +           container_of(vq, struct soc_camera_device, vb2_vidq);
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       struct mv_camera_dev *pcdev = ici->priv;
> +
> +       ccic_stop_dma(pcdev);
> +       return 0;
> +}
> +
> +static struct vb2_ops mv_videobuf_ops = {
> +       .queue_setup = mv_videobuf_setup,
> +       .buf_prepare = mv_videobuf_prepare,
> +       .buf_queue = mv_videobuf_queue,
> +       .buf_cleanup = mv_videobuf_release,
> +       .buf_init = mv_videobuf_init,
> +       .start_streaming = mv_start_streaming,
> +       .stop_streaming = mv_stop_streaming,
> +       .wait_prepare = soc_camera_unlock,
> +       .wait_finish = soc_camera_lock,
> +};
> +
> +static int mv_camera_init_videobuf(struct vb2_queue *q,
> +                                  struct soc_camera_device *icd)
> +{
> +       int ret = 0;
> +       struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +
> +       ret = v4l2_subdev_call(sd, core, load_fw);
> +       if (ret < 0)
> +               BUG_ON(1);
> +
> +       q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       q->io_modes = VB2_USERPTR;
> +       q->drv_priv = icd;
> +       q->ops = &mv_videobuf_ops;
> +       q->mem_ops = &vb2_dma_contig_memops;
> +       q->buf_struct_size = sizeof(struct mv_buffer);
> +
> +       return vb2_queue_init(q);
> +}
> +
> +static inline void ccic_dma_done(struct mv_camera_dev *pcdev, short frame)
> +{
> +       struct mv_buffer *buf = NULL;
> +       unsigned long flags = 0;
> +       dma_addr_t dma_base_reg = 0;
> +       struct mv_buffer *newbuf = NULL;
> +       unsigned long y, u, v;
> +
> +       spin_lock_irqsave(&pcdev->list_lock, flags);
> +       dma_base_reg = ccic_reg_read(pcdev, REG_Y0BAR + (frame << 2));
> +
> +       /* video buffer done */
> +       if (dma_base_reg != pcdev->dummy_buf_phy)
> +               list_for_each_entry(buf, &pcdev->sb_dma, queue) {
> +               if (dma_base_reg == buf->yuv_p.y) {
> +                       list_del_init(&buf->queue);
> +                       vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
> +                       break;
> +               }
> +               }
> +
> +       if (list_empty(&pcdev->capture)) {
> +               /* use dummy buffer when no video buffer available */
> +               y = u = v = pcdev->dummy_buf_phy;
> +       } else {
> +               newbuf =
> +                   list_entry(pcdev->capture.next, struct mv_buffer, queue);
> +               list_move_tail(&newbuf->queue, &pcdev->sb_dma);
> +
> +               y = newbuf->yuv_p.y;
> +               u = newbuf->yuv_p.u;
> +               v = newbuf->yuv_p.v;
> +       }
> +
> +       /* Setup DMA */
> +       ccic_reg_write(pcdev, REG_Y0BAR + (frame << 2), y);
> +       ccic_reg_write(pcdev, REG_U0BAR + (frame << 2), u);
> +       ccic_reg_write(pcdev, REG_V0BAR + (frame << 2), v);
> +
> +       spin_unlock_irqrestore(&pcdev->list_lock, flags);
> +}
> +
> +static irqreturn_t mv_camera_irq(int irq, void *data)
> +{
> +       struct mv_camera_dev *pcdev = data;
> +       unsigned int irqs;
> +       short frame = 0x0f;
> +
> +       irqs = ccic_reg_read(pcdev, REG_IRQSTAT);
> +       ccic_reg_write(pcdev, REG_IRQSTAT, irqs);
> +
> +       if (irqs & IRQ_EOF0)
> +               frame = 0;
> +       else if (irqs & IRQ_EOF1)
> +               frame = 1;
> +       else if (irqs & IRQ_EOF2)
> +               frame = 2;
> +       else
> +               frame = 0x0f;
> +       if (0x0f != frame)
> +               ccic_dma_done(pcdev, frame);
> +       return IRQ_HANDLED;
> +}
> +
> +static int mv_camera_add_device(struct soc_camera_device *icd)
> +{
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       struct mv_camera_dev *pcdev = ici->priv;
> +
> +       if (pcdev->icd)
> +               return -EBUSY;
> +
> +       pcdev->icd = icd;
> +       ccic_enable_clk(pcdev);
> +
> +       return 0;
> +}
> +
> +static void mv_camera_remove_device(struct soc_camera_device
> +                                   *icd)
> +{
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       struct mv_camera_dev *pcdev = ici->priv;
> +
> +       BUG_ON(icd != pcdev->icd);
> +
> +       ccic_disable_clk(pcdev);
> +       pcdev->icd = NULL;
> +}
> +
> +static int mv_camera_set_bus_param(struct soc_camera_device
> +                                  *icd, __u32 pixfmt)
> +{
> +       struct device *dev = icd->dev.parent;
> +       int ret = 0;
> +       unsigned long common_flags = 0;
> +
> +       common_flags = icd->ops->query_bus_param(icd);
> +
> +       ret = icd->ops->set_bus_param(icd, common_flags);
> +       if (ret < 0) {
> +               dev_err(dev, "%s %d\n", __func__, __LINE__);
> +               return ret;
> +       }
> +       return 0;
> +}
> +
> +static int mv_camera_set_fmt(struct soc_camera_device *icd,
> +                            struct v4l2_format *f)
> +{
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       struct mv_camera_dev *pcdev = ici->priv;
> +       struct device *dev = icd->dev.parent;
> +       struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +       const struct soc_camera_format_xlate *xlate = NULL;
> +       struct v4l2_mbus_framefmt mf;
> +       int ret = 0;
> +       struct v4l2_pix_format *pix = &f->fmt.pix;
> +
> +       memcpy(&(pcdev->pix_format), pix, sizeof(struct v4l2_pix_format));
> +       dev_err(dev, "S_FMT %c%c%c%c, %ux%u\n",
> +               pixfmtstr(pix->pixelformat), pix->width, pix->height);
> +       xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
> +       if (!xlate) {
> +               dev_err(dev, "Format %c%c%c%c not found\n",
> +                       pixfmtstr(pix->pixelformat));
> +               return -EINVAL;
> +       }
> +
> +       mf.width = pix->width;
> +       mf.height = pix->height;
> +       mf.field = pix->field;
> +       mf.colorspace = pix->colorspace;
> +       mf.code = xlate->code;
> +
> +       ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
> +       if (ret < 0) {
> +               dev_err(dev, "%s %d\n", __func__, __LINE__);
> +               return ret;
> +       }
> +       if (mf.code != xlate->code) {
> +               dev_err(dev, "%s %d\n", __func__, __LINE__);
> +               return -EINVAL;
> +       }
> +
> +       icd->sense = NULL;
> +
> +       pix->width = mf.width;
> +       pix->height = mf.height;
> +       pix->field = mf.field;
> +       pix->colorspace = mf.colorspace;
> +       icd->current_fmt = xlate;
> +
> +       ret = ccic_config_image(pcdev);
> +
> +       return ret;
> +}
> +
> +static int mv_camera_try_fmt(struct soc_camera_device *icd,
> +                            struct v4l2_format *f)
> +{
> +       struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +       struct device *dev = icd->dev.parent;
> +       const struct soc_camera_format_xlate *xlate;
> +       struct v4l2_pix_format *pix = &f->fmt.pix;
> +       struct v4l2_mbus_framefmt mf;
> +       __u32 pixfmt = pix->pixelformat;
> +       int ret;
> +
> +       xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +       if (!xlate) {
> +               dev_err(dev, "Format %c%c%c%c not found\n",
> +                       pixfmtstr(pix->pixelformat));
> +               return -EINVAL;
> +       }
> +
> +       pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
> +                                                   xlate->host_fmt);
> +       if (pix->bytesperline < 0)
> +               return pix->bytesperline;
> +       if (pix->pixelformat == V4L2_PIX_FMT_JPEG)
> +               pix->bytesperline = 2048;
> +       else
> +               pix->sizeimage = pix->height * pix->bytesperline;
> +
> +       /* limit to sensor capabilities */
> +       mf.width = pix->width;
> +       mf.height = pix->height;
> +       mf.field = pix->field;
> +       mf.colorspace = pix->colorspace;
> +       mf.code = xlate->code;
> +
> +       ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
> +       if (ret < 0)
> +               return ret;
> +
> +       pix->width = mf.width;
> +       pix->height = mf.height;
> +       pix->colorspace = mf.colorspace;
> +
> +       switch (mf.field) {
> +       case V4L2_FIELD_ANY:
> +       case V4L2_FIELD_NONE:
> +               pix->field = V4L2_FIELD_NONE;
> +               break;
> +       default:
> +               dev_err(icd->dev.parent, "Field type %d unsupported.\n",
> +                       mf.field);
> +               return -EINVAL;
> +       }
> +
> +       return ret;
> +
> +}
> +
> +static unsigned int mv_camera_poll(struct file *file, poll_table * pt)
> +{
> +       struct soc_camera_device *icd = file->private_data;
> +
> +       return vb2_poll(&icd->vb2_vidq, file, pt);
> +}
> +
> +static int mv_camera_querycap(struct soc_camera_host *ici,
> +                             struct v4l2_capability *cap)
> +{
> +       cap->version = KERNEL_VERSION(0, 2, 2);
> +       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +       strlcpy(cap->card, "Marvell.CCIC", sizeof(cap->card));
> +       return 0;
> +}
> +
> +static const struct soc_mbus_pixelfmt ccic_formats[] = {
> +       {
> +        .fourcc = V4L2_PIX_FMT_YUV422P,
> +        .name = "YUV422PLANAR",
> +        .bits_per_sample = 8,
> +        .packing = SOC_MBUS_PACKING_2X8_PADLO,
> +        .order = SOC_MBUS_ORDER_LE,
> +        },
> +       {
> +        .fourcc = V4L2_PIX_FMT_YUV420,
> +        .name = "YUV420PLANAR",
> +        .bits_per_sample = 12,
> +        .packing = SOC_MBUS_PACKING_NONE,
> +        .order = SOC_MBUS_ORDER_LE,
> +        },
> +       {
> +        .fourcc = V4L2_PIX_FMT_UYVY,
> +        .name = "YUV422PACKED",
> +        .bits_per_sample = 8,
> +        .packing = SOC_MBUS_PACKING_2X8_PADLO,
> +        .order = SOC_MBUS_ORDER_LE,
> +        },
> +
> +};
> +
> +static int mv_camera_get_formats(struct soc_camera_device *icd,
> +                                unsigned int idx,
> +                                struct soc_camera_format_xlate
> +                                *xlate)
> +{
> +       struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +       struct device *dev = icd->dev.parent;
> +       int formats = 0, ret;
> +       enum v4l2_mbus_pixelcode code;
> +       const struct soc_mbus_pixelfmt *fmt;
> +       int i = 0;
> +
> +       ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
> +       if (ret < 0)
> +               /* No more formats */
> +               return 0;
> +
> +       fmt = soc_mbus_get_fmtdesc(code);
> +       if (!fmt) {
> +               dev_err(dev, "Invalid format code #%u: %d\n", idx, code);
> +               return 0;
> +       }
> +
> +       switch (code) {
> +               /* refer to mbus_fmt struct */
> +       case V4L2_MBUS_FMT_YUYV8_2X8:
> +               /* TODO: add support for YUV420 and YUV422P */
> +               formats = ARRAY_SIZE(ccic_formats);
> +
> +               if (xlate) {
> +                       for (i = 0; i < ARRAY_SIZE(ccic_formats); i++) {
> +                               xlate->host_fmt = &ccic_formats[i];
> +                               xlate->code = code;
> +                               xlate++;
> +                       }
> +               }
> +
> +               break;
> +       default:
> +               /* camera controller can not support
> +                  this format, which might supported by the sensor
> +                */
> +               dev_err(dev, "Not support fmt %s\n", fmt->name);
> +               return 0;
> +       }
> +
> +       /* Generic pass-through */
> +       formats++;
> +       if (xlate) {
> +               xlate->host_fmt = fmt;
> +               xlate->code = code;
> +               xlate++;
> +       }
> +
> +       return formats;
> +}
> +
> +static int mv_camera_enum_fsizes(struct soc_camera_device *icd,
> +                                struct v4l2_frmsizeenum *fsizes)
> +{
> +       int ret;
> +       struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +       const struct soc_camera_format_xlate *xlate;
> +       __u32 pixfmt = fsizes->pixel_format;
> +       struct v4l2_frmsizeenum *fsize_mbus = fsizes;
> +
> +       xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +       if (!xlate)
> +               return -EINVAL;
> +
> +       /* map xlate-code to pixel_format, sensor only handle xlate-code */
> +       fsize_mbus->pixel_format = xlate->code;
> +
> +       ret = v4l2_subdev_call(sd, video, enum_mbus_fsizes, fsize_mbus);
> +       if (ret < 0)
> +               return ret;
> +
> +       fsizes->pixel_format = pixfmt;
> +
> +       return 0;
> +}
> +
> +static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
> +       .owner = THIS_MODULE,
> +       .add = mv_camera_add_device,
> +       .remove = mv_camera_remove_device,
> +       .set_fmt = mv_camera_set_fmt,
> +       .try_fmt = mv_camera_try_fmt,
> +       .init_videobuf2 = mv_camera_init_videobuf,
> +       .poll = mv_camera_poll,
> +       .querycap = mv_camera_querycap,
> +       .set_bus_param = mv_camera_set_bus_param,
> +       .get_formats = mv_camera_get_formats,
> +       .enum_fsizes = mv_camera_enum_fsizes,
> +};
> +
> +static int __devinit mv_camera_probe(struct platform_device
> +                                    *pdev)
> +{
> +       struct mv_camera_dev *pcdev;
> +       struct mv_cam_pdata *mcam;
> +       struct resource *res;
> +       void __iomem *base;
> +       int irq;
> +       int err = 0;
> +       int i = 0;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       irq = platform_get_irq(pdev, 0);
> +       if (!res || irq < 0) {
> +               err = -ENODEV;
> +               goto exit;
> +       }
> +       pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
> +       if (!pcdev) {
> +               dev_err(&pdev->dev, "Could not allocate pcdev\n");
> +               err = -ENOMEM;
> +               goto exit;
> +       }
> +
> +       /* allocate dummy buffer */
> +       pcdev->dummy_buf_virt =
> +           (void *)__get_free_pages(GFP_KERNEL, get_order(dma_buf_size));
> +       if (!pcdev->dummy_buf_virt) {
> +               dev_err(&pdev->dev, "Can't get memory for dummy buffer\n");
> +               err = -ENOMEM;
> +               goto exit_kfree;
> +       } else {
> +               pcdev->dummy_buf_phy = __pa(pcdev->dummy_buf_virt);
> +       }
> +
> +       pcdev->res = res;
> +       pcdev->pdev = pdev;
> +
> +       mcam = (struct mv_cam_pdata *)pdev->dev.platform_data;
> +       if (mcam->clk_init)
> +               err = mcam->clk_init(&pdev->dev, 1);
> +       else
> +               goto exit_clk;
> +
> +       if (err)
> +               goto exit_clk;
> +
> +       INIT_LIST_HEAD(&pcdev->capture);
> +       INIT_LIST_HEAD(&pcdev->sb_dma);
> +
> +       spin_lock_init(&pcdev->list_lock);
> +
> +       /*
> +        * Request the regions.
> +        */
> +       if (!request_mem_region
> +           (res->start, resource_size(res), MV_CAM_DRV_NAME)) {
> +               err = -EBUSY;
> +               dev_err(&pdev->dev, "request_mem_region resource failed\n");
> +               goto exit_release;
> +       }
> +
> +       base = ioremap(res->start, resource_size(res));
> +       if (!base) {
> +               err = -ENOMEM;
> +               dev_err(&pdev->dev, "ioremap resource failed\n");
> +               goto exit_iounmap;
> +       }
> +       pcdev->irq = irq;
> +       pcdev->base = base;
> +       /* request irq */
> +       err = request_irq(pcdev->irq, mv_camera_irq, 0, MV_CAM_DRV_NAME, pcdev);
> +       if (err) {
> +               dev_err(&pdev->dev, "Camera interrupt register failed\n");
> +               goto exit_free_irq;
> +       }
> +
> +       /* setup dma with dummy_buf_phy firstly */
> +       for (i = 0; i < 3; i++) {
> +               ccic_reg_write(pcdev, REG_Y0BAR + (i << 2),
> +                              pcdev->dummy_buf_phy);
> +               ccic_reg_write(pcdev, REG_U0BAR + (i << 2),
> +                              pcdev->dummy_buf_phy);
> +               ccic_reg_write(pcdev, REG_V0BAR + (i << 2),
> +                              pcdev->dummy_buf_phy);
> +       }
> +
> +       ccic_enable_clk(pcdev);
> +       /*
> +        * Initialize the controller and leave it powered up.  It will
> +        * stay that way until the sensor driver shows up.
> +        */
> +       ccic_init(pcdev);
> +       ccic_power_up(pcdev);
> +       pcdev->soc_host.drv_name = MV_CAM_DRV_NAME;
> +       pcdev->soc_host.ops = &pxa_soc_camera_host_ops;
> +       pcdev->soc_host.priv = pcdev;
> +       pcdev->soc_host.v4l2_dev.dev = &pdev->dev;
> +       pcdev->soc_host.nr = pdev->id;
> +       err = soc_camera_host_register(&pcdev->soc_host);
> +       if (err)
> +               goto exit_free_irq;
> +       return 0;
> +
> +exit_free_irq:
> +       free_irq(pcdev->irq, pcdev);
> +       ccic_power_down(pcdev);
> +exit_iounmap:
> +       iounmap(base);
> +exit_release:
> +       release_mem_region(res->start, resource_size(res));
> +exit_clk:
> +       mcam->clk_init(&pdev->dev, 0);
> +exit_kfree:
> +       /* free dummy buffer */
> +       if (pcdev->dummy_buf_virt)
> +               free_pages((unsigned long)pcdev->dummy_buf_virt,
> +                          get_order(dma_buf_size));
> +       kfree(pcdev);
> +exit:
> +       return err;
> +}
> +
> +static int mv_camera_remove(struct platform_device
> +                           *pdev)
> +{
> +
> +       struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
> +       struct mv_camera_dev *pcdev = container_of(soc_host,
> +                                                  struct
> +                                                  mv_camera_dev,
> +                                                  soc_host);
> +       struct mv_cam_pdata *mcam = pcdev->pdev->dev.platform_data;
> +       struct resource *res;
> +
> +       mcam->clk_init(&pdev->dev, 0);
> +       free_irq(pcdev->irq, pcdev);
> +
> +       soc_camera_host_unregister(soc_host);
> +
> +       iounmap(pcdev->base);
> +
> +       res = pcdev->res;
> +       release_mem_region(res->start, resource_size(res));
> +
> +       kfree(pcdev);
> +
> +       /* free dummy buffer */
> +       if (pcdev->dummy_buf_virt)
> +               free_pages((unsigned long)pcdev->dummy_buf_virt,
> +                          get_order(dma_buf_size));
> +
> +       dev_info(&pdev->dev, "MV Camera driver unloaded\n");
> +
> +       return 0;
> +}
> +
> +static struct platform_driver mv_camera_driver = {
> +       .driver = {
> +                  .name = MV_CAM_DRV_NAME,
> +                  },
> +       .probe = mv_camera_probe,
> +       .remove = mv_camera_remove,
> +};
> +
> +static int __init mv_camera_init(void)
> +{
> +       return platform_driver_register(&mv_camera_driver);
> +}
> +
> +static void __exit mv_camera_exit(void)
> +{
> +       platform_driver_unregister(&mv_camera_driver);
> +}
> +
> +module_init(mv_camera_init);
> +module_exit(mv_camera_exit);
> +
> +MODULE_DESCRIPTION("Marvell CCIC driver");
> +MODULE_AUTHOR("Kassey Lee <ygli@marvell.com>");
> +MODULE_LICENSE("GPL");
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
