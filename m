Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:40152 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933852AbdAKLyz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 06:54:55 -0500
Subject: Re: [PATCH v2 2/2] Support for DW CSI-2 Host IPK
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, mchehab@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <cover.1481548484.git.roliveir@synopsys.com>
 <bf2f0a6730e4a74d64e04575859d6b195f65b368.1481554324.git.roliveir@synopsys.com>
Cc: davem@davemloft.net, gregkh@linuxfoundation.org,
        geert+renesas@glider.be, akpm@linux-foundation.org,
        linux@roeck-us.net, laurent.pinchart+renesas@ideasonboard.com,
        arnd@arndb.de, sudipm.mukherjee@gmail.com,
        tiffany.lin@mediatek.com, minghsiu.tsai@mediatek.com,
        jean-christophe.trotin@st.com, andrew-ct.chen@mediatek.com,
        simon.horman@netronome.com, songjun.wu@microchip.com,
        bparrot@ti.com, CARLOS.PALMINHA@synopsys.com,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <eb89af79-f868-ceba-ac69-558bac77613d@xs4all.nl>
Date: Wed, 11 Jan 2017 12:54:42 +0100
MIME-Version: 1.0
In-Reply-To: <bf2f0a6730e4a74d64e04575859d6b195f65b368.1481554324.git.roliveir@synopsys.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

See my review comments below:

On 12/12/16 16:00, Ramiro Oliveira wrote:
> Add support for the DesignWare CSI-2 Host IP Prototyping Kit
>
> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> ---
>  MAINTAINERS                                 |   7 +
>  drivers/media/platform/Kconfig              |   1 +
>  drivers/media/platform/Makefile             |   2 +
>  drivers/media/platform/dwc/Kconfig          |  36 ++
>  drivers/media/platform/dwc/Makefile         |   3 +
>  drivers/media/platform/dwc/dw_mipi_csi.c    | 647 ++++++++++++++++++++++
>  drivers/media/platform/dwc/dw_mipi_csi.h    | 180 ++++++
>  drivers/media/platform/dwc/plat_ipk.c       | 818 ++++++++++++++++++++++++++++
>  drivers/media/platform/dwc/plat_ipk.h       | 101 ++++
>  drivers/media/platform/dwc/plat_ipk_video.h |  97 ++++
>  drivers/media/platform/dwc/video_device.c   | 707 ++++++++++++++++++++++++
>  drivers/media/platform/dwc/video_device.h   |  85 +++
>  12 files changed, 2684 insertions(+)
>  create mode 100644 drivers/media/platform/dwc/Kconfig
>  create mode 100644 drivers/media/platform/dwc/Makefile
>  create mode 100644 drivers/media/platform/dwc/dw_mipi_csi.c
>  create mode 100644 drivers/media/platform/dwc/dw_mipi_csi.h
>  create mode 100644 drivers/media/platform/dwc/plat_ipk.c
>  create mode 100644 drivers/media/platform/dwc/plat_ipk.h
>  create mode 100644 drivers/media/platform/dwc/plat_ipk_video.h
>  create mode 100644 drivers/media/platform/dwc/video_device.c
>  create mode 100644 drivers/media/platform/dwc/video_device.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 72e828a..73250b5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10651,6 +10651,13 @@ S:	Maintained
>  F:	drivers/staging/media/st-cec/
>  F:	Documentation/devicetree/bindings/media/stih-cec.txt
>
> +SYNOPSYS DESIGNWARE CSI-2 HOST IPK DRIVER
> +M:	Ramiro Oliveira <roliveir@synopsys.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/platform/dwc/
> +
>  SYNOPSYS DESIGNWARE DMAC DRIVER
>  M:	Viresh Kumar <vireshk@kernel.org>
>  M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index d944421..7b99ba3 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -120,6 +120,7 @@ source "drivers/media/platform/am437x/Kconfig"
>  source "drivers/media/platform/xilinx/Kconfig"
>  source "drivers/media/platform/rcar-vin/Kconfig"
>  source "drivers/media/platform/atmel/Kconfig"
> +source "drivers/media/platform/dwc/Kconfig"
>
>  config VIDEO_TI_CAL
>  	tristate "TI CAL (Camera Adaptation Layer) driver"
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 5b3cb27..d84b1de 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -62,6 +62,8 @@ obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar-vin/
>
>  obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
>
> +obj-$(CONFIG_VIDEO_DWC)			+= dwc/
> +
>  ccflags-y += -I$(srctree)/drivers/media/i2c
>
>  obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
> diff --git a/drivers/media/platform/dwc/Kconfig b/drivers/media/platform/dwc/Kconfig
> new file mode 100644
> index 0000000..fb8533b
> --- /dev/null
> +++ b/drivers/media/platform/dwc/Kconfig
> @@ -0,0 +1,36 @@
> +config VIDEO_DWC
> +	bool "Designware Cores CSI-2 IPK (EXPERIMENTAL)"
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
> +	help
> +	  Say Y here to enable support for the DesignWare Cores CSI-2 Host IP
> +	  Prototyping Kit.
> +
> +if VIDEO_DWC
> +config DWC_PLATFORM
> +	tristate "SNPS DWC MIPI CSI2 Host"
> +	depends on VIDEO_DWC
> +	help
> +	  This is the V4L2 plaftorm driver driver for the DWC CSI-2 HOST IPK

plaftorm -> platform

> +
> +	  To compile this driver as a module, choose M here
> +
> +
> +config DWC_MIPI_CSI2_HOST
> +	tristate "SNPS DWC MIPI CSI2 Host"
> +	select GENERIC_PHY
> +	depends on VIDEO_DWC
> +	help
> +	  This is a V4L2 driver for SNPS DWC MIPI-CSI2
> +
> +	  To compile this driver as a module, choose M here
> +
> +config DWC_VIDEO_DEVICE
> +	tristate "DWC VIDEO DEVICE"
> +	select VIDEOBUF2_VMALLOC
> +	select VIDEOBUF2_DMA_CONTIG
> +	depends on VIDEO_DWC
> +	help
> +	  This is a V4L2 driver for SNPS Video device
> +	  To compile this driver as a module, choose M here
> +
> +endif # VIDEO_DWC
> diff --git a/drivers/media/platform/dwc/Makefile b/drivers/media/platform/dwc/Makefile
> new file mode 100644
> index 0000000..75c74b7
> --- /dev/null
> +++ b/drivers/media/platform/dwc/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_DWC_PLATFORM)		+= plat_ipk.o
> +obj-$(CONFIG_DWC_MIPI_CSI2_HOST)	+= dw_mipi_csi.o
> +obj-$(CONFIG_DWC_VIDEO_DEVICE)		+= video_device.o
> diff --git a/drivers/media/platform/dwc/dw_mipi_csi.c b/drivers/media/platform/dwc/dw_mipi_csi.c
> new file mode 100644
> index 0000000..6515afa
> --- /dev/null
> +++ b/drivers/media/platform/dwc/dw_mipi_csi.c
> @@ -0,0 +1,647 @@
> +/*
> + * DWC MIPI CSI-2 Host device driver
> + *
> + * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
> + * Author: Ramiro Oliveira <ramiro.oliveira@synopsys.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */
> +
> +#include "dw_mipi_csi.h"
> +
> +/**
> + * @short Video formats supported by the MIPI CSI-2
> + */
> +static const struct mipi_fmt dw_mipi_csi_formats[] = {
> +	{
> +		/* RAW 8 */
> +		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
> +		.depth = 8,
> +	},
> +	{
> +		/* RAW 10 */
> +		.code = MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE,
> +		.depth = 10,
> +	},
> +	{
> +		/* RGB 565 */
> +		.code = MEDIA_BUS_FMT_RGB565_2X8_BE,
> +		.depth = 16,
> +	},
> +	{
> +		/* BGR 565 */
> +		.code = MEDIA_BUS_FMT_RGB565_2X8_LE,
> +		.depth = 16,
> +	},
> +	{
> +		/* RGB 888 */
> +		.code = MEDIA_BUS_FMT_RGB888_2X12_LE,
> +		.depth = 24,
> +	},
> +	{
> +		/* BGR 888 */
> +		.code = MEDIA_BUS_FMT_RGB888_2X12_BE,
> +		.depth = 24,
> +	},
> +};
> +
> +static struct mipi_csi_dev *sd_to_mipi_csi_dev(struct v4l2_subdev *sdev)
> +{
> +	return container_of(sdev, struct mipi_csi_dev, sd);
> +}
> +
> +static void dw_mipi_csi_write(struct mipi_csi_dev *dev,
> +		  unsigned int address, unsigned int data)
> +{
> +	iowrite32(data, dev->base_address + address);
> +}
> +
> +static u32 dw_mipi_csi_read(struct mipi_csi_dev *dev, unsigned long address)
> +{
> +	return ioread32(dev->base_address + address);
> +}
> +
> +static void dw_mipi_csi_write_part(struct mipi_csi_dev *dev,
> +		       unsigned long address, unsigned long data,
> +		       unsigned char shift, unsigned char width)
> +{
> +	u32 mask = (1 << width) - 1;
> +	u32 temp = dw_mipi_csi_read(dev, address);
> +
> +	temp &= ~(mask << shift);
> +	temp |= (data & mask) << shift;
> +	dw_mipi_csi_write(dev, address, temp);
> +}
> +
> +static const struct mipi_fmt *
> +find_dw_mipi_csi_format(struct v4l2_mbus_framefmt *mf)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dw_mipi_csi_formats); i++)
> +		if (mf->code == dw_mipi_csi_formats[i].code)
> +			return &dw_mipi_csi_formats[i];
> +	return NULL;
> +}
> +
> +static void dw_mipi_csi_reset(struct mipi_csi_dev *dev)
> +{
> +	dw_mipi_csi_write(dev, R_CSI2_CTRL_RESETN, 0);
> +	dw_mipi_csi_write(dev, R_CSI2_CTRL_RESETN, 1);
> +}
> +
> +static int dw_mipi_csi_mask_irq_power_off(struct mipi_csi_dev *dev)
> +{
> +	/* set only one lane (lane 0) as active (ON) */
> +	dw_mipi_csi_write(dev, R_CSI2_N_LANES, 0);
> +
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PHY_FATAL, 0);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PKT_FATAL, 0);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_FRAME_FATAL, 0);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PHY, 0);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PKT, 0);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_LINE, 0);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_IPI, 0);
> +
> +	dw_mipi_csi_write(dev, R_CSI2_CTRL_RESETN, 0);
> +
> +	return 0;
> +
> +}
> +
> +static int dw_mipi_csi_hw_stdby(struct mipi_csi_dev *dev)
> +{
> +	/* set only one lane (lane 0) as active (ON) */
> +	dw_mipi_csi_reset(dev);
> +
> +	dw_mipi_csi_write(dev, R_CSI2_N_LANES, 0);
> +
> +	phy_init(dev->phy);
> +
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PHY_FATAL, 0xFFFFFFFF);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PKT_FATAL, 0xFFFFFFFF);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_FRAME_FATAL, 0xFFFFFFFF);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PHY, 0xFFFFFFFF);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PKT, 0xFFFFFFFF);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_LINE, 0xFFFFFFFF);
> +	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_IPI, 0xFFFFFFFF);
> +
> +	return 0;
> +
> +}
> +
> +static void dw_mipi_csi_set_ipi_fmt(struct mipi_csi_dev *csi_dev)
> +{
> +	struct device *dev = &csi_dev->pdev->dev;
> +
> +	switch (csi_dev->fmt->code) {
> +	case MEDIA_BUS_FMT_RGB565_2X8_BE:
> +	case MEDIA_BUS_FMT_RGB565_2X8_LE:
> +		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_DATA_TYPE, CSI_2_RGB565);
> +		dev_dbg(dev, "DT: RGB 565");
> +		break;
> +
> +	case MEDIA_BUS_FMT_RGB888_2X12_LE:
> +	case MEDIA_BUS_FMT_RGB888_2X12_BE:
> +		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_DATA_TYPE, CSI_2_RGB888);
> +		dev_dbg(dev, "DT: RGB 888");
> +		break;
> +	case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE:
> +		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_DATA_TYPE, CSI_2_RAW10);
> +		dev_dbg(dev, "DT: RAW 10");
> +		break;
> +	case MEDIA_BUS_FMT_SBGGR8_1X8:
> +		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_DATA_TYPE, CSI_2_RAW8);
> +		dev_dbg(dev, "DT: RAW 8");
> +		break;
> +	default:
> +		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_DATA_TYPE, CSI_2_RGB565);
> +		dev_dbg(dev, "Error");
> +		break;
> +	}
> +}
> +
> +static void __dw_mipi_csi_fill_timings(struct mipi_csi_dev *dev,
> +			   const struct v4l2_bt_timings *bt)
> +{
> +
> +	if (bt == NULL)
> +		return;
> +
> +	dev->hw.hsa = bt->hsync;
> +	dev->hw.hbp = bt->hbackporch;
> +	dev->hw.hsd = bt->hsync;
> +	dev->hw.htotal = bt->height + bt->vfrontporch +
> +	    bt->vsync + bt->vbackporch;
> +	dev->hw.vsa = bt->vsync;
> +	dev->hw.vbp = bt->vbackporch;
> +	dev->hw.vfp = bt->vfrontporch;
> +	dev->hw.vactive = bt->height;
> +}
> +
> +static void dw_mipi_csi_start(struct mipi_csi_dev *csi_dev)
> +{
> +	const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[0].bt;
> +	struct device *dev = &csi_dev->pdev->dev;
> +
> +	__dw_mipi_csi_fill_timings(csi_dev, bt);
> +
> +	dw_mipi_csi_write(csi_dev, R_CSI2_N_LANES, (csi_dev->hw.num_lanes - 1));
> +	dev_dbg(dev, "N Lanes: %d\n", csi_dev->hw.num_lanes);
> +
> +	/*IPI Related Configuration */
> +	if ((csi_dev->hw.output_type == IPI_OUT)
> +	    || (csi_dev->hw.output_type == BOTH_OUT)) {
> +
> +		dw_mipi_csi_write_part(csi_dev, R_CSI2_IPI_MODE,
> +					csi_dev->hw.ipi_mode, 0, 1);
> +		dev_dbg(dev, "IPI MODE: %d\n", csi_dev->hw.ipi_mode);
> +
> +		dw_mipi_csi_write_part(csi_dev, R_CSI2_IPI_MODE,
> +				       csi_dev->hw.ipi_color_mode, 8, 1);
> +		dev_dbg(dev, "Color Mode: %d\n", csi_dev->hw.ipi_color_mode);
> +
> +		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_VCID,
> +					csi_dev->hw.virtual_ch);
> +		dev_dbg(dev, "Virtual Channel: %d\n", csi_dev->hw.virtual_ch);
> +
> +		dw_mipi_csi_write_part(csi_dev, R_CSI2_IPI_MEM_FLUSH,
> +				       csi_dev->hw.ipi_auto_flush, 8, 1);
> +		dev_dbg(dev, "Auto-flush: %d\n", csi_dev->hw.ipi_auto_flush);
> +
> +		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_HSA_TIME,
> +					csi_dev->hw.hsa);
> +		dev_dbg(dev, "HSA: %d\n", csi_dev->hw.hsa);
> +
> +		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_HBP_TIME,
> +					csi_dev->hw.hbp);
> +		dev_dbg(dev, "HBP: %d\n", csi_dev->hw.hbp);
> +
> +		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_HSD_TIME,
> +					csi_dev->hw.hsd);
> +		dev_dbg(dev, "HSD: %d\n", csi_dev->hw.hsd);
> +
> +		if (csi_dev->hw.ipi_mode == AUTO_TIMING) {
> +			dw_mipi_csi_write(csi_dev, R_CSI2_IPI_HLINE_TIME,
> +					  csi_dev->hw.htotal);
> +			dev_dbg(dev, "H total: %d\n", csi_dev->hw.htotal);
> +
> +			dw_mipi_csi_write(csi_dev, R_CSI2_IPI_VSA_LINES,
> +					  csi_dev->hw.vsa);
> +			dev_dbg(dev, "VSA: %d\n", csi_dev->hw.vsa);
> +
> +			dw_mipi_csi_write(csi_dev, R_CSI2_IPI_VBP_LINES,
> +					  csi_dev->hw.vbp);
> +			dev_dbg(dev, "VBP: %d\n", csi_dev->hw.vbp);
> +
> +			dw_mipi_csi_write(csi_dev, R_CSI2_IPI_VFP_LINES,
> +					  csi_dev->hw.vfp);
> +			dev_dbg(dev, "VFP: %d\n", csi_dev->hw.vfp);
> +
> +			dw_mipi_csi_write(csi_dev, R_CSI2_IPI_VACTIVE_LINES,
> +					  csi_dev->hw.vactive);
> +			dev_dbg(dev, "V Active: %d\n", csi_dev->hw.vactive);
> +		}
> +	}
> +
> +	phy_power_on(csi_dev->phy);
> +}
> +
> +static int dw_mipi_csi_enum_mbus_code(struct v4l2_subdev *sd,
> +					struct v4l2_subdev_pad_config *cfg,
> +					struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index >= ARRAY_SIZE(dw_mipi_csi_formats))
> +		return -EINVAL;
> +
> +	code->code = dw_mipi_csi_formats[code->index].code;
> +	return 0;
> +}
> +
> +static struct mipi_fmt const *
> +dw_mipi_csi_try_format(struct v4l2_mbus_framefmt *mf)
> +{
> +	struct mipi_fmt const *fmt;
> +
> +	fmt = find_dw_mipi_csi_format(mf);
> +	if (fmt == NULL)
> +		fmt = &dw_mipi_csi_formats[0];
> +
> +	mf->code = fmt->code;
> +	return fmt;
> +}
> +
> +static struct v4l2_mbus_framefmt *
> +__dw_mipi_csi_get_format(struct mipi_csi_dev *dev,
> +			 struct v4l2_subdev_pad_config *cfg,
> +			 enum v4l2_subdev_format_whence which)
> +{
> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> +		return cfg ? v4l2_subdev_get_try_format(&dev->sd, cfg,
> +							0) : NULL;
> +
> +	return &dev->format;
> +}
> +
> +static int
> +dw_mipi_csi_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
> +		    struct v4l2_subdev_format *fmt)
> +{
> +	struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
> +	struct mipi_fmt const *dev_fmt;
> +	struct v4l2_mbus_framefmt *mf;
> +	unsigned int i = 0;
> +	const struct v4l2_bt_timings *bt_r = &v4l2_dv_timings_presets[0].bt;
> +
> +	mf = __dw_mipi_csi_get_format(dev, cfg, fmt->which);
> +
> +	dev_fmt = dw_mipi_csi_try_format(&fmt->format);
> +	if (dev_fmt) {
> +		*mf = fmt->format;
> +		if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +			dev->fmt = dev_fmt;
> +		dw_mipi_csi_set_ipi_fmt(dev);
> +	}
> +	while (v4l2_dv_timings_presets[i].bt.width) {
> +		const struct v4l2_bt_timings *bt =
> +		    &v4l2_dv_timings_presets[i].bt;
> +		if (mf->width == bt->width && mf->height == bt->width) {
> +			__dw_mipi_csi_fill_timings(dev, bt);
> +			return 0;
> +		}
> +		i++;
> +	}
> +
> +	__dw_mipi_csi_fill_timings(dev, bt_r);

This code is weird. The video source can be either from a sensor or from an
HDMI input, right?

But if it is from a sensor, then using v4l2_dv_timings_presets since that's for
an HDMI input. Sensors will typically not follow these preset timings.

For HDMI input I expect that this driver supports the s_dv_timings op and will
just use the timings set there and override the width/height in v4l2_subdev_format.

For sensors I am actually not quite certain how this is done. I've CC-ed Sakari
since he'll know. But let us know first whether it is indeed the intention that
this should also work with a sensor.

> +	return 0;
> +
> +}
> +
> +static int
> +dw_mipi_csi_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
> +		    struct v4l2_subdev_format *fmt)
> +{
> +	struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
> +	struct v4l2_mbus_framefmt *mf;
> +
> +	mf = __dw_mipi_csi_get_format(dev, cfg, fmt->which);
> +	if (!mf)
> +		return -EINVAL;
> +
> +	mutex_lock(&dev->lock);
> +	fmt->format = *mf;
> +	mutex_unlock(&dev->lock);
> +	return 0;
> +}
> +
> +static int
> +dw_mipi_csi_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
> +
> +	if (on) {
> +		dw_mipi_csi_hw_stdby(dev);
> +		dw_mipi_csi_start(dev);
> +	} else {
> +		dw_mipi_csi_mask_irq_power_off(dev);
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +dw_mipi_csi_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct v4l2_mbus_framefmt *format =
> +	    v4l2_subdev_get_try_format(sd, fh->pad, 0);
> +
> +	format->colorspace = V4L2_COLORSPACE_SRGB;
> +	format->code = dw_mipi_csi_formats[0].code;
> +	format->width = MIN_WIDTH;
> +	format->height = MIN_HEIGHT;
> +	format->field = V4L2_FIELD_NONE;

Don't do this. Instead implement the init_cfg pad op and initialize this there.

You can then drop this function.

> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_internal_ops dw_mipi_csi_sd_internal_ops = {
> +	.open = dw_mipi_csi_open,
> +};
> +
> +static struct v4l2_subdev_core_ops dw_mipi_csi_core_ops = {
> +	.s_power = dw_mipi_csi_s_power,
> +};
> +
> +static struct v4l2_subdev_pad_ops dw_mipi_csi_pad_ops = {
> +	.enum_mbus_code = dw_mipi_csi_enum_mbus_code,
> +	.get_fmt = dw_mipi_csi_get_fmt,
> +	.set_fmt = dw_mipi_csi_set_fmt,
> +};
> +
> +static struct v4l2_subdev_ops dw_mipi_csi_subdev_ops = {
> +	.core = &dw_mipi_csi_core_ops,
> +	.pad = &dw_mipi_csi_pad_ops,
> +};
> +
> +static irqreturn_t
> +dw_mipi_csi_irq1(int irq, void *dev_id)
> +{
> +	struct mipi_csi_dev *csi_dev = dev_id;
> +	u32 global_int_status, i_sts;
> +	unsigned long flags;
> +	struct device *dev = &csi_dev->pdev->dev;
> +
> +	global_int_status = dw_mipi_csi_read(csi_dev, R_CSI2_INTERRUPT);
> +	spin_lock_irqsave(&csi_dev->slock, flags);
> +
> +	if (global_int_status & CSI2_INT_PHY_FATAL) {
> +		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PHY_FATAL);
> +		dev_dbg_ratelimited(dev, "CSI INT PHY FATAL: %08X\n", i_sts);
> +	}
> +
> +	if (global_int_status & CSI2_INT_PKT_FATAL) {
> +		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PKT_FATAL);
> +		dev_dbg_ratelimited(dev, "CSI INT PKT FATAL: %08X\n", i_sts);
> +	}
> +
> +	if (global_int_status & CSI2_INT_FRAME_FATAL) {
> +		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_FRAME_FATAL);
> +		dev_dbg_ratelimited(dev, "CSI INT FRAME FATAL: %08X\n", i_sts);
> +	}
> +
> +	if (global_int_status & CSI2_INT_PHY) {
> +		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PHY);
> +		dev_dbg_ratelimited(dev, "CSI INT PHY: %08X\n", i_sts);
> +	}
> +
> +	if (global_int_status & CSI2_INT_PKT) {
> +		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PKT);
> +		dev_dbg_ratelimited(dev, "CSI INT PKT: %08X\n", i_sts);
> +	}
> +
> +	if (global_int_status & CSI2_INT_LINE) {
> +		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_LINE);
> +		dev_dbg_ratelimited(dev, "CSI INT LINE: %08X\n", i_sts);
> +	}
> +
> +	if (global_int_status & CSI2_INT_IPI) {
> +		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_IPI);
> +		dev_dbg_ratelimited(dev, "CSI INT IPI: %08X\n", i_sts);
> +	}
> +	spin_unlock_irqrestore(&csi_dev->slock, flags);
> +	return IRQ_HANDLED;
> +}
> +
> +static int
> +dw_mipi_csi_parse_dt(struct platform_device *pdev, struct mipi_csi_dev *dev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	int reg;
> +	int ret = 0;
> +
> +	/* Device tree information */

I would expect to see a call to v4l2_of_parse_endpoint here.

> +	ret = of_property_read_u32(node, "data-lanes", &dev->hw.num_lanes);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't read data-lanes\n");
> +		return ret;
> +	}
> +
> +	ret = of_property_read_u32(node, "output-type", &dev->hw.output_type);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't read output-type\n");
> +		return ret;
> +	}
> +
> +	ret = of_property_read_u32(node, "ipi-mode", &dev->hw.ipi_mode);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't read ipi-mode\n");
> +		return ret;
> +	}
> +
> +	ret =
> +	    of_property_read_u32(node, "ipi-auto-flush",
> +				 &dev->hw.ipi_auto_flush);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't read ipi-auto-flush\n");
> +		return ret;
> +	}
> +
> +	ret =
> +	    of_property_read_u32(node, "ipi-color-mode",
> +				 &dev->hw.ipi_color_mode);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't read ipi-color-mode\n");
> +		return ret;
> +	}
> +
> +	ret =
> +	    of_property_read_u32(node, "virtual-channel", &dev->hw.virtual_ch);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't read virtual-channel\n");
> +		return ret;
> +	}
> +
> +	node = of_get_child_by_name(node, "port");
> +	if (!node)
> +		return -EINVAL;
> +
> +	ret = of_property_read_u32(node, "reg", &reg);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't read reg value\n");
> +		return ret;
> +	}
> +	dev->index = reg - 1;
> +
> +	if (dev->index >= CSI_MAX_ENTITIES)
> +		return -ENXIO;
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id dw_mipi_csi_of_match[];
> +
> +/**
> + * @short Initialization routine - Entry point of the driver
> + * @param[in] pdev pointer to the platform device structure
> + * @return 0 on success and a negative number on failure
> + * Refer to Linux errors.
> + */
> +static int mipi_csi_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *of_id;
> +	struct device *dev = &pdev->dev;
> +	struct resource *res = NULL;
> +	struct mipi_csi_dev *mipi_csi;
> +	int ret = -ENOMEM;
> +
> +	mipi_csi = devm_kzalloc(dev, sizeof(*mipi_csi), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	mutex_init(&mipi_csi->lock);
> +	spin_lock_init(&mipi_csi->slock);
> +	mipi_csi->pdev = pdev;
> +
> +	of_id = of_match_node(dw_mipi_csi_of_match, dev->of_node);
> +	if (WARN_ON(of_id == NULL))
> +		return -EINVAL;
> +
> +	ret = dw_mipi_csi_parse_dt(pdev, mipi_csi);
> +	if (ret < 0)
> +		return ret;
> +
> +	mipi_csi->phy = devm_phy_get(dev, "csi2-dphy");
> +	if (IS_ERR(mipi_csi->phy)) {
> +		dev_err(dev, "No DPHY available\n");
> +		return PTR_ERR(mipi_csi->phy);
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	mipi_csi->base_address = devm_ioremap_resource(dev, res);
> +
> +	if (IS_ERR(mipi_csi->base_address)) {
> +		dev_err(dev, "Base address not set.\n");
> +		return PTR_ERR(mipi_csi->base_address);
> +	}
> +
> +	mipi_csi->ctrl_irq_number = platform_get_irq(pdev, 0);
> +	if (mipi_csi->ctrl_irq_number <= 0) {
> +		dev_err(dev, "IRQ number not set.\n");
> +		return mipi_csi->ctrl_irq_number;
> +	}
> +
> +	ret = devm_request_irq(dev, mipi_csi->ctrl_irq_number,
> +			       dw_mipi_csi_irq1, IRQF_SHARED,
> +			       dev_name(dev), mipi_csi);
> +	if (ret) {
> +		dev_err(dev, "IRQ failed\n");
> +		goto end;
> +	}
> +
> +	v4l2_subdev_init(&mipi_csi->sd, &dw_mipi_csi_subdev_ops);
> +	mipi_csi->sd.owner = THIS_MODULE;
> +	snprintf(mipi_csi->sd.name, sizeof(mipi_csi->sd.name), "%s.%d",
> +		 CSI_DEVICE_NAME, mipi_csi->index);
> +	mipi_csi->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	mipi_csi->fmt = &dw_mipi_csi_formats[0];
> +
> +	mipi_csi->format.code = dw_mipi_csi_formats[0].code;
> +	mipi_csi->format.width = MIN_WIDTH;
> +	mipi_csi->format.height = MIN_HEIGHT;
> +
> +	mipi_csi->sd.entity.function = MEDIA_ENT_F_IO_V4L;
> +	mipi_csi->pads[CSI_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
> +	mipi_csi->pads[CSI_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_pads_init(&mipi_csi->sd.entity,
> +				     CSI_PADS_NUM, mipi_csi->pads);
> +
> +	if (ret < 0) {
> +		dev_err(dev, "Media Entity init failed\n");
> +		goto entity_cleanup;
> +	}
> +
> +	/* This allows to retrieve the platform device id by the host driver */
> +	v4l2_set_subdevdata(&mipi_csi->sd, pdev);
> +
> +	/* .. and a pointer to the subdev. */
> +	platform_set_drvdata(pdev, &mipi_csi->sd);
> +
> +	dw_mipi_csi_mask_irq_power_off(mipi_csi);
> +	dev_info(dev, "DW MIPI CSI-2 Host registered successfully\n");
> +	return 0;
> +
> +entity_cleanup:
> +	media_entity_cleanup(&mipi_csi->sd.entity);
> +end:
> +	return ret;
> +}
> +
> +/**
> + * @short Exit routine - Exit point of the driver
> + * @param[in] pdev pointer to the platform device structure
> + * @return 0 on success and a negative number on failure
> + * Refer to Linux errors.
> + */
> +static int mipi_csi_remove(struct platform_device *pdev)
> +{
> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
> +	struct mipi_csi_dev *mipi_csi = sd_to_mipi_csi_dev(sd);
> +
> +	dev_dbg(&pdev->dev, "Removing MIPI CSI-2 module\n");
> +	media_entity_cleanup(&mipi_csi->sd.entity);
> +
> +	return 0;
> +}
> +
> +/**
> + * @short of_device_id structure
> + */
> +static const struct of_device_id dw_mipi_csi_of_match[] = {
> +	{
> +	 .compatible = "snps,dw-mipi-csi"},
> +	{ /* sentinel */ },
> +};
> +
> +MODULE_DEVICE_TABLE(of, dw_mipi_csi_of_match);
> +
> +/**
> + * @short Platform driver structure
> + */
> +static struct platform_driver __refdata dw_mipi_csi_pdrv = {
> +	.remove = mipi_csi_remove,
> +	.probe = mipi_csi_probe,
> +	.driver = {
> +		   .name = CSI_DEVICE_NAME,
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = dw_mipi_csi_of_match,
> +		   },
> +};
> +
> +module_platform_driver(dw_mipi_csi_pdrv);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Ramiro Oliveira <roliveir@synopsys.com>");
> +MODULE_DESCRIPTION("Synopsys DW MIPI CSI-2 Host driver");
> diff --git a/drivers/media/platform/dwc/dw_mipi_csi.h b/drivers/media/platform/dwc/dw_mipi_csi.h
> new file mode 100644
> index 0000000..610a01f
> --- /dev/null
> +++ b/drivers/media/platform/dwc/dw_mipi_csi.h
> @@ -0,0 +1,180 @@
> +/*
> + * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef DW_MIPI_CSI_H_
> +#define DW_MIPI_CSI_H_
> +
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_graph.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/ratelimit.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/videodev2.h>
> +#include <linux/wait.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-dv-timings.h>
> +
> +#include "plat_ipk_video.h"
> +
> +#define CSI_DEVICE_NAME	"dw-mipi-csi"
> +
> +/** @short DWC MIPI CSI-2 register addresses*/
> +enum register_addresses {
> +	R_CSI2_VERSION = 0x00,
> +	R_CSI2_N_LANES = 0x04,
> +	R_CSI2_CTRL_RESETN = 0x08,
> +	R_CSI2_INTERRUPT = 0x0C,
> +	R_CSI2_DATA_IDS_1 = 0x10,
> +	R_CSI2_DATA_IDS_2 = 0x14,
> +	R_CSI2_IPI_MODE = 0x80,
> +	R_CSI2_IPI_VCID = 0x84,
> +	R_CSI2_IPI_DATA_TYPE = 0x88,
> +	R_CSI2_IPI_MEM_FLUSH = 0x8C,
> +	R_CSI2_IPI_HSA_TIME = 0x90,
> +	R_CSI2_IPI_HBP_TIME = 0x94,
> +	R_CSI2_IPI_HSD_TIME = 0x98,
> +	R_CSI2_IPI_HLINE_TIME = 0x9C,
> +	R_CSI2_IPI_VSA_LINES = 0xB0,
> +	R_CSI2_IPI_VBP_LINES = 0xB4,
> +	R_CSI2_IPI_VFP_LINES = 0xB8,
> +	R_CSI2_IPI_VACTIVE_LINES = 0xBC,
> +	R_CSI2_INT_PHY_FATAL = 0xe0,
> +	R_CSI2_MASK_INT_PHY_FATAL = 0xe4,
> +	R_CSI2_FORCE_INT_PHY_FATAL = 0xe8,
> +	R_CSI2_INT_PKT_FATAL = 0xf0,
> +	R_CSI2_MASK_INT_PKT_FATAL = 0xf4,
> +	R_CSI2_FORCE_INT_PKT_FATAL = 0xf8,
> +	R_CSI2_INT_FRAME_FATAL = 0x100,
> +	R_CSI2_MASK_INT_FRAME_FATAL = 0x104,
> +	R_CSI2_FORCE_INT_FRAME_FATAL = 0x108,
> +	R_CSI2_INT_PHY = 0x110,
> +	R_CSI2_MASK_INT_PHY = 0x114,
> +	R_CSI2_FORCE_INT_PHY = 0x118,
> +	R_CSI2_INT_PKT = 0x120,
> +	R_CSI2_MASK_INT_PKT = 0x124,
> +	R_CSI2_FORCE_INT_PKT = 0x128,
> +	R_CSI2_INT_LINE = 0x130,
> +	R_CSI2_MASK_INT_LINE = 0x134,
> +	R_CSI2_FORCE_INT_LINE = 0x138,
> +	R_CSI2_INT_IPI = 0x140,
> +	R_CSI2_MASK_INT_IPI = 0x144,
> +	R_CSI2_FORCE_INT_IPI = 0x148
> +};
> +
> +/** @short IPI Data Types */
> +enum data_type {
> +	CSI_2_YUV420_8 = 0x18,
> +	CSI_2_YUV420_10 = 0x19,
> +	CSI_2_YUV420_8_LEG = 0x1A,
> +	CSI_2_YUV420_8_SHIFT = 0x1C,
> +	CSI_2_YUV420_10_SHIFT = 0x1D,
> +	CSI_2_YUV422_8 = 0x1E,
> +	CSI_2_YUV422_10 = 0x1F,
> +	CSI_2_RGB444 = 0x20,
> +	CSI_2_RGB555 = 0x21,
> +	CSI_2_RGB565 = 0x22,
> +	CSI_2_RGB666 = 0x23,
> +	CSI_2_RGB888 = 0x24,
> +	CSI_2_RAW6 = 0x28,
> +	CSI_2_RAW7 = 0x29,
> +	CSI_2_RAW8 = 0x2A,
> +	CSI_2_RAW10 = 0x2B,
> +	CSI_2_RAW12 = 0x2C,
> +	CSI_2_RAW14 = 0x2D,
> +};
> +
> +/** @short Interrupt Masks */
> +enum interrupt_type {
> +	CSI2_INT_PHY_FATAL = 1 << 0,
> +	CSI2_INT_PKT_FATAL = 1 << 1,
> +	CSI2_INT_FRAME_FATAL = 1 << 2,
> +	CSI2_INT_PHY = 1 << 16,
> +	CSI2_INT_PKT = 1 << 17,
> +	CSI2_INT_LINE = 1 << 18,
> +	CSI2_INT_IPI = 1 << 19,
> +
> +};
> +
> +/** @short DWC MIPI CSI-2 output types*/
> +enum output_type {
> +	IPI_OUT = 0,
> +	IDI_OUT = 1,
> +	BOTH_OUT = 2
> +};
> +
> +/** @short IPI output types*/
> +enum ipi_output_type {
> +	CAMERA_TIMING = 0,
> +	AUTO_TIMING = 1
> +};
> +
> +/**
> + * @short Format template
> + */
> +struct mipi_fmt {
> +	u32 code;
> +	u8 depth;
> +};
> +
> +struct csi_hw {
> +
> +	uint32_t num_lanes;
> +	uint32_t output_type;
> +
> +	/*IPI Info */
> +	uint32_t ipi_mode;
> +	uint32_t ipi_color_mode;
> +	uint32_t ipi_auto_flush;
> +	uint32_t virtual_ch;
> +
> +	uint32_t hsa;
> +	uint32_t hbp;
> +	uint32_t hsd;
> +	uint32_t htotal;
> +
> +	uint32_t vsa;
> +	uint32_t vbp;
> +	uint32_t vfp;
> +	uint32_t vactive;
> +};
> +
> +/**
> + * @short Structure to embed device driver information
> + */
> +struct mipi_csi_dev {
> +	struct v4l2_subdev sd;
> +	struct video_device vdev;
> +
> +	struct mutex lock;
> +	spinlock_t slock;
> +	struct media_pad pads[CSI_PADS_NUM];
> +	struct platform_device *pdev;
> +	u8 index;
> +
> +	/** Store current format */
> +	const struct mipi_fmt *fmt;
> +	struct v4l2_mbus_framefmt format;
> +
> +	/** Device Tree Information */
> +	void __iomem *base_address;
> +	uint32_t ctrl_irq_number;
> +
> +	struct csi_hw hw;
> +
> +	struct phy *phy;
> +};
> +
> +#endif				/* DW_MIPI_CSI */
> diff --git a/drivers/media/platform/dwc/plat_ipk.c b/drivers/media/platform/dwc/plat_ipk.c
> new file mode 100644
> index 0000000..02dcf36
> --- /dev/null
> +++ b/drivers/media/platform/dwc/plat_ipk.c
> @@ -0,0 +1,818 @@
> +/**
> + * DWC MIPI CSI-2 Host IPK platform device driver

What does IPK stand for?

> + *
> + * Based on Omnivision OV7670 Camera Driver
> + * Copyright (C) 2011 - 2013 Samsung Electronics Co., Ltd.
> + * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
> + * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
> + * Author: Ramiro Oliveira <ramiro.oliveira@synopsys.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */
> +
> +#include "plat_ipk.h"
> +
> +static int
> +__plat_ipk_pipeline_s_format(struct plat_ipk_media_pipeline *ep,
> +			     struct v4l2_subdev_format *fmt)
> +{
> +
> +	struct plat_ipk_pipeline *p = to_plat_ipk_pipeline(ep);
> +	static const u8 seq[IDX_MAX] = {IDX_SENSOR, IDX_CSI, IDX_VDEV};
> +
> +	fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	v4l2_subdev_call(p->subdevs[seq[IDX_CSI]], pad, set_fmt, NULL, fmt);
> +
> +	return 0;
> +}
> +
> +static void
> +plat_ipk_pipeline_prepare(struct plat_ipk_pipeline *p, struct media_entity *me)
> +{
> +	struct v4l2_subdev *sd;
> +	unsigned int i = 0;
> +
> +	for (i = 0; i < IDX_MAX; i++)
> +		p->subdevs[i] = NULL;
> +
> +	while (1) {
> +		struct media_pad *pad = NULL;
> +
> +		for (i = 0; i < me->num_pads; i++) {
> +			struct media_pad *spad = &me->pads[i];
> +
> +			if (!(spad->flags & MEDIA_PAD_FL_SINK))
> +				continue;
> +
> +			pad = media_entity_remote_pad(spad);
> +			if (pad)
> +				break;
> +		}
> +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> +			break;
> +
> +		sd = media_entity_to_v4l2_subdev(pad->entity);
> +
> +		switch (sd->grp_id) {
> +		case GRP_ID_SENSOR:
> +			p->subdevs[IDX_SENSOR] = sd;
> +			break;
> +		case GRP_ID_CSI:
> +			p->subdevs[IDX_CSI] = sd;
> +			break;
> +		case GRP_ID_VIDEODEV:
> +			p->subdevs[IDX_VDEV] = sd;
> +			break;
> +		default:
> +			break;
> +		}
> +		me = &sd->entity;
> +		if (me->num_pads == 1)
> +			break;
> +	}
> +}
> +
> +static int __subdev_set_power(struct v4l2_subdev *sd, int on)
> +{
> +	int *use_count;
> +	int ret;
> +
> +	if (sd == NULL) {
> +		pr_err("null subdev\n");
> +		return -ENXIO;
> +	}
> +	use_count = &sd->entity.use_count;
> +	if (on && (*use_count)++ > 0)
> +		return 0;
> +	else if (!on && (*use_count == 0 || --(*use_count) > 0))
> +		return 0;
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, on);
> +
> +	return ret != -ENOIOCTLCMD ? ret : 0;
> +}
> +
> +static int plat_ipk_pipeline_s_power(struct plat_ipk_pipeline *p, bool on)
> +{
> +	static const u8 seq[IDX_MAX] = {IDX_CSI, IDX_SENSOR, IDX_VDEV};
> +	int i, ret = 0;
> +
> +	for (i = 0; i < IDX_MAX; i++) {
> +		unsigned int idx = seq[i];
> +
> +		if (p->subdevs[idx] == NULL)
> +			pr_info("No device registered on %d\n", idx);
> +		else {
> +			ret = __subdev_set_power(p->subdevs[idx], on);
> +			if (ret < 0 && ret != -ENXIO)
> +				goto error;
> +		}
> +	}
> +	return 0;
> +error:
> +	for (; i >= 0; i--) {
> +		unsigned int idx = seq[i];
> +
> +		__subdev_set_power(p->subdevs[idx], !on);
> +	}
> +	return ret;
> +}
> +
> +static int
> +__plat_ipk_pipeline_open(struct plat_ipk_media_pipeline *ep,
> +			 struct media_entity *me, bool prepare)
> +{
> +	struct plat_ipk_pipeline *p = to_plat_ipk_pipeline(ep);
> +	int ret;
> +
> +	if (WARN_ON(p == NULL || me == NULL))
> +		return -EINVAL;
> +
> +	if (prepare)
> +		plat_ipk_pipeline_prepare(p, me);
> +
> +	ret = plat_ipk_pipeline_s_power(p, 1);
> +	if (!ret)
> +		return 0;
> +
> +	return ret;
> +}
> +
> +static int __plat_ipk_pipeline_close(struct plat_ipk_media_pipeline *ep)
> +{
> +	struct plat_ipk_pipeline *p = to_plat_ipk_pipeline(ep);
> +	int ret;
> +
> +	ret = plat_ipk_pipeline_s_power(p, 0);
> +
> +	return ret == -ENXIO ? 0 : ret;
> +}
> +
> +static int
> +__plat_ipk_pipeline_s_stream(struct plat_ipk_media_pipeline *ep, bool on)
> +{
> +	static const u8 seq[IDX_MAX] = {IDX_SENSOR, IDX_CSI, IDX_VDEV};
> +	struct plat_ipk_pipeline *p = to_plat_ipk_pipeline(ep);
> +	int i, ret = 0;
> +
> +	for (i = 0; i < IDX_MAX; i++) {
> +		unsigned int idx = seq[i];
> +
> +		if (p->subdevs[idx] == NULL)
> +			pr_debug("No device registered on %d\n", idx);
> +		else {
> +			ret =
> +			    v4l2_subdev_call(p->subdevs[idx], video, s_stream,
> +					     on);
> +
> +			if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +				goto error;
> +		}
> +	}
> +	return 0;
> +error:
> +	for (; i >= 0; i--) {
> +		unsigned int idx = seq[i];
> +
> +		v4l2_subdev_call(p->subdevs[idx], video, s_stream, !on);
> +	}
> +	return ret;
> +}
> +
> +static const struct plat_ipk_media_pipeline_ops plat_ipk_pipeline_ops = {
> +	.open = __plat_ipk_pipeline_open,
> +	.close = __plat_ipk_pipeline_close,
> +	.set_format = __plat_ipk_pipeline_s_format,
> +	.set_stream = __plat_ipk_pipeline_s_stream,
> +};
> +
> +static struct plat_ipk_media_pipeline *
> +plat_ipk_pipeline_create(struct plat_ipk_dev *plat_ipk)
> +{
> +	struct plat_ipk_pipeline *p;
> +
> +	p = kzalloc(sizeof(*p), GFP_KERNEL);
> +	if (!p)
> +		return NULL;
> +
> +	list_add_tail(&p->list, &plat_ipk->pipelines);
> +
> +	p->ep.ops = &plat_ipk_pipeline_ops;
> +	return &p->ep;
> +}
> +
> +static void
> +plat_ipk_pipelines_free(struct plat_ipk_dev *plat_ipk)
> +{
> +	while (!list_empty(&plat_ipk->pipelines)) {
> +		struct plat_ipk_pipeline *p;
> +
> +		p = list_entry(plat_ipk->pipelines.next, typeof(*p), list);
> +		list_del(&p->list);
> +		kfree(p);
> +	}
> +}
> +
> +static int
> +plat_ipk_parse_port_node(struct plat_ipk_dev *plat_ipk,
> +			 struct device_node *port, unsigned int index)
> +{
> +	struct device_node *rem, *ep;
> +	struct v4l2_of_endpoint endpoint;
> +	struct plat_ipk_source_info *pd = &plat_ipk->sensor[index].pdata;
> +
> +	/* Assume here a port node can have only one endpoint node. */
> +	ep = of_get_next_child(port, NULL);
> +	if (!ep)
> +		return 0;
> +
> +	v4l2_of_parse_endpoint(ep, &endpoint);
> +	if (WARN_ON(endpoint.base.port == 0) || index >= PLAT_MAX_SENSORS)
> +		return -EINVAL;
> +
> +	pd->mux_id = endpoint.base.port - 1;
> +
> +	rem = of_graph_get_remote_port_parent(ep);
> +	of_node_put(ep);
> +	if (rem == NULL) {
> +		dev_info(plat_ipk->dev,
> +			  "Remote device at %s not found\n", ep->full_name);
> +		return 0;
> +	}
> +
> +	if (WARN_ON(index >= ARRAY_SIZE(plat_ipk->sensor)))
> +		return -EINVAL;
> +
> +	plat_ipk->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_OF;
> +	plat_ipk->sensor[index].asd.match.of.node = rem;
> +	plat_ipk->async_subdevs[index] = &plat_ipk->sensor[index].asd;
> +
> +	plat_ipk->num_sensors++;
> +
> +	of_node_put(rem);
> +	return 0;
> +}
> +
> +
> +static int plat_ipk_register_sensor_entities(struct plat_ipk_dev *plat_ipk)
> +{
> +	struct device_node *parent = plat_ipk->pdev->dev.of_node;
> +	struct device_node *node;
> +	int index = 0;
> +	int ret;
> +
> +	plat_ipk->num_sensors = 0;
> +
> +	for_each_available_child_of_node(parent, node) {
> +		struct device_node *port;
> +
> +		if (of_node_cmp(node->name, "csi2"))
> +			continue;
> +		port = of_get_next_child(node, NULL);
> +		if (!port)
> +			continue;
> +
> +		ret = plat_ipk_parse_port_node(plat_ipk, port, index);
> +		if (ret < 0)
> +			return ret;
> +		index++;
> +	}
> +	return 0;
> +}
> +
> +static int
> +__of_get_port_id(struct device_node *np)
> +{
> +	u32 reg = 0;
> +
> +	np = of_get_child_by_name(np, "port");
> +	if (!np)
> +		return -EINVAL;
> +	of_property_read_u32(np, "reg", &reg);
> +
> +	return reg - 1;
> +}
> +
> +static int register_videodev_entity(struct plat_ipk_dev *plat_ipk,
> +			 struct video_device_dev *vid_dev)
> +{
> +	struct v4l2_subdev *sd;
> +	struct plat_ipk_media_pipeline *ep;
> +	int ret;
> +
> +	sd = &vid_dev->subdev;
> +	sd->grp_id = GRP_ID_VIDEODEV;
> +
> +	ep = plat_ipk_pipeline_create(plat_ipk);
> +	if (!ep)
> +		return -ENOMEM;
> +
> +	v4l2_set_subdev_hostdata(sd, ep);
> +
> +	ret = v4l2_device_register_subdev(&plat_ipk->v4l2_dev, sd);
> +	if (!ret)
> +		plat_ipk->vid_dev = vid_dev;
> +	else
> +		v4l2_err(&plat_ipk->v4l2_dev,
> +			 "Failed to register Video Device\n");
> +	return ret;
> +}
> +
> +static int register_mipi_csi_entity(struct plat_ipk_dev *plat_ipk,
> +			 struct platform_device *pdev, struct v4l2_subdev *sd)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	int id, ret;
> +
> +	id = node ? __of_get_port_id(node) : max(0, pdev->id);
> +
> +	if (WARN_ON(id < 0 || id >= CSI_MAX_ENTITIES))
> +		return -ENOENT;
> +
> +	if (WARN_ON(plat_ipk->mipi_csi[id].sd))
> +		return -EBUSY;
> +
> +	sd->grp_id = GRP_ID_CSI;
> +	ret = v4l2_device_register_subdev(&plat_ipk->v4l2_dev, sd);
> +
> +	if (!ret)
> +		plat_ipk->mipi_csi[id].sd = sd;
> +	else
> +		v4l2_err(&plat_ipk->v4l2_dev,
> +			 "Failed to register MIPI-CSI.%d (%d)\n", id, ret);
> +	return ret;
> +}
> +
> +static int plat_ipk_register_platform_entity(struct plat_ipk_dev *plat_ipk,
> +				struct platform_device *pdev, int plat_entity)
> +{
> +	struct device *dev = &pdev->dev;
> +	int ret = -EPROBE_DEFER;
> +	void *drvdata;
> +
> +	device_lock(dev);
> +	if (!dev->driver || !try_module_get(dev->driver->owner))
> +		goto dev_unlock;
> +
> +	drvdata = dev_get_drvdata(dev);
> +
> +	if (drvdata) {
> +		switch (plat_entity) {
> +		case IDX_VDEV:
> +			ret = register_videodev_entity(plat_ipk, drvdata);
> +			break;
> +		case IDX_CSI:
> +			ret = register_mipi_csi_entity(plat_ipk, pdev, drvdata);
> +			break;
> +		default:
> +			ret = -ENODEV;
> +		}
> +	} else
> +		dev_err(plat_ipk->dev, "%s no drvdata\n", dev_name(dev));
> +	module_put(dev->driver->owner);
> +dev_unlock:
> +	device_unlock(dev);
> +	if (ret == -EPROBE_DEFER)
> +		dev_info(plat_ipk->dev,
> +			 "deferring %s device registration\n", dev_name(dev));
> +	else if (ret < 0)
> +		dev_err(plat_ipk->dev,
> +			"%s device registration failed (%d)\n", dev_name(dev),
> +			ret);
> +	return ret;
> +}
> +
> +static int
> +plat_ipk_register_platform_entities(struct plat_ipk_dev *plat_ipk,
> +				    struct device_node *parent)
> +{
> +	struct device_node *node;
> +	int ret = 0;
> +
> +	for_each_available_child_of_node(parent, node) {
> +		struct platform_device *pdev;
> +		int plat_entity = -1;
> +
> +		pdev = of_find_device_by_node(node);
> +		if (!pdev)
> +			continue;
> +
> +		if (!strcmp(node->name, VIDEODEV_OF_NODE_NAME))
> +			plat_entity = IDX_VDEV;
> +		else if (!strcmp(node->name, CSI_OF_NODE_NAME))
> +			plat_entity = IDX_CSI;
> +
> +		if (plat_entity >= 0)
> +			ret = plat_ipk_register_platform_entity(plat_ipk, pdev,
> +								plat_entity);
> +		put_device(&pdev->dev);
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +static void
> +plat_ipk_unregister_entities(struct plat_ipk_dev *plat_ipk)
> +{
> +	int i;
> +	struct video_device_dev *dev = plat_ipk->vid_dev;
> +
> +	if (dev == NULL)
> +		return;
> +	v4l2_device_unregister_subdev(&dev->subdev);
> +	dev->ve.pipe = NULL;
> +	plat_ipk->vid_dev = NULL;
> +
> +	for (i = 0; i < CSI_MAX_ENTITIES; i++) {
> +		if (plat_ipk->mipi_csi[i].sd == NULL)
> +			continue;
> +		v4l2_device_unregister_subdev(plat_ipk->mipi_csi[i].sd);
> +		plat_ipk->mipi_csi[i].sd = NULL;
> +	}
> +
> +	dev_info(plat_ipk->dev, "Unregistered all entities\n");
> +}
> +
> +static int
> +__plat_ipk_create_videodev_sink_links(struct plat_ipk_dev *plat_ipk,
> +				      struct media_entity *source,
> +				      int pad)
> +{
> +	struct media_entity *sink;
> +	int ret = 0;
> +
> +	if (!plat_ipk->vid_dev)
> +		return 0;
> +
> +	sink = &plat_ipk->vid_dev->subdev.entity;
> +	ret = media_create_pad_link(source, pad, sink,
> +				    CSI_PAD_SOURCE, MEDIA_LNK_FL_ENABLED);
> +	if (ret)
> +		return ret;
> +
> +	dev_dbg(plat_ipk->dev, "created link [%s] -> [%s]\n",
> +		  source->name, sink->name);
> +
> +	return 0;
> +}
> +
> +
> +static int
> +__plat_ipk_create_videodev_source_links(struct plat_ipk_dev *plat_ipk)
> +{
> +	struct media_entity *source, *sink;
> +	int ret = 0;
> +
> +	struct video_device_dev *vid_dev = plat_ipk->vid_dev;
> +
> +	if (vid_dev == NULL)
> +		return -ENODEV;
> +
> +	source = &vid_dev->subdev.entity;
> +	sink = &vid_dev->ve.vdev.entity;
> +
> +	ret = media_create_pad_link(source, VIDEO_DEV_SD_PAD_SOURCE_DMA,
> +				    sink, 0, MEDIA_LNK_FL_ENABLED);
> +
> +	dev_dbg(plat_ipk->dev, "created link [%s] -> [%s]\n",
> +		  source->name, sink->name);
> +	return ret;
> +}
> +
> +static int
> +plat_ipk_create_links(struct plat_ipk_dev *plat_ipk)
> +{
> +	struct v4l2_subdev *csi_sensor[CSI_MAX_ENTITIES] = { NULL };
> +	struct v4l2_subdev *sensor, *csi;
> +	struct media_entity *source;
> +	struct plat_ipk_source_info *pdata;
> +	int i, pad, ret = 0;
> +
> +	for (i = 0; i < plat_ipk->num_sensors; i++) {
> +		if (plat_ipk->sensor[i].subdev == NULL)
> +			continue;
> +
> +		sensor = plat_ipk->sensor[i].subdev;
> +		pdata = v4l2_get_subdev_hostdata(sensor);
> +		if (!pdata)
> +			continue;
> +
> +		source = NULL;
> +
> +		csi = plat_ipk->mipi_csi[pdata->mux_id].sd;
> +		if (WARN(csi == NULL, "MIPI-CSI interface specified but	dw-mipi-csi module is not loaded!\n"))
> +			return -EINVAL;
> +
> +		pad = sensor->entity.num_pads - 1;
> +		ret = media_create_pad_link(&sensor->entity, pad,
> +					    &csi->entity, CSI_PAD_SINK,
> +					    MEDIA_LNK_FL_IMMUTABLE |
> +					    MEDIA_LNK_FL_ENABLED);
> +
> +		if (ret)
> +			return ret;
> +		dev_dbg(plat_ipk->dev, "created link [%s] -> [%s]\n",
> +			  sensor->entity.name, csi->entity.name);
> +
> +		csi_sensor[pdata->mux_id] = sensor;
> +	}
> +
> +	for (i = 0; i < CSI_MAX_ENTITIES; i++) {
> +		if (plat_ipk->mipi_csi[i].sd == NULL) {
> +			dev_info(plat_ipk->dev, "no link\n");
> +			continue;
> +		}
> +
> +		source = &plat_ipk->mipi_csi[i].sd->entity;
> +		pad = VIDEO_DEV_SD_PAD_SINK_CSI;
> +
> +		ret = __plat_ipk_create_videodev_sink_links(plat_ipk, source,
> +								pad);
> +	}
> +
> +	ret = __plat_ipk_create_videodev_source_links(plat_ipk);
> +	if (ret < 0)
> +		return ret;
> +
> +	return ret;
> +}
> +
> +static int __plat_ipk_modify_pipeline(struct media_entity *entity, bool enable)
> +{
> +	struct plat_ipk_video_entity *ve;
> +	struct plat_ipk_pipeline *p;
> +	struct video_device *vdev;
> +	int ret;
> +
> +	vdev = media_entity_to_video_device(entity);
> +
> +	if (vdev->entity.use_count == 0)
> +		return 0;
> +
> +	ve = vdev_to_plat_ipk_video_entity(vdev);
> +	p = to_plat_ipk_pipeline(ve->pipe);
> +
> +	if (enable)
> +		ret = __plat_ipk_pipeline_open(ve->pipe, entity, true);
> +	else
> +		ret = __plat_ipk_pipeline_close(ve->pipe);
> +
> +	if (ret == 0 && !enable)
> +		memset(p->subdevs, 0, sizeof(p->subdevs));
> +
> +	return ret;
> +}
> +
> +
> +static int
> +__plat_ipk_modify_pipelines(struct media_entity *entity, bool enable,
> +			    struct media_entity_graph *graph)
> +{
> +	struct media_entity *entity_err = entity;
> +	int ret;
> +
> +	media_entity_graph_walk_start(graph, entity);
> +
> +	while ((entity = media_entity_graph_walk_next(graph))) {
> +		if (!is_media_entity_v4l2_video_device(entity))
> +			continue;
> +
> +		ret = __plat_ipk_modify_pipeline(entity, enable);
> +
> +		if (ret < 0)
> +			goto err;
> +	}
> +
> +	return 0;
> +
> +err:
> +	media_entity_graph_walk_start(graph, entity_err);
> +
> +	while ((entity_err = media_entity_graph_walk_next(graph))) {
> +		if (!is_media_entity_v4l2_video_device(entity_err))
> +			continue;
> +
> +		__plat_ipk_modify_pipeline(entity_err, !enable);
> +
> +		if (entity_err == entity)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int
> +plat_ipk_link_notify(struct media_link *link, unsigned int flags,
> +		     unsigned int notification)
> +{
> +	struct media_entity_graph *graph =
> +	    &container_of(link->graph_obj.mdev, struct plat_ipk_dev,
> +			  media_dev)->link_setup_graph;
> +	struct media_entity *sink = link->sink->entity;
> +	int ret = 0;
> +
> +	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
> +		ret = media_entity_graph_walk_init(graph, link->graph_obj.mdev);
> +		if (ret)
> +			return ret;
> +		if (!(flags & MEDIA_LNK_FL_ENABLED))
> +			ret = __plat_ipk_modify_pipelines(sink, false, graph);
> +
> +	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH) {
> +		if (link->flags & MEDIA_LNK_FL_ENABLED)
> +			ret = __plat_ipk_modify_pipelines(sink, true, graph);
> +		media_entity_graph_walk_cleanup(graph);
> +	}
> +
> +	return ret ? -EPIPE : 0;
> +}
> +
> +static const struct media_device_ops plat_ipk_media_ops = {
> +	.link_notify = plat_ipk_link_notify,
> +};
> +
> +
> +static int
> +subdev_notifier_bound(struct v4l2_async_notifier *notifier,
> +		      struct v4l2_subdev *subdev, struct v4l2_async_subdev *asd)
> +{
> +	struct plat_ipk_dev *plat_ipk = notifier_to_plat_ipk(notifier);
> +	struct plat_ipk_sensor_info *si = NULL;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(plat_ipk->sensor); i++)
> +		if (plat_ipk->sensor[i].asd.match.of.node ==
> +		    subdev->dev->of_node)
> +			si = &plat_ipk->sensor[i];
> +
> +	if (si == NULL)
> +		return -EINVAL;
> +
> +	v4l2_set_subdev_hostdata(subdev, &si->pdata);
> +
> +	subdev->grp_id = GRP_ID_SENSOR;
> +
> +	si->subdev = subdev;
> +
> +	dev_dbg(&plat_ipk->pdev->dev, "Registered sensor subdevice: %s (%d)\n",
> +		  subdev->name, plat_ipk->num_sensors);
> +
> +	plat_ipk->num_sensors++;
> +
> +	return 0;
> +}
> +
> +static int
> +subdev_notifier_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct plat_ipk_dev *plat_ipk = notifier_to_plat_ipk(notifier);
> +	int ret;
> +
> +	mutex_lock(&plat_ipk->media_dev.graph_mutex);
> +
> +	ret = plat_ipk_create_links(plat_ipk);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	ret = v4l2_device_register_subdev_nodes(&plat_ipk->v4l2_dev);
> +unlock:
> +	mutex_unlock(&plat_ipk->media_dev.graph_mutex);
> +	if (ret < 0)
> +		return ret;
> +
> +	return media_device_register(&plat_ipk->media_dev);
> +}
> +
> +static int plat_ipk_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct v4l2_device *v4l2_dev;
> +	struct plat_ipk_dev *plat_ipk;
> +	int ret;
> +
> +	dev_dbg(dev, "Installing DW MIPI CSI-2 IPK Platform module\n");
> +
> +	plat_ipk = devm_kzalloc(dev, sizeof(*plat_ipk), GFP_KERNEL);
> +	if (!plat_ipk)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&plat_ipk->slock);
> +	INIT_LIST_HEAD(&plat_ipk->pipelines);
> +	plat_ipk->pdev = pdev;
> +
> +	strlcpy(plat_ipk->media_dev.model, "SNPS IPK Platform",
> +		sizeof(plat_ipk->media_dev.model));
> +	plat_ipk->media_dev.ops = &plat_ipk_media_ops;
> +	plat_ipk->media_dev.dev = dev;
> +
> +	v4l2_dev = &plat_ipk->v4l2_dev;
> +	v4l2_dev->mdev = &plat_ipk->media_dev;
> +	strlcpy(v4l2_dev->name, "plat-ipk", sizeof(v4l2_dev->name));
> +
> +	media_device_init(&plat_ipk->media_dev);
> +
> +	ret = v4l2_device_register(dev, &plat_ipk->v4l2_dev);
> +	if (ret < 0) {
> +		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, plat_ipk);
> +
> +	ret = plat_ipk_register_platform_entities(plat_ipk, dev->of_node);
> +	if (ret)
> +		goto err_m_ent;
> +
> +	ret = plat_ipk_register_sensor_entities(plat_ipk);
> +	if (ret)
> +		goto err_m_ent;
> +
> +	if (plat_ipk->num_sensors > 0) {
> +		plat_ipk->subdev_notifier.subdevs = plat_ipk->async_subdevs;
> +		plat_ipk->subdev_notifier.num_subdevs = plat_ipk->num_sensors;
> +		plat_ipk->subdev_notifier.bound = subdev_notifier_bound;
> +		plat_ipk->subdev_notifier.complete = subdev_notifier_complete;
> +		plat_ipk->num_sensors = 0;
> +
> +		ret = v4l2_async_notifier_register(&plat_ipk->v4l2_dev,
> +						   &plat_ipk->subdev_notifier);
> +		if (ret)
> +			goto err_m_ent;
> +	}
> +
> +	return 0;
> +
> +err_m_ent:
> +	plat_ipk_unregister_entities(plat_ipk);
> +	media_device_unregister(&plat_ipk->media_dev);
> +	media_device_cleanup(&plat_ipk->media_dev);
> +	v4l2_device_unregister(&plat_ipk->v4l2_dev);
> +	return ret;
> +}
> +
> +static int plat_ipk_remove(struct platform_device *pdev)
> +{
> +	struct plat_ipk_dev *dev = platform_get_drvdata(pdev);
> +
> +	v4l2_async_notifier_unregister(&dev->subdev_notifier);
> +
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	plat_ipk_unregister_entities(dev);
> +	plat_ipk_pipelines_free(dev);
> +	media_device_unregister(&dev->media_dev);
> +	media_device_cleanup(&dev->media_dev);
> +
> +	dev_info(&pdev->dev, "Driver removed\n");
> +
> +	return 0;
> +}
> +
> +/**
> + * @short of_device_id structure
> + */
> +static const struct of_device_id plat_ipk_of_match[] = {
> +	{.compatible = "snps,plat-ipk"},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(of, plat_ipk_of_match);
> +
> +/**
> + * @short Platform driver structure
> + */
> +static struct platform_driver plat_ipk_pdrv = {
> +	.remove = plat_ipk_remove,
> +	.probe = plat_ipk_probe,
> +	.driver = {
> +		   .name = "snps,plat-ipk",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = plat_ipk_of_match,
> +		   },
> +};
> +
> +static int __init
> +plat_ipk_init(void)
> +{
> +	request_module("dw-mipi-csi");
> +
> +	return platform_driver_register(&plat_ipk_pdrv);
> +}
> +
> +static void __exit
> +plat_ipk_exit(void)
> +{
> +	platform_driver_unregister(&plat_ipk_pdrv);
> +}
> +
> +module_init(plat_ipk_init);
> +module_exit(plat_ipk_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Ramiro Oliveira <roliveir@synopsys.com>");
> +MODULE_DESCRIPTION("Platform driver for MIPI CSI-2 Host IPK");
> diff --git a/drivers/media/platform/dwc/plat_ipk.h b/drivers/media/platform/dwc/plat_ipk.h
> new file mode 100644
> index 0000000..ff2f98b
> --- /dev/null
> +++ b/drivers/media/platform/dwc/plat_ipk.h
> @@ -0,0 +1,101 @@
> +/*
> + * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef PLAT_IPK_H_
> +#define PLAT_IPK_H_
> +
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/videodev2.h>
> +#include <media/media-entity.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +
> +#include "dw_mipi_csi.h"
> +#include "plat_ipk_video.h"
> +#include "video_device.h"
> +
> +#define VIDEODEV_OF_NODE_NAME	"video-device"
> +#define CSI_OF_NODE_NAME	"csi2"
> +
> +enum plat_ipk_subdev_index {
> +	IDX_SENSOR,
> +	IDX_CSI,
> +	IDX_VDEV,
> +	IDX_MAX,
> +};
> +
> +struct plat_ipk_sensor_info {
> +	struct plat_ipk_source_info pdata;
> +	struct v4l2_async_subdev asd;
> +	struct v4l2_subdev *subdev;
> +	struct mipi_csi_dev *host;
> +};
> +
> +struct plat_ipk_pipeline {
> +	struct plat_ipk_media_pipeline ep;
> +	struct list_head list;
> +	struct media_entity *vdev_entity;
> +	struct v4l2_subdev *subdevs[IDX_MAX];
> +};
> +
> +#define to_plat_ipk_pipeline(_ep)\
> +	 container_of(_ep, struct plat_ipk_pipeline, ep)
> +
> +struct mipi_csi_info {
> +	struct v4l2_subdev *sd;
> +	int id;
> +};
> +
> +/**
> + * @short Structure to embed device driver information
> + */
> +struct plat_ipk_dev {
> +	struct mipi_csi_info		mipi_csi[CSI_MAX_ENTITIES];
> +	struct video_device_dev		*vid_dev;
> +	struct device			*dev;
> +	struct media_device		media_dev;
> +	struct v4l2_device		v4l2_dev;
> +	struct platform_device		*pdev;
> +	struct plat_ipk_sensor_info	sensor[PLAT_MAX_SENSORS];
> +	struct v4l2_async_notifier	subdev_notifier;
> +	struct v4l2_async_subdev	*async_subdevs[PLAT_MAX_SENSORS];
> +	spinlock_t			slock;
> +	struct list_head		pipelines;
> +	int				num_sensors;
> +	struct media_entity_graph	link_setup_graph;
> +};
> +
> +static inline struct plat_ipk_dev *
> +entity_to_plat_ipk_mdev(struct media_entity *me)
> +{
> +	return me->graph_obj.mdev == NULL ? NULL :
> +	    container_of(me->graph_obj.mdev, struct plat_ipk_dev, media_dev);
> +}
> +
> +static inline struct plat_ipk_dev *
> +notifier_to_plat_ipk(struct v4l2_async_notifier *n)
> +{
> +	return container_of(n, struct plat_ipk_dev, subdev_notifier);
> +}
> +
> +static inline void
> +plat_ipk_graph_unlock(struct plat_ipk_video_entity *ve)
> +{
> +	mutex_unlock(&ve->vdev.entity.graph_obj.mdev->graph_mutex);
> +}
> +
> +#endif				/* PLAT_IPK_H_ */
> diff --git a/drivers/media/platform/dwc/plat_ipk_video.h b/drivers/media/platform/dwc/plat_ipk_video.h
> new file mode 100644
> index 0000000..9956ead
> --- /dev/null
> +++ b/drivers/media/platform/dwc/plat_ipk_video.h
> @@ -0,0 +1,97 @@
> +/*
> + * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef PLAT_IPK_INCLUDES_H_
> +#define PLAT_IPK_INCLUDES_H_
> +
> +#include <media/media-entity.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-mediabus.h>
> +#include <media/v4l2-subdev.h>
> +
> +/*
> + * The subdevices' group IDs.
> + */
> +
> +#define MAX_WIDTH	3280
> +#define MAX_HEIGHT	1852
> +
> +#define MIN_WIDTH	640
> +#define MIN_HEIGHT	480
> +
> +#define GRP_ID_SENSOR		(10)
> +#define GRP_ID_CSI		(20)
> +#define GRP_ID_VIDEODEV		(30)
> +
> +#define CSI_MAX_ENTITIES	1
> +#define PLAT_MAX_SENSORS	1
> +
> +enum video_dev_pads {
> +	VIDEO_DEV_SD_PAD_SINK_CSI = 0,
> +	VIDEO_DEV_SD_PAD_SOURCE_DMA = 1,
> +	VIDEO_DEV_SD_PADS_NUM = 2,
> +};
> +
> +enum mipi_csi_pads {
> +	CSI_PAD_SINK = 0,
> +	CSI_PAD_SOURCE = 1,
> +	CSI_PADS_NUM = 2,
> +};
> +
> +struct plat_ipk_source_info {
> +	u16 flags;
> +	u16 mux_id;
> +};
> +
> +struct plat_ipk_fmt {
> +	char *name;
> +	u32 mbus_code;
> +	u32 fourcc;
> +	u8 depth;
> +};
> +
> +struct plat_ipk_media_pipeline;
> +
> +/*
> + * Media pipeline operations to be called from within a video node,  i.e. the
> + * last entity within the pipeline. Implemented by related media device driver.
> + */
> +struct plat_ipk_media_pipeline_ops {
> +	int (*prepare)(struct plat_ipk_media_pipeline *p,
> +			struct media_entity *me);
> +	int (*unprepare)(struct plat_ipk_media_pipeline *p);
> +	int (*open)(struct plat_ipk_media_pipeline *p,
> +			struct media_entity *me, bool resume);
> +	int (*close)(struct plat_ipk_media_pipeline *p);
> +	int (*set_stream)(struct plat_ipk_media_pipeline *p, bool state);
> +	int (*set_format)(struct plat_ipk_media_pipeline *p,
> +			struct v4l2_subdev_format *fmt);
> +};
> +
> +struct plat_ipk_video_entity {
> +	struct video_device vdev;
> +	struct plat_ipk_media_pipeline *pipe;
> +};
> +
> +struct plat_ipk_media_pipeline {
> +	struct media_pipeline mp;
> +	const struct plat_ipk_media_pipeline_ops *ops;
> +};
> +
> +static inline struct plat_ipk_video_entity *
> +vdev_to_plat_ipk_video_entity(struct video_device *vdev)
> +{
> +	return container_of(vdev, struct plat_ipk_video_entity, vdev);
> +}
> +
> +#define plat_ipk_pipeline_call(ent, op, args...)\
> +	(!(ent) ? -ENOENT : (((ent)->pipe->ops && (ent)->pipe->ops->op) ? \
> +	(ent)->pipe->ops->op(((ent)->pipe), ##args) : -ENOIOCTLCMD))	  \
> +
> +
> +#endif				/* PLAT_IPK_INCLUDES_H_ */
> diff --git a/drivers/media/platform/dwc/video_device.c b/drivers/media/platform/dwc/video_device.c
> new file mode 100644
> index 0000000..8e7033c
> --- /dev/null
> +++ b/drivers/media/platform/dwc/video_device.c
> @@ -0,0 +1,707 @@
> +/*
> + * DWC MIPI CSI-2 Host IPK video device device driver
> + *
> + * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
> + * Author: Ramiro Oliveira <ramiro.oliveira@synopsys.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */
> +
> +#include "video_device.h"
> +
> +static const struct plat_ipk_fmt vid_dev_formats[] = {
> +	{
> +		.name = "BGR888",
> +		.fourcc = V4L2_PIX_FMT_BGR24,
> +		.depth = 24,
> +		.mbus_code = MEDIA_BUS_FMT_RGB888_2X12_LE,
> +	}, {
> +		.name = "RGB565",
> +		.fourcc = V4L2_PIX_FMT_RGB565,
> +		.depth = 16,
> +		.mbus_code = MEDIA_BUS_FMT_RGB565_2X8_BE,
> +	},
> +};
> +
> +static const struct plat_ipk_fmt *
> +vid_dev_find_format(struct v4l2_format *f, int index)
> +{
> +	const struct plat_ipk_fmt *fmt = NULL;
> +	unsigned int i;
> +
> +	if (index >= (int) ARRAY_SIZE(vid_dev_formats))
> +		return NULL;

???

What's the purpose of the index argument? I get the feeling it is
a left-over from older code.

> +
> +	for (i = 0; i < ARRAY_SIZE(vid_dev_formats); ++i) {
> +		fmt = &vid_dev_formats[i];
> +		if (fmt->fourcc == f->fmt.pix.pixelformat)
> +			return fmt;
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * Video node ioctl operations
> + */
> +static int
> +vidioc_querycap(struct file *file, void *priv, struct v4l2_capability *cap)
> +{
> +	struct video_device_dev *vid_dev = video_drvdata(file);
> +
> +	strlcpy(cap->driver, VIDEO_DEVICE_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, VIDEO_DEVICE_NAME, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(&vid_dev->pdev->dev));
> +
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

Set the device_caps in struct video_device and drop these two lines.
The core will fill those in for you.

> +	return 0;
> +}
> +
> +static int
> +vidioc_enum_fmt_vid_cap(struct file *file, void *priv, struct v4l2_fmtdesc *f)
> +{
> +	const struct plat_ipk_fmt *p_fmt;
> +
> +	if (f->index >= ARRAY_SIZE(vid_dev_formats))
> +		return -EINVAL;
> +
> +	p_fmt = &vid_dev_formats[f->index];
> +
> +	strlcpy(f->description, p_fmt->name, sizeof(f->description));

Don't set the description, the core will do that for you.

> +	f->pixelformat = p_fmt->fourcc;
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> +					struct v4l2_format *f)
> +{
> +	struct video_device_dev *dev = video_drvdata(file);
> +
> +	memcpy(&f->fmt.pix, &dev->format.fmt.pix,
> +	       sizeof(struct v4l2_pix_format));

Use f->fmt.pix = dev->format.fmt.pix;

> +
> +	return 0;
> +}
> +
> +static int
> +vidioc_try_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	const struct plat_ipk_fmt *fmt;
> +
> +	fmt = vid_dev_find_format(f, -1);
> +	if (!fmt) {
> +		f->fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565;
> +		fmt = vid_dev_find_format(f, -1);
> +	}
> +
> +	f->fmt.pix.field = V4L2_FIELD_NONE;
> +	v4l_bound_align_image(&f->fmt.pix.width, 48, MAX_WIDTH, 2,
> +			      &f->fmt.pix.height, 32, MAX_HEIGHT, 0, 0);
> +
> +	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
> +	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
> +	return 0;
> +}
> +
> +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> +					struct v4l2_format *f)
> +{
> +	struct video_device_dev *dev = video_drvdata(file);
> +	int ret;
> +	struct v4l2_subdev_format fmt;
> +	struct v4l2_pix_format *dev_fmt_pix = &dev->format.fmt.pix;
> +
> +	if (vb2_is_busy(&dev->vb_queue))
> +		return -EBUSY;
> +
> +	ret = vidioc_try_fmt_vid_cap(file, dev, f);
> +	if (ret)
> +		return ret;
> +
> +	dev->fmt = vid_dev_find_format(f, -1);
> +	dev_fmt_pix->pixelformat = f->fmt.pix.pixelformat;
> +	dev_fmt_pix->width = f->fmt.pix.width;
> +	dev_fmt_pix->height  = f->fmt.pix.height;
> +	dev_fmt_pix->bytesperline = dev_fmt_pix->width * (dev->fmt->depth / 8);
> +	dev_fmt_pix->sizeimage =
> +			dev_fmt_pix->height * dev_fmt_pix->bytesperline;
> +
> +	fmt.format.colorspace = V4L2_COLORSPACE_SRGB;
> +	fmt.format.code = dev->fmt->mbus_code;
> +
> +	fmt.format.width = dev_fmt_pix->width;
> +	fmt.format.height = dev_fmt_pix->height;
> +
> +	ret = plat_ipk_pipeline_call(&dev->ve, set_format, &fmt);
> +
> +	return 0;
> +}
> +
> +static int vidioc_enum_framesizes(struct file *file, void *fh,
> +		       struct v4l2_frmsizeenum *fsize)
> +{
> +	static const struct v4l2_frmsize_stepwise sizes = {
> +		48, MAX_WIDTH, 4,
> +		32, MAX_HEIGHT, 1
> +	};
> +	int i;
> +
> +	if (fsize->index)
> +		return -EINVAL;
> +	for (i = 0; i < ARRAY_SIZE(vid_dev_formats); i++)
> +		if (vid_dev_formats[i].fourcc == fsize->pixel_format)
> +			break;
> +	if (i == ARRAY_SIZE(vid_dev_formats))
> +		return -EINVAL;
> +	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> +	fsize->stepwise = sizes;
> +	return 0;
> +}
> +
> +static int vidioc_enum_input(struct file *file, void *priv,
> +			struct v4l2_input *input)
> +{
> +	if (input->index != 0)
> +		return -EINVAL;
> +
> +	input->type = V4L2_INPUT_TYPE_CAMERA;
> +	input->std = V4L2_STD_ALL;	/* Not sure what should go here */

Set this to 0, or just drop the line.

> +	strcpy(input->name, "Camera");
> +	return 0;
> +}
> +
> +static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	if (i != 0)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int
> +vid_dev_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
> +{
> +	struct video_device_dev *vid_dev = video_drvdata(file);
> +	struct media_entity *entity = &vid_dev->ve.vdev.entity;
> +	int ret;
> +
> +	ret = media_entity_pipeline_start(entity, &vid_dev->ve.pipe->mp);
> +	if (ret < 0)
> +		return ret;
> +
> +	vb2_ioctl_streamon(file, priv, type);
> +	if (!ret)
> +		return ret;
> +
> +	media_entity_pipeline_stop(entity);
> +	return 0;
> +}
> +
> +static int
> +vid_dev_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
> +{
> +	struct video_device_dev *vid_dev = video_drvdata(file);
> +	int ret;
> +
> +	ret = vb2_ioctl_streamoff(file, priv, type);
> +	if (ret < 0)
> +		return ret;
> +
> +	media_entity_pipeline_stop(&vid_dev->ve.vdev.entity);
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops vid_dev_ioctl_ops = {
> +	.vidioc_querycap = vidioc_querycap,
> +	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
> +	.vidioc_enum_framesizes = vidioc_enum_framesizes,
> +	.vidioc_enum_input = vidioc_enum_input,
> +	.vidioc_g_input = vidioc_g_input,
> +	.vidioc_s_input = vidioc_s_input,
> +
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> +	.vidioc_streamon = vid_dev_streamon,
> +	.vidioc_streamoff = vid_dev_streamoff,
> +};
> +
> +static int
> +vid_dev_open(struct file *file)
> +{
> +	struct video_device_dev *vid_dev = video_drvdata(file);
> +	struct media_entity *me = &vid_dev->ve.vdev.entity;
> +	int ret;
> +
> +	mutex_lock(&vid_dev->lock);
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		goto unlock;
> +
> +	mutex_lock(&me->graph_obj.mdev->graph_mutex);
> +
> +	ret = plat_ipk_pipeline_call(&vid_dev->ve, open, me, true);
> +	if (ret == 0)
> +		me->use_count++;
> +
> +	mutex_unlock(&me->graph_obj.mdev->graph_mutex);
> +
> +	if (!ret)
> +		goto unlock;
> +
> +	v4l2_fh_release(file);
> +unlock:
> +	mutex_unlock(&vid_dev->lock);
> +	return ret;
> +}
> +
> +static int
> +vid_dev_release(struct file *file)
> +{
> +	struct video_device_dev *vid_dev = video_drvdata(file);
> +	struct media_entity *entity = &vid_dev->ve.vdev.entity;
> +
> +	mutex_lock(&vid_dev->lock);
> +
> +	if (v4l2_fh_is_singular_file(file)) {
> +		plat_ipk_pipeline_call(&vid_dev->ve, close);
> +		mutex_lock(&entity->graph_obj.mdev->graph_mutex);
> +		entity->use_count--;
> +		mutex_unlock(&entity->graph_obj.mdev->graph_mutex);
> +	}
> +
> +	_vb2_fop_release(file, NULL);
> +
> +	mutex_unlock(&vid_dev->lock);
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations vid_dev_fops = {
> +	.owner = THIS_MODULE,
> +	.open = vid_dev_open,
> +	.release = vid_dev_release,
> +	.write = vb2_fop_write,
> +	.read = vb2_fop_read,
> +	.poll = vb2_fop_poll,
> +	.unlocked_ioctl = video_ioctl2,
> +	.mmap = vb2_fop_mmap,
> +};
> +
> +/*
> + * VideoBuffer2 operations
> + */
> +
> +static void fill_buffer(struct video_device_dev *dev, struct rx_buffer *buf,
> +			int buf_num, unsigned long flags)
> +{
> +	int size = 0;
> +	void *vbuf = NULL;
> +
> +	if (&buf->vb == NULL)
> +		return;
> +
> +	size = vb2_plane_size(&buf->vb.vb2_buf, 0);
> +	vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
> +
> +	if (vbuf) {
> +		spin_unlock_irqrestore(&dev->slock, flags);
> +
> +		memcpy(vbuf, dev->dma_buf[buf_num].cpu_addr, size);
> +
> +		spin_lock_irqsave(&dev->slock, flags);
> +
> +		buf->vb.field = dev->format.fmt.pix.field;
> +		buf->vb.sequence++;
> +		buf->vb.vb2_buf.timestamp = ktime_get_ns();
> +	}
> +	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
> +}
> +
> +static void buffer_copy_process(void *param)
> +{
> +	struct video_device_dev *dev = (struct video_device_dev *) param;
> +	unsigned long flags;
> +	struct dmaqueue *dma_q = &dev->vidq;
> +	struct rx_buffer *buf = NULL;
> +
> +	spin_lock_irqsave(&dev->slock, flags);
> +
> +	if (!list_empty(&dma_q->active)) {
> +		buf = list_entry(dma_q->active.next, struct rx_buffer, list);
> +		list_del(&buf->list);
> +		fill_buffer(dev, buf, dev->last_idx, flags);
> +	}
> +
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +}
> +
> +static inline struct rx_buffer *to_rx_buffer(struct vb2_v4l2_buffer *vb2)
> +{
> +	return container_of(vb2, struct rx_buffer, vb);
> +}
> +
> +static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> +			unsigned int *nplanes, unsigned int sizes[],
> +			struct device *alloc_devs[])
> +{
> +	struct video_device_dev *dev = vb2_get_drv_priv(vq);
> +	unsigned long size = 0;
> +	int i;
> +
> +	size = dev->format.fmt.pix.sizeimage;
> +	if (size == 0)
> +		return -EINVAL;
> +
> +	*nbuffers = N_BUFFERS;
> +
> +	for (i = 0; i < N_BUFFERS; i++) {
> +		dev->dma_buf[i].cpu_addr = dma_alloc_coherent(&dev->pdev->dev,
> +						dev->format.fmt.pix.sizeimage,
> +						&dev->dma_buf[i].dma_addr,
> +						GFP_KERNEL);
> +	}
> +
> +	*nplanes = 1;
> +	sizes[0] = size;
> +
> +	return 0;
> +}
> +
> +static int buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct rx_buffer *buf = NULL;
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	int size = 0;
> +
> +	if (vb == NULL) {
> +		pr_warn("%s:vb2_buffer is null\n", FUNC_NAME);
> +		return 0;
> +	}
> +
> +	buf = to_rx_buffer(vbuf);
> +
> +	size = vb2_plane_size(&buf->vb.vb2_buf, 0);
> +	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
> +
> +	INIT_LIST_HEAD(&buf->list);
> +	return 0;
> +}
> +
> +static void buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct video_device_dev *dev = NULL;
> +	struct rx_buffer *buf = NULL;
> +	struct dmaqueue *vidq = NULL;
> +	struct dma_async_tx_descriptor *desc;
> +	u32 flags;
> +
> +	if (vb == NULL) {
> +		pr_warn("%s:vb2_buffer is null\n", FUNC_NAME);
> +		return;
> +	}
> +
> +	dev = vb2_get_drv_priv(vb->vb2_queue);
> +	buf = to_rx_buffer(vbuf);
> +	vidq = &dev->vidq;
> +
> +	flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
> +	dev->xt.dir = DMA_DEV_TO_MEM;
> +	dev->xt.src_sgl = false;
> +	dev->xt.dst_inc = false;
> +	dev->xt.dst_sgl = true;
> +	dev->xt.dst_start = dev->dma_buf[dev->idx].dma_addr;
> +
> +	dev->last_idx = dev->idx;
> +	dev->idx++;
> +	if (dev->idx >= N_BUFFERS)
> +		dev->idx = 0;
> +
> +	dev->xt.frame_size = 1;
> +	dev->sgl[0].size = dev->format.fmt.pix.bytesperline;
> +	dev->sgl[0].icg = 0;
> +	dev->xt.numf = dev->format.fmt.pix.height;
> +
> +	desc = dmaengine_prep_interleaved_dma(dev->dma, &dev->xt, flags);
> +	if (!desc) {
> +		pr_err("Failed to prepare DMA transfer\n");
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +		return;
> +	}
> +
> +	desc->callback = buffer_copy_process;
> +	desc->callback_param = dev;
> +
> +	spin_lock(&dev->slock);
> +	list_add_tail(&buf->list, &vidq->active);
> +	spin_unlock(&dev->slock);
> +
> +	dmaengine_submit(desc);
> +
> +	if (vb2_is_streaming(&dev->vb_queue))
> +		dma_async_issue_pending(dev->dma);
> +}
> +
> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct video_device_dev *dev = vb2_get_drv_priv(vq);
> +
> +	dma_async_issue_pending(dev->dma);
> +
> +	return 0;
> +}
> +
> +static void stop_streaming(struct vb2_queue *vq)
> +{
> +	struct video_device_dev *dev = vb2_get_drv_priv(vq);
> +	struct dmaqueue *dma_q = &dev->vidq;
> +
> +	/* Stop and reset the DMA engine. */
> +	dmaengine_terminate_all(dev->dma);
> +
> +	while (!list_empty(&dma_q->active)) {
> +		struct rx_buffer *buf;
> +
> +		buf = list_entry(dma_q->active.next, struct rx_buffer, list);
> +		if (buf) {
> +			list_del(&buf->list);
> +			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +		}
> +	}
> +	list_del_init(&dev->vidq.active);
> +}
> +
> +static const struct vb2_ops vb2_video_qops = {
> +	.queue_setup = queue_setup,
> +	.buf_prepare = buffer_prepare,
> +	.buf_queue = buffer_queue,
> +	.start_streaming = start_streaming,
> +	.stop_streaming = stop_streaming,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +};
> +
> +static int vid_dev_subdev_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	return 0;
> +}

Just drop this empty function, shouldn't be needed.

> +
> +static int vid_dev_subdev_registered(struct v4l2_subdev *sd)
> +{
> +	struct video_device_dev *vid_dev = v4l2_get_subdevdata(sd);
> +	struct vb2_queue *q = &vid_dev->vb_queue;
> +	struct video_device *vfd = &vid_dev->ve.vdev;
> +	int ret;
> +
> +	memset(vfd, 0, sizeof(*vfd));
> +
> +	strlcpy(vfd->name, VIDEO_DEVICE_NAME, sizeof(vfd->name));
> +
> +	vfd->fops = &vid_dev_fops;
> +	vfd->ioctl_ops = &vid_dev_ioctl_ops;
> +	vfd->v4l2_dev = sd->v4l2_dev;
> +	vfd->minor = -1;
> +	vfd->release = video_device_release_empty;
> +	vfd->queue = q;
> +
> +	INIT_LIST_HEAD(&vid_dev->vidq.active);
> +	init_waitqueue_head(&vid_dev->vidq.wq);
> +	memset(q, 0, sizeof(*q));
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR;

Add VB2_DMABUF and VB2_READ.

> +	q->ops = &vb2_video_qops;
> +	q->mem_ops = &vb2_vmalloc_memops;

Why is vmalloc used? Can't you use dma_contig or dma_sg and avoid having to copy
the image data? That's a really bad design given the amount of video data that
you have to copy.

> +	q->buf_struct_size = sizeof(struct rx_buffer);
> +	q->drv_priv = vid_dev;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock = &vid_dev->lock;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret < 0)
> +		return ret;
> +
> +	vid_dev->vd_pad.flags = MEDIA_PAD_FL_SINK;
> +	ret = media_entity_pads_init(&vfd->entity, 1, &vid_dev->vd_pad);
> +	if (ret < 0)
> +		return ret;
> +
> +	video_set_drvdata(vfd, vid_dev);
> +	vid_dev->ve.pipe = v4l2_get_subdev_hostdata(sd);
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		media_entity_cleanup(&vfd->entity);
> +		vid_dev->ve.pipe = NULL;
> +		return ret;
> +	}
> +
> +	v4l2_info(sd->v4l2_dev, "Registered %s as /dev/%s\n",
> +		  vfd->name, video_device_node_name(vfd));
> +	return 0;
> +}
> +
> +static void vid_dev_subdev_unregistered(struct v4l2_subdev *sd)
> +{
> +	struct video_device_dev *vid_dev = v4l2_get_subdevdata(sd);
> +
> +	if (vid_dev == NULL)
> +		return;
> +
> +	mutex_lock(&vid_dev->lock);
> +
> +	if (video_is_registered(&vid_dev->ve.vdev)) {
> +		video_unregister_device(&vid_dev->ve.vdev);
> +		media_entity_cleanup(&vid_dev->ve.vdev.entity);
> +		vid_dev->ve.pipe = NULL;
> +	}
> +
> +	mutex_unlock(&vid_dev->lock);
> +}
> +
> +static const struct v4l2_subdev_internal_ops vid_dev_subdev_internal_ops = {
> +	.registered = vid_dev_subdev_registered,
> +	.unregistered = vid_dev_subdev_unregistered,
> +};
> +
> +static const struct v4l2_subdev_core_ops vid_dev_subdev_core_ops = {
> +	.s_power = vid_dev_subdev_s_power,
> +};
> +
> +static struct v4l2_subdev_ops vid_dev_subdev_ops = {
> +	.core = &vid_dev_subdev_core_ops,
> +};
> +
> +static int vid_dev_create_capture_subdev(struct video_device_dev *vid_dev)
> +{
> +	struct v4l2_subdev *sd = &vid_dev->subdev;
> +	int ret;
> +
> +	v4l2_subdev_init(sd, &vid_dev_subdev_ops);
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	snprintf(sd->name, sizeof(sd->name), "Capture device");
> +
> +	vid_dev->subdev_pads[VIDEO_DEV_SD_PAD_SINK_CSI].flags =
> +		MEDIA_PAD_FL_SOURCE;
> +	vid_dev->subdev_pads[VIDEO_DEV_SD_PAD_SOURCE_DMA].flags =
> +		MEDIA_PAD_FL_SINK;
> +	ret = media_entity_pads_init(&sd->entity, VIDEO_DEV_SD_PADS_NUM,
> +				   vid_dev->subdev_pads);
> +	if (ret)
> +		return ret;
> +
> +	sd->internal_ops = &vid_dev_subdev_internal_ops;
> +	sd->owner = THIS_MODULE;
> +	v4l2_set_subdevdata(sd, vid_dev);
> +
> +	return 0;
> +}
> +
> +static void vid_dev_unregister_subdev(struct video_device_dev *vid_dev)
> +{
> +	struct v4l2_subdev *sd = &vid_dev->subdev;
> +
> +	v4l2_device_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	v4l2_set_subdevdata(sd, NULL);
> +}
> +
> +static const struct of_device_id vid_dev_of_match[];
> +
> +static int vid_dev_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	const struct of_device_id *of_id;
> +	int ret = 0;
> +	struct video_device_dev *vid_dev;
> +
> +	dev_dbg(dev, "Installing IPK Video Device module\n");
> +
> +	if (!dev->of_node)
> +		return -ENODEV;
> +
> +	vid_dev = devm_kzalloc(dev, sizeof(*vid_dev), GFP_KERNEL);
> +	if (!vid_dev)
> +		return -ENOMEM;
> +
> +	of_id = of_match_node(vid_dev_of_match, dev->of_node);
> +	if (WARN_ON(of_id == NULL))
> +		return -EINVAL;
> +
> +	vid_dev->pdev = pdev;
> +
> +	spin_lock_init(&vid_dev->slock);
> +	mutex_init(&vid_dev->lock);
> +
> +	dev_dbg(&pdev->dev, "Requesting DMA\n");
> +	vid_dev->dma = dma_request_slave_channel(&pdev->dev, "vdma0");
> +	if (vid_dev->dma == NULL) {
> +		dev_err(&pdev->dev, "no VDMA channel found\n");
> +		ret = -ENODEV;
> +		goto end;
> +	}
> +
> +	ret = vid_dev_create_capture_subdev(vid_dev);
> +	if (ret)
> +		goto end;
> +
> +	platform_set_drvdata(pdev, vid_dev);
> +
> +	dev_info(dev, "Video Device registered successfully\n");
> +	return 0;
> +end:
> +	dev_err(dev, "Video Device not registered!!\n");
> +	return ret;
> +}
> +
> +static int vid_dev_remove(struct platform_device *pdev)
> +{
> +	struct video_device_dev *dev = platform_get_drvdata(pdev);
> +
> +	vid_dev_unregister_subdev(dev);
> +	dev_info(&pdev->dev, "Driver removed\n");
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id vid_dev_of_match[] = {
> +	{.compatible = "snps,video-device"},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(of, vid_dev_of_match);
> +
> +static struct platform_driver __refdata vid_dev_pdrv = {
> +	.remove = vid_dev_remove,
> +	.probe = vid_dev_probe,
> +	.driver = {
> +		   .name = VIDEO_DEVICE_NAME,
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = vid_dev_of_match,
> +		   },
> +};
> +
> +module_platform_driver(vid_dev_pdrv);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Ramiro Oliveira <roliveir@synopsys.com>");
> +MODULE_DESCRIPTION("Driver for configuring DMA and Video Device");
> diff --git a/drivers/media/platform/dwc/video_device.h b/drivers/media/platform/dwc/video_device.h
> new file mode 100644
> index 0000000..2d8a1a0
> --- /dev/null
> +++ b/drivers/media/platform/dwc/video_device.h
> @@ -0,0 +1,85 @@
> +/*
> + * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef VIDEO_DEVICE_H_
> +#define VIDEO_DEVICE_H_
> +
> +#include <linux/delay.h>
> +#include <linux/dma/xilinx_dma.h>
> +#include <linux/errno.h>
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of_irq.h>
> +#include <linux/platform_device.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/videodev2.h>
> +#include <linux/wait.h>
> +#include <media/media-entity.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-vmalloc.h>
> +
> +
> +
> +#include "plat_ipk_video.h"
> +
> +#define N_BUFFERS 3
> +
> +#define VIDEO_DEVICE_NAME	"video-device"
> +
> +#define FUNC_NAME __func__
> +
> +struct rx_buffer {
> +	/** @short Buffer for video frames */
> +	struct vb2_v4l2_buffer vb;
> +	struct list_head list;
> +
> +	dma_addr_t dma_addr;
> +	void *cpu_addr;
> +};
> +
> +struct dmaqueue {
> +	struct list_head active;
> +	wait_queue_head_t wq;
> +};
> +
> +/**
> + * @short Structure to embed device driver information
> + */
> +struct video_device_dev {
> +	struct platform_device *pdev;
> +	struct v4l2_device *v4l2_dev;
> +	struct v4l2_subdev subdev;
> +	struct media_pad vd_pad;
> +	struct media_pad subdev_pads[VIDEO_DEV_SD_PADS_NUM];
> +	struct mutex lock;
> +	spinlock_t slock;
> +	struct plat_ipk_video_entity ve;
> +	struct v4l2_format format;
> +	struct v4l2_pix_format pix_format;
> +	const struct plat_ipk_fmt *fmt;
> +	unsigned long *alloc_ctx;
> +
> +	/* Buffer and DMA */
> +	struct vb2_queue vb_queue;
> +	int idx;
> +	int last_idx;
> +	struct dmaqueue vidq;
> +	struct rx_buffer dma_buf[N_BUFFERS];
> +	struct dma_chan *dma;
> +	struct dma_interleaved_template xt;
> +	struct data_chunk sgl[1];
> +};
> +
> +#endif				/* VIDEO_DEVICE_H_ */
>

Regards,

	Hans
