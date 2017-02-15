Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:38719 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751362AbdBOOqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 09:46:39 -0500
Date: Wed, 15 Feb 2017 08:46:22 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: <linux-media@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v1.1 5/8] v4l: Switch from V4L2 OF not V4L2 fwnode API
Message-ID: <20170215144622.GB10737@ti.com>
References: <20170213165746.GB1103@ti.com>
 <1487056352-4281-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1487056352-4281-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


For: ov2569.c, am437x/am437x-vpfe.c and ti-cal/cal.c:

Acked-by: Benoit Parrot <bparrot@ti.com>


Sakari Ailus <sakari.ailus@linux.intel.com> wrote on Tue [2017-Feb-14 09:12:32 +0200]:
> Switch users of the v4l2_of_ APIs to the more generic v4l2_fwnode_ APIs.
> 
> Existing OF matching continues to be supported. omap3isp and smiapp
> drivers are converted to fwnode matching as well.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Resending because of a mis-copied e-mail address.
> 
>  drivers/media/i2c/Kconfig                      |  9 ++++
>  drivers/media/i2c/adv7604.c                    |  7 +--
>  drivers/media/i2c/mt9v032.c                    |  7 +--
>  drivers/media/i2c/ov2659.c                     |  8 +--
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c       |  7 +--
>  drivers/media/i2c/s5k5baf.c                    |  6 +--
>  drivers/media/i2c/smiapp/Kconfig               |  1 +
>  drivers/media/i2c/smiapp/smiapp-core.c         | 29 ++++++-----
>  drivers/media/i2c/tc358743.c                   | 11 ++--
>  drivers/media/i2c/tvp514x.c                    |  6 +--
>  drivers/media/i2c/tvp5150.c                    |  7 +--
>  drivers/media/i2c/tvp7002.c                    |  6 +--
>  drivers/media/platform/Kconfig                 |  3 ++
>  drivers/media/platform/am437x/Kconfig          |  1 +
>  drivers/media/platform/am437x/am437x-vpfe.c    |  8 +--
>  drivers/media/platform/atmel/Kconfig           |  1 +
>  drivers/media/platform/atmel/atmel-isc.c       |  8 +--
>  drivers/media/platform/exynos4-is/Kconfig      |  2 +
>  drivers/media/platform/exynos4-is/media-dev.c  |  6 +--
>  drivers/media/platform/exynos4-is/mipi-csis.c  |  6 +--
>  drivers/media/platform/omap3isp/isp.c          | 71 +++++++++++++-------------
>  drivers/media/platform/pxa_camera.c            |  7 +--
>  drivers/media/platform/rcar-vin/Kconfig        |  1 +
>  drivers/media/platform/rcar-vin/rcar-core.c    |  6 +--
>  drivers/media/platform/soc_camera/Kconfig      |  1 +
>  drivers/media/platform/soc_camera/atmel-isi.c  |  7 +--
>  drivers/media/platform/soc_camera/soc_camera.c |  2 +-
>  drivers/media/platform/ti-vpe/cal.c            | 11 ++--
>  drivers/media/platform/xilinx/Kconfig          |  1 +
>  drivers/media/platform/xilinx/xilinx-vipp.c    | 59 +++++++++++----------
>  include/media/v4l2-fwnode.h                    |  4 +-
>  31 files changed, 175 insertions(+), 134 deletions(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index cee1dae..6b2423a 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -210,6 +210,7 @@ config VIDEO_ADV7604
>  	depends on GPIOLIB || COMPILE_TEST
>  	select HDMI
>  	select MEDIA_CEC_EDID
> +	select V4L2_FWNODE
>  	---help---
>  	  Support for the Analog Devices ADV7604 video decoder.
>  
> @@ -324,6 +325,7 @@ config VIDEO_TC358743
>  	tristate "Toshiba TC358743 decoder"
>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>  	select HDMI
> +	select V4L2_FWNODE
>  	---help---
>  	  Support for the Toshiba TC358743 HDMI to MIPI CSI-2 bridge.
>  
> @@ -333,6 +335,7 @@ config VIDEO_TC358743
>  config VIDEO_TVP514X
>  	tristate "Texas Instruments TVP514x video decoder"
>  	depends on VIDEO_V4L2 && I2C
> +	select V4L2_FWNODE
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the TI TVP5146/47
>  	  decoder. It is currently working with the TI OMAP3 camera
> @@ -344,6 +347,7 @@ config VIDEO_TVP514X
>  config VIDEO_TVP5150
>  	tristate "Texas Instruments TVP5150 video decoder"
>  	depends on VIDEO_V4L2 && I2C
> +	select V4L2_FWNODE
>  	---help---
>  	  Support for the Texas Instruments TVP5150 video decoder.
>  
> @@ -353,6 +357,7 @@ config VIDEO_TVP5150
>  config VIDEO_TVP7002
>  	tristate "Texas Instruments TVP7002 video decoder"
>  	depends on VIDEO_V4L2 && I2C
> +	select V4L2_FWNODE
>  	---help---
>  	  Support for the Texas Instruments TVP7002 video decoder.
>  
> @@ -524,6 +529,7 @@ config VIDEO_OV2659
>  	tristate "OmniVision OV2659 sensor support"
>  	depends on VIDEO_V4L2 && I2C
>  	depends on MEDIA_CAMERA_SUPPORT
> +	select V4L2_FWNODE
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the OmniVision
>  	  OV2659 camera.
> @@ -616,6 +622,7 @@ config VIDEO_MT9V032
>  	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>  	depends on MEDIA_CAMERA_SUPPORT
>  	select REGMAP_I2C
> +	select V4L2_FWNODE
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the Micron
>  	  MT9V032 752x480 CMOS sensor.
> @@ -663,6 +670,7 @@ config VIDEO_S5K4ECGX
>  config VIDEO_S5K5BAF
>  	tristate "Samsung S5K5BAF sensor support"
>  	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	select V4L2_FWNODE
>  	---help---
>  	  This is a V4L2 sensor-level driver for Samsung S5K5BAF 2M
>  	  camera sensor with an embedded SoC image signal processor.
> @@ -673,6 +681,7 @@ source "drivers/media/i2c/et8ek8/Kconfig"
>  config VIDEO_S5C73M3
>  	tristate "Samsung S5C73M3 sensor support"
>  	depends on I2C && SPI && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	select V4L2_FWNODE
>  	---help---
>  	  This is a V4L2 sensor-level driver for Samsung S5C73M3
>  	  8 Mpixel camera.
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index d8bf435..9281e54 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -33,6 +33,7 @@
>  #include <linux/i2c.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of_graph.h>
>  #include <linux/slab.h>
>  #include <linux/v4l2-dv-timings.h>
>  #include <linux/videodev2.h>
> @@ -45,7 +46,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-dv-timings.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  
>  static int debug;
>  module_param(debug, int, 0644);
> @@ -3069,7 +3070,7 @@ MODULE_DEVICE_TABLE(of, adv76xx_of_id);
>  
>  static int adv76xx_parse_dt(struct adv76xx_state *state)
>  {
> -	struct v4l2_of_endpoint bus_cfg;
> +	struct v4l2_fwnode_endpoint bus_cfg;
>  	struct device_node *endpoint;
>  	struct device_node *np;
>  	unsigned int flags;
> @@ -3083,7 +3084,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
>  	if (!endpoint)
>  		return -EINVAL;
>  
> -	ret = v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint), &bus_cfg);
>  	if (ret) {
>  		of_node_put(endpoint);
>  		return ret;
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 2e7a6e6..8a43064 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -19,6 +19,7 @@
>  #include <linux/log2.h>
>  #include <linux/mutex.h>
>  #include <linux/of.h>
> +#include <linux/of_graph.h>
>  #include <linux/regmap.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
> @@ -28,7 +29,7 @@
>  #include <media/i2c/mt9v032.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
>  
>  /* The first four rows are black rows. The active area spans 753x481 pixels. */
> @@ -979,7 +980,7 @@ static struct mt9v032_platform_data *
>  mt9v032_get_pdata(struct i2c_client *client)
>  {
>  	struct mt9v032_platform_data *pdata = NULL;
> -	struct v4l2_of_endpoint endpoint;
> +	struct v4l2_fwnode_endpoint endpoint;
>  	struct device_node *np;
>  	struct property *prop;
>  
> @@ -990,7 +991,7 @@ mt9v032_get_pdata(struct i2c_client *client)
>  	if (!np)
>  		return NULL;
>  
> -	if (v4l2_of_parse_endpoint(np, &endpoint) < 0)
> +	if (v4l2_fwnode_endpoint_parse(of_fwnode_handle(np), &endpoint) < 0)
>  		goto done;
>  
>  	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
> index 6e63672..545ca3f 100644
> --- a/drivers/media/i2c/ov2659.c
> +++ b/drivers/media/i2c/ov2659.c
> @@ -42,9 +42,9 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-event.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-image-sizes.h>
>  #include <media/v4l2-mediabus.h>
> -#include <media/v4l2-of.h>
>  #include <media/v4l2-subdev.h>
>  
>  #define DRIVER_NAME "ov2659"
> @@ -1346,7 +1346,7 @@ static struct ov2659_platform_data *
>  ov2659_get_pdata(struct i2c_client *client)
>  {
>  	struct ov2659_platform_data *pdata;
> -	struct v4l2_of_endpoint *bus_cfg;
> +	struct v4l2_fwnode_endpoint *bus_cfg;
>  	struct device_node *endpoint;
>  
>  	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> @@ -1356,7 +1356,7 @@ ov2659_get_pdata(struct i2c_client *client)
>  	if (!endpoint)
>  		return NULL;
>  
> -	bus_cfg = v4l2_of_alloc_parse_endpoint(endpoint);
> +	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(endpoint));
>  	if (IS_ERR(bus_cfg)) {
>  		pdata = NULL;
>  		goto done;
> @@ -1376,7 +1376,7 @@ ov2659_get_pdata(struct i2c_client *client)
>  	pdata->link_frequency = bus_cfg->link_frequencies[0];
>  
>  done:
> -	v4l2_of_free_endpoint(bus_cfg);
> +	v4l2_fwnode_endpoint_free(bus_cfg);
>  	of_node_put(endpoint);
>  	return pdata;
>  }
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> index 3844853..f434fb2 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> @@ -24,6 +24,7 @@
>  #include <linux/media.h>
>  #include <linux/module.h>
>  #include <linux/of_gpio.h>
> +#include <linux/of_graph.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/sizes.h>
>  #include <linux/slab.h>
> @@ -35,7 +36,7 @@
>  #include <media/v4l2-subdev.h>
>  #include <media/v4l2-mediabus.h>
>  #include <media/i2c/s5c73m3.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  
>  #include "s5c73m3.h"
>  
> @@ -1602,7 +1603,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
>  	const struct s5c73m3_platform_data *pdata = dev->platform_data;
>  	struct device_node *node = dev->of_node;
>  	struct device_node *node_ep;
> -	struct v4l2_of_endpoint ep;
> +	struct v4l2_fwnode_endpoint ep;
>  	int ret;
>  
>  	if (!node) {
> @@ -1639,7 +1640,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
>  		return 0;
>  	}
>  
> -	ret = v4l2_of_parse_endpoint(node_ep, &ep);
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(node_ep), &ep);
>  	of_node_put(node_ep);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index db82ed0..962051b 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -30,7 +30,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-subdev.h>
>  #include <media/v4l2-mediabus.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  
>  static int debug;
>  module_param(debug, int, 0644);
> @@ -1841,7 +1841,7 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
>  {
>  	struct device_node *node = dev->of_node;
>  	struct device_node *node_ep;
> -	struct v4l2_of_endpoint ep;
> +	struct v4l2_fwnode_endpoint ep;
>  	int ret;
>  
>  	if (!node) {
> @@ -1868,7 +1868,7 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
>  		return -EINVAL;
>  	}
>  
> -	ret = v4l2_of_parse_endpoint(node_ep, &ep);
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(node_ep), &ep);
>  	of_node_put(node_ep);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/media/i2c/smiapp/Kconfig b/drivers/media/i2c/smiapp/Kconfig
> index 3149cda..f59718d 100644
> --- a/drivers/media/i2c/smiapp/Kconfig
> +++ b/drivers/media/i2c/smiapp/Kconfig
> @@ -3,5 +3,6 @@ config VIDEO_SMIAPP
>  	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAVE_CLK
>  	depends on MEDIA_CAMERA_SUPPORT
>  	select VIDEO_SMIAPP_PLL
> +	select V4L2_FWNODE
>  	---help---
>  	  This is a generic driver for SMIA++/SMIA camera modules.
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index f4e92bd..4d8ebd8 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -27,12 +27,13 @@
>  #include <linux/gpio/consumer.h>
>  #include <linux/module.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/property.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
>  #include <linux/smiapp.h>
>  #include <linux/v4l2-mediabus.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-device.h>
> -#include <media/v4l2-of.h>
>  
>  #include "smiapp.h"
>  
> @@ -2784,19 +2785,20 @@ static int __maybe_unused smiapp_resume(struct device *dev)
>  static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
>  {
>  	struct smiapp_hwconfig *hwcfg;
> -	struct v4l2_of_endpoint *bus_cfg;
> -	struct device_node *ep;
> +	struct v4l2_fwnode_endpoint *bus_cfg;
> +	struct fwnode_handle *ep;
> +	struct fwnode_handle *fwn = device_fwnode_handle(dev);
>  	int i;
>  	int rval;
>  
> -	if (!dev->of_node)
> +	if (!fwn)
>  		return dev->platform_data;
>  
> -	ep = of_graph_get_next_endpoint(dev->of_node, NULL);
> +	ep = fwnode_graph_get_next_endpoint(fwn, NULL);
>  	if (!ep)
>  		return NULL;
>  
> -	bus_cfg = v4l2_of_alloc_parse_endpoint(ep);
> +	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(ep);
>  	if (IS_ERR(bus_cfg))
>  		goto out_err;
>  
> @@ -2817,11 +2819,10 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
>  	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
>  
>  	/* NVM size is not mandatory */
> -	of_property_read_u32(dev->of_node, "nokia,nvm-size",
> -				    &hwcfg->nvm_size);
> +	fwnode_property_read_u32(fwn, "nokia,nvm-size", &hwcfg->nvm_size);
>  
> -	rval = of_property_read_u32(dev->of_node, "clock-frequency",
> -				    &hwcfg->ext_clk);
> +	rval = fwnode_property_read_u32(fwn, "clock-frequency",
> +					&hwcfg->ext_clk);
>  	if (rval) {
>  		dev_warn(dev, "can't get clock-frequency\n");
>  		goto out_err;
> @@ -2846,13 +2847,13 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
>  		dev_dbg(dev, "freq %d: %lld\n", i, hwcfg->op_sys_clock[i]);
>  	}
>  
> -	v4l2_of_free_endpoint(bus_cfg);
> -	of_node_put(ep);
> +	v4l2_fwnode_endpoint_free(bus_cfg);
> +	fwnode_handle_put(ep);
>  	return hwcfg;
>  
>  out_err:
> -	v4l2_of_free_endpoint(bus_cfg);
> -	of_node_put(ep);
> +	v4l2_fwnode_endpoint_free(bus_cfg);
> +	fwnode_handle_put(ep);
>  	return NULL;
>  }
>  
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index f569a05..6a1b428 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -33,6 +33,7 @@
>  #include <linux/delay.h>
>  #include <linux/gpio/consumer.h>
>  #include <linux/interrupt.h>
> +#include <linux/of_graph.h>
>  #include <linux/videodev2.h>
>  #include <linux/workqueue.h>
>  #include <linux/v4l2-dv-timings.h>
> @@ -41,7 +42,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-event.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/i2c/tc358743.h>
>  
>  #include "tc358743_regs.h"
> @@ -76,7 +77,7 @@ static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
>  
>  struct tc358743_state {
>  	struct tc358743_platform_data pdata;
> -	struct v4l2_of_bus_mipi_csi2 bus;
> +	struct v4l2_fwnode_bus_mipi_csi2 bus;
>  	struct v4l2_subdev sd;
>  	struct media_pad pad;
>  	struct v4l2_ctrl_handler hdl;
> @@ -1687,7 +1688,7 @@ static void tc358743_gpio_reset(struct tc358743_state *state)
>  static int tc358743_probe_of(struct tc358743_state *state)
>  {
>  	struct device *dev = &state->i2c_client->dev;
> -	struct v4l2_of_endpoint *endpoint;
> +	struct v4l2_fwnode_endpoint *endpoint;
>  	struct device_node *ep;
>  	struct clk *refclk;
>  	u32 bps_pr_lane;
> @@ -1707,7 +1708,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
>  		return -EINVAL;
>  	}
>  
> -	endpoint = v4l2_of_alloc_parse_endpoint(ep);
> +	endpoint = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep));
>  	if (IS_ERR(endpoint)) {
>  		dev_err(dev, "failed to parse endpoint\n");
>  		return PTR_ERR(endpoint);
> @@ -1795,7 +1796,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
>  disable_clk:
>  	clk_disable_unprepare(refclk);
>  free_endpoint:
> -	v4l2_of_free_endpoint(endpoint);
> +	v4l2_fwnode_endpoint_free(endpoint);
>  	return ret;
>  }
>  #else
> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> index 07853d2..ad2df99 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -38,7 +38,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-mediabus.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/i2c/tvp514x.h>
>  #include <media/media-entity.h>
> @@ -998,7 +998,7 @@ static struct tvp514x_platform_data *
>  tvp514x_get_pdata(struct i2c_client *client)
>  {
>  	struct tvp514x_platform_data *pdata = NULL;
> -	struct v4l2_of_endpoint bus_cfg;
> +	struct v4l2_fwnode_endpoint bus_cfg;
>  	struct device_node *endpoint;
>  	unsigned int flags;
>  
> @@ -1009,7 +1009,7 @@ tvp514x_get_pdata(struct i2c_client *client)
>  	if (!endpoint)
>  		return NULL;
>  
> -	if (v4l2_of_parse_endpoint(endpoint, &bus_cfg))
> +	if (v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint), &bus_cfg))
>  		goto done;
>  
>  	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 48646a7..dff30a0 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -12,10 +12,11 @@
>  #include <linux/delay.h>
>  #include <linux/gpio/consumer.h>
>  #include <linux/module.h>
> +#include <linux/of_graph.h>
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-mc.h>
>  
>  #include "tvp5150_reg.h"
> @@ -1358,7 +1359,7 @@ static int tvp5150_init(struct i2c_client *c)
>  
>  static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
>  {
> -	struct v4l2_of_endpoint bus_cfg;
> +	struct v4l2_fwnode_endpoint bus_cfg;
>  	struct device_node *ep;
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct device_node *connectors, *child;
> @@ -1373,7 +1374,7 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
>  	if (!ep)
>  		return -EINVAL;
>  
> -	ret = v4l2_of_parse_endpoint(ep, &bus_cfg);
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &bus_cfg);
>  	if (ret)
>  		goto err;
>  
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 4c11901..a26c1a3 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -33,7 +33,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ctrls.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  
>  #include "tvp7002_reg.h"
>  
> @@ -889,7 +889,7 @@ static const struct v4l2_subdev_ops tvp7002_ops = {
>  static struct tvp7002_config *
>  tvp7002_get_pdata(struct i2c_client *client)
>  {
> -	struct v4l2_of_endpoint bus_cfg;
> +	struct v4l2_fwnode_endpoint bus_cfg;
>  	struct tvp7002_config *pdata = NULL;
>  	struct device_node *endpoint;
>  	unsigned int flags;
> @@ -901,7 +901,7 @@ tvp7002_get_pdata(struct i2c_client *client)
>  	if (!endpoint)
>  		return NULL;
>  
> -	if (v4l2_of_parse_endpoint(endpoint, &bus_cfg))
> +	if (v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint), &bus_cfg))
>  		goto done;
>  
>  	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index c9106e1..2f7792c 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -82,6 +82,7 @@ config VIDEO_OMAP3
>  	select ARM_DMA_USE_IOMMU
>  	select VIDEOBUF2_DMA_CONTIG
>  	select MFD_SYSCON
> +	select V4L2_FWNODE
>  	---help---
>  	  Driver for an OMAP 3 camera controller.
>  
> @@ -97,6 +98,7 @@ config VIDEO_PXA27x
>  	depends on PXA27x || COMPILE_TEST
>  	select VIDEOBUF2_DMA_SG
>  	select SG_SPLIT
> +	select V4L2_FWNODE
>  	---help---
>  	  This is a v4l2 driver for the PXA27x Quick Capture Interface
>  
> @@ -127,6 +129,7 @@ config VIDEO_TI_CAL
>  	depends on SOC_DRA7XX || COMPILE_TEST
>  	depends on HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
>  	default n
>  	---help---
>  	  Support for the TI CAL (Camera Adaptation Layer) block
> diff --git a/drivers/media/platform/am437x/Kconfig b/drivers/media/platform/am437x/Kconfig
> index 42d9c18..160e77e 100644
> --- a/drivers/media/platform/am437x/Kconfig
> +++ b/drivers/media/platform/am437x/Kconfig
> @@ -3,6 +3,7 @@ config VIDEO_AM437X_VPFE
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
>  	depends on SOC_AM43XX || COMPILE_TEST
>  	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
>  	help
>  	   Support for AM437x Video Processing Front End based Video
>  	   Capture Driver.
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> index 05489a4..3eb0bd2 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -26,6 +26,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> +#include <linux/of_graph.h>
>  #include <linux/pinctrl/consumer.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> @@ -36,7 +37,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-event.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  
>  #include "am437x-vpfe.h"
>  
> @@ -2419,7 +2420,7 @@ static struct vpfe_config *
>  vpfe_get_pdata(struct platform_device *pdev)
>  {
>  	struct device_node *endpoint = NULL;
> -	struct v4l2_of_endpoint bus_cfg;
> +	struct v4l2_fwnode_endpoint bus_cfg;
>  	struct vpfe_subdev_info *sdinfo;
>  	struct vpfe_config *pdata;
>  	unsigned int flags;
> @@ -2463,7 +2464,8 @@ vpfe_get_pdata(struct platform_device *pdev)
>  			sdinfo->vpfe_param.if_type = VPFE_RAW_BAYER;
>  		}
>  
> -		err = v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> +		err = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
> +						 &bus_cfg);
>  		if (err) {
>  			dev_err(&pdev->dev, "Could not parse the endpoint\n");
>  			goto done;
> diff --git a/drivers/media/platform/atmel/Kconfig b/drivers/media/platform/atmel/Kconfig
> index 867dca2..3dbc89c 100644
> --- a/drivers/media/platform/atmel/Kconfig
> +++ b/drivers/media/platform/atmel/Kconfig
> @@ -4,6 +4,7 @@ config VIDEO_ATMEL_ISC
>  	depends on ARCH_AT91 || COMPILE_TEST
>  	select VIDEOBUF2_DMA_CONTIG
>  	select REGMAP_MMIO
> +	select V4L2_FWNODE
>  	help
>  	   This module makes the ATMEL Image Sensor Controller available
>  	   as a v4l2 device.
> \ No newline at end of file
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> index fa68fe9..7af92e7 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -31,6 +31,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_graph.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/regmap.h>
> @@ -39,7 +40,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-image-sizes.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
>  #include <media/videobuf2-dma-contig.h>
>  
> @@ -1268,7 +1269,7 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
>  {
>  	struct device_node *np = dev->of_node;
>  	struct device_node *epn = NULL, *rem;
> -	struct v4l2_of_endpoint v4l2_epn;
> +	struct v4l2_fwnode_endpoint v4l2_epn;
>  	struct isc_subdev_entity *subdev_entity;
>  	unsigned int flags;
>  	int ret;
> @@ -1287,7 +1288,8 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
>  			continue;
>  		}
>  
> -		ret = v4l2_of_parse_endpoint(epn, &v4l2_epn);
> +		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(epn),
> +						 &v4l2_epn);
>  		if (ret) {
>  			of_node_put(rem);
>  			ret = -EINVAL;
> diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
> index 57d42c6..c480efb 100644
> --- a/drivers/media/platform/exynos4-is/Kconfig
> +++ b/drivers/media/platform/exynos4-is/Kconfig
> @@ -4,6 +4,7 @@ config VIDEO_SAMSUNG_EXYNOS4_IS
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>  	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
>  	depends on OF && COMMON_CLK
> +	select V4L2_FWNODE
>  	help
>  	  Say Y here to enable camera host interface devices for
>  	  Samsung S5P and EXYNOS SoC series.
> @@ -32,6 +33,7 @@ config VIDEO_S5P_MIPI_CSIS
>  	tristate "S5P/EXYNOS MIPI-CSI2 receiver (MIPI-CSIS) driver"
>  	depends on REGULATOR
>  	select GENERIC_PHY
> +	select V4L2_FWNODE
>  	help
>  	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC MIPI-CSI2
>  	  receiver (MIPI-CSIS) devices.
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index e82450e9..4a1808c 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -29,7 +29,7 @@
>  #include <linux/slab.h>
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-ctrls.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/media-device.h>
>  #include <media/drv-intf/exynos-fimc.h>
>  
> @@ -388,7 +388,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
>  {
>  	struct fimc_source_info *pd = &fmd->sensor[index].pdata;
>  	struct device_node *rem, *ep, *np;
> -	struct v4l2_of_endpoint endpoint;
> +	struct v4l2_fwnode_endpoint endpoint;
>  	int ret;
>  
>  	/* Assume here a port node can have only one endpoint node. */
> @@ -396,7 +396,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
>  	if (!ep)
>  		return 0;
>  
> -	ret = v4l2_of_parse_endpoint(ep, &endpoint);
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &endpoint);
>  	if (ret) {
>  		of_node_put(ep);
>  		return ret;
> diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
> index f819b29..98c8987 100644
> --- a/drivers/media/platform/exynos4-is/mipi-csis.c
> +++ b/drivers/media/platform/exynos4-is/mipi-csis.c
> @@ -30,7 +30,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/videodev2.h>
>  #include <media/drv-intf/exynos-fimc.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
>  
>  #include "mipi-csis.h"
> @@ -718,7 +718,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
>  			    struct csis_state *state)
>  {
>  	struct device_node *node = pdev->dev.of_node;
> -	struct v4l2_of_endpoint endpoint;
> +	struct v4l2_fwnode_endpoint endpoint;
>  	int ret;
>  
>  	if (of_property_read_u32(node, "clock-frequency",
> @@ -735,7 +735,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
>  		return -EINVAL;
>  	}
>  	/* Get port node and validate MIPI-CSI channel id. */
> -	ret = v4l2_of_parse_endpoint(node, &endpoint);
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(node), &endpoint);
>  	if (ret)
>  		goto err;
>  
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 084ecf4a..245225a 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -55,6 +55,7 @@
>  #include <linux/module.h>
>  #include <linux/omap-iommu.h>
>  #include <linux/platform_device.h>
> +#include <linux/property.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> @@ -63,9 +64,9 @@
>  #include <asm/dma-iommu.h>
>  
>  #include <media/v4l2-common.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-mc.h>
> -#include <media/v4l2-of.h>
>  
>  #include "isp.h"
>  #include "ispreg.h"
> @@ -2024,43 +2025,42 @@ enum isp_of_phy {
>  	ISP_OF_PHY_CSIPHY2,
>  };
>  
> -static int isp_of_parse_node(struct device *dev, struct device_node *node,
> -			     struct isp_async_subdev *isd)
> +static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwn,
> +			    struct isp_async_subdev *isd)
>  {
>  	struct isp_bus_cfg *buscfg = &isd->bus;
> -	struct v4l2_of_endpoint vep;
> +	struct v4l2_fwnode_endpoint vfwn;
>  	unsigned int i;
>  	int ret;
>  
> -	ret = v4l2_of_parse_endpoint(node, &vep);
> +	ret = v4l2_fwnode_endpoint_parse(fwn, &vfwn);
>  	if (ret)
>  		return ret;
>  
> -	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
> -		vep.base.port);
> +	dev_dbg(dev, "interface %u\n", vfwn.base.port);
>  
> -	switch (vep.base.port) {
> +	switch (vfwn.base.port) {
>  	case ISP_OF_PHY_PARALLEL:
>  		buscfg->interface = ISP_INTERFACE_PARALLEL;
>  		buscfg->bus.parallel.data_lane_shift =
> -			vep.bus.parallel.data_shift;
> +			vfwn.bus.parallel.data_shift;
>  		buscfg->bus.parallel.clk_pol =
> -			!!(vep.bus.parallel.flags
> +			!!(vfwn.bus.parallel.flags
>  			   & V4L2_MBUS_PCLK_SAMPLE_FALLING);
>  		buscfg->bus.parallel.hs_pol =
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
> +			!!(vfwn.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
>  		buscfg->bus.parallel.vs_pol =
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
> +			!!(vfwn.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
>  		buscfg->bus.parallel.fld_pol =
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
> +			!!(vfwn.bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
>  		buscfg->bus.parallel.data_pol =
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
> +			!!(vfwn.bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
>  		break;
>  
>  	case ISP_OF_PHY_CSIPHY1:
>  	case ISP_OF_PHY_CSIPHY2:
>  		/* FIXME: always assume CSI-2 for now. */
> -		switch (vep.base.port) {
> +		switch (vfwn.base.port) {
>  		case ISP_OF_PHY_CSIPHY1:
>  			buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
>  			break;
> @@ -2068,18 +2068,18 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
>  			buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
>  			break;
>  		}
> -		buscfg->bus.csi2.lanecfg.clk.pos = vep.bus.mipi_csi2.clock_lane;
> +		buscfg->bus.csi2.lanecfg.clk.pos = vfwn.bus.mipi_csi2.clock_lane;
>  		buscfg->bus.csi2.lanecfg.clk.pol =
> -			vep.bus.mipi_csi2.lane_polarities[0];
> +			vfwn.bus.mipi_csi2.lane_polarities[0];
>  		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
>  			buscfg->bus.csi2.lanecfg.clk.pol,
>  			buscfg->bus.csi2.lanecfg.clk.pos);
>  
>  		for (i = 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
>  			buscfg->bus.csi2.lanecfg.data[i].pos =
> -				vep.bus.mipi_csi2.data_lanes[i];
> +				vfwn.bus.mipi_csi2.data_lanes[i];
>  			buscfg->bus.csi2.lanecfg.data[i].pol =
> -				vep.bus.mipi_csi2.lane_polarities[i + 1];
> +				vfwn.bus.mipi_csi2.lane_polarities[i + 1];
>  			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
>  				buscfg->bus.csi2.lanecfg.data[i].pol,
>  				buscfg->bus.csi2.lanecfg.data[i].pos);
> @@ -2094,18 +2094,17 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
>  		break;
>  
>  	default:
> -		dev_warn(dev, "%s: invalid interface %u\n", node->full_name,
> -			 vep.base.port);
> +		dev_warn(dev, "invalid interface %u\n", vfwn.base.port);
>  		break;
>  	}
>  
>  	return 0;
>  }
>  
> -static int isp_of_parse_nodes(struct device *dev,
> -			      struct v4l2_async_notifier *notifier)
> +static int isp_fwnodes_parse(struct device *dev,
> +			     struct v4l2_async_notifier *notifier)
>  {
> -	struct device_node *node = NULL;
> +	struct fwnode_handle *fwn = NULL;
>  
>  	notifier->subdevs = devm_kcalloc(
>  		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
> @@ -2113,7 +2112,8 @@ static int isp_of_parse_nodes(struct device *dev,
>  		return -ENOMEM;
>  
>  	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
> -	       (node = of_graph_get_next_endpoint(dev->of_node, node))) {
> +	       (fwn = fwnode_graph_get_next_endpoint(device_fwnode_handle(dev),
> +						     fwn))) {
>  		struct isp_async_subdev *isd;
>  
>  		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> @@ -2122,23 +2122,24 @@ static int isp_of_parse_nodes(struct device *dev,
>  
>  		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
>  
> -		if (isp_of_parse_node(dev, node, isd))
> +		if (isp_fwnode_parse(dev, fwn, isd))
>  			goto error;
>  
> -		isd->asd.match.of.node = of_graph_get_remote_port_parent(node);
> -		if (!isd->asd.match.of.node) {
> +		isd->asd.match.fwnode.fwn =
> +			fwnode_graph_get_remote_port_parent(fwn);
> +		if (!isd->asd.match.fwnode.fwn) {
>  			dev_warn(dev, "bad remote port parent\n");
>  			goto error;
>  		}
>  
> -		isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
> +		isd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
>  		notifier->num_subdevs++;
>  	}
>  
>  	return notifier->num_subdevs;
>  
>  error:
> -	of_node_put(node);
> +	fwnode_handle_put(fwn);
>  	return -EINVAL;
>  }
>  
> @@ -2209,8 +2210,8 @@ static int isp_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	ret = of_property_read_u32(pdev->dev.of_node, "ti,phy-type",
> -				   &isp->phy_type);
> +	ret = fwnode_property_read_u32(device_fwnode_handle(&pdev->dev),
> +				       "ti,phy-type", &isp->phy_type);
>  	if (ret)
>  		return ret;
>  
> @@ -2219,12 +2220,12 @@ static int isp_probe(struct platform_device *pdev)
>  	if (IS_ERR(isp->syscon))
>  		return PTR_ERR(isp->syscon);
>  
> -	ret = of_property_read_u32_index(pdev->dev.of_node, "syscon", 1,
> -					 &isp->syscon_offset);
> +	ret = of_property_read_u32_index(pdev->dev.of_node,
> +					 "syscon", 1, &isp->syscon_offset);
>  	if (ret)
>  		return ret;
>  
> -	ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
> +	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> index 929006f..1ad4cf9 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -25,6 +25,7 @@
>  #include <linux/mm.h>
>  #include <linux/moduleparam.h>
>  #include <linux/of.h>
> +#include <linux/of_graph.h>
>  #include <linux/time.h>
>  #include <linux/platform_device.h>
>  #include <linux/clk.h>
> @@ -39,7 +40,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  
>  #include <media/videobuf2-dma-sg.h>
>  
> @@ -2236,7 +2237,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
>  {
>  	u32 mclk_rate;
>  	struct device_node *remote, *np = dev->of_node;
> -	struct v4l2_of_endpoint ep;
> +	struct v4l2_fwnode_endpoint ep;
>  	int err = of_property_read_u32(np, "clock-frequency",
>  				       &mclk_rate);
>  	if (!err) {
> @@ -2250,7 +2251,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
>  		return -EINVAL;
>  	}
>  
> -	err = v4l2_of_parse_endpoint(np, &ep);
> +	err = v4l2_fwnode_endpoint_parse(of_fwnode_handle(np), &ep);
>  	if (err) {
>  		dev_err(dev, "could not parse endpoint\n");
>  		goto out;
> diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
> index 111d2a1..af4c98b 100644
> --- a/drivers/media/platform/rcar-vin/Kconfig
> +++ b/drivers/media/platform/rcar-vin/Kconfig
> @@ -3,6 +3,7 @@ config VIDEO_RCAR_VIN
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDIA_CONTROLLER
>  	depends on ARCH_RENESAS || COMPILE_TEST
>  	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
>  	---help---
>  	  Support for Renesas R-Car Video Input (VIN) driver.
>  	  Supports R-Car Gen2 SoCs.
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 098a0b1..72903fc 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -21,7 +21,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  
>  #include "rcar-vin.h"
>  
> @@ -118,10 +118,10 @@ static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
>  				    struct device_node *ep,
>  				    struct v4l2_mbus_config *mbus_cfg)
>  {
> -	struct v4l2_of_endpoint v4l2_ep;
> +	struct v4l2_fwnode_endpoint v4l2_ep;
>  	int ret;
>  
> -	ret = v4l2_of_parse_endpoint(ep, &v4l2_ep);
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
>  	if (ret) {
>  		vin_err(vin, "Could not parse v4l2 endpoint\n");
>  		return -EINVAL;
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 86d7478..ab62932 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -33,6 +33,7 @@ config VIDEO_ATMEL_ISI
>  	depends on ARCH_AT91 || COMPILE_TEST
>  	depends on HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
>  	---help---
>  	  This module makes the ATMEL Image Sensor Interface available
>  	  as a v4l2 device.
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 46de657..f9f2ad6 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -19,13 +19,14 @@
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of_graph.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  
>  #include <media/soc_camera.h>
>  #include <media/drv-intf/soc_mediabus.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "atmel-isi.h"
> @@ -974,7 +975,7 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
>  			struct platform_device *pdev)
>  {
>  	struct device_node *np= pdev->dev.of_node;
> -	struct v4l2_of_endpoint ep;
> +	struct v4l2_fwnode_endpoint ep;
>  	int err;
>  
>  	/* Default settings for ISI */
> @@ -987,7 +988,7 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
>  		return -EINVAL;
>  	}
>  
> -	err = v4l2_of_parse_endpoint(np, &ep);
> +	err = v4l2_fwnode_endpoint_parse(of_fwnode_handle(np), &ep);
>  	of_node_put(np);
>  	if (err) {
>  		dev_err(&pdev->dev, "Could not parse the endpoint\n");
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index edd1c1d..cf246b2 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -23,6 +23,7 @@
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/of_graph.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/regulator/consumer.h>
> @@ -36,7 +37,6 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-dev.h>
> -#include <media/v4l2-of.h>
>  #include <media/videobuf-core.h>
>  #include <media/videobuf2-v4l2.h>
>  
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index 7a058b6..f72f541 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -21,7 +21,7 @@
>  #include <linux/of_device.h>
>  #include <linux/of_graph.h>
>  
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ctrls.h>
> @@ -270,7 +270,7 @@ struct cal_ctx {
>  	struct video_device	vdev;
>  	struct v4l2_async_notifier notifier;
>  	struct v4l2_subdev	*sensor;
> -	struct v4l2_of_endpoint	endpoint;
> +	struct v4l2_fwnode_endpoint	endpoint;
>  
>  	struct v4l2_async_subdev asd;
>  	struct v4l2_async_subdev *asd_list[1];
> @@ -608,7 +608,8 @@ static void csi2_lane_config(struct cal_ctx *ctx)
>  	u32 val = reg_read(ctx->dev, CAL_CSI2_COMPLEXIO_CFG(ctx->csi2_port));
>  	u32 lane_mask = CAL_CSI2_COMPLEXIO_CFG_CLOCK_POSITION_MASK;
>  	u32 polarity_mask = CAL_CSI2_COMPLEXIO_CFG_CLOCK_POL_MASK;
> -	struct v4l2_of_bus_mipi_csi2 *mipi_csi2 = &ctx->endpoint.bus.mipi_csi2;
> +	struct v4l2_fwnode_bus_mipi_csi2 *mipi_csi2 =
> +		&ctx->endpoint.bus.mipi_csi2;
>  	int lane;
>  
>  	set_field(&val, mipi_csi2->clock_lane + 1, lane_mask);
> @@ -1643,7 +1644,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  	struct platform_device *pdev = ctx->dev->pdev;
>  	struct device_node *ep_node, *port, *remote_ep,
>  			*sensor_node, *parent;
> -	struct v4l2_of_endpoint *endpoint;
> +	struct v4l2_fwnode_endpoint *endpoint;
>  	struct v4l2_async_subdev *asd;
>  	u32 regval = 0;
>  	int ret, index, found_port = 0, lane;
> @@ -1706,7 +1707,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  		ctx_dbg(3, ctx, "can't get remote-endpoint\n");
>  		goto cleanup_exit;
>  	}
> -	v4l2_of_parse_endpoint(remote_ep, endpoint);
> +	v4l2_fwnode_endpoint_parse(of_fwnode_handle(remote_ep), endpoint);
>  
>  	if (endpoint->bus_type != V4L2_MBUS_CSI2) {
>  		ctx_err(ctx, "Port:%d sub-device %s is not a CSI2 device\n",
> diff --git a/drivers/media/platform/xilinx/Kconfig b/drivers/media/platform/xilinx/Kconfig
> index 84bae79..a5d21b7 100644
> --- a/drivers/media/platform/xilinx/Kconfig
> +++ b/drivers/media/platform/xilinx/Kconfig
> @@ -2,6 +2,7 @@ config VIDEO_XILINX
>  	tristate "Xilinx Video IP (EXPERIMENTAL)"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
>  	---help---
>  	  Driver for Xilinx Video IP Pipelines
>  
> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
> index feb3b2f..6a2721b 100644
> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> @@ -22,7 +22,7 @@
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
> -#include <media/v4l2-of.h>
> +#include <media/v4l2-fwnode.h>
>  
>  #include "xilinx-dma.h"
>  #include "xilinx-vipp.h"
> @@ -74,7 +74,7 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>  	struct media_pad *local_pad;
>  	struct media_pad *remote_pad;
>  	struct xvip_graph_entity *ent;
> -	struct v4l2_of_link link;
> +	struct v4l2_fwnode_link link;
>  	struct device_node *ep = NULL;
>  	struct device_node *next;
>  	int ret = 0;
> @@ -92,7 +92,7 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>  
>  		dev_dbg(xdev->dev, "processing endpoint %s\n", ep->full_name);
>  
> -		ret = v4l2_of_parse_link(ep, &link);
> +		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
>  		if (ret < 0) {
>  			dev_err(xdev->dev, "failed to parse link for %s\n",
>  				ep->full_name);
> @@ -103,9 +103,10 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>  		 * the link.
>  		 */
>  		if (link.local_port >= local->num_pads) {
> -			dev_err(xdev->dev, "invalid port number %u on %s\n",
> -				link.local_port, link.local_node->full_name);
> -			v4l2_of_put_link(&link);
> +			dev_err(xdev->dev, "invalid port number %u for %s\n",
> +				link.local_port,
> +				to_of_node(link.local_node)->full_name);
> +			v4l2_fwnode_put_link(&link);
>  			ret = -EINVAL;
>  			break;
>  		}
> @@ -114,25 +115,28 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>  
>  		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
>  			dev_dbg(xdev->dev, "skipping sink port %s:%u\n",
> -				link.local_node->full_name, link.local_port);
> -			v4l2_of_put_link(&link);
> +				to_of_node(link.local_node)->full_name,
> +				link.local_port);
> +			v4l2_fwnode_put_link(&link);
>  			continue;
>  		}
>  
>  		/* Skip DMA engines, they will be processed separately. */
> -		if (link.remote_node == xdev->dev->of_node) {
> +		if (link.remote_node == of_fwnode_handle(xdev->dev->of_node)) {
>  			dev_dbg(xdev->dev, "skipping DMA port %s:%u\n",
> -				link.local_node->full_name, link.local_port);
> -			v4l2_of_put_link(&link);
> +				to_of_node(link.local_node)->full_name,
> +				link.local_port);
> +			v4l2_fwnode_put_link(&link);
>  			continue;
>  		}
>  
>  		/* Find the remote entity. */
> -		ent = xvip_graph_find_entity(xdev, link.remote_node);
> +		ent = xvip_graph_find_entity(xdev,
> +					     to_of_node(link.remote_node));
>  		if (ent == NULL) {
>  			dev_err(xdev->dev, "no entity found for %s\n",
> -				link.remote_node->full_name);
> -			v4l2_of_put_link(&link);
> +				to_of_node(link.remote_node)->full_name);
> +			v4l2_fwnode_put_link(&link);
>  			ret = -ENODEV;
>  			break;
>  		}
> @@ -141,15 +145,16 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>  
>  		if (link.remote_port >= remote->num_pads) {
>  			dev_err(xdev->dev, "invalid port number %u on %s\n",
> -				link.remote_port, link.remote_node->full_name);
> -			v4l2_of_put_link(&link);
> +				link.remote_port,
> +				to_of_node(link.remote_node)->full_name);
> +			v4l2_fwnode_put_link(&link);
>  			ret = -EINVAL;
>  			break;
>  		}
>  
>  		remote_pad = &remote->pads[link.remote_port];
>  
> -		v4l2_of_put_link(&link);
> +		v4l2_fwnode_put_link(&link);
>  
>  		/* Create the media link. */
>  		dev_dbg(xdev->dev, "creating %s:%u -> %s:%u link\n",
> @@ -194,7 +199,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
>  	struct media_pad *source_pad;
>  	struct media_pad *sink_pad;
>  	struct xvip_graph_entity *ent;
> -	struct v4l2_of_link link;
> +	struct v4l2_fwnode_link link;
>  	struct device_node *ep = NULL;
>  	struct device_node *next;
>  	struct xvip_dma *dma;
> @@ -213,7 +218,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
>  
>  		dev_dbg(xdev->dev, "processing endpoint %s\n", ep->full_name);
>  
> -		ret = v4l2_of_parse_link(ep, &link);
> +		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
>  		if (ret < 0) {
>  			dev_err(xdev->dev, "failed to parse link for %s\n",
>  				ep->full_name);
> @@ -225,7 +230,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
>  		if (dma == NULL) {
>  			dev_err(xdev->dev, "no DMA engine found for port %u\n",
>  				link.local_port);
> -			v4l2_of_put_link(&link);
> +			v4l2_fwnode_put_link(&link);
>  			ret = -EINVAL;
>  			break;
>  		}
> @@ -234,19 +239,21 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
>  			dma->video.name);
>  
>  		/* Find the remote entity. */
> -		ent = xvip_graph_find_entity(xdev, link.remote_node);
> +		ent = xvip_graph_find_entity(xdev,
> +					     to_of_node(link.remote_node));
>  		if (ent == NULL) {
>  			dev_err(xdev->dev, "no entity found for %s\n",
> -				link.remote_node->full_name);
> -			v4l2_of_put_link(&link);
> +				to_of_node(link.remote_node)->full_name);
> +			v4l2_fwnode_put_link(&link);
>  			ret = -ENODEV;
>  			break;
>  		}
>  
>  		if (link.remote_port >= ent->entity->num_pads) {
>  			dev_err(xdev->dev, "invalid port number %u on %s\n",
> -				link.remote_port, link.remote_node->full_name);
> -			v4l2_of_put_link(&link);
> +				link.remote_port,
> +				to_of_node(link.remote_node)->full_name);
> +			v4l2_fwnode_put_link(&link);
>  			ret = -EINVAL;
>  			break;
>  		}
> @@ -263,7 +270,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
>  			sink_pad = &dma->pad;
>  		}
>  
> -		v4l2_of_put_link(&link);
> +		v4l2_fwnode_put_link(&link);
>  
>  		/* Create the media link. */
>  		dev_dbg(xdev->dev, "creating %s:%u -> %s:%u link\n",
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index a675d8a..bc9cf51 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -17,10 +17,10 @@
>  #ifndef _V4L2_FWNODE_H
>  #define _V4L2_FWNODE_H
>  
> +#include <linux/errno.h>
> +#include <linux/fwnode.h>
>  #include <linux/list.h>
>  #include <linux/types.h>
> -#include <linux/errno.h>
> -#include <linux/of_graph.h>
>  
>  #include <media/v4l2-mediabus.h>
>  
> -- 
> 2.7.4
> 
