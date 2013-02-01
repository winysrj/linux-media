Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41655 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030202Ab3BALF2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 06:05:28 -0500
Message-id: <510BA174.1010602@samsung.com>
Date: Fri, 01 Feb 2013 12:05:24 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
	'linux-arm-kernel' <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] s5p-fimc: Redefine platform data structure for fimc-is
References: <1359566606-31394-1-git-send-email-s.nawrocki@samsung.com>
 <1359566606-31394-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1359566606-31394-6-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/30/2013 06:23 PM, Sylwester Nawrocki wrote:
> Newer Exynos4 SoC are equipped with a local camera ISP that
> controls external raw image sensor directly. Such sensors
> can be connected through FIMC-LITEn (and MIPI-CSISn) IPs to
> the ISP, which then feeds image data to the FIMCn IP. Thus
> there can be two busses associated with an image source
> (sensor). Rename struct s5p_fimc_isp_info describing external
> image sensor (video decoder) to struct fimc_source_info to
> avoid confusion. bus_type is split into fimc_bus_type and
> sensor_bus_type. The bus type enumeration is extended to
> include both FIMC Writeback input types.
> 
> The bus_type enumeration and the data structure name in the
> board files are modified according to the above changes.
> 
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: linux-samsung-soc@vger.kernel.org
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Kukjin, can I please have your ack on this patch so it can be
merged through the media tree ?

--

Thanks,
Sylwester
> ---
>  arch/arm/mach-exynos/mach-nuri.c                |    8 ++--
>  arch/arm/mach-exynos/mach-universal_c210.c      |    8 ++--
>  arch/arm/mach-s5pv210/mach-goni.c               |    6 +--
>  drivers/media/platform/s5p-fimc/fimc-lite-reg.c |    8 ++--
>  drivers/media/platform/s5p-fimc/fimc-lite-reg.h |    4 +-
>  drivers/media/platform/s5p-fimc/fimc-mdevice.c  |   16 ++++----
>  drivers/media/platform/s5p-fimc/fimc-mdevice.h  |    2 +-
>  drivers/media/platform/s5p-fimc/fimc-reg.c      |   34 +++++++++-------
>  drivers/media/platform/s5p-fimc/fimc-reg.h      |    6 +--
>  include/media/s5p_fimc.h                        |   49 ++++++++++++++---------
>  10 files changed, 79 insertions(+), 62 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
> index 27d4ed8..7c2600e 100644
> --- a/arch/arm/mach-exynos/mach-nuri.c
> +++ b/arch/arm/mach-exynos/mach-nuri.c
> @@ -1209,25 +1209,25 @@ static struct i2c_board_info m5mols_board_info = {
>  	.platform_data	= &m5mols_platdata,
>  };
> 
> -static struct s5p_fimc_isp_info nuri_camera_sensors[] = {
> +static struct fimc_source_info nuri_camera_sensors[] = {
>  	{
>  		.flags		= V4L2_MBUS_PCLK_SAMPLE_RISING |
>  				  V4L2_MBUS_VSYNC_ACTIVE_LOW,
> -		.bus_type	= FIMC_ITU_601,
> +		.fimc_bus_type	= FIMC_BUS_TYPE_ITU_601,
>  		.board_info	= &s5k6aa_board_info,
>  		.clk_frequency	= 24000000UL,
>  		.i2c_bus_num	= 6,
>  	}, {
>  		.flags		= V4L2_MBUS_PCLK_SAMPLE_FALLING |
>  				  V4L2_MBUS_VSYNC_ACTIVE_LOW,
> -		.bus_type	= FIMC_MIPI_CSI2,
> +		.fimc_bus_type	= FIMC_BUS_TYPE_MIPI_CSI2,
>  		.board_info	= &m5mols_board_info,
>  		.clk_frequency	= 24000000UL,
>  	},
>  };
> 
>  static struct s5p_platform_fimc fimc_md_platdata = {
> -	.isp_info	= nuri_camera_sensors,
> +	.source_info	= nuri_camera_sensors,
>  	.num_clients	= ARRAY_SIZE(nuri_camera_sensors),
>  };
> 
> diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
> index 9e3340f..c09290a 100644
> --- a/arch/arm/mach-exynos/mach-universal_c210.c
> +++ b/arch/arm/mach-exynos/mach-universal_c210.c
> @@ -988,12 +988,12 @@ static struct i2c_board_info m5mols_board_info = {
>  	.platform_data = &m5mols_platdata,
>  };
> 
> -static struct s5p_fimc_isp_info universal_camera_sensors[] = {
> +static struct fimc_source_info universal_camera_sensors[] = {
>  	{
>  		.mux_id		= 0,
>  		.flags		= V4L2_MBUS_PCLK_SAMPLE_FALLING |
>  				  V4L2_MBUS_VSYNC_ACTIVE_LOW,
> -		.bus_type	= FIMC_ITU_601,
> +		.fimc_bus_type	= FIMC_BUS_TYPE_ITU_601,
>  		.board_info	= &s5k6aa_board_info,
>  		.i2c_bus_num	= 0,
>  		.clk_frequency	= 24000000UL,
> @@ -1001,7 +1001,7 @@ static struct s5p_fimc_isp_info universal_camera_sensors[] = {
>  		.mux_id		= 0,
>  		.flags		= V4L2_MBUS_PCLK_SAMPLE_FALLING |
>  				  V4L2_MBUS_VSYNC_ACTIVE_LOW,
> -		.bus_type	= FIMC_MIPI_CSI2,
> +		.fimc_bus_type	= FIMC_BUS_TYPE_MIPI_CSI2,
>  		.board_info	= &m5mols_board_info,
>  		.i2c_bus_num	= 0,
>  		.clk_frequency	= 24000000UL,
> @@ -1009,7 +1009,7 @@ static struct s5p_fimc_isp_info universal_camera_sensors[] = {
>  };
> 
>  static struct s5p_platform_fimc fimc_md_platdata = {
> -	.isp_info	= universal_camera_sensors,
> +	.source_info	= universal_camera_sensors,
>  	.num_clients	= ARRAY_SIZE(universal_camera_sensors),
>  };
> 
> diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
> index c72b310..423f6b6 100644
> --- a/arch/arm/mach-s5pv210/mach-goni.c
> +++ b/arch/arm/mach-s5pv210/mach-goni.c
> @@ -841,12 +841,12 @@ static struct i2c_board_info noon010pc30_board_info = {
>  	.platform_data = &noon010pc30_pldata,
>  };
> 
> -static struct s5p_fimc_isp_info goni_camera_sensors[] = {
> +static struct fimc_source_info goni_camera_sensors[] = {
>  	{
>  		.mux_id		= 0,
>  		.flags		= V4L2_MBUS_PCLK_SAMPLE_FALLING |
>  				  V4L2_MBUS_VSYNC_ACTIVE_LOW,
> -		.bus_type	= FIMC_ITU_601,
> +		.bus_type	= FIMC_BUS_TYPE_ITU_601,
>  		.board_info	= &noon010pc30_board_info,
>  		.i2c_bus_num	= 0,
>  		.clk_frequency	= 16000000UL,
> @@ -854,7 +854,7 @@ static struct s5p_fimc_isp_info goni_camera_sensors[] = {
>  };
> 
>  static struct s5p_platform_fimc goni_fimc_md_platdata __initdata = {
> -	.isp_info	= goni_camera_sensors,
> +	.source_info	= goni_camera_sensors,
>  	.num_clients	= ARRAY_SIZE(goni_camera_sensors),
>  };
> 
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
> index 962652d..f0af075 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
> @@ -187,12 +187,12 @@ static void flite_hw_set_camera_port(struct fimc_lite *dev, int id)
> 
>  /* Select serial or parallel bus, camera port (A,B) and set signals polarity */
>  void flite_hw_set_camera_bus(struct fimc_lite *dev,
> -			     struct s5p_fimc_isp_info *s_info)
> +			     struct fimc_source_info *si)
>  {
>  	u32 cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
> -	unsigned int flags = s_info->flags;
> +	unsigned int flags = si->flags;
> 
> -	if (s_info->bus_type != FIMC_MIPI_CSI2) {
> +	if (si->sensor_bus_type != FIMC_BUS_TYPE_MIPI_CSI2) {
>  		cfg &= ~(FLITE_REG_CIGCTRL_SELCAM_MIPI |
>  			 FLITE_REG_CIGCTRL_INVPOLPCLK |
>  			 FLITE_REG_CIGCTRL_INVPOLVSYNC |
> @@ -212,7 +212,7 @@ void flite_hw_set_camera_bus(struct fimc_lite *dev,
> 
>  	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
> 
> -	flite_hw_set_camera_port(dev, s_info->mux_id);
> +	flite_hw_set_camera_port(dev, si->mux_id);
>  }
> 
>  static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.h b/drivers/media/platform/s5p-fimc/fimc-lite-reg.h
> index adb9e9e..0e34584 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.h
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.h
> @@ -131,9 +131,9 @@ void flite_hw_set_interrupt_mask(struct fimc_lite *dev);
>  void flite_hw_capture_start(struct fimc_lite *dev);
>  void flite_hw_capture_stop(struct fimc_lite *dev);
>  void flite_hw_set_camera_bus(struct fimc_lite *dev,
> -			     struct s5p_fimc_isp_info *s_info);
> +			     struct fimc_source_info *s_info);
>  void flite_hw_set_camera_polarity(struct fimc_lite *dev,
> -				  struct s5p_fimc_isp_info *cam);
> +				  struct fimc_source_info *cam);
>  void flite_hw_set_window_offset(struct fimc_lite *dev, struct flite_frame *f);
>  void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f);
> 
> diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> index d940454..f49f6f1 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> @@ -290,7 +290,7 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
>  	for (i = 0; i < num_clients; i++) {
>  		struct v4l2_subdev *sd;
> 
> -		fmd->sensor[i].pdata = pdata->isp_info[i];
> +		fmd->sensor[i].pdata = pdata->source_info[i];
>  		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], true);
>  		if (ret)
>  			break;
> @@ -504,7 +504,7 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
>  					    struct v4l2_subdev *sensor,
>  					    int pad, int link_mask)
>  {
> -	struct fimc_sensor_info *s_info;
> +	struct fimc_sensor_info *s_info = NULL;
>  	struct media_entity *sink;
>  	unsigned int flags = 0;
>  	int ret, i;
> @@ -614,7 +614,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
>  {
>  	struct v4l2_subdev *csi_sensors[CSIS_MAX_ENTITIES] = { NULL };
>  	struct v4l2_subdev *sensor, *csis;
> -	struct s5p_fimc_isp_info *pdata;
> +	struct fimc_source_info *pdata;
>  	struct fimc_sensor_info *s_info;
>  	struct media_entity *source, *sink;
>  	int i, pad, fimc_id = 0, ret = 0;
> @@ -632,8 +632,8 @@ static int fimc_md_create_links(struct fimc_md *fmd)
>  		source = NULL;
>  		pdata = &s_info->pdata;
> 
> -		switch (pdata->bus_type) {
> -		case FIMC_MIPI_CSI2:
> +		switch (pdata->sensor_bus_type) {
> +		case FIMC_BUS_TYPE_MIPI_CSI2:
>  			if (WARN(pdata->mux_id >= CSIS_MAX_ENTITIES,
>  				"Wrong CSI channel id: %d\n", pdata->mux_id))
>  				return -EINVAL;
> @@ -659,14 +659,14 @@ static int fimc_md_create_links(struct fimc_md *fmd)
>  			csi_sensors[pdata->mux_id] = sensor;
>  			break;
> 
> -		case FIMC_ITU_601...FIMC_ITU_656:
> +		case FIMC_BUS_TYPE_ITU_601...FIMC_BUS_TYPE_ITU_656:
>  			source = &sensor->entity;
>  			pad = 0;
>  			break;
> 
>  		default:
>  			v4l2_err(&fmd->v4l2_dev, "Wrong bus_type: %x\n",
> -				 pdata->bus_type);
> +				 pdata->sensor_bus_type);
>  			return -EINVAL;
>  		}
>  		if (source == NULL)
> @@ -762,7 +762,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
>  				struct fimc_sensor_info *s_info,
>  				bool on)
>  {
> -	struct s5p_fimc_isp_info *pdata = &s_info->pdata;
> +	struct fimc_source_info *pdata = &s_info->pdata;
>  	struct fimc_camclk_info *camclk;
>  	int ret = 0;
> 
> diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
> index da7d992..06b0d82 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
> +++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
> @@ -53,7 +53,7 @@ struct fimc_camclk_info {
>   * This data structure applies to image sensor and the writeback subdevs.
>   */
>  struct fimc_sensor_info {
> -	struct s5p_fimc_isp_info pdata;
> +	struct fimc_source_info pdata;
>  	struct v4l2_subdev *subdev;
>  	struct fimc_dev *host;
>  };
> diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.c b/drivers/media/platform/s5p-fimc/fimc-reg.c
> index c05d044..50b97c7 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-reg.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-reg.c
> @@ -554,7 +554,7 @@ void fimc_hw_set_output_addr(struct fimc_dev *dev,
>  }
> 
>  int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
> -				struct s5p_fimc_isp_info *cam)
> +				struct fimc_source_info *cam)
>  {
>  	u32 cfg = readl(fimc->regs + FIMC_REG_CIGCTRL);
> 
> @@ -596,14 +596,15 @@ static const struct mbus_pixfmt_desc pix_desc[] = {
>  };
> 
>  int fimc_hw_set_camera_source(struct fimc_dev *fimc,
> -			      struct s5p_fimc_isp_info *cam)
> +			      struct fimc_source_info *source)
>  {
>  	struct fimc_frame *f = &fimc->vid_cap.ctx->s_frame;
> -	u32 cfg = 0;
> -	u32 bus_width;
> +	u32 bus_width, cfg = 0;
>  	int i;
> 
> -	if (cam->bus_type == FIMC_ITU_601 || cam->bus_type == FIMC_ITU_656) {
> +	switch (source->fimc_bus_type) {
> +	case FIMC_BUS_TYPE_ITU_601:
> +	case FIMC_BUS_TYPE_ITU_656:
>  		for (i = 0; i < ARRAY_SIZE(pix_desc); i++) {
>  			if (fimc->vid_cap.mf.code == pix_desc[i].pixelcode) {
>  				cfg = pix_desc[i].cisrcfmt;
> @@ -619,15 +620,17 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
>  			return -EINVAL;
>  		}
> 
> -		if (cam->bus_type == FIMC_ITU_601) {
> +		if (source->fimc_bus_type == FIMC_BUS_TYPE_ITU_601) {
>  			if (bus_width == 8)
>  				cfg |= FIMC_REG_CISRCFMT_ITU601_8BIT;
>  			else if (bus_width == 16)
>  				cfg |= FIMC_REG_CISRCFMT_ITU601_16BIT;
>  		} /* else defaults to ITU-R BT.656 8-bit */
> -	} else if (cam->bus_type == FIMC_MIPI_CSI2) {
> +		break;
> +	case FIMC_BUS_TYPE_MIPI_CSI2:
>  		if (fimc_fmt_is_user_defined(f->fmt->color))
>  			cfg |= FIMC_REG_CISRCFMT_ITU601_8BIT;
> +		break;
>  	}
> 
>  	cfg |= (f->o_width << 16) | f->o_height;
> @@ -655,7 +658,7 @@ void fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f)
>  }
> 
>  int fimc_hw_set_camera_type(struct fimc_dev *fimc,
> -			    struct s5p_fimc_isp_info *cam)
> +			    struct fimc_source_info *source)
>  {
>  	u32 cfg, tmp;
>  	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
> @@ -668,11 +671,11 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
>  		FIMC_REG_CIGCTRL_SELCAM_MIPI | FIMC_REG_CIGCTRL_CAMIF_SELWB |
>  		FIMC_REG_CIGCTRL_SELCAM_MIPI_A | FIMC_REG_CIGCTRL_CAM_JPEG);
> 
> -	switch (cam->bus_type) {
> -	case FIMC_MIPI_CSI2:
> +	switch (source->fimc_bus_type) {
> +	case FIMC_BUS_TYPE_MIPI_CSI2:
>  		cfg |= FIMC_REG_CIGCTRL_SELCAM_MIPI;
> 
> -		if (cam->mux_id == 0)
> +		if (source->mux_id == 0)
>  			cfg |= FIMC_REG_CIGCTRL_SELCAM_MIPI_A;
> 
>  		/* TODO: add remaining supported formats. */
> @@ -695,15 +698,16 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
> 
>  		writel(tmp, fimc->regs + FIMC_REG_CSIIMGFMT);
>  		break;
> -	case FIMC_ITU_601...FIMC_ITU_656:
> -		if (cam->mux_id == 0) /* ITU-A, ITU-B: 0, 1 */
> +	case FIMC_BUS_TYPE_ITU_601...FIMC_BUS_TYPE_ITU_656:
> +		if (source->mux_id == 0) /* ITU-A, ITU-B: 0, 1 */
>  			cfg |= FIMC_REG_CIGCTRL_SELCAM_ITU_A;
>  		break;
> -	case FIMC_LCD_WB:
> +	case FIMC_BUS_TYPE_LCD_WRITEBACK_A:
>  		cfg |= FIMC_REG_CIGCTRL_CAMIF_SELWB;
>  		break;
>  	default:
> -		v4l2_err(&vid_cap->vfd, "Invalid camera bus type selected\n");
> +		v4l2_err(&vid_cap->vfd, "Invalid FIMC bus type selected: %d\n",
> +			 source->fimc_bus_type);
>  		return -EINVAL;
>  	}
>  	writel(cfg, fimc->regs + FIMC_REG_CIGCTRL);
> diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.h b/drivers/media/platform/s5p-fimc/fimc-reg.h
> index f3e0b78..1a40df6 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-reg.h
> +++ b/drivers/media/platform/s5p-fimc/fimc-reg.h
> @@ -297,12 +297,12 @@ void fimc_hw_set_input_addr(struct fimc_dev *fimc, struct fimc_addr *paddr);
>  void fimc_hw_set_output_addr(struct fimc_dev *fimc, struct fimc_addr *paddr,
>  			     int index);
>  int fimc_hw_set_camera_source(struct fimc_dev *fimc,
> -			      struct s5p_fimc_isp_info *cam);
> +			      struct fimc_source_info *cam);
>  void fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f);
>  int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
> -				struct s5p_fimc_isp_info *cam);
> +				struct fimc_source_info *cam);
>  int fimc_hw_set_camera_type(struct fimc_dev *fimc,
> -			    struct s5p_fimc_isp_info *cam);
> +			    struct fimc_source_info *cam);
>  void fimc_hw_clear_irq(struct fimc_dev *dev);
>  void fimc_hw_enable_scaler(struct fimc_dev *dev, bool on);
>  void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on);
> diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
> index eaea62a..28f3590 100644
> --- a/include/media/s5p_fimc.h
> +++ b/include/media/s5p_fimc.h
> @@ -1,8 +1,8 @@
>  /*
> - * Samsung S5P SoC camera interface driver header
> + * Samsung S5P/Exynos4 SoC series camera interface driver header
>   *
> - * Copyright (c) 2010 Samsung Electronics Co., Ltd
> - * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
> + * Copyright (C) 2010 - 2013 Samsung Electronics Co., Ltd.
> + * Sylwester Nawrocki <s.nawrocki@samsung.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -14,45 +14,58 @@
> 
>  #include <media/media-entity.h>
> 
> -enum cam_bus_type {
> -	FIMC_ITU_601 = 1,
> -	FIMC_ITU_656,
> -	FIMC_MIPI_CSI2,
> -	FIMC_LCD_WB, /* FIFO link from LCD mixer */
> +/*
> + * Enumeration of the FIMC data bus types.
> + */
> +enum fimc_bus_type {
> +	/* Camera parallel bus */
> +	FIMC_BUS_TYPE_ITU_601 = 1,
> +	/* Camera parallel bus with embedded synchronization */
> +	FIMC_BUS_TYPE_ITU_656,
> +	/* Camera MIPI-CSI2 serial bus */
> +	FIMC_BUS_TYPE_MIPI_CSI2,
> +	/* FIFO link from LCD controller (WriteBack A) */
> +	FIMC_BUS_TYPE_LCD_WRITEBACK_A,
> +	/* FIFO link from LCD controller (WriteBack B) */
> +	FIMC_BUS_TYPE_LCD_WRITEBACK_B,
> +	/* FIFO link from FIMC-IS */
> +	FIMC_BUS_TYPE_ISP_WRITEBACK = FIMC_BUS_TYPE_LCD_WRITEBACK_B,
>  };
> 
>  struct i2c_board_info;
> 
>  /**
> - * struct s5p_fimc_isp_info - image sensor information required for host
> - *			      interace configuration.
> + * struct fimc_source_info - video source description required for the host
> + *			     interface configuration
>   *
>   * @board_info: pointer to I2C subdevice's board info
>   * @clk_frequency: frequency of the clock the host interface provides to sensor
> - * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
> + * @fimc_bus_type: FIMC camera input type
> + * @sensor_bus_type: image sensor bus type, MIPI, ITU-R BT.601 etc.
> + * @flags: the parallel sensor bus flags defining signals polarity (V4L2_MBUS_*)
>   * @i2c_bus_num: i2c control bus id the sensor is attached to
>   * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
>   * @clk_id: index of the SoC peripheral clock for sensors
> - * @flags: the parallel bus flags defining signals polarity (V4L2_MBUS_*)
>   */
> -struct s5p_fimc_isp_info {
> +struct fimc_source_info {
>  	struct i2c_board_info *board_info;
>  	unsigned long clk_frequency;
> -	enum cam_bus_type bus_type;
> +	enum fimc_bus_type fimc_bus_type;
> +	enum fimc_bus_type sensor_bus_type;
> +	u16 flags;
>  	u16 i2c_bus_num;
>  	u16 mux_id;
> -	u16 flags;
>  	u8 clk_id;
>  };
> 
>  /**
>   * struct s5p_platform_fimc - camera host interface platform data
>   *
> - * @isp_info: properties of camera sensor required for host interface setup
> - * @num_clients: the number of attached image sensors
> + * @source_info: properties of an image source for the host interface setup
> + * @num_clients: the number of attached image sources
>   */
>  struct s5p_platform_fimc {
> -	struct s5p_fimc_isp_info *isp_info;
> +	struct fimc_source_info *source_info;
>  	int num_clients;
>  };
> 
> --
> 1.7.9.5
