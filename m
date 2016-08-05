Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:56236 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799AbcHEN2T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 09:28:19 -0400
Subject: Re: [PATCH] s5p-tv: remove obsolete driver
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <362becb3-704e-92c6-289e-9ece6dff3801@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d16f87cf-3e4e-41b9-33fc-356ff9103077@xs4all.nl>
Date: Fri, 5 Aug 2016 15:28:11 +0200
MIME-Version: 1.0
In-Reply-To: <362becb3-704e-92c6-289e-9ece6dff3801@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oops, forgot something. Please ignore.

	Hans

On 08/05/2016 03:27 PM, Hans Verkuil wrote:
> This driver is obsolete and it couldn't even be selected anymore in
> the Kconfig. Just remove it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/exynos/Kconfig                  |    3 +-
>  drivers/media/platform/Makefile                 |    1 -
>  drivers/media/platform/s5p-tv/Kconfig           |   88 --
>  drivers/media/platform/s5p-tv/Makefile          |   19 -
>  drivers/media/platform/s5p-tv/hdmi_drv.c        | 1059 ---------------------
>  drivers/media/platform/s5p-tv/hdmiphy_drv.c     |  324 -------
>  drivers/media/platform/s5p-tv/mixer.h           |  364 --------
>  drivers/media/platform/s5p-tv/mixer_drv.c       |  527 -----------
>  drivers/media/platform/s5p-tv/mixer_grp_layer.c |  270 ------
>  drivers/media/platform/s5p-tv/mixer_reg.c       |  551 -----------
>  drivers/media/platform/s5p-tv/mixer_video.c     | 1130 -----------------------
>  drivers/media/platform/s5p-tv/mixer_vp_layer.c  |  242 -----
>  drivers/media/platform/s5p-tv/regs-hdmi.h       |  146 ---
>  drivers/media/platform/s5p-tv/regs-mixer.h      |  122 ---
>  drivers/media/platform/s5p-tv/regs-sdo.h        |   63 --
>  drivers/media/platform/s5p-tv/regs-vp.h         |   88 --
>  drivers/media/platform/s5p-tv/sdo_drv.c         |  497 ----------
>  drivers/media/platform/s5p-tv/sii9234_drv.c     |  407 --------
>  18 files changed, 1 insertion(+), 5900 deletions(-)
>  delete mode 100644 drivers/media/platform/s5p-tv/Kconfig
>  delete mode 100644 drivers/media/platform/s5p-tv/Makefile
>  delete mode 100644 drivers/media/platform/s5p-tv/hdmi_drv.c
>  delete mode 100644 drivers/media/platform/s5p-tv/hdmiphy_drv.c
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer.h
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer_drv.c
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer_grp_layer.c
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer_reg.c
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer_video.c
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer_vp_layer.c
>  delete mode 100644 drivers/media/platform/s5p-tv/regs-hdmi.h
>  delete mode 100644 drivers/media/platform/s5p-tv/regs-mixer.h
>  delete mode 100644 drivers/media/platform/s5p-tv/regs-sdo.h
>  delete mode 100644 drivers/media/platform/s5p-tv/regs-vp.h
>  delete mode 100644 drivers/media/platform/s5p-tv/sdo_drv.c
>  delete mode 100644 drivers/media/platform/s5p-tv/sii9234_drv.c
> 
> diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
> index d814b30..5939217 100644
> --- a/drivers/gpu/drm/exynos/Kconfig
> +++ b/drivers/gpu/drm/exynos/Kconfig
> @@ -42,7 +42,6 @@ config DRM_EXYNOS7_DECON
> 
>  config DRM_EXYNOS_MIXER
>  	bool "Mixer"
> -	depends on !VIDEO_SAMSUNG_S5P_TV
>  	help
>  	  Choose this option if you want to use Exynos Mixer for DRM.
> 
> @@ -81,7 +80,7 @@ config DRM_EXYNOS_DP
> 
>  config DRM_EXYNOS_HDMI
>  	bool "HDMI"
> -	depends on !VIDEO_SAMSUNG_S5P_TV && (DRM_EXYNOS_MIXER || DRM_EXYNOS5433_DECON)
> +	depends on DRM_EXYNOS_MIXER || DRM_EXYNOS5433_DECON
>  	help
>  	  Choose this option if you want to use Exynos HDMI for DRM.
> 
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 21771c1..bbbaa3a 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -30,7 +30,6 @@ obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
>  obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
> -obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
> 
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
>  obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
> diff --git a/drivers/media/platform/s5p-tv/Kconfig b/drivers/media/platform/s5p-tv/Kconfig
> deleted file mode 100644
> index 697aaed..0000000
> --- a/drivers/media/platform/s5p-tv/Kconfig
> +++ /dev/null
> @@ -1,88 +0,0 @@
> -# drivers/media/platform/s5p-tv/Kconfig
> -#
> -# Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> -#	http://www.samsung.com/
> -# Tomasz Stanislawski <t.stanislaws@samsung.com>
> -#
> -# Licensed under GPL
> -
> -config VIDEO_SAMSUNG_S5P_TV
> -	bool "Samsung TV driver for S5P platform"
> -	depends on PM
> -	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
> -	default n
> -	---help---
> -	  Say Y here to enable selecting the TV output devices for
> -	  Samsung S5P platform.
> -
> -if VIDEO_SAMSUNG_S5P_TV
> -
> -config VIDEO_SAMSUNG_S5P_HDMI
> -	tristate "Samsung HDMI Driver"
> -	depends on VIDEO_V4L2
> -	depends on I2C
> -	depends on VIDEO_SAMSUNG_S5P_TV
> -	select VIDEO_SAMSUNG_S5P_HDMIPHY
> -	help
> -	  Say Y here if you want support for the HDMI output
> -	  interface in S5P Samsung SoC. The driver can be compiled
> -	  as module. It is an auxiliary driver, that exposes a V4L2
> -	  subdev for use by other drivers. This driver requires
> -	  hdmiphy driver to work correctly.
> -
> -config VIDEO_SAMSUNG_S5P_HDMI_DEBUG
> -	bool "Enable debug for HDMI Driver"
> -	depends on VIDEO_SAMSUNG_S5P_HDMI
> -	default n
> -	help
> -	  Enables debugging for HDMI driver.
> -
> -config VIDEO_SAMSUNG_S5P_HDMIPHY
> -	tristate "Samsung HDMIPHY Driver"
> -	depends on VIDEO_DEV && VIDEO_V4L2 && I2C
> -	depends on VIDEO_SAMSUNG_S5P_TV
> -	help
> -	  Say Y here if you want support for the physical HDMI
> -	  interface in S5P Samsung SoC. The driver can be compiled
> -	  as module. It is an I2C driver, that exposes a V4L2
> -	  subdev for use by other drivers.
> -
> -config VIDEO_SAMSUNG_S5P_SII9234
> -	tristate "Samsung SII9234 Driver"
> -	depends on VIDEO_DEV && VIDEO_V4L2 && I2C
> -	depends on VIDEO_SAMSUNG_S5P_TV
> -	help
> -	  Say Y here if you want support for the MHL interface
> -	  in S5P Samsung SoC. The driver can be compiled
> -	  as module. It is an I2C driver, that exposes a V4L2
> -	  subdev for use by other drivers.
> -
> -config VIDEO_SAMSUNG_S5P_SDO
> -	tristate "Samsung Analog TV Driver"
> -	depends on VIDEO_DEV && VIDEO_V4L2
> -	depends on VIDEO_SAMSUNG_S5P_TV
> -	help
> -	  Say Y here if you want support for the analog TV output
> -	  interface in S5P Samsung SoC. The driver can be compiled
> -	  as module. It is an auxiliary driver, that exposes a V4L2
> -	  subdev for use by other drivers. This driver requires
> -	  hdmiphy driver to work correctly.
> -
> -config VIDEO_SAMSUNG_S5P_MIXER
> -	tristate "Samsung Mixer and Video Processor Driver"
> -	depends on VIDEO_DEV && VIDEO_V4L2
> -	depends on VIDEO_SAMSUNG_S5P_TV
> -	depends on HAS_DMA
> -	select VIDEOBUF2_DMA_CONTIG
> -	help
> -	  Say Y here if you want support for the Mixer in Samsung S5P SoCs.
> -	  This device produce image data to one of output interfaces.
> -
> -config VIDEO_SAMSUNG_S5P_MIXER_DEBUG
> -	bool "Enable debug for Mixer Driver"
> -	depends on VIDEO_SAMSUNG_S5P_MIXER
> -	default n
> -	help
> -	  Enables debugging for Mixer driver.
> -
> -endif # VIDEO_SAMSUNG_S5P_TV
> diff --git a/drivers/media/platform/s5p-tv/Makefile b/drivers/media/platform/s5p-tv/Makefile
> deleted file mode 100644
> index 7cd4790..0000000
> --- a/drivers/media/platform/s5p-tv/Makefile
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -# drivers/media/platform/samsung/tvout/Makefile
> -#
> -# Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> -#	http://www.samsung.com/
> -# Tomasz Stanislawski <t.stanislaws@samsung.com>
> -#
> -# Licensed under GPL
> -
> -obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMIPHY) += s5p-hdmiphy.o
> -s5p-hdmiphy-y += hdmiphy_drv.o
> -obj-$(CONFIG_VIDEO_SAMSUNG_S5P_SII9234) += s5p-sii9234.o
> -s5p-sii9234-y += sii9234_drv.o
> -obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMI) += s5p-hdmi.o
> -s5p-hdmi-y += hdmi_drv.o
> -obj-$(CONFIG_VIDEO_SAMSUNG_S5P_SDO) += s5p-sdo.o
> -s5p-sdo-y += sdo_drv.o
> -obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MIXER) += s5p-mixer.o
> -s5p-mixer-y += mixer_drv.o mixer_video.o mixer_reg.o mixer_grp_layer.o mixer_vp_layer.o
> -
> diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
> deleted file mode 100644
> index e71b13e..0000000
> --- a/drivers/media/platform/s5p-tv/hdmi_drv.c
> +++ /dev/null
> @@ -1,1059 +0,0 @@
> -/*
> - * Samsung HDMI interface driver
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *
> - * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published
> - * by the Free Software Foundiation. either version 2 of the License,
> - * or (at your option) any later version
> - */
> -
> -#define pr_fmt(fmt) "s5p-tv (hdmi_drv): " fmt
> -
> -#ifdef CONFIG_VIDEO_SAMSUNG_S5P_HDMI_DEBUG
> -#define DEBUG
> -#endif
> -
> -#include <linux/kernel.h>
> -#include <linux/slab.h>
> -#include <linux/io.h>
> -#include <linux/i2c.h>
> -#include <linux/platform_device.h>
> -#include <media/v4l2-subdev.h>
> -#include <linux/module.h>
> -#include <linux/interrupt.h>
> -#include <linux/irq.h>
> -#include <linux/delay.h>
> -#include <linux/bug.h>
> -#include <linux/pm_runtime.h>
> -#include <linux/clk.h>
> -#include <linux/regulator/consumer.h>
> -#include <linux/v4l2-dv-timings.h>
> -
> -#include <linux/platform_data/media/s5p_hdmi.h>
> -#include <media/v4l2-common.h>
> -#include <media/v4l2-dev.h>
> -#include <media/v4l2-device.h>
> -#include <media/v4l2-dv-timings.h>
> -
> -#include "regs-hdmi.h"
> -
> -MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
> -MODULE_DESCRIPTION("Samsung HDMI");
> -MODULE_LICENSE("GPL");
> -
> -struct hdmi_pulse {
> -	u32 beg;
> -	u32 end;
> -};
> -
> -struct hdmi_timings {
> -	struct hdmi_pulse hact;
> -	u32 hsyn_pol; /* 0 - high, 1 - low */
> -	struct hdmi_pulse hsyn;
> -	u32 interlaced;
> -	struct hdmi_pulse vact[2];
> -	u32 vsyn_pol; /* 0 - high, 1 - low */
> -	u32 vsyn_off;
> -	struct hdmi_pulse vsyn[2];
> -};
> -
> -struct hdmi_resources {
> -	struct clk *hdmi;
> -	struct clk *sclk_hdmi;
> -	struct clk *sclk_pixel;
> -	struct clk *sclk_hdmiphy;
> -	struct clk *hdmiphy;
> -	struct regulator_bulk_data *regul_bulk;
> -	int regul_count;
> -};
> -
> -struct hdmi_device {
> -	/** base address of HDMI registers */
> -	void __iomem *regs;
> -	/** HDMI interrupt */
> -	unsigned int irq;
> -	/** pointer to device parent */
> -	struct device *dev;
> -	/** subdev generated by HDMI device */
> -	struct v4l2_subdev sd;
> -	/** V4L2 device structure */
> -	struct v4l2_device v4l2_dev;
> -	/** subdev of HDMIPHY interface */
> -	struct v4l2_subdev *phy_sd;
> -	/** subdev of MHL interface */
> -	struct v4l2_subdev *mhl_sd;
> -	/** configuration of current graphic mode */
> -	const struct hdmi_timings *cur_conf;
> -	/** flag indicating that timings are dirty */
> -	int cur_conf_dirty;
> -	/** current timings */
> -	struct v4l2_dv_timings cur_timings;
> -	/** other resources */
> -	struct hdmi_resources res;
> -};
> -
> -static const struct platform_device_id hdmi_driver_types[] = {
> -	{
> -		.name		= "s5pv210-hdmi",
> -	}, {
> -		.name		= "exynos4-hdmi",
> -	}, {
> -		/* end node */
> -	}
> -};
> -
> -static const struct v4l2_subdev_ops hdmi_sd_ops;
> -
> -static struct hdmi_device *sd_to_hdmi_dev(struct v4l2_subdev *sd)
> -{
> -	return container_of(sd, struct hdmi_device, sd);
> -}
> -
> -static inline
> -void hdmi_write(struct hdmi_device *hdev, u32 reg_id, u32 value)
> -{
> -	writel(value, hdev->regs + reg_id);
> -}
> -
> -static inline
> -void hdmi_write_mask(struct hdmi_device *hdev, u32 reg_id, u32 value, u32 mask)
> -{
> -	u32 old = readl(hdev->regs + reg_id);
> -	value = (value & mask) | (old & ~mask);
> -	writel(value, hdev->regs + reg_id);
> -}
> -
> -static inline
> -void hdmi_writeb(struct hdmi_device *hdev, u32 reg_id, u8 value)
> -{
> -	writeb(value, hdev->regs + reg_id);
> -}
> -
> -static inline
> -void hdmi_writebn(struct hdmi_device *hdev, u32 reg_id, int n, u32 value)
> -{
> -	switch (n) {
> -	default:
> -		writeb(value >> 24, hdev->regs + reg_id + 12);
> -	case 3:
> -		writeb(value >> 16, hdev->regs + reg_id + 8);
> -	case 2:
> -		writeb(value >>  8, hdev->regs + reg_id + 4);
> -	case 1:
> -		writeb(value >>  0, hdev->regs + reg_id + 0);
> -	}
> -}
> -
> -static inline u32 hdmi_read(struct hdmi_device *hdev, u32 reg_id)
> -{
> -	return readl(hdev->regs + reg_id);
> -}
> -
> -static irqreturn_t hdmi_irq_handler(int irq, void *dev_data)
> -{
> -	struct hdmi_device *hdev = dev_data;
> -	u32 intc_flag;
> -
> -	(void)irq;
> -	intc_flag = hdmi_read(hdev, HDMI_INTC_FLAG);
> -	/* clearing flags for HPD plug/unplug */
> -	if (intc_flag & HDMI_INTC_FLAG_HPD_UNPLUG) {
> -		pr_info("unplugged\n");
> -		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
> -			HDMI_INTC_FLAG_HPD_UNPLUG);
> -	}
> -	if (intc_flag & HDMI_INTC_FLAG_HPD_PLUG) {
> -		pr_info("plugged\n");
> -		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
> -			HDMI_INTC_FLAG_HPD_PLUG);
> -	}
> -
> -	return IRQ_HANDLED;
> -}
> -
> -static void hdmi_reg_init(struct hdmi_device *hdev)
> -{
> -	/* enable HPD interrupts */
> -	hdmi_write_mask(hdev, HDMI_INTC_CON, ~0, HDMI_INTC_EN_GLOBAL |
> -		HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
> -	/* choose DVI mode */
> -	hdmi_write_mask(hdev, HDMI_MODE_SEL,
> -		HDMI_MODE_DVI_EN, HDMI_MODE_MASK);
> -	hdmi_write_mask(hdev, HDMI_CON_2, ~0,
> -		HDMI_DVI_PERAMBLE_EN | HDMI_DVI_BAND_EN);
> -	/* disable bluescreen */
> -	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_BLUE_SCR_EN);
> -	/* choose bluescreen (fecal) color */
> -	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_0, 0x12);
> -	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_1, 0x34);
> -	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_2, 0x56);
> -}
> -
> -static void hdmi_timing_apply(struct hdmi_device *hdev,
> -	const struct hdmi_timings *t)
> -{
> -	/* setting core registers */
> -	hdmi_writebn(hdev, HDMI_H_BLANK_0, 2, t->hact.beg);
> -	hdmi_writebn(hdev, HDMI_H_SYNC_GEN_0, 3,
> -		(t->hsyn_pol << 20) | (t->hsyn.end << 10) | t->hsyn.beg);
> -	hdmi_writeb(hdev, HDMI_VSYNC_POL, t->vsyn_pol);
> -	hdmi_writebn(hdev, HDMI_V_BLANK_0, 3,
> -		(t->vact[0].beg << 11) | t->vact[0].end);
> -	hdmi_writebn(hdev, HDMI_V_SYNC_GEN_1_0, 3,
> -		(t->vsyn[0].beg << 12) | t->vsyn[0].end);
> -	if (t->interlaced) {
> -		u32 vsyn_trans = t->hsyn.beg + t->vsyn_off;
> -
> -		hdmi_writeb(hdev, HDMI_INT_PRO_MODE, 1);
> -		hdmi_writebn(hdev, HDMI_H_V_LINE_0, 3,
> -			(t->hact.end << 12) | t->vact[1].end);
> -		hdmi_writebn(hdev, HDMI_V_BLANK_F_0, 3,
> -			(t->vact[1].end << 11) | t->vact[1].beg);
> -		hdmi_writebn(hdev, HDMI_V_SYNC_GEN_2_0, 3,
> -			(t->vsyn[1].beg << 12) | t->vsyn[1].end);
> -		hdmi_writebn(hdev, HDMI_V_SYNC_GEN_3_0, 3,
> -			(vsyn_trans << 12) | vsyn_trans);
> -	} else {
> -		hdmi_writeb(hdev, HDMI_INT_PRO_MODE, 0);
> -		hdmi_writebn(hdev, HDMI_H_V_LINE_0, 3,
> -			(t->hact.end << 12) | t->vact[0].end);
> -	}
> -
> -	/* Timing generator registers */
> -	hdmi_writebn(hdev, HDMI_TG_H_FSZ_L, 2, t->hact.end);
> -	hdmi_writebn(hdev, HDMI_TG_HACT_ST_L, 2, t->hact.beg);
> -	hdmi_writebn(hdev, HDMI_TG_HACT_SZ_L, 2, t->hact.end - t->hact.beg);
> -	hdmi_writebn(hdev, HDMI_TG_VSYNC_L, 2, t->vsyn[0].beg);
> -	hdmi_writebn(hdev, HDMI_TG_VACT_ST_L, 2, t->vact[0].beg);
> -	hdmi_writebn(hdev, HDMI_TG_VACT_SZ_L, 2,
> -		t->vact[0].end - t->vact[0].beg);
> -	hdmi_writebn(hdev, HDMI_TG_VSYNC_TOP_HDMI_L, 2, t->vsyn[0].beg);
> -	hdmi_writebn(hdev, HDMI_TG_FIELD_TOP_HDMI_L, 2, t->vsyn[0].beg);
> -	if (t->interlaced) {
> -		hdmi_write_mask(hdev, HDMI_TG_CMD, ~0, HDMI_TG_FIELD_EN);
> -		hdmi_writebn(hdev, HDMI_TG_V_FSZ_L, 2, t->vact[1].end);
> -		hdmi_writebn(hdev, HDMI_TG_VSYNC2_L, 2, t->vsyn[1].beg);
> -		hdmi_writebn(hdev, HDMI_TG_FIELD_CHG_L, 2, t->vact[0].end);
> -		hdmi_writebn(hdev, HDMI_TG_VACT_ST2_L, 2, t->vact[1].beg);
> -		hdmi_writebn(hdev, HDMI_TG_VSYNC_BOT_HDMI_L, 2, t->vsyn[1].beg);
> -		hdmi_writebn(hdev, HDMI_TG_FIELD_BOT_HDMI_L, 2, t->vsyn[1].beg);
> -	} else {
> -		hdmi_write_mask(hdev, HDMI_TG_CMD, 0, HDMI_TG_FIELD_EN);
> -		hdmi_writebn(hdev, HDMI_TG_V_FSZ_L, 2, t->vact[0].end);
> -	}
> -}
> -
> -static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
> -{
> -	struct device *dev = hdmi_dev->dev;
> -	const struct hdmi_timings *conf = hdmi_dev->cur_conf;
> -	int ret;
> -
> -	dev_dbg(dev, "%s\n", __func__);
> -
> -	/* skip if conf is already synchronized with HW */
> -	if (!hdmi_dev->cur_conf_dirty)
> -		return 0;
> -
> -	/* reset hdmiphy */
> -	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT, ~0, HDMI_PHY_SW_RSTOUT);
> -	mdelay(10);
> -	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT,  0, HDMI_PHY_SW_RSTOUT);
> -	mdelay(10);
> -
> -	/* configure timings */
> -	ret = v4l2_subdev_call(hdmi_dev->phy_sd, video, s_dv_timings,
> -				&hdmi_dev->cur_timings);
> -	if (ret) {
> -		dev_err(dev, "failed to set timings\n");
> -		return ret;
> -	}
> -
> -	/* resetting HDMI core */
> -	hdmi_write_mask(hdmi_dev, HDMI_CORE_RSTOUT,  0, HDMI_CORE_SW_RSTOUT);
> -	mdelay(10);
> -	hdmi_write_mask(hdmi_dev, HDMI_CORE_RSTOUT, ~0, HDMI_CORE_SW_RSTOUT);
> -	mdelay(10);
> -
> -	hdmi_reg_init(hdmi_dev);
> -
> -	/* setting core registers */
> -	hdmi_timing_apply(hdmi_dev, conf);
> -
> -	hdmi_dev->cur_conf_dirty = 0;
> -
> -	return 0;
> -}
> -
> -static void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix)
> -{
> -#define DUMPREG(reg_id) \
> -	dev_dbg(hdev->dev, "%s:" #reg_id " = %08x\n", prefix, \
> -		readl(hdev->regs + reg_id))
> -
> -	dev_dbg(hdev->dev, "%s: ---- CONTROL REGISTERS ----\n", prefix);
> -	DUMPREG(HDMI_INTC_FLAG);
> -	DUMPREG(HDMI_INTC_CON);
> -	DUMPREG(HDMI_HPD_STATUS);
> -	DUMPREG(HDMI_PHY_RSTOUT);
> -	DUMPREG(HDMI_PHY_VPLL);
> -	DUMPREG(HDMI_PHY_CMU);
> -	DUMPREG(HDMI_CORE_RSTOUT);
> -
> -	dev_dbg(hdev->dev, "%s: ---- CORE REGISTERS ----\n", prefix);
> -	DUMPREG(HDMI_CON_0);
> -	DUMPREG(HDMI_CON_1);
> -	DUMPREG(HDMI_CON_2);
> -	DUMPREG(HDMI_SYS_STATUS);
> -	DUMPREG(HDMI_PHY_STATUS);
> -	DUMPREG(HDMI_STATUS_EN);
> -	DUMPREG(HDMI_HPD);
> -	DUMPREG(HDMI_MODE_SEL);
> -	DUMPREG(HDMI_HPD_GEN);
> -	DUMPREG(HDMI_DC_CONTROL);
> -	DUMPREG(HDMI_VIDEO_PATTERN_GEN);
> -
> -	dev_dbg(hdev->dev, "%s: ---- CORE SYNC REGISTERS ----\n", prefix);
> -	DUMPREG(HDMI_H_BLANK_0);
> -	DUMPREG(HDMI_H_BLANK_1);
> -	DUMPREG(HDMI_V_BLANK_0);
> -	DUMPREG(HDMI_V_BLANK_1);
> -	DUMPREG(HDMI_V_BLANK_2);
> -	DUMPREG(HDMI_H_V_LINE_0);
> -	DUMPREG(HDMI_H_V_LINE_1);
> -	DUMPREG(HDMI_H_V_LINE_2);
> -	DUMPREG(HDMI_VSYNC_POL);
> -	DUMPREG(HDMI_INT_PRO_MODE);
> -	DUMPREG(HDMI_V_BLANK_F_0);
> -	DUMPREG(HDMI_V_BLANK_F_1);
> -	DUMPREG(HDMI_V_BLANK_F_2);
> -	DUMPREG(HDMI_H_SYNC_GEN_0);
> -	DUMPREG(HDMI_H_SYNC_GEN_1);
> -	DUMPREG(HDMI_H_SYNC_GEN_2);
> -	DUMPREG(HDMI_V_SYNC_GEN_1_0);
> -	DUMPREG(HDMI_V_SYNC_GEN_1_1);
> -	DUMPREG(HDMI_V_SYNC_GEN_1_2);
> -	DUMPREG(HDMI_V_SYNC_GEN_2_0);
> -	DUMPREG(HDMI_V_SYNC_GEN_2_1);
> -	DUMPREG(HDMI_V_SYNC_GEN_2_2);
> -	DUMPREG(HDMI_V_SYNC_GEN_3_0);
> -	DUMPREG(HDMI_V_SYNC_GEN_3_1);
> -	DUMPREG(HDMI_V_SYNC_GEN_3_2);
> -
> -	dev_dbg(hdev->dev, "%s: ---- TG REGISTERS ----\n", prefix);
> -	DUMPREG(HDMI_TG_CMD);
> -	DUMPREG(HDMI_TG_H_FSZ_L);
> -	DUMPREG(HDMI_TG_H_FSZ_H);
> -	DUMPREG(HDMI_TG_HACT_ST_L);
> -	DUMPREG(HDMI_TG_HACT_ST_H);
> -	DUMPREG(HDMI_TG_HACT_SZ_L);
> -	DUMPREG(HDMI_TG_HACT_SZ_H);
> -	DUMPREG(HDMI_TG_V_FSZ_L);
> -	DUMPREG(HDMI_TG_V_FSZ_H);
> -	DUMPREG(HDMI_TG_VSYNC_L);
> -	DUMPREG(HDMI_TG_VSYNC_H);
> -	DUMPREG(HDMI_TG_VSYNC2_L);
> -	DUMPREG(HDMI_TG_VSYNC2_H);
> -	DUMPREG(HDMI_TG_VACT_ST_L);
> -	DUMPREG(HDMI_TG_VACT_ST_H);
> -	DUMPREG(HDMI_TG_VACT_SZ_L);
> -	DUMPREG(HDMI_TG_VACT_SZ_H);
> -	DUMPREG(HDMI_TG_FIELD_CHG_L);
> -	DUMPREG(HDMI_TG_FIELD_CHG_H);
> -	DUMPREG(HDMI_TG_VACT_ST2_L);
> -	DUMPREG(HDMI_TG_VACT_ST2_H);
> -	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_L);
> -	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_H);
> -	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_L);
> -	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_H);
> -	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_L);
> -	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_H);
> -	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_L);
> -	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_H);
> -#undef DUMPREG
> -}
> -
> -static const struct hdmi_timings hdmi_timings_480p = {
> -	.hact = { .beg = 138, .end = 858 },
> -	.hsyn_pol = 1,
> -	.hsyn = { .beg = 16, .end = 16 + 62 },
> -	.interlaced = 0,
> -	.vact[0] = { .beg = 42 + 3, .end = 522 + 3 },
> -	.vsyn_pol = 1,
> -	.vsyn[0] = { .beg = 6 + 3, .end = 12 + 3},
> -};
> -
> -static const struct hdmi_timings hdmi_timings_576p50 = {
> -	.hact = { .beg = 144, .end = 864 },
> -	.hsyn_pol = 1,
> -	.hsyn = { .beg = 12, .end = 12 + 64 },
> -	.interlaced = 0,
> -	.vact[0] = { .beg = 44 + 5, .end = 620 + 5 },
> -	.vsyn_pol = 1,
> -	.vsyn[0] = { .beg = 0 + 5, .end = 5 + 5},
> -};
> -
> -static const struct hdmi_timings hdmi_timings_720p60 = {
> -	.hact = { .beg = 370, .end = 1650 },
> -	.hsyn_pol = 0,
> -	.hsyn = { .beg = 110, .end = 110 + 40 },
> -	.interlaced = 0,
> -	.vact[0] = { .beg = 25 + 5, .end = 745 + 5 },
> -	.vsyn_pol = 0,
> -	.vsyn[0] = { .beg = 0 + 5, .end = 5 + 5},
> -};
> -
> -static const struct hdmi_timings hdmi_timings_720p50 = {
> -	.hact = { .beg = 700, .end = 1980 },
> -	.hsyn_pol = 0,
> -	.hsyn = { .beg = 440, .end = 440 + 40 },
> -	.interlaced = 0,
> -	.vact[0] = { .beg = 25 + 5, .end = 745 + 5 },
> -	.vsyn_pol = 0,
> -	.vsyn[0] = { .beg = 0 + 5, .end = 5 + 5},
> -};
> -
> -static const struct hdmi_timings hdmi_timings_1080p24 = {
> -	.hact = { .beg = 830, .end = 2750 },
> -	.hsyn_pol = 0,
> -	.hsyn = { .beg = 638, .end = 638 + 44 },
> -	.interlaced = 0,
> -	.vact[0] = { .beg = 41 + 4, .end = 1121 + 4 },
> -	.vsyn_pol = 0,
> -	.vsyn[0] = { .beg = 0 + 4, .end = 5 + 4},
> -};
> -
> -static const struct hdmi_timings hdmi_timings_1080p60 = {
> -	.hact = { .beg = 280, .end = 2200 },
> -	.hsyn_pol = 0,
> -	.hsyn = { .beg = 88, .end = 88 + 44 },
> -	.interlaced = 0,
> -	.vact[0] = { .beg = 41 + 4, .end = 1121 + 4 },
> -	.vsyn_pol = 0,
> -	.vsyn[0] = { .beg = 0 + 4, .end = 5 + 4},
> -};
> -
> -static const struct hdmi_timings hdmi_timings_1080i60 = {
> -	.hact = { .beg = 280, .end = 2200 },
> -	.hsyn_pol = 0,
> -	.hsyn = { .beg = 88, .end = 88 + 44 },
> -	.interlaced = 1,
> -	.vact[0] = { .beg = 20 + 2, .end = 560 + 2 },
> -	.vact[1] = { .beg = 583 + 2, .end = 1123 + 2 },
> -	.vsyn_pol = 0,
> -	.vsyn_off = 1100,
> -	.vsyn[0] = { .beg = 0 + 2, .end = 5 + 2},
> -	.vsyn[1] = { .beg = 562 + 2, .end = 567 + 2},
> -};
> -
> -static const struct hdmi_timings hdmi_timings_1080i50 = {
> -	.hact = { .beg = 720, .end = 2640 },
> -	.hsyn_pol = 0,
> -	.hsyn = { .beg = 528, .end = 528 + 44 },
> -	.interlaced = 1,
> -	.vact[0] = { .beg = 20 + 2, .end = 560 + 2 },
> -	.vact[1] = { .beg = 583 + 2, .end = 1123 + 2 },
> -	.vsyn_pol = 0,
> -	.vsyn_off = 1320,
> -	.vsyn[0] = { .beg = 0 + 2, .end = 5 + 2},
> -	.vsyn[1] = { .beg = 562 + 2, .end = 567 + 2},
> -};
> -
> -static const struct hdmi_timings hdmi_timings_1080p50 = {
> -	.hact = { .beg = 720, .end = 2640 },
> -	.hsyn_pol = 0,
> -	.hsyn = { .beg = 528, .end = 528 + 44 },
> -	.interlaced = 0,
> -	.vact[0] = { .beg = 41 + 4, .end = 1121 + 4 },
> -	.vsyn_pol = 0,
> -	.vsyn[0] = { .beg = 0 + 4, .end = 5 + 4},
> -};
> -
> -/* default hdmi_timings index of the timings configured on probe */
> -#define HDMI_DEFAULT_TIMINGS_IDX (0)
> -
> -static const struct {
> -	bool reduced_fps;
> -	const struct v4l2_dv_timings dv_timings;
> -	const struct hdmi_timings *hdmi_timings;
> -} hdmi_timings[] = {
> -	{ false, V4L2_DV_BT_CEA_720X480P59_94, &hdmi_timings_480p    },
> -	{ false, V4L2_DV_BT_CEA_720X576P50,    &hdmi_timings_576p50  },
> -	{ false, V4L2_DV_BT_CEA_1280X720P50,   &hdmi_timings_720p50  },
> -	{ true,  V4L2_DV_BT_CEA_1280X720P60,   &hdmi_timings_720p60  },
> -	{ false, V4L2_DV_BT_CEA_1920X1080P24,  &hdmi_timings_1080p24 },
> -	{ false, V4L2_DV_BT_CEA_1920X1080P30,  &hdmi_timings_1080p60 },
> -	{ false, V4L2_DV_BT_CEA_1920X1080P50,  &hdmi_timings_1080p50 },
> -	{ false, V4L2_DV_BT_CEA_1920X1080I50,  &hdmi_timings_1080i50 },
> -	{ false, V4L2_DV_BT_CEA_1920X1080I60,  &hdmi_timings_1080i60 },
> -	{ false, V4L2_DV_BT_CEA_1920X1080P60,  &hdmi_timings_1080p60 },
> -};
> -
> -static int hdmi_streamon(struct hdmi_device *hdev)
> -{
> -	struct device *dev = hdev->dev;
> -	struct hdmi_resources *res = &hdev->res;
> -	int ret, tries;
> -
> -	dev_dbg(dev, "%s\n", __func__);
> -
> -	ret = hdmi_conf_apply(hdev);
> -	if (ret)
> -		return ret;
> -
> -	ret = v4l2_subdev_call(hdev->phy_sd, video, s_stream, 1);
> -	if (ret)
> -		return ret;
> -
> -	/* waiting for HDMIPHY's PLL to get to steady state */
> -	for (tries = 100; tries; --tries) {
> -		u32 val = hdmi_read(hdev, HDMI_PHY_STATUS);
> -		if (val & HDMI_PHY_STATUS_READY)
> -			break;
> -		mdelay(1);
> -	}
> -	/* steady state not achieved */
> -	if (tries == 0) {
> -		dev_err(dev, "hdmiphy's pll could not reach steady state.\n");
> -		v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
> -		hdmi_dumpregs(hdev, "hdmiphy - s_stream");
> -		return -EIO;
> -	}
> -
> -	/* starting MHL */
> -	ret = v4l2_subdev_call(hdev->mhl_sd, video, s_stream, 1);
> -	if (hdev->mhl_sd && ret) {
> -		v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
> -		hdmi_dumpregs(hdev, "mhl - s_stream");
> -		return -EIO;
> -	}
> -
> -	/* hdmiphy clock is used for HDMI in streaming mode */
> -	clk_disable(res->sclk_hdmi);
> -	clk_set_parent(res->sclk_hdmi, res->sclk_hdmiphy);
> -	clk_enable(res->sclk_hdmi);
> -
> -	/* enable HDMI and timing generator */
> -	hdmi_write_mask(hdev, HDMI_CON_0, ~0, HDMI_EN);
> -	hdmi_write_mask(hdev, HDMI_TG_CMD, ~0, HDMI_TG_EN);
> -	hdmi_dumpregs(hdev, "streamon");
> -	return 0;
> -}
> -
> -static int hdmi_streamoff(struct hdmi_device *hdev)
> -{
> -	struct device *dev = hdev->dev;
> -	struct hdmi_resources *res = &hdev->res;
> -
> -	dev_dbg(dev, "%s\n", __func__);
> -
> -	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_EN);
> -	hdmi_write_mask(hdev, HDMI_TG_CMD, 0, HDMI_TG_EN);
> -
> -	/* pixel(vpll) clock is used for HDMI in config mode */
> -	clk_disable(res->sclk_hdmi);
> -	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
> -	clk_enable(res->sclk_hdmi);
> -
> -	v4l2_subdev_call(hdev->mhl_sd, video, s_stream, 0);
> -	v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
> -
> -	hdmi_dumpregs(hdev, "streamoff");
> -	return 0;
> -}
> -
> -static int hdmi_s_stream(struct v4l2_subdev *sd, int enable)
> -{
> -	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> -	struct device *dev = hdev->dev;
> -
> -	dev_dbg(dev, "%s(%d)\n", __func__, enable);
> -	if (enable)
> -		return hdmi_streamon(hdev);
> -	return hdmi_streamoff(hdev);
> -}
> -
> -static int hdmi_resource_poweron(struct hdmi_resources *res)
> -{
> -	int ret;
> -
> -	/* turn HDMI power on */
> -	ret = regulator_bulk_enable(res->regul_count, res->regul_bulk);
> -	if (ret < 0)
> -		return ret;
> -	/* power-on hdmi physical interface */
> -	clk_enable(res->hdmiphy);
> -	/* use VPP as parent clock; HDMIPHY is not working yet */
> -	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
> -	/* turn clocks on */
> -	clk_enable(res->sclk_hdmi);
> -
> -	return 0;
> -}
> -
> -static void hdmi_resource_poweroff(struct hdmi_resources *res)
> -{
> -	/* turn clocks off */
> -	clk_disable(res->sclk_hdmi);
> -	/* power-off hdmiphy */
> -	clk_disable(res->hdmiphy);
> -	/* turn HDMI power off */
> -	regulator_bulk_disable(res->regul_count, res->regul_bulk);
> -}
> -
> -static int hdmi_s_power(struct v4l2_subdev *sd, int on)
> -{
> -	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> -	int ret;
> -
> -	if (on)
> -		ret = pm_runtime_get_sync(hdev->dev);
> -	else
> -		ret = pm_runtime_put_sync(hdev->dev);
> -	/* only values < 0 indicate errors */
> -	return ret < 0 ? ret : 0;
> -}
> -
> -static int hdmi_s_dv_timings(struct v4l2_subdev *sd,
> -	struct v4l2_dv_timings *timings)
> -{
> -	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> -	struct device *dev = hdev->dev;
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(hdmi_timings); i++)
> -		if (v4l2_match_dv_timings(&hdmi_timings[i].dv_timings,
> -					timings, 0, false))
> -			break;
> -	if (i == ARRAY_SIZE(hdmi_timings)) {
> -		dev_err(dev, "timings not supported\n");
> -		return -EINVAL;
> -	}
> -	hdev->cur_conf = hdmi_timings[i].hdmi_timings;
> -	hdev->cur_conf_dirty = 1;
> -	hdev->cur_timings = *timings;
> -	if (!hdmi_timings[i].reduced_fps)
> -		hdev->cur_timings.bt.flags &= ~V4L2_DV_FL_CAN_REDUCE_FPS;
> -	return 0;
> -}
> -
> -static int hdmi_g_dv_timings(struct v4l2_subdev *sd,
> -	struct v4l2_dv_timings *timings)
> -{
> -	*timings = sd_to_hdmi_dev(sd)->cur_timings;
> -	return 0;
> -}
> -
> -static int hdmi_get_fmt(struct v4l2_subdev *sd,
> -		struct v4l2_subdev_pad_config *cfg,
> -		struct v4l2_subdev_format *format)
> -{
> -	struct v4l2_mbus_framefmt *fmt = &format->format;
> -	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> -	const struct hdmi_timings *t = hdev->cur_conf;
> -
> -	dev_dbg(hdev->dev, "%s\n", __func__);
> -	if (!hdev->cur_conf)
> -		return -EINVAL;
> -	if (format->pad)
> -		return -EINVAL;
> -
> -	memset(fmt, 0, sizeof(*fmt));
> -	fmt->width = t->hact.end - t->hact.beg;
> -	fmt->height = t->vact[0].end - t->vact[0].beg;
> -	fmt->code = MEDIA_BUS_FMT_FIXED; /* means RGB888 */
> -	fmt->colorspace = V4L2_COLORSPACE_SRGB;
> -	if (t->interlaced) {
> -		fmt->field = V4L2_FIELD_INTERLACED;
> -		fmt->height *= 2;
> -	} else {
> -		fmt->field = V4L2_FIELD_NONE;
> -	}
> -	return 0;
> -}
> -
> -static int hdmi_enum_dv_timings(struct v4l2_subdev *sd,
> -	struct v4l2_enum_dv_timings *timings)
> -{
> -	if (timings->pad != 0)
> -		return -EINVAL;
> -	if (timings->index >= ARRAY_SIZE(hdmi_timings))
> -		return -EINVAL;
> -	timings->timings = hdmi_timings[timings->index].dv_timings;
> -	if (!hdmi_timings[timings->index].reduced_fps)
> -		timings->timings.bt.flags &= ~V4L2_DV_FL_CAN_REDUCE_FPS;
> -	return 0;
> -}
> -
> -static int hdmi_dv_timings_cap(struct v4l2_subdev *sd,
> -	struct v4l2_dv_timings_cap *cap)
> -{
> -	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> -
> -	if (cap->pad != 0)
> -		return -EINVAL;
> -
> -	/* Let the phy fill in the pixelclock range */
> -	v4l2_subdev_call(hdev->phy_sd, pad, dv_timings_cap, cap);
> -	cap->type = V4L2_DV_BT_656_1120;
> -	cap->bt.min_width = 720;
> -	cap->bt.max_width = 1920;
> -	cap->bt.min_height = 480;
> -	cap->bt.max_height = 1080;
> -	cap->bt.standards = V4L2_DV_BT_STD_CEA861;
> -	cap->bt.capabilities = V4L2_DV_BT_CAP_INTERLACED |
> -			       V4L2_DV_BT_CAP_PROGRESSIVE;
> -	return 0;
> -}
> -
> -static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
> -	.s_power = hdmi_s_power,
> -};
> -
> -static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
> -	.s_dv_timings = hdmi_s_dv_timings,
> -	.g_dv_timings = hdmi_g_dv_timings,
> -	.s_stream = hdmi_s_stream,
> -};
> -
> -static const struct v4l2_subdev_pad_ops hdmi_sd_pad_ops = {
> -	.enum_dv_timings = hdmi_enum_dv_timings,
> -	.dv_timings_cap = hdmi_dv_timings_cap,
> -	.get_fmt = hdmi_get_fmt,
> -};
> -
> -static const struct v4l2_subdev_ops hdmi_sd_ops = {
> -	.core = &hdmi_sd_core_ops,
> -	.video = &hdmi_sd_video_ops,
> -	.pad = &hdmi_sd_pad_ops,
> -};
> -
> -static int hdmi_runtime_suspend(struct device *dev)
> -{
> -	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> -	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> -
> -	dev_dbg(dev, "%s\n", __func__);
> -	v4l2_subdev_call(hdev->mhl_sd, core, s_power, 0);
> -	hdmi_resource_poweroff(&hdev->res);
> -	/* flag that device context is lost */
> -	hdev->cur_conf_dirty = 1;
> -	return 0;
> -}
> -
> -static int hdmi_runtime_resume(struct device *dev)
> -{
> -	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> -	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> -	int ret;
> -
> -	dev_dbg(dev, "%s\n", __func__);
> -
> -	ret = hdmi_resource_poweron(&hdev->res);
> -	if (ret < 0)
> -		return ret;
> -
> -	/* starting MHL */
> -	ret = v4l2_subdev_call(hdev->mhl_sd, core, s_power, 1);
> -	if (hdev->mhl_sd && ret)
> -		goto fail;
> -
> -	dev_dbg(dev, "poweron succeed\n");
> -
> -	return 0;
> -
> -fail:
> -	hdmi_resource_poweroff(&hdev->res);
> -	dev_err(dev, "poweron failed\n");
> -
> -	return ret;
> -}
> -
> -static const struct dev_pm_ops hdmi_pm_ops = {
> -	.runtime_suspend = hdmi_runtime_suspend,
> -	.runtime_resume	 = hdmi_runtime_resume,
> -};
> -
> -static void hdmi_resource_clear_clocks(struct hdmi_resources *res)
> -{
> -	res->hdmi	 = ERR_PTR(-EINVAL);
> -	res->sclk_hdmi	 = ERR_PTR(-EINVAL);
> -	res->sclk_pixel	 = ERR_PTR(-EINVAL);
> -	res->sclk_hdmiphy = ERR_PTR(-EINVAL);
> -	res->hdmiphy	 = ERR_PTR(-EINVAL);
> -}
> -
> -static void hdmi_resources_cleanup(struct hdmi_device *hdev)
> -{
> -	struct hdmi_resources *res = &hdev->res;
> -
> -	dev_dbg(hdev->dev, "HDMI resource cleanup\n");
> -	/* put clocks, power */
> -	if (res->regul_count)
> -		regulator_bulk_free(res->regul_count, res->regul_bulk);
> -	/* kfree is NULL-safe */
> -	kfree(res->regul_bulk);
> -	if (!IS_ERR(res->hdmiphy))
> -		clk_put(res->hdmiphy);
> -	if (!IS_ERR(res->sclk_hdmiphy))
> -		clk_put(res->sclk_hdmiphy);
> -	if (!IS_ERR(res->sclk_pixel))
> -		clk_put(res->sclk_pixel);
> -	if (!IS_ERR(res->sclk_hdmi))
> -		clk_put(res->sclk_hdmi);
> -	if (!IS_ERR(res->hdmi))
> -		clk_put(res->hdmi);
> -	memset(res, 0, sizeof(*res));
> -	hdmi_resource_clear_clocks(res);
> -}
> -
> -static int hdmi_resources_init(struct hdmi_device *hdev)
> -{
> -	struct device *dev = hdev->dev;
> -	struct hdmi_resources *res = &hdev->res;
> -	static char *supply[] = {
> -		"hdmi-en",
> -		"vdd",
> -		"vdd_osc",
> -		"vdd_pll",
> -	};
> -	int i, ret;
> -
> -	dev_dbg(dev, "HDMI resource init\n");
> -
> -	memset(res, 0, sizeof(*res));
> -	hdmi_resource_clear_clocks(res);
> -
> -	/* get clocks, power */
> -	res->hdmi = clk_get(dev, "hdmi");
> -	if (IS_ERR(res->hdmi)) {
> -		dev_err(dev, "failed to get clock 'hdmi'\n");
> -		goto fail;
> -	}
> -	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
> -	if (IS_ERR(res->sclk_hdmi)) {
> -		dev_err(dev, "failed to get clock 'sclk_hdmi'\n");
> -		goto fail;
> -	}
> -	res->sclk_pixel = clk_get(dev, "sclk_pixel");
> -	if (IS_ERR(res->sclk_pixel)) {
> -		dev_err(dev, "failed to get clock 'sclk_pixel'\n");
> -		goto fail;
> -	}
> -	res->sclk_hdmiphy = clk_get(dev, "sclk_hdmiphy");
> -	if (IS_ERR(res->sclk_hdmiphy)) {
> -		dev_err(dev, "failed to get clock 'sclk_hdmiphy'\n");
> -		goto fail;
> -	}
> -	res->hdmiphy = clk_get(dev, "hdmiphy");
> -	if (IS_ERR(res->hdmiphy)) {
> -		dev_err(dev, "failed to get clock 'hdmiphy'\n");
> -		goto fail;
> -	}
> -	res->regul_bulk = kcalloc(ARRAY_SIZE(supply),
> -				  sizeof(res->regul_bulk[0]), GFP_KERNEL);
> -	if (!res->regul_bulk) {
> -		dev_err(dev, "failed to get memory for regulators\n");
> -		goto fail;
> -	}
> -	for (i = 0; i < ARRAY_SIZE(supply); ++i) {
> -		res->regul_bulk[i].supply = supply[i];
> -		res->regul_bulk[i].consumer = NULL;
> -	}
> -
> -	ret = regulator_bulk_get(dev, ARRAY_SIZE(supply), res->regul_bulk);
> -	if (ret) {
> -		dev_err(dev, "failed to get regulators\n");
> -		goto fail;
> -	}
> -	res->regul_count = ARRAY_SIZE(supply);
> -
> -	return 0;
> -fail:
> -	dev_err(dev, "HDMI resource init - failed\n");
> -	hdmi_resources_cleanup(hdev);
> -	return -ENODEV;
> -}
> -
> -static int hdmi_probe(struct platform_device *pdev)
> -{
> -	struct device *dev = &pdev->dev;
> -	struct resource *res;
> -	struct i2c_adapter *adapter;
> -	struct v4l2_subdev *sd;
> -	struct hdmi_device *hdmi_dev = NULL;
> -	struct s5p_hdmi_platform_data *pdata = dev->platform_data;
> -	int ret;
> -
> -	dev_dbg(dev, "probe start\n");
> -
> -	if (!pdata) {
> -		dev_err(dev, "platform data is missing\n");
> -		ret = -ENODEV;
> -		goto fail;
> -	}
> -
> -	hdmi_dev = devm_kzalloc(&pdev->dev, sizeof(*hdmi_dev), GFP_KERNEL);
> -	if (!hdmi_dev) {
> -		dev_err(dev, "out of memory\n");
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> -
> -	hdmi_dev->dev = dev;
> -
> -	ret = hdmi_resources_init(hdmi_dev);
> -	if (ret)
> -		goto fail;
> -
> -	/* mapping HDMI registers */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (res == NULL) {
> -		dev_err(dev, "get memory resource failed.\n");
> -		ret = -ENXIO;
> -		goto fail_init;
> -	}
> -
> -	hdmi_dev->regs = devm_ioremap(&pdev->dev, res->start,
> -				      resource_size(res));
> -	if (hdmi_dev->regs == NULL) {
> -		dev_err(dev, "register mapping failed.\n");
> -		ret = -ENXIO;
> -		goto fail_init;
> -	}
> -
> -	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -	if (res == NULL) {
> -		dev_err(dev, "get interrupt resource failed.\n");
> -		ret = -ENXIO;
> -		goto fail_init;
> -	}
> -
> -	ret = devm_request_irq(&pdev->dev, res->start, hdmi_irq_handler, 0,
> -			       "hdmi", hdmi_dev);
> -	if (ret) {
> -		dev_err(dev, "request interrupt failed.\n");
> -		goto fail_init;
> -	}
> -	hdmi_dev->irq = res->start;
> -
> -	/* setting v4l2 name to prevent WARN_ON in v4l2_device_register */
> -	strlcpy(hdmi_dev->v4l2_dev.name, dev_name(dev),
> -		sizeof(hdmi_dev->v4l2_dev.name));
> -	/* passing NULL owner prevents driver from erasing drvdata */
> -	ret = v4l2_device_register(NULL, &hdmi_dev->v4l2_dev);
> -	if (ret) {
> -		dev_err(dev, "could not register v4l2 device.\n");
> -		goto fail_init;
> -	}
> -
> -	/* testing if hdmiphy info is present */
> -	if (!pdata->hdmiphy_info) {
> -		dev_err(dev, "hdmiphy info is missing in platform data\n");
> -		ret = -ENXIO;
> -		goto fail_vdev;
> -	}
> -
> -	adapter = i2c_get_adapter(pdata->hdmiphy_bus);
> -	if (adapter == NULL) {
> -		dev_err(dev, "hdmiphy adapter request failed\n");
> -		ret = -ENXIO;
> -		goto fail_vdev;
> -	}
> -
> -	hdmi_dev->phy_sd = v4l2_i2c_new_subdev_board(&hdmi_dev->v4l2_dev,
> -		adapter, pdata->hdmiphy_info, NULL);
> -	/* on failure or not adapter is no longer useful */
> -	i2c_put_adapter(adapter);
> -	if (hdmi_dev->phy_sd == NULL) {
> -		dev_err(dev, "missing subdev for hdmiphy\n");
> -		ret = -ENODEV;
> -		goto fail_vdev;
> -	}
> -
> -	/* initialization of MHL interface if present */
> -	if (pdata->mhl_info) {
> -		adapter = i2c_get_adapter(pdata->mhl_bus);
> -		if (adapter == NULL) {
> -			dev_err(dev, "MHL adapter request failed\n");
> -			ret = -ENXIO;
> -			goto fail_vdev;
> -		}
> -
> -		hdmi_dev->mhl_sd = v4l2_i2c_new_subdev_board(
> -			&hdmi_dev->v4l2_dev, adapter,
> -			pdata->mhl_info, NULL);
> -		/* on failure or not adapter is no longer useful */
> -		i2c_put_adapter(adapter);
> -		if (hdmi_dev->mhl_sd == NULL) {
> -			dev_err(dev, "missing subdev for MHL\n");
> -			ret = -ENODEV;
> -			goto fail_vdev;
> -		}
> -	}
> -
> -	clk_enable(hdmi_dev->res.hdmi);
> -
> -	pm_runtime_enable(dev);
> -
> -	sd = &hdmi_dev->sd;
> -	v4l2_subdev_init(sd, &hdmi_sd_ops);
> -	sd->owner = THIS_MODULE;
> -
> -	strlcpy(sd->name, "s5p-hdmi", sizeof(sd->name));
> -	hdmi_dev->cur_timings =
> -		hdmi_timings[HDMI_DEFAULT_TIMINGS_IDX].dv_timings;
> -	/* FIXME: missing fail timings is not supported */
> -	hdmi_dev->cur_conf =
> -		hdmi_timings[HDMI_DEFAULT_TIMINGS_IDX].hdmi_timings;
> -	hdmi_dev->cur_conf_dirty = 1;
> -
> -	/* storing subdev for call that have only access to struct device */
> -	dev_set_drvdata(dev, sd);
> -
> -	dev_info(dev, "probe successful\n");
> -
> -	return 0;
> -
> -fail_vdev:
> -	v4l2_device_unregister(&hdmi_dev->v4l2_dev);
> -
> -fail_init:
> -	hdmi_resources_cleanup(hdmi_dev);
> -
> -fail:
> -	dev_err(dev, "probe failed\n");
> -	return ret;
> -}
> -
> -static int hdmi_remove(struct platform_device *pdev)
> -{
> -	struct device *dev = &pdev->dev;
> -	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> -	struct hdmi_device *hdmi_dev = sd_to_hdmi_dev(sd);
> -
> -	pm_runtime_disable(dev);
> -	clk_disable(hdmi_dev->res.hdmi);
> -	v4l2_device_unregister(&hdmi_dev->v4l2_dev);
> -	disable_irq(hdmi_dev->irq);
> -	hdmi_resources_cleanup(hdmi_dev);
> -	dev_info(dev, "remove successful\n");
> -
> -	return 0;
> -}
> -
> -static struct platform_driver hdmi_driver __refdata = {
> -	.probe = hdmi_probe,
> -	.remove = hdmi_remove,
> -	.id_table = hdmi_driver_types,
> -	.driver = {
> -		.name = "s5p-hdmi",
> -		.pm = &hdmi_pm_ops,
> -	}
> -};
> -
> -module_platform_driver(hdmi_driver);
> diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
> deleted file mode 100644
> index aae6523..0000000
> --- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
> +++ /dev/null
> @@ -1,324 +0,0 @@
> -/*
> - * Samsung HDMI Physical interface driver
> - *
> - * Copyright (C) 2010-2011 Samsung Electronics Co.Ltd
> - * Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
> - *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/i2c.h>
> -#include <linux/slab.h>
> -#include <linux/clk.h>
> -#include <linux/io.h>
> -#include <linux/interrupt.h>
> -#include <linux/irq.h>
> -#include <linux/err.h>
> -
> -#include <media/v4l2-subdev.h>
> -
> -MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
> -MODULE_DESCRIPTION("Samsung HDMI Physical interface driver");
> -MODULE_LICENSE("GPL");
> -
> -struct hdmiphy_conf {
> -	unsigned long pixclk;
> -	const u8 *data;
> -};
> -
> -struct hdmiphy_ctx {
> -	struct v4l2_subdev sd;
> -	const struct hdmiphy_conf *conf_tab;
> -};
> -
> -static const struct hdmiphy_conf hdmiphy_conf_s5pv210[] = {
> -	{ .pixclk = 27000000, .data = (u8 [32]) {
> -		0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
> -		0x6B, 0x10, 0x02, 0x52, 0xDF, 0xF2, 0x54, 0x87,
> -		0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
> -		0x22, 0x40, 0xE3, 0x26, 0x00, 0x00, 0x00, 0x00, }
> -	},
> -	{ .pixclk = 27027000, .data = (u8 [32]) {
> -		0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0x09, 0x64,
> -		0x6B, 0x10, 0x02, 0x52, 0xDF, 0xF2, 0x54, 0x87,
> -		0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
> -		0x22, 0x40, 0xE2, 0x26, 0x00, 0x00, 0x00, 0x00, }
> -	},
> -	{ .pixclk = 74176000, .data = (u8 [32]) {
> -		0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xEF, 0x5B,
> -		0x6D, 0x10, 0x01, 0x52, 0xEF, 0xF3, 0x54, 0xB9,
> -		0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
> -		0x22, 0x40, 0xA5, 0x26, 0x01, 0x00, 0x00, 0x00, }
> -	},
> -	{ .pixclk = 74250000, .data = (u8 [32]) {
> -		0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xF8, 0x40,
> -		0x6A, 0x10, 0x01, 0x52, 0xFF, 0xF1, 0x54, 0xBA,
> -		0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
> -		0x22, 0x40, 0xA4, 0x26, 0x01, 0x00, 0x00, 0x00, }
> -	},
> -	{ /* end marker */ }
> -};
> -
> -static const struct hdmiphy_conf hdmiphy_conf_exynos4210[] = {
> -	{ .pixclk = 27000000, .data = (u8 [32]) {
> -		0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
> -		0x6B, 0x10, 0x02, 0x51, 0xDF, 0xF2, 0x54, 0x87,
> -		0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
> -		0x22, 0x40, 0xE3, 0x26, 0x00, 0x00, 0x00, 0x00, }
> -	},
> -	{ .pixclk = 27027000, .data = (u8 [32]) {
> -		0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0x09, 0x64,
> -		0x6B, 0x10, 0x02, 0x51, 0xDF, 0xF2, 0x54, 0x87,
> -		0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
> -		0x22, 0x40, 0xE2, 0x26, 0x00, 0x00, 0x00, 0x00, }
> -	},
> -	{ .pixclk = 74176000, .data = (u8 [32]) {
> -		0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xEF, 0x5B,
> -		0x6D, 0x10, 0x01, 0x51, 0xEF, 0xF3, 0x54, 0xB9,
> -		0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
> -		0x22, 0x40, 0xA5, 0x26, 0x01, 0x00, 0x00, 0x00, }
> -	},
> -	{ .pixclk = 74250000, .data = (u8 [32]) {
> -		0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xF8, 0x40,
> -		0x6A, 0x10, 0x01, 0x51, 0xFF, 0xF1, 0x54, 0xBA,
> -		0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
> -		0x22, 0x40, 0xA4, 0x26, 0x01, 0x00, 0x00, 0x00, }
> -	},
> -	{ .pixclk = 148352000, .data = (u8 [32]) {
> -		0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xEF, 0x5B,
> -		0x6D, 0x18, 0x00, 0x51, 0xEF, 0xF3, 0x54, 0xB9,
> -		0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
> -		0x11, 0x40, 0xA5, 0x26, 0x02, 0x00, 0x00, 0x00, }
> -	},
> -	{ .pixclk = 148500000, .data = (u8 [32]) {
> -		0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xF8, 0x40,
> -		0x6A, 0x18, 0x00, 0x51, 0xFF, 0xF1, 0x54, 0xBA,
> -		0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
> -		0x11, 0x40, 0xA4, 0x26, 0x02, 0x00, 0x00, 0x00, }
> -	},
> -	{ /* end marker */ }
> -};
> -
> -static const struct hdmiphy_conf hdmiphy_conf_exynos4212[] = {
> -	{ .pixclk = 27000000, .data = (u8 [32]) {
> -		0x01, 0x11, 0x2D, 0x75, 0x00, 0x01, 0x00, 0x08,
> -		0x82, 0x00, 0x0E, 0xD9, 0x45, 0xA0, 0x34, 0xC0,
> -		0x0B, 0x80, 0x12, 0x87, 0x08, 0x24, 0x24, 0x71,
> -		0x54, 0xE3, 0x24, 0x00, 0x00, 0x00, 0x01, 0x00, }
> -	},
> -	{ .pixclk = 27027000, .data = (u8 [32]) {
> -		0x01, 0x91, 0x2D, 0x72, 0x00, 0x64, 0x12, 0x08,
> -		0x43, 0x20, 0x0E, 0xD9, 0x45, 0xA0, 0x34, 0xC0,
> -		0x0B, 0x80, 0x12, 0x87, 0x08, 0x24, 0x24, 0x71,
> -		0x54, 0xE2, 0x24, 0x00, 0x00, 0x00, 0x01, 0x00, }
> -	},
> -	{ .pixclk = 74176000, .data = (u8 [32]) {
> -		0x01, 0x91, 0x3E, 0x35, 0x00, 0x5B, 0xDE, 0x08,
> -		0x82, 0x20, 0x73, 0xD9, 0x45, 0xA0, 0x34, 0xC0,
> -		0x0B, 0x80, 0x12, 0x87, 0x08, 0x24, 0x24, 0x52,
> -		0x54, 0xA5, 0x24, 0x01, 0x00, 0x00, 0x01, 0x00, }
> -	},
> -	{ .pixclk = 74250000, .data = (u8 [32]) {
> -		0x01, 0x91, 0x3E, 0x35, 0x00, 0x40, 0xF0, 0x08,
> -		0x82, 0x20, 0x73, 0xD9, 0x45, 0xA0, 0x34, 0xC0,
> -		0x0B, 0x80, 0x12, 0x87, 0x08, 0x24, 0x24, 0x52,
> -		0x54, 0xA4, 0x24, 0x01, 0x00, 0x00, 0x01, 0x00, }
> -	},
> -	{ .pixclk = 148500000, .data = (u8 [32]) {
> -		0x01, 0x91, 0x3E, 0x15, 0x00, 0x40, 0xF0, 0x08,
> -		0x82, 0x20, 0x73, 0xD9, 0x45, 0xA0, 0x34, 0xC0,
> -		0x0B, 0x80, 0x12, 0x87, 0x08, 0x24, 0x24, 0xA4,
> -		0x54, 0x4A, 0x25, 0x03, 0x00, 0x00, 0x01, 0x00, }
> -	},
> -	{ /* end marker */ }
> -};
> -
> -static const struct hdmiphy_conf hdmiphy_conf_exynos4412[] = {
> -	{ .pixclk = 27000000, .data = (u8 [32]) {
> -		0x01, 0x11, 0x2D, 0x75, 0x40, 0x01, 0x00, 0x08,
> -		0x82, 0x00, 0x0E, 0xD9, 0x45, 0xA0, 0xAC, 0x80,
> -		0x08, 0x80, 0x11, 0x84, 0x02, 0x22, 0x44, 0x86,
> -		0x54, 0xE4, 0x24, 0x00, 0x00, 0x00, 0x01, 0x00, }
> -	},
> -	{ .pixclk = 27027000, .data = (u8 [32]) {
> -		0x01, 0x91, 0x2D, 0x72, 0x40, 0x64, 0x12, 0x08,
> -		0x43, 0x20, 0x0E, 0xD9, 0x45, 0xA0, 0xAC, 0x80,
> -		0x08, 0x80, 0x11, 0x84, 0x02, 0x22, 0x44, 0x86,
> -		0x54, 0xE3, 0x24, 0x00, 0x00, 0x00, 0x01, 0x00, }
> -	},
> -	{ .pixclk = 74176000, .data = (u8 [32]) {
> -		0x01, 0x91, 0x1F, 0x10, 0x40, 0x5B, 0xEF, 0x08,
> -		0x81, 0x20, 0xB9, 0xD8, 0x45, 0xA0, 0xAC, 0x80,
> -		0x08, 0x80, 0x11, 0x84, 0x02, 0x22, 0x44, 0x86,
> -		0x54, 0xA6, 0x24, 0x01, 0x00, 0x00, 0x01, 0x00, }
> -	},
> -	{ .pixclk = 74250000, .data = (u8 [32]) {
> -		0x01, 0x91, 0x1F, 0x10, 0x40, 0x40, 0xF8, 0x08,
> -		0x81, 0x20, 0xBA, 0xD8, 0x45, 0xA0, 0xAC, 0x80,
> -		0x08, 0x80, 0x11, 0x84, 0x02, 0x22, 0x44, 0x86,
> -		0x54, 0xA5, 0x24, 0x01, 0x00, 0x00, 0x01, 0x00, }
> -	},
> -	{ .pixclk = 148500000, .data = (u8 [32]) {
> -		0x01, 0x91, 0x1F, 0x00, 0x40, 0x40, 0xF8, 0x08,
> -		0x81, 0x20, 0xBA, 0xD8, 0x45, 0xA0, 0xAC, 0x80,
> -		0x08, 0x80, 0x11, 0x84, 0x02, 0x22, 0x44, 0x86,
> -		0x54, 0x4B, 0x25, 0x03, 0x00, 0x00, 0x01, 0x00, }
> -	},
> -	{ /* end marker */ }
> -};
> -
> -static inline struct hdmiphy_ctx *sd_to_ctx(struct v4l2_subdev *sd)
> -{
> -	return container_of(sd, struct hdmiphy_ctx, sd);
> -}
> -
> -static const u8 *hdmiphy_find_conf(unsigned long pixclk,
> -		const struct hdmiphy_conf *conf)
> -{
> -	for (; conf->pixclk; ++conf)
> -		if (conf->pixclk == pixclk)
> -			return conf->data;
> -	return NULL;
> -}
> -
> -static int hdmiphy_s_power(struct v4l2_subdev *sd, int on)
> -{
> -	/* to be implemented */
> -	return 0;
> -}
> -
> -static int hdmiphy_s_dv_timings(struct v4l2_subdev *sd,
> -	struct v4l2_dv_timings *timings)
> -{
> -	const u8 *data;
> -	u8 buffer[32];
> -	int ret;
> -	struct hdmiphy_ctx *ctx = sd_to_ctx(sd);
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct device *dev = &client->dev;
> -	unsigned long pixclk = timings->bt.pixelclock;
> -
> -	dev_info(dev, "s_dv_timings\n");
> -	if ((timings->bt.flags & V4L2_DV_FL_REDUCED_FPS) && pixclk == 74250000)
> -		pixclk = 74176000;
> -	data = hdmiphy_find_conf(pixclk, ctx->conf_tab);
> -	if (!data) {
> -		dev_err(dev, "format not supported\n");
> -		return -EINVAL;
> -	}
> -
> -	/* storing configuration to the device */
> -	memcpy(buffer, data, 32);
> -	ret = i2c_master_send(client, buffer, 32);
> -	if (ret != 32) {
> -		dev_err(dev, "failed to configure HDMIPHY via I2C\n");
> -		return -EIO;
> -	}
> -
> -	return 0;
> -}
> -
> -static int hdmiphy_dv_timings_cap(struct v4l2_subdev *sd,
> -	struct v4l2_dv_timings_cap *cap)
> -{
> -	if (cap->pad != 0)
> -		return -EINVAL;
> -
> -	cap->type = V4L2_DV_BT_656_1120;
> -	/* The phy only determines the pixelclock, leave the other values
> -	 * at 0 to signify that we have no information for them. */
> -	cap->bt.min_pixelclock = 27000000;
> -	cap->bt.max_pixelclock = 148500000;
> -	return 0;
> -}
> -
> -static int hdmiphy_s_stream(struct v4l2_subdev *sd, int enable)
> -{
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct device *dev = &client->dev;
> -	u8 buffer[2];
> -	int ret;
> -
> -	dev_info(dev, "s_stream(%d)\n", enable);
> -	/* going to/from configuration from/to operation mode */
> -	buffer[0] = 0x1f;
> -	buffer[1] = enable ? 0x80 : 0x00;
> -
> -	ret = i2c_master_send(client, buffer, 2);
> -	if (ret != 2) {
> -		dev_err(dev, "stream (%d) failed\n", enable);
> -		return -EIO;
> -	}
> -	return 0;
> -}
> -
> -static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
> -	.s_power =  hdmiphy_s_power,
> -};
> -
> -static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
> -	.s_dv_timings = hdmiphy_s_dv_timings,
> -	.s_stream =  hdmiphy_s_stream,
> -};
> -
> -static const struct v4l2_subdev_pad_ops hdmiphy_pad_ops = {
> -	.dv_timings_cap = hdmiphy_dv_timings_cap,
> -};
> -
> -static const struct v4l2_subdev_ops hdmiphy_ops = {
> -	.core = &hdmiphy_core_ops,
> -	.video = &hdmiphy_video_ops,
> -	.pad = &hdmiphy_pad_ops,
> -};
> -
> -static int hdmiphy_probe(struct i2c_client *client,
> -			 const struct i2c_device_id *id)
> -{
> -	struct hdmiphy_ctx *ctx;
> -
> -	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> -	if (!ctx)
> -		return -ENOMEM;
> -
> -	ctx->conf_tab = (struct hdmiphy_conf *)id->driver_data;
> -	v4l2_i2c_subdev_init(&ctx->sd, client, &hdmiphy_ops);
> -
> -	dev_info(&client->dev, "probe successful\n");
> -	return 0;
> -}
> -
> -static int hdmiphy_remove(struct i2c_client *client)
> -{
> -	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> -	struct hdmiphy_ctx *ctx = sd_to_ctx(sd);
> -
> -	kfree(ctx);
> -	dev_info(&client->dev, "remove successful\n");
> -
> -	return 0;
> -}
> -
> -static const struct i2c_device_id hdmiphy_id[] = {
> -	{ "hdmiphy", (unsigned long)hdmiphy_conf_exynos4210 },
> -	{ "hdmiphy-s5pv210", (unsigned long)hdmiphy_conf_s5pv210 },
> -	{ "hdmiphy-exynos4210", (unsigned long)hdmiphy_conf_exynos4210 },
> -	{ "hdmiphy-exynos4212", (unsigned long)hdmiphy_conf_exynos4212 },
> -	{ "hdmiphy-exynos4412", (unsigned long)hdmiphy_conf_exynos4412 },
> -	{ },
> -};
> -MODULE_DEVICE_TABLE(i2c, hdmiphy_id);
> -
> -static struct i2c_driver hdmiphy_driver = {
> -	.driver = {
> -		.name	= "s5p-hdmiphy",
> -	},
> -	.probe		= hdmiphy_probe,
> -	.remove		= hdmiphy_remove,
> -	.id_table = hdmiphy_id,
> -};
> -
> -module_i2c_driver(hdmiphy_driver);
> diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
> deleted file mode 100644
> index 869f0ce..0000000
> --- a/drivers/media/platform/s5p-tv/mixer.h
> +++ /dev/null
> @@ -1,364 +0,0 @@
> -/*
> - * Samsung TV Mixer driver
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *
> - * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published
> - * by the Free Software Foundiation. either version 2 of the License,
> - * or (at your option) any later version
> - */
> -
> -#ifndef SAMSUNG_MIXER_H
> -#define SAMSUNG_MIXER_H
> -
> -#ifdef CONFIG_VIDEO_SAMSUNG_S5P_MIXER_DEBUG
> -	#define DEBUG
> -#endif
> -
> -#include <linux/fb.h>
> -#include <linux/irqreturn.h>
> -#include <linux/kernel.h>
> -#include <linux/spinlock.h>
> -#include <linux/wait.h>
> -#include <media/v4l2-device.h>
> -#include <media/videobuf2-v4l2.h>
> -
> -#include "regs-mixer.h"
> -
> -/** maximum number of output interfaces */
> -#define MXR_MAX_OUTPUTS 2
> -/** maximum number of input interfaces (layers) */
> -#define MXR_MAX_LAYERS 3
> -#define MXR_DRIVER_NAME "s5p-mixer"
> -/** maximal number of planes for every layer */
> -#define MXR_MAX_PLANES	2
> -
> -#define MXR_ENABLE 1
> -#define MXR_DISABLE 0
> -
> -/** description of a macroblock for packed formats */
> -struct mxr_block {
> -	/** vertical number of pixels in macroblock */
> -	unsigned int width;
> -	/** horizontal number of pixels in macroblock */
> -	unsigned int height;
> -	/** size of block in bytes */
> -	unsigned int size;
> -};
> -
> -/** description of supported format */
> -struct mxr_format {
> -	/** format name/mnemonic */
> -	const char *name;
> -	/** fourcc identifier */
> -	u32 fourcc;
> -	/** colorspace identifier */
> -	enum v4l2_colorspace colorspace;
> -	/** number of planes in image data */
> -	int num_planes;
> -	/** description of block for each plane */
> -	struct mxr_block plane[MXR_MAX_PLANES];
> -	/** number of subframes in image data */
> -	int num_subframes;
> -	/** specifies to which subframe belong given plane */
> -	int plane2subframe[MXR_MAX_PLANES];
> -	/** internal code, driver dependent */
> -	unsigned long cookie;
> -};
> -
> -/** description of crop configuration for image */
> -struct mxr_crop {
> -	/** width of layer in pixels */
> -	unsigned int full_width;
> -	/** height of layer in pixels */
> -	unsigned int full_height;
> -	/** horizontal offset of first pixel to be displayed */
> -	unsigned int x_offset;
> -	/** vertical offset of first pixel to be displayed */
> -	unsigned int y_offset;
> -	/** width of displayed data in pixels */
> -	unsigned int width;
> -	/** height of displayed data in pixels */
> -	unsigned int height;
> -	/** indicate which fields are present in buffer */
> -	unsigned int field;
> -};
> -
> -/** stages of geometry operations */
> -enum mxr_geometry_stage {
> -	MXR_GEOMETRY_SINK,
> -	MXR_GEOMETRY_COMPOSE,
> -	MXR_GEOMETRY_CROP,
> -	MXR_GEOMETRY_SOURCE,
> -};
> -
> -/* flag indicating that offset should be 0 */
> -#define MXR_NO_OFFSET	0x80000000
> -
> -/** description of transformation from source to destination image */
> -struct mxr_geometry {
> -	/** cropping for source image */
> -	struct mxr_crop src;
> -	/** cropping for destination image */
> -	struct mxr_crop dst;
> -	/** layer-dependant description of horizontal scaling */
> -	unsigned int x_ratio;
> -	/** layer-dependant description of vertical scaling */
> -	unsigned int y_ratio;
> -};
> -
> -/** instance of a buffer */
> -struct mxr_buffer {
> -	/** common v4l buffer stuff -- must be first */
> -	struct vb2_v4l2_buffer vb;
> -	/** node for layer's lists */
> -	struct list_head	list;
> -};
> -
> -
> -/** internal states of layer */
> -enum mxr_layer_state {
> -	/** layers is not shown */
> -	MXR_LAYER_IDLE = 0,
> -	/** layer is shown */
> -	MXR_LAYER_STREAMING,
> -	/** state before STREAMOFF is finished */
> -	MXR_LAYER_STREAMING_FINISH,
> -};
> -
> -/** forward declarations */
> -struct mxr_device;
> -struct mxr_layer;
> -
> -/** callback for layers operation */
> -struct mxr_layer_ops {
> -	/* TODO: try to port it to subdev API */
> -	/** handler for resource release function */
> -	void (*release)(struct mxr_layer *);
> -	/** setting buffer to HW */
> -	void (*buffer_set)(struct mxr_layer *, struct mxr_buffer *);
> -	/** setting format and geometry in HW */
> -	void (*format_set)(struct mxr_layer *);
> -	/** streaming stop/start */
> -	void (*stream_set)(struct mxr_layer *, int);
> -	/** adjusting geometry */
> -	void (*fix_geometry)(struct mxr_layer *,
> -		enum mxr_geometry_stage, unsigned long);
> -};
> -
> -/** layer instance, a single window and content displayed on output */
> -struct mxr_layer {
> -	/** parent mixer device */
> -	struct mxr_device *mdev;
> -	/** layer index (unique identifier) */
> -	int idx;
> -	/** callbacks for layer methods */
> -	struct mxr_layer_ops ops;
> -	/** format array */
> -	const struct mxr_format **fmt_array;
> -	/** size of format array */
> -	unsigned long fmt_array_size;
> -
> -	/** lock for protection of list and state fields */
> -	spinlock_t enq_slock;
> -	/** list for enqueued buffers */
> -	struct list_head enq_list;
> -	/** buffer currently owned by hardware in temporary registers */
> -	struct mxr_buffer *update_buf;
> -	/** buffer currently owned by hardware in shadow registers */
> -	struct mxr_buffer *shadow_buf;
> -	/** state of layer IDLE/STREAMING */
> -	enum mxr_layer_state state;
> -
> -	/** mutex for protection of fields below */
> -	struct mutex mutex;
> -	/** handler for video node */
> -	struct video_device vfd;
> -	/** queue for output buffers */
> -	struct vb2_queue vb_queue;
> -	/** current image format */
> -	const struct mxr_format *fmt;
> -	/** current geometry of image */
> -	struct mxr_geometry geo;
> -};
> -
> -/** description of mixers output interface */
> -struct mxr_output {
> -	/** name of output */
> -	char name[32];
> -	/** output subdev */
> -	struct v4l2_subdev *sd;
> -	/** cookie used for configuration of registers */
> -	int cookie;
> -};
> -
> -/** specify source of output subdevs */
> -struct mxr_output_conf {
> -	/** name of output (connector) */
> -	char *output_name;
> -	/** name of module that generates output subdev */
> -	char *module_name;
> -	/** cookie need for mixer HW */
> -	int cookie;
> -};
> -
> -struct clk;
> -struct regulator;
> -
> -/** auxiliary resources used my mixer */
> -struct mxr_resources {
> -	/** interrupt index */
> -	int irq;
> -	/** pointer to Mixer registers */
> -	void __iomem *mxr_regs;
> -	/** pointer to Video Processor registers */
> -	void __iomem *vp_regs;
> -	/** other resources, should used under mxr_device.mutex */
> -	struct clk *mixer;
> -	struct clk *vp;
> -	struct clk *sclk_mixer;
> -	struct clk *sclk_hdmi;
> -	struct clk *sclk_dac;
> -};
> -
> -/* event flags used  */
> -enum mxr_devide_flags {
> -	MXR_EVENT_VSYNC = 0,
> -	MXR_EVENT_TOP = 1,
> -};
> -
> -/** drivers instance */
> -struct mxr_device {
> -	/** master device */
> -	struct device *dev;
> -	/** state of each layer */
> -	struct mxr_layer *layer[MXR_MAX_LAYERS];
> -	/** state of each output */
> -	struct mxr_output *output[MXR_MAX_OUTPUTS];
> -	/** number of registered outputs */
> -	int output_cnt;
> -
> -	/* video resources */
> -
> -	/** V4L2 device */
> -	struct v4l2_device v4l2_dev;
> -	/** event wait queue */
> -	wait_queue_head_t event_queue;
> -	/** state flags */
> -	unsigned long event_flags;
> -
> -	/** spinlock for protection of registers */
> -	spinlock_t reg_slock;
> -
> -	/** mutex for protection of fields below */
> -	struct mutex mutex;
> -	/** number of entities depndant on output configuration */
> -	int n_output;
> -	/** number of users that do streaming */
> -	int n_streamer;
> -	/** index of current output */
> -	int current_output;
> -	/** auxiliary resources used my mixer */
> -	struct mxr_resources res;
> -};
> -
> -/** transform device structure into mixer device */
> -static inline struct mxr_device *to_mdev(struct device *dev)
> -{
> -	struct v4l2_device *vdev = dev_get_drvdata(dev);
> -	return container_of(vdev, struct mxr_device, v4l2_dev);
> -}
> -
> -/** get current output data, should be called under mdev's mutex */
> -static inline struct mxr_output *to_output(struct mxr_device *mdev)
> -{
> -	return mdev->output[mdev->current_output];
> -}
> -
> -/** get current output subdev, should be called under mdev's mutex */
> -static inline struct v4l2_subdev *to_outsd(struct mxr_device *mdev)
> -{
> -	struct mxr_output *out = to_output(mdev);
> -	return out ? out->sd : NULL;
> -}
> -
> -/** forward declaration for mixer platform data */
> -struct mxr_platform_data;
> -
> -/** acquiring common video resources */
> -int mxr_acquire_video(struct mxr_device *mdev,
> -	struct mxr_output_conf *output_cont, int output_count);
> -
> -/** releasing common video resources */
> -void mxr_release_video(struct mxr_device *mdev);
> -
> -struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx);
> -struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx);
> -struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
> -	int idx, char *name, const struct mxr_layer_ops *ops);
> -
> -void mxr_base_layer_release(struct mxr_layer *layer);
> -void mxr_layer_release(struct mxr_layer *layer);
> -
> -int mxr_base_layer_register(struct mxr_layer *layer);
> -void mxr_base_layer_unregister(struct mxr_layer *layer);
> -
> -unsigned long mxr_get_plane_size(const struct mxr_block *blk,
> -	unsigned int width, unsigned int height);
> -
> -/** adds new consumer for mixer's power */
> -int __must_check mxr_power_get(struct mxr_device *mdev);
> -/** removes consumer for mixer's power */
> -void mxr_power_put(struct mxr_device *mdev);
> -/** add new client for output configuration */
> -void mxr_output_get(struct mxr_device *mdev);
> -/** removes new client for output configuration */
> -void mxr_output_put(struct mxr_device *mdev);
> -/** add new client for streaming */
> -void mxr_streamer_get(struct mxr_device *mdev);
> -/** removes new client for streaming */
> -void mxr_streamer_put(struct mxr_device *mdev);
> -/** returns format of data delivared to current output */
> -void mxr_get_mbus_fmt(struct mxr_device *mdev,
> -	struct v4l2_mbus_framefmt *mbus_fmt);
> -
> -/* Debug */
> -
> -#define mxr_err(mdev, fmt, ...)  dev_err(mdev->dev, fmt, ##__VA_ARGS__)
> -#define mxr_warn(mdev, fmt, ...) dev_warn(mdev->dev, fmt, ##__VA_ARGS__)
> -#define mxr_info(mdev, fmt, ...) dev_info(mdev->dev, fmt, ##__VA_ARGS__)
> -
> -#ifdef CONFIG_VIDEO_SAMSUNG_S5P_MIXER_DEBUG
> -	#define mxr_dbg(mdev, fmt, ...)  dev_dbg(mdev->dev, fmt, ##__VA_ARGS__)
> -#else
> -	#define mxr_dbg(mdev, fmt, ...)  do { (void) mdev; } while (0)
> -#endif
> -
> -/* accessing Mixer's and Video Processor's registers */
> -
> -void mxr_vsync_set_update(struct mxr_device *mdev, int en);
> -void mxr_reg_reset(struct mxr_device *mdev);
> -irqreturn_t mxr_irq_handler(int irq, void *dev_data);
> -void mxr_reg_s_output(struct mxr_device *mdev, int cookie);
> -void mxr_reg_streamon(struct mxr_device *mdev);
> -void mxr_reg_streamoff(struct mxr_device *mdev);
> -int mxr_reg_wait4vsync(struct mxr_device *mdev);
> -void mxr_reg_set_mbus_fmt(struct mxr_device *mdev,
> -	struct v4l2_mbus_framefmt *fmt);
> -void mxr_reg_graph_layer_stream(struct mxr_device *mdev, int idx, int en);
> -void mxr_reg_graph_buffer(struct mxr_device *mdev, int idx, dma_addr_t addr);
> -void mxr_reg_graph_format(struct mxr_device *mdev, int idx,
> -	const struct mxr_format *fmt, const struct mxr_geometry *geo);
> -
> -void mxr_reg_vp_layer_stream(struct mxr_device *mdev, int en);
> -void mxr_reg_vp_buffer(struct mxr_device *mdev,
> -	dma_addr_t luma_addr[2], dma_addr_t chroma_addr[2]);
> -void mxr_reg_vp_format(struct mxr_device *mdev,
> -	const struct mxr_format *fmt, const struct mxr_geometry *geo);
> -void mxr_reg_dump(struct mxr_device *mdev);
> -
> -#endif /* SAMSUNG_MIXER_H */
> -
> diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
> deleted file mode 100644
> index 8a5d194..0000000
> --- a/drivers/media/platform/s5p-tv/mixer_drv.c
> +++ /dev/null
> @@ -1,527 +0,0 @@
> -/*
> - * Samsung TV Mixer driver
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *
> - * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published
> - * by the Free Software Foundiation. either version 2 of the License,
> - * or (at your option) any later version
> - */
> -
> -#include "mixer.h"
> -
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/io.h>
> -#include <linux/interrupt.h>
> -#include <linux/irq.h>
> -#include <linux/fb.h>
> -#include <linux/delay.h>
> -#include <linux/pm_runtime.h>
> -#include <linux/clk.h>
> -
> -MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
> -MODULE_DESCRIPTION("Samsung MIXER");
> -MODULE_LICENSE("GPL");
> -
> -/* --------- DRIVER PARAMETERS ---------- */
> -
> -static struct mxr_output_conf mxr_output_conf[] = {
> -	{
> -		.output_name = "S5P HDMI connector",
> -		.module_name = "s5p-hdmi",
> -		.cookie = 1,
> -	},
> -	{
> -		.output_name = "S5P SDO connector",
> -		.module_name = "s5p-sdo",
> -		.cookie = 0,
> -	},
> -};
> -
> -void mxr_get_mbus_fmt(struct mxr_device *mdev,
> -	struct v4l2_mbus_framefmt *mbus_fmt)
> -{
> -	struct v4l2_subdev *sd;
> -	struct v4l2_subdev_format fmt = {
> -		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> -	};
> -	int ret;
> -
> -	mutex_lock(&mdev->mutex);
> -	sd = to_outsd(mdev);
> -	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
> -	*mbus_fmt = fmt.format;
> -	WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
> -	mutex_unlock(&mdev->mutex);
> -}
> -
> -void mxr_streamer_get(struct mxr_device *mdev)
> -{
> -	mutex_lock(&mdev->mutex);
> -	++mdev->n_streamer;
> -	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
> -	if (mdev->n_streamer == 1) {
> -		struct v4l2_subdev *sd = to_outsd(mdev);
> -		struct v4l2_subdev_format fmt = {
> -			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> -		};
> -		struct v4l2_mbus_framefmt *mbus_fmt = &fmt.format;
> -		struct mxr_resources *res = &mdev->res;
> -		int ret;
> -
> -		if (to_output(mdev)->cookie == 0)
> -			clk_set_parent(res->sclk_mixer, res->sclk_dac);
> -		else
> -			clk_set_parent(res->sclk_mixer, res->sclk_hdmi);
> -		mxr_reg_s_output(mdev, to_output(mdev)->cookie);
> -
> -		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
> -		WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
> -		ret = v4l2_subdev_call(sd, video, s_stream, 1);
> -		WARN(ret, "starting stream failed for output %s\n", sd->name);
> -
> -		mxr_reg_set_mbus_fmt(mdev, mbus_fmt);
> -		mxr_reg_streamon(mdev);
> -		ret = mxr_reg_wait4vsync(mdev);
> -		WARN(ret, "failed to get vsync (%d) from output\n", ret);
> -	}
> -	mutex_unlock(&mdev->mutex);
> -	mxr_reg_dump(mdev);
> -	/* FIXME: what to do when streaming fails? */
> -}
> -
> -void mxr_streamer_put(struct mxr_device *mdev)
> -{
> -	mutex_lock(&mdev->mutex);
> -	--mdev->n_streamer;
> -	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
> -	if (mdev->n_streamer == 0) {
> -		int ret;
> -		struct v4l2_subdev *sd = to_outsd(mdev);
> -
> -		mxr_reg_streamoff(mdev);
> -		/* vsync applies Mixer setup */
> -		ret = mxr_reg_wait4vsync(mdev);
> -		WARN(ret, "failed to get vsync (%d) from output\n", ret);
> -		ret = v4l2_subdev_call(sd, video, s_stream, 0);
> -		WARN(ret, "stopping stream failed for output %s\n", sd->name);
> -	}
> -	WARN(mdev->n_streamer < 0, "negative number of streamers (%d)\n",
> -		mdev->n_streamer);
> -	mutex_unlock(&mdev->mutex);
> -	mxr_reg_dump(mdev);
> -}
> -
> -void mxr_output_get(struct mxr_device *mdev)
> -{
> -	mutex_lock(&mdev->mutex);
> -	++mdev->n_output;
> -	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_output);
> -	/* turn on auxiliary driver */
> -	if (mdev->n_output == 1)
> -		v4l2_subdev_call(to_outsd(mdev), core, s_power, 1);
> -	mutex_unlock(&mdev->mutex);
> -}
> -
> -void mxr_output_put(struct mxr_device *mdev)
> -{
> -	mutex_lock(&mdev->mutex);
> -	--mdev->n_output;
> -	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_output);
> -	/* turn on auxiliary driver */
> -	if (mdev->n_output == 0)
> -		v4l2_subdev_call(to_outsd(mdev), core, s_power, 0);
> -	WARN(mdev->n_output < 0, "negative number of output users (%d)\n",
> -		mdev->n_output);
> -	mutex_unlock(&mdev->mutex);
> -}
> -
> -int mxr_power_get(struct mxr_device *mdev)
> -{
> -	int ret = pm_runtime_get_sync(mdev->dev);
> -
> -	/* returning 1 means that power is already enabled,
> -	 * so zero success be returned */
> -	if (ret < 0)
> -		return ret;
> -	return 0;
> -}
> -
> -void mxr_power_put(struct mxr_device *mdev)
> -{
> -	pm_runtime_put_sync(mdev->dev);
> -}
> -
> -/* --------- RESOURCE MANAGEMENT -------------*/
> -
> -static int mxr_acquire_plat_resources(struct mxr_device *mdev,
> -				      struct platform_device *pdev)
> -{
> -	struct resource *res;
> -	int ret;
> -
> -	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
> -	if (res == NULL) {
> -		mxr_err(mdev, "get memory resource failed.\n");
> -		ret = -ENXIO;
> -		goto fail;
> -	}
> -
> -	mdev->res.mxr_regs = ioremap(res->start, resource_size(res));
> -	if (mdev->res.mxr_regs == NULL) {
> -		mxr_err(mdev, "register mapping failed.\n");
> -		ret = -ENXIO;
> -		goto fail;
> -	}
> -
> -	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vp");
> -	if (res == NULL) {
> -		mxr_err(mdev, "get memory resource failed.\n");
> -		ret = -ENXIO;
> -		goto fail_mxr_regs;
> -	}
> -
> -	mdev->res.vp_regs = ioremap(res->start, resource_size(res));
> -	if (mdev->res.vp_regs == NULL) {
> -		mxr_err(mdev, "register mapping failed.\n");
> -		ret = -ENXIO;
> -		goto fail_mxr_regs;
> -	}
> -
> -	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "irq");
> -	if (res == NULL) {
> -		mxr_err(mdev, "get interrupt resource failed.\n");
> -		ret = -ENXIO;
> -		goto fail_vp_regs;
> -	}
> -
> -	ret = request_irq(res->start, mxr_irq_handler, 0, "s5p-mixer", mdev);
> -	if (ret) {
> -		mxr_err(mdev, "request interrupt failed.\n");
> -		goto fail_vp_regs;
> -	}
> -	mdev->res.irq = res->start;
> -
> -	return 0;
> -
> -fail_vp_regs:
> -	iounmap(mdev->res.vp_regs);
> -
> -fail_mxr_regs:
> -	iounmap(mdev->res.mxr_regs);
> -
> -fail:
> -	return ret;
> -}
> -
> -static void mxr_resource_clear_clocks(struct mxr_resources *res)
> -{
> -	res->mixer	= ERR_PTR(-EINVAL);
> -	res->vp		= ERR_PTR(-EINVAL);
> -	res->sclk_mixer	= ERR_PTR(-EINVAL);
> -	res->sclk_hdmi	= ERR_PTR(-EINVAL);
> -	res->sclk_dac	= ERR_PTR(-EINVAL);
> -}
> -
> -static void mxr_release_plat_resources(struct mxr_device *mdev)
> -{
> -	free_irq(mdev->res.irq, mdev);
> -	iounmap(mdev->res.vp_regs);
> -	iounmap(mdev->res.mxr_regs);
> -}
> -
> -static void mxr_release_clocks(struct mxr_device *mdev)
> -{
> -	struct mxr_resources *res = &mdev->res;
> -
> -	if (!IS_ERR(res->sclk_dac))
> -		clk_put(res->sclk_dac);
> -	if (!IS_ERR(res->sclk_hdmi))
> -		clk_put(res->sclk_hdmi);
> -	if (!IS_ERR(res->sclk_mixer))
> -		clk_put(res->sclk_mixer);
> -	if (!IS_ERR(res->vp))
> -		clk_put(res->vp);
> -	if (!IS_ERR(res->mixer))
> -		clk_put(res->mixer);
> -}
> -
> -static int mxr_acquire_clocks(struct mxr_device *mdev)
> -{
> -	struct mxr_resources *res = &mdev->res;
> -	struct device *dev = mdev->dev;
> -
> -	mxr_resource_clear_clocks(res);
> -
> -	res->mixer = clk_get(dev, "mixer");
> -	if (IS_ERR(res->mixer)) {
> -		mxr_err(mdev, "failed to get clock 'mixer'\n");
> -		goto fail;
> -	}
> -	res->vp = clk_get(dev, "vp");
> -	if (IS_ERR(res->vp)) {
> -		mxr_err(mdev, "failed to get clock 'vp'\n");
> -		goto fail;
> -	}
> -	res->sclk_mixer = clk_get(dev, "sclk_mixer");
> -	if (IS_ERR(res->sclk_mixer)) {
> -		mxr_err(mdev, "failed to get clock 'sclk_mixer'\n");
> -		goto fail;
> -	}
> -	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
> -	if (IS_ERR(res->sclk_hdmi)) {
> -		mxr_err(mdev, "failed to get clock 'sclk_hdmi'\n");
> -		goto fail;
> -	}
> -	res->sclk_dac = clk_get(dev, "sclk_dac");
> -	if (IS_ERR(res->sclk_dac)) {
> -		mxr_err(mdev, "failed to get clock 'sclk_dac'\n");
> -		goto fail;
> -	}
> -
> -	return 0;
> -fail:
> -	mxr_release_clocks(mdev);
> -	return -ENODEV;
> -}
> -
> -static int mxr_acquire_resources(struct mxr_device *mdev,
> -				 struct platform_device *pdev)
> -{
> -	int ret;
> -	ret = mxr_acquire_plat_resources(mdev, pdev);
> -
> -	if (ret)
> -		goto fail;
> -
> -	ret = mxr_acquire_clocks(mdev);
> -	if (ret)
> -		goto fail_plat;
> -
> -	mxr_info(mdev, "resources acquired\n");
> -	return 0;
> -
> -fail_plat:
> -	mxr_release_plat_resources(mdev);
> -fail:
> -	mxr_err(mdev, "resources acquire failed\n");
> -	return ret;
> -}
> -
> -static void mxr_release_resources(struct mxr_device *mdev)
> -{
> -	mxr_release_clocks(mdev);
> -	mxr_release_plat_resources(mdev);
> -	memset(&mdev->res, 0, sizeof(mdev->res));
> -	mxr_resource_clear_clocks(&mdev->res);
> -}
> -
> -static void mxr_release_layers(struct mxr_device *mdev)
> -{
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(mdev->layer); ++i)
> -		if (mdev->layer[i])
> -			mxr_layer_release(mdev->layer[i]);
> -}
> -
> -static int mxr_acquire_layers(struct mxr_device *mdev,
> -			      struct mxr_platform_data *pdata)
> -{
> -	mdev->layer[0] = mxr_graph_layer_create(mdev, 0);
> -	mdev->layer[1] = mxr_graph_layer_create(mdev, 1);
> -	mdev->layer[2] = mxr_vp_layer_create(mdev, 0);
> -
> -	if (!mdev->layer[0] || !mdev->layer[1] || !mdev->layer[2]) {
> -		mxr_err(mdev, "failed to acquire layers\n");
> -		goto fail;
> -	}
> -
> -	return 0;
> -
> -fail:
> -	mxr_release_layers(mdev);
> -	return -ENODEV;
> -}
> -
> -/* ---------- POWER MANAGEMENT ----------- */
> -
> -static int mxr_runtime_resume(struct device *dev)
> -{
> -	struct mxr_device *mdev = to_mdev(dev);
> -	struct mxr_resources *res = &mdev->res;
> -	int ret;
> -
> -	mxr_dbg(mdev, "resume - start\n");
> -	mutex_lock(&mdev->mutex);
> -	/* turn clocks on */
> -	ret = clk_prepare_enable(res->mixer);
> -	if (ret < 0) {
> -		dev_err(mdev->dev, "clk_prepare_enable(mixer) failed\n");
> -		goto fail;
> -	}
> -	ret = clk_prepare_enable(res->vp);
> -	if (ret < 0) {
> -		dev_err(mdev->dev, "clk_prepare_enable(vp) failed\n");
> -		goto fail_mixer;
> -	}
> -	ret = clk_prepare_enable(res->sclk_mixer);
> -	if (ret < 0) {
> -		dev_err(mdev->dev, "clk_prepare_enable(sclk_mixer) failed\n");
> -		goto fail_vp;
> -	}
> -	/* apply default configuration */
> -	mxr_reg_reset(mdev);
> -	mxr_dbg(mdev, "resume - finished\n");
> -
> -	mutex_unlock(&mdev->mutex);
> -	return 0;
> -
> -fail_vp:
> -	clk_disable_unprepare(res->vp);
> -fail_mixer:
> -	clk_disable_unprepare(res->mixer);
> -fail:
> -	mutex_unlock(&mdev->mutex);
> -	dev_err(mdev->dev, "resume failed\n");
> -	return ret;
> -}
> -
> -static int mxr_runtime_suspend(struct device *dev)
> -{
> -	struct mxr_device *mdev = to_mdev(dev);
> -	struct mxr_resources *res = &mdev->res;
> -	mxr_dbg(mdev, "suspend - start\n");
> -	mutex_lock(&mdev->mutex);
> -	/* turn clocks off */
> -	clk_disable_unprepare(res->sclk_mixer);
> -	clk_disable_unprepare(res->vp);
> -	clk_disable_unprepare(res->mixer);
> -	mutex_unlock(&mdev->mutex);
> -	mxr_dbg(mdev, "suspend - finished\n");
> -	return 0;
> -}
> -
> -static const struct dev_pm_ops mxr_pm_ops = {
> -	.runtime_suspend = mxr_runtime_suspend,
> -	.runtime_resume	 = mxr_runtime_resume,
> -};
> -
> -/* --------- DRIVER INITIALIZATION ---------- */
> -
> -static int mxr_probe(struct platform_device *pdev)
> -{
> -	struct device *dev = &pdev->dev;
> -	struct mxr_platform_data *pdata = dev->platform_data;
> -	struct mxr_device *mdev;
> -	int ret;
> -
> -	/* mdev does not exist yet so no mxr_dbg is used */
> -	dev_info(dev, "probe start\n");
> -
> -	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> -	if (!mdev) {
> -		dev_err(dev, "not enough memory.\n");
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> -
> -	/* setup pointer to master device */
> -	mdev->dev = dev;
> -
> -	mutex_init(&mdev->mutex);
> -	spin_lock_init(&mdev->reg_slock);
> -	init_waitqueue_head(&mdev->event_queue);
> -
> -	/* acquire resources: regs, irqs, clocks, regulators */
> -	ret = mxr_acquire_resources(mdev, pdev);
> -	if (ret)
> -		goto fail_mem;
> -
> -	/* configure resources for video output */
> -	ret = mxr_acquire_video(mdev, mxr_output_conf,
> -		ARRAY_SIZE(mxr_output_conf));
> -	if (ret)
> -		goto fail_resources;
> -
> -	/* configure layers */
> -	ret = mxr_acquire_layers(mdev, pdata);
> -	if (ret)
> -		goto fail_video;
> -
> -	pm_runtime_enable(dev);
> -
> -	mxr_info(mdev, "probe successful\n");
> -	return 0;
> -
> -fail_video:
> -	mxr_release_video(mdev);
> -
> -fail_resources:
> -	mxr_release_resources(mdev);
> -
> -fail_mem:
> -	kfree(mdev);
> -
> -fail:
> -	dev_info(dev, "probe failed\n");
> -	return ret;
> -}
> -
> -static int mxr_remove(struct platform_device *pdev)
> -{
> -	struct device *dev = &pdev->dev;
> -	struct mxr_device *mdev = to_mdev(dev);
> -
> -	pm_runtime_disable(dev);
> -
> -	mxr_release_layers(mdev);
> -	mxr_release_video(mdev);
> -	mxr_release_resources(mdev);
> -
> -	kfree(mdev);
> -
> -	dev_info(dev, "remove successful\n");
> -	return 0;
> -}
> -
> -static struct platform_driver mxr_driver __refdata = {
> -	.probe = mxr_probe,
> -	.remove = mxr_remove,
> -	.driver = {
> -		.name = MXR_DRIVER_NAME,
> -		.pm = &mxr_pm_ops,
> -	}
> -};
> -
> -static int __init mxr_init(void)
> -{
> -	int i, ret;
> -	static const char banner[] __initconst =
> -		"Samsung TV Mixer driver, "
> -		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
> -	pr_info("%s\n", banner);
> -
> -	/* Loading auxiliary modules */
> -	for (i = 0; i < ARRAY_SIZE(mxr_output_conf); ++i)
> -		request_module(mxr_output_conf[i].module_name);
> -
> -	ret = platform_driver_register(&mxr_driver);
> -	if (ret != 0) {
> -		pr_err("s5p-tv: registration of MIXER driver failed\n");
> -		return -ENXIO;
> -	}
> -
> -	return 0;
> -}
> -module_init(mxr_init);
> -
> -static void __exit mxr_exit(void)
> -{
> -	platform_driver_unregister(&mxr_driver);
> -}
> -module_exit(mxr_exit);
> diff --git a/drivers/media/platform/s5p-tv/mixer_grp_layer.c b/drivers/media/platform/s5p-tv/mixer_grp_layer.c
> deleted file mode 100644
> index d4d2564..0000000
> --- a/drivers/media/platform/s5p-tv/mixer_grp_layer.c
> +++ /dev/null
> @@ -1,270 +0,0 @@
> -/*
> - * Samsung TV Mixer driver
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *
> - * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published
> - * by the Free Software Foundiation. either version 2 of the License,
> - * or (at your option) any later version
> - */
> -
> -#include "mixer.h"
> -
> -#include <media/videobuf2-dma-contig.h>
> -
> -/* FORMAT DEFINITIONS */
> -
> -static const struct mxr_format mxr_fb_fmt_rgb565 = {
> -	.name = "RGB565",
> -	.fourcc = V4L2_PIX_FMT_RGB565,
> -	.colorspace = V4L2_COLORSPACE_SRGB,
> -	.num_planes = 1,
> -	.plane = {
> -		{ .width = 1, .height = 1, .size = 2 },
> -	},
> -	.num_subframes = 1,
> -	.cookie = 4,
> -};
> -
> -static const struct mxr_format mxr_fb_fmt_argb1555 = {
> -	.name = "ARGB1555",
> -	.num_planes = 1,
> -	.fourcc = V4L2_PIX_FMT_RGB555,
> -	.colorspace = V4L2_COLORSPACE_SRGB,
> -	.plane = {
> -		{ .width = 1, .height = 1, .size = 2 },
> -	},
> -	.num_subframes = 1,
> -	.cookie = 5,
> -};
> -
> -static const struct mxr_format mxr_fb_fmt_argb4444 = {
> -	.name = "ARGB4444",
> -	.num_planes = 1,
> -	.fourcc = V4L2_PIX_FMT_RGB444,
> -	.colorspace = V4L2_COLORSPACE_SRGB,
> -	.plane = {
> -		{ .width = 1, .height = 1, .size = 2 },
> -	},
> -	.num_subframes = 1,
> -	.cookie = 6,
> -};
> -
> -static const struct mxr_format mxr_fb_fmt_argb8888 = {
> -	.name = "ARGB8888",
> -	.fourcc = V4L2_PIX_FMT_BGR32,
> -	.colorspace = V4L2_COLORSPACE_SRGB,
> -	.num_planes = 1,
> -	.plane = {
> -		{ .width = 1, .height = 1, .size = 4 },
> -	},
> -	.num_subframes = 1,
> -	.cookie = 7,
> -};
> -
> -static const struct mxr_format *mxr_graph_format[] = {
> -	&mxr_fb_fmt_rgb565,
> -	&mxr_fb_fmt_argb1555,
> -	&mxr_fb_fmt_argb4444,
> -	&mxr_fb_fmt_argb8888,
> -};
> -
> -/* AUXILIARY CALLBACKS */
> -
> -static void mxr_graph_layer_release(struct mxr_layer *layer)
> -{
> -	mxr_base_layer_unregister(layer);
> -	mxr_base_layer_release(layer);
> -}
> -
> -static void mxr_graph_buffer_set(struct mxr_layer *layer,
> -	struct mxr_buffer *buf)
> -{
> -	dma_addr_t addr = 0;
> -
> -	if (buf)
> -		addr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
> -	mxr_reg_graph_buffer(layer->mdev, layer->idx, addr);
> -}
> -
> -static void mxr_graph_stream_set(struct mxr_layer *layer, int en)
> -{
> -	mxr_reg_graph_layer_stream(layer->mdev, layer->idx, en);
> -}
> -
> -static void mxr_graph_format_set(struct mxr_layer *layer)
> -{
> -	mxr_reg_graph_format(layer->mdev, layer->idx,
> -		layer->fmt, &layer->geo);
> -}
> -
> -static inline unsigned int closest(unsigned int x, unsigned int a,
> -	unsigned int b, unsigned long flags)
> -{
> -	unsigned int mid = (a + b) / 2;
> -
> -	/* choosing closest value with constraints according to table:
> -	 * -------------+-----+-----+-----+-------+
> -	 * flags	|  0  |  LE |  GE | LE|GE |
> -	 * -------------+-----+-----+-----+-------+
> -	 * x <= a	|  a  |  a  |  a  |   a   |
> -	 * a < x <= mid	|  a  |  a  |  b  |   a   |
> -	 * mid < x < b	|  b  |  a  |  b  |   b   |
> -	 * b <= x	|  b  |  b  |  b  |   b   |
> -	 * -------------+-----+-----+-----+-------+
> -	 */
> -
> -	/* remove all non-constraint flags */
> -	flags &= V4L2_SEL_FLAG_LE | V4L2_SEL_FLAG_GE;
> -
> -	if (x <= a)
> -		return  a;
> -	if (x >= b)
> -		return b;
> -	if (flags == V4L2_SEL_FLAG_LE)
> -		return a;
> -	if (flags == V4L2_SEL_FLAG_GE)
> -		return b;
> -	if (x <= mid)
> -		return a;
> -	return b;
> -}
> -
> -static inline unsigned int do_center(unsigned int center,
> -	unsigned int size, unsigned int upper, unsigned int flags)
> -{
> -	unsigned int lower;
> -
> -	if (flags & MXR_NO_OFFSET)
> -		return 0;
> -
> -	lower = center - min(center, size / 2);
> -	return min(lower, upper - size);
> -}
> -
> -static void mxr_graph_fix_geometry(struct mxr_layer *layer,
> -	enum mxr_geometry_stage stage, unsigned long flags)
> -{
> -	struct mxr_geometry *geo = &layer->geo;
> -	struct mxr_crop *src = &geo->src;
> -	struct mxr_crop *dst = &geo->dst;
> -	unsigned int x_center, y_center;
> -
> -	switch (stage) {
> -
> -	case MXR_GEOMETRY_SINK: /* nothing to be fixed here */
> -		flags = 0;
> -		/* fall through */
> -
> -	case MXR_GEOMETRY_COMPOSE:
> -		/* remember center of the area */
> -		x_center = dst->x_offset + dst->width / 2;
> -		y_center = dst->y_offset + dst->height / 2;
> -		/* round up/down to 2 multiple depending on flags */
> -		if (flags & V4L2_SEL_FLAG_LE) {
> -			dst->width = round_down(dst->width, 2);
> -			dst->height = round_down(dst->height, 2);
> -		} else {
> -			dst->width = round_up(dst->width, 2);
> -			dst->height = round_up(dst->height, 2);
> -		}
> -		/* assure that compose rect is inside display area */
> -		dst->width = min(dst->width, dst->full_width);
> -		dst->height = min(dst->height, dst->full_height);
> -
> -		/* ensure that compose is reachable using 2x scaling */
> -		dst->width = min(dst->width, 2 * src->full_width);
> -		dst->height = min(dst->height, 2 * src->full_height);
> -
> -		/* setup offsets */
> -		dst->x_offset = do_center(x_center, dst->width,
> -			dst->full_width, flags);
> -		dst->y_offset = do_center(y_center, dst->height,
> -			dst->full_height, flags);
> -		flags = 0;
> -		/* fall through */
> -
> -	case MXR_GEOMETRY_CROP:
> -		/* remember center of the area */
> -		x_center = src->x_offset + src->width / 2;
> -		y_center = src->y_offset + src->height / 2;
> -		/* ensure that cropping area lies inside the buffer */
> -		if (src->full_width < dst->width)
> -			src->width = dst->width / 2;
> -		else
> -			src->width = closest(src->width, dst->width / 2,
> -				dst->width, flags);
> -
> -		if (src->width == dst->width)
> -			geo->x_ratio = 0;
> -		else
> -			geo->x_ratio = 1;
> -
> -		if (src->full_height < dst->height)
> -			src->height = dst->height / 2;
> -		else
> -			src->height = closest(src->height, dst->height / 2,
> -				dst->height, flags);
> -
> -		if (src->height == dst->height)
> -			geo->y_ratio = 0;
> -		else
> -			geo->y_ratio = 1;
> -
> -		/* setup offsets */
> -		src->x_offset = do_center(x_center, src->width,
> -			src->full_width, flags);
> -		src->y_offset = do_center(y_center, src->height,
> -			src->full_height, flags);
> -		flags = 0;
> -		/* fall through */
> -	case MXR_GEOMETRY_SOURCE:
> -		src->full_width = clamp_val(src->full_width,
> -			src->width + src->x_offset, 32767);
> -		src->full_height = clamp_val(src->full_height,
> -			src->height + src->y_offset, 2047);
> -	}
> -}
> -
> -/* PUBLIC API */
> -
> -struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx)
> -{
> -	struct mxr_layer *layer;
> -	int ret;
> -	const struct mxr_layer_ops ops = {
> -		.release = mxr_graph_layer_release,
> -		.buffer_set = mxr_graph_buffer_set,
> -		.stream_set = mxr_graph_stream_set,
> -		.format_set = mxr_graph_format_set,
> -		.fix_geometry = mxr_graph_fix_geometry,
> -	};
> -	char name[32];
> -
> -	sprintf(name, "graph%d", idx);
> -
> -	layer = mxr_base_layer_create(mdev, idx, name, &ops);
> -	if (layer == NULL) {
> -		mxr_err(mdev, "failed to initialize layer(%d) base\n", idx);
> -		goto fail;
> -	}
> -
> -	layer->fmt_array = mxr_graph_format;
> -	layer->fmt_array_size = ARRAY_SIZE(mxr_graph_format);
> -
> -	ret = mxr_base_layer_register(layer);
> -	if (ret)
> -		goto fail_layer;
> -
> -	return layer;
> -
> -fail_layer:
> -	mxr_base_layer_release(layer);
> -
> -fail:
> -	return NULL;
> -}
> -
> diff --git a/drivers/media/platform/s5p-tv/mixer_reg.c b/drivers/media/platform/s5p-tv/mixer_reg.c
> deleted file mode 100644
> index a0ec14a..0000000
> --- a/drivers/media/platform/s5p-tv/mixer_reg.c
> +++ /dev/null
> @@ -1,551 +0,0 @@
> -/*
> - * Samsung TV Mixer driver
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *
> - * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published
> - * by the Free Software Foundiation. either version 2 of the License,
> - * or (at your option) any later version
> - */
> -
> -#include "mixer.h"
> -#include "regs-mixer.h"
> -#include "regs-vp.h"
> -
> -#include <linux/delay.h>
> -
> -/* Register access subroutines */
> -
> -static inline u32 vp_read(struct mxr_device *mdev, u32 reg_id)
> -{
> -	return readl(mdev->res.vp_regs + reg_id);
> -}
> -
> -static inline void vp_write(struct mxr_device *mdev, u32 reg_id, u32 val)
> -{
> -	writel(val, mdev->res.vp_regs + reg_id);
> -}
> -
> -static inline void vp_write_mask(struct mxr_device *mdev, u32 reg_id,
> -	u32 val, u32 mask)
> -{
> -	u32 old = vp_read(mdev, reg_id);
> -
> -	val = (val & mask) | (old & ~mask);
> -	writel(val, mdev->res.vp_regs + reg_id);
> -}
> -
> -static inline u32 mxr_read(struct mxr_device *mdev, u32 reg_id)
> -{
> -	return readl(mdev->res.mxr_regs + reg_id);
> -}
> -
> -static inline void mxr_write(struct mxr_device *mdev, u32 reg_id, u32 val)
> -{
> -	writel(val, mdev->res.mxr_regs + reg_id);
> -}
> -
> -static inline void mxr_write_mask(struct mxr_device *mdev, u32 reg_id,
> -	u32 val, u32 mask)
> -{
> -	u32 old = mxr_read(mdev, reg_id);
> -
> -	val = (val & mask) | (old & ~mask);
> -	writel(val, mdev->res.mxr_regs + reg_id);
> -}
> -
> -void mxr_vsync_set_update(struct mxr_device *mdev, int en)
> -{
> -	/* block update on vsync */
> -	mxr_write_mask(mdev, MXR_STATUS, en ? MXR_STATUS_SYNC_ENABLE : 0,
> -		MXR_STATUS_SYNC_ENABLE);
> -	vp_write(mdev, VP_SHADOW_UPDATE, en ? VP_SHADOW_UPDATE_ENABLE : 0);
> -}
> -
> -static void __mxr_reg_vp_reset(struct mxr_device *mdev)
> -{
> -	int tries = 100;
> -
> -	vp_write(mdev, VP_SRESET, VP_SRESET_PROCESSING);
> -	for (tries = 100; tries; --tries) {
> -		/* waiting until VP_SRESET_PROCESSING is 0 */
> -		if (~vp_read(mdev, VP_SRESET) & VP_SRESET_PROCESSING)
> -			break;
> -		mdelay(10);
> -	}
> -	WARN(tries == 0, "failed to reset Video Processor\n");
> -}
> -
> -static void mxr_reg_vp_default_filter(struct mxr_device *mdev);
> -
> -void mxr_reg_reset(struct mxr_device *mdev)
> -{
> -	unsigned long flags;
> -	u32 val; /* value stored to register */
> -
> -	spin_lock_irqsave(&mdev->reg_slock, flags);
> -	mxr_vsync_set_update(mdev, MXR_DISABLE);
> -
> -	/* set output in RGB888 mode */
> -	mxr_write(mdev, MXR_CFG, MXR_CFG_OUT_RGB888);
> -
> -	/* 16 beat burst in DMA */
> -	mxr_write_mask(mdev, MXR_STATUS, MXR_STATUS_16_BURST,
> -		MXR_STATUS_BURST_MASK);
> -
> -	/* setting default layer priority: layer1 > video > layer0
> -	 * because typical usage scenario would be
> -	 * layer0 - framebuffer
> -	 * video - video overlay
> -	 * layer1 - OSD
> -	 */
> -	val  = MXR_LAYER_CFG_GRP0_VAL(1);
> -	val |= MXR_LAYER_CFG_VP_VAL(2);
> -	val |= MXR_LAYER_CFG_GRP1_VAL(3);
> -	mxr_write(mdev, MXR_LAYER_CFG, val);
> -
> -	/* use dark gray background color */
> -	mxr_write(mdev, MXR_BG_COLOR0, 0x808080);
> -	mxr_write(mdev, MXR_BG_COLOR1, 0x808080);
> -	mxr_write(mdev, MXR_BG_COLOR2, 0x808080);
> -
> -	/* setting graphical layers */
> -
> -	val  = MXR_GRP_CFG_COLOR_KEY_DISABLE; /* no blank key */
> -	val |= MXR_GRP_CFG_BLEND_PRE_MUL; /* premul mode */
> -	val |= MXR_GRP_CFG_ALPHA_VAL(0xff); /* non-transparent alpha */
> -
> -	/* the same configuration for both layers */
> -	mxr_write(mdev, MXR_GRAPHIC_CFG(0), val);
> -	mxr_write(mdev, MXR_GRAPHIC_CFG(1), val);
> -
> -	/* configuration of Video Processor Registers */
> -	__mxr_reg_vp_reset(mdev);
> -	mxr_reg_vp_default_filter(mdev);
> -
> -	/* enable all interrupts */
> -	mxr_write_mask(mdev, MXR_INT_EN, ~0, MXR_INT_EN_ALL);
> -
> -	mxr_vsync_set_update(mdev, MXR_ENABLE);
> -	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> -}
> -
> -void mxr_reg_graph_format(struct mxr_device *mdev, int idx,
> -	const struct mxr_format *fmt, const struct mxr_geometry *geo)
> -{
> -	u32 val;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&mdev->reg_slock, flags);
> -	mxr_vsync_set_update(mdev, MXR_DISABLE);
> -
> -	/* setup format */
> -	mxr_write_mask(mdev, MXR_GRAPHIC_CFG(idx),
> -		MXR_GRP_CFG_FORMAT_VAL(fmt->cookie), MXR_GRP_CFG_FORMAT_MASK);
> -
> -	/* setup geometry */
> -	mxr_write(mdev, MXR_GRAPHIC_SPAN(idx), geo->src.full_width);
> -	val  = MXR_GRP_WH_WIDTH(geo->src.width);
> -	val |= MXR_GRP_WH_HEIGHT(geo->src.height);
> -	val |= MXR_GRP_WH_H_SCALE(geo->x_ratio);
> -	val |= MXR_GRP_WH_V_SCALE(geo->y_ratio);
> -	mxr_write(mdev, MXR_GRAPHIC_WH(idx), val);
> -
> -	/* setup offsets in source image */
> -	val  = MXR_GRP_SXY_SX(geo->src.x_offset);
> -	val |= MXR_GRP_SXY_SY(geo->src.y_offset);
> -	mxr_write(mdev, MXR_GRAPHIC_SXY(idx), val);
> -
> -	/* setup offsets in display image */
> -	val  = MXR_GRP_DXY_DX(geo->dst.x_offset);
> -	val |= MXR_GRP_DXY_DY(geo->dst.y_offset);
> -	mxr_write(mdev, MXR_GRAPHIC_DXY(idx), val);
> -
> -	mxr_vsync_set_update(mdev, MXR_ENABLE);
> -	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> -}
> -
> -void mxr_reg_vp_format(struct mxr_device *mdev,
> -	const struct mxr_format *fmt, const struct mxr_geometry *geo)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&mdev->reg_slock, flags);
> -	mxr_vsync_set_update(mdev, MXR_DISABLE);
> -
> -	vp_write_mask(mdev, VP_MODE, fmt->cookie, VP_MODE_FMT_MASK);
> -
> -	/* setting size of input image */
> -	vp_write(mdev, VP_IMG_SIZE_Y, VP_IMG_HSIZE(geo->src.full_width) |
> -		VP_IMG_VSIZE(geo->src.full_height));
> -	/* chroma height has to reduced by 2 to avoid chroma distorions */
> -	vp_write(mdev, VP_IMG_SIZE_C, VP_IMG_HSIZE(geo->src.full_width) |
> -		VP_IMG_VSIZE(geo->src.full_height / 2));
> -
> -	vp_write(mdev, VP_SRC_WIDTH, geo->src.width);
> -	vp_write(mdev, VP_SRC_HEIGHT, geo->src.height);
> -	vp_write(mdev, VP_SRC_H_POSITION,
> -		VP_SRC_H_POSITION_VAL(geo->src.x_offset));
> -	vp_write(mdev, VP_SRC_V_POSITION, geo->src.y_offset);
> -
> -	vp_write(mdev, VP_DST_WIDTH, geo->dst.width);
> -	vp_write(mdev, VP_DST_H_POSITION, geo->dst.x_offset);
> -	if (geo->dst.field == V4L2_FIELD_INTERLACED) {
> -		vp_write(mdev, VP_DST_HEIGHT, geo->dst.height / 2);
> -		vp_write(mdev, VP_DST_V_POSITION, geo->dst.y_offset / 2);
> -	} else {
> -		vp_write(mdev, VP_DST_HEIGHT, geo->dst.height);
> -		vp_write(mdev, VP_DST_V_POSITION, geo->dst.y_offset);
> -	}
> -
> -	vp_write(mdev, VP_H_RATIO, geo->x_ratio);
> -	vp_write(mdev, VP_V_RATIO, geo->y_ratio);
> -
> -	vp_write(mdev, VP_ENDIAN_MODE, VP_ENDIAN_MODE_LITTLE);
> -
> -	mxr_vsync_set_update(mdev, MXR_ENABLE);
> -	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> -
> -}
> -
> -void mxr_reg_graph_buffer(struct mxr_device *mdev, int idx, dma_addr_t addr)
> -{
> -	u32 val = addr ? ~0 : 0;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&mdev->reg_slock, flags);
> -	mxr_vsync_set_update(mdev, MXR_DISABLE);
> -
> -	if (idx == 0)
> -		mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_GRP0_ENABLE);
> -	else
> -		mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_GRP1_ENABLE);
> -	mxr_write(mdev, MXR_GRAPHIC_BASE(idx), addr);
> -
> -	mxr_vsync_set_update(mdev, MXR_ENABLE);
> -	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> -}
> -
> -void mxr_reg_vp_buffer(struct mxr_device *mdev,
> -	dma_addr_t luma_addr[2], dma_addr_t chroma_addr[2])
> -{
> -	u32 val = luma_addr[0] ? ~0 : 0;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&mdev->reg_slock, flags);
> -	mxr_vsync_set_update(mdev, MXR_DISABLE);
> -
> -	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_VP_ENABLE);
> -	vp_write_mask(mdev, VP_ENABLE, val, VP_ENABLE_ON);
> -	/* TODO: fix tiled mode */
> -	vp_write(mdev, VP_TOP_Y_PTR, luma_addr[0]);
> -	vp_write(mdev, VP_TOP_C_PTR, chroma_addr[0]);
> -	vp_write(mdev, VP_BOT_Y_PTR, luma_addr[1]);
> -	vp_write(mdev, VP_BOT_C_PTR, chroma_addr[1]);
> -
> -	mxr_vsync_set_update(mdev, MXR_ENABLE);
> -	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> -}
> -
> -static void mxr_irq_layer_handle(struct mxr_layer *layer)
> -{
> -	struct list_head *head = &layer->enq_list;
> -	struct mxr_buffer *done;
> -
> -	/* skip non-existing layer */
> -	if (layer == NULL)
> -		return;
> -
> -	spin_lock(&layer->enq_slock);
> -	if (layer->state == MXR_LAYER_IDLE)
> -		goto done;
> -
> -	done = layer->shadow_buf;
> -	layer->shadow_buf = layer->update_buf;
> -
> -	if (list_empty(head)) {
> -		if (layer->state != MXR_LAYER_STREAMING)
> -			layer->update_buf = NULL;
> -	} else {
> -		struct mxr_buffer *next;
> -		next = list_first_entry(head, struct mxr_buffer, list);
> -		list_del(&next->list);
> -		layer->update_buf = next;
> -	}
> -
> -	layer->ops.buffer_set(layer, layer->update_buf);
> -
> -	if (done && done != layer->shadow_buf)
> -		vb2_buffer_done(&done->vb.vb2_buf, VB2_BUF_STATE_DONE);
> -
> -done:
> -	spin_unlock(&layer->enq_slock);
> -}
> -
> -irqreturn_t mxr_irq_handler(int irq, void *dev_data)
> -{
> -	struct mxr_device *mdev = dev_data;
> -	u32 i, val;
> -
> -	spin_lock(&mdev->reg_slock);
> -	val = mxr_read(mdev, MXR_INT_STATUS);
> -
> -	/* wake up process waiting for VSYNC */
> -	if (val & MXR_INT_STATUS_VSYNC) {
> -		set_bit(MXR_EVENT_VSYNC, &mdev->event_flags);
> -		/* toggle TOP field event if working in interlaced mode */
> -		if (~mxr_read(mdev, MXR_CFG) & MXR_CFG_SCAN_PROGRASSIVE)
> -			change_bit(MXR_EVENT_TOP, &mdev->event_flags);
> -		wake_up(&mdev->event_queue);
> -		/* vsync interrupt use different bit for read and clear */
> -		val &= ~MXR_INT_STATUS_VSYNC;
> -		val |= MXR_INT_CLEAR_VSYNC;
> -	}
> -
> -	/* clear interrupts */
> -	mxr_write(mdev, MXR_INT_STATUS, val);
> -
> -	spin_unlock(&mdev->reg_slock);
> -	/* leave on non-vsync event */
> -	if (~val & MXR_INT_CLEAR_VSYNC)
> -		return IRQ_HANDLED;
> -	/* skip layer update on bottom field */
> -	if (!test_bit(MXR_EVENT_TOP, &mdev->event_flags))
> -		return IRQ_HANDLED;
> -	for (i = 0; i < MXR_MAX_LAYERS; ++i)
> -		mxr_irq_layer_handle(mdev->layer[i]);
> -	return IRQ_HANDLED;
> -}
> -
> -void mxr_reg_s_output(struct mxr_device *mdev, int cookie)
> -{
> -	u32 val;
> -
> -	val = cookie == 0 ? MXR_CFG_DST_SDO : MXR_CFG_DST_HDMI;
> -	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_DST_MASK);
> -}
> -
> -void mxr_reg_streamon(struct mxr_device *mdev)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&mdev->reg_slock, flags);
> -	/* single write -> no need to block vsync update */
> -
> -	/* start MIXER */
> -	mxr_write_mask(mdev, MXR_STATUS, ~0, MXR_STATUS_REG_RUN);
> -	set_bit(MXR_EVENT_TOP, &mdev->event_flags);
> -
> -	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> -}
> -
> -void mxr_reg_streamoff(struct mxr_device *mdev)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&mdev->reg_slock, flags);
> -	/* single write -> no need to block vsync update */
> -
> -	/* stop MIXER */
> -	mxr_write_mask(mdev, MXR_STATUS, 0, MXR_STATUS_REG_RUN);
> -
> -	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> -}
> -
> -int mxr_reg_wait4vsync(struct mxr_device *mdev)
> -{
> -	long time_left;
> -
> -	clear_bit(MXR_EVENT_VSYNC, &mdev->event_flags);
> -	/* TODO: consider adding interruptible */
> -	time_left = wait_event_timeout(mdev->event_queue,
> -			test_bit(MXR_EVENT_VSYNC, &mdev->event_flags),
> -				 msecs_to_jiffies(1000));
> -	if (time_left > 0)
> -		return 0;
> -	mxr_warn(mdev, "no vsync detected - timeout\n");
> -	return -ETIME;
> -}
> -
> -void mxr_reg_set_mbus_fmt(struct mxr_device *mdev,
> -	struct v4l2_mbus_framefmt *fmt)
> -{
> -	u32 val = 0;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&mdev->reg_slock, flags);
> -	mxr_vsync_set_update(mdev, MXR_DISABLE);
> -
> -	/* selecting colorspace accepted by output */
> -	if (fmt->colorspace == V4L2_COLORSPACE_JPEG)
> -		val |= MXR_CFG_OUT_YUV444;
> -	else
> -		val |= MXR_CFG_OUT_RGB888;
> -
> -	/* choosing between interlace and progressive mode */
> -	if (fmt->field == V4L2_FIELD_INTERLACED)
> -		val |= MXR_CFG_SCAN_INTERLACE;
> -	else
> -		val |= MXR_CFG_SCAN_PROGRASSIVE;
> -
> -	/* choosing between porper HD and SD mode */
> -	if (fmt->height == 480)
> -		val |= MXR_CFG_SCAN_NTSC | MXR_CFG_SCAN_SD;
> -	else if (fmt->height == 576)
> -		val |= MXR_CFG_SCAN_PAL | MXR_CFG_SCAN_SD;
> -	else if (fmt->height == 720)
> -		val |= MXR_CFG_SCAN_HD_720 | MXR_CFG_SCAN_HD;
> -	else if (fmt->height == 1080)
> -		val |= MXR_CFG_SCAN_HD_1080 | MXR_CFG_SCAN_HD;
> -	else
> -		WARN(1, "unrecognized mbus height %u!\n", fmt->height);
> -
> -	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_SCAN_MASK |
> -		MXR_CFG_OUT_MASK);
> -
> -	val = (fmt->field == V4L2_FIELD_INTERLACED) ? ~0 : 0;
> -	vp_write_mask(mdev, VP_MODE, val,
> -		VP_MODE_LINE_SKIP | VP_MODE_FIELD_ID_AUTO_TOGGLING);
> -
> -	mxr_vsync_set_update(mdev, MXR_ENABLE);
> -	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> -}
> -
> -void mxr_reg_graph_layer_stream(struct mxr_device *mdev, int idx, int en)
> -{
> -	/* no extra actions need to be done */
> -}
> -
> -void mxr_reg_vp_layer_stream(struct mxr_device *mdev, int en)
> -{
> -	/* no extra actions need to be done */
> -}
> -
> -static const u8 filter_y_horiz_tap8[] = {
> -	0,	-1,	-1,	-1,	-1,	-1,	-1,	-1,
> -	-1,	-1,	-1,	-1,	-1,	0,	0,	0,
> -	0,	2,	4,	5,	6,	6,	6,	6,
> -	6,	5,	5,	4,	3,	2,	1,	1,
> -	0,	-6,	-12,	-16,	-18,	-20,	-21,	-20,
> -	-20,	-18,	-16,	-13,	-10,	-8,	-5,	-2,
> -	127,	126,	125,	121,	114,	107,	99,	89,
> -	79,	68,	57,	46,	35,	25,	16,	8,
> -};
> -
> -static const u8 filter_y_vert_tap4[] = {
> -	0,	-3,	-6,	-8,	-8,	-8,	-8,	-7,
> -	-6,	-5,	-4,	-3,	-2,	-1,	-1,	0,
> -	127,	126,	124,	118,	111,	102,	92,	81,
> -	70,	59,	48,	37,	27,	19,	11,	5,
> -	0,	5,	11,	19,	27,	37,	48,	59,
> -	70,	81,	92,	102,	111,	118,	124,	126,
> -	0,	0,	-1,	-1,	-2,	-3,	-4,	-5,
> -	-6,	-7,	-8,	-8,	-8,	-8,	-6,	-3,
> -};
> -
> -static const u8 filter_cr_horiz_tap4[] = {
> -	0,	-3,	-6,	-8,	-8,	-8,	-8,	-7,
> -	-6,	-5,	-4,	-3,	-2,	-1,	-1,	0,
> -	127,	126,	124,	118,	111,	102,	92,	81,
> -	70,	59,	48,	37,	27,	19,	11,	5,
> -};
> -
> -static inline void mxr_reg_vp_filter_set(struct mxr_device *mdev,
> -	int reg_id, const u8 *data, unsigned int size)
> -{
> -	/* assure 4-byte align */
> -	BUG_ON(size & 3);
> -	for (; size; size -= 4, reg_id += 4, data += 4) {
> -		u32 val = (data[0] << 24) |  (data[1] << 16) |
> -			(data[2] << 8) | data[3];
> -		vp_write(mdev, reg_id, val);
> -	}
> -}
> -
> -static void mxr_reg_vp_default_filter(struct mxr_device *mdev)
> -{
> -	mxr_reg_vp_filter_set(mdev, VP_POLY8_Y0_LL,
> -		filter_y_horiz_tap8, sizeof(filter_y_horiz_tap8));
> -	mxr_reg_vp_filter_set(mdev, VP_POLY4_Y0_LL,
> -		filter_y_vert_tap4, sizeof(filter_y_vert_tap4));
> -	mxr_reg_vp_filter_set(mdev, VP_POLY4_C0_LL,
> -		filter_cr_horiz_tap4, sizeof(filter_cr_horiz_tap4));
> -}
> -
> -static void mxr_reg_mxr_dump(struct mxr_device *mdev)
> -{
> -#define DUMPREG(reg_id) \
> -do { \
> -	mxr_dbg(mdev, #reg_id " = %08x\n", \
> -		(u32)readl(mdev->res.mxr_regs + reg_id)); \
> -} while (0)
> -
> -	DUMPREG(MXR_STATUS);
> -	DUMPREG(MXR_CFG);
> -	DUMPREG(MXR_INT_EN);
> -	DUMPREG(MXR_INT_STATUS);
> -
> -	DUMPREG(MXR_LAYER_CFG);
> -	DUMPREG(MXR_VIDEO_CFG);
> -
> -	DUMPREG(MXR_GRAPHIC0_CFG);
> -	DUMPREG(MXR_GRAPHIC0_BASE);
> -	DUMPREG(MXR_GRAPHIC0_SPAN);
> -	DUMPREG(MXR_GRAPHIC0_WH);
> -	DUMPREG(MXR_GRAPHIC0_SXY);
> -	DUMPREG(MXR_GRAPHIC0_DXY);
> -
> -	DUMPREG(MXR_GRAPHIC1_CFG);
> -	DUMPREG(MXR_GRAPHIC1_BASE);
> -	DUMPREG(MXR_GRAPHIC1_SPAN);
> -	DUMPREG(MXR_GRAPHIC1_WH);
> -	DUMPREG(MXR_GRAPHIC1_SXY);
> -	DUMPREG(MXR_GRAPHIC1_DXY);
> -#undef DUMPREG
> -}
> -
> -static void mxr_reg_vp_dump(struct mxr_device *mdev)
> -{
> -#define DUMPREG(reg_id) \
> -do { \
> -	mxr_dbg(mdev, #reg_id " = %08x\n", \
> -		(u32) readl(mdev->res.vp_regs + reg_id)); \
> -} while (0)
> -
> -
> -	DUMPREG(VP_ENABLE);
> -	DUMPREG(VP_SRESET);
> -	DUMPREG(VP_SHADOW_UPDATE);
> -	DUMPREG(VP_FIELD_ID);
> -	DUMPREG(VP_MODE);
> -	DUMPREG(VP_IMG_SIZE_Y);
> -	DUMPREG(VP_IMG_SIZE_C);
> -	DUMPREG(VP_PER_RATE_CTRL);
> -	DUMPREG(VP_TOP_Y_PTR);
> -	DUMPREG(VP_BOT_Y_PTR);
> -	DUMPREG(VP_TOP_C_PTR);
> -	DUMPREG(VP_BOT_C_PTR);
> -	DUMPREG(VP_ENDIAN_MODE);
> -	DUMPREG(VP_SRC_H_POSITION);
> -	DUMPREG(VP_SRC_V_POSITION);
> -	DUMPREG(VP_SRC_WIDTH);
> -	DUMPREG(VP_SRC_HEIGHT);
> -	DUMPREG(VP_DST_H_POSITION);
> -	DUMPREG(VP_DST_V_POSITION);
> -	DUMPREG(VP_DST_WIDTH);
> -	DUMPREG(VP_DST_HEIGHT);
> -	DUMPREG(VP_H_RATIO);
> -	DUMPREG(VP_V_RATIO);
> -
> -#undef DUMPREG
> -}
> -
> -void mxr_reg_dump(struct mxr_device *mdev)
> -{
> -	mxr_reg_mxr_dump(mdev);
> -	mxr_reg_vp_dump(mdev);
> -}
> -
> diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
> deleted file mode 100644
> index ee74e2b..0000000
> --- a/drivers/media/platform/s5p-tv/mixer_video.c
> +++ /dev/null
> @@ -1,1130 +0,0 @@
> -/*
> - * Samsung TV Mixer driver
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *
> - * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published
> - * by the Free Software Foundation. either version 2 of the License,
> - * or (at your option) any later version
> - */
> -
> -#define pr_fmt(fmt) "s5p-tv (mixer): " fmt
> -
> -#include "mixer.h"
> -
> -#include <media/v4l2-ioctl.h>
> -#include <linux/videodev2.h>
> -#include <linux/mm.h>
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/timer.h>
> -#include <media/videobuf2-dma-contig.h>
> -
> -static int find_reg_callback(struct device *dev, void *p)
> -{
> -	struct v4l2_subdev **sd = p;
> -
> -	*sd = dev_get_drvdata(dev);
> -	/* non-zero value stops iteration */
> -	return 1;
> -}
> -
> -static struct v4l2_subdev *find_and_register_subdev(
> -	struct mxr_device *mdev, char *module_name)
> -{
> -	struct device_driver *drv;
> -	struct v4l2_subdev *sd = NULL;
> -	int ret;
> -
> -	/* TODO: add waiting until probe is finished */
> -	drv = driver_find(module_name, &platform_bus_type);
> -	if (!drv) {
> -		mxr_warn(mdev, "module %s is missing\n", module_name);
> -		return NULL;
> -	}
> -	/* driver refcnt is increased, it is safe to iterate over devices */
> -	ret = driver_for_each_device(drv, NULL, &sd, find_reg_callback);
> -	/* ret == 0 means that find_reg_callback was never executed */
> -	if (sd == NULL) {
> -		mxr_warn(mdev, "module %s provides no subdev!\n", module_name);
> -		goto done;
> -	}
> -	/* v4l2_device_register_subdev detects if sd is NULL */
> -	ret = v4l2_device_register_subdev(&mdev->v4l2_dev, sd);
> -	if (ret) {
> -		mxr_warn(mdev, "failed to register subdev %s\n", sd->name);
> -		sd = NULL;
> -	}
> -
> -done:
> -	return sd;
> -}
> -
> -int mxr_acquire_video(struct mxr_device *mdev,
> -		      struct mxr_output_conf *output_conf, int output_count)
> -{
> -	struct device *dev = mdev->dev;
> -	struct v4l2_device *v4l2_dev = &mdev->v4l2_dev;
> -	int i;
> -	int ret = 0;
> -	struct v4l2_subdev *sd;
> -
> -	strlcpy(v4l2_dev->name, dev_name(mdev->dev), sizeof(v4l2_dev->name));
> -	/* prepare context for V4L2 device */
> -	ret = v4l2_device_register(dev, v4l2_dev);
> -	if (ret) {
> -		mxr_err(mdev, "could not register v4l2 device.\n");
> -		goto fail;
> -	}
> -
> -	vb2_dma_contig_set_max_seg_size(mdev->dev, DMA_BIT_MASK(32));
> -
> -	/* registering outputs */
> -	mdev->output_cnt = 0;
> -	for (i = 0; i < output_count; ++i) {
> -		struct mxr_output_conf *conf = &output_conf[i];
> -		struct mxr_output *out;
> -
> -		sd = find_and_register_subdev(mdev, conf->module_name);
> -		/* trying to register next output */
> -		if (sd == NULL)
> -			continue;
> -		out = kzalloc(sizeof(*out), GFP_KERNEL);
> -		if (out == NULL) {
> -			mxr_err(mdev, "no memory for '%s'\n",
> -				conf->output_name);
> -			ret = -ENOMEM;
> -			/* registered subdevs are removed in fail_v4l2_dev */
> -			goto fail_output;
> -		}
> -		strlcpy(out->name, conf->output_name, sizeof(out->name));
> -		out->sd = sd;
> -		out->cookie = conf->cookie;
> -		mdev->output[mdev->output_cnt++] = out;
> -		mxr_info(mdev, "added output '%s' from module '%s'\n",
> -			conf->output_name, conf->module_name);
> -		/* checking if maximal number of outputs is reached */
> -		if (mdev->output_cnt >= MXR_MAX_OUTPUTS)
> -			break;
> -	}
> -
> -	if (mdev->output_cnt == 0) {
> -		mxr_err(mdev, "failed to register any output\n");
> -		ret = -ENODEV;
> -		/* skipping fail_output because there is nothing to free */
> -		goto fail_v4l2_dev;
> -	}
> -
> -	return 0;
> -
> -fail_output:
> -	/* kfree is NULL-safe */
> -	for (i = 0; i < mdev->output_cnt; ++i)
> -		kfree(mdev->output[i]);
> -	memset(mdev->output, 0, sizeof(mdev->output));
> -
> -fail_v4l2_dev:
> -	/* NOTE: automatically unregister all subdevs */
> -	v4l2_device_unregister(v4l2_dev);
> -
> -fail:
> -	return ret;
> -}
> -
> -void mxr_release_video(struct mxr_device *mdev)
> -{
> -	int i;
> -
> -	/* kfree is NULL-safe */
> -	for (i = 0; i < mdev->output_cnt; ++i)
> -		kfree(mdev->output[i]);
> -
> -	vb2_dma_contig_clear_max_seg_size(mdev->dev);
> -	v4l2_device_unregister(&mdev->v4l2_dev);
> -}
> -
> -static int mxr_querycap(struct file *file, void *priv,
> -	struct v4l2_capability *cap)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -
> -	strlcpy(cap->driver, MXR_DRIVER_NAME, sizeof(cap->driver));
> -	strlcpy(cap->card, layer->vfd.name, sizeof(cap->card));
> -	sprintf(cap->bus_info, "%d", layer->idx);
> -	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> -	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> -
> -	return 0;
> -}
> -
> -static void mxr_geometry_dump(struct mxr_device *mdev, struct mxr_geometry *geo)
> -{
> -	mxr_dbg(mdev, "src.full_size = (%u, %u)\n",
> -		geo->src.full_width, geo->src.full_height);
> -	mxr_dbg(mdev, "src.size = (%u, %u)\n",
> -		geo->src.width, geo->src.height);
> -	mxr_dbg(mdev, "src.offset = (%u, %u)\n",
> -		geo->src.x_offset, geo->src.y_offset);
> -	mxr_dbg(mdev, "dst.full_size = (%u, %u)\n",
> -		geo->dst.full_width, geo->dst.full_height);
> -	mxr_dbg(mdev, "dst.size = (%u, %u)\n",
> -		geo->dst.width, geo->dst.height);
> -	mxr_dbg(mdev, "dst.offset = (%u, %u)\n",
> -		geo->dst.x_offset, geo->dst.y_offset);
> -	mxr_dbg(mdev, "ratio = (%u, %u)\n",
> -		geo->x_ratio, geo->y_ratio);
> -}
> -
> -static void mxr_layer_default_geo(struct mxr_layer *layer)
> -{
> -	struct mxr_device *mdev = layer->mdev;
> -	struct v4l2_mbus_framefmt mbus_fmt;
> -
> -	memset(&layer->geo, 0, sizeof(layer->geo));
> -
> -	mxr_get_mbus_fmt(mdev, &mbus_fmt);
> -
> -	layer->geo.dst.full_width = mbus_fmt.width;
> -	layer->geo.dst.full_height = mbus_fmt.height;
> -	layer->geo.dst.width = layer->geo.dst.full_width;
> -	layer->geo.dst.height = layer->geo.dst.full_height;
> -	layer->geo.dst.field = mbus_fmt.field;
> -
> -	layer->geo.src.full_width = mbus_fmt.width;
> -	layer->geo.src.full_height = mbus_fmt.height;
> -	layer->geo.src.width = layer->geo.src.full_width;
> -	layer->geo.src.height = layer->geo.src.full_height;
> -
> -	mxr_geometry_dump(mdev, &layer->geo);
> -	layer->ops.fix_geometry(layer, MXR_GEOMETRY_SINK, 0);
> -	mxr_geometry_dump(mdev, &layer->geo);
> -}
> -
> -static void mxr_layer_update_output(struct mxr_layer *layer)
> -{
> -	struct mxr_device *mdev = layer->mdev;
> -	struct v4l2_mbus_framefmt mbus_fmt;
> -
> -	mxr_get_mbus_fmt(mdev, &mbus_fmt);
> -	/* checking if update is needed */
> -	if (layer->geo.dst.full_width == mbus_fmt.width &&
> -		layer->geo.dst.full_height == mbus_fmt.width)
> -		return;
> -
> -	layer->geo.dst.full_width = mbus_fmt.width;
> -	layer->geo.dst.full_height = mbus_fmt.height;
> -	layer->geo.dst.field = mbus_fmt.field;
> -	layer->ops.fix_geometry(layer, MXR_GEOMETRY_SINK, 0);
> -
> -	mxr_geometry_dump(mdev, &layer->geo);
> -}
> -
> -static const struct mxr_format *find_format_by_fourcc(
> -	struct mxr_layer *layer, unsigned long fourcc);
> -static const struct mxr_format *find_format_by_index(
> -	struct mxr_layer *layer, unsigned long index);
> -
> -static int mxr_enum_fmt(struct file *file, void  *priv,
> -	struct v4l2_fmtdesc *f)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -	const struct mxr_format *fmt;
> -
> -	mxr_dbg(mdev, "%s\n", __func__);
> -	fmt = find_format_by_index(layer, f->index);
> -	if (fmt == NULL)
> -		return -EINVAL;
> -
> -	strlcpy(f->description, fmt->name, sizeof(f->description));
> -	f->pixelformat = fmt->fourcc;
> -
> -	return 0;
> -}
> -
> -static unsigned int divup(unsigned int divident, unsigned int divisor)
> -{
> -	return (divident + divisor - 1) / divisor;
> -}
> -
> -unsigned long mxr_get_plane_size(const struct mxr_block *blk,
> -	unsigned int width, unsigned int height)
> -{
> -	unsigned int bl_width = divup(width, blk->width);
> -	unsigned int bl_height = divup(height, blk->height);
> -
> -	return bl_width * bl_height * blk->size;
> -}
> -
> -static void mxr_mplane_fill(struct v4l2_plane_pix_format *planes,
> -	const struct mxr_format *fmt, u32 width, u32 height)
> -{
> -	int i;
> -
> -	/* checking if nothing to fill */
> -	if (!planes)
> -		return;
> -
> -	memset(planes, 0, sizeof(*planes) * fmt->num_subframes);
> -	for (i = 0; i < fmt->num_planes; ++i) {
> -		struct v4l2_plane_pix_format *plane = planes
> -			+ fmt->plane2subframe[i];
> -		const struct mxr_block *blk = &fmt->plane[i];
> -		u32 bl_width = divup(width, blk->width);
> -		u32 bl_height = divup(height, blk->height);
> -		u32 sizeimage = bl_width * bl_height * blk->size;
> -		u32 bytesperline = bl_width * blk->size / blk->height;
> -
> -		plane->sizeimage += sizeimage;
> -		plane->bytesperline = max(plane->bytesperline, bytesperline);
> -	}
> -}
> -
> -static int mxr_g_fmt(struct file *file, void *priv,
> -			     struct v4l2_format *f)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -
> -	pix->width = layer->geo.src.full_width;
> -	pix->height = layer->geo.src.full_height;
> -	pix->field = V4L2_FIELD_NONE;
> -	pix->pixelformat = layer->fmt->fourcc;
> -	pix->colorspace = layer->fmt->colorspace;
> -	mxr_mplane_fill(pix->plane_fmt, layer->fmt, pix->width, pix->height);
> -
> -	return 0;
> -}
> -
> -static int mxr_s_fmt(struct file *file, void *priv,
> -	struct v4l2_format *f)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	const struct mxr_format *fmt;
> -	struct v4l2_pix_format_mplane *pix;
> -	struct mxr_device *mdev = layer->mdev;
> -	struct mxr_geometry *geo = &layer->geo;
> -
> -	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
> -
> -	pix = &f->fmt.pix_mp;
> -	fmt = find_format_by_fourcc(layer, pix->pixelformat);
> -	if (fmt == NULL) {
> -		mxr_warn(mdev, "not recognized fourcc: %08x\n",
> -			pix->pixelformat);
> -		return -EINVAL;
> -	}
> -	layer->fmt = fmt;
> -	/* set source size to highest accepted value */
> -	geo->src.full_width = max(geo->dst.full_width, pix->width);
> -	geo->src.full_height = max(geo->dst.full_height, pix->height);
> -	layer->ops.fix_geometry(layer, MXR_GEOMETRY_SOURCE, 0);
> -	mxr_geometry_dump(mdev, &layer->geo);
> -	/* set cropping to total visible screen */
> -	geo->src.width = pix->width;
> -	geo->src.height = pix->height;
> -	geo->src.x_offset = 0;
> -	geo->src.y_offset = 0;
> -	/* assure consistency of geometry */
> -	layer->ops.fix_geometry(layer, MXR_GEOMETRY_CROP, MXR_NO_OFFSET);
> -	mxr_geometry_dump(mdev, &layer->geo);
> -	/* set full size to lowest possible value */
> -	geo->src.full_width = 0;
> -	geo->src.full_height = 0;
> -	layer->ops.fix_geometry(layer, MXR_GEOMETRY_SOURCE, 0);
> -	mxr_geometry_dump(mdev, &layer->geo);
> -
> -	/* returning results */
> -	mxr_g_fmt(file, priv, f);
> -
> -	return 0;
> -}
> -
> -static int mxr_g_selection(struct file *file, void *fh,
> -	struct v4l2_selection *s)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_geometry *geo = &layer->geo;
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -
> -	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> -		s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> -		return -EINVAL;
> -
> -	switch (s->target) {
> -	case V4L2_SEL_TGT_CROP:
> -		s->r.left = geo->src.x_offset;
> -		s->r.top = geo->src.y_offset;
> -		s->r.width = geo->src.width;
> -		s->r.height = geo->src.height;
> -		break;
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
> -	case V4L2_SEL_TGT_CROP_BOUNDS:
> -		s->r.left = 0;
> -		s->r.top = 0;
> -		s->r.width = geo->src.full_width;
> -		s->r.height = geo->src.full_height;
> -		break;
> -	case V4L2_SEL_TGT_COMPOSE:
> -	case V4L2_SEL_TGT_COMPOSE_PADDED:
> -		s->r.left = geo->dst.x_offset;
> -		s->r.top = geo->dst.y_offset;
> -		s->r.width = geo->dst.width;
> -		s->r.height = geo->dst.height;
> -		break;
> -	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> -	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> -		s->r.left = 0;
> -		s->r.top = 0;
> -		s->r.width = geo->dst.full_width;
> -		s->r.height = geo->dst.full_height;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -/* returns 1 if rectangle 'a' is inside 'b' */
> -static int mxr_is_rect_inside(struct v4l2_rect *a, struct v4l2_rect *b)
> -{
> -	if (a->left < b->left)
> -		return 0;
> -	if (a->top < b->top)
> -		return 0;
> -	if (a->left + a->width > b->left + b->width)
> -		return 0;
> -	if (a->top + a->height > b->top + b->height)
> -		return 0;
> -	return 1;
> -}
> -
> -static int mxr_s_selection(struct file *file, void *fh,
> -	struct v4l2_selection *s)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_geometry *geo = &layer->geo;
> -	struct mxr_crop *target = NULL;
> -	enum mxr_geometry_stage stage;
> -	struct mxr_geometry tmp;
> -	struct v4l2_rect res;
> -
> -	memset(&res, 0, sizeof(res));
> -
> -	mxr_dbg(layer->mdev, "%s: rect: %dx%d@%d,%d\n", __func__,
> -		s->r.width, s->r.height, s->r.left, s->r.top);
> -
> -	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> -		s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> -		return -EINVAL;
> -
> -	switch (s->target) {
> -	/* ignore read-only targets */
> -	case V4L2_SEL_TGT_CROP_DEFAULT:
> -	case V4L2_SEL_TGT_CROP_BOUNDS:
> -		res.width = geo->src.full_width;
> -		res.height = geo->src.full_height;
> -		break;
> -
> -	/* ignore read-only targets */
> -	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> -	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> -		res.width = geo->dst.full_width;
> -		res.height = geo->dst.full_height;
> -		break;
> -
> -	case V4L2_SEL_TGT_CROP:
> -		target = &geo->src;
> -		stage = MXR_GEOMETRY_CROP;
> -		break;
> -	case V4L2_SEL_TGT_COMPOSE:
> -	case V4L2_SEL_TGT_COMPOSE_PADDED:
> -		target = &geo->dst;
> -		stage = MXR_GEOMETRY_COMPOSE;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -	/* apply change and update geometry if needed */
> -	if (target) {
> -		/* backup current geometry if setup fails */
> -		memcpy(&tmp, geo, sizeof(tmp));
> -
> -		/* apply requested selection */
> -		target->x_offset = s->r.left;
> -		target->y_offset = s->r.top;
> -		target->width = s->r.width;
> -		target->height = s->r.height;
> -
> -		layer->ops.fix_geometry(layer, stage, s->flags);
> -
> -		/* retrieve update selection rectangle */
> -		res.left = target->x_offset;
> -		res.top = target->y_offset;
> -		res.width = target->width;
> -		res.height = target->height;
> -
> -		mxr_geometry_dump(layer->mdev, &layer->geo);
> -	}
> -
> -	/* checking if the rectangle satisfies constraints */
> -	if ((s->flags & V4L2_SEL_FLAG_LE) && !mxr_is_rect_inside(&res, &s->r))
> -		goto fail;
> -	if ((s->flags & V4L2_SEL_FLAG_GE) && !mxr_is_rect_inside(&s->r, &res))
> -		goto fail;
> -
> -	/* return result rectangle */
> -	s->r = res;
> -
> -	return 0;
> -fail:
> -	/* restore old geometry, which is not touched if target is NULL */
> -	if (target)
> -		memcpy(geo, &tmp, sizeof(tmp));
> -	return -ERANGE;
> -}
> -
> -static int mxr_enum_dv_timings(struct file *file, void *fh,
> -	struct v4l2_enum_dv_timings *timings)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -	int ret;
> -
> -	timings->pad = 0;
> -
> -	/* lock protects from changing sd_out */
> -	mutex_lock(&mdev->mutex);
> -	ret = v4l2_subdev_call(to_outsd(mdev), pad, enum_dv_timings, timings);
> -	mutex_unlock(&mdev->mutex);
> -
> -	return ret ? -EINVAL : 0;
> -}
> -
> -static int mxr_s_dv_timings(struct file *file, void *fh,
> -	struct v4l2_dv_timings *timings)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -	int ret;
> -
> -	/* lock protects from changing sd_out */
> -	mutex_lock(&mdev->mutex);
> -
> -	/* timings change cannot be done while there is an entity
> -	 * dependent on output configuration
> -	 */
> -	if (mdev->n_output > 0) {
> -		mutex_unlock(&mdev->mutex);
> -		return -EBUSY;
> -	}
> -
> -	ret = v4l2_subdev_call(to_outsd(mdev), video, s_dv_timings, timings);
> -
> -	mutex_unlock(&mdev->mutex);
> -
> -	mxr_layer_update_output(layer);
> -
> -	/* any failure should return EINVAL according to V4L2 doc */
> -	return ret ? -EINVAL : 0;
> -}
> -
> -static int mxr_g_dv_timings(struct file *file, void *fh,
> -	struct v4l2_dv_timings *timings)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -	int ret;
> -
> -	/* lock protects from changing sd_out */
> -	mutex_lock(&mdev->mutex);
> -	ret = v4l2_subdev_call(to_outsd(mdev), video, g_dv_timings, timings);
> -	mutex_unlock(&mdev->mutex);
> -
> -	return ret ? -EINVAL : 0;
> -}
> -
> -static int mxr_dv_timings_cap(struct file *file, void *fh,
> -	struct v4l2_dv_timings_cap *cap)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -	int ret;
> -
> -	cap->pad = 0;
> -
> -	/* lock protects from changing sd_out */
> -	mutex_lock(&mdev->mutex);
> -	ret = v4l2_subdev_call(to_outsd(mdev), pad, dv_timings_cap, cap);
> -	mutex_unlock(&mdev->mutex);
> -
> -	return ret ? -EINVAL : 0;
> -}
> -
> -static int mxr_s_std(struct file *file, void *fh, v4l2_std_id norm)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -	int ret;
> -
> -	/* lock protects from changing sd_out */
> -	mutex_lock(&mdev->mutex);
> -
> -	/* standard change cannot be done while there is an entity
> -	 * dependent on output configuration
> -	 */
> -	if (mdev->n_output > 0) {
> -		mutex_unlock(&mdev->mutex);
> -		return -EBUSY;
> -	}
> -
> -	ret = v4l2_subdev_call(to_outsd(mdev), video, s_std_output, norm);
> -
> -	mutex_unlock(&mdev->mutex);
> -
> -	mxr_layer_update_output(layer);
> -
> -	return ret ? -EINVAL : 0;
> -}
> -
> -static int mxr_g_std(struct file *file, void *fh, v4l2_std_id *norm)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -	int ret;
> -
> -	/* lock protects from changing sd_out */
> -	mutex_lock(&mdev->mutex);
> -	ret = v4l2_subdev_call(to_outsd(mdev), video, g_std_output, norm);
> -	mutex_unlock(&mdev->mutex);
> -
> -	return ret ? -EINVAL : 0;
> -}
> -
> -static int mxr_enum_output(struct file *file, void *fh, struct v4l2_output *a)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -	struct mxr_output *out;
> -	struct v4l2_subdev *sd;
> -
> -	if (a->index >= mdev->output_cnt)
> -		return -EINVAL;
> -	out = mdev->output[a->index];
> -	BUG_ON(out == NULL);
> -	sd = out->sd;
> -	strlcpy(a->name, out->name, sizeof(a->name));
> -
> -	/* try to obtain supported tv norms */
> -	v4l2_subdev_call(sd, video, g_tvnorms_output, &a->std);
> -	a->capabilities = 0;
> -	if (sd->ops->video && sd->ops->video->s_dv_timings)
> -		a->capabilities |= V4L2_OUT_CAP_DV_TIMINGS;
> -	if (sd->ops->video && sd->ops->video->s_std_output)
> -		a->capabilities |= V4L2_OUT_CAP_STD;
> -	a->type = V4L2_OUTPUT_TYPE_ANALOG;
> -
> -	return 0;
> -}
> -
> -static int mxr_s_output(struct file *file, void *fh, unsigned int i)
> -{
> -	struct video_device *vfd = video_devdata(file);
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -
> -	if (i >= mdev->output_cnt || mdev->output[i] == NULL)
> -		return -EINVAL;
> -
> -	mutex_lock(&mdev->mutex);
> -	if (mdev->n_output > 0) {
> -		mutex_unlock(&mdev->mutex);
> -		return -EBUSY;
> -	}
> -	mdev->current_output = i;
> -	vfd->tvnorms = 0;
> -	v4l2_subdev_call(to_outsd(mdev), video, g_tvnorms_output,
> -		&vfd->tvnorms);
> -	mutex_unlock(&mdev->mutex);
> -
> -	/* update layers geometry */
> -	mxr_layer_update_output(layer);
> -
> -	mxr_dbg(mdev, "tvnorms = %08llx\n", vfd->tvnorms);
> -
> -	return 0;
> -}
> -
> -static int mxr_g_output(struct file *file, void *fh, unsigned int *p)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -
> -	mutex_lock(&mdev->mutex);
> -	*p = mdev->current_output;
> -	mutex_unlock(&mdev->mutex);
> -
> -	return 0;
> -}
> -
> -static int mxr_reqbufs(struct file *file, void *priv,
> -			  struct v4l2_requestbuffers *p)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -	return vb2_reqbufs(&layer->vb_queue, p);
> -}
> -
> -static int mxr_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -	return vb2_querybuf(&layer->vb_queue, p);
> -}
> -
> -static int mxr_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -
> -	mxr_dbg(layer->mdev, "%s:%d(%d)\n", __func__, __LINE__, p->index);
> -	return vb2_qbuf(&layer->vb_queue, p);
> -}
> -
> -static int mxr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -	return vb2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
> -}
> -
> -static int mxr_expbuf(struct file *file, void *priv,
> -	struct v4l2_exportbuffer *eb)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -	return vb2_expbuf(&layer->vb_queue, eb);
> -}
> -
> -static int mxr_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -	return vb2_streamon(&layer->vb_queue, i);
> -}
> -
> -static int mxr_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -	return vb2_streamoff(&layer->vb_queue, i);
> -}
> -
> -static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
> -	.vidioc_querycap = mxr_querycap,
> -	/* format handling */
> -	.vidioc_enum_fmt_vid_out_mplane = mxr_enum_fmt,
> -	.vidioc_s_fmt_vid_out_mplane = mxr_s_fmt,
> -	.vidioc_g_fmt_vid_out_mplane = mxr_g_fmt,
> -	/* buffer control */
> -	.vidioc_reqbufs = mxr_reqbufs,
> -	.vidioc_querybuf = mxr_querybuf,
> -	.vidioc_qbuf = mxr_qbuf,
> -	.vidioc_dqbuf = mxr_dqbuf,
> -	.vidioc_expbuf = mxr_expbuf,
> -	/* Streaming control */
> -	.vidioc_streamon = mxr_streamon,
> -	.vidioc_streamoff = mxr_streamoff,
> -	/* DV Timings functions */
> -	.vidioc_enum_dv_timings = mxr_enum_dv_timings,
> -	.vidioc_s_dv_timings = mxr_s_dv_timings,
> -	.vidioc_g_dv_timings = mxr_g_dv_timings,
> -	.vidioc_dv_timings_cap = mxr_dv_timings_cap,
> -	/* analog TV standard functions */
> -	.vidioc_s_std = mxr_s_std,
> -	.vidioc_g_std = mxr_g_std,
> -	/* Output handling */
> -	.vidioc_enum_output = mxr_enum_output,
> -	.vidioc_s_output = mxr_s_output,
> -	.vidioc_g_output = mxr_g_output,
> -	/* selection ioctls */
> -	.vidioc_g_selection = mxr_g_selection,
> -	.vidioc_s_selection = mxr_s_selection,
> -};
> -
> -static int mxr_video_open(struct file *file)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	struct mxr_device *mdev = layer->mdev;
> -	int ret = 0;
> -
> -	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
> -	if (mutex_lock_interruptible(&layer->mutex))
> -		return -ERESTARTSYS;
> -	/* assure device probe is finished */
> -	wait_for_device_probe();
> -	/* creating context for file descriptor */
> -	ret = v4l2_fh_open(file);
> -	if (ret) {
> -		mxr_err(mdev, "v4l2_fh_open failed\n");
> -		goto unlock;
> -	}
> -
> -	/* leaving if layer is already initialized */
> -	if (!v4l2_fh_is_singular_file(file))
> -		goto unlock;
> -
> -	/* FIXME: should power be enabled on open? */
> -	ret = mxr_power_get(mdev);
> -	if (ret) {
> -		mxr_err(mdev, "power on failed\n");
> -		goto fail_fh_open;
> -	}
> -
> -	ret = vb2_queue_init(&layer->vb_queue);
> -	if (ret != 0) {
> -		mxr_err(mdev, "failed to initialize vb2 queue\n");
> -		goto fail_power;
> -	}
> -	/* set default format, first on the list */
> -	layer->fmt = layer->fmt_array[0];
> -	/* setup default geometry */
> -	mxr_layer_default_geo(layer);
> -	mutex_unlock(&layer->mutex);
> -
> -	return 0;
> -
> -fail_power:
> -	mxr_power_put(mdev);
> -
> -fail_fh_open:
> -	v4l2_fh_release(file);
> -
> -unlock:
> -	mutex_unlock(&layer->mutex);
> -
> -	return ret;
> -}
> -
> -static unsigned int
> -mxr_video_poll(struct file *file, struct poll_table_struct *wait)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	unsigned int res;
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -
> -	mutex_lock(&layer->mutex);
> -	res = vb2_poll(&layer->vb_queue, file, wait);
> -	mutex_unlock(&layer->mutex);
> -	return res;
> -}
> -
> -static int mxr_video_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -	int ret;
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -
> -	if (mutex_lock_interruptible(&layer->mutex))
> -		return -ERESTARTSYS;
> -	ret = vb2_mmap(&layer->vb_queue, vma);
> -	mutex_unlock(&layer->mutex);
> -	return ret;
> -}
> -
> -static int mxr_video_release(struct file *file)
> -{
> -	struct mxr_layer *layer = video_drvdata(file);
> -
> -	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> -	mutex_lock(&layer->mutex);
> -	if (v4l2_fh_is_singular_file(file)) {
> -		vb2_queue_release(&layer->vb_queue);
> -		mxr_power_put(layer->mdev);
> -	}
> -	v4l2_fh_release(file);
> -	mutex_unlock(&layer->mutex);
> -	return 0;
> -}
> -
> -static const struct v4l2_file_operations mxr_fops = {
> -	.owner = THIS_MODULE,
> -	.open = mxr_video_open,
> -	.poll = mxr_video_poll,
> -	.mmap = mxr_video_mmap,
> -	.release = mxr_video_release,
> -	.unlocked_ioctl = video_ioctl2,
> -};
> -
> -static int queue_setup(struct vb2_queue *vq,
> -	unsigned int *nbuffers, unsigned int *nplanes, unsigned int sizes[],
> -	struct device *alloc_devs[])
> -{
> -	struct mxr_layer *layer = vb2_get_drv_priv(vq);
> -	const struct mxr_format *fmt = layer->fmt;
> -	int i;
> -	struct mxr_device *mdev = layer->mdev;
> -	struct v4l2_plane_pix_format planes[3];
> -
> -	mxr_dbg(mdev, "%s\n", __func__);
> -	/* checking if format was configured */
> -	if (fmt == NULL)
> -		return -EINVAL;
> -	mxr_dbg(mdev, "fmt = %s\n", fmt->name);
> -	mxr_mplane_fill(planes, fmt, layer->geo.src.full_width,
> -		layer->geo.src.full_height);
> -
> -	*nplanes = fmt->num_subframes;
> -	for (i = 0; i < fmt->num_subframes; ++i) {
> -		sizes[i] = planes[i].sizeimage;
> -		mxr_dbg(mdev, "size[%d] = %08x\n", i, sizes[i]);
> -	}
> -
> -	if (*nbuffers == 0)
> -		*nbuffers = 1;
> -
> -	return 0;
> -}
> -
> -static void buf_queue(struct vb2_buffer *vb)
> -{
> -	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> -	struct mxr_buffer *buffer = container_of(vbuf, struct mxr_buffer, vb);
> -	struct mxr_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
> -	struct mxr_device *mdev = layer->mdev;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&layer->enq_slock, flags);
> -	list_add_tail(&buffer->list, &layer->enq_list);
> -	spin_unlock_irqrestore(&layer->enq_slock, flags);
> -
> -	mxr_dbg(mdev, "queuing buffer\n");
> -}
> -
> -static int start_streaming(struct vb2_queue *vq, unsigned int count)
> -{
> -	struct mxr_layer *layer = vb2_get_drv_priv(vq);
> -	struct mxr_device *mdev = layer->mdev;
> -	unsigned long flags;
> -
> -	mxr_dbg(mdev, "%s\n", __func__);
> -
> -	/* block any changes in output configuration */
> -	mxr_output_get(mdev);
> -
> -	mxr_layer_update_output(layer);
> -	layer->ops.format_set(layer);
> -	/* enabling layer in hardware */
> -	spin_lock_irqsave(&layer->enq_slock, flags);
> -	layer->state = MXR_LAYER_STREAMING;
> -	spin_unlock_irqrestore(&layer->enq_slock, flags);
> -
> -	layer->ops.stream_set(layer, MXR_ENABLE);
> -	mxr_streamer_get(mdev);
> -
> -	return 0;
> -}
> -
> -static void mxr_watchdog(unsigned long arg)
> -{
> -	struct mxr_layer *layer = (struct mxr_layer *) arg;
> -	struct mxr_device *mdev = layer->mdev;
> -	unsigned long flags;
> -
> -	mxr_err(mdev, "watchdog fired for layer %s\n", layer->vfd.name);
> -
> -	spin_lock_irqsave(&layer->enq_slock, flags);
> -
> -	if (layer->update_buf == layer->shadow_buf)
> -		layer->update_buf = NULL;
> -	if (layer->update_buf) {
> -		vb2_buffer_done(&layer->update_buf->vb.vb2_buf,
> -				VB2_BUF_STATE_ERROR);
> -		layer->update_buf = NULL;
> -	}
> -	if (layer->shadow_buf) {
> -		vb2_buffer_done(&layer->shadow_buf->vb.vb2_buf,
> -				VB2_BUF_STATE_ERROR);
> -		layer->shadow_buf = NULL;
> -	}
> -	spin_unlock_irqrestore(&layer->enq_slock, flags);
> -}
> -
> -static void stop_streaming(struct vb2_queue *vq)
> -{
> -	struct mxr_layer *layer = vb2_get_drv_priv(vq);
> -	struct mxr_device *mdev = layer->mdev;
> -	unsigned long flags;
> -	struct timer_list watchdog;
> -	struct mxr_buffer *buf, *buf_tmp;
> -
> -	mxr_dbg(mdev, "%s\n", __func__);
> -
> -	spin_lock_irqsave(&layer->enq_slock, flags);
> -
> -	/* reset list */
> -	layer->state = MXR_LAYER_STREAMING_FINISH;
> -
> -	/* set all buffer to be done */
> -	list_for_each_entry_safe(buf, buf_tmp, &layer->enq_list, list) {
> -		list_del(&buf->list);
> -		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> -	}
> -
> -	spin_unlock_irqrestore(&layer->enq_slock, flags);
> -
> -	/* give 1 seconds to complete to complete last buffers */
> -	setup_timer_on_stack(&watchdog, mxr_watchdog,
> -		(unsigned long)layer);
> -	mod_timer(&watchdog, jiffies + msecs_to_jiffies(1000));
> -
> -	/* wait until all buffers are goes to done state */
> -	vb2_wait_for_all_buffers(vq);
> -
> -	/* stop timer if all synchronization is done */
> -	del_timer_sync(&watchdog);
> -	destroy_timer_on_stack(&watchdog);
> -
> -	/* stopping hardware */
> -	spin_lock_irqsave(&layer->enq_slock, flags);
> -	layer->state = MXR_LAYER_IDLE;
> -	spin_unlock_irqrestore(&layer->enq_slock, flags);
> -
> -	/* disabling layer in hardware */
> -	layer->ops.stream_set(layer, MXR_DISABLE);
> -	/* remove one streamer */
> -	mxr_streamer_put(mdev);
> -	/* allow changes in output configuration */
> -	mxr_output_put(mdev);
> -}
> -
> -static struct vb2_ops mxr_video_qops = {
> -	.queue_setup = queue_setup,
> -	.buf_queue = buf_queue,
> -	.wait_prepare = vb2_ops_wait_prepare,
> -	.wait_finish = vb2_ops_wait_finish,
> -	.start_streaming = start_streaming,
> -	.stop_streaming = stop_streaming,
> -};
> -
> -/* FIXME: try to put this functions to mxr_base_layer_create */
> -int mxr_base_layer_register(struct mxr_layer *layer)
> -{
> -	struct mxr_device *mdev = layer->mdev;
> -	int ret;
> -
> -	ret = video_register_device(&layer->vfd, VFL_TYPE_GRABBER, -1);
> -	if (ret)
> -		mxr_err(mdev, "failed to register video device\n");
> -	else
> -		mxr_info(mdev, "registered layer %s as /dev/video%d\n",
> -			layer->vfd.name, layer->vfd.num);
> -	return ret;
> -}
> -
> -void mxr_base_layer_unregister(struct mxr_layer *layer)
> -{
> -	video_unregister_device(&layer->vfd);
> -}
> -
> -void mxr_layer_release(struct mxr_layer *layer)
> -{
> -	if (layer->ops.release)
> -		layer->ops.release(layer);
> -}
> -
> -void mxr_base_layer_release(struct mxr_layer *layer)
> -{
> -	kfree(layer);
> -}
> -
> -static void mxr_vfd_release(struct video_device *vdev)
> -{
> -	pr_info("video device release\n");
> -}
> -
> -struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
> -	int idx, char *name, const struct mxr_layer_ops *ops)
> -{
> -	struct mxr_layer *layer;
> -
> -	layer = kzalloc(sizeof(*layer), GFP_KERNEL);
> -	if (layer == NULL) {
> -		mxr_err(mdev, "not enough memory for layer.\n");
> -		goto fail;
> -	}
> -
> -	layer->mdev = mdev;
> -	layer->idx = idx;
> -	layer->ops = *ops;
> -
> -	spin_lock_init(&layer->enq_slock);
> -	INIT_LIST_HEAD(&layer->enq_list);
> -	mutex_init(&layer->mutex);
> -
> -	layer->vfd = (struct video_device) {
> -		.minor = -1,
> -		.release = mxr_vfd_release,
> -		.fops = &mxr_fops,
> -		.vfl_dir = VFL_DIR_TX,
> -		.ioctl_ops = &mxr_ioctl_ops,
> -	};
> -	strlcpy(layer->vfd.name, name, sizeof(layer->vfd.name));
> -
> -	video_set_drvdata(&layer->vfd, layer);
> -	layer->vfd.lock = &layer->mutex;
> -	layer->vfd.v4l2_dev = &mdev->v4l2_dev;
> -
> -	layer->vb_queue = (struct vb2_queue) {
> -		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> -		.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF,
> -		.drv_priv = layer,
> -		.buf_struct_size = sizeof(struct mxr_buffer),
> -		.ops = &mxr_video_qops,
> -		.min_buffers_needed = 1,
> -		.mem_ops = &vb2_dma_contig_memops,
> -		.lock = &layer->mutex,
> -		.dev = mdev->dev,
> -	};
> -
> -	return layer;
> -
> -fail:
> -	return NULL;
> -}
> -
> -static const struct mxr_format *find_format_by_fourcc(
> -	struct mxr_layer *layer, unsigned long fourcc)
> -{
> -	int i;
> -
> -	for (i = 0; i < layer->fmt_array_size; ++i)
> -		if (layer->fmt_array[i]->fourcc == fourcc)
> -			return layer->fmt_array[i];
> -	return NULL;
> -}
> -
> -static const struct mxr_format *find_format_by_index(
> -	struct mxr_layer *layer, unsigned long index)
> -{
> -	if (index >= layer->fmt_array_size)
> -		return NULL;
> -	return layer->fmt_array[index];
> -}
> -
> diff --git a/drivers/media/platform/s5p-tv/mixer_vp_layer.c b/drivers/media/platform/s5p-tv/mixer_vp_layer.c
> deleted file mode 100644
> index 6fa6f67..0000000
> --- a/drivers/media/platform/s5p-tv/mixer_vp_layer.c
> +++ /dev/null
> @@ -1,242 +0,0 @@
> -/*
> - * Samsung TV Mixer driver
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *
> - * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published
> - * by the Free Software Foundiation. either version 2 of the License,
> - * or (at your option) any later version
> - */
> -
> -#include "mixer.h"
> -
> -#include "regs-vp.h"
> -
> -#include <media/videobuf2-dma-contig.h>
> -
> -/* FORMAT DEFINITIONS */
> -static const struct mxr_format mxr_fmt_nv12 = {
> -	.name = "NV12",
> -	.fourcc = V4L2_PIX_FMT_NV12,
> -	.colorspace = V4L2_COLORSPACE_JPEG,
> -	.num_planes = 2,
> -	.plane = {
> -		{ .width = 1, .height = 1, .size = 1 },
> -		{ .width = 2, .height = 2, .size = 2 },
> -	},
> -	.num_subframes = 1,
> -	.cookie = VP_MODE_NV12 | VP_MODE_MEM_LINEAR,
> -};
> -
> -static const struct mxr_format mxr_fmt_nv21 = {
> -	.name = "NV21",
> -	.fourcc = V4L2_PIX_FMT_NV21,
> -	.colorspace = V4L2_COLORSPACE_JPEG,
> -	.num_planes = 2,
> -	.plane = {
> -		{ .width = 1, .height = 1, .size = 1 },
> -		{ .width = 2, .height = 2, .size = 2 },
> -	},
> -	.num_subframes = 1,
> -	.cookie = VP_MODE_NV21 | VP_MODE_MEM_LINEAR,
> -};
> -
> -static const struct mxr_format mxr_fmt_nv12m = {
> -	.name = "NV12 (mplane)",
> -	.fourcc = V4L2_PIX_FMT_NV12M,
> -	.colorspace = V4L2_COLORSPACE_JPEG,
> -	.num_planes = 2,
> -	.plane = {
> -		{ .width = 1, .height = 1, .size = 1 },
> -		{ .width = 2, .height = 2, .size = 2 },
> -	},
> -	.num_subframes = 2,
> -	.plane2subframe = {0, 1},
> -	.cookie = VP_MODE_NV12 | VP_MODE_MEM_LINEAR,
> -};
> -
> -static const struct mxr_format mxr_fmt_nv12mt = {
> -	.name = "NV12 tiled (mplane)",
> -	.fourcc = V4L2_PIX_FMT_NV12MT,
> -	.colorspace = V4L2_COLORSPACE_JPEG,
> -	.num_planes = 2,
> -	.plane = {
> -		{ .width = 128, .height = 32, .size = 4096 },
> -		{ .width = 128, .height = 32, .size = 2048 },
> -	},
> -	.num_subframes = 2,
> -	.plane2subframe = {0, 1},
> -	.cookie = VP_MODE_NV12 | VP_MODE_MEM_TILED,
> -};
> -
> -static const struct mxr_format *mxr_video_format[] = {
> -	&mxr_fmt_nv12,
> -	&mxr_fmt_nv21,
> -	&mxr_fmt_nv12m,
> -	&mxr_fmt_nv12mt,
> -};
> -
> -/* AUXILIARY CALLBACKS */
> -
> -static void mxr_vp_layer_release(struct mxr_layer *layer)
> -{
> -	mxr_base_layer_unregister(layer);
> -	mxr_base_layer_release(layer);
> -}
> -
> -static void mxr_vp_buffer_set(struct mxr_layer *layer,
> -	struct mxr_buffer *buf)
> -{
> -	dma_addr_t luma_addr[2] = {0, 0};
> -	dma_addr_t chroma_addr[2] = {0, 0};
> -
> -	if (buf == NULL) {
> -		mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
> -		return;
> -	}
> -	luma_addr[0] = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
> -	if (layer->fmt->num_subframes == 2) {
> -		chroma_addr[0] =
> -			vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 1);
> -	} else {
> -		/* FIXME: mxr_get_plane_size compute integer division,
> -		 * which is slow and should not be performed in interrupt */
> -		chroma_addr[0] = luma_addr[0] + mxr_get_plane_size(
> -			&layer->fmt->plane[0], layer->geo.src.full_width,
> -			layer->geo.src.full_height);
> -	}
> -	if (layer->fmt->cookie & VP_MODE_MEM_TILED) {
> -		luma_addr[1] = luma_addr[0] + 0x40;
> -		chroma_addr[1] = chroma_addr[0] + 0x40;
> -	} else {
> -		luma_addr[1] = luma_addr[0] + layer->geo.src.full_width;
> -		chroma_addr[1] = chroma_addr[0];
> -	}
> -	mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
> -}
> -
> -static void mxr_vp_stream_set(struct mxr_layer *layer, int en)
> -{
> -	mxr_reg_vp_layer_stream(layer->mdev, en);
> -}
> -
> -static void mxr_vp_format_set(struct mxr_layer *layer)
> -{
> -	mxr_reg_vp_format(layer->mdev, layer->fmt, &layer->geo);
> -}
> -
> -static inline unsigned int do_center(unsigned int center,
> -	unsigned int size, unsigned int upper, unsigned int flags)
> -{
> -	unsigned int lower;
> -
> -	if (flags & MXR_NO_OFFSET)
> -		return 0;
> -
> -	lower = center - min(center, size / 2);
> -	return min(lower, upper - size);
> -}
> -
> -static void mxr_vp_fix_geometry(struct mxr_layer *layer,
> -	enum mxr_geometry_stage stage, unsigned long flags)
> -{
> -	struct mxr_geometry *geo = &layer->geo;
> -	struct mxr_crop *src = &geo->src;
> -	struct mxr_crop *dst = &geo->dst;
> -	unsigned long x_center, y_center;
> -
> -	switch (stage) {
> -
> -	case MXR_GEOMETRY_SINK: /* nothing to be fixed here */
> -	case MXR_GEOMETRY_COMPOSE:
> -		/* remember center of the area */
> -		x_center = dst->x_offset + dst->width / 2;
> -		y_center = dst->y_offset + dst->height / 2;
> -
> -		/* ensure that compose is reachable using 16x scaling */
> -		dst->width = clamp(dst->width, 8U, 16 * src->full_width);
> -		dst->height = clamp(dst->height, 1U, 16 * src->full_height);
> -
> -		/* setup offsets */
> -		dst->x_offset = do_center(x_center, dst->width,
> -			dst->full_width, flags);
> -		dst->y_offset = do_center(y_center, dst->height,
> -			dst->full_height, flags);
> -		flags = 0; /* remove possible MXR_NO_OFFSET flag */
> -		/* fall through */
> -	case MXR_GEOMETRY_CROP:
> -		/* remember center of the area */
> -		x_center = src->x_offset + src->width / 2;
> -		y_center = src->y_offset + src->height / 2;
> -
> -		/* ensure scaling is between 0.25x .. 16x */
> -		src->width = clamp(src->width, round_up(dst->width / 16, 4),
> -			dst->width * 4);
> -		src->height = clamp(src->height, round_up(dst->height / 16, 4),
> -			dst->height * 4);
> -
> -		/* hardware limits */
> -		src->width = clamp(src->width, 32U, 2047U);
> -		src->height = clamp(src->height, 4U, 2047U);
> -
> -		/* setup offsets */
> -		src->x_offset = do_center(x_center, src->width,
> -			src->full_width, flags);
> -		src->y_offset = do_center(y_center, src->height,
> -			src->full_height, flags);
> -
> -		/* setting scaling ratio */
> -		geo->x_ratio = (src->width << 16) / dst->width;
> -		geo->y_ratio = (src->height << 16) / dst->height;
> -		/* fall through */
> -
> -	case MXR_GEOMETRY_SOURCE:
> -		src->full_width = clamp(src->full_width,
> -			ALIGN(src->width + src->x_offset, 8), 8192U);
> -		src->full_height = clamp(src->full_height,
> -			src->height + src->y_offset, 8192U);
> -	}
> -}
> -
> -/* PUBLIC API */
> -
> -struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx)
> -{
> -	struct mxr_layer *layer;
> -	int ret;
> -	const struct mxr_layer_ops ops = {
> -		.release = mxr_vp_layer_release,
> -		.buffer_set = mxr_vp_buffer_set,
> -		.stream_set = mxr_vp_stream_set,
> -		.format_set = mxr_vp_format_set,
> -		.fix_geometry = mxr_vp_fix_geometry,
> -	};
> -	char name[32];
> -
> -	sprintf(name, "video%d", idx);
> -
> -	layer = mxr_base_layer_create(mdev, idx, name, &ops);
> -	if (layer == NULL) {
> -		mxr_err(mdev, "failed to initialize layer(%d) base\n", idx);
> -		goto fail;
> -	}
> -
> -	layer->fmt_array = mxr_video_format;
> -	layer->fmt_array_size = ARRAY_SIZE(mxr_video_format);
> -
> -	ret = mxr_base_layer_register(layer);
> -	if (ret)
> -		goto fail_layer;
> -
> -	return layer;
> -
> -fail_layer:
> -	mxr_base_layer_release(layer);
> -
> -fail:
> -	return NULL;
> -}
> -
> diff --git a/drivers/media/platform/s5p-tv/regs-hdmi.h b/drivers/media/platform/s5p-tv/regs-hdmi.h
> deleted file mode 100644
> index a889d1f..0000000
> --- a/drivers/media/platform/s5p-tv/regs-hdmi.h
> +++ /dev/null
> @@ -1,146 +0,0 @@
> -/* linux/arch/arm/mach-exynos4/include/mach/regs-hdmi.h
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - * http://www.samsung.com/
> - *
> - * HDMI register header file for Samsung TVOUT driver
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> -*/
> -
> -#ifndef SAMSUNG_REGS_HDMI_H
> -#define SAMSUNG_REGS_HDMI_H
> -
> -/*
> - * Register part
> -*/
> -
> -#define HDMI_CTRL_BASE(x)		((x) + 0x00000000)
> -#define HDMI_CORE_BASE(x)		((x) + 0x00010000)
> -#define HDMI_TG_BASE(x)			((x) + 0x00050000)
> -
> -/* Control registers */
> -#define HDMI_INTC_CON			HDMI_CTRL_BASE(0x0000)
> -#define HDMI_INTC_FLAG			HDMI_CTRL_BASE(0x0004)
> -#define HDMI_HPD_STATUS			HDMI_CTRL_BASE(0x000C)
> -#define HDMI_PHY_RSTOUT			HDMI_CTRL_BASE(0x0014)
> -#define HDMI_PHY_VPLL			HDMI_CTRL_BASE(0x0018)
> -#define HDMI_PHY_CMU			HDMI_CTRL_BASE(0x001C)
> -#define HDMI_CORE_RSTOUT		HDMI_CTRL_BASE(0x0020)
> -
> -/* Core registers */
> -#define HDMI_CON_0			HDMI_CORE_BASE(0x0000)
> -#define HDMI_CON_1			HDMI_CORE_BASE(0x0004)
> -#define HDMI_CON_2			HDMI_CORE_BASE(0x0008)
> -#define HDMI_SYS_STATUS			HDMI_CORE_BASE(0x0010)
> -#define HDMI_PHY_STATUS			HDMI_CORE_BASE(0x0014)
> -#define HDMI_STATUS_EN			HDMI_CORE_BASE(0x0020)
> -#define HDMI_HPD			HDMI_CORE_BASE(0x0030)
> -#define HDMI_MODE_SEL			HDMI_CORE_BASE(0x0040)
> -#define HDMI_BLUE_SCREEN_0		HDMI_CORE_BASE(0x0050)
> -#define HDMI_BLUE_SCREEN_1		HDMI_CORE_BASE(0x0054)
> -#define HDMI_BLUE_SCREEN_2		HDMI_CORE_BASE(0x0058)
> -#define HDMI_H_BLANK_0			HDMI_CORE_BASE(0x00A0)
> -#define HDMI_H_BLANK_1			HDMI_CORE_BASE(0x00A4)
> -#define HDMI_V_BLANK_0			HDMI_CORE_BASE(0x00B0)
> -#define HDMI_V_BLANK_1			HDMI_CORE_BASE(0x00B4)
> -#define HDMI_V_BLANK_2			HDMI_CORE_BASE(0x00B8)
> -#define HDMI_H_V_LINE_0			HDMI_CORE_BASE(0x00C0)
> -#define HDMI_H_V_LINE_1			HDMI_CORE_BASE(0x00C4)
> -#define HDMI_H_V_LINE_2			HDMI_CORE_BASE(0x00C8)
> -#define HDMI_VSYNC_POL			HDMI_CORE_BASE(0x00E4)
> -#define HDMI_INT_PRO_MODE		HDMI_CORE_BASE(0x00E8)
> -#define HDMI_V_BLANK_F_0		HDMI_CORE_BASE(0x0110)
> -#define HDMI_V_BLANK_F_1		HDMI_CORE_BASE(0x0114)
> -#define HDMI_V_BLANK_F_2		HDMI_CORE_BASE(0x0118)
> -#define HDMI_H_SYNC_GEN_0		HDMI_CORE_BASE(0x0120)
> -#define HDMI_H_SYNC_GEN_1		HDMI_CORE_BASE(0x0124)
> -#define HDMI_H_SYNC_GEN_2		HDMI_CORE_BASE(0x0128)
> -#define HDMI_V_SYNC_GEN_1_0		HDMI_CORE_BASE(0x0130)
> -#define HDMI_V_SYNC_GEN_1_1		HDMI_CORE_BASE(0x0134)
> -#define HDMI_V_SYNC_GEN_1_2		HDMI_CORE_BASE(0x0138)
> -#define HDMI_V_SYNC_GEN_2_0		HDMI_CORE_BASE(0x0140)
> -#define HDMI_V_SYNC_GEN_2_1		HDMI_CORE_BASE(0x0144)
> -#define HDMI_V_SYNC_GEN_2_2		HDMI_CORE_BASE(0x0148)
> -#define HDMI_V_SYNC_GEN_3_0		HDMI_CORE_BASE(0x0150)
> -#define HDMI_V_SYNC_GEN_3_1		HDMI_CORE_BASE(0x0154)
> -#define HDMI_V_SYNC_GEN_3_2		HDMI_CORE_BASE(0x0158)
> -#define HDMI_AVI_CON			HDMI_CORE_BASE(0x0300)
> -#define HDMI_AVI_BYTE(n)		HDMI_CORE_BASE(0x0320 + 4 * (n))
> -#define	HDMI_DC_CONTROL			HDMI_CORE_BASE(0x05C0)
> -#define HDMI_VIDEO_PATTERN_GEN		HDMI_CORE_BASE(0x05C4)
> -#define HDMI_HPD_GEN			HDMI_CORE_BASE(0x05C8)
> -
> -/* Timing generator registers */
> -#define HDMI_TG_CMD			HDMI_TG_BASE(0x0000)
> -#define HDMI_TG_H_FSZ_L			HDMI_TG_BASE(0x0018)
> -#define HDMI_TG_H_FSZ_H			HDMI_TG_BASE(0x001C)
> -#define HDMI_TG_HACT_ST_L		HDMI_TG_BASE(0x0020)
> -#define HDMI_TG_HACT_ST_H		HDMI_TG_BASE(0x0024)
> -#define HDMI_TG_HACT_SZ_L		HDMI_TG_BASE(0x0028)
> -#define HDMI_TG_HACT_SZ_H		HDMI_TG_BASE(0x002C)
> -#define HDMI_TG_V_FSZ_L			HDMI_TG_BASE(0x0030)
> -#define HDMI_TG_V_FSZ_H			HDMI_TG_BASE(0x0034)
> -#define HDMI_TG_VSYNC_L			HDMI_TG_BASE(0x0038)
> -#define HDMI_TG_VSYNC_H			HDMI_TG_BASE(0x003C)
> -#define HDMI_TG_VSYNC2_L		HDMI_TG_BASE(0x0040)
> -#define HDMI_TG_VSYNC2_H		HDMI_TG_BASE(0x0044)
> -#define HDMI_TG_VACT_ST_L		HDMI_TG_BASE(0x0048)
> -#define HDMI_TG_VACT_ST_H		HDMI_TG_BASE(0x004C)
> -#define HDMI_TG_VACT_SZ_L		HDMI_TG_BASE(0x0050)
> -#define HDMI_TG_VACT_SZ_H		HDMI_TG_BASE(0x0054)
> -#define HDMI_TG_FIELD_CHG_L		HDMI_TG_BASE(0x0058)
> -#define HDMI_TG_FIELD_CHG_H		HDMI_TG_BASE(0x005C)
> -#define HDMI_TG_VACT_ST2_L		HDMI_TG_BASE(0x0060)
> -#define HDMI_TG_VACT_ST2_H		HDMI_TG_BASE(0x0064)
> -#define HDMI_TG_VSYNC_TOP_HDMI_L	HDMI_TG_BASE(0x0078)
> -#define HDMI_TG_VSYNC_TOP_HDMI_H	HDMI_TG_BASE(0x007C)
> -#define HDMI_TG_VSYNC_BOT_HDMI_L	HDMI_TG_BASE(0x0080)
> -#define HDMI_TG_VSYNC_BOT_HDMI_H	HDMI_TG_BASE(0x0084)
> -#define HDMI_TG_FIELD_TOP_HDMI_L	HDMI_TG_BASE(0x0088)
> -#define HDMI_TG_FIELD_TOP_HDMI_H	HDMI_TG_BASE(0x008C)
> -#define HDMI_TG_FIELD_BOT_HDMI_L	HDMI_TG_BASE(0x0090)
> -#define HDMI_TG_FIELD_BOT_HDMI_H	HDMI_TG_BASE(0x0094)
> -
> -/*
> - * Bit definition part
> - */
> -
> -/* HDMI_INTC_CON */
> -#define HDMI_INTC_EN_GLOBAL		(1 << 6)
> -#define HDMI_INTC_EN_HPD_PLUG		(1 << 3)
> -#define HDMI_INTC_EN_HPD_UNPLUG		(1 << 2)
> -
> -/* HDMI_INTC_FLAG */
> -#define HDMI_INTC_FLAG_HPD_PLUG		(1 << 3)
> -#define HDMI_INTC_FLAG_HPD_UNPLUG	(1 << 2)
> -
> -/* HDMI_PHY_RSTOUT */
> -#define HDMI_PHY_SW_RSTOUT		(1 << 0)
> -
> -/* HDMI_CORE_RSTOUT */
> -#define HDMI_CORE_SW_RSTOUT		(1 << 0)
> -
> -/* HDMI_CON_0 */
> -#define HDMI_BLUE_SCR_EN		(1 << 5)
> -#define HDMI_EN				(1 << 0)
> -
> -/* HDMI_CON_2 */
> -#define HDMI_DVI_PERAMBLE_EN		(1 << 5)
> -#define HDMI_DVI_BAND_EN		(1 << 1)
> -
> -/* HDMI_PHY_STATUS */
> -#define HDMI_PHY_STATUS_READY		(1 << 0)
> -
> -/* HDMI_MODE_SEL */
> -#define HDMI_MODE_HDMI_EN		(1 << 1)
> -#define HDMI_MODE_DVI_EN		(1 << 0)
> -#define HDMI_MODE_MASK			(3 << 0)
> -
> -/* HDMI_TG_CMD */
> -#define HDMI_TG_FIELD_EN		(1 << 1)
> -#define HDMI_TG_EN			(1 << 0)
> -
> -#endif /* SAMSUNG_REGS_HDMI_H */
> diff --git a/drivers/media/platform/s5p-tv/regs-mixer.h b/drivers/media/platform/s5p-tv/regs-mixer.h
> deleted file mode 100644
> index 158abb4..0000000
> --- a/drivers/media/platform/s5p-tv/regs-mixer.h
> +++ /dev/null
> @@ -1,122 +0,0 @@
> -/*
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - * http://www.samsung.com/
> - *
> - * Mixer register header file for Samsung Mixer driver
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> -*/
> -#ifndef SAMSUNG_REGS_MIXER_H
> -#define SAMSUNG_REGS_MIXER_H
> -
> -/*
> - * Register part
> - */
> -#define MXR_STATUS			0x0000
> -#define MXR_CFG				0x0004
> -#define MXR_INT_EN			0x0008
> -#define MXR_INT_STATUS			0x000C
> -#define MXR_LAYER_CFG			0x0010
> -#define MXR_VIDEO_CFG			0x0014
> -#define MXR_GRAPHIC0_CFG		0x0020
> -#define MXR_GRAPHIC0_BASE		0x0024
> -#define MXR_GRAPHIC0_SPAN		0x0028
> -#define MXR_GRAPHIC0_SXY		0x002C
> -#define MXR_GRAPHIC0_WH			0x0030
> -#define MXR_GRAPHIC0_DXY		0x0034
> -#define MXR_GRAPHIC0_BLANK		0x0038
> -#define MXR_GRAPHIC1_CFG		0x0040
> -#define MXR_GRAPHIC1_BASE		0x0044
> -#define MXR_GRAPHIC1_SPAN		0x0048
> -#define MXR_GRAPHIC1_SXY		0x004C
> -#define MXR_GRAPHIC1_WH			0x0050
> -#define MXR_GRAPHIC1_DXY		0x0054
> -#define MXR_GRAPHIC1_BLANK		0x0058
> -#define MXR_BG_CFG			0x0060
> -#define MXR_BG_COLOR0			0x0064
> -#define MXR_BG_COLOR1			0x0068
> -#define MXR_BG_COLOR2			0x006C
> -
> -/* for parametrized access to layer registers */
> -#define MXR_GRAPHIC_CFG(i)		(0x0020 + (i) * 0x20)
> -#define MXR_GRAPHIC_BASE(i)		(0x0024 + (i) * 0x20)
> -#define MXR_GRAPHIC_SPAN(i)		(0x0028 + (i) * 0x20)
> -#define MXR_GRAPHIC_SXY(i)		(0x002C + (i) * 0x20)
> -#define MXR_GRAPHIC_WH(i)		(0x0030 + (i) * 0x20)
> -#define MXR_GRAPHIC_DXY(i)		(0x0034 + (i) * 0x20)
> -
> -/*
> - * Bit definition part
> - */
> -
> -/* generates mask for range of bits */
> -#define MXR_MASK(high_bit, low_bit) \
> -	(((2 << ((high_bit) - (low_bit))) - 1) << (low_bit))
> -
> -#define MXR_MASK_VAL(val, high_bit, low_bit) \
> -	(((val) << (low_bit)) & MXR_MASK(high_bit, low_bit))
> -
> -/* bits for MXR_STATUS */
> -#define MXR_STATUS_16_BURST		(1 << 7)
> -#define MXR_STATUS_BURST_MASK		(1 << 7)
> -#define MXR_STATUS_SYNC_ENABLE		(1 << 2)
> -#define MXR_STATUS_REG_RUN		(1 << 0)
> -
> -/* bits for MXR_CFG */
> -#define MXR_CFG_OUT_YUV444		(0 << 8)
> -#define MXR_CFG_OUT_RGB888		(1 << 8)
> -#define MXR_CFG_OUT_MASK		(1 << 8)
> -#define MXR_CFG_DST_SDO			(0 << 7)
> -#define MXR_CFG_DST_HDMI		(1 << 7)
> -#define MXR_CFG_DST_MASK		(1 << 7)
> -#define MXR_CFG_SCAN_HD_720		(0 << 6)
> -#define MXR_CFG_SCAN_HD_1080		(1 << 6)
> -#define MXR_CFG_GRP1_ENABLE		(1 << 5)
> -#define MXR_CFG_GRP0_ENABLE		(1 << 4)
> -#define MXR_CFG_VP_ENABLE		(1 << 3)
> -#define MXR_CFG_SCAN_INTERLACE		(0 << 2)
> -#define MXR_CFG_SCAN_PROGRASSIVE	(1 << 2)
> -#define MXR_CFG_SCAN_NTSC		(0 << 1)
> -#define MXR_CFG_SCAN_PAL		(1 << 1)
> -#define MXR_CFG_SCAN_SD			(0 << 0)
> -#define MXR_CFG_SCAN_HD			(1 << 0)
> -#define MXR_CFG_SCAN_MASK		0x47
> -
> -/* bits for MXR_GRAPHICn_CFG */
> -#define MXR_GRP_CFG_COLOR_KEY_DISABLE	(1 << 21)
> -#define MXR_GRP_CFG_BLEND_PRE_MUL	(1 << 20)
> -#define MXR_GRP_CFG_FORMAT_VAL(x)	MXR_MASK_VAL(x, 11, 8)
> -#define MXR_GRP_CFG_FORMAT_MASK		MXR_GRP_CFG_FORMAT_VAL(~0)
> -#define MXR_GRP_CFG_ALPHA_VAL(x)	MXR_MASK_VAL(x, 7, 0)
> -
> -/* bits for MXR_GRAPHICn_WH */
> -#define MXR_GRP_WH_H_SCALE(x)		MXR_MASK_VAL(x, 28, 28)
> -#define MXR_GRP_WH_V_SCALE(x)		MXR_MASK_VAL(x, 12, 12)
> -#define MXR_GRP_WH_WIDTH(x)		MXR_MASK_VAL(x, 26, 16)
> -#define MXR_GRP_WH_HEIGHT(x)		MXR_MASK_VAL(x, 10, 0)
> -
> -/* bits for MXR_GRAPHICn_SXY */
> -#define MXR_GRP_SXY_SX(x)		MXR_MASK_VAL(x, 26, 16)
> -#define MXR_GRP_SXY_SY(x)		MXR_MASK_VAL(x, 10, 0)
> -
> -/* bits for MXR_GRAPHICn_DXY */
> -#define MXR_GRP_DXY_DX(x)		MXR_MASK_VAL(x, 26, 16)
> -#define MXR_GRP_DXY_DY(x)		MXR_MASK_VAL(x, 10, 0)
> -
> -/* bits for MXR_INT_EN */
> -#define MXR_INT_EN_VSYNC		(1 << 11)
> -#define MXR_INT_EN_ALL			(0x0f << 8)
> -
> -/* bit for MXR_INT_STATUS */
> -#define MXR_INT_CLEAR_VSYNC		(1 << 11)
> -#define MXR_INT_STATUS_VSYNC		(1 << 0)
> -
> -/* bit for MXR_LAYER_CFG */
> -#define MXR_LAYER_CFG_GRP1_VAL(x)	MXR_MASK_VAL(x, 11, 8)
> -#define MXR_LAYER_CFG_GRP0_VAL(x)	MXR_MASK_VAL(x, 7, 4)
> -#define MXR_LAYER_CFG_VP_VAL(x)		MXR_MASK_VAL(x, 3, 0)
> -
> -#endif /* SAMSUNG_REGS_MIXER_H */
> -
> diff --git a/drivers/media/platform/s5p-tv/regs-sdo.h b/drivers/media/platform/s5p-tv/regs-sdo.h
> deleted file mode 100644
> index 6f22fbf..0000000
> --- a/drivers/media/platform/s5p-tv/regs-sdo.h
> +++ /dev/null
> @@ -1,63 +0,0 @@
> -/* drivers/media/platform/s5p-tv/regs-sdo.h
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *		http://www.samsung.com/
> - *
> - * SDO register description file
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#ifndef SAMSUNG_REGS_SDO_H
> -#define SAMSUNG_REGS_SDO_H
> -
> -/*
> - * Register part
> - */
> -
> -#define SDO_CLKCON			0x0000
> -#define SDO_CONFIG			0x0008
> -#define SDO_VBI				0x0014
> -#define SDO_DAC				0x003C
> -#define SDO_CCCON			0x0180
> -#define SDO_IRQ				0x0280
> -#define SDO_IRQMASK			0x0284
> -#define SDO_VERSION			0x03D8
> -
> -/*
> - * Bit definition part
> - */
> -
> -/* SDO Clock Control Register (SDO_CLKCON) */
> -#define SDO_TVOUT_SW_RESET		(1 << 4)
> -#define SDO_TVOUT_CLOCK_READY		(1 << 1)
> -#define SDO_TVOUT_CLOCK_ON		(1 << 0)
> -
> -/* SDO Video Standard Configuration Register (SDO_CONFIG) */
> -#define SDO_PROGRESSIVE			(1 << 4)
> -#define SDO_NTSC_M			0
> -#define SDO_PAL_M			1
> -#define SDO_PAL_BGHID			2
> -#define SDO_PAL_N			3
> -#define SDO_PAL_NC			4
> -#define SDO_NTSC_443			8
> -#define SDO_PAL_60			9
> -#define SDO_STANDARD_MASK		0xf
> -
> -/* SDO VBI Configuration Register (SDO_VBI) */
> -#define SDO_CVBS_WSS_INS		(1 << 14)
> -#define SDO_CVBS_CLOSED_CAPTION_MASK	(3 << 12)
> -
> -/* SDO DAC Configuration Register (SDO_DAC) */
> -#define SDO_POWER_ON_DAC		(1 << 0)
> -
> -/* SDO Color Compensation On/Off Control (SDO_CCCON) */
> -#define SDO_COMPENSATION_BHS_ADJ_OFF	(1 << 4)
> -#define SDO_COMPENSATION_CVBS_COMP_OFF	(1 << 0)
> -
> -/* SDO Interrupt Request Register (SDO_IRQ) */
> -#define SDO_VSYNC_IRQ_PEND		(1 << 0)
> -
> -#endif /* SAMSUNG_REGS_SDO_H */
> diff --git a/drivers/media/platform/s5p-tv/regs-vp.h b/drivers/media/platform/s5p-tv/regs-vp.h
> deleted file mode 100644
> index 6c63984..0000000
> --- a/drivers/media/platform/s5p-tv/regs-vp.h
> +++ /dev/null
> @@ -1,88 +0,0 @@
> -/*
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *		http://www.samsung.com/
> - *
> - * Video processor register header file for Samsung Mixer driver
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#ifndef SAMSUNG_REGS_VP_H
> -#define SAMSUNG_REGS_VP_H
> -
> -/*
> - * Register part
> - */
> -
> -#define VP_ENABLE			0x0000
> -#define VP_SRESET			0x0004
> -#define VP_SHADOW_UPDATE		0x0008
> -#define VP_FIELD_ID			0x000C
> -#define VP_MODE				0x0010
> -#define VP_IMG_SIZE_Y			0x0014
> -#define VP_IMG_SIZE_C			0x0018
> -#define VP_PER_RATE_CTRL		0x001C
> -#define VP_TOP_Y_PTR			0x0028
> -#define VP_BOT_Y_PTR			0x002C
> -#define VP_TOP_C_PTR			0x0030
> -#define VP_BOT_C_PTR			0x0034
> -#define VP_ENDIAN_MODE			0x03CC
> -#define VP_SRC_H_POSITION		0x0044
> -#define VP_SRC_V_POSITION		0x0048
> -#define VP_SRC_WIDTH			0x004C
> -#define VP_SRC_HEIGHT			0x0050
> -#define VP_DST_H_POSITION		0x0054
> -#define VP_DST_V_POSITION		0x0058
> -#define VP_DST_WIDTH			0x005C
> -#define VP_DST_HEIGHT			0x0060
> -#define VP_H_RATIO			0x0064
> -#define VP_V_RATIO			0x0068
> -#define VP_POLY8_Y0_LL			0x006C
> -#define VP_POLY4_Y0_LL			0x00EC
> -#define VP_POLY4_C0_LL			0x012C
> -
> -/*
> - * Bit definition part
> - */
> -
> -/* generates mask for range of bits */
> -
> -#define VP_MASK(high_bit, low_bit) \
> -	(((2 << ((high_bit) - (low_bit))) - 1) << (low_bit))
> -
> -#define VP_MASK_VAL(val, high_bit, low_bit) \
> -	(((val) << (low_bit)) & VP_MASK(high_bit, low_bit))
> -
> - /* VP_ENABLE */
> -#define VP_ENABLE_ON			(1 << 0)
> -
> -/* VP_SRESET */
> -#define VP_SRESET_PROCESSING		(1 << 0)
> -
> -/* VP_SHADOW_UPDATE */
> -#define VP_SHADOW_UPDATE_ENABLE		(1 << 0)
> -
> -/* VP_MODE */
> -#define VP_MODE_NV12			(0 << 6)
> -#define VP_MODE_NV21			(1 << 6)
> -#define VP_MODE_LINE_SKIP		(1 << 5)
> -#define VP_MODE_MEM_LINEAR		(0 << 4)
> -#define VP_MODE_MEM_TILED		(1 << 4)
> -#define VP_MODE_FMT_MASK		(5 << 4)
> -#define VP_MODE_FIELD_ID_AUTO_TOGGLING	(1 << 2)
> -#define VP_MODE_2D_IPC			(1 << 1)
> -
> -/* VP_IMG_SIZE_Y */
> -/* VP_IMG_SIZE_C */
> -#define VP_IMG_HSIZE(x)			VP_MASK_VAL(x, 29, 16)
> -#define VP_IMG_VSIZE(x)			VP_MASK_VAL(x, 13, 0)
> -
> -/* VP_SRC_H_POSITION */
> -#define VP_SRC_H_POSITION_VAL(x)	VP_MASK_VAL(x, 14, 4)
> -
> -/* VP_ENDIAN_MODE */
> -#define VP_ENDIAN_MODE_LITTLE		(1 << 0)
> -
> -#endif /* SAMSUNG_REGS_VP_H */
> diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
> deleted file mode 100644
> index c75d435..0000000
> --- a/drivers/media/platform/s5p-tv/sdo_drv.c
> +++ /dev/null
> @@ -1,497 +0,0 @@
> -/*
> - * Samsung Standard Definition Output (SDO) driver
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *
> - * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published
> - * by the Free Software Foundiation. either version 2 of the License,
> - * or (at your option) any later version
> - */
> -
> -#include <linux/clk.h>
> -#include <linux/delay.h>
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/interrupt.h>
> -#include <linux/io.h>
> -#include <linux/irq.h>
> -#include <linux/platform_device.h>
> -#include <linux/pm_runtime.h>
> -#include <linux/regulator/consumer.h>
> -#include <linux/slab.h>
> -
> -#include <media/v4l2-subdev.h>
> -
> -#include "regs-sdo.h"
> -
> -MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
> -MODULE_DESCRIPTION("Samsung Standard Definition Output (SDO)");
> -MODULE_LICENSE("GPL");
> -
> -#define SDO_DEFAULT_STD	V4L2_STD_PAL
> -
> -struct sdo_format {
> -	v4l2_std_id id;
> -	/* all modes are 720 pixels wide */
> -	unsigned int height;
> -	unsigned int cookie;
> -};
> -
> -struct sdo_device {
> -	/** pointer to device parent */
> -	struct device *dev;
> -	/** base address of SDO registers */
> -	void __iomem *regs;
> -	/** SDO interrupt */
> -	unsigned int irq;
> -	/** DAC source clock */
> -	struct clk *sclk_dac;
> -	/** DAC clock */
> -	struct clk *dac;
> -	/** DAC physical interface */
> -	struct clk *dacphy;
> -	/** clock for control of VPLL */
> -	struct clk *fout_vpll;
> -	/** vpll rate before sdo stream was on */
> -	unsigned long vpll_rate;
> -	/** regulator for SDO IP power */
> -	struct regulator *vdac;
> -	/** regulator for SDO plug detection */
> -	struct regulator *vdet;
> -	/** subdev used as device interface */
> -	struct v4l2_subdev sd;
> -	/** current format */
> -	const struct sdo_format *fmt;
> -};
> -
> -static inline struct sdo_device *sd_to_sdev(struct v4l2_subdev *sd)
> -{
> -	return container_of(sd, struct sdo_device, sd);
> -}
> -
> -static inline
> -void sdo_write_mask(struct sdo_device *sdev, u32 reg_id, u32 value, u32 mask)
> -{
> -	u32 old = readl(sdev->regs + reg_id);
> -	value = (value & mask) | (old & ~mask);
> -	writel(value, sdev->regs + reg_id);
> -}
> -
> -static inline
> -void sdo_write(struct sdo_device *sdev, u32 reg_id, u32 value)
> -{
> -	writel(value, sdev->regs + reg_id);
> -}
> -
> -static inline
> -u32 sdo_read(struct sdo_device *sdev, u32 reg_id)
> -{
> -	return readl(sdev->regs + reg_id);
> -}
> -
> -static irqreturn_t sdo_irq_handler(int irq, void *dev_data)
> -{
> -	struct sdo_device *sdev = dev_data;
> -
> -	/* clear interrupt */
> -	sdo_write_mask(sdev, SDO_IRQ, ~0, SDO_VSYNC_IRQ_PEND);
> -	return IRQ_HANDLED;
> -}
> -
> -static void sdo_reg_debug(struct sdo_device *sdev)
> -{
> -#define DBGREG(reg_id) \
> -	dev_info(sdev->dev, #reg_id " = %08x\n", \
> -		sdo_read(sdev, reg_id))
> -
> -	DBGREG(SDO_CLKCON);
> -	DBGREG(SDO_CONFIG);
> -	DBGREG(SDO_VBI);
> -	DBGREG(SDO_DAC);
> -	DBGREG(SDO_IRQ);
> -	DBGREG(SDO_IRQMASK);
> -	DBGREG(SDO_VERSION);
> -}
> -
> -static const struct sdo_format sdo_format[] = {
> -	{ V4L2_STD_PAL_N,	.height = 576, .cookie = SDO_PAL_N },
> -	{ V4L2_STD_PAL_Nc,	.height = 576, .cookie = SDO_PAL_NC },
> -	{ V4L2_STD_PAL_M,	.height = 480, .cookie = SDO_PAL_M },
> -	{ V4L2_STD_PAL_60,	.height = 480, .cookie = SDO_PAL_60 },
> -	{ V4L2_STD_NTSC_443,	.height = 480, .cookie = SDO_NTSC_443 },
> -	{ V4L2_STD_PAL,		.height = 576, .cookie = SDO_PAL_BGHID },
> -	{ V4L2_STD_NTSC_M,	.height = 480, .cookie = SDO_NTSC_M },
> -};
> -
> -static const struct sdo_format *sdo_find_format(v4l2_std_id id)
> -{
> -	int i;
> -	for (i = 0; i < ARRAY_SIZE(sdo_format); ++i)
> -		if (sdo_format[i].id & id)
> -			return &sdo_format[i];
> -	return NULL;
> -}
> -
> -static int sdo_g_tvnorms_output(struct v4l2_subdev *sd, v4l2_std_id *std)
> -{
> -	*std = V4L2_STD_NTSC_M | V4L2_STD_PAL_M | V4L2_STD_PAL |
> -		V4L2_STD_PAL_N | V4L2_STD_PAL_Nc |
> -		V4L2_STD_NTSC_443 | V4L2_STD_PAL_60;
> -	return 0;
> -}
> -
> -static int sdo_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
> -{
> -	struct sdo_device *sdev = sd_to_sdev(sd);
> -	const struct sdo_format *fmt;
> -	fmt = sdo_find_format(std);
> -	if (fmt == NULL)
> -		return -EINVAL;
> -	sdev->fmt = fmt;
> -	return 0;
> -}
> -
> -static int sdo_g_std_output(struct v4l2_subdev *sd, v4l2_std_id *std)
> -{
> -	*std = sd_to_sdev(sd)->fmt->id;
> -	return 0;
> -}
> -
> -static int sdo_get_fmt(struct v4l2_subdev *sd,
> -		struct v4l2_subdev_pad_config *cfg,
> -		struct v4l2_subdev_format *format)
> -{
> -	struct v4l2_mbus_framefmt *fmt = &format->format;
> -	struct sdo_device *sdev = sd_to_sdev(sd);
> -
> -	if (!sdev->fmt)
> -		return -ENXIO;
> -	if (format->pad)
> -		return -EINVAL;
> -	/* all modes are 720 pixels wide */
> -	fmt->width = 720;
> -	fmt->height = sdev->fmt->height;
> -	fmt->code = MEDIA_BUS_FMT_FIXED;
> -	fmt->field = V4L2_FIELD_INTERLACED;
> -	fmt->colorspace = V4L2_COLORSPACE_JPEG;
> -	return 0;
> -}
> -
> -static int sdo_s_power(struct v4l2_subdev *sd, int on)
> -{
> -	struct sdo_device *sdev = sd_to_sdev(sd);
> -	struct device *dev = sdev->dev;
> -	int ret;
> -
> -	dev_info(dev, "sdo_s_power(%d)\n", on);
> -
> -	if (on)
> -		ret = pm_runtime_get_sync(dev);
> -	else
> -		ret = pm_runtime_put_sync(dev);
> -
> -	/* only values < 0 indicate errors */
> -	return ret < 0 ? ret : 0;
> -}
> -
> -static int sdo_streamon(struct sdo_device *sdev)
> -{
> -	int ret;
> -
> -	/* set proper clock for Timing Generator */
> -	sdev->vpll_rate = clk_get_rate(sdev->fout_vpll);
> -	ret = clk_set_rate(sdev->fout_vpll, 54000000);
> -	if (ret < 0) {
> -		dev_err(sdev->dev, "Failed to set vpll rate\n");
> -		return ret;
> -	}
> -	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",
> -	clk_get_rate(sdev->fout_vpll));
> -	/* enable clock in SDO */
> -	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
> -	ret = clk_prepare_enable(sdev->dacphy);
> -	if (ret < 0) {
> -		dev_err(sdev->dev, "clk_prepare_enable(dacphy) failed\n");
> -		goto fail;
> -	}
> -	/* enable DAC */
> -	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
> -	sdo_reg_debug(sdev);
> -	return 0;
> -
> -fail:
> -	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
> -	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
> -	return ret;
> -}
> -
> -static int sdo_streamoff(struct sdo_device *sdev)
> -{
> -	int tries;
> -
> -	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
> -	clk_disable_unprepare(sdev->dacphy);
> -	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
> -	for (tries = 100; tries; --tries) {
> -		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
> -			break;
> -		mdelay(1);
> -	}
> -	if (tries == 0)
> -		dev_err(sdev->dev, "failed to stop streaming\n");
> -	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
> -	return tries ? 0 : -EIO;
> -}
> -
> -static int sdo_s_stream(struct v4l2_subdev *sd, int on)
> -{
> -	struct sdo_device *sdev = sd_to_sdev(sd);
> -	return on ? sdo_streamon(sdev) : sdo_streamoff(sdev);
> -}
> -
> -static const struct v4l2_subdev_core_ops sdo_sd_core_ops = {
> -	.s_power = sdo_s_power,
> -};
> -
> -static const struct v4l2_subdev_video_ops sdo_sd_video_ops = {
> -	.s_std_output = sdo_s_std_output,
> -	.g_std_output = sdo_g_std_output,
> -	.g_tvnorms_output = sdo_g_tvnorms_output,
> -	.s_stream = sdo_s_stream,
> -};
> -
> -static const struct v4l2_subdev_pad_ops sdo_sd_pad_ops = {
> -	.get_fmt = sdo_get_fmt,
> -};
> -
> -static const struct v4l2_subdev_ops sdo_sd_ops = {
> -	.core = &sdo_sd_core_ops,
> -	.video = &sdo_sd_video_ops,
> -	.pad = &sdo_sd_pad_ops,
> -};
> -
> -static int sdo_runtime_suspend(struct device *dev)
> -{
> -	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> -	struct sdo_device *sdev = sd_to_sdev(sd);
> -
> -	dev_info(dev, "suspend\n");
> -	regulator_disable(sdev->vdet);
> -	regulator_disable(sdev->vdac);
> -	clk_disable_unprepare(sdev->sclk_dac);
> -	return 0;
> -}
> -
> -static int sdo_runtime_resume(struct device *dev)
> -{
> -	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> -	struct sdo_device *sdev = sd_to_sdev(sd);
> -	int ret;
> -
> -	dev_info(dev, "resume\n");
> -
> -	ret = clk_prepare_enable(sdev->sclk_dac);
> -	if (ret < 0)
> -		return ret;
> -
> -	ret = regulator_enable(sdev->vdac);
> -	if (ret < 0)
> -		goto dac_clk_dis;
> -
> -	ret = regulator_enable(sdev->vdet);
> -	if (ret < 0)
> -		goto vdac_r_dis;
> -
> -	/* software reset */
> -	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_SW_RESET);
> -	mdelay(10);
> -	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_SW_RESET);
> -
> -	/* setting TV mode */
> -	sdo_write_mask(sdev, SDO_CONFIG, sdev->fmt->cookie, SDO_STANDARD_MASK);
> -	/* XXX: forcing interlaced mode using undocumented bit */
> -	sdo_write_mask(sdev, SDO_CONFIG, 0, SDO_PROGRESSIVE);
> -	/* turn all VBI off */
> -	sdo_write_mask(sdev, SDO_VBI, 0, SDO_CVBS_WSS_INS |
> -		SDO_CVBS_CLOSED_CAPTION_MASK);
> -	/* turn all post processing off */
> -	sdo_write_mask(sdev, SDO_CCCON, ~0, SDO_COMPENSATION_BHS_ADJ_OFF |
> -		SDO_COMPENSATION_CVBS_COMP_OFF);
> -	sdo_reg_debug(sdev);
> -	return 0;
> -
> -vdac_r_dis:
> -	regulator_disable(sdev->vdac);
> -dac_clk_dis:
> -	clk_disable_unprepare(sdev->sclk_dac);
> -	return ret;
> -}
> -
> -static const struct dev_pm_ops sdo_pm_ops = {
> -	.runtime_suspend = sdo_runtime_suspend,
> -	.runtime_resume	 = sdo_runtime_resume,
> -};
> -
> -static int sdo_probe(struct platform_device *pdev)
> -{
> -	struct device *dev = &pdev->dev;
> -	struct sdo_device *sdev;
> -	struct resource *res;
> -	int ret = 0;
> -	struct clk *sclk_vpll;
> -
> -	dev_info(dev, "probe start\n");
> -	sdev = devm_kzalloc(&pdev->dev, sizeof(*sdev), GFP_KERNEL);
> -	if (!sdev) {
> -		dev_err(dev, "not enough memory.\n");
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> -	sdev->dev = dev;
> -
> -	/* mapping registers */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (res == NULL) {
> -		dev_err(dev, "get memory resource failed.\n");
> -		ret = -ENXIO;
> -		goto fail;
> -	}
> -
> -	sdev->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> -	if (sdev->regs == NULL) {
> -		dev_err(dev, "register mapping failed.\n");
> -		ret = -ENXIO;
> -		goto fail;
> -	}
> -
> -	/* acquiring interrupt */
> -	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -	if (res == NULL) {
> -		dev_err(dev, "get interrupt resource failed.\n");
> -		ret = -ENXIO;
> -		goto fail;
> -	}
> -	ret = devm_request_irq(&pdev->dev, res->start, sdo_irq_handler, 0,
> -			       "s5p-sdo", sdev);
> -	if (ret) {
> -		dev_err(dev, "request interrupt failed.\n");
> -		goto fail;
> -	}
> -	sdev->irq = res->start;
> -
> -	/* acquire clocks */
> -	sdev->sclk_dac = clk_get(dev, "sclk_dac");
> -	if (IS_ERR(sdev->sclk_dac)) {
> -		dev_err(dev, "failed to get clock 'sclk_dac'\n");
> -		ret = PTR_ERR(sdev->sclk_dac);
> -		goto fail;
> -	}
> -	sdev->dac = clk_get(dev, "dac");
> -	if (IS_ERR(sdev->dac)) {
> -		dev_err(dev, "failed to get clock 'dac'\n");
> -		ret = PTR_ERR(sdev->dac);
> -		goto fail_sclk_dac;
> -	}
> -	sdev->dacphy = clk_get(dev, "dacphy");
> -	if (IS_ERR(sdev->dacphy)) {
> -		dev_err(dev, "failed to get clock 'dacphy'\n");
> -		ret = PTR_ERR(sdev->dacphy);
> -		goto fail_dac;
> -	}
> -	sclk_vpll = clk_get(dev, "sclk_vpll");
> -	if (IS_ERR(sclk_vpll)) {
> -		dev_err(dev, "failed to get clock 'sclk_vpll'\n");
> -		ret = PTR_ERR(sclk_vpll);
> -		goto fail_dacphy;
> -	}
> -	clk_set_parent(sdev->sclk_dac, sclk_vpll);
> -	clk_put(sclk_vpll);
> -	sdev->fout_vpll = clk_get(dev, "fout_vpll");
> -	if (IS_ERR(sdev->fout_vpll)) {
> -		dev_err(dev, "failed to get clock 'fout_vpll'\n");
> -		ret = PTR_ERR(sdev->fout_vpll);
> -		goto fail_dacphy;
> -	}
> -	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
> -
> -	/* acquire regulator */
> -	sdev->vdac = devm_regulator_get(dev, "vdd33a_dac");
> -	if (IS_ERR(sdev->vdac)) {
> -		dev_err(dev, "failed to get regulator 'vdac'\n");
> -		ret = PTR_ERR(sdev->vdac);
> -		goto fail_fout_vpll;
> -	}
> -	sdev->vdet = devm_regulator_get(dev, "vdet");
> -	if (IS_ERR(sdev->vdet)) {
> -		dev_err(dev, "failed to get regulator 'vdet'\n");
> -		ret = PTR_ERR(sdev->vdet);
> -		goto fail_fout_vpll;
> -	}
> -
> -	/* enable gate for dac clock, because mixer uses it */
> -	ret = clk_prepare_enable(sdev->dac);
> -	if (ret < 0) {
> -		dev_err(dev, "clk_prepare_enable(dac) failed\n");
> -		goto fail_fout_vpll;
> -	}
> -
> -	/* configure power management */
> -	pm_runtime_enable(dev);
> -
> -	/* configuration of interface subdevice */
> -	v4l2_subdev_init(&sdev->sd, &sdo_sd_ops);
> -	sdev->sd.owner = THIS_MODULE;
> -	strlcpy(sdev->sd.name, "s5p-sdo", sizeof(sdev->sd.name));
> -
> -	/* set default format */
> -	sdev->fmt = sdo_find_format(SDO_DEFAULT_STD);
> -	BUG_ON(sdev->fmt == NULL);
> -
> -	/* keeping subdev in device's private for use by other drivers */
> -	dev_set_drvdata(dev, &sdev->sd);
> -
> -	dev_info(dev, "probe succeeded\n");
> -	return 0;
> -
> -fail_fout_vpll:
> -	clk_put(sdev->fout_vpll);
> -fail_dacphy:
> -	clk_put(sdev->dacphy);
> -fail_dac:
> -	clk_put(sdev->dac);
> -fail_sclk_dac:
> -	clk_put(sdev->sclk_dac);
> -fail:
> -	dev_info(dev, "probe failed\n");
> -	return ret;
> -}
> -
> -static int sdo_remove(struct platform_device *pdev)
> -{
> -	struct v4l2_subdev *sd = dev_get_drvdata(&pdev->dev);
> -	struct sdo_device *sdev = sd_to_sdev(sd);
> -
> -	pm_runtime_disable(&pdev->dev);
> -	clk_disable_unprepare(sdev->dac);
> -	clk_put(sdev->fout_vpll);
> -	clk_put(sdev->dacphy);
> -	clk_put(sdev->dac);
> -	clk_put(sdev->sclk_dac);
> -
> -	dev_info(&pdev->dev, "remove successful\n");
> -	return 0;
> -}
> -
> -static struct platform_driver sdo_driver __refdata = {
> -	.probe = sdo_probe,
> -	.remove = sdo_remove,
> -	.driver = {
> -		.name = "s5p-sdo",
> -		.pm = &sdo_pm_ops,
> -	}
> -};
> -
> -module_platform_driver(sdo_driver);
> diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
> deleted file mode 100644
> index 0a97f9a..0000000
> --- a/drivers/media/platform/s5p-tv/sii9234_drv.c
> +++ /dev/null
> @@ -1,407 +0,0 @@
> -/*
> - * Samsung MHL interface driver
> - *
> - * Copyright (C) 2011 Samsung Electronics Co.Ltd
> - * Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
> - *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
> - */
> -
> -#include <linux/delay.h>
> -#include <linux/err.h>
> -#include <linux/freezer.h>
> -#include <linux/gpio.h>
> -#include <linux/i2c.h>
> -#include <linux/interrupt.h>
> -#include <linux/irq.h>
> -#include <linux/kthread.h>
> -#include <linux/module.h>
> -#include <linux/pm_runtime.h>
> -#include <linux/regulator/machine.h>
> -#include <linux/slab.h>
> -
> -#include <linux/platform_data/media/sii9234.h>
> -#include <media/v4l2-subdev.h>
> -
> -MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
> -MODULE_DESCRIPTION("Samsung MHL interface driver");
> -MODULE_LICENSE("GPL");
> -
> -struct sii9234_context {
> -	struct i2c_client *client;
> -	struct regulator *power;
> -	int gpio_n_reset;
> -	struct v4l2_subdev sd;
> -};
> -
> -static inline struct sii9234_context *sd_to_context(struct v4l2_subdev *sd)
> -{
> -	return container_of(sd, struct sii9234_context, sd);
> -}
> -
> -static inline int sii9234_readb(struct i2c_client *client, int addr)
> -{
> -	return i2c_smbus_read_byte_data(client, addr);
> -}
> -
> -static inline int sii9234_writeb(struct i2c_client *client, int addr, int value)
> -{
> -	return i2c_smbus_write_byte_data(client, addr, value);
> -}
> -
> -static inline int sii9234_writeb_mask(struct i2c_client *client, int addr,
> -	int value, int mask)
> -{
> -	int ret;
> -
> -	ret = i2c_smbus_read_byte_data(client, addr);
> -	if (ret < 0)
> -		return ret;
> -	ret = (ret & ~mask) | (value & mask);
> -	return i2c_smbus_write_byte_data(client, addr, ret);
> -}
> -
> -static inline int sii9234_readb_idx(struct i2c_client *client, int addr)
> -{
> -	int ret;
> -	ret = i2c_smbus_write_byte_data(client, 0xbc, addr >> 8);
> -	if (ret < 0)
> -		return ret;
> -	ret = i2c_smbus_write_byte_data(client, 0xbd, addr & 0xff);
> -	if (ret < 0)
> -		return ret;
> -	return i2c_smbus_read_byte_data(client, 0xbe);
> -}
> -
> -static inline int sii9234_writeb_idx(struct i2c_client *client, int addr,
> -	int value)
> -{
> -	int ret;
> -	ret = i2c_smbus_write_byte_data(client, 0xbc, addr >> 8);
> -	if (ret < 0)
> -		return ret;
> -	ret = i2c_smbus_write_byte_data(client, 0xbd, addr & 0xff);
> -	if (ret < 0)
> -		return ret;
> -	ret = i2c_smbus_write_byte_data(client, 0xbe, value);
> -	return ret;
> -}
> -
> -static inline int sii9234_writeb_idx_mask(struct i2c_client *client, int addr,
> -	int value, int mask)
> -{
> -	int ret;
> -
> -	ret = sii9234_readb_idx(client, addr);
> -	if (ret < 0)
> -		return ret;
> -	ret = (ret & ~mask) | (value & mask);
> -	return sii9234_writeb_idx(client, addr, ret);
> -}
> -
> -static int sii9234_reset(struct sii9234_context *ctx)
> -{
> -	struct i2c_client *client = ctx->client;
> -	struct device *dev = &client->dev;
> -	int ret, tries;
> -
> -	gpio_direction_output(ctx->gpio_n_reset, 1);
> -	mdelay(1);
> -	gpio_direction_output(ctx->gpio_n_reset, 0);
> -	mdelay(1);
> -	gpio_direction_output(ctx->gpio_n_reset, 1);
> -	mdelay(1);
> -
> -	/* going to TTPI mode */
> -	ret = sii9234_writeb(client, 0xc7, 0);
> -	if (ret < 0) {
> -		dev_err(dev, "failed to set TTPI mode\n");
> -		return ret;
> -	}
> -	for (tries = 0; tries < 100 ; ++tries) {
> -		ret = sii9234_readb(client, 0x1b);
> -		if (ret > 0)
> -			break;
> -		if (ret < 0) {
> -			dev_err(dev, "failed to reset device\n");
> -			return -EIO;
> -		}
> -		mdelay(1);
> -	}
> -	if (tries == 100) {
> -		dev_err(dev, "maximal number of tries reached\n");
> -		return -EIO;
> -	}
> -
> -	return 0;
> -}
> -
> -static int sii9234_verify_version(struct i2c_client *client)
> -{
> -	struct device *dev = &client->dev;
> -	int family, rev, tpi_rev, dev_id, sub_id, hdcp, id;
> -
> -	family = sii9234_readb(client, 0x1b);
> -	rev = sii9234_readb(client, 0x1c) & 0x0f;
> -	tpi_rev = sii9234_readb(client, 0x1d) & 0x7f;
> -	dev_id = sii9234_readb_idx(client, 0x0103);
> -	sub_id = sii9234_readb_idx(client, 0x0102);
> -	hdcp = sii9234_readb(client, 0x30);
> -
> -	if (family < 0 || rev < 0 || tpi_rev < 0 || dev_id < 0 ||
> -		sub_id < 0 || hdcp < 0) {
> -		dev_err(dev, "failed to read chip's version\n");
> -		return -EIO;
> -	}
> -
> -	id = (dev_id << 8) | sub_id;
> -
> -	dev_info(dev, "chip: SiL%02x family: %02x, rev: %02x\n",
> -		id, family, rev);
> -	dev_info(dev, "tpi_rev:%02x, hdcp: %02x\n", tpi_rev, hdcp);
> -	if (id != 0x9234) {
> -		dev_err(dev, "not supported chip\n");
> -		return -ENODEV;
> -	}
> -
> -	return 0;
> -}
> -
> -static u8 data[][3] = {
> -/* setup from driver created by doonsoo45.kim */
> -	{ 0x01, 0x05, 0x04 }, /* Enable Auto soft reset on SCDT = 0 */
> -	{ 0x01, 0x08, 0x35 }, /* Power Up TMDS Tx Core */
> -	{ 0x01, 0x0d, 0x1c }, /* HDMI Transcode mode enable */
> -	{ 0x01, 0x2b, 0x01 }, /* Enable HDCP Compliance workaround */
> -	{ 0x01, 0x79, 0x40 }, /* daniel test...MHL_INT */
> -	{ 0x01, 0x80, 0x34 }, /* Enable Rx PLL Clock Value */
> -	{ 0x01, 0x90, 0x27 }, /* Enable CBUS discovery */
> -	{ 0x01, 0x91, 0xe5 }, /* Skip RGND detection */
> -	{ 0x01, 0x92, 0x46 }, /* Force MHD mode */
> -	{ 0x01, 0x93, 0xdc }, /* Disable CBUS pull-up during RGND measurement */
> -	{ 0x01, 0x94, 0x66 }, /* 1.8V CBUS VTH & GND threshold */
> -	{ 0x01, 0x95, 0x31 }, /* RGND block & single discovery attempt */
> -	{ 0x01, 0x96, 0x22 }, /* use 1K and 2K setting */
> -	{ 0x01, 0xa0, 0x10 }, /* SIMG: Term mode */
> -	{ 0x01, 0xa1, 0xfc }, /* Disable internal Mobile HD driver */
> -	{ 0x01, 0xa3, 0xfa }, /* SIMG: Output Swing  default EB, 3x Clk Mult */
> -	{ 0x01, 0xa5, 0x80 }, /* SIMG: RGND Hysterisis, 3x mode for Beast */
> -	{ 0x01, 0xa6, 0x0c }, /* SIMG: Swing Offset */
> -	{ 0x02, 0x3d, 0x3f }, /* Power up CVCC 1.2V core */
> -	{ 0x03, 0x00, 0x00 }, /* SIMG: correcting HW default */
> -	{ 0x03, 0x11, 0x01 }, /* Enable TxPLL Clock */
> -	{ 0x03, 0x12, 0x15 }, /* Enable Tx Clock Path & Equalizer */
> -	{ 0x03, 0x13, 0x60 }, /* SIMG: Set termination value */
> -	{ 0x03, 0x14, 0xf0 }, /* SIMG: Change CKDT level */
> -	{ 0x03, 0x17, 0x07 }, /* SIMG: PLL Calrefsel */
> -	{ 0x03, 0x1a, 0x20 }, /* VCO Cal */
> -	{ 0x03, 0x22, 0xe0 }, /* SIMG: Auto EQ */
> -	{ 0x03, 0x23, 0xc0 }, /* SIMG: Auto EQ */
> -	{ 0x03, 0x24, 0xa0 }, /* SIMG: Auto EQ */
> -	{ 0x03, 0x25, 0x80 }, /* SIMG: Auto EQ */
> -	{ 0x03, 0x26, 0x60 }, /* SIMG: Auto EQ */
> -	{ 0x03, 0x27, 0x40 }, /* SIMG: Auto EQ */
> -	{ 0x03, 0x28, 0x20 }, /* SIMG: Auto EQ */
> -	{ 0x03, 0x29, 0x00 }, /* SIMG: Auto EQ */
> -	{ 0x03, 0x31, 0x0b }, /* SIMG: Rx PLL BW value from I2C BW ~ 4MHz */
> -	{ 0x03, 0x45, 0x06 }, /* SIMG: DPLL Mode */
> -	{ 0x03, 0x4b, 0x06 }, /* SIMG: Correcting HW default */
> -	{ 0x03, 0x4c, 0xa0 }, /* Manual zone control */
> -	{ 0x03, 0x4d, 0x02 }, /* SIMG: PLL Mode Value (order is important) */
> -};
> -
> -static int sii9234_set_internal(struct sii9234_context *ctx)
> -{
> -	struct i2c_client *client = ctx->client;
> -	int i, ret;
> -
> -	for (i = 0; i < ARRAY_SIZE(data); ++i) {
> -		int addr = (data[i][0] << 8) | data[i][1];
> -		ret = sii9234_writeb_idx(client, addr, data[i][2]);
> -		if (ret < 0)
> -			return ret;
> -	}
> -	return 0;
> -}
> -
> -static int sii9234_runtime_suspend(struct device *dev)
> -{
> -	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> -	struct sii9234_context *ctx = sd_to_context(sd);
> -	struct i2c_client *client = ctx->client;
> -
> -	dev_info(dev, "suspend start\n");
> -
> -	sii9234_writeb_mask(client, 0x1e, 3, 3);
> -	regulator_disable(ctx->power);
> -
> -	return 0;
> -}
> -
> -static int sii9234_runtime_resume(struct device *dev)
> -{
> -	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> -	struct sii9234_context *ctx = sd_to_context(sd);
> -	struct i2c_client *client = ctx->client;
> -	int ret;
> -
> -	dev_info(dev, "resume start\n");
> -	ret = regulator_enable(ctx->power);
> -	if (ret < 0)
> -		return ret;
> -
> -	ret = sii9234_reset(ctx);
> -	if (ret)
> -		goto fail;
> -
> -	/* enable tpi */
> -	ret = sii9234_writeb_mask(client, 0x1e, 1, 0);
> -	if (ret < 0)
> -		goto fail;
> -	ret = sii9234_set_internal(ctx);
> -	if (ret < 0)
> -		goto fail;
> -
> -	return 0;
> -
> -fail:
> -	dev_err(dev, "failed to resume\n");
> -	regulator_disable(ctx->power);
> -
> -	return ret;
> -}
> -
> -static const struct dev_pm_ops sii9234_pm_ops = {
> -	.runtime_suspend = sii9234_runtime_suspend,
> -	.runtime_resume	 = sii9234_runtime_resume,
> -};
> -
> -static int sii9234_s_power(struct v4l2_subdev *sd, int on)
> -{
> -	struct sii9234_context *ctx = sd_to_context(sd);
> -	int ret;
> -
> -	if (on)
> -		ret = pm_runtime_get_sync(&ctx->client->dev);
> -	else
> -		ret = pm_runtime_put(&ctx->client->dev);
> -	/* only values < 0 indicate errors */
> -	return ret < 0 ? ret : 0;
> -}
> -
> -static int sii9234_s_stream(struct v4l2_subdev *sd, int enable)
> -{
> -	struct sii9234_context *ctx = sd_to_context(sd);
> -
> -	/* (dis/en)able TDMS output */
> -	sii9234_writeb_mask(ctx->client, 0x1a, enable ? 0 : ~0 , 1 << 4);
> -	return 0;
> -}
> -
> -static const struct v4l2_subdev_core_ops sii9234_core_ops = {
> -	.s_power =  sii9234_s_power,
> -};
> -
> -static const struct v4l2_subdev_video_ops sii9234_video_ops = {
> -	.s_stream =  sii9234_s_stream,
> -};
> -
> -static const struct v4l2_subdev_ops sii9234_ops = {
> -	.core = &sii9234_core_ops,
> -	.video = &sii9234_video_ops,
> -};
> -
> -static int sii9234_probe(struct i2c_client *client,
> -			 const struct i2c_device_id *id)
> -{
> -	struct device *dev = &client->dev;
> -	struct sii9234_platform_data *pdata = dev->platform_data;
> -	struct sii9234_context *ctx;
> -	int ret;
> -
> -	ctx = devm_kzalloc(&client->dev, sizeof(*ctx), GFP_KERNEL);
> -	if (!ctx) {
> -		dev_err(dev, "out of memory\n");
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> -	ctx->client = client;
> -
> -	ctx->power = devm_regulator_get(dev, "hdmi-en");
> -	if (IS_ERR(ctx->power)) {
> -		dev_err(dev, "failed to acquire regulator hdmi-en\n");
> -		return PTR_ERR(ctx->power);
> -	}
> -
> -	ctx->gpio_n_reset = pdata->gpio_n_reset;
> -	ret = devm_gpio_request(dev, ctx->gpio_n_reset, "MHL_RST");
> -	if (ret) {
> -		dev_err(dev, "failed to acquire MHL_RST gpio\n");
> -		return ret;
> -	}
> -
> -	v4l2_i2c_subdev_init(&ctx->sd, client, &sii9234_ops);
> -
> -	pm_runtime_enable(dev);
> -
> -	/* enable device */
> -	ret = pm_runtime_get_sync(dev);
> -	if (ret)
> -		goto fail_pm;
> -
> -	/* verify chip version */
> -	ret = sii9234_verify_version(client);
> -	if (ret)
> -		goto fail_pm_get;
> -
> -	/* stop processing */
> -	pm_runtime_put(dev);
> -
> -	dev_info(dev, "probe successful\n");
> -
> -	return 0;
> -
> -fail_pm_get:
> -	pm_runtime_put_sync(dev);
> -
> -fail_pm:
> -	pm_runtime_disable(dev);
> -
> -fail:
> -	dev_err(dev, "probe failed\n");
> -
> -	return ret;
> -}
> -
> -static int sii9234_remove(struct i2c_client *client)
> -{
> -	struct device *dev = &client->dev;
> -
> -	pm_runtime_disable(dev);
> -
> -	dev_info(dev, "remove successful\n");
> -
> -	return 0;
> -}
> -
> -
> -static const struct i2c_device_id sii9234_id[] = {
> -	{ "SII9234", 0 },
> -	{ },
> -};
> -
> -MODULE_DEVICE_TABLE(i2c, sii9234_id);
> -static struct i2c_driver sii9234_driver = {
> -	.driver = {
> -		.name	= "sii9234",
> -		.pm = &sii9234_pm_ops,
> -	},
> -	.probe		= sii9234_probe,
> -	.remove		= sii9234_remove,
> -	.id_table = sii9234_id,
> -};
> -
> -module_i2c_driver(sii9234_driver);
> 
