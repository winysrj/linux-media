Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:39908 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbbCYX0I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 19:26:08 -0400
Date: Wed, 25 Mar 2015 16:21:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com,
	Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH v2 06/15] omap3isp: Refactor device configuration structs
 for Device Tree
Message-ID: <20150325232144.GE31346@atomide.com>
References: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
 <1427324259-18438-7-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1427324259-18438-7-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Sakari Ailus <sakari.ailus@iki.fi> [150325 16:00]:
> Make omap3isp configuration data structures more suitable for consumption by
> the DT by separating the I2C bus information of all the sub-devices in a
> group and the ISP bus information from each other. The ISP bus information
> is made a pointer instead of being directly embedded in the struct.
> 
> In the case of the DT only the sensor specific information on the ISP bus
> configuration is retained. The structs are renamed to reflect that.
> 
> After this change the structs needed to describe device configuration can be
> allocated and accessed separately without those needed only in the case of
> platform data. The platform data related structs can be later removed once
> the support for platform data can be removed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Igor Grinberg <grinberg@compulab.co.il>
> Acked-by: Igor Grinberg <grinberg@compulab.co.il> (for cm-t35)

There arch/arm/mach-omap2 changes here are OK to merge along with
the driver changes:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/board-cm-t35.c          |   57 +++++++-----------
>  drivers/media/platform/omap3isp/isp.c       |   86 +++++++++++++--------------
>  drivers/media/platform/omap3isp/isp.h       |    2 +-
>  drivers/media/platform/omap3isp/ispccdc.c   |   26 ++++----
>  drivers/media/platform/omap3isp/ispccp2.c   |   22 +++----
>  drivers/media/platform/omap3isp/ispcsi2.c   |    8 +--
>  drivers/media/platform/omap3isp/ispcsiphy.c |   21 ++++---
>  include/media/omap3isp.h                    |   34 +++++------
>  8 files changed, 119 insertions(+), 137 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
> index 91738a1..b5dfbc1 100644
> --- a/arch/arm/mach-omap2/board-cm-t35.c
> +++ b/arch/arm/mach-omap2/board-cm-t35.c
> @@ -492,51 +492,36 @@ static struct twl4030_platform_data cm_t35_twldata = {
>  #include <media/omap3isp.h>
>  #include "devices.h"
>  
> -static struct i2c_board_info cm_t35_isp_i2c_boardinfo[] = {
> +static struct isp_platform_subdev cm_t35_isp_subdevs[] = {
>  	{
> -		I2C_BOARD_INFO("mt9t001", 0x5d),
> -	},
> -	{
> -		I2C_BOARD_INFO("tvp5150", 0x5c),
> -	},
> -};
> -
> -static struct isp_subdev_i2c_board_info cm_t35_isp_primary_subdevs[] = {
> -	{
> -		.board_info = &cm_t35_isp_i2c_boardinfo[0],
> -		.i2c_adapter_id = 3,
> -	},
> -	{ NULL, 0, },
> -};
> -
> -static struct isp_subdev_i2c_board_info cm_t35_isp_secondary_subdevs[] = {
> -	{
> -		.board_info = &cm_t35_isp_i2c_boardinfo[1],
> +		.board_info = &(struct i2c_board_info){
> +			I2C_BOARD_INFO("mt9t001", 0x5d)
> +		},
>  		.i2c_adapter_id = 3,
> -	},
> -	{ NULL, 0, },
> -};
> -
> -static struct isp_v4l2_subdevs_group cm_t35_isp_subdevs[] = {
> -	{
> -		.subdevs = cm_t35_isp_primary_subdevs,
> -		.interface = ISP_INTERFACE_PARALLEL,
> -		.bus = {
> -			.parallel = {
> -				.clk_pol = 1,
> +		.bus = &(struct isp_bus_cfg){
> +			.interface = ISP_INTERFACE_PARALLEL,
> +			.bus = {
> +				.parallel = {
> +					.clk_pol = 1,
> +				},
>  			},
>  		},
>  	},
>  	{
> -		.subdevs = cm_t35_isp_secondary_subdevs,
> -		.interface = ISP_INTERFACE_PARALLEL,
> -		.bus = {
> -			.parallel = {
> -				.clk_pol = 0,
> +		.board_info = &(struct i2c_board_info){
> +			I2C_BOARD_INFO("tvp5150", 0x5c),
> +		},
> +		.i2c_adapter_id = 3,
> +		.bus = &(struct isp_bus_cfg){
> +			.interface = ISP_INTERFACE_PARALLEL,
> +			.bus = {
> +				.parallel = {
> +					.clk_pol = 0,
> +				},
>  			},
>  		},
>  	},
> -	{ NULL, 0, },
> +	{ 0 },
>  };
>  
>  static struct isp_platform_data cm_t35_isp_pdata = {
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 537377b..1b5c6df 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -447,7 +447,7 @@ static void isp_core_init(struct isp_device *isp, int idle)
>   */
>  void omap3isp_configure_bridge(struct isp_device *isp,
>  			       enum ccdc_input_entity input,
> -			       const struct isp_parallel_platform_data *pdata,
> +			       const struct isp_parallel_cfg *parcfg,
>  			       unsigned int shift, unsigned int bridge)
>  {
>  	u32 ispctrl_val;
> @@ -462,8 +462,8 @@ void omap3isp_configure_bridge(struct isp_device *isp,
>  	switch (input) {
>  	case CCDC_INPUT_PARALLEL:
>  		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
> -		ispctrl_val |= pdata->clk_pol << ISPCTRL_PAR_CLK_POL_SHIFT;
> -		shift += pdata->data_lane_shift * 2;
> +		ispctrl_val |= parcfg->clk_pol << ISPCTRL_PAR_CLK_POL_SHIFT;
> +		shift += parcfg->data_lane_shift * 2;
>  		break;
>  
>  	case CCDC_INPUT_CSI2A:
> @@ -1809,52 +1809,44 @@ static void isp_unregister_entities(struct isp_device *isp)
>  }
>  
>  /*
> - * isp_register_subdev_group - Register a group of subdevices
> + * isp_register_subdev - Register a sub-device
>   * @isp: OMAP3 ISP device
> - * @board_info: I2C subdevs board information array
> + * @isp_subdev: platform data related to a sub-device
>   *
> - * Register all I2C subdevices in the board_info array. The array must be
> - * terminated by a NULL entry, and the first entry must be the sensor.
> + * Register an I2C sub-device which has not been registered by other
> + * means (such as the Device Tree).
>   *
> - * Return a pointer to the sensor media entity if it has been successfully
> + * Return a pointer to the sub-device if it has been successfully
>   * registered, or NULL otherwise.
>   */
>  static struct v4l2_subdev *
> -isp_register_subdev_group(struct isp_device *isp,
> -		     struct isp_subdev_i2c_board_info *board_info)
> +isp_register_subdev(struct isp_device *isp,
> +		    struct isp_platform_subdev *isp_subdev)
>  {
> -	struct v4l2_subdev *sensor = NULL;
> -	unsigned int first;
> +	struct i2c_adapter *adapter;
> +	struct v4l2_subdev *sd;
>  
> -	if (board_info->board_info == NULL)
> +	if (isp_subdev->board_info == NULL)
>  		return NULL;
>  
> -	for (first = 1; board_info->board_info; ++board_info, first = 0) {
> -		struct v4l2_subdev *subdev;
> -		struct i2c_adapter *adapter;
> -
> -		adapter = i2c_get_adapter(board_info->i2c_adapter_id);
> -		if (adapter == NULL) {
> -			dev_err(isp->dev, "%s: Unable to get I2C adapter %d for "
> -				"device %s\n", __func__,
> -				board_info->i2c_adapter_id,
> -				board_info->board_info->type);
> -			continue;
> -		}
> -
> -		subdev = v4l2_i2c_new_subdev_board(&isp->v4l2_dev, adapter,
> -				board_info->board_info, NULL);
> -		if (subdev == NULL) {
> -			dev_err(isp->dev, "%s: Unable to register subdev %s\n",
> -				__func__, board_info->board_info->type);
> -			continue;
> -		}
> +	adapter = i2c_get_adapter(isp_subdev->i2c_adapter_id);
> +	if (adapter == NULL) {
> +		dev_err(isp->dev,
> +			"%s: Unable to get I2C adapter %d for device %s\n",
> +			__func__, isp_subdev->i2c_adapter_id,
> +			isp_subdev->board_info->type);
> +		return NULL;
> +	}
>  
> -		if (first)
> -			sensor = subdev;
> +	sd = v4l2_i2c_new_subdev_board(&isp->v4l2_dev, adapter,
> +				       isp_subdev->board_info, NULL);
> +	if (sd == NULL) {
> +		dev_err(isp->dev, "%s: Unable to register subdev %s\n",
> +			__func__, isp_subdev->board_info->type);
> +		return NULL;
>  	}
>  
> -	return sensor;
> +	return sd;
>  }
>  
>  static int isp_link_entity(
> @@ -1931,7 +1923,7 @@ static int isp_link_entity(
>  static int isp_register_entities(struct isp_device *isp)
>  {
>  	struct isp_platform_data *pdata = isp->pdata;
> -	struct isp_v4l2_subdevs_group *subdevs;
> +	struct isp_platform_subdev *isp_subdev;
>  	int ret;
>  
>  	isp->media_dev.dev = isp->dev;
> @@ -1989,17 +1981,23 @@ static int isp_register_entities(struct isp_device *isp)
>  		goto done;
>  
>  	/* Register external entities */
> -	for (subdevs = pdata ? pdata->subdevs : NULL;
> -	     subdevs && subdevs->subdevs; ++subdevs) {
> -		struct v4l2_subdev *sensor;
> +	for (isp_subdev = pdata ? pdata->subdevs : NULL;
> +	     isp_subdev && isp_subdev->board_info; isp_subdev++) {
> +		struct v4l2_subdev *sd;
>  
> -		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
> -		if (sensor == NULL)
> +		sd = isp_register_subdev(isp, isp_subdev);
> +
> +		/*
> +		 * No bus information --- this is either a flash or a
> +		 * lens subdev.
> +		 */
> +		if (!sd || !isp_subdev->bus)
>  			continue;
>  
> -		sensor->host_priv = subdevs;
> +		sd->host_priv = isp_subdev->bus;
>  
> -		ret = isp_link_entity(isp, &sensor->entity, subdevs->interface);
> +		ret = isp_link_entity(isp, &sd->entity,
> +				      isp_subdev->bus->interface);
>  		if (ret < 0)
>  			goto done;
>  	}
> diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
> index cfdfc87..b932a6f 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -229,7 +229,7 @@ int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
>  void omap3isp_pipeline_cancel_stream(struct isp_pipeline *pipe);
>  void omap3isp_configure_bridge(struct isp_device *isp,
>  			       enum ccdc_input_entity input,
> -			       const struct isp_parallel_platform_data *pdata,
> +			       const struct isp_parallel_cfg *buscfg,
>  			       unsigned int shift, unsigned int bridge);
>  
>  struct isp_device *omap3isp_get(struct isp_device *isp);
> diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
> index 587489a..388f971 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -958,11 +958,11 @@ void omap3isp_ccdc_max_rate(struct isp_ccdc_device *ccdc,
>  /*
>   * ccdc_config_sync_if - Set CCDC sync interface configuration
>   * @ccdc: Pointer to ISP CCDC device.
> - * @pdata: Parallel interface platform data (may be NULL)
> + * @parcfg: Parallel interface platform data (may be NULL)
>   * @data_size: Data size
>   */
>  static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
> -				struct isp_parallel_platform_data *pdata,
> +				struct isp_parallel_cfg *parcfg,
>  				unsigned int data_size)
>  {
>  	struct isp_device *isp = to_isp_device(ccdc);
> @@ -1000,19 +1000,19 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
>  		break;
>  	}
>  
> -	if (pdata && pdata->data_pol)
> +	if (parcfg && parcfg->data_pol)
>  		syn_mode |= ISPCCDC_SYN_MODE_DATAPOL;
>  
> -	if (pdata && pdata->hs_pol)
> +	if (parcfg && parcfg->hs_pol)
>  		syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
>  
>  	/* The polarity of the vertical sync signal output by the BT.656
>  	 * decoder is not documented and seems to be active low.
>  	 */
> -	if ((pdata && pdata->vs_pol) || ccdc->bt656)
> +	if ((parcfg && parcfg->vs_pol) || ccdc->bt656)
>  		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
>  
> -	if (pdata && pdata->fld_pol)
> +	if (parcfg && parcfg->fld_pol)
>  		syn_mode |= ISPCCDC_SYN_MODE_FLDPOL;
>  
>  	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
> @@ -1115,7 +1115,7 @@ static const u32 ccdc_sgbrg_pattern =
>  static void ccdc_configure(struct isp_ccdc_device *ccdc)
>  {
>  	struct isp_device *isp = to_isp_device(ccdc);
> -	struct isp_parallel_platform_data *pdata = NULL;
> +	struct isp_parallel_cfg *parcfg = NULL;
>  	struct v4l2_subdev *sensor;
>  	struct v4l2_mbus_framefmt *format;
>  	const struct v4l2_rect *crop;
> @@ -1145,7 +1145,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
>  		if (!ret)
>  			ccdc->bt656 = cfg.type == V4L2_MBUS_BT656;
>  
> -		pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
> +		parcfg = &((struct isp_bus_cfg *)sensor->host_priv)
>  			->bus.parallel;
>  	}
>  
> @@ -1175,10 +1175,10 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
>  	else
>  		bridge = ISPCTRL_PAR_BRIDGE_DISABLE;
>  
> -	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift, bridge);
> +	omap3isp_configure_bridge(isp, ccdc->input, parcfg, shift, bridge);
>  
>  	/* Configure the sync interface. */
> -	ccdc_config_sync_if(ccdc, pdata, depth_out);
> +	ccdc_config_sync_if(ccdc, parcfg, depth_out);
>  
>  	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
>  
> @@ -2417,11 +2417,11 @@ static int ccdc_link_validate(struct v4l2_subdev *sd,
>  
>  	/* We've got a parallel sensor here. */
>  	if (ccdc->input == CCDC_INPUT_PARALLEL) {
> -		struct isp_parallel_platform_data *pdata =
> -			&((struct isp_v4l2_subdevs_group *)
> +		struct isp_parallel_cfg *parcfg =
> +			&((struct isp_bus_cfg *)
>  			  media_entity_to_v4l2_subdev(link->source->entity)
>  			  ->host_priv)->bus.parallel;
> -		parallel_shift = pdata->data_lane_shift * 2;
> +		parallel_shift = parcfg->data_lane_shift * 2;
>  	} else {
>  		parallel_shift = 0;
>  	}
> diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
> index f4aedb3..374a1f4 100644
> --- a/drivers/media/platform/omap3isp/ispccp2.c
> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> @@ -201,14 +201,14 @@ static void ccp2_mem_enable(struct isp_ccp2_device *ccp2, u8 enable)
>  /*
>   * ccp2_phyif_config - Initialize CCP2 phy interface config
>   * @ccp2: Pointer to ISP CCP2 device
> - * @pdata: CCP2 platform data
> + * @buscfg: CCP2 platform data
>   *
>   * Configure the CCP2 physical interface module from platform data.
>   *
>   * Returns -EIO if strobe is chosen in CSI1 mode, or 0 on success.
>   */
>  static int ccp2_phyif_config(struct isp_ccp2_device *ccp2,
> -			     const struct isp_ccp2_platform_data *pdata)
> +			     const struct isp_ccp2_cfg *buscfg)
>  {
>  	struct isp_device *isp = to_isp_device(ccp2);
>  	u32 val;
> @@ -218,16 +218,16 @@ static int ccp2_phyif_config(struct isp_ccp2_device *ccp2,
>  			    ISPCCP2_CTRL_IO_OUT_SEL | ISPCCP2_CTRL_MODE;
>  	/* Data/strobe physical layer */
>  	BIT_SET(val, ISPCCP2_CTRL_PHY_SEL_SHIFT, ISPCCP2_CTRL_PHY_SEL_MASK,
> -		pdata->phy_layer);
> +		buscfg->phy_layer);
>  	BIT_SET(val, ISPCCP2_CTRL_INV_SHIFT, ISPCCP2_CTRL_INV_MASK,
> -		pdata->strobe_clk_pol);
> +		buscfg->strobe_clk_pol);
>  	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL);
>  
>  	val = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL);
>  	if (!(val & ISPCCP2_CTRL_MODE)) {
> -		if (pdata->ccp2_mode == ISP_CCP2_MODE_CCP2)
> +		if (buscfg->ccp2_mode == ISP_CCP2_MODE_CCP2)
>  			dev_warn(isp->dev, "OMAP3 CCP2 bus not available\n");
> -		if (pdata->phy_layer == ISP_CCP2_PHY_DATA_STROBE)
> +		if (buscfg->phy_layer == ISP_CCP2_PHY_DATA_STROBE)
>  			/* Strobe mode requires CCP2 */
>  			return -EIO;
>  	}
> @@ -347,7 +347,7 @@ static void ccp2_lcx_config(struct isp_ccp2_device *ccp2,
>   */
>  static int ccp2_if_configure(struct isp_ccp2_device *ccp2)
>  {
> -	const struct isp_v4l2_subdevs_group *pdata;
> +	const struct isp_bus_cfg *buscfg;
>  	struct v4l2_mbus_framefmt *format;
>  	struct media_pad *pad;
>  	struct v4l2_subdev *sensor;
> @@ -358,20 +358,20 @@ static int ccp2_if_configure(struct isp_ccp2_device *ccp2)
>  
>  	pad = media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
>  	sensor = media_entity_to_v4l2_subdev(pad->entity);
> -	pdata = sensor->host_priv;
> +	buscfg = sensor->host_priv;
>  
> -	ret = ccp2_phyif_config(ccp2, &pdata->bus.ccp2);
> +	ret = ccp2_phyif_config(ccp2, &buscfg->bus.ccp2);
>  	if (ret < 0)
>  		return ret;
>  
> -	ccp2_vp_config(ccp2, pdata->bus.ccp2.vpclk_div + 1);
> +	ccp2_vp_config(ccp2, buscfg->bus.ccp2.vpclk_div + 1);
>  
>  	v4l2_subdev_call(sensor, sensor, g_skip_top_lines, &lines);
>  
>  	format = &ccp2->formats[CCP2_PAD_SINK];
>  
>  	ccp2->if_cfg.data_start = lines;
> -	ccp2->if_cfg.crc = pdata->bus.ccp2.crc;
> +	ccp2->if_cfg.crc = buscfg->bus.ccp2.crc;
>  	ccp2->if_cfg.format = format->code;
>  	ccp2->if_cfg.data_size = format->height;
>  
> diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
> index 09c686d..14d279d 100644
> --- a/drivers/media/platform/omap3isp/ispcsi2.c
> +++ b/drivers/media/platform/omap3isp/ispcsi2.c
> @@ -548,7 +548,7 @@ int omap3isp_csi2_reset(struct isp_csi2_device *csi2)
>  
>  static int csi2_configure(struct isp_csi2_device *csi2)
>  {
> -	const struct isp_v4l2_subdevs_group *pdata;
> +	const struct isp_bus_cfg *buscfg;
>  	struct isp_device *isp = csi2->isp;
>  	struct isp_csi2_timing_cfg *timing = &csi2->timing[0];
>  	struct v4l2_subdev *sensor;
> @@ -565,14 +565,14 @@ static int csi2_configure(struct isp_csi2_device *csi2)
>  
>  	pad = media_entity_remote_pad(&csi2->pads[CSI2_PAD_SINK]);
>  	sensor = media_entity_to_v4l2_subdev(pad->entity);
> -	pdata = sensor->host_priv;
> +	buscfg = sensor->host_priv;
>  
>  	csi2->frame_skip = 0;
>  	v4l2_subdev_call(sensor, sensor, g_skip_frames, &csi2->frame_skip);
>  
> -	csi2->ctrl.vp_out_ctrl = pdata->bus.csi2.vpclk_div;
> +	csi2->ctrl.vp_out_ctrl = buscfg->bus.csi2.vpclk_div;
>  	csi2->ctrl.frame_mode = ISP_CSI2_FRAME_IMMEDIATE;
> -	csi2->ctrl.ecc_enable = pdata->bus.csi2.crc;
> +	csi2->ctrl.ecc_enable = buscfg->bus.csi2.crc;
>  
>  	timing->ionum = 1;
>  	timing->force_rx_mode = 1;
> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
> index e033f22..4486e9f 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> @@ -168,18 +168,18 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
>  {
>  	struct isp_csi2_device *csi2 = phy->csi2;
>  	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
> -	struct isp_v4l2_subdevs_group *subdevs = pipe->external->host_priv;
> +	struct isp_bus_cfg *buscfg = pipe->external->host_priv;
>  	struct isp_csiphy_lanes_cfg *lanes;
>  	int csi2_ddrclk_khz;
>  	unsigned int used_lanes = 0;
>  	unsigned int i;
>  	u32 reg;
>  
> -	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
> -	    || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
> -		lanes = &subdevs->bus.ccp2.lanecfg;
> +	if (buscfg->interface == ISP_INTERFACE_CCP2B_PHY1
> +	    || buscfg->interface == ISP_INTERFACE_CCP2B_PHY2)
> +		lanes = &buscfg->bus.ccp2.lanecfg;
>  	else
> -		lanes = &subdevs->bus.csi2.lanecfg;
> +		lanes = &buscfg->bus.csi2.lanecfg;
>  
>  	/* Clock and data lanes verification */
>  	for (i = 0; i < phy->num_data_lanes; i++) {
> @@ -203,8 +203,8 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
>  	 * issue since the MPU power domain is forced on whilst the
>  	 * ISP is in use.
>  	 */
> -	csiphy_routing_cfg(phy, subdevs->interface, true,
> -			   subdevs->bus.ccp2.phy_layer);
> +	csiphy_routing_cfg(phy, buscfg->interface, true,
> +			   buscfg->bus.ccp2.phy_layer);
>  
>  	/* DPHY timing configuration */
>  	/* CSI-2 is DDR and we only count used lanes. */
> @@ -302,11 +302,10 @@ void omap3isp_csiphy_release(struct isp_csiphy *phy)
>  		struct isp_csi2_device *csi2 = phy->csi2;
>  		struct isp_pipeline *pipe =
>  			to_isp_pipeline(&csi2->subdev.entity);
> -		struct isp_v4l2_subdevs_group *subdevs =
> -			pipe->external->host_priv;
> +		struct isp_bus_cfg *buscfg = pipe->external->host_priv;
>  
> -		csiphy_routing_cfg(phy, subdevs->interface, false,
> -				   subdevs->bus.ccp2.phy_layer);
> +		csiphy_routing_cfg(phy, buscfg->interface, false,
> +				   buscfg->bus.ccp2.phy_layer);
>  		csiphy_power_autoswitch_enable(phy, false);
>  		csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_OFF);
>  		regulator_disable(phy->vdd);
> diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
> index 398279d..39e0748 100644
> --- a/include/media/omap3isp.h
> +++ b/include/media/omap3isp.h
> @@ -45,7 +45,7 @@ enum {
>  };
>  
>  /**
> - * struct isp_parallel_platform_data - Parallel interface platform data
> + * struct isp_parallel_cfg - Parallel interface configuration
>   * @data_lane_shift: Data lane shifter
>   *		ISP_LANE_SHIFT_0 - CAMEXT[13:0] -> CAM[13:0]
>   *		ISP_LANE_SHIFT_2 - CAMEXT[13:2] -> CAM[11:0]
> @@ -62,7 +62,7 @@ enum {
>   * @data_pol: Data polarity
>   *		0 - Normal, 1 - One's complement
>   */
> -struct isp_parallel_platform_data {
> +struct isp_parallel_cfg {
>  	unsigned int data_lane_shift:2;
>  	unsigned int clk_pol:1;
>  	unsigned int hs_pol:1;
> @@ -105,7 +105,7 @@ struct isp_csiphy_lanes_cfg {
>  };
>  
>  /**
> - * struct isp_ccp2_platform_data - CCP2 interface platform data
> + * struct isp_ccp2_cfg - CCP2 interface configuration
>   * @strobe_clk_pol: Strobe/clock polarity
>   *		0 - Non Inverted, 1 - Inverted
>   * @crc: Enable the cyclic redundancy check
> @@ -117,7 +117,7 @@ struct isp_csiphy_lanes_cfg {
>   *		ISP_CCP2_PHY_DATA_STROBE - Data/strobe physical layer
>   * @vpclk_div: Video port output clock control
>   */
> -struct isp_ccp2_platform_data {
> +struct isp_ccp2_cfg {
>  	unsigned int strobe_clk_pol:1;
>  	unsigned int crc:1;
>  	unsigned int ccp2_mode:1;
> @@ -127,31 +127,31 @@ struct isp_ccp2_platform_data {
>  };
>  
>  /**
> - * struct isp_csi2_platform_data - CSI2 interface platform data
> + * struct isp_csi2_cfg - CSI2 interface configuration
>   * @crc: Enable the cyclic redundancy check
>   * @vpclk_div: Video port output clock control
>   */
> -struct isp_csi2_platform_data {
> +struct isp_csi2_cfg {
>  	unsigned crc:1;
>  	unsigned vpclk_div:2;
>  	struct isp_csiphy_lanes_cfg lanecfg;
>  };
>  
> -struct isp_subdev_i2c_board_info {
> -	struct i2c_board_info *board_info;
> -	int i2c_adapter_id;
> -};
> -
> -struct isp_v4l2_subdevs_group {
> -	struct isp_subdev_i2c_board_info *subdevs;
> +struct isp_bus_cfg {
>  	enum isp_interface_type interface;
>  	union {
> -		struct isp_parallel_platform_data parallel;
> -		struct isp_ccp2_platform_data ccp2;
> -		struct isp_csi2_platform_data csi2;
> +		struct isp_parallel_cfg parallel;
> +		struct isp_ccp2_cfg ccp2;
> +		struct isp_csi2_cfg csi2;
>  	} bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
>  };
>  
> +struct isp_platform_subdev {
> +	struct i2c_board_info *board_info;
> +	int i2c_adapter_id;
> +	struct isp_bus_cfg *bus;
> +};
> +
>  struct isp_platform_xclk {
>  	const char *dev_id;
>  	const char *con_id;
> @@ -159,7 +159,7 @@ struct isp_platform_xclk {
>  
>  struct isp_platform_data {
>  	struct isp_platform_xclk xclks[2];
> -	struct isp_v4l2_subdevs_group *subdevs;
> +	struct isp_platform_subdev *subdevs;
>  	void (*set_constraints)(struct isp_device *isp, bool enable);
>  };
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
