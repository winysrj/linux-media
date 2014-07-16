Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:63761 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680AbaGPIkC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jul 2014 04:40:02 -0400
MIME-Version: 1.0
In-Reply-To: <1405447012-5340-2-git-send-email-balbi@ti.com>
References: <1405447012-5340-1-git-send-email-balbi@ti.com> <1405447012-5340-2-git-send-email-balbi@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 16 Jul 2014 09:39:28 +0100
Message-ID: <CA+V-a8tewb31Wv9g_yU45F4y9iNQ9opUXTEk=2KgdjjMFMPyXQ@mail.gmail.com>
Subject: Re: [RFC/PATCH 1/5] Media: platform: Add ti-vpfe driver for AM437x device
To: Felipe Balbi <balbi@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Tony Lindgren <tony@atomide.com>,
	Benoit Cousson <bcousson@baylibre.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
	Linux ARM Kernel Mailing List
	<linux-arm-kernel@lists.infradead.org>,
	linux-media <linux-media@vger.kernel.org>, archit@ti.com,
	"Etheridge, Darren" <detheridge@ti.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

Thanks for the patch. Please find some of the comments below.

On Tue, Jul 15, 2014 at 6:56 PM, Felipe Balbi <balbi@ti.com> wrote:
> From: Benoit Parrot <bparrot@ti.com>
>
> Add Video Processing Front End (VPFE) driver for AM43XX family of devices
> Driver supports the following:
> - Dual instances (AM43XX has two hardware instance)
> - V4L2 API using MMAP buffer access based on videobuf2 api
> - Asynchronous sensor/decoder sub device registration
>
> [detheridge@ti.com - fixed up for v3.14]
> [balbi@ti.com   - updated for v3.16-rc5
>                 - fixed v4l2-compliance
>                 - fixed a kernel crash
>                 - fixed checkpatch.pl ]
>
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Darren Etheridge <detheridge@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/media/platform/Kconfig                    |    1 +
>  drivers/media/platform/Makefile                   |    2 +
>  drivers/media/platform/ti-vpfe/Kconfig            |   12 +
>  drivers/media/platform/ti-vpfe/Makefile           |    2 +
>  drivers/media/platform/ti-vpfe/am437x_isif.c      | 1053 +++++++++
>  drivers/media/platform/ti-vpfe/am437x_isif.h      |  355 +++
>  drivers/media/platform/ti-vpfe/am437x_isif_regs.h |  144 ++
>  drivers/media/platform/ti-vpfe/vpfe_capture.c     | 2478 +++++++++++++++++++++
>  drivers/media/platform/ti-vpfe/vpfe_capture.h     |  263 +++
>  9 files changed, 4310 insertions(+)
>  create mode 100644 drivers/media/platform/ti-vpfe/Kconfig
>  create mode 100644 drivers/media/platform/ti-vpfe/Makefile
>  create mode 100644 drivers/media/platform/ti-vpfe/am437x_isif.c
>  create mode 100644 drivers/media/platform/ti-vpfe/am437x_isif.h
>  create mode 100644 drivers/media/platform/ti-vpfe/am437x_isif_regs.h
>  create mode 100644 drivers/media/platform/ti-vpfe/vpfe_capture.c
>  create mode 100644 drivers/media/platform/ti-vpfe/vpfe_capture.h
>
The ti-vpfe folder makes it kind of generic (drivers under
media/platform are platform specific.
for example the Davinci too has vpfe.

> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 8108c69..c119f0a 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -120,6 +120,7 @@ config VIDEO_S3C_CAMIF
>  source "drivers/media/platform/soc_camera/Kconfig"
>  source "drivers/media/platform/exynos4-is/Kconfig"
>  source "drivers/media/platform/s5p-tv/Kconfig"
> +source "drivers/media/platform/ti-vpfe/Kconfig"
>
>  endif # V4L_PLATFORM_DRIVERS
>
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index e5269da..bd6b321 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -52,3 +52,5 @@ obj-y += davinci/
>  obj-$(CONFIG_ARCH_OMAP)        += omap/
>
>  ccflags-y += -I$(srctree)/drivers/media/i2c
> +
> +obj-$(CONFIG_VIDEO_AM437X_VPFE)        += ti-vpfe/
> diff --git a/drivers/media/platform/ti-vpfe/Kconfig b/drivers/media/platform/ti-vpfe/Kconfig
> new file mode 100644
> index 0000000..6758bb7
> --- /dev/null
> +++ b/drivers/media/platform/ti-vpfe/Kconfig
> @@ -0,0 +1,12 @@
> +config VIDEO_AM437X_VPFE
> +       tristate "TI AM437x VPFE video capture driver"
> +       depends on VIDEO_V4L2 && ARCH_OMAP3
> +       select MEDIA_CONTROLLER
> +       select VIDEO_V4L2_SUBDEV_API
> +       select VIDEOBUF2_DMA_CONTIG
> +       help
> +          Support for AM437x Video Processing Front End based Video
> +          Capture Driver.
> +
> +          To compile this driver as a module, choose M here. The module
> +          will be called ti_vpfe.
> diff --git a/drivers/media/platform/ti-vpfe/Makefile b/drivers/media/platform/ti-vpfe/Makefile
> new file mode 100644
> index 0000000..0155cd8
> --- /dev/null
> +++ b/drivers/media/platform/ti-vpfe/Makefile
> @@ -0,0 +1,2 @@
> +ti-vpfe-y := am437x_isif.o vpfe_capture.o
> +obj-$(CONFIG_VIDEO_AM437X_VPFE) += ti-vpfe.o
> diff --git a/drivers/media/platform/ti-vpfe/am437x_isif.c b/drivers/media/platform/ti-vpfe/am437x_isif.c
> new file mode 100644
> index 0000000..1f4262b
> --- /dev/null
> +++ b/drivers/media/platform/ti-vpfe/am437x_isif.c
> @@ -0,0 +1,1053 @@
> +/*
> + * TI AM437x Image Sensor Interface
> + *
> + * Copyright (C) 2013 - 2014 Texas Instruments, Inc.
> + *
> + * Benoit Parrot <bparrot@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/uaccess.h>
> +#include <linux/videodev2.h>
> +#include <linux/gfp.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/clk-private.h>
> +#include <linux/pm_runtime.h>
> +#include "vpfe_capture.h"
> +
> +/*  Print Four-character-code (FOURCC) */
> +static char *print_fourcc(u32 fmt)
> +{
> +       static char code[5];
> +
> +       code[0] = (unsigned char)(fmt & 0xff);
> +       code[1] = (unsigned char)((fmt>>8) & 0xff);
> +       code[2] = (unsigned char)((fmt>>16) & 0xff);
> +       code[3] = (unsigned char)((fmt>>24) & 0xff);
> +       code[4] = '\0';
> +
> +       return code;
> +}
> +
> +/* Raw Bayer formats */
> +static u32 isif_raw_bayer_pix_formats[] = {
> +       V4L2_PIX_FMT_SBGGR8,
> +       V4L2_PIX_FMT_SBGGR16,
> +       V4L2_PIX_FMT_UYVY,
> +       V4L2_PIX_FMT_YUYV
> +};
> +
> +/* Raw YUV formats */
> +static u32 isif_raw_yuv_pix_formats[] = {
> +       V4L2_PIX_FMT_UYVY,
> +       V4L2_PIX_FMT_YUYV
> +};
> +
> +static inline u32 isif_read(struct vpfe_isif_device *isif,
> +               u32 offset)
> +{
> +       return readl(isif->isif_cfg.base_addr + offset);
> +}
> +
> +static inline void isif_write(struct vpfe_isif_device *isif,
> +               u32 val, u32 offset)
> +{
> +       writel(val, isif->isif_cfg.base_addr + offset);
> +}
> +
> +static void isif_enable(struct vpfe_isif_device *isif, int flag)
> +{
> +       unsigned int pcr = 0;
> +
> +       pcr = isif_read(isif, ISIF_PCR);
> +
> +       if (flag) { /* Enable */
> +               pcr = 1;
> +       } else { /* Disable */
> +               pcr = 0;
> +       }
> +
> +       dev_dbg(isif->isif_cfg.dev,
> +               "isif_enable(%d) pcr:%x\n", flag, pcr);
> +       isif_write(isif, pcr, ISIF_PCR);
> +}
> +static void isif_module_enable(struct vpfe_isif_device *isif, int flag)
> +{
> +       unsigned int cfg = 0;
> +
> +       cfg = isif_read(isif, ISIF_VPFE_CONFIG);
> +
> +       if (flag) { /* Enable */
> +               cfg = (ISIF_VPFE_CONFIG_VPFE_EN_ENABLE<<
> +                               ISIF_VPFE_CONFIG_VPFE_EN_SHIFT);
> +       } else { /* Disable */
> +               cfg &= ~(ISIF_VPFE_CONFIG_VPFE_EN_ENABLE<<
> +                               ISIF_VPFE_CONFIG_VPFE_EN_SHIFT);
> +       }
> +
> +       dev_dbg(isif->isif_cfg.dev,
> +               "isif_module_enable(%d) cfg:%x\n", flag, cfg);
> +       isif_write(isif, cfg, ISIF_VPFE_CONFIG);
> +}
> +
> +/*
> + * isif_setwin()
> + * This function will configure the window size
> + * to be capture in ISIF reg
> + */
> +static void isif_setwin(struct vpfe_isif_device *isif,
> +               struct v4l2_rect *image_win, enum isif_frmfmt frm_fmt, int bpp)
> +{
> +       int horz_start, horz_nr_pixels;
> +       int vert_start, vert_nr_lines;
> +       int val = 0, mid_img = 0;
> +
> +       dev_dbg(isif->isif_cfg.dev, "isif_setwin: %dx%d (WxH)\n",
> +               image_win->width, image_win->height);
> +       dev_dbg(isif->isif_cfg.dev, "isif_setwin: top %d left %d\n",
> +               image_win->top, image_win->left);
> +       /*
> +        * ppc - per pixel count. indicates how many pixels per cell
> +        * output to SDRAM. example, for ycbcr, it is one y and one c, so 2.
> +        * raw capture this is 1
> +        */
> +       horz_start = image_win->left * bpp;
> +       horz_nr_pixels = (image_win->width * bpp) - 1;
> +       isif_write(isif,
> +                  (horz_start << ISIF_HORZ_INFO_SPH_SHIFT) | horz_nr_pixels,
> +                  ISIF_HORZ_INFO);
> +
> +       vert_start = image_win->top;
> +
> +       if (frm_fmt == ISIF_FRMFMT_INTERLACED) {
> +               vert_nr_lines = (image_win->height >> 1) - 1;
> +               vert_start >>= 1;
> +               /* Since first line doesn't have any data */
> +               vert_start += 1;
> +               /* configure VDINT0 */
> +               val = (vert_start << ISIF_VDINT_VDINT0_SHIFT);
> +               isif_write(isif, val, ISIF_VDINT);
> +
> +       } else {
> +               /* Since first line doesn't have any data */
> +               vert_start += 1;
> +               vert_nr_lines = image_win->height - 1;
> +               /*
> +                * configure VDINT0 and VDINT1. VDINT1 will be at half
> +                * of image height
> +                */
> +               mid_img = vert_start + (image_win->height / 2);
> +               val = (vert_start << ISIF_VDINT_VDINT0_SHIFT) |
> +                   (mid_img & ISIF_VDINT_VDINT1_MASK);
> +               isif_write(isif, val, ISIF_VDINT);
> +       }
> +       isif_write(isif,
> +                  (vert_start << ISIF_VERT_START_SLV0_SHIFT) | vert_start,
> +                  ISIF_VERT_START);
> +       isif_write(isif, vert_nr_lines, ISIF_VERT_LINES);
> +       dev_dbg(isif->isif_cfg.dev, "End of isif_setwin...\n");
> +}
> +
> +static void isif_readregs(struct vpfe_isif_device *isif)
> +{
> +       dev_dbg(isif->isif_cfg.dev, "ALAW: 0x%x\n",
> +               isif_read(isif, ISIF_ALAW));
> +       dev_dbg(isif->isif_cfg.dev, "CLAMP: 0x%x\n",
> +               isif_read(isif, ISIF_CLAMP));
> +       dev_dbg(isif->isif_cfg.dev, "DCSUB: 0x%x\n",
> +               isif_read(isif, ISIF_DCSUB));
> +       dev_dbg(isif->isif_cfg.dev, "BLKCMP: 0x%x\n",
> +               isif_read(isif, ISIF_BLKCMP));
> +       dev_dbg(isif->isif_cfg.dev, "COLPTN: 0x%x\n",
> +               isif_read(isif, ISIF_COLPTN));
> +       dev_dbg(isif->isif_cfg.dev, "HSIZE_OFF: 0x%x\n",
> +               isif_read(isif, ISIF_HSIZE_OFF));
> +       dev_dbg(isif->isif_cfg.dev, "SDOFST: 0x%x\n",
> +               isif_read(isif, ISIF_SDOFST));
> +       dev_dbg(isif->isif_cfg.dev, "SYN_MODE: 0x%x\n",
> +               isif_read(isif, ISIF_SYN_MODE));
> +       dev_dbg(isif->isif_cfg.dev, "HORZ_INFO: 0x%x\n",
> +               isif_read(isif, ISIF_HORZ_INFO));
> +       dev_dbg(isif->isif_cfg.dev, "VERT_START: 0x%x\n",
> +               isif_read(isif, ISIF_VERT_START));
> +       dev_dbg(isif->isif_cfg.dev, "VERT_LINES: 0x%x\n",
> +               isif_read(isif, ISIF_VERT_LINES));
> +}
> +
> +static int validate_isif_param(struct vpfe_isif_device *isif,
> +       struct isif_config_params_raw *ccdcparam)
> +{
> +       if (ccdcparam->alaw.enable) {
> +               u8 max_gamma =
> +                       isif_gamma_width_max_bit(ccdcparam->alaw.gamma_wd);
> +               u8 max_data =
> +                       isif_data_size_max_bit(ccdcparam->data_sz);
> +
> +               if ((ccdcparam->alaw.gamma_wd > ISIF_GAMMA_BITS_09_0) ||
> +                   (ccdcparam->alaw.gamma_wd < ISIF_GAMMA_BITS_15_6) ||
> +                   (max_gamma > max_data)) {
> +                       dev_dbg(isif->isif_cfg.dev, "\nInvalid data line select");
> +                       return -1;
> +               }
> +       }
> +       return 0;
> +}
> +
> +static int isif_update_raw_params(struct vpfe_isif_device *isif,
> +       struct isif_config_params_raw *raw_params)
> +{
> +       struct isif_config_params_raw *config_params =
> +                               &isif->isif_cfg.bayer.config_params;
> +
> +       memcpy(config_params, raw_params, sizeof(*raw_params));
> +
> +       return 0;
> +}
> +
> +/*
> + * isif_restore_defaults()
> + * This function will write defaults to all ISIF registers
> + */
> +static void isif_restore_defaults(struct vpfe_isif_device *isif)
> +{
> +       int i;
> +
> +       /* disable ISIF */
> +       isif_enable(isif, 0);
> +       /* set all registers to default value */
> +       for (i = 4; i <= 0x94; i += 4)
> +               isif_write(isif, 0,  i);
> +       isif_write(isif, ISIF_NO_CULLING, ISIF_CULLING);
> +       isif_write(isif, ISIF_GAMMA_BITS_11_2, ISIF_ALAW);
> +}
> +
> +static int isif_intr_status(struct vpfe_isif_device *isif);
> +static void isif_clear_intr(struct vpfe_isif_device *isif, int vdint);
> +
> +static int isif_close(struct vpfe_isif_device *isif, struct device *dev)
> +{
> +       int dma_cntl, i, pcr;
> +
> +       dev_dbg(isif->isif_cfg.dev, "isif_close\n");
> +
> +       /* If the ISIF module is still busy wait for it to be done */
> +       i = 0;
> +       while (i++ < 10) {
> +               usleep_range(5000, 6000);
> +               pcr = isif_read(isif, ISIF_PCR);
> +               if (pcr) {
> +                       /* make sure it it is disabled */
> +                       isif_enable(isif, 0);
> +               } else {
> +                       break;
> +               }
> +       }
> +
> +       /* Disable ISIF by resetting all register to default POR values */
> +       isif_restore_defaults(isif);
> +
> +       /* if DMA_CNTL overflow bit is set. Clear it
> +        *  It appears to take a while for this to become quiescent ~20ms
> +        */
> +       i = 0;
> +       while (i++ < 10) {
> +               dma_cntl = isif_read(isif, ISIF_DMA_CNTL);
> +               if (dma_cntl & ISIF_DMA_CNTL_OVERFLOW) {
> +                       /* Clear the overflow bit */
> +                       isif_write(isif, dma_cntl, ISIF_DMA_CNTL);
> +                       usleep_range(5000, 6000);
> +               } else {
> +                       break;
> +               }
> +       }
> +
> +       /* Disabled the module at the CONFIG level */
> +       isif_module_enable(isif, 0);
> +
> +       pm_runtime_put_sync(dev);
> +       return 0;
> +}
> +
> +static int isif_open(struct vpfe_isif_device *isif, struct device *dev)
> +{
> +       dev_dbg(isif->isif_cfg.dev, "isif_open\n");
> +
> +       pm_runtime_get_sync(dev);
> +       isif_module_enable(isif, 1);
> +       isif_restore_defaults(isif);
> +
> +       return 0;
> +}
> +
> +/* Parameter operations */
> +static int isif_set_params(struct vpfe_isif_device *isif, void __user *params)
> +{
> +       struct isif_config_params_raw isif_raw_params;
> +       int x;
> +
> +       if (isif->isif_cfg.if_type != VPFE_RAW_BAYER)
> +               return -EINVAL;
> +
> +       x = copy_from_user(&isif_raw_params, params, sizeof(isif_raw_params));
> +       if (x) {
> +               dev_dbg(isif->isif_cfg.dev, "error copying ccdc params, %d\n", x);
> +               return -EFAULT;
> +       }
> +
> +       if (!validate_isif_param(isif, &isif_raw_params)) {
> +               if (!isif_update_raw_params(isif, &isif_raw_params))
> +                       return 0;
> +       }
> +       return -EINVAL;
> +}
> +
> +/*
> + * isif_config_ycbcr()
> + * This function will configure ISIF for YCbCr video capture
> + */
> +static void isif_config_ycbcr(struct vpfe_isif_device *isif)
> +{
> +       struct isif_params_ycbcr *params = &isif->isif_cfg.ycbcr;
> +       u32 syn_mode;
> +
> +       dev_dbg(isif->isif_cfg.dev, "isif_config_ycbcr:\n");
> +       /*
> +        * first restore the ISIF registers to default values
> +        * This is important since we assume default values to be set in
> +        * a lot of registers that we didn't touch
> +        */
> +       isif_restore_defaults(isif);
> +
> +       /*
> +        * configure pixel format, frame format, configure video frame
> +        * format, enable output to SDRAM, enable internal timing generator
> +        * and 8bit pack mode
> +        */
> +       syn_mode = (((params->pix_fmt & ISIF_SYN_MODE_INPMOD_MASK) <<
> +                   ISIF_SYN_MODE_INPMOD_SHIFT) |
> +                   ((params->frm_fmt & ISIF_SYN_FLDMODE_MASK) <<
> +                   ISIF_SYN_FLDMODE_SHIFT) | ISIF_VDHDEN_ENABLE |
> +                   ISIF_WEN_ENABLE | ISIF_DATA_PACK_ENABLE);
> +
> +       /* setup BT.656 sync mode */
> +       if (params->bt656_enable) {
> +               isif_write(isif, ISIF_REC656IF_BT656_EN, ISIF_REC656IF);
> +
> +               /*
> +                * configure the FID, VD, HD pin polarity,
> +                * fld,hd pol positive, vd negative, 8-bit data
> +                */
> +               syn_mode |= ISIF_SYN_MODE_VD_POL_NEGATIVE;
> +               if (isif->isif_cfg.if_type == VPFE_BT656_10BIT)
> +                       syn_mode |= ISIF_SYN_MODE_10BITS;
> +               else
> +                       syn_mode |= ISIF_SYN_MODE_8BITS;
> +       } else {
> +               /* y/c external sync mode */
> +               syn_mode |= (((params->fid_pol & ISIF_FID_POL_MASK) <<
> +                            ISIF_FID_POL_SHIFT) |
> +                            ((params->hd_pol & ISIF_HD_POL_MASK) <<
> +                            ISIF_HD_POL_SHIFT) |
> +                            ((params->vd_pol & ISIF_VD_POL_MASK) <<
> +                            ISIF_VD_POL_SHIFT));
> +       }
> +       isif_write(isif, syn_mode, ISIF_SYN_MODE);
> +
> +       /* configure video window */
> +       isif_setwin(isif, &params->win, params->frm_fmt, params->bytesperpixel);
> +
> +       /*
> +        * configure the order of y cb cr in SDRAM, and disable latch
> +        * internal register on vsync
> +        */
> +       if (isif->isif_cfg.if_type == VPFE_BT656_10BIT)
> +               isif_write(isif,
> +                          (params->pix_order << ISIF_CCDCFG_Y8POS_SHIFT) |
> +                          ISIF_LATCH_ON_VSYNC_DISABLE |
> +                          ISIF_CCDCFG_BW656_10BIT,
> +                          ISIF_CCDCFG);
> +       else
> +               isif_write(isif,
> +                          (params->pix_order << ISIF_CCDCFG_Y8POS_SHIFT) |
> +                          ISIF_LATCH_ON_VSYNC_DISABLE, ISIF_CCDCFG);
> +
> +       /*
> +        * configure the horizontal line offset. This should be a
> +        * on 32 byte boundary. So clear LSB 5 bits
> +        */
> +       isif_write(isif, params->bytesperline, ISIF_HSIZE_OFF);
> +
> +       /* configure the memory line offset */
> +       if (params->buf_type == ISIF_BUFTYPE_FLD_INTERLEAVED)
> +               /* two fields are interleaved in memory */
> +               isif_write(isif, ISIF_SDOFST_FIELD_INTERLEAVED, ISIF_SDOFST);
> +
> +       dev_dbg(isif->isif_cfg.dev, "\nEnd of isif_config_ycbcr...\n");
> +}
> +
> +static void isif_config_black_clamp(struct vpfe_isif_device *isif,
> +       struct isif_black_clamp *bclamp)
> +{
> +       u32 val;
> +
> +       if (!bclamp->enable) {
> +               /* configure DCSub */
> +               val = (bclamp->dc_sub) & ISIF_BLK_DC_SUB_MASK;
> +               isif_write(isif, val, ISIF_DCSUB);
> +               dev_dbg(isif->isif_cfg.dev,
> +                       "\nWriting 0x%x to DCSUB...\n", val);
> +               isif_write(isif, ISIF_CLAMP_DEFAULT_VAL, ISIF_CLAMP);
> +               dev_dbg(isif->isif_cfg.dev,
> +                       "\nWriting 0x0000 to CLAMP...\n");
> +               return;
> +       }
> +       /*
> +        * Configure gain,  Start pixel, No of line to be avg,
> +        * No of pixel/line to be avg, & Enable the Black clamping
> +        */
> +       val = ((bclamp->sgain & ISIF_BLK_SGAIN_MASK) |
> +              ((bclamp->start_pixel & ISIF_BLK_ST_PXL_MASK) <<
> +               ISIF_BLK_ST_PXL_SHIFT) |
> +              ((bclamp->sample_ln & ISIF_BLK_SAMPLE_LINE_MASK) <<
> +               ISIF_BLK_SAMPLE_LINE_SHIFT) |
> +              ((bclamp->sample_pixel & ISIF_BLK_SAMPLE_LN_MASK) <<
> +               ISIF_BLK_SAMPLE_LN_SHIFT) | ISIF_BLK_CLAMP_ENABLE);
> +       isif_write(isif, val, ISIF_CLAMP);
> +       dev_dbg(isif->isif_cfg.dev, "\nWriting 0x%x to CLAMP...\n", val);
> +       /* If Black clamping is enable then make dcsub 0 */
> +       isif_write(isif, ISIF_DCSUB_DEFAULT_VAL, ISIF_DCSUB);
> +       dev_dbg(isif->isif_cfg.dev, "\nWriting 0x00000000 to DCSUB...\n");
> +}
> +
> +static void isif_config_black_compense(struct vpfe_isif_device *isif,
> +       struct isif_black_compensation *bcomp)
> +{
> +       u32 val;
> +
> +       val = ((bcomp->b & ISIF_BLK_COMP_MASK) |
> +             ((bcomp->gb & ISIF_BLK_COMP_MASK) <<
> +              ISIF_BLK_COMP_GB_COMP_SHIFT) |
> +             ((bcomp->gr & ISIF_BLK_COMP_MASK) <<
> +              ISIF_BLK_COMP_GR_COMP_SHIFT) |
> +             ((bcomp->r & ISIF_BLK_COMP_MASK) <<
> +              ISIF_BLK_COMP_R_COMP_SHIFT));
> +       isif_write(isif, val, ISIF_BLKCMP);
> +}
> +
> +/*
> + * isif_config_raw()
> + * This function will configure ISIF for Raw capture mode
> + */
> +static void isif_config_raw(struct vpfe_isif_device *isif)
> +{
> +       struct isif_params_raw *params = &isif->isif_cfg.bayer;
> +       struct isif_config_params_raw *config_params =
> +                               &isif->isif_cfg.bayer.config_params;
> +       unsigned int syn_mode = 0;
> +       unsigned int val;
> +
> +       dev_dbg(isif->isif_cfg.dev, "isif_config_raw:\n");
> +
> +       /* Reset ISIF */
> +       isif_restore_defaults(isif);
> +
> +       /* Disable latching function registers on VSYNC  */
> +       isif_write(isif, ISIF_LATCH_ON_VSYNC_DISABLE, ISIF_CCDCFG);
> +
> +       /*
> +        * Configure the vertical sync polarity(SYN_MODE.VDPOL),
> +        * horizontal sync polarity (SYN_MODE.HDPOL), frame id polarity
> +        * (SYN_MODE.FLDPOL), frame format(progressive or interlace),
> +        * data size(SYNMODE.DATSIZ), &pixel format (Input mode), output
> +        * SDRAM, enable internal timing generator
> +        */
> +       syn_mode =
> +               (((params->vd_pol & ISIF_VD_POL_MASK) << ISIF_VD_POL_SHIFT) |
> +               ((params->hd_pol & ISIF_HD_POL_MASK) << ISIF_HD_POL_SHIFT) |
> +               ((params->fid_pol & ISIF_FID_POL_MASK) << ISIF_FID_POL_SHIFT) |
> +               ((params->frm_fmt & ISIF_FRM_FMT_MASK) << ISIF_FRM_FMT_SHIFT) |
> +               ((config_params->data_sz & ISIF_DATA_SZ_MASK) <<
> +               ISIF_DATA_SZ_SHIFT) |
> +               ((params->pix_fmt & ISIF_PIX_FMT_MASK) << ISIF_PIX_FMT_SHIFT) |
> +               ISIF_WEN_ENABLE | ISIF_VDHDEN_ENABLE);
> +
> +       /* Enable and configure aLaw register if needed */
> +       if (config_params->alaw.enable) {
> +               val = ((config_params->alaw.gamma_wd &
> +                     ISIF_ALAW_GAMMA_WD_MASK) | ISIF_ALAW_ENABLE);
> +               isif_write(isif, val, ISIF_ALAW);
> +               dev_dbg(isif->isif_cfg.dev, "\nWriting 0x%x to ALAW...\n", val);
> +       }
> +
> +       /* Configure video window */
> +       isif_setwin(isif, &params->win, params->frm_fmt, params->bytesperpixel);
> +
> +       /* Configure Black Clamp */
> +       isif_config_black_clamp(isif, &config_params->blk_clamp);
> +
> +       /* Configure Black level compensation */
> +       isif_config_black_compense(isif, &config_params->blk_comp);
> +
> +       /* If data size is 8 bit then pack the data */
> +       if ((config_params->data_sz == ISIF_DATA_8BITS) ||
> +           config_params->alaw.enable)
> +               syn_mode |= ISIF_DATA_PACK_ENABLE;
> +
> +       /* Configure the color pattern according to mt9t001 sensor */
> +/*     isif_write(isif, ISIF_COLPTN_VAL, ISIF_COLPTN);
> +       dev_dbg(isif->isif_cfg.dev, "\nWriting 0xBB11BB11 to COLPTN...\n"); */
> +
> +       /*
> +        * Configure Horizontal offset register. If pack 8 is enabled then
> +        * 1 pixel will take 1 byte
> +        */
> +
> +       isif_write(isif, params->bytesperline, ISIF_HSIZE_OFF);
> +       dev_dbg(isif->isif_cfg.dev, "Writing %d (%x) to HSIZE_OFF\n",
> +               params->bytesperline, params->bytesperline);
> +
> +       /* Set value for SDOFST */
> +       if (params->frm_fmt == ISIF_FRMFMT_INTERLACED) {
> +               if (params->image_invert_enable) {
> +                       /* For intelace inverse mode */
> +                       isif_write(isif, ISIF_INTERLACED_IMAGE_INVERT,
> +                                  ISIF_SDOFST);
> +                       dev_dbg(isif->isif_cfg.dev, "\nWriting 0x4B6D to SDOFST..\n");
> +               }
> +
> +               else {
> +                       /* For intelace non inverse mode */
> +                       isif_write(isif, ISIF_INTERLACED_NO_IMAGE_INVERT,
> +                                  ISIF_SDOFST);
> +                       dev_dbg(isif->isif_cfg.dev, "\nWriting 0x0249 to SDOFST..\n");
> +               }
> +       } else if (params->frm_fmt == ISIF_FRMFMT_PROGRESSIVE) {
> +               isif_write(isif, ISIF_PROGRESSIVE_NO_IMAGE_INVERT,
> +                          ISIF_SDOFST);
> +               dev_dbg(isif->isif_cfg.dev, "\nWriting 0x0000 to SDOFST...\n");
> +       }
> +
> +       isif_write(isif, syn_mode, ISIF_SYN_MODE);
> +       dev_dbg(isif->isif_cfg.dev,
> +               "\nWriting 0x%x to SYN_MODE...\n", syn_mode);
> +
> +       dev_dbg(isif->isif_cfg.dev, "end of isif_config_raw...\n");
> +       isif_readregs(isif);
> +}
> +
> +static int isif_configure(struct vpfe_isif_device *isif)
> +{
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER)
> +               isif_config_raw(isif);
> +       else
> +               isif_config_ycbcr(isif);
> +       return 0;
> +}
> +
> +static int isif_set_buftype(struct vpfe_isif_device *isif,
> +       enum isif_buftype buf_type)
> +{
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER)
> +               isif->isif_cfg.bayer.buf_type = buf_type;
> +       else
> +               isif->isif_cfg.ycbcr.buf_type = buf_type;
> +       return 0;
> +}
> +
> +static enum isif_buftype isif_get_buftype(struct vpfe_isif_device *isif)
> +{
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER)
> +               return isif->isif_cfg.bayer.buf_type;
> +
> +       return isif->isif_cfg.ycbcr.buf_type;
> +}
> +
> +static int isif_enum_pix(struct vpfe_isif_device *isif, u32 *pix, int i)
> +{
> +       int ret = -EINVAL;
> +
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER) {
> +               if (i < ARRAY_SIZE(isif_raw_bayer_pix_formats)) {
> +                       *pix = isif_raw_bayer_pix_formats[i];
> +                       ret = 0;
> +               }
> +       } else {
> +               if (i < ARRAY_SIZE(isif_raw_yuv_pix_formats)) {
> +                       *pix = isif_raw_yuv_pix_formats[i];
> +                       ret = 0;
> +               }
> +       }
> +       return ret;
> +}
> +
> +static int isif_set_pixel_format(struct vpfe_isif_device *isif, u32 pixfmt)
> +{
> +       dev_dbg(isif->isif_cfg.dev, "isif_set_pixel_format: if_type: %d, pixfmt:%s\n",
> +               isif->isif_cfg.if_type, print_fourcc(pixfmt));
> +
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER) {
> +               isif->isif_cfg.bayer.pix_fmt = ISIF_PIXFMT_RAW;
> +               /*
> +                * Need to clear it in case it was left on
> +                * after the last capture.
> +                */
> +               isif->isif_cfg.bayer.config_params.alaw.enable = 0;
> +
> +               switch (pixfmt) {
> +               case V4L2_PIX_FMT_SBGGR8:
> +                       isif->isif_cfg.bayer.config_params.alaw.enable = 1;
> +                       break;
> +               case V4L2_PIX_FMT_YUYV:
> +               case V4L2_PIX_FMT_UYVY:
> +               case V4L2_PIX_FMT_YUV420:
> +               case V4L2_PIX_FMT_NV12:
> +               case V4L2_PIX_FMT_RGB565X:
> +                       break; /* nothing for now */
> +               case V4L2_PIX_FMT_SBGGR16:
> +               default:
> +                       return -EINVAL;
> +               }
> +       } else {
> +               switch (pixfmt) {
> +               case V4L2_PIX_FMT_YUYV:
> +                       isif->isif_cfg.ycbcr.pix_order = ISIF_PIXORDER_YCBYCR;
> +                       break;
> +               case V4L2_PIX_FMT_UYVY:
> +                       isif->isif_cfg.ycbcr.pix_order = ISIF_PIXORDER_CBYCRY;
> +                       break;
> +               default:
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static u32 isif_get_pixel_format(struct vpfe_isif_device *isif)
> +{
> +       u32 pixfmt;
> +
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER) {
> +               pixfmt = V4L2_PIX_FMT_YUYV;
> +       } else {
> +               if (isif->isif_cfg.ycbcr.pix_order == ISIF_PIXORDER_YCBYCR)
> +                       pixfmt = V4L2_PIX_FMT_YUYV;
> +               else
> +                       pixfmt = V4L2_PIX_FMT_UYVY;
> +       }
> +
> +       return pixfmt;
> +}
> +
> +static int isif_set_image_window(struct vpfe_isif_device *isif,
> +       struct v4l2_rect *win, unsigned int bpp)
> +{
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER) {
> +               isif->isif_cfg.bayer.win = *win;
> +               isif->isif_cfg.bayer.bytesperpixel = bpp;
> +               isif->isif_cfg.bayer.bytesperline = ALIGN(win->width * bpp, 32);
> +       } else {
> +               isif->isif_cfg.ycbcr.win = *win;
> +               isif->isif_cfg.ycbcr.bytesperpixel = bpp;
> +               isif->isif_cfg.ycbcr.bytesperline = ALIGN(win->width * bpp, 32);
> +       }
> +
> +       return 0;
> +}
> +
> +static void isif_get_image_window(struct vpfe_isif_device *isif,
> +       struct v4l2_rect *win)
> +{
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER)
> +               *win = isif->isif_cfg.bayer.win;
> +       else
> +               *win = isif->isif_cfg.ycbcr.win;
> +}
> +
> +static unsigned int isif_get_line_length(struct vpfe_isif_device *isif)
> +{
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER)
> +               return isif->isif_cfg.bayer.bytesperline;
> +
> +       return isif->isif_cfg.ycbcr.bytesperline;
> +}
> +
> +static int isif_set_frame_format(struct vpfe_isif_device *isif,
> +       enum isif_frmfmt frm_fmt)
> +{
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER)
> +               isif->isif_cfg.bayer.frm_fmt = frm_fmt;
> +       else
> +               isif->isif_cfg.ycbcr.frm_fmt = frm_fmt;
> +
> +       return 0;
> +}
> +
> +static enum isif_frmfmt isif_get_frame_format(struct vpfe_isif_device *isif)
> +{
> +       if (isif->isif_cfg.if_type == VPFE_RAW_BAYER)
> +               return isif->isif_cfg.bayer.frm_fmt;
> +
> +       return isif->isif_cfg.ycbcr.frm_fmt;
> +}
> +
> +static int isif_getfid(struct vpfe_isif_device *isif)
> +{
> +       return (isif_read(isif, ISIF_SYN_MODE) >> 15) & 1;
> +}
> +
> +/* misc operations */
> +static inline void isif_setfbaddr(struct vpfe_isif_device *isif,
> +       unsigned long addr)
> +{
> +       isif_write(isif, addr & 0xffffffe0, ISIF_SDR_ADDR);
> +}
> +
> +static int isif_set_hw_if_params(struct vpfe_isif_device *isif,
> +       struct vpfe_hw_if_param *params)
> +{
> +       isif->isif_cfg.if_type = params->if_type;
> +
> +       switch (params->if_type) {
> +       case VPFE_BT656:
> +       case VPFE_YCBCR_SYNC_16:
> +       case VPFE_YCBCR_SYNC_8:
> +       case VPFE_BT656_10BIT:
> +               isif->isif_cfg.ycbcr.vd_pol = params->vdpol;
> +               isif->isif_cfg.ycbcr.hd_pol = params->hdpol;
> +               break;
> +       case VPFE_RAW_BAYER:
> +               isif->isif_cfg.bayer.vd_pol = params->vdpol;
> +               isif->isif_cfg.bayer.hd_pol = params->hdpol;
> +               if (params->bus_width == 10)
> +                       isif->isif_cfg.bayer.config_params.data_sz =
> +                               ISIF_DATA_10BITS;
> +               else
> +                       isif->isif_cfg.bayer.config_params.data_sz =
> +                               ISIF_DATA_8BITS;
> +               dev_dbg(isif->isif_cfg.dev, "params.bus_width: %d\n",
> +                       params->bus_width);
> +               dev_dbg(isif->isif_cfg.dev, "config_params.data_sz: %d\n",
> +                       isif->isif_cfg.bayer.config_params.data_sz);
> +               break;
> +
> +       default:
> +               /* TODO add support for raw bayer here */
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static void isif_save_context(struct vpfe_isif_device *isif)
> +{
> +       isif->isif_ctx[ISIF_PCR >> 2] = isif_read(isif, ISIF_PCR);
> +       isif->isif_ctx[ISIF_SYN_MODE >> 2] = isif_read(isif, ISIF_SYN_MODE);
> +       isif->isif_ctx[ISIF_HD_VD_WID >> 2] = isif_read(isif, ISIF_HD_VD_WID);
> +       isif->isif_ctx[ISIF_PIX_LINES >> 2] = isif_read(isif, ISIF_PIX_LINES);
> +       isif->isif_ctx[ISIF_HORZ_INFO >> 2] = isif_read(isif, ISIF_HORZ_INFO);
> +       isif->isif_ctx[ISIF_VERT_START >> 2] = isif_read(isif, ISIF_VERT_START);
> +       isif->isif_ctx[ISIF_VERT_LINES >> 2] = isif_read(isif, ISIF_VERT_LINES);
> +       isif->isif_ctx[ISIF_CULLING >> 2] = isif_read(isif, ISIF_CULLING);
> +       isif->isif_ctx[ISIF_HSIZE_OFF >> 2] = isif_read(isif, ISIF_HSIZE_OFF);
> +       isif->isif_ctx[ISIF_SDOFST >> 2] = isif_read(isif, ISIF_SDOFST);
> +       isif->isif_ctx[ISIF_SDR_ADDR >> 2] = isif_read(isif, ISIF_SDR_ADDR);
> +       isif->isif_ctx[ISIF_CLAMP >> 2] = isif_read(isif, ISIF_CLAMP);
> +       isif->isif_ctx[ISIF_DCSUB >> 2] = isif_read(isif, ISIF_DCSUB);
> +       isif->isif_ctx[ISIF_COLPTN >> 2] = isif_read(isif, ISIF_COLPTN);
> +       isif->isif_ctx[ISIF_BLKCMP >> 2] = isif_read(isif, ISIF_BLKCMP);
> +       isif->isif_ctx[ISIF_VDINT >> 2] = isif_read(isif, ISIF_VDINT);
> +       isif->isif_ctx[ISIF_ALAW >> 2] = isif_read(isif, ISIF_ALAW);
> +       isif->isif_ctx[ISIF_REC656IF >> 2] = isif_read(isif, ISIF_REC656IF);
> +       isif->isif_ctx[ISIF_CCDCFG >> 2] = isif_read(isif, ISIF_CCDCFG);
> +}
> +
> +static void isif_restore_context(struct vpfe_isif_device *isif)
> +{
> +       isif_write(isif, isif->isif_ctx[ISIF_SYN_MODE >> 2], ISIF_SYN_MODE);
> +       isif_write(isif, isif->isif_ctx[ISIF_HD_VD_WID >> 2], ISIF_HD_VD_WID);
> +       isif_write(isif, isif->isif_ctx[ISIF_PIX_LINES >> 2], ISIF_PIX_LINES);
> +       isif_write(isif, isif->isif_ctx[ISIF_HORZ_INFO >> 2], ISIF_HORZ_INFO);
> +       isif_write(isif, isif->isif_ctx[ISIF_VERT_START >> 2], ISIF_VERT_START);
> +       isif_write(isif, isif->isif_ctx[ISIF_VERT_LINES >> 2], ISIF_VERT_LINES);
> +       isif_write(isif, isif->isif_ctx[ISIF_CULLING >> 2], ISIF_CULLING);
> +       isif_write(isif, isif->isif_ctx[ISIF_HSIZE_OFF >> 2], ISIF_HSIZE_OFF);
> +       isif_write(isif, isif->isif_ctx[ISIF_SDOFST >> 2], ISIF_SDOFST);
> +       isif_write(isif, isif->isif_ctx[ISIF_SDR_ADDR >> 2], ISIF_SDR_ADDR);
> +       isif_write(isif, isif->isif_ctx[ISIF_CLAMP >> 2], ISIF_CLAMP);
> +       isif_write(isif, isif->isif_ctx[ISIF_DCSUB >> 2], ISIF_DCSUB);
> +       isif_write(isif, isif->isif_ctx[ISIF_COLPTN >> 2], ISIF_COLPTN);
> +       isif_write(isif, isif->isif_ctx[ISIF_BLKCMP >> 2], ISIF_BLKCMP);
> +       isif_write(isif, isif->isif_ctx[ISIF_VDINT >> 2], ISIF_VDINT);
> +       isif_write(isif, isif->isif_ctx[ISIF_ALAW >> 2], ISIF_ALAW);
> +       isif_write(isif, isif->isif_ctx[ISIF_REC656IF >> 2], ISIF_REC656IF);
> +       isif_write(isif, isif->isif_ctx[ISIF_CCDCFG >> 2], ISIF_CCDCFG);
> +       isif_write(isif, isif->isif_ctx[ISIF_PCR >> 2], ISIF_PCR);
> +}
> +
> +static void isif_clear_intr(struct vpfe_isif_device *isif, int vdint)
> +{
> +       unsigned int vpfe_int_status;
> +
> +       vpfe_int_status = isif_read(isif, ISIF_VPFE_IRQ_STATUS);
> +
> +       switch (vdint) {
> +       /* VD0 interrrupt */
> +       case ISIF_VPFE_VDINT0:
> +               vpfe_int_status &= ~ISIF_VPFE_VDINT0;
> +               vpfe_int_status |= ISIF_VPFE_VDINT0;
> +               break;
> +       /* VD1 interrrupt */
> +       case ISIF_VPFE_VDINT1:
> +               vpfe_int_status &= ~ISIF_VPFE_VDINT1;
> +               vpfe_int_status |= ISIF_VPFE_VDINT1;
> +               break;
> +       /* VD2 interrrupt */
> +       case ISIF_VPFE_VDINT2:
> +               vpfe_int_status &= ~ISIF_VPFE_VDINT2;
> +               vpfe_int_status |= ISIF_VPFE_VDINT2;
> +               break;
> +       /* Clear all interrrupts */
> +       default:
> +               vpfe_int_status &= ~(ISIF_VPFE_VDINT0 |
> +                               ISIF_VPFE_VDINT1 |
> +                               ISIF_VPFE_VDINT2);
> +               vpfe_int_status |= (ISIF_VPFE_VDINT0 |
> +                               ISIF_VPFE_VDINT1 |
> +                               ISIF_VPFE_VDINT2);
> +               break;
> +       }
> +       /* Clear specific VDINT from the status register */
> +       isif_write(isif, vpfe_int_status, ISIF_VPFE_IRQ_STATUS);
> +
> +       vpfe_int_status = isif_read(isif, ISIF_VPFE_IRQ_STATUS);
> +
> +       /* Acknowledge that we are done with all interrupts */
> +       isif_write(isif, 1, ISIF_VPFE_IRQ_EOI);
> +}
> +
> +static int isif_intr_status(struct vpfe_isif_device *isif)
> +{
> +       return isif_read(isif, ISIF_VPFE_IRQ_STATUS);
> +}
> +
> +static int isif_intr_enable(struct vpfe_isif_device *isif, int vdint)
> +{
> +       unsigned int intr;
> +
> +       dev_vdbg(isif->isif_cfg.dev, "isif_intr_enable(%d) ", vdint);
> +       isif_write(isif, vdint, ISIF_VPFE_IRQ_ENABLE_SET);
> +       intr = isif_read(isif, ISIF_VPFE_IRQ_ENABLE_SET);
> +       dev_vdbg(isif->isif_cfg.dev, "irq_enable_set: %x\n", intr);
> +
> +       return 0;
> +}
> +
> +static int isif_intr_disable(struct vpfe_isif_device *isif, int vdint)
> +{
> +       unsigned int intr;
> +
> +       dev_vdbg(isif->isif_cfg.dev, "isif_intr_disable(%d) ", vdint);
> +       isif_write(isif, vdint, ISIF_VPFE_IRQ_ENABLE_CLR);
> +       intr = isif_read(isif, ISIF_VPFE_IRQ_ENABLE_CLR);
> +       dev_vdbg(isif->isif_cfg.dev, "irq_enable_CLR: %x\n", intr);
> +
> +       return 0;
> +}
> +
> +int isif_remove(struct vpfe_isif_device *isif, struct platform_device *pdev)
> +{
> +       struct resource *res;
> +
> +       dev_vdbg(isif->isif_cfg.dev, "isif_remove\n");
> +
> +       pm_runtime_disable(&pdev->dev);
> +       iounmap(isif->isif_cfg.base_addr);
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (res)
> +               release_mem_region(res->start, resource_size(res));
> +
> +       return 0;
> +}
> +
> +int isif_suspend(struct vpfe_isif_device *isif, struct device *dev)
> +{
> +       dev_dbg(isif->isif_cfg.dev, "isif_suspend\n");
> +
> +       pm_runtime_get_sync(dev);
> +       isif_module_enable(isif, 1);
> +
> +       /* Save ISIF context */
> +       isif_save_context(isif);
> +
> +       /* Disable ISIF */
> +       isif_enable(isif, 0);
> +       isif_module_enable(isif, 0);
> +       /* Disable both master and slave clock */
> +       pm_runtime_put_sync(dev);
> +
> +       return 0;
> +}
> +
> +int isif_resume(struct vpfe_isif_device *isif, struct device *dev)
> +{
> +       dev_dbg(isif->isif_cfg.dev, "isif_resume\n");
> +
> +       /* Enable both master and slave clock */
> +       pm_runtime_get_sync(dev);
> +       isif_module_enable(isif, 1);
> +       /* Restore ISIF context */
> +       isif_restore_context(isif);
> +
> +       isif_module_enable(isif, 0);
> +       pm_runtime_put_sync(dev);
> +
> +       return 0;
> +}
> +
> +/*
> + * vpfe_isif_init() - Initialize V4L2 subdev and media entity
> + * @isif: VPFE isif module
> + * @pdev: Pointer to platform device structure.
> + * Return 0 on success and a negative error code on failure.
> + */
> +
> +static const struct isif_hw_ops isif_ops = {
> +       .open = isif_open,
> +       .close = isif_close,
> +       .enable = isif_enable,
> +       .set_hw_if_params = isif_set_hw_if_params,
> +       .set_params = isif_set_params,
> +       .configure = isif_configure,
> +       .set_buftype = isif_set_buftype,
> +       .get_buftype = isif_get_buftype,
> +       .enum_pix = isif_enum_pix,
> +       .set_pixel_format = isif_set_pixel_format,
> +       .get_pixel_format = isif_get_pixel_format,
> +       .set_frame_format = isif_set_frame_format,
> +       .get_frame_format = isif_get_frame_format,
> +       .set_image_window = isif_set_image_window,
> +       .get_image_window = isif_get_image_window,
> +       .get_line_length = isif_get_line_length,
> +       .setfbaddr = isif_setfbaddr,
> +       .getfid = isif_getfid,
> +       .clear_intr = isif_clear_intr,
> +       .intr_status = isif_intr_status,
> +       .intr_enable = isif_intr_enable,
> +       .intr_disable = isif_intr_disable,
> +};
> +

why are these exposed as function pointers ?

> +static void isif_config_defaults(struct vpfe_isif_device *isif)
> +{
> +       isif->isif_cfg.if_type = VPFE_RAW_BAYER;
> +
> +       isif->isif_cfg.ycbcr.pix_fmt = ISIF_PIXFMT_YCBCR_8BIT;
> +       isif->isif_cfg.ycbcr.frm_fmt = ISIF_FRMFMT_INTERLACED;
> +       isif->isif_cfg.ycbcr.fid_pol = VPFE_PINPOL_POSITIVE;
> +       isif->isif_cfg.ycbcr.vd_pol = VPFE_PINPOL_POSITIVE;
> +       isif->isif_cfg.ycbcr.hd_pol = VPFE_PINPOL_POSITIVE;
> +       isif->isif_cfg.ycbcr.pix_order = ISIF_PIXORDER_CBYCRY;
> +       isif->isif_cfg.ycbcr.buf_type = ISIF_BUFTYPE_FLD_INTERLEAVED;
> +       /* ISIF_WIN_PAL */
> +       isif->isif_cfg.ycbcr.win.left = 0;
> +       isif->isif_cfg.ycbcr.win.top = 0;
> +       isif->isif_cfg.ycbcr.win.width = 720;
> +       isif->isif_cfg.ycbcr.win.height = 576;
> +       isif->isif_cfg.ycbcr.bt656_enable = 1;
> +
> +       isif->isif_cfg.bayer.pix_fmt = ISIF_PIXFMT_RAW;
> +       isif->isif_cfg.bayer.frm_fmt = ISIF_FRMFMT_PROGRESSIVE;
> +       isif->isif_cfg.bayer.fid_pol = VPFE_PINPOL_POSITIVE;
> +       isif->isif_cfg.bayer.vd_pol = VPFE_PINPOL_POSITIVE;
> +       isif->isif_cfg.bayer.hd_pol = VPFE_PINPOL_POSITIVE;
> +       /* ISIF_WIN_SVGA */
> +       isif->isif_cfg.bayer.win.left = 0;
> +       isif->isif_cfg.bayer.win.top = 0;
> +       isif->isif_cfg.bayer.win.width = 800;
> +       isif->isif_cfg.bayer.win.height = 600;
> +       isif->isif_cfg.bayer.config_params.data_sz = ISIF_DATA_8BITS;
> +       isif->isif_cfg.bayer.config_params.alaw.gamma_wd = ISIF_GAMMA_BITS_09_0;
> +}
> +
> +int vpfe_isif_init(struct vpfe_isif_device *isif, struct platform_device *pdev)
> +{
> +       struct resource *res;
> +       int status = 0;
> +
> +       dev_dbg(&pdev->dev, "vpfe_isif_init\n");
> +
> +       if (!isif) {
> +               dev_err(&pdev->dev, "Failed to init isif device: isif is null\n");
> +               return -EFAULT;
> +       }
> +
> +       strncpy(isif->name, "AM437x ISIF", sizeof(isif->name));
> +       isif->owner = THIS_MODULE;
> +
> +       dev_dbg(&pdev->dev, "vpfe_isif_init: %s\n", isif->name);
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               status = -ENODEV;
> +               goto fail_nores;
> +       }
> +
> +       res = request_mem_region(res->start, resource_size(res), res->name);
> +       if (!res) {
> +               status = -EBUSY;
> +               goto fail_nores;
> +       }
> +
> +       isif->isif_cfg.base_addr =
> +                       ioremap_nocache(res->start, resource_size(res));
> +       if (!isif->isif_cfg.base_addr) {
> +               status = -ENOMEM;
> +               goto fail_nomem;
> +       }
> +

devm_ioremap_resource() instead ?


> +       /* not sure we still need this but keeping it for
> +        * 1st pass multi-instance mods
> +        */
> +       isif->isif_cfg.dev = &pdev->dev;
> +
> +       /* Enabling module functional clock */
> +       pm_runtime_enable(&pdev->dev);
> +
> +       /* for now just enable it here instead of waiting for the open */
> +       pm_runtime_get_sync(&pdev->dev);
> +
> +       /* Populate the function pointers table */
> +       isif->hw_ops = isif_ops;
> +       isif_config_defaults(isif);
> +       pm_runtime_put_sync(&pdev->dev);
> +
> +       return 0;
> +
> +fail_nomem:
> +       release_mem_region(res->start, resource_size(res));
> +fail_nores:
> +       isif_remove(isif, pdev);
> +       return status;
> +}
> +
> +/*
> + * vpfe_isif_cleanup - isif module cleanup
> + * @isif: pointer to isif subdevice
> + * @dev: pointer to platform device structure
> + */
> +void
> +vpfe_isif_cleanup(struct vpfe_isif_device *isif, struct platform_device *pdev)
> +{
> +       isif_remove(isif, pdev);
> +}
> diff --git a/drivers/media/platform/ti-vpfe/am437x_isif.h b/drivers/media/platform/ti-vpfe/am437x_isif.h
> new file mode 100644
> index 0000000..c8af122
> --- /dev/null
> +++ b/drivers/media/platform/ti-vpfe/am437x_isif.h
> @@ -0,0 +1,355 @@
> +/*
> + * TI AM437x Image Sensor Interface device API
> + *
> + * Copyright (C) 2013 - 2014 Texas Instruments, Inc.
> + *
> + * Benoit Parrot <bparrot@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _AM437X_ISIF_H
> +#define _AM437X_ISIF_H
> +
> +#ifdef __KERNEL__
> +#include <linux/videodev2.h>
> +#include <linux/device.h>
> +#include <linux/io.h>
> +#include "am437x_isif_regs.h"
> +#include "vpfe_capture.h"
> +
> +enum isif_pixfmt {
> +       ISIF_PIXFMT_RAW,
> +       ISIF_PIXFMT_YCBCR_16BIT,
> +       ISIF_PIXFMT_YCBCR_8BIT
> +};
> +
> +enum isif_frmfmt {
> +       ISIF_FRMFMT_PROGRESSIVE,
> +       ISIF_FRMFMT_INTERLACED
> +};
> +
> +/* PIXEL ORDER IN MEMORY from LSB to MSB */
> +/* only applicable for 8-bit input mode  */
> +enum isif_pixorder {
> +       ISIF_PIXORDER_YCBYCR,
> +       ISIF_PIXORDER_CBYCRY,
> +};
> +
> +enum isif_buftype {
> +       ISIF_BUFTYPE_FLD_INTERLEAVED,
> +       ISIF_BUFTYPE_FLD_SEPARATED
> +};
> +
> +
> +/* enum for No of pixel per line to be avg. in Black Clamping*/
> +enum isif_sample_length {
> +       ISIF_SAMPLE_1PIXELS,
> +       ISIF_SAMPLE_2PIXELS,
> +       ISIF_SAMPLE_4PIXELS,
> +       ISIF_SAMPLE_8PIXELS,
> +       ISIF_SAMPLE_16PIXELS
> +};
> +
> +/* enum for No of lines in Black Clamping */
> +enum isif_sample_line {
> +       ISIF_SAMPLE_1LINES,
> +       ISIF_SAMPLE_2LINES,
> +       ISIF_SAMPLE_4LINES,
> +       ISIF_SAMPLE_8LINES,
> +       ISIF_SAMPLE_16LINES
> +};
> +
> +/* enum for Alaw gamma width */
> +enum isif_gamma_width {
> +       ISIF_GAMMA_BITS_15_6,   /* use bits 15-6 for gamma */
> +       ISIF_GAMMA_BITS_14_5,
> +       ISIF_GAMMA_BITS_13_4,
> +       ISIF_GAMMA_BITS_12_3,
> +       ISIF_GAMMA_BITS_11_2,
> +       ISIF_GAMMA_BITS_10_1,
> +       ISIF_GAMMA_BITS_09_0    /* use bits 9-0 for gamma */
> +};
> +
> +/* returns the highest bit used for the gamma */
> +static inline u8 isif_gamma_width_max_bit(enum isif_gamma_width width)
> +{
> +       return 15 - width;
> +}
> +
> +enum isif_data_size {
> +       ISIF_DATA_16BITS,
> +       ISIF_DATA_15BITS,
> +       ISIF_DATA_14BITS,
> +       ISIF_DATA_13BITS,
> +       ISIF_DATA_12BITS,
> +       ISIF_DATA_11BITS,
> +       ISIF_DATA_10BITS,
> +       ISIF_DATA_8BITS
> +};
> +
> +/* returns the highest bit used for this data size */
> +static inline u8 isif_data_size_max_bit(enum isif_data_size sz)
> +{
> +       return sz == ISIF_DATA_8BITS ? 7 : 15 - sz;
> +}
> +
> +/* structure for ALaw */
> +struct isif_a_law {
> +       /* Enable/disable A-Law */
> +       unsigned char enable;
> +       /* Gamma Width Input */
> +       enum isif_gamma_width gamma_wd;
> +};
> +
> +/* structure for Black Clamping */
> +struct isif_black_clamp {
> +       unsigned char enable;
> +       /* only if bClampEnable is TRUE */
> +       enum isif_sample_length sample_pixel;
> +       /* only if bClampEnable is TRUE */
> +       enum isif_sample_line sample_ln;
> +       /* only if bClampEnable is TRUE */
> +       unsigned short start_pixel;
> +       /* only if bClampEnable is TRUE */
> +       unsigned short sgain;
> +       /* only if bClampEnable is FALSE */
> +       unsigned short dc_sub;
> +};
> +
> +/* structure for Black Level Compensation */
> +struct isif_black_compensation {
> +       /* Constant value to subtract from Red component */
> +       char r;
> +       /* Constant value to subtract from Gr component */
> +       char gr;
> +       /* Constant value to subtract from Blue component */
> +       char b;
> +       /* Constant value to subtract from Gb component */
> +       char gb;
> +};
> +
> +/* Structure for ISIF configuration parameters for raw capture mode passed
> + * by application
> + */
> +struct isif_config_params_raw {
> +       /* data size value from 8 to 16 bits */
> +       enum isif_data_size data_sz;
> +       /* Structure for Optional A-Law */
> +       struct isif_a_law alaw;
> +       /* Structure for Optical Black Clamp */
> +       struct isif_black_clamp blk_clamp;
> +       /* Structure for Black Compensation */
> +       struct isif_black_compensation blk_comp;
> +};
> +
> +
> +/* Define for extra pixel/line and extra lines/frame */
> +#define NUM_EXTRAPIXELS                8
> +#define NUM_EXTRALINES         8
> +
> +/* settings for commonly used video formats */
> +#define ISIF_WIN_PAL     {0, 0, 720, 576}
> +/* ntsc square pixel */
> +#define ISIF_WIN_VGA   {0, 0, (640 + NUM_EXTRAPIXELS), (480 + NUM_EXTRALINES)}
> +#define ISIF_WIN_SVGA  {0, 0, (800), (600)}
> +
> +/* Structure for ISIF configuration parameters for raw capture mode */
> +struct isif_params_raw {
> +       /* pixel format */
> +       enum isif_pixfmt pix_fmt;
> +       /* progressive or interlaced frame */
> +       enum isif_frmfmt frm_fmt;
> +       /* v4l2 format for reference */
> +       struct v4l2_format fmt;
> +       /* video window */
> +       struct v4l2_rect win;
> +       /* Current Format Bytes Per Pixels */
> +       unsigned int bytesperpixel;
> +       /* Current Format Bytes per Lines
> +        * (Aligned to 32 bytes) used for HORZ_INFO
> +        */
> +       unsigned int bytesperline;
> +       /* field id polarity */
> +       enum vpfe_pin_pol fid_pol;
> +       /* vertical sync polarity */
> +       enum vpfe_pin_pol vd_pol;
> +       /* horizontal sync polarity */
> +       enum vpfe_pin_pol hd_pol;
> +       /* interleaved or separated fields */
> +       enum isif_buftype buf_type;
> +       /*
> +        * enable to store the image in inverse
> +        * order in memory(bottom to top)
> +        */
> +       unsigned char image_invert_enable;
> +       /* configurable paramaters */
> +       struct isif_config_params_raw config_params;
> +};
> +
> +struct isif_params_ycbcr {
> +       /* pixel format */
> +       enum isif_pixfmt pix_fmt;
> +       /* progressive or interlaced frame */
> +       enum isif_frmfmt frm_fmt;
> +       /* v4l2 format for reference */
> +       struct v4l2_format fmt;
> +       /* video window */
> +       struct v4l2_rect win;
> +       /* Current Format Bytes Per Pixels */
> +       unsigned int bytesperpixel;
> +       /* Current Format Bytes per Lines
> +        * (Aligned to 32 bytes) used for HORZ_INFO
> +        */
> +       unsigned int bytesperline;
> +       /* field id polarity */
> +       enum vpfe_pin_pol fid_pol;
> +       /* vertical sync polarity */
> +       enum vpfe_pin_pol vd_pol;
> +       /* horizontal sync polarity */
> +       enum vpfe_pin_pol hd_pol;
> +       /* enable BT.656 embedded sync mode */
> +       int bt656_enable;
> +       /* cb:y:cr:y or y:cb:y:cr in memory */
> +       enum isif_pixorder pix_order;
> +       /* interleaved or separated fields  */
> +       enum isif_buftype buf_type;
> +};
> +
> +/*
> + * isif operational configuration
> + */
> +struct isif_oper_config {
> +       struct device *dev;
> +       /* ISIF interface type */
> +       enum vpfe_hw_if_type if_type;
> +       /* Raw Bayer configuration */
> +       struct isif_params_raw bayer;
> +       /* YCbCr configuration */
> +       struct isif_params_ycbcr ycbcr;
> +       /* ccdc base address */
> +       void __iomem *base_addr;
> +};
> +
> +
> +/*
> + * isif hw operations
> + */
> +struct vpfe_isif_device;
> +
> +struct isif_hw_ops {
> +       /* Pointer to initialize function to initialize isif device */
> +       int (*open)(struct vpfe_isif_device *isif, struct device *dev);
> +       /* Pointer to deinitialize function */
> +       int (*close)(struct vpfe_isif_device *isif,
> +               struct device *dev);
> +       /* set isif base address */
> +       void (*set_isif_base)(struct vpfe_isif_device *isif,
> +               void *base, int size);
> +       /* Pointer to function to enable or disable isif */
> +       void (*enable)(struct vpfe_isif_device *isif, int en);
> +       /* reset sbl. only for 6446 */
> +       void (*reset)(struct vpfe_isif_device *isif);
> +       /* enable output to sdram */
> +       void (*enable_out_to_sdram)(struct vpfe_isif_device *isif,
> +               int en);
> +       /* Pointer to function to set hw parameters */
> +       int (*set_hw_if_params)(struct vpfe_isif_device *isif,
> +               struct vpfe_hw_if_param *param);
> +       /* get interface parameters */
> +       int (*get_hw_if_params)(struct vpfe_isif_device *isif,
> +               struct vpfe_hw_if_param *param);
> +       /*
> +        * Pointer to function to set parameters. Used
> +        * for implementing VPFE_S_ISIF_PARAMS
> +        */
> +       int (*set_params)(struct vpfe_isif_device *isif,
> +               void __user *params);
> +       /*
> +        * Pointer to function to get parameter. Used
> +        * for implementing VPFE_G_ISIF_PARAMS
> +        */
> +       int (*get_params)(struct vpfe_isif_device *isif,
> +               void __user *params);
> +       /* Pointer to function to configure isif */
> +       int (*configure)(struct vpfe_isif_device *isif);
> +
> +       /* Pointer to function to set buffer type */
> +       int (*set_buftype)(struct vpfe_isif_device *isif,
> +               enum isif_buftype buf_type);
> +       /* Pointer to function to get buffer type */
> +       enum isif_buftype (*get_buftype)(struct vpfe_isif_device *isif);
> +       /* Pointer to function to set frame format */
> +       int (*set_frame_format)(struct vpfe_isif_device *isif,
> +               enum isif_frmfmt frm_fmt);
> +       /* Pointer to function to get frame format */
> +       enum isif_frmfmt (*get_frame_format)(struct vpfe_isif_device *isif);
> +       /* enumerate hw pix formats */
> +       int (*enum_pix)(struct vpfe_isif_device *isif, u32 *hw_pix, int i);
> +       /* Pointer to function to set buffer type */
> +       u32 (*get_pixel_format)(struct vpfe_isif_device *isif);
> +       /* Pointer to function to get pixel format. */
> +       int (*set_pixel_format)(struct vpfe_isif_device *isif, u32 pixfmt);
> +       /* Pointer to function to set image window */
> +       int (*set_image_window)(struct vpfe_isif_device *isif,
> +               struct v4l2_rect *win, unsigned int bpp);
> +       /* Pointer to function to set image window */
> +       void (*get_image_window)(struct vpfe_isif_device *isif,
> +               struct v4l2_rect *win);
> +       /* Pointer to function to get line length */
> +       unsigned int (*get_line_length)(struct vpfe_isif_device *isif);
> +
> +       /* Query ISIF control IDs */
> +       int (*queryctrl)(struct vpfe_isif_device *isif,
> +               struct v4l2_queryctrl *qctrl);
> +       /* Set ISIF control */
> +       int (*set_control)(struct vpfe_isif_device *isif,
> +               struct v4l2_control *ctrl);
> +       /* Get ISIF control */
> +       int (*get_control)(struct vpfe_isif_device *isif,
> +               struct v4l2_control *ctrl);
> +       /* Clear Interrupt */
> +       void (*clear_intr)(struct vpfe_isif_device *isif, int vdint);
> +       /* Read Interrupt Status */
> +       int (*intr_status)(struct vpfe_isif_device *isif);
> +       /* Enable Interrupt */
> +       int (*intr_enable)(struct vpfe_isif_device *isif, int vdint);
> +       /* Disable Interrupt */
> +       int (*intr_disable)(struct vpfe_isif_device *isif, int vdint);
> +
> +       /* Pointer to function to set frame buffer address */
> +       void (*setfbaddr)(struct vpfe_isif_device *isif, unsigned long addr);
> +       /* Pointer to function to get field id */
> +       int (*getfid)(struct vpfe_isif_device *isif);
> +};
> +
> +struct vpfe_isif_device {
> +       /* isif device name */
> +       char name[32];
> +       /* module owner */
> +       struct module *owner;
> +       struct isif_oper_config isif_cfg;
> +       /* hw ops */
> +       struct isif_hw_ops hw_ops;
> +       /* ISIF Save/Restore context */
> +       u32 isif_ctx[ISIF_REG_END / sizeof(u32)];
> +
> +};
> +
> +int vpfe_isif_init(struct vpfe_isif_device *isif,
> +       struct platform_device *pdev);
> +void vpfe_isif_cleanup(struct vpfe_isif_device *isif,
> +       struct platform_device *pdev);
> +int isif_remove(struct vpfe_isif_device *isif, struct platform_device *pdev);
> +int isif_suspend(struct vpfe_isif_device *isif, struct device *dev);
> +int isif_resume(struct vpfe_isif_device *isif, struct device *dev);
> +
> +#endif
> +#endif
> diff --git a/drivers/media/platform/ti-vpfe/am437x_isif_regs.h b/drivers/media/platform/ti-vpfe/am437x_isif_regs.h
> new file mode 100644
> index 0000000..843e3ff
> --- /dev/null
> +++ b/drivers/media/platform/ti-vpfe/am437x_isif_regs.h
> @@ -0,0 +1,144 @@
> +/*
> + * TI AM437x Image Sensor Interface Registers
> + *
> + * Copyright (C) 2013 - 2014 Texas Instruments, Inc.
> + *
> + * Benoit Parrot <bparrot@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _AM437X_ISIF_REGS_H
> +#define _AM437X_ISIF_REGS_H
> +
> +/**************************************************************************\
> +* Register OFFSET Definitions
> +\**************************************************************************/
> +#define ISIF_PID                               0x0
> +#define ISIF_PCR                               0x4
> +#define ISIF_SYN_MODE                          0x8
> +#define ISIF_HD_VD_WID                         0xc
> +#define ISIF_PIX_LINES                         0x10
> +#define ISIF_HORZ_INFO                         0x14
> +#define ISIF_VERT_START                                0x18
> +#define ISIF_VERT_LINES                                0x1c
> +#define ISIF_CULLING                           0x20
> +#define ISIF_HSIZE_OFF                         0x24
> +#define ISIF_SDOFST                            0x28
> +#define ISIF_SDR_ADDR                          0x2c
> +#define ISIF_CLAMP                             0x30
> +#define ISIF_DCSUB                             0x34
> +#define ISIF_COLPTN                            0x38
> +#define ISIF_BLKCMP                            0x3c
> +#define ISIF_VDINT                             0x48
> +#define ISIF_ALAW                              0x4c
> +#define ISIF_REC656IF                          0x50
> +#define ISIF_CCDCFG                            0x54
> +#define ISIF_DMA_CNTL                          0x98
> +#define ISIF_VPFE_SYSCONFIG                    0x104
> +#define ISIF_VPFE_CONFIG                       0x108
> +#define ISIF_VPFE_IRQ_EOI                      0x110
> +#define ISIF_VPFE_IRQ_STATUS_RAW               0x114
> +#define ISIF_VPFE_IRQ_STATUS                   0x118
> +#define ISIF_VPFE_IRQ_ENABLE_SET               0x11c
> +#define ISIF_VPFE_IRQ_ENABLE_CLR               0x120
> +#define ISIF_REG_END                           0x124
> +
> +/***************************************************************
> +*      Define for various register bit mask and shifts for ISIF
> +****************************************************************/
> +#define ISIF_FID_POL_MASK                      1
> +#define ISIF_FID_POL_SHIFT                     4
> +#define ISIF_HD_POL_MASK                       1
> +#define ISIF_HD_POL_SHIFT                      3
> +#define ISIF_VD_POL_MASK                       1
> +#define ISIF_VD_POL_SHIFT                      2
> +#define ISIF_HSIZE_OFF_MASK                    0xffffffe0
> +#define ISIF_32BYTE_ALIGN_VAL                  31
> +#define ISIF_FRM_FMT_MASK                      0x1
> +#define ISIF_FRM_FMT_SHIFT                     7
> +#define ISIF_DATA_SZ_MASK                      7
> +#define ISIF_DATA_SZ_SHIFT                     8
> +#define ISIF_PIX_FMT_MASK                      3
> +#define ISIF_PIX_FMT_SHIFT                     12
> +#define ISIF_VP2SDR_DISABLE                    0xFFFBFFFF
> +#define ISIF_WEN_ENABLE                                (1 << 17)
> +#define ISIF_SDR2RSZ_DISABLE                   0xFFF7FFFF
> +#define ISIF_VDHDEN_ENABLE                     (1 << 16)
> +#define ISIF_LPF_ENABLE                                (1 << 14)
> +#define ISIF_ALAW_ENABLE                       (1 << 3)
> +#define ISIF_ALAW_GAMMA_WD_MASK                        7
> +#define ISIF_BLK_CLAMP_ENABLE                  (1 << 31)
> +#define ISIF_BLK_SGAIN_MASK                    0x1F
> +#define ISIF_BLK_ST_PXL_MASK                   0x7FFF
> +#define ISIF_BLK_ST_PXL_SHIFT                  10
> +#define ISIF_BLK_SAMPLE_LN_MASK                        7
> +#define ISIF_BLK_SAMPLE_LN_SHIFT               28
> +#define ISIF_BLK_SAMPLE_LINE_MASK              7
> +#define ISIF_BLK_SAMPLE_LINE_SHIFT             25
> +#define ISIF_BLK_DC_SUB_MASK                   0x03FFF
> +#define ISIF_BLK_COMP_MASK                     0xFF
> +#define ISIF_BLK_COMP_GB_COMP_SHIFT            8
> +#define ISIF_BLK_COMP_GR_COMP_SHIFT            16
> +#define ISIF_BLK_COMP_R_COMP_SHIFT             24
> +#define ISIF_LATCH_ON_VSYNC_DISABLE            (1 << 15)
> +#define ISIF_DATA_PACK_ENABLE                  (1 << 11)
> +#define ISIF_HORZ_INFO_SPH_SHIFT               16
> +#define ISIF_VERT_START_SLV0_SHIFT             16
> +#define ISIF_VDINT_VDINT0_SHIFT                        16
> +#define ISIF_VDINT_VDINT1_MASK                 0xFFFF
> +#define ISIF_PPC_RAW                           1
> +#define ISIF_DCSUB_DEFAULT_VAL                 0
> +#define ISIF_CLAMP_DEFAULT_VAL                 0
> +#define ISIF_COLPTN_VAL                                0xBB11BB11
> +#define ISIF_TWO_BYTES_PER_PIXEL               2
> +#define ISIF_INTERLACED_IMAGE_INVERT           0x4B6D
> +#define ISIF_INTERLACED_NO_IMAGE_INVERT                0x0249
> +#define ISIF_PROGRESSIVE_IMAGE_INVERT          0x4000
> +#define ISIF_PROGRESSIVE_NO_IMAGE_INVERT       0
> +#define ISIF_INTERLACED_HEIGHT_SHIFT           1
> +#define ISIF_SYN_MODE_INPMOD_SHIFT             12
> +#define ISIF_SYN_MODE_INPMOD_MASK              3
> +#define ISIF_SYN_MODE_8BITS                    (7 << 8)
> +#define ISIF_SYN_MODE_10BITS                   (6 << 8)
> +#define ISIF_SYN_MODE_11BITS                   (5 << 8)
> +#define ISIF_SYN_MODE_12BITS                   (4 << 8)
> +#define ISIF_SYN_MODE_13BITS                   (3 << 8)
> +#define ISIF_SYN_MODE_14BITS                   (2 << 8)
> +#define ISIF_SYN_MODE_15BITS                   (1 << 8)
> +#define ISIF_SYN_MODE_16BITS                   (0 << 8)
> +#define ISIF_SYN_FLDMODE_MASK                  1
> +#define ISIF_SYN_FLDMODE_SHIFT                 7
> +#define ISIF_REC656IF_BT656_EN                 3
> +#define ISIF_SYN_MODE_VD_POL_NEGATIVE          (1 << 2)
> +#define ISIF_CCDCFG_Y8POS_SHIFT                        11
> +#define ISIF_CCDCFG_BW656_10BIT                        (1 << 5)
> +#define ISIF_SDOFST_FIELD_INTERLEAVED          0x249
> +#define ISIF_NO_CULLING                                0xffff00ff
> +#define ISIF_VPFE_VDINT0                       (1 << 0)
> +#define ISIF_VPFE_VDINT1                       (1 << 1)
> +#define ISIF_VPFE_VDINT2                       (1 << 2)
> +#define ISIF_DMA_CNTL_OVERFLOW                 (1 << 31)
> +
> +#define ISIF_VPFE_CONFIG_PCLK_INV_SHIFT                0
> +#define ISIF_VPFE_CONFIG_PCLK_INV_MASK         1
> +#define ISIF_VPFE_CONFIG_PCLK_INV_NOT_INV      0
> +#define ISIF_VPFE_CONFIG_PCLK_INV_INV          1
> +#define ISIF_VPFE_CONFIG_VPFE_EN_SHIFT         1
> +#define ISIF_VPFE_CONFIG_VPFE_EN_MASK          2
> +#define ISIF_VPFE_CONFIG_VPFE_EN_DISABLE       0
> +#define ISIF_VPFE_CONFIG_VPFE_EN_ENABLE                1
> +#define ISIF_VPFE_CONFIG_VPFE_ST_SHIFT         2
> +#define ISIF_VPFE_CONFIG_VPFE_ST_MASK          4
> +#define ISIF_VPFE_CONFIG_VPFE_ST_OCP_ACTIVE    0
> +#define ISIF_VPFE_CONFIG_VPFE_ST_OCP_STANDBY   1
> +
> +
> +#endif
> diff --git a/drivers/media/platform/ti-vpfe/vpfe_capture.c b/drivers/media/platform/ti-vpfe/vpfe_capture.c
> new file mode 100644
> index 0000000..fa54756
> --- /dev/null
> +++ b/drivers/media/platform/ti-vpfe/vpfe_capture.c
> @@ -0,0 +1,2478 @@
> +/*
> + * TI VPFE Multi instance Capture Driver
> + *
> + * Copyright (C) 2013 - 2014 Texas Instruments, Inc.
> + *
> + * Benoit Parrot <bparrot@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Detail description:
> + *    VPFE Capture driver allows applications to capture and stream video
> + *    frames on TI AM43xx SoCs from a YUV or Raw Bayer source such as
> + *    decoder or image sensor device.
> + *
> + *    This SoC has a dual Video Processing Front End (VPFE) instances for
> + *    capturing video/raw image data into memory buffers. The data can then
> + *    be stored or passed on to a compatible display device.
> + *    A typical EVM using these SoCs have following high level configuration.
> + *
> + *
> + *    decoder(OV2659/          YUV/
> + *          TVP514x)   -->  Raw Bayer RGB ---> VPFE (CCDC/ISIF)
> + *                             data input        |      |
> + *                                               V      |
> + *                                             SDRAM    |
> + *                                                      V
> + *                                                 Image Processor
> + *                                                      |
> + *                                                      V
> + *                                                    SDRAM
> + *
> + *    The data flow happens from a sensor/decoder connected to the VPFE over a
> + *    YUV embedded (BT.656/BT.1120) or separate sync or raw bayer rgb interface
> + *    and to the input of VPFE. The input data is first passed through
> + *    ISIF (Image Sensor Interface). The ISIF does very little or no
> + *    processing on YUV data and does lightly pre-process Raw Bayer RGB
> + *    data through data gain/offset etc. After this, data is written to SDRAM.
> + *
> + *    Features supported
> + *             - MMAP IO
> + *             - Capture using OV2659 in raw mode
> + *             - Support for interfacing decoders/sensor using sub-device model
> + *             - Support for asynchronous sub-device registration
> + *             - Support media controller API
> + *             - Support videobuf2 buffer API
> + *             - Work with AM437x ISIF to do Raw Bayer RGB/YUV data capture
> + *                to SDRAM.
> + *    TODO list
> + *             - Support for control ioctls
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-of.h>
> +#include <linux/io.h>
> +#include "vpfe_capture.h"
> +#include <media/tvp514x.h>
> +
> +#include "am437x_isif_regs.h"
> +
> +static int debug;
> +static u32 numbuffers = 3;
> +static u32 bufsize = (800 * 600 * 2);
> +
> +module_param(numbuffers, uint, S_IRUGO);
> +module_param(bufsize, uint, S_IRUGO);
> +module_param(debug, int, 0644);
> +
> +MODULE_PARM_DESC(numbuffers, "buffer count (default:3)");
> +MODULE_PARM_DESC(bufsize, "buffer size in bytes (default:720 x 576 x 2)");
> +MODULE_PARM_DESC(debug, "Debug level 0-1");
> +
> +MODULE_DESCRIPTION("VPFE Video for Linux Capture Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Texas Instruments");
> +
> +#define MAX_WIDTH      4096
> +#define MAX_HEIGHT     4096
> +
> +/* standard information */
> +struct vpfe_standard {
> +       v4l2_std_id std_id;
> +       unsigned int width;
> +       unsigned int height;
> +       struct v4l2_fract pixelaspect;
> +       /* 0 - progressive, 1 - interlaced */
> +       int frame_format;
> +};
> +
> +/* MULTI: Global default OK for multi-instance use */
> +/* data structures */
> +static struct vpfe_config_params config_params = {
> +       .min_numbuffers = 3,
> +       .numbuffers = 3,
> +       .min_bufsize = 800 * 600 * 2,
> +       .device_bufsize = 800 * 600 * 2,
> +};
> +
> +static const struct vpfe_standard vpfe_standards[] = {
> +       {V4L2_STD_525_60, 800, 600, {1, 1}, 0},
> +       {V4L2_STD_625_50, 720, 576, {54, 59}, 1},
> +};
> +
> +/* map mbus_fmt to pixelformat */
> +static void mbus_to_pix(struct vpfe_device *vpfe,
> +               const struct v4l2_mbus_framefmt *mbus,
> +               struct v4l2_pix_format *pix, unsigned int *bpp)
> +{
> +       unsigned int bus_width =
> +                       vpfe->current_subdev->isif_if_params.bus_width;
> +
> +       switch (mbus->code) {
> +       case V4L2_MBUS_FMT_UYVY8_2X8:
> +               pix->pixelformat = V4L2_PIX_FMT_UYVY;
> +               *bpp = (bus_width == 10) ? 4 : 2;
> +               break;
> +
> +       case V4L2_MBUS_FMT_YUYV8_2X8:
> +               pix->pixelformat = V4L2_PIX_FMT_YUYV;
> +               *bpp = (bus_width == 10) ? 4 : 2;
> +               break;
> +
> +       case V4L2_MBUS_FMT_YVYU8_2X8:
> +               pix->pixelformat = V4L2_PIX_FMT_YVYU;
> +               *bpp = (bus_width == 10) ? 4 : 2;
> +               break;
> +
> +       case V4L2_MBUS_FMT_VYUY8_2X8:
> +               pix->pixelformat = V4L2_PIX_FMT_VYUY;
> +               *bpp = (bus_width == 10) ? 4 : 2;
> +               break;
> +
> +       case V4L2_MBUS_FMT_YDYUYDYV8_1X16:
> +               pix->pixelformat = V4L2_PIX_FMT_NV12;
> +               *bpp = (bus_width == 10) ? 2 : 1;
> +               break;
> +
> +       case V4L2_MBUS_FMT_Y12_1X12:
> +               pix->pixelformat = V4L2_PIX_FMT_YUV420;
> +               *bpp = (bus_width == 10) ? 2 : 1;
> +               break;
> +
> +       case V4L2_MBUS_FMT_YUYV8_1_5X8:
> +               pix->pixelformat = V4L2_PIX_FMT_YUV420;
> +               *bpp = (bus_width == 10) ? 2 : 1;
> +               break;
> +
> +       case V4L2_MBUS_FMT_SBGGR8_1X8:
> +               pix->pixelformat = V4L2_PIX_FMT_SBGGR8;
> +               *bpp = (bus_width == 10) ? 2 : 1;
> +               break;
> +
> +       case V4L2_MBUS_FMT_SGBRG8_1X8:
> +               pix->pixelformat = V4L2_PIX_FMT_SGBRG8;
> +               *bpp = (bus_width == 10) ? 2 : 1;
> +               break;
> +
> +       case V4L2_MBUS_FMT_SGRBG8_1X8:
> +               pix->pixelformat = V4L2_PIX_FMT_SGRBG8;
> +               *bpp = (bus_width == 10) ? 2 : 1;
> +               break;
> +
> +       case V4L2_MBUS_FMT_SRGGB8_1X8:
> +               pix->pixelformat = V4L2_PIX_FMT_SRGGB8;
> +               *bpp = (bus_width == 10) ? 2 : 1;
> +               break;
> +
> +       case V4L2_MBUS_FMT_BGR565_2X8_BE:
> +               pix->pixelformat = V4L2_PIX_FMT_RGB565;
> +               *bpp = (bus_width == 10) ? 4 : 2;
> +               break;
> +
> +       case V4L2_MBUS_FMT_RGB565_2X8_BE:
> +               pix->pixelformat = V4L2_PIX_FMT_RGB565X;
> +               *bpp = (bus_width == 10) ? 4 : 2;
> +               break;
> +
> +       default:
> +               pr_err("Invalid mbus code set\n");
> +               *bpp = 1;
> +       }
> +
> +       pix->bytesperline = pix->width * *bpp;
> +       /* pitch should be 32 bytes aligned */
> +       pix->bytesperline = ALIGN(pix->bytesperline, 32);
> +       if (pix->pixelformat == V4L2_PIX_FMT_NV12)
> +               pix->sizeimage = pix->bytesperline * pix->height +
> +                               ((pix->bytesperline * pix->height) >> 1);
> +       else if (pix->pixelformat == V4L2_PIX_FMT_YUV420)
> +               pix->sizeimage = pix->bytesperline * pix->height +
> +                               ((pix->bytesperline * pix->height) >> 1);
> +       else
> +               pix->sizeimage = pix->bytesperline * pix->height;
> +}
> +
> +/* map mbus_fmt to pixelformat */
> +static int pix_to_mbus(struct vpfe_device *vpfe,
> +               struct v4l2_pix_format *pix,
> +               struct v4l2_mbus_framefmt *mbus)
> +{
> +       memset(mbus, 0, sizeof(*mbus));
> +       mbus->width = pix->width;
> +       mbus->height = pix->height;
> +
> +       switch (pix->pixelformat) {
> +       case V4L2_PIX_FMT_UYVY:
> +               mbus->code = V4L2_MBUS_FMT_UYVY8_2X8;
> +               break;
> +       case V4L2_PIX_FMT_YUYV:
> +               mbus->code = V4L2_MBUS_FMT_YUYV8_2X8;
> +               break;
> +       case V4L2_PIX_FMT_YVYU:
> +               mbus->code = V4L2_MBUS_FMT_YVYU8_2X8;
> +               break;
> +       case V4L2_PIX_FMT_VYUY:
> +               mbus->code = V4L2_MBUS_FMT_VYUY8_2X8;
> +               break;
> +       case V4L2_PIX_FMT_NV12:
> +               mbus->code = V4L2_MBUS_FMT_YDYUYDYV8_1X16;
> +               break;
> +       case V4L2_PIX_FMT_YUV420:
> +               mbus->code = V4L2_MBUS_FMT_Y12_1X12;
> +               break;
> +       case V4L2_PIX_FMT_SBGGR8:
> +               mbus->code = V4L2_MBUS_FMT_SBGGR8_1X8;
> +               break;
> +       case V4L2_PIX_FMT_SGBRG8:
> +               mbus->code = V4L2_MBUS_FMT_SGBRG8_1X8;
> +               break;
> +       case V4L2_PIX_FMT_SGRBG8:
> +               mbus->code = V4L2_MBUS_FMT_SGRBG8_1X8;
> +               break;
> +       case V4L2_PIX_FMT_SRGGB8:
> +               mbus->code = V4L2_MBUS_FMT_SRGGB8_1X8;
> +               break;
> +       case V4L2_PIX_FMT_RGB565:
> +               mbus->code = V4L2_MBUS_FMT_BGR565_2X8_BE;
> +               break;
> +       case V4L2_PIX_FMT_RGB565X:
> +               mbus->code = V4L2_MBUS_FMT_RGB565_2X8_BE;
> +               break;
> +       default:
> +               pr_err("Invalid pixel code\n");
> +               return -EINVAL;
> +       }
> +
> +       mbus->colorspace = pix->colorspace;
> +       mbus->field = pix->field;
> +
> +       return 0;
> +}
> +
> +static int cmp_v4l2_format(const struct v4l2_format *lhs,
> +       const struct v4l2_format *rhs)
> +{
> +       return lhs->type == rhs->type &&
> +               lhs->fmt.pix.width == rhs->fmt.pix.width &&
> +               lhs->fmt.pix.height == rhs->fmt.pix.height &&
> +               lhs->fmt.pix.pixelformat == rhs->fmt.pix.pixelformat &&
> +               lhs->fmt.pix.field == rhs->fmt.pix.field &&
> +               lhs->fmt.pix.colorspace == rhs->fmt.pix.colorspace;
> +}
> +
> +/*
> + * vpfe_get_isif_image_format - Get image parameters based on ISIF settings
> + */
> +static int vpfe_get_isif_image_format(struct vpfe_device *vpfe,
> +                                struct v4l2_format *f)
> +{
> +       struct v4l2_rect image_win;
> +       enum isif_buftype buf_type;
> +       enum isif_frmfmt frm_fmt;
> +
> +       memset(f, 0, sizeof(*f));
> +       f->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +       vpfe->vpfe_isif.hw_ops.get_image_window(
> +                       &vpfe->vpfe_isif, &image_win);
> +       f->fmt.pix.width = image_win.width;
> +       f->fmt.pix.height = image_win.height;
> +       f->fmt.pix.bytesperline =
> +               vpfe->vpfe_isif.hw_ops.get_line_length(
> +                       &vpfe->vpfe_isif);
> +       f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
> +                               f->fmt.pix.height;
> +       buf_type = vpfe->vpfe_isif.hw_ops.get_buftype(
> +                               &vpfe->vpfe_isif);
> +       f->fmt.pix.pixelformat =
> +               vpfe->vpfe_isif.hw_ops.get_pixel_format(
> +                               &vpfe->vpfe_isif);
> +       frm_fmt =
> +               vpfe->vpfe_isif.hw_ops.get_frame_format(
> +                               &vpfe->vpfe_isif);
> +       if (frm_fmt == ISIF_FRMFMT_PROGRESSIVE) {
> +               f->fmt.pix.field = V4L2_FIELD_NONE;
> +       } else if (frm_fmt == ISIF_FRMFMT_INTERLACED) {
> +               if (buf_type == ISIF_BUFTYPE_FLD_INTERLEAVED) {
> +                       f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> +                } else if (buf_type == ISIF_BUFTYPE_FLD_SEPARATED) {
> +                       f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
> +               } else {
> +                       dev_err(vpfe->dev, "Invalid buf_type\n");
> +                       return -EINVAL;
> +               }
> +       } else {
> +               dev_err(vpfe->dev, "Invalid frm_fmt\n");
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * vpfe_config_isif_image_format()
> + * For a pix format, configure isif to setup the capture
> + */
> +static int vpfe_config_isif_image_format(struct vpfe_device *vpfe)
> +{
> +       enum isif_frmfmt frm_fmt = ISIF_FRMFMT_INTERLACED;
> +       int ret = 0;
> +
> +       if (vpfe->vpfe_isif.hw_ops.set_pixel_format(
> +                       &vpfe->vpfe_isif,
> +                       vpfe->fmt.fmt.pix.pixelformat) < 0) {
> +               dev_err(vpfe->dev,
> +                       "couldn't set pix format in isif\n");
> +               return -EINVAL;
> +       }
> +       /* configure the image window */
> +       vpfe->vpfe_isif.hw_ops.set_image_window(
> +                               &vpfe->vpfe_isif,
> +                               &vpfe->crop, vpfe->bpp);
> +
> +       switch (vpfe->fmt.fmt.pix.field) {
> +       case V4L2_FIELD_INTERLACED:
> +               /* do nothing, since it is default */
> +               ret = vpfe->vpfe_isif.hw_ops.set_buftype(
> +                               &vpfe->vpfe_isif,
> +                               ISIF_BUFTYPE_FLD_INTERLEAVED);
> +               break;
> +       case V4L2_FIELD_NONE:
> +               frm_fmt = ISIF_FRMFMT_PROGRESSIVE;
> +               /* buffer type only applicable for interlaced scan */
> +               break;
> +       case V4L2_FIELD_SEQ_TB:
> +               ret = vpfe->vpfe_isif.hw_ops.set_buftype(
> +                               &vpfe->vpfe_isif,
> +                               ISIF_BUFTYPE_FLD_SEPARATED);
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       /* set the frame format */
> +       if (!ret)
> +               ret = vpfe->vpfe_isif.hw_ops.set_frame_format(
> +                               &vpfe->vpfe_isif, frm_fmt);
> +
> +       return ret;
> +}
> +/*
> + * vpfe_config_image_format()
> + * For a given standard, this functions sets up the default
> + * pix format & crop values in the vpfe device and isif.  It first
> + * starts with defaults based values from the standard table.
> + * It then checks if sub device support g_mbus_fmt and then override the
> + * values based on that.Sets crop values to match with scan resolution
> + * starting at 0,0. It calls vpfe_config_isif_image_format() set the
> + * values in isif
> + */
> +static int vpfe_config_image_format(struct vpfe_device *vpfe,
> +                                   v4l2_std_id std_id)
> +{
> +       struct vpfe_subdev_info *sdinfo = vpfe->current_subdev;
> +       struct v4l2_mbus_framefmt mbus_fmt;
> +       struct v4l2_pix_format *pix = &vpfe->fmt.fmt.pix;
> +       struct v4l2_pix_format pix_test;
> +       struct v4l2_subdev_format sd_fmt;
> +       int i, ret = 0;
> +
> +       for (i = 0; i < ARRAY_SIZE(vpfe_standards); i++) {
> +               if (vpfe_standards[i].std_id & std_id) {
> +                       vpfe->std_info.active_pixels =
> +                                       vpfe_standards[i].width;
> +                       vpfe->std_info.active_lines =
> +                                       vpfe_standards[i].height;
> +                       vpfe->std_info.frame_format =
> +                                       vpfe_standards[i].frame_format;
> +                       vpfe->std_index = i;
> +                       break;
> +               }
> +       }
> +
> +       if (i ==  ARRAY_SIZE(vpfe_standards)) {
> +               dev_err(vpfe->dev, "standard not supported\n");
> +               return -EINVAL;
> +       }
> +
> +       vpfe->crop.top = 0;
> +       vpfe->crop.left = 0;
> +       vpfe->crop.width = vpfe->std_info.active_pixels;
> +       vpfe->crop.height = vpfe->std_info.active_lines;
> +       pix->width = vpfe->crop.width;
> +       pix->height = vpfe->crop.height;
> +
> +       /* first field and frame format based on standard frame format */
> +       if (vpfe->std_info.frame_format) {
> +               pix->field = V4L2_FIELD_INTERLACED;
> +               /* assume V4L2_PIX_FMT_UYVY as default */
> +               pix->pixelformat = V4L2_PIX_FMT_YUYV;
> +               v4l2_fill_mbus_format(&mbus_fmt, pix,
> +                                     V4L2_MBUS_FMT_YUYV10_2X10);
> +       } else {
> +               pix->field = V4L2_FIELD_NONE;
> +               /* assume V4L2_PIX_FMT_SBGGR8 */
> +               pix->pixelformat = V4L2_PIX_FMT_YUYV;
> +               v4l2_fill_mbus_format(&mbus_fmt, pix,
> +                                     V4L2_MBUS_FMT_YUYV10_2X10);
> +       }
> +
> +       /* copy pix format for testing */
> +       pix_test = *pix;
> +
> +       if (!v4l2_device_has_op(&vpfe->v4l2_dev, video, g_mbus_fmt)) {
> +               sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +
> +               ret = v4l2_device_call_until_err(&vpfe->v4l2_dev,
> +                               sdinfo->grp_id, pad, get_fmt, NULL, &sd_fmt);
> +
> +               if (ret && ret != -ENOIOCTLCMD) {
> +                       dev_err(vpfe->dev,
> +                               "error in getting g_mbus_fmt from sub device\n");
> +                       return ret;
> +               }
> +       } else {
> +               /* if sub device supports g_mbus_fmt, override the defaults */
> +               ret = v4l2_device_call_until_err(&vpfe->v4l2_dev,
> +                               sdinfo->grp_id, video, g_mbus_fmt, &mbus_fmt);
> +
> +               if (ret && ret != -ENOIOCTLCMD) {
> +                       dev_err(vpfe->dev,
> +                               "error in getting g_mbus_fmt from sub device\n");
> +                       return ret;
> +               } else if (ret == -ENOIOCTLCMD) {
> +                       dev_dbg(vpfe->dev,
> +                               "sub device '%s' does not support g_mbus_fmt\n",
> +                               sdinfo->name);
> +               } else {
> +                       dev_dbg(vpfe->dev,
> +                               "v4l2_subdev_call g_mbus_fmt: %d\n", ret);
> +               }
> +       }
> +
> +       /* convert mbus_format to v4l2_format */
> +       v4l2_fill_pix_format(pix, &sd_fmt.format);
> +       mbus_to_pix(vpfe, &sd_fmt.format, pix, &vpfe->bpp);
> +
> +       /* Update the crop window based on found values */
> +       vpfe->crop.width = pix->width;
> +       vpfe->crop.height = pix->height;
> +
> +       /* Sets the values in ISIF */
> +       ret = vpfe_config_isif_image_format(vpfe);
> +
> +       return ret;
> +}
> +
> +static int vpfe_initialize_device(struct vpfe_device *vpfe)
> +{
> +       int ret = 0;
> +
> +       /* set first input of current subdevice as the current input */
> +       vpfe->current_input = 0;
> +
> +       /* set default standard */
> +       vpfe->std_index = 0;
> +
> +       /* Configure the default format information */
> +       ret = vpfe_config_image_format(vpfe,
> +                               vpfe_standards[vpfe->std_index].std_id);
> +       if (ret)
> +               return ret;
> +
> +       /* now open the isif device to initialize it */
> +       ret = vpfe->vpfe_isif.hw_ops.open(
> +                               &vpfe->vpfe_isif,
> +                               vpfe->dev);
> +       if (!ret)
> +               vpfe->initialized = 1;
> +
> +       /* Clear all VPFE/ISIF interrupts */
> +       if (vpfe->vpfe_isif.hw_ops.clear_intr)
> +               vpfe->vpfe_isif.hw_ops.clear_intr(
> +                               &vpfe->vpfe_isif, -1);
> +
> +       return ret;
> +}
> +
> +/*
> + * vpfe_open : It creates object of file handle structure and
> + * stores it in private_data  member of filepointer
> + */
> +static int vpfe_open(struct file *file)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct vpfe_fh *fh;
> +
> +       if (!vpfe->cfg->num_subdevs) {
> +               dev_err(vpfe->dev, "No decoder/sensor registered\n");
> +               return -ENODEV;
> +       }
> +
> +       /* Allocate memory for the file handle object */
> +       fh = kmalloc(sizeof(*fh), GFP_KERNEL);
> +       if (NULL == fh)
> +               return -ENOMEM;
> +
> +       /* store pointer to fh in private_data member of file */
> +       file->private_data = fh;
> +       fh->vpfe = vpfe;
> +       mutex_lock(&vpfe->lock);
> +       /* If decoder is not initialized. initialize it */
> +       if (!vpfe->initialized) {
> +               if (vpfe_initialize_device(vpfe)) {
> +                       mutex_unlock(&vpfe->lock);
> +                       return -ENODEV;
> +               }
> +       }
> +       /* Increment device usrs counter */
> +       vpfe->usrs++;
> +       /* Set io_allowed member to false */
> +       fh->io_allowed = 0;
> +       /* Initialize priority of this instance to default priority */
> +       fh->prio = V4L2_PRIORITY_UNSET;
> +       v4l2_prio_open(&vpfe->prio, &fh->prio);
> +       mutex_unlock(&vpfe->lock);
> +
> +       return 0;
> +}
> +
> +/**
> + * vpfe_schedule_next_buffer: set next buffer address for capture
> + * @vpfe : ptr to device
> + *
> + * This function will get next buffer from the dma queue and
> + * set the buffer address in the vpfe register for capture.
> + * the buffer is marked active
> + *
> + * Assumes caller is holding vpfe->dma_queue_lock already
> + */
> +static void vpfe_schedule_next_buffer(struct vpfe_device *vpfe)
> +{
> +       unsigned long addr;
> +
> +       vpfe->next_frm = list_entry(vpfe->dma_queue.next,
> +                                       struct vpfe_cap_buffer, list);
> +       list_del(&vpfe->next_frm->list);
> +
> +       vpfe->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
> +       addr = vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb, 0);
> +
> +       vpfe->vpfe_isif.hw_ops.setfbaddr(&vpfe->vpfe_isif, addr);
> +}
> +
> +static void vpfe_schedule_bottom_field(struct vpfe_device *vpfe)
> +{
> +       unsigned long addr;
> +
> +       addr = vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb, 0);
> +       addr += vpfe->field_off;
> +       vpfe->vpfe_isif.hw_ops.setfbaddr(&vpfe->vpfe_isif, addr);
> +}
> +
> +/*
> + * vpfe_process_buffer_complete: process a completed buffer
> + * @vpfe : ptr to device
> + *
> + * This function time stamp the buffer and mark it as DONE. It also
> + * wake up any process waiting on the QUEUE and set the next buffer
> + * as current
> + */
> +static void vpfe_process_buffer_complete(struct vpfe_device *vpfe)
> +{
> +       v4l2_get_timestamp(&vpfe->cur_frm->vb.v4l2_buf.timestamp);
> +
> +       vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_DONE);
> +       vpfe->cur_frm = vpfe->next_frm;
> +}
> +
> +/*
> + * vpfe_isr : ISR handler for vpfe capture (VINT0)
> + * @irq: irq number
> + * @dev_id: dev_id ptr
> + *
> + * It changes status of the captured buffer, takes next buffer from the queue
> + * and sets its address in VPFE registers
> + */
> +static irqreturn_t vpfe_isr(int irq, void *dev_id)
> +{
> +       struct vpfe_device *vpfe = dev_id;
> +       int vpfe_intr_status;
> +       enum v4l2_field field;
> +       int fid;
> +
> +       /* Which interrupt did we get */
> +       vpfe_intr_status = vpfe->vpfe_isif.hw_ops.intr_status(
> +                                       &vpfe->vpfe_isif);
> +
> +       /* if streaming not started, don't do anything */
> +       if (!vpfe->started)
> +               goto clear_intr;
> +
> +       if (vpfe_intr_status & ISIF_VPFE_VDINT0) {
> +               field = vpfe->fmt.fmt.pix.field;
> +
> +               /* only for 6446 this will be applicable */
> +               if (vpfe->vpfe_isif.hw_ops.reset)
> +                       vpfe->vpfe_isif.hw_ops.reset(
> +                                       &vpfe->vpfe_isif);
> +
> +               if (field == V4L2_FIELD_NONE) {
> +                       /* handle progressive frame capture */
> +                       if (vpfe->cur_frm != vpfe->next_frm)
> +                               vpfe_process_buffer_complete(vpfe);
> +                       goto next_intr;
> +               }
> +
> +               /* interlaced or TB capture check which field
> +                  we are in hardware */
> +               fid = vpfe->vpfe_isif.hw_ops.getfid(
> +                                       &vpfe->vpfe_isif);
> +
> +               /* switch the software maintained field id */
> +               vpfe->field_id ^= 1;
> +               if (fid == vpfe->field_id) {
> +                       /* we are in-sync here,continue */
> +                       if (fid == 0) {
> +                               /*
> +                                * One frame is just being captured. If the
> +                                * next frame is available, release the
> +                                * current frame and move on
> +                                */
> +                               if (vpfe->cur_frm != vpfe->next_frm)
> +                                       vpfe_process_buffer_complete(vpfe);
> +                               /*
> +                                * based on whether the two fields are stored
> +                                * interleavely or separately in memory,
> +                                * reconfigure the ISIF memory address
> +                                */
> +                               if (field == V4L2_FIELD_SEQ_TB)
> +                                       vpfe_schedule_bottom_field(vpfe);
> +
> +                               goto next_intr;
> +                       }
> +                       /*
> +                        * if one field is just being captured configure
> +                        * the next frame get the next frame from the empty
> +                        * queue if no frame is available hold on to the
> +                        * current buffer
> +                        */
> +                       spin_lock(&vpfe->dma_queue_lock);
> +                       if (!list_empty(&vpfe->dma_queue) &&
> +                           vpfe->cur_frm == vpfe->next_frm)
> +                               vpfe_schedule_next_buffer(vpfe);
> +                       spin_unlock(&vpfe->dma_queue_lock);
> +               } else if (fid == 0) {
> +                       /*
> +                        * out of sync. Recover from any hardware out-of-sync.
> +                        * May loose one frame
> +                        */
> +                       vpfe->field_id = fid;
> +               }
> +       }
> +
> +next_intr:
> +       if (vpfe_intr_status & ISIF_VPFE_VDINT1) {
> +               spin_lock(&vpfe->dma_queue_lock);
> +               if ((vpfe->fmt.fmt.pix.field == V4L2_FIELD_NONE) &&
> +                   !list_empty(&vpfe->dma_queue) &&
> +                   vpfe->cur_frm == vpfe->next_frm)
> +                       vpfe_schedule_next_buffer(vpfe);
> +               spin_unlock(&vpfe->dma_queue_lock);
> +       }
> +
> +clear_intr:
> +       if (vpfe->vpfe_isif.hw_ops.clear_intr)
> +               vpfe->vpfe_isif.hw_ops.clear_intr(
> +                               &vpfe->vpfe_isif, vpfe_intr_status);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static void vpfe_detach_irq(struct vpfe_device *vpfe)
> +{
> +       enum isif_frmfmt frame_format;
> +       unsigned int intr = ISIF_VPFE_VDINT0;
> +
> +       frame_format = vpfe->vpfe_isif.hw_ops.get_frame_format(
> +                                       &vpfe->vpfe_isif);
> +       if (frame_format == ISIF_FRMFMT_PROGRESSIVE)
> +               intr |= ISIF_VPFE_VDINT1;
> +
> +       vpfe->vpfe_isif.hw_ops.intr_disable(
> +                       &vpfe->vpfe_isif, intr);
> +}
> +
> +static int vpfe_attach_irq(struct vpfe_device *vpfe)
> +{
> +       enum isif_frmfmt frame_format;
> +       unsigned int intr = ISIF_VPFE_VDINT0;
> +
> +       frame_format = vpfe->vpfe_isif.hw_ops.get_frame_format(
> +                                       &vpfe->vpfe_isif);
> +       if (frame_format == ISIF_FRMFMT_PROGRESSIVE)
> +               intr |= ISIF_VPFE_VDINT1;
> +
> +       vpfe->vpfe_isif.hw_ops.intr_enable(
> +                       &vpfe->vpfe_isif, intr);
> +       return 0;
> +}
> +
> +/* vpfe_stop_isif_capture: stop streaming in ccdc/isif */
> +static void vpfe_stop_isif_capture(struct vpfe_device *vpfe)
> +{
> +       vpfe->started = 0;
> +       vpfe->vpfe_isif.hw_ops.enable(&vpfe->vpfe_isif, 0);
> +       if (vpfe->vpfe_isif.hw_ops.enable_out_to_sdram)
> +               vpfe->vpfe_isif.hw_ops.enable_out_to_sdram(
> +                                       &vpfe->vpfe_isif, 0);
> +}
> +
> + /*
> + * vpfe_release : function to clean up file close
> + * @filep: file pointer
> + *
> + * This function deletes buffer queue, frees the
> + * buffers and the vpfe file  handle
> + */
> +static int vpfe_release(struct file *file)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct vpfe_fh *fh = file->private_data;
> +       struct vpfe_subdev_info *sdinfo;
> +       int ret;
> +
> +       /* Get the device lock */
> +       mutex_lock(&vpfe->lock);
> +       /* if this instance is doing IO */
> +       if (fh->io_allowed) {
> +               if (vpfe->started) {
> +                       sdinfo = vpfe->current_subdev;
> +                       ret = v4l2_device_call_until_err(&vpfe->v4l2_dev,
> +                                                        sdinfo->grp_id,
> +                                                        video, s_stream, 0);
> +                       if (ret && (ret != -ENOIOCTLCMD))
> +                               dev_err(vpfe->dev,
> +                                       "stream off failed in subdev\n");
> +                       vpfe_stop_isif_capture(vpfe);
> +                       vpfe_detach_irq(vpfe);
> +                       vb2_queue_release(&vpfe->buffer_queue);
> +                       vb2_dma_contig_cleanup_ctx(vpfe->alloc_ctx);
> +               }
> +               vpfe->io_usrs = 0;
> +               vpfe->numbuffers = config_params.numbuffers;
> +       }
> +
> +       /* Decrement device usrs counter */
> +       vpfe->usrs--;
> +       /* Close the priority */
> +       v4l2_prio_close(&vpfe->prio, fh->prio);
> +       /* If this is the last file handle */
> +       if (!vpfe->usrs) {
> +               vpfe->initialized = 0;
> +               if (vpfe->vpfe_isif.hw_ops.close)
> +                       vpfe->vpfe_isif.hw_ops.close(
> +                               &vpfe->vpfe_isif, vpfe->dev);
> +       }
> +       mutex_unlock(&vpfe->lock);
> +       file->private_data = NULL;
> +
> +       /* Free memory allocated to file handle object */
> +       kfree(fh);
> +
> +       return 0;
> +}
> +
> +/*
> + * vpfe_mmap : It is used to map kernel space buffers into user spaces
> + * @file: file pointer
> + * @vma: ptr to vm_area_struct
> + */
> +static int vpfe_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       /* Get the device object and file handle object */
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       int ret;
> +
> +       if (mutex_lock_interruptible(&vpfe->lock))
> +               return -ERESTARTSYS;
> +
> +       ret = vb2_mmap(&vpfe->buffer_queue, vma);
> +       mutex_unlock(&vpfe->lock);
> +
> +       return ret;
> +}
> +
> +/*
> + * vpfe_poll: It is used for select/poll system call
> + * @filep: file pointer
> + * @wait: poll table to wait
> + */
> +static unsigned int vpfe_poll(struct file *file, poll_table *wait)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       int ret = 0;
> +
> +       if (vpfe->started) {
> +               mutex_lock(&vpfe->lock);
> +               ret = vb2_poll(&vpfe->buffer_queue, file, wait);
> +               mutex_unlock(&vpfe->lock);
> +       }
> +
> +       return ret;
> +}
> +
> +/* vpfe capture driver file operations */
> +static const struct v4l2_file_operations vpfe_fops = {
> +       .owner = THIS_MODULE,
> +       .open = vpfe_open,
> +       .release = vpfe_release,
> +       .unlocked_ioctl = video_ioctl2,
> +       .mmap = vpfe_mmap,
> +       .poll = vpfe_poll
> +};
> +
> +static int vpfe_querycap(struct file *file, void  *priv,
> +                              struct v4l2_capability *cap)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +
> +       cap->version = KERNEL_VERSION(3, 17, 0);
> +       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING
> +               | V4L2_CAP_READWRITE;
> +       cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +       strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
> +       snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +                       "VPFE");
> +       strlcpy(cap->card, vpfe->cfg->card_name, sizeof(cap->card));
> +
> +       return 0;
> +}
> +
> +/* get the subdev which is connected to the output video node */
> +static struct v4l2_subdev *
> +vpfe_remote_subdev(struct vpfe_device *vpfe, u32 *pad)
> +{
> +       struct media_pad *remote = media_entity_remote_pad(&vpfe->pad);
> +
> +       if (remote == NULL)
> +               return NULL;
> +       else if ((remote->entity->type & MEDIA_ENT_T_V4L2_SUBDEV) == 0)
> +               return NULL;
> +
> +       if (pad)
> +               *pad = remote->index;
> +
> +       return media_entity_to_v4l2_subdev(remote->entity);
> +}
> +
> +/* get the format set at output pad of the adjacent subdev */
> +static int __vpfe_get_format(struct vpfe_device *vpfe,
> +                       struct v4l2_format *format, unsigned int *bpp)
> +{
> +       struct v4l2_subdev_format fmt;
> +       struct v4l2_subdev *subdev;
> +       struct media_pad *remote;
> +       u32 pad;
> +       int ret;
> +
> +       subdev = vpfe_remote_subdev(vpfe, &pad);
> +       if (subdev == NULL)
> +               return -EINVAL;
> +
> +       fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +       remote = media_entity_remote_pad(&vpfe->pad);
> +       fmt.pad = remote->index;
> +
> +       ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
> +       if (ret == -ENOIOCTLCMD)
> +               return -EINVAL;
> +
> +       format->type = vpfe->fmt.type;
> +
> +       /* convert mbus_format to v4l2_format */
> +       v4l2_fill_pix_format(&format->fmt.pix, &fmt.format);
> +       mbus_to_pix(vpfe, &fmt.format, &format->fmt.pix, bpp);
> +
> +       return 0;
> +}
> +
> +/* set the format at output pad of the adjacent subdev */
> +static int __vpfe_set_format(struct vpfe_device *vpfe,
> +                       struct v4l2_format *format, unsigned int *bpp)
> +{
> +       struct v4l2_subdev_format fmt;
> +       struct v4l2_subdev *subdev;
> +       struct media_pad *remote;
> +       u32 pad;
> +       int ret;
> +
> +       subdev = vpfe_remote_subdev(vpfe, &pad);
> +       if (subdev == NULL)
> +               return -EINVAL;
> +
> +       fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +       remote = media_entity_remote_pad(&vpfe->pad);
> +       fmt.pad = remote->index;
> +
> +       ret = pix_to_mbus(vpfe, &format->fmt.pix, &fmt.format);
> +       if (ret)
> +               return ret;
> +
> +       ret = v4l2_subdev_call(subdev, pad, set_fmt, NULL, &fmt);
> +       if (ret == -ENOIOCTLCMD)
> +               return -EINVAL;
> +
> +       format->type = vpfe->fmt.type;
> +
> +       /* convert mbus_format to v4l2_format */
> +       v4l2_fill_pix_format(&format->fmt.pix, &fmt.format);
> +       mbus_to_pix(vpfe, &fmt.format, &format->fmt.pix, bpp);
> +
> +       return 0;
> +}
> +
> +static int vpfe_g_fmt(struct file *file, void *priv,
> +                               struct v4l2_format *fmt)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct v4l2_format format;
> +       unsigned int bpp;
> +       int ret = 0;
> +
> +       ret = __vpfe_get_format(vpfe, &format, &bpp);
> +       if (ret)
> +               return ret;
> +
> +       /* Fill in the information about format */
> +       *fmt = vpfe->fmt;
> +       return ret;
> +}
> +
> +static int vpfe_enum_fmt(struct file *file, void  *priv,
> +                                  struct v4l2_fmtdesc *fmt)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct v4l2_mbus_framefmt mbus;
> +       struct v4l2_subdev_mbus_code_enum mbus_code;
> +       struct v4l2_subdev *subdev;
> +       struct media_pad *remote;
> +       struct v4l2_pix_format pix;
> +       u32 pad, bpp;
> +       int ret;
> +
> +       subdev = vpfe_remote_subdev(vpfe, &pad);
> +       if (subdev == NULL)
> +               return -EINVAL;
> +
> +       remote = media_entity_remote_pad(&vpfe->pad);
> +       mbus_code.index = fmt->index;
> +       ret = v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &mbus_code);
> +       if (ret)
> +               return -EINVAL;
> +
> +       mbus.code = mbus_code.code;
> +       mbus_to_pix(vpfe, &mbus, &pix, &bpp);
> +
> +       /* Should be V4L2_BUF_TYPE_VIDEO_CAPTURE */
> +       fmt->type = vpfe->fmt.type;
> +       fmt->pixelformat = pix.pixelformat;
> +
> +       switch (fmt->pixelformat) {
> +       case V4L2_PIX_FMT_UYVY:
> +       case V4L2_PIX_FMT_YUYV:
> +       case V4L2_PIX_FMT_VYUY:
> +               snprintf(fmt->description, sizeof(fmt->description),
> +                               "YUV 4:2:2");
> +               break;
> +       case V4L2_PIX_FMT_YVYU:
> +               snprintf(fmt->description, sizeof(fmt->description),
> +                               "YVU 4:2:2");
> +               break;
> +       case V4L2_PIX_FMT_NV12:
> +               snprintf(fmt->description, sizeof(fmt->description),
> +                               "Y/CbCr 4:2:0");
> +               break;
> +       case V4L2_PIX_FMT_YUV420:
> +               snprintf(fmt->description, sizeof(fmt->description),
> +                               "YUV 4:2:0");
> +               break;
> +       case V4L2_PIX_FMT_SBGGR8:
> +       case V4L2_PIX_FMT_SGBRG8:
> +       case V4L2_PIX_FMT_SGRBG8:
> +       case V4L2_PIX_FMT_SRGGB8:
> +               snprintf(fmt->description, sizeof(fmt->description),
> +                               "SRGB-8");
> +               break;
> +       case V4L2_PIX_FMT_RGB565:
> +               snprintf(fmt->description, sizeof(fmt->description),
> +                               "RGB-16 (5-6-5)");
> +               break;
> +       case V4L2_PIX_FMT_RGB565X:
> +               snprintf(fmt->description, sizeof(fmt->description),
> +                               "RGB-16 (5-6-5) BE");
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +static int vpfe_s_fmt(struct file *file, void *priv,
> +                               struct v4l2_format *fmt)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct v4l2_format format;
> +       unsigned int bpp;
> +       int ret = 0;
> +
> +       memset(&format, 0x00, sizeof(format));
> +
> +       /* If streaming is started, return error */
> +       if (vpfe->started) {
> +               dev_err(vpfe->dev, "Streaming is started\n");
> +               return -EBUSY;
> +       }
> +
> +       /* Check for valid frame format */
> +       ret = __vpfe_get_format(vpfe, &format, &bpp);
> +       if (ret)
> +               return ret;
> +       if (!cmp_v4l2_format(fmt, &format)) {
> +               /* Sensor format is different from the requested format
> +                * so we need to change it
> +                */
> +               ret = __vpfe_set_format(vpfe, fmt, &bpp);
> +               if (ret)
> +                       return ret;
> +       } else /* Just make sure all of the fields are consistent */
> +               *fmt = format;
> +
> +       /* store the pixel format in the device  object */
> +       ret = mutex_lock_interruptible(&vpfe->lock);
> +       if (ret)
> +               return ret;
> +
> +       /* First detach any IRQ if currently attached */
> +       vpfe_detach_irq(vpfe);
> +       vpfe->fmt = *fmt;
> +       vpfe->bpp = bpp;
> +
> +       /* Update the crop window based on found values */
> +       vpfe->crop.width = fmt->fmt.pix.width;
> +       vpfe->crop.height = fmt->fmt.pix.height;
> +
> +       /* set image capture parameters in the isif */
> +       ret = vpfe_config_isif_image_format(vpfe);
> +       mutex_unlock(&vpfe->lock);
> +
> +       return ret;
> +}
> +
> +static int vpfe_try_fmt(struct file *file, void *priv,
> +                                 struct v4l2_format *fmt)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct v4l2_format format;
> +       unsigned int bpp;
> +       int ret = 0;
> +
> +       memset(&format, 0x00, sizeof(format));
> +
> +       ret = __vpfe_get_format(vpfe, &format, &bpp);
> +       if (ret)
> +               return ret;
> +
> +       *fmt = format;
> +
> +       return 0;
> +}
> +
> +static int vpfe_enum_size(struct file *file, void  *priv,
> +                                  struct v4l2_frmsizeenum *fsize)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct v4l2_mbus_framefmt mbus;
> +       struct v4l2_subdev_frame_size_enum fse;
> +       struct v4l2_subdev *subdev;
> +       struct media_pad *remote;
> +       struct v4l2_pix_format pix;
> +       u32 pad;
> +       int ret;
> +
> +       memset(fsize->reserved, 0x00, sizeof(fsize->reserved));
> +
> +       subdev = vpfe_remote_subdev(vpfe, &pad);
> +       if (subdev == NULL)
> +               return -EINVAL;
> +
> +       /* Construct pix from parameter and use defualt for the rest */
> +       pix.pixelformat = fsize->pixel_format;
> +       pix.width = 640;
> +       pix.height = 480;
> +       pix.colorspace = V4L2_COLORSPACE_JPEG;
> +       pix.field = V4L2_FIELD_NONE;
> +
> +       ret = pix_to_mbus(vpfe, &pix, &mbus);
> +       if (ret)
> +               return ret;
> +
> +       remote = media_entity_remote_pad(&vpfe->pad);
> +       fse.index = fsize->index;
> +       fse.pad = remote->index;
> +       fse.code = mbus.code;
> +
> +       ret = v4l2_subdev_call(subdev, pad, enum_frame_size, NULL, &fse);
> +       if (ret)
> +               return -EINVAL;
> +
> +       fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +       fsize->discrete.width = fse.max_width;
> +       fsize->discrete.height = fse.max_height;
> +
> +       return 0;
> +}
> +
> +/*
> + * vpfe_get_subdev_input_index - Get subdev index and subdev input index for a
> + * given app input index
> + */
> +static int vpfe_get_subdev_input_index(struct vpfe_device *vpfe,
> +                                       int *subdev_index,
> +                                       int *subdev_input_index,
> +                                       int app_input_index)
> +{
> +       struct vpfe_config *cfg = vpfe->cfg;
> +       struct vpfe_subdev_info *sdinfo;
> +       int i, j = 0;
> +
> +       for (i = 0; i < cfg->num_subdevs; i++) {
> +               sdinfo = &cfg->sub_devs[i];
> +               if (app_input_index < (j + sdinfo->num_inputs)) {
> +                       *subdev_index = i;
> +                       *subdev_input_index = app_input_index - j;
> +                       return 0;
> +               }
> +               j += sdinfo->num_inputs;
> +       }
> +
> +       return -EINVAL;
> +}
> +
> +/*
> + * vpfe_get_app_input - Get app input index for a given subdev input index
> + * driver stores the input index of the current sub device and translate it
> + * when application request the current input
> + */
> +static int vpfe_get_app_input_index(struct vpfe_device *vpfe,
> +                                   int *app_input_index)
> +{
> +       struct vpfe_config *cfg = vpfe->cfg;
> +       struct vpfe_subdev_info *sdinfo;
> +       int i, j = 0;
> +
> +       for (i = 0; i < cfg->num_subdevs; i++) {
> +               sdinfo = &cfg->sub_devs[i];
> +               if (!strcmp(sdinfo->name, vpfe->current_subdev->name)) {
> +                       if (vpfe->current_input >= sdinfo->num_inputs)
> +                               return -1;
> +                       *app_input_index = j + vpfe->current_input;
> +                       return 0;
> +               }
> +               j += sdinfo->num_inputs;
> +       }
> +
> +       return -EINVAL;
> +}
> +
> +static int vpfe_enum_input(struct file *file, void *priv,
> +                                struct v4l2_input *inp)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct vpfe_subdev_info *sdinfo;
> +       int subdev, index;
> +
> +       if (vpfe_get_subdev_input_index(vpfe,
> +                               &subdev, &index,
> +                               inp->index) < 0)
> +               return -EINVAL;
> +
> +       sdinfo = &vpfe->cfg->sub_devs[subdev];
> +       memcpy(inp, &sdinfo->inputs[index], sizeof(struct v4l2_input));
> +
> +       return 0;
> +}
> +
> +static int vpfe_g_input(struct file *file, void *priv, unsigned int *index)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +
> +       return vpfe_get_app_input_index(vpfe, index);
> +}
> +
> +/* Assumes caller is holding vpfe->lock */
> +static int vpfe_set_input(struct vpfe_device *vpfe, unsigned int index)
> +{
> +       struct v4l2_subdev *sd;
> +       struct vpfe_subdev_info *sdinfo;
> +       int subdev_index = 0, inp_index = 0;
> +       struct vpfe_route *route;
> +       u32 input = 0, output = 0;
> +       int ret = -EINVAL;
> +
> +       /*
> +        * If streaming is started return device busy
> +        * error
> +        */
> +       if (vpfe->started) {
> +               dev_err(vpfe->dev, "Streaming is on\n");
> +               ret = -EBUSY;
> +               goto get_out;
> +       }
> +       ret = vpfe_get_subdev_input_index(vpfe,
> +                       &subdev_index, &inp_index, index);
> +       if (ret < 0) {
> +               dev_err(vpfe->dev, "invalid input index\n");
> +               goto get_out;
> +       }
> +
> +       sdinfo = &vpfe->cfg->sub_devs[subdev_index];
> +       sd = vpfe->sd[subdev_index];
> +       route = &sdinfo->routes[inp_index];
> +       if (route && sdinfo->can_route) {
> +               input = route->input;
> +               output = route->output;
> +               if (sd)
> +                       ret = v4l2_subdev_call(sd, video,
> +                                       s_routing, input, output, 0);
> +
> +               if (ret) {
> +                       ret = -EINVAL;
> +                       goto get_out;
> +               }
> +       }
> +
> +       vpfe->current_subdev = sdinfo;
> +       vpfe->current_input = index;
> +       vpfe->std_index = 0;
> +
> +       /* set the bus/interface parameter for the sub device in isif */
> +       ret = vpfe->vpfe_isif.hw_ops.set_hw_if_params(
> +                       &vpfe->vpfe_isif, &sdinfo->isif_if_params);
> +       if (ret)
> +               goto get_out;
> +
> +       /* set the default image parameters in the device */
> +       ret = vpfe_config_image_format(vpfe,
> +                               vpfe_standards[vpfe->std_index].std_id);
> +
> +get_out:
> +       return ret;
> +}
> +
> +static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       int ret = -EINVAL;
> +
> +       ret = mutex_lock_interruptible(&vpfe->lock);
> +       if (ret)
> +               return ret;
> +
> +       ret = vpfe_set_input(vpfe, index);
> +       mutex_unlock(&vpfe->lock);
> +
> +       return ret;
> +}
> +
> +static int vpfe_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct vpfe_subdev_info *sdinfo;
> +       int ret = 0;
> +
> +       ret = mutex_lock_interruptible(&vpfe->lock);
> +       sdinfo = vpfe->current_subdev;
> +       if (ret)
> +               return ret;
> +
> +       /* Call querystd function of decoder device */
> +       ret = v4l2_device_call_until_err(&vpfe->v4l2_dev, sdinfo->grp_id,
> +                                        video, querystd, std_id);
> +       mutex_unlock(&vpfe->lock);
> +
> +       return ret;
> +}
> +
> +static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id std_id)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct vpfe_subdev_info *sdinfo;
> +       int ret = 0;
> +
> +       /* Call decoder driver function to set the standard */
> +       ret = mutex_lock_interruptible(&vpfe->lock);
> +       if (ret)
> +               return ret;
> +
> +       sdinfo = vpfe->current_subdev;
> +       /* If streaming is started, return device busy error */
> +       if (vpfe->started) {
> +               dev_err(vpfe->dev, "streaming is started\n");
> +               ret = -EBUSY;
> +               goto unlock_out;
> +       }
> +
> +       ret = v4l2_device_call_until_err(&vpfe->v4l2_dev, sdinfo->grp_id,
> +                                        video, s_std, std_id);
> +       if (ret < 0) {
> +               dev_err(vpfe->dev, "Failed to set standard\n");
> +               goto unlock_out;
> +       }
> +       ret = vpfe_config_image_format(vpfe, std_id);
> +
> +unlock_out:
> +       mutex_unlock(&vpfe->lock);
> +
> +       return ret;
> +}
> +
> +static int vpfe_g_std(struct file *file, void *priv, v4l2_std_id *std_id)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +
> +       *std_id = vpfe_standards[vpfe->std_index].std_id;
> +
> +       return 0;
> +}
> +/*
> + *  Videobuf operations
> + */
> +
> +/*
> + * vpfe_buffer_queue_setup : Callback function for buffer setup.
> + * @vq: vb2_queue ptr
> + * @fmt: v4l2 format
> + * @nbuffers: ptr to number of buffers requested by application
> + * @nplanes:: contains number of distinct video planes needed to hold a frame
> + * @sizes[]: contains the size (in bytes) of each plane.
> + * @alloc_ctxs: ptr to allocation context
> + *
> + * This callback function is called when reqbuf() is called to adjust
> + * the buffer count and buffer size
> + */
> +
> +static int vpfe_buffer_queue_setup(struct vb2_queue *vq,
> +                               const struct v4l2_format *fmt,
> +                               unsigned int *nbuffers, unsigned int *nplanes,
> +                               unsigned int sizes[], void *alloc_ctxs[])
> +{
> +       struct vpfe_fh *fh = vb2_get_drv_priv(vq);
> +       struct vpfe_device *vpfe = fh->vpfe;
> +       unsigned long size;
> +
> +       size = vpfe->fmt.fmt.pix.sizeimage;
> +
> +       if (*nbuffers < config_params.min_numbuffers)
> +               *nbuffers = config_params.min_numbuffers;
> +
> +       *nplanes = 1;
> +       sizes[0] = size;
> +       alloc_ctxs[0] = vpfe->alloc_ctx;
> +
> +       return 0;
> +}
> +
> +/*
> + * vpfe_buffer_prepare :  callback function for buffer prepare
> + * @vb: ptr to vb2_buffer
> + *
> + * This is the callback function for buffer prepare when vb2_qbuf()
> + * function is called. The buffer is prepared and user space virtual address
> + * or user address is converted into  physical address
> + */
> +static int vpfe_buffer_prepare(struct vb2_buffer *vb)
> +{
> +       struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
> +       struct vpfe_device *vpfe = fh->vpfe;
> +       unsigned long addr;
> +
> +       /* If buffer is not initialized, initialize it */
> +       if (vb->state != VB2_BUF_STATE_ACTIVE &&
> +           vb->state != VB2_BUF_STATE_PREPARED) {
> +               vb2_set_plane_payload(vb, 0, vpfe->fmt.fmt.pix.sizeimage);
> +               if (vb2_plane_vaddr(vb, 0) &&
> +                   vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
> +                       goto exit;
> +               addr = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +               /* Make sure user addresses are aligned to 32 bytes */
> +               if (!ALIGN(addr, 32))
> +                       goto exit;
> +       }
> +
> +       return 0;
> +
> +exit:
> +       return -EINVAL;
> +}
> +
> +/*
> + * vpfe_buffer_queue : Callback function to add buffer to DMA queue
> + * @vb: ptr to vb2_buffer
> + */
> +static void vpfe_buffer_queue(struct vb2_buffer *vb)
> +{
> +       /* Get the file handle object and device object */
> +       struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
> +       struct vpfe_device *vpfe = fh->vpfe;
> +       struct vpfe_cap_buffer *buf = container_of(vb,
> +                                       struct vpfe_cap_buffer, vb);
> +       unsigned long flags;
> +
> +       /* add the buffer to the DMA queue */
> +       spin_lock_irqsave(&vpfe->dma_queue_lock, flags);
> +       list_add_tail(&buf->list, &vpfe->dma_queue);
> +       spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
> +}
> +
> +/*
> + * vpfe_buffer_cleanup : Callback function to free buffer
> + * @vb: ptr to vb2_buffer
> + *
> + * This function is called from the videobuf2 layer to free memory
> + * allocated to  the buffers
> + */
> +static void vpfe_buffer_cleanup(struct vb2_buffer *vb)
> +{
> +       /* Get the file handle object and device object */
> +       struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
> +       struct vpfe_device *vpfe = fh->vpfe;
> +       struct vpfe_cap_buffer *buf = container_of(vb,
> +                                       struct vpfe_cap_buffer, vb);
> +       unsigned long flags;
> +
> +       /*
> +        * We need to flush the buffer from the dma queue since
> +        * they are de-allocated
> +        */
> +       spin_lock_irqsave(&vpfe->dma_queue_lock, flags);
> +
> +       if (vb->state == VB2_BUF_STATE_ACTIVE)
> +               list_del_init(&buf->list);
> +
> +       spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
> +}
> +
> +static void vpfe_wait_prepare(struct vb2_queue *vq)
> +{
> +       struct vpfe_fh *fh = vb2_get_drv_priv(vq);
> +       struct vpfe_device *vpfe = fh->vpfe;
> +
> +       mutex_unlock(&vpfe->lock);
> +}
> +
> +static void vpfe_wait_finish(struct vb2_queue *vq)
> +{
> +       struct vpfe_fh *fh = vb2_get_drv_priv(vq);
> +       struct vpfe_device *vpfe = fh->vpfe;
> +
> +       mutex_lock(&vpfe->lock);
> +}
> +

make use of vb2_ops_wait_prepare/finish helper functions.


> +static int vpfe_buffer_init(struct vb2_buffer *vb)
> +{
> +       struct vpfe_cap_buffer *buf = container_of(vb,
> +                                       struct vpfe_cap_buffer, vb);
> +
> +       INIT_LIST_HEAD(&buf->list);
> +
> +       return 0;
> +}

Is this required ?

> +
> +static void vpfe_calculate_offsets(struct vpfe_device *vpfe);
> +static void vpfe_start_isif_capture(struct vpfe_device *vpfe);
> +
> +static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +       struct vpfe_fh *fh = vb2_get_drv_priv(vq);
> +       struct vpfe_device *vpfe = fh->vpfe;
> +       unsigned long addr = 0;
> +       unsigned long flags;
> +       int ret = 0;
> +
> +       /* If buffer queue is empty, return error */
> +       spin_lock_irqsave(&vpfe->dma_queue_lock, flags);
> +       if (list_empty(&vpfe->dma_queue)) {
> +               spin_unlock_irqrestore(&vpfe->irqlock, flags);
> +               return -EIO;
> +       }
> +
> +       /* Get the next frame from the buffer queue */
> +       vpfe->next_frm = list_entry(vpfe->dma_queue.next,
> +                                       struct vpfe_cap_buffer, list);
> +       vpfe->cur_frm = vpfe->next_frm;
> +       /* Remove buffer from the buffer queue */
> +       list_del(&vpfe->cur_frm->list);
> +       spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
> +
> +       /* Mark state of the current frame to active */
> +       vpfe->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
> +       /* Initialize field_id and started member */
> +       vpfe->field_id = 0;
> +       addr = vb2_dma_contig_plane_dma_addr(&vpfe->cur_frm->vb, 0);
> +
> +       /* Calculate field offset */
> +       vpfe_calculate_offsets(vpfe);
> +
> +       if (vpfe_attach_irq(vpfe) < 0) {
> +               dev_err(vpfe->dev,
> +                       "Error in attaching interrupt handle\n");
> +               return -EFAULT;
> +       }
> +       if (vpfe->vpfe_isif.hw_ops.configure(&vpfe->vpfe_isif) < 0) {
> +               dev_err(vpfe->dev,
> +                       "Error in configuring isif\n");
> +               return -EINVAL;
> +       }
> +
> +       vpfe->vpfe_isif.hw_ops.setfbaddr(
> +                       &vpfe->vpfe_isif, (unsigned long)(addr));
> +       vpfe_start_isif_capture(vpfe);
> +
> +       return ret;
> +}
> +
> +/* abort streaming and wait for last buffer */
> +static void vpfe_stop_streaming(struct vb2_queue *vq)
> +{
> +       struct vpfe_fh *fh = vb2_get_drv_priv(vq);
> +       struct vpfe_device *vpfe = fh->vpfe;
> +       unsigned long flags;
> +
> +       if (!vb2_is_streaming(vq))
> +               return;
> +
> +       /* release all active buffers */
> +       spin_lock_irqsave(&vpfe->dma_queue_lock, flags);
> +
> +       if (vpfe->cur_frm)
> +               vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_DONE);
> +
> +       while (!list_empty(&vpfe->dma_queue)) {
> +               struct vpfe_cap_buffer *buf;
> +
> +               buf = list_first_entry(&vpfe->dma_queue, struct vpfe_cap_buffer,
> +                               list);
> +               list_del(&buf->list);
> +               vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +       }
> +
> +       spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
> +}
> +
> +static struct vb2_ops video_qops = {
> +       .queue_setup            = vpfe_buffer_queue_setup,
> +       .wait_prepare           = vpfe_wait_prepare,
> +       .wait_finish            = vpfe_wait_finish,
> +       .buf_init               = vpfe_buffer_init,
> +       .buf_prepare            = vpfe_buffer_prepare,
> +       .start_streaming        = vpfe_start_streaming,
> +       .stop_streaming         = vpfe_stop_streaming,
> +       .buf_cleanup            = vpfe_buffer_cleanup,
> +       .buf_queue              = vpfe_buffer_queue,
> +};
> +
> +/*
> + * vpfe_reqbufs() - request buffer handler
> + * @file: file ptr
> + * @priv: file handle
> + * @reqbuf: request buffer structure ptr
> + *
> + * Currently support REQBUF only once opening
> + * the device.
> + */
> +static int vpfe_reqbufs(struct file *file, void *priv,
> +                       struct v4l2_requestbuffers *req_buf)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct vpfe_fh *fh = file->private_data;
> +       struct vb2_queue *q;
> +       int ret = 0;
> +
> +       if (req_buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +               dev_err(vpfe->dev, "Invalid buffer type\n");
> +               return -EINVAL;
> +       }
> +
> +       ret = mutex_lock_interruptible(&vpfe->lock);
> +       if (ret)
> +               return ret;
> +
> +       if (vpfe->io_usrs != 0) {
> +               dev_err(vpfe->dev, "Only one IO user allowed\n");
> +               ret = -EBUSY;
> +               goto unlock_out;
> +       }
> +
> +       /* Initialize videobuf2 queue as per the buffer type */
> +       vpfe->alloc_ctx = vb2_dma_contig_init_ctx(vpfe->dev);
> +       if (IS_ERR(vpfe->alloc_ctx)) {
> +               dev_err(vpfe->dev, "Failed to get the context\n");
> +               ret = PTR_ERR(vpfe->alloc_ctx);
> +               goto unlock_out;
> +       }
> +
> +       q = &vpfe->buffer_queue;
> +       q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       q->io_modes = VB2_MMAP | VB2_USERPTR;
> +       q->drv_priv = fh;
> +       q->ops = &video_qops;
> +       q->mem_ops = &vb2_dma_contig_memops;
> +       q->buf_struct_size = sizeof(struct vpfe_cap_buffer);
> +       q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +
> +       ret = vb2_queue_init(q);
> +       if (ret) {
> +               dev_err(vpfe->dev, "vb2_queue_init() failed\n");
> +               vb2_dma_contig_cleanup_ctx(vpfe->alloc_ctx);
> +               goto unlock_out;
> +       }
> +
> +       /* Set io allowed member of file handle to TRUE */
> +       fh->io_allowed = 1;
> +       /* Increment io usrs member of channel object to 1 */
> +       vpfe->io_usrs = 1;
> +       /* Store type of memory requested in channel object */
> +       vpfe->memory = req_buf->memory;
> +       INIT_LIST_HEAD(&vpfe->dma_queue);
> +
> +       /* Allocate buffers */
> +       ret = vb2_reqbufs(&vpfe->buffer_queue, req_buf);
> +
> +unlock_out:
> +       mutex_unlock(&vpfe->lock);
> +
> +       return ret;
> +}
> +
> +/*
> + * vpfe_querybuf() - query buffer handler
> + * @file: file ptr
> + * @priv: file handle
> + * @buf: v4l2 buffer structure ptr
> + */
> +static int vpfe_querybuf(struct file *file, void *priv,
> +                        struct v4l2_buffer *buf)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +
> +       if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +               dev_dbg(vpfe->dev, "Invalid buf type\n");
> +               return  -EINVAL;
> +       }
> +
> +       if (vpfe->memory != V4L2_MEMORY_MMAP) {
> +               dev_dbg(vpfe->dev, "Invalid memory\n");
> +               return -EINVAL;
> +       }
> +
> +       return vb2_querybuf(&vpfe->buffer_queue, buf);
> +}
> +
> +/*
> + * vpfe_qbuf() - queue buffer handler
> + * @file: file ptr
> + * @priv: file handle
> + * @buf: v4l2 buffer structure ptr
> + */
> +static int vpfe_qbuf(struct file *file, void *priv,
> +                    struct v4l2_buffer *buf)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct vpfe_fh *fh = file->private_data;
> +
> +       if (V4L2_BUF_TYPE_VIDEO_CAPTURE != buf->type) {
> +               dev_err(vpfe->dev, "Invalid buf type\n");
> +               return -EINVAL;
> +       }
> +
> +       /*
> +        * If this file handle is not allowed to do IO,
> +        * return error
> +        */
> +       if (!fh->io_allowed) {
> +               dev_err(vpfe->dev, "fh->io_allowed\n");
> +               return -EACCES;
> +       }
> +
> +       return vb2_qbuf(&vpfe->buffer_queue, buf);
> +}
> +
> +/*
> + * vpfe_dqbuf() - dequeue buffer handler
> + * @file: file ptr
> + * @priv: file handle
> + * @buf: v4l2 buffer structure ptr
> + */
> +static int vpfe_dqbuf(struct file *file, void *priv,
> +                     struct v4l2_buffer *buf)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +
> +       if (V4L2_BUF_TYPE_VIDEO_CAPTURE != buf->type) {
> +               dev_err(vpfe->dev, "Invalid buf type\n");
> +               return -EINVAL;
> +       }
> +
> +       return vb2_dqbuf(&vpfe->buffer_queue, buf,
> +                       (file->f_flags & O_NONBLOCK));
> +}
> +
> +/*
> + * vpfe_calculate_offsets : This function calculates buffers offset
> + * for top and bottom field
> + */
> +static void vpfe_calculate_offsets(struct vpfe_device *vpfe)
> +{
> +       struct v4l2_rect image_win;
> +
> +       vpfe->vpfe_isif.hw_ops.get_image_window(
> +                               &vpfe->vpfe_isif, &image_win);
> +       vpfe->field_off = image_win.height * image_win.width;
> +}
> +
> +/* vpfe_start_isif_capture: start streaming in ccdc/isif */
> +static void vpfe_start_isif_capture(struct vpfe_device *vpfe)
> +{
> +       vpfe->vpfe_isif.hw_ops.enable(&vpfe->vpfe_isif, 1);
> +       if (vpfe->vpfe_isif.hw_ops.enable_out_to_sdram)
> +               vpfe->vpfe_isif.hw_ops.enable_out_to_sdram(
> +                               &vpfe->vpfe_isif, 1);
> +       vpfe->started = 1;
> +}
> +
> +/*
> + * vpfe_streamon() - streamon handler
> + * @file: file ptr
> + * @priv: file handle
> + * @buftype: v4l2 buffer type
> +
> + * Assume the DMA queue is not empty.
> + * application is expected to call QBUF before calling
> + * this ioctl. If not, driver returns error
> + */
> +static int vpfe_streamon(struct file *file, void *priv,
> +                        enum v4l2_buf_type buf_type)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct vpfe_fh *fh = file->private_data;
> +       struct vpfe_subdev_info *sdinfo;
> +       int ret = 0;
> +
> +       if (V4L2_BUF_TYPE_VIDEO_CAPTURE != buf_type) {
> +               dev_err(vpfe->dev, "Invalid buf type\n");
> +               return -EINVAL;
> +       }
> +
> +       /* If file handle is not allowed IO, return error */
> +       if (!fh->io_allowed) {
> +               dev_err(vpfe->dev, "fh->io_allowed\n");
> +               return -EACCES;
> +       }
> +
> +       /* If streaming is already started, return error */
> +       if (vpfe->started) {
> +               dev_err(vpfe->dev, "device started\n");
> +               return -EBUSY;
> +       }
> +
> +       sdinfo = vpfe->current_subdev;
> +       ret = v4l2_device_call_until_err(&vpfe->v4l2_dev, sdinfo->grp_id,
> +                                       video, s_stream, 1);
> +
> +       if (ret && (ret != -ENOIOCTLCMD)) {
> +               dev_err(vpfe->dev, "stream on failed in subdev\n");
> +               return -EINVAL;
> +       }
> +
> +       ret = mutex_lock_interruptible(&vpfe->lock);
> +       if (ret)
> +               goto unlock_out;
> +
> +       /* Call vb2_streamon to start streaming * in videobuf2 */
> +       ret = vb2_streamon(&vpfe->buffer_queue, buf_type);
> +       if (ret)
> +               goto unlock_out;
> +
> +unlock_out:
> +       mutex_unlock(&vpfe->lock);
> +
> +       return ret;
> +}
> +
> +/*
> + * vpfe_streamoff() - streamoff handler
> + * @file: file ptr
> + * @priv: file handle
> + * @buftype: v4l2 buffer type
> + */
> +static int vpfe_streamoff(struct file *file, void *priv,
> +                         enum v4l2_buf_type buf_type)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct vpfe_fh *fh = file->private_data;
> +       struct vpfe_subdev_info *sdinfo;
> +       int ret = 0;
> +
> +       if (V4L2_BUF_TYPE_VIDEO_CAPTURE != buf_type) {
> +               dev_err(vpfe->dev, "Invalid buf type\n");
> +               return -EINVAL;
> +       }
> +
> +       /* If io is allowed for this file handle, return error */
> +       if (!fh->io_allowed) {
> +               dev_err(vpfe->dev, "fh->io_allowed\n");
> +               return -EACCES;
> +       }
> +
> +       /* If streaming is not started, return error */
> +       if (!vpfe->started) {
> +               dev_err(vpfe->dev, "device started\n");
> +               return -EINVAL;
> +       }
> +
> +       ret = mutex_lock_interruptible(&vpfe->lock);
> +       if (ret)
> +               return ret;
> +
> +       vpfe_stop_isif_capture(vpfe);
> +       vpfe_detach_irq(vpfe);
> +
> +       sdinfo = vpfe->current_subdev;
> +       ret = v4l2_device_call_until_err(&vpfe->v4l2_dev, sdinfo->grp_id,
> +                                       video, s_stream, 0);
> +
> +       if (ret && (ret != -ENOIOCTLCMD))
> +               dev_err(vpfe->dev, "stream off failed in subdev\n");
> +
> +       ret = vb2_streamoff(&vpfe->buffer_queue, buf_type);
> +       mutex_unlock(&vpfe->lock);
> +
> +       return ret;
> +}
> +
> +static int vpfe_cropcap(struct file *file, void *priv,
> +                             struct v4l2_cropcap *crop)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +
> +       if (vpfe->std_index >= ARRAY_SIZE(vpfe_standards))
> +               return -EINVAL;
> +
> +       memset(crop, 0, sizeof(struct v4l2_cropcap));
> +       crop->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       crop->defrect.width = vpfe_standards[vpfe->std_index].width;
> +       crop->bounds.width = crop->defrect.width;
> +       crop->defrect.height = vpfe_standards[vpfe->std_index].height;
> +       crop->bounds.height = crop->defrect.height;
> +       crop->pixelaspect = vpfe_standards[vpfe->std_index].pixelaspect;
> +
> +       return 0;
> +}
> +
> +static int vpfe_g_crop(struct file *file, void *priv,
> +                            struct v4l2_crop *crop)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +
> +       crop->c = vpfe->crop;
> +
> +       return 0;
> +}
> +
> +static int vpfe_s_crop(struct file *file, void *priv,
> +                            const struct v4l2_crop *crop)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       struct v4l2_rect rect = crop->c;
> +       int ret = 0;
> +
> +       if (vpfe->started) {
> +               /* make sure streaming is not started */
> +               dev_err(vpfe->dev,
> +                       "Cannot change crop when streaming is ON\n");
> +               return -EBUSY;
> +       }
> +
> +       ret = mutex_lock_interruptible(&vpfe->lock);
> +       if (ret)
> +               return ret;
> +
> +       if (rect.top < 0 || rect.left < 0) {
> +               dev_err(vpfe->dev,
> +                       "doesn't support negative values for top & left\n");
> +               ret = -EINVAL;
> +               goto unlock_out;
> +       }
> +
> +       /* adjust the width to 16 pixel boundary */
> +       rect.width = ((rect.width + 15) & ~0xf);
> +
> +       /* make sure parameters are valid */
> +       if ((rect.left + rect.width >
> +               vpfe->std_info.active_pixels) ||
> +           (rect.top + rect.height >
> +               vpfe->std_info.active_lines)) {
> +               dev_err(vpfe->dev, "Error in S_CROP params\n");
> +               ret = -EINVAL;
> +               goto unlock_out;
> +       }
> +       vpfe->vpfe_isif.hw_ops.set_image_window(
> +                               &vpfe->vpfe_isif, &rect, vpfe->bpp);
> +       vpfe->fmt.fmt.pix.width = rect.width;
> +       vpfe->fmt.fmt.pix.height = rect.height;
> +       vpfe->fmt.fmt.pix.bytesperline =
> +               vpfe->vpfe_isif.hw_ops.get_line_length(
> +                               &vpfe->vpfe_isif);
> +       vpfe->fmt.fmt.pix.sizeimage =
> +               vpfe->fmt.fmt.pix.bytesperline *
> +               vpfe->fmt.fmt.pix.height;
> +       vpfe->crop = rect;
> +
> +unlock_out:
> +       mutex_unlock(&vpfe->lock);
> +
> +       return ret;
> +}
> +
> +
> +static long vpfe_param_handler(struct file *file, void *priv,
> +               bool valid_prio, unsigned int cmd, void *param)
> +{
> +       struct vpfe_device *vpfe = video_drvdata(file);
> +       int ret = 0;
> +
> +       if (vpfe->started)
> +               return -EBUSY;
> +
> +       ret = mutex_lock_interruptible(&vpfe->lock);
> +       if (ret)
> +               return ret;
> +
> +       switch (cmd) {
> +       case VPFE_CMD_S_ISIF_RAW_PARAMS:
> +               dev_warn(vpfe->dev,
> +                        "VPFE_CMD_S_ISIF_RAW_PARAMS: experimental ioctl\n");
> +               if (vpfe->vpfe_isif.hw_ops.set_params) {
> +                       ret = vpfe->vpfe_isif.hw_ops.set_params(
> +                                       &vpfe->vpfe_isif, param);
> +                       if (ret)
> +                               goto unlock_out;
> +                       ret = vpfe_get_isif_image_format(vpfe, &vpfe->fmt);
> +                       if (ret < 0)
> +                               goto unlock_out;
> +               } else {
> +                       ret = -EINVAL;
> +               }
> +               break;
> +       default:
> +               ret = -ENOTTY;
> +       }
> +
> +unlock_out:
> +       mutex_unlock(&vpfe->lock);
> +
> +       return ret;
> +}
> +
> +static int vpfe_vidioc_g_priority(struct file *file, void *priv,
> +               enum v4l2_priority *p)
> +{
> +       struct vpfe_fh *fh = file->private_data;
> +       struct vpfe_device *vpfe = fh->vpfe;
> +
> +       *p = v4l2_prio_max(&vpfe->prio);
> +
> +       return 0;
> +}
> +
> +static int vpfe_vidioc_s_priority(struct file *file, void *priv,
> +               enum v4l2_priority p)
> +{
> +       struct vpfe_fh *fh = file->private_data;
> +       struct vpfe_device *vpfe = fh->vpfe;
> +
> +       return v4l2_prio_change(&vpfe->prio, &fh->prio, p);
> +}
> +
> +/* vpfe capture ioctl operations */
> +static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
> +       .vidioc_querycap        = vpfe_querycap,
> +       .vidioc_g_priority      = vpfe_vidioc_g_priority,
> +       .vidioc_s_priority      = vpfe_vidioc_s_priority,
> +       .vidioc_g_fmt_vid_cap   = vpfe_g_fmt,
> +       .vidioc_enum_fmt_vid_cap = vpfe_enum_fmt,
> +       .vidioc_s_fmt_vid_cap   = vpfe_s_fmt,
> +       .vidioc_try_fmt_vid_cap = vpfe_try_fmt,
> +       .vidioc_enum_framesizes = vpfe_enum_size,
> +       .vidioc_enum_input      = vpfe_enum_input,
> +       .vidioc_g_input         = vpfe_g_input,
> +       .vidioc_s_input         = vpfe_s_input,
> +       .vidioc_querystd        = vpfe_querystd,
> +       .vidioc_s_std           = vpfe_s_std,
> +       .vidioc_g_std           = vpfe_g_std,
> +       .vidioc_reqbufs         = vpfe_reqbufs,
> +       .vidioc_querybuf        = vpfe_querybuf,
> +       .vidioc_qbuf            = vpfe_qbuf,
> +       .vidioc_dqbuf           = vpfe_dqbuf,
> +       .vidioc_streamon        = vpfe_streamon,
> +       .vidioc_streamoff       = vpfe_streamoff,
> +       .vidioc_cropcap         = vpfe_cropcap,
> +       .vidioc_g_crop          = vpfe_g_crop,
> +       .vidioc_s_crop          = vpfe_s_crop,
> +       .vidioc_default         = vpfe_param_handler,
> +};
> +
use vb2 helpers.

> +static int vpfe_async_bound(struct v4l2_async_notifier *notifier,
> +                           struct v4l2_subdev *subdev,
> +                           struct v4l2_async_subdev *asd)
> +{
> +       int i, j;
> +       struct vpfe_subdev_info *sdinfo;
> +       struct vpfe_device *vpfe = container_of(notifier->v4l2_dev,
> +                                       struct vpfe_device, v4l2_dev);
> +
> +       for (i = 0; i < vpfe->cfg->num_subdevs; i++) {
> +               sdinfo = &vpfe->cfg->sub_devs[i];
> +
> +               if (!strcmp(sdinfo->name, subdev->name)) {
> +                       vpfe->sd[i] = subdev;
> +                       dev_info(vpfe->dev,
> +                                "v4l2 sub device %s registered\n",
> +                                subdev->name);
> +                       vpfe->sd[i]->grp_id =
> +                                       sdinfo->grp_id;
> +                       /* update tvnorms from the sub devices */
> +                       for (j = 0;
> +                                j < sdinfo->num_inputs;
> +                                j++) {
> +                               vpfe->video_dev->tvnorms |=
> +                                       sdinfo->inputs[j].std;
> +                       }
> +                       return 0;
> +               }
> +       }
> +
> +       dev_warn(vpfe->dev, "vpfe_async_bound sub device (%s) not matched\n",
> +                subdev->name);
> +
> +       return -EINVAL;
> +}
> +
> +static int vpfe_probe_complete(struct vpfe_device *vpfe)
> +{
> +       int err;
> +       unsigned int flags;
> +
> +       spin_lock_init(&vpfe->irqlock);
> +       spin_lock_init(&vpfe->dma_queue_lock);
> +       mutex_init(&vpfe->lock);
> +
> +       /* Initialize field of the device objects */
> +       vpfe->numbuffers = config_params.numbuffers;
> +
> +       /* Initialize prio member of device object */
> +       v4l2_prio_init(&vpfe->prio);
> +
> +       vpfe->pad.flags = MEDIA_PAD_FL_SINK;
> +       err = media_entity_init(&vpfe->video_dev->entity,
> +                               1, &vpfe->pad, 0);
> +       if (err < 0)
> +               return err;
> +
> +       /* set video driver private data */
> +       video_set_drvdata(vpfe->video_dev, vpfe);
> +       vpfe->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +       dev_info(vpfe->dev, "%s capture driver initialized\n",
> +                vpfe->cfg->card_name);
> +
> +       /* set first sub device as current one */
> +       vpfe->current_subdev = &vpfe->cfg->sub_devs[0];
> +
> +       /* select input 0 */
> +       err = vpfe_set_input(vpfe, 0);
> +       if (err)
> +               goto probe_out;
> +
> +       /* connect subdev to video node */
> +       dev_err(vpfe->dev, "sd[0]->entity is %x\n",
> +               (unsigned int)&vpfe->sd[0]->entity);
> +       dev_err(vpfe->dev, "video_dev->entity is %x\n",
> +               (unsigned int)&vpfe->video_dev->entity);
> +
> +       dev_err(vpfe->dev, "source_pad:%d source->num_pads:%d\n",
> +               0, vpfe->sd[0]->entity.num_pads);
> +       dev_err(vpfe->dev, "sink_pad:%d sink->num_pads:%d\n",
> +               0, vpfe->video_dev->entity.num_pads);
> +
> +       flags = MEDIA_LNK_FL_ENABLED;
> +       err = media_entity_create_link(&vpfe->sd[0]->entity, 0,
> +                                      &vpfe->video_dev->entity,
> +                                      0, flags);
> +       if (err < 0)
> +               goto probe_out;
> +
> +       err = v4l2_device_register_subdev_nodes(&vpfe->v4l2_dev);
> +       if (err < 0)
> +               goto probe_out;
> +
> +       err = video_register_device(vpfe->video_dev,
> +                                   VFL_TYPE_GRABBER, -1);
> +       if (err) {
> +               dev_err(vpfe->dev,
> +                       "Unable to register video device.\n");
> +               goto probe_out;
> +       }
> +       dev_info(vpfe->dev, "video device registered as %s\n",
> +                video_device_node_name(vpfe->video_dev));
> +
> +       return 0;
> +
> +probe_out:
> +       v4l2_device_unregister(&vpfe->v4l2_dev);
> +
> +       return err;
> +}
> +
> +static int vpfe_async_complete(struct v4l2_async_notifier *notifier)
> +{
> +       struct vpfe_device *vpfe = container_of(notifier->v4l2_dev,
> +                                       struct vpfe_device, v4l2_dev);
> +       return vpfe_probe_complete(vpfe);
> +}
> +
> +static struct vpfe_config *
> +vpfe_get_pdata(struct platform_device *pdev)
> +{
> +       struct vpfe_config *pdata;
> +       struct device_node *endpoint, *rem;
> +       struct vpfe_subdev_info *sdinfo;
> +       const char *instance_name;
> +
> +       if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
> +               return pdev->dev.platform_data;
> +
> +       /* the hwmods property basically provides us with the instance
> +        * name and number. So use instead of creating some other means
> +        */
> +       of_property_read_string(pdev->dev.of_node, "ti,hwmods", &instance_name);
> +
> +       endpoint = of_graph_get_next_endpoint(pdev->dev.of_node, NULL);
> +       if (!endpoint)
> +               return NULL;
> +
> +       pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +       if (!pdata)
> +               goto done;
> +
> +       /* Populate vpfe_config with default if needed */
> +       pdata->card_name = (char *)instance_name;
> +       pdata->isif = "AM437x ISIF";
> +
> +       /* We only support one sub_devive per port */
> +       /* Will need cleanup */
> +       pdata->num_subdevs = 1;
> +       sdinfo = &pdata->sub_devs[0];
> +       sdinfo->grp_id = 0;
> +
> +       /* There is only one input on the camera */
> +       sdinfo->num_inputs = 1;
> +       sdinfo->inputs[0].index = 0;
> +       strcpy(sdinfo->inputs[0].name, "camera");
> +       sdinfo->inputs[0].type = V4L2_INPUT_TYPE_CAMERA;
> +       sdinfo->inputs[0].std = V4L2_STD_ALL;
> +       sdinfo->inputs[0].capabilities = V4L2_IN_CAP_STD;
> +
> +       sdinfo->can_route = 0;
> +       sdinfo->routes = NULL;
> +
> +       of_property_read_u32(endpoint, "if_type",
> +                            &sdinfo->isif_if_params.if_type);
> +       if (sdinfo->isif_if_params.if_type < 0)
> +               sdinfo->isif_if_params.if_type = VPFE_RAW_BAYER;
> +       of_property_read_u32(endpoint, "bus_width",
> +                            &sdinfo->isif_if_params.bus_width);
> +       if (sdinfo->isif_if_params.bus_width != 10)
> +               sdinfo->isif_if_params.bus_width = 8;
> +       of_property_read_u32(endpoint, "hdpol",
> +                            &sdinfo->isif_if_params.hdpol);
> +       if (sdinfo->isif_if_params.hdpol != 0)
> +               sdinfo->isif_if_params.hdpol = 1;
> +       of_property_read_u32(endpoint, "vdpol",
> +                            &sdinfo->isif_if_params.vdpol);
> +       if (sdinfo->isif_if_params.vdpol != 0)
> +               sdinfo->isif_if_params.vdpol = 1;
> +
> +       rem = of_graph_get_remote_port_parent(endpoint);
> +       if (rem == NULL) {
> +               dev_err(&pdev->dev, "Remote device at %s not found\n",
> +                       endpoint->full_name);
> +               goto done;
> +       } else {
> +               strncpy(sdinfo->name, rem->name, sizeof(sdinfo->name));
> +       }
> +
> +       sdinfo->asd.match_type = V4L2_ASYNC_MATCH_OF;
> +       sdinfo->asd.match.of.node = rem;
> +       pdata->asd[0] = &sdinfo->asd;
> +       pdata->asd_sizes = 1;
> +       of_node_put(rem);
> +
> +done:
> +       of_node_put(endpoint);
> +
> +       return pdata;
> +}
> +
> +static int vpfe_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct vpfe_subdev_info *sdinfo;
> +       struct vpfe_config *vpfe_cfg;
> +       struct vpfe_device *vpfe;
> +       struct i2c_adapter *i2c_adap;
> +       struct video_device *vfd;
> +       int ret = -ENOMEM, i, j;
> +       int num_subdevs = 0;
> +
> +       /* Default number of buffers should be 3 */
> +       if ((numbuffers > 0) &&
> +           (numbuffers < config_params.min_numbuffers))
> +               numbuffers = config_params.min_numbuffers;
> +
> +       config_params.numbuffers = numbuffers;
> +
> +       vpfe = devm_kzalloc(dev, sizeof(*vpfe), GFP_KERNEL);
> +       if (!vpfe)
> +               return -ENOMEM;
> +
> +       vpfe->sd = devm_kmalloc_array(dev, num_subdevs,
> +                       sizeof(struct v4l2_subdev), GFP_KERNEL);
> +       if (!vpfe->sd)
> +               return -ENOMEM;
> +
> +       vpfe->dev = dev;
> +
> +       vpfe_cfg = vpfe_get_pdata(pdev);
> +       if (!vpfe_cfg) {
> +               dev_err(dev, "Unable to get vpfe config\n");
> +               return -ENODEV;
> +       }
> +
> +       vpfe->cfg = vpfe_cfg;
> +       if (!vpfe_cfg->isif ||
> +           !vpfe_cfg->card_name ||
> +           !vpfe_cfg->sub_devs) {
> +               dev_err(dev, "null ptr in vpfe_cfg\n");
> +               return -ENOENT;
> +       }
> +
> +       vpfe->isif_irq0 = platform_get_irq(pdev, 0);
> +       if (vpfe->isif_irq0 < 0) {
> +               dev_err(vpfe->dev,
> +                       "Unable to get interrupt for VINT0\n");
> +               return -ENODEV;
> +       }
> +
> +       ret = devm_request_irq(dev, vpfe->isif_irq0, vpfe_isr, 0,
> +                       "vpfe_capture0", vpfe);
> +       if (ret != 0) {
> +               dev_err(vpfe->dev, "Unable to request interrupt\n");
> +               return ret;
> +       }
> +
> +       /* Allocate memory for video device */
> +       vfd = video_device_alloc();
> +       if (!vfd)
> +               return -ENOMEM;
> +
> +       /* Initialize field of video device */
> +       vfd->release            = video_device_release;
> +       vfd->fops               = &vpfe_fops;
> +       vfd->ioctl_ops          = &vpfe_ioctl_ops;
> +       vfd->tvnorms            = 0;
> +       vfd->v4l2_dev           = &vpfe->v4l2_dev;
> +
> +       snprintf(vfd->name, sizeof(vfd->name),
> +                "%s_V%d.%d.%d",
> +                CAPTURE_DRV_NAME,
> +                (VPFE_CAPTURE_VERSION_CODE >> 16) & 0xff,
> +                (VPFE_CAPTURE_VERSION_CODE >> 8) & 0xff,
> +                (VPFE_CAPTURE_VERSION_CODE) & 0xff);
> +
> +       vpfe->video_dev = vfd;
> +       vpfe->media_dev.dev = vpfe->dev;
> +
> +       strcpy((char *)&vpfe->media_dev.model, "ti-vpfe-media");
> +
> +       ret = media_device_register(&vpfe->media_dev);
> +       if (ret) {
> +               dev_err(vpfe->dev,
> +                       "Unable to register media device.\n");
> +               goto probe_out_video_release;
> +       }
> +
> +       vpfe->v4l2_dev.mdev = &vpfe->media_dev;
> +
> +       ret = v4l2_device_register(&pdev->dev, &vpfe->v4l2_dev);
> +       if (ret) {
> +               dev_err(vpfe->dev,
> +                       "Unable to register v4l2 device.\n");
> +               goto probe_out_media_unregister;
> +       }
> +
> +       ret = vpfe_isif_init(&vpfe->vpfe_isif, pdev);
> +       if (ret) {
> +               dev_err(vpfe->dev, "Error initializing isif\n");
> +               ret = -EINVAL;
> +               goto probe_out_v4l2_unregister;
> +       }
> +
> +       num_subdevs = vpfe_cfg->num_subdevs;
> +       if (vpfe->cfg->asd_sizes == 0) {
> +               i2c_adap = i2c_get_adapter(vpfe_cfg->i2c_adapter_id);
> +
> +               for (i = 0; i < num_subdevs; i++) {
> +                       struct v4l2_input *inps;
> +
> +                       sdinfo = &vpfe_cfg->sub_devs[i];
> +
> +                       /* Load up the subdevice */
> +                       vpfe->sd[i] =
> +                               v4l2_i2c_new_subdev_board(&vpfe->v4l2_dev,
> +                                                         i2c_adap,
> +                                                         &sdinfo->board_info,
> +                                                         NULL);
> +                       if (vpfe->sd[i]) {
> +                               dev_info(vpfe->dev,
> +                                        "v4l2 sub device %s registered\n",
> +                                        sdinfo->name);
> +                               vpfe->sd[i]->grp_id = sdinfo->grp_id;
> +                               /* update tvnorms from the sub devices */
> +                               for (j = 0; j < sdinfo->num_inputs; j++) {
> +                                       inps = &sdinfo->inputs[j];
> +                                       vfd->tvnorms |= inps->std;
> +                               }
> +                       } else {
> +                               dev_err(vpfe->dev,
> +                                       "v4l2 sub device %s register fails\n",
> +                                       sdinfo->name);
> +                               goto probe_out_v4l2_unregister;
> +                       }
> +               }
> +               vpfe_probe_complete(vpfe);
> +
> +       } else {
> +               vpfe->notifier.subdevs = vpfe->cfg->asd;
> +               vpfe->notifier.num_subdevs = vpfe->cfg->asd_sizes;
> +               vpfe->notifier.bound = vpfe_async_bound;
> +               vpfe->notifier.complete = vpfe_async_complete;
> +               ret = v4l2_async_notifier_register(&vpfe->v4l2_dev,
> +                               &vpfe->notifier);
> +               if (ret) {
> +                       dev_err(vpfe->dev, "Error registering async notifier\n");
> +                       ret = -EINVAL;
> +                       goto probe_out_v4l2_unregister;
> +               }
> +       }
> +
> +       return 0;
> +
> +probe_out_v4l2_unregister:
> +       v4l2_device_unregister(&vpfe->v4l2_dev);
> +
> +probe_out_media_unregister:
> +       media_device_unregister(&vpfe->media_dev);
> +
> +probe_out_video_release:
> +       if (!video_is_registered(vpfe->video_dev))
> +               video_device_release(vpfe->video_dev);
> +
> +       return ret;
> +}
> +
> +/*
> + * vpfe_remove : It un-register device from V4L2 driver
> + */
> +static int vpfe_remove(struct platform_device *pdev)
> +{
> +       struct vpfe_device *vpfe = platform_get_drvdata(pdev);
> +
> +       isif_remove(&vpfe->vpfe_isif, pdev);
> +       v4l2_async_notifier_unregister(&vpfe->notifier);
> +       v4l2_device_unregister(&vpfe->v4l2_dev);
> +       media_device_unregister(&vpfe->media_dev);
> +       video_unregister_device(vpfe->video_dev);
> +
> +       return 0;
> +}
> +
> +static int vpfe_suspend(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct vpfe_device *vpfe = platform_get_drvdata(pdev);
> +
> +       isif_suspend(&vpfe->vpfe_isif, dev);
> +       pinctrl_pm_select_sleep_state(dev);
> +
> +       return 0;
> +}
> +
> +static int vpfe_resume(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct vpfe_device *vpfe = platform_get_drvdata(pdev);
> +
> +       isif_resume(&vpfe->vpfe_isif, dev);
> +       pinctrl_pm_select_default_state(dev);
> +
> +       return 0;
> +}
> +
> +static const struct dev_pm_ops vpfe_dev_pm_ops = {
> +       .suspend = vpfe_suspend,
> +       .resume = vpfe_resume,
> +};
> +
> +static const struct of_device_id vpfe_of_match[] = {
> +       { .compatible = "ti,am437x-vpfe", },
> +       { /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, vpfe_of_match);
> +
> +static struct platform_driver vpfe_driver = {
> +       .driver = {
> +               .name = CAPTURE_DRV_NAME,
> +               .owner = THIS_MODULE,
> +               .pm = &vpfe_dev_pm_ops,
> +               .of_match_table = vpfe_of_match,
> +       },
> +       .probe = vpfe_probe,
> +       .remove = vpfe_remove,
> +};
> +
> +module_platform_driver(vpfe_driver);
> diff --git a/drivers/media/platform/ti-vpfe/vpfe_capture.h b/drivers/media/platform/ti-vpfe/vpfe_capture.h
> new file mode 100644
> index 0000000..91be779
> --- /dev/null
> +++ b/drivers/media/platform/ti-vpfe/vpfe_capture.h
> @@ -0,0 +1,263 @@
> +/*
> + * TI VPFE Multi instance Capture Driver
> + *
> + * Copyright (C) 2013 - 2014 Texas Instruments, Inc.
> + *
> + * Benoit Parrot <bparrot@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _VPFE_CAPTURE_H
> +#define _VPFE_CAPTURE_H
> +
> +#ifdef __KERNEL__
> +
> +/* Header files */
> +#include <media/v4l2-dev.h>
> +#include <linux/videodev2.h>
> +#include <linux/clk.h>
> +#include <linux/i2c.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +enum vpfe_pin_pol {
> +       VPFE_PINPOL_POSITIVE,
> +       VPFE_PINPOL_NEGATIVE
> +};
> +
> +enum vpfe_hw_if_type {
> +       /* BT656 - 8 bit */
> +       VPFE_BT656,
> +       /* BT1120 - 16 bit */
> +       VPFE_BT1120,
> +       /* Raw Bayer */
> +       VPFE_RAW_BAYER,
> +       /* YCbCr - 8 bit with external sync */
> +       VPFE_YCBCR_SYNC_8,
> +       /* YCbCr - 16 bit with external sync */
> +       VPFE_YCBCR_SYNC_16,
> +       /* BT656 - 10 bit */
> +       VPFE_BT656_10BIT
> +};
> +
> +/* interface description */
> +struct vpfe_hw_if_param {
> +       enum vpfe_hw_if_type if_type;
> +       enum vpfe_pin_pol hdpol;
> +       enum vpfe_pin_pol vdpol;
> +       unsigned int bus_width;
> +};
> +
> +#include "am437x_isif.h"
> +
> +#define VPFE_CAPTURE_NUM_DECODERS        5
> +
> +/* Macros */
> +#define VPFE_MAJOR_RELEASE              0
> +#define VPFE_MINOR_RELEASE              0
> +#define VPFE_BUILD                      1
> +#define VPFE_CAPTURE_VERSION_CODE       ((VPFE_MAJOR_RELEASE << 16) | \
> +                                       (VPFE_MINOR_RELEASE << 8)  | \
> +                                       VPFE_BUILD)
> +
> +#define CAPTURE_DRV_NAME               "vpfe-capture"
> +#define VPFE_MAX_SUBDEV 2
> +#define VPFE_MAX_INPUTS 2
> +
> +struct vpfe_pixel_format {
> +       struct v4l2_fmtdesc fmtdesc;
> +       /* bytes per pixel */
> +       int bpp;
> +};
> +
> +struct vpfe_std_info {
> +       int active_pixels;
> +       int active_lines;
> +       /* current frame format */
> +       int frame_format;
> +};
> +
> +struct vpfe_route {
> +       u32 input;
> +       u32 output;
> +};
> +
> +struct vpfe_subdev_info {
> +       /* Sub device name */
> +       char name[32];
> +       /* Sub device group id */
> +       int grp_id;
> +       /* Number of inputs supported */
> +       int num_inputs;
> +       /* inputs available at the sub device */
> +       struct v4l2_input inputs[VPFE_MAX_INPUTS];
> +       /* Sub dev routing information for each input */
> +       struct vpfe_route *routes;
> +       /* check if sub dev supports routing */
> +       int can_route;
> +       /* isif bus/interface configuration */
> +       struct vpfe_hw_if_param isif_if_params;
> +       /* i2c subdevice board info */
> +       struct i2c_board_info board_info;
> +       struct v4l2_async_subdev asd;
> +};
> +
> +struct vpfe_config {
> +       /* Number of sub devices connected to vpfe */
> +       int num_subdevs;
> +       /* i2c bus adapter no */
> +       int i2c_adapter_id;
> +       /* information about each subdev */
> +       struct vpfe_subdev_info sub_devs[VPFE_MAX_SUBDEV];
> +       /* evm card info */
> +       char *card_name;
> +       /* isif name */
> +       char *isif;
> +       /* vpfe clock */
> +       struct clk *vpssclk;
> +       struct clk *slaveclk;
> +       /* Function for Clearing the interrupt */
> +       void (*clr_intr)(int vdint);
> +       /* Flat array, arranged in groups */
> +       struct v4l2_async_subdev *asd[VPFE_MAX_SUBDEV];
> +       int asd_sizes;
> +};
> +
> +struct vpfe_cap_buffer {
> +       struct vb2_buffer vb;
> +       struct list_head list;
> +};
> +
> +struct vpfe_device {
> +       /* V4l2 specific parameters */
> +       /* Identifies video device for this channel */
> +       struct video_device *video_dev;
> +       /* media pad of video entity */
> +       struct media_pad pad;
> +       /* sub devices */
> +       struct v4l2_subdev **sd;
> +       /* vpfe cfg */
> +       struct vpfe_config *cfg;
> +       /* V4l2 device */
> +       struct v4l2_device v4l2_dev;
> +       /* parent device */
> +       struct device *dev;
> +       /* Subdevive Async Notifier */
> +       struct v4l2_async_notifier notifier;
> +       /* Used to keep track of state of the priority */
> +       struct v4l2_prio_state prio;
> +       /* number of open instances of the channel */
> +       u32 usrs;
> +       /* Indicates id of the field which is being displayed */
> +       u32 field_id;
> +       /* flag to indicate whether decoder is initialized */
> +       u8 initialized;
> +       /* current interface type */
> +       struct vpfe_hw_if_param vpfe_if_params;
> +       /* ptr to currently selected sub device */
> +       struct vpfe_subdev_info *current_subdev;
> +       /* current input at the sub device */
> +       int current_input;
> +       /* Keeps track of the information about the standard */
> +       struct vpfe_std_info std_info;
> +       /* std index into std table */
> +       int std_index;
> +       /* IRQs used when CCDC/ISIF output to SDRAM */
> +       unsigned int isif_irq0;
> +       unsigned int isif_irq1;
> +       /* number of buffers in fbuffers */
> +       u32 numbuffers;
> +       /* List of buffer pointers for storing frames */
> +       u8 *fbuffers[VIDEO_MAX_FRAME];
> +       /* Pointer pointing to current v4l2_buffer */
> +       struct vpfe_cap_buffer *cur_frm;
> +       /* Pointer pointing to next v4l2_buffer */
> +       struct vpfe_cap_buffer *next_frm;
> +       /*
> +        * This field keeps track of type of buffer exchange mechanism
> +        * user has selected
> +        */
> +       enum v4l2_memory memory;
> +       /* Used to store pixel format */
> +       struct v4l2_format fmt;
> +       /* Used to store current bytes per pixel based on current format */
> +       unsigned int bpp;
> +       /*
> +        * used when IMP is chained to store the crop window which
> +        * is different from the image window
> +        */
> +       struct v4l2_rect crop;
> +       /* Buffer queue used in video-buf */
> +       struct vb2_queue buffer_queue;
> +       /* Allocator-specific contexts for each plane */
> +       struct vb2_alloc_ctx *alloc_ctx;
> +       /* Queue of filled frames */
> +       struct list_head dma_queue;
> +       /* Used in video-buf */
> +       spinlock_t irqlock;
> +       /* IRQ lock for DMA queue */
> +       spinlock_t dma_queue_lock;
> +       /* lock used to access this structure */
> +       struct mutex lock;
> +       /* number of users performing IO */
> +       u32 io_usrs;
> +       /* Indicates whether streaming started */
> +       u8 started;
> +       /*
> +        * offset where second field starts from the starting of the
> +        * buffer for field separated YCbCr formats
> +        */
> +       u32 field_off;
> +       /* media device */
> +       struct media_device media_dev;
> +       /* isif sub device */
> +       struct vpfe_isif_device vpfe_isif;
> +};
> +
> +/* File handle structure */
> +struct vpfe_fh {
> +       struct vpfe_device *vpfe;
> +       /* Indicates whether this file handle is doing IO */
> +       u8 io_allowed;
> +       /* Used to keep track priority of this instance */
> +       enum v4l2_priority prio;
> +};
> +
> +struct vpfe_config_params {
> +       u8 min_numbuffers;
> +       u8 numbuffers;
> +       u32 min_bufsize;
> +       u32 device_bufsize;
> +};
> +
> +struct vpfe_v4l2_subdev {
> +       struct list_head list;  /* internal use only */
> +       struct i2c_client *client;
> +       void *priv;
> +       struct device_node *node;
> +};
> +
> +void vpfe_register_subdev(struct vpfe_v4l2_subdev *subdev);
> +void vpfe_unregister_subdev(struct vpfe_v4l2_subdev *subdev);
> +
> +#endif                         /* End of __KERNEL__ */
> +/**
> + * VPFE_CMD_S_ISIF_RAW_PARAMS - EXPERIMENTAL IOCTL to set raw capture params
> + * This can be used to configure modules such as defect pixel correction,
> + * color space conversion, culling etc. This is an experimental ioctl that
> + * will change in future kernels. So use this ioctl with care !
> + * TODO: This is to be split into multiple ioctls and also explore the
> + * possibility of extending the v4l2 api to include this
> + **/
> +#define VPFE_CMD_S_ISIF_RAW_PARAMS _IOW('V', BASE_VIDIOC_PRIVATE + 1, \
> +                                       void *)
> +#endif                         /* _VPFE_CAPTURE_H */

Regards,
--Prabhakar Lad
