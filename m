Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38705 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab3D2QJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 12:09:55 -0400
Message-id: <517E9B4E.3080004@samsung.com>
Date: Mon, 29 Apr 2013 18:09:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v2 6/6] media: exynos5-is: Adding media device driver for
 exynos5
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
 <1366789273-30184-7-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1366789273-30184-7-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/24/2013 09:41 AM, Shaik Ameer Basha wrote:
> This patch adds support for media device for EXYNOS5 SoCs.
> The current media device supports the following ips to connect
> through the media controller framework.

> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  .../devicetree/bindings/media/exynos5-mdev.txt     |  153 +++
>  drivers/media/platform/Kconfig                     |    1 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/exynos5-is/Kconfig          |    7 +
>  drivers/media/platform/exynos5-is/Makefile         |    4 +
>  drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1131 ++++++++++++++++++++
>  drivers/media/platform/exynos5-is/exynos5-mdev.h   |  120 +++
>  7 files changed, 1417 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/exynos5-mdev.txt
>  create mode 100644 drivers/media/platform/exynos5-is/Kconfig
>  create mode 100644 drivers/media/platform/exynos5-is/Makefile
>  create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
>  create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h
> 
> diff --git a/Documentation/devicetree/bindings/media/exynos5-mdev.txt b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
> new file mode 100644
> index 0000000..d7d419b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
> @@ -0,0 +1,153 @@
> +Samsung EXYNOS5 SoC Camera Subsystem (FIMC)
> +----------------------------------------------
> +
> +The Exynos5 SoC Camera subsystem comprises of multiple sub-devices
> +represented by separate device tree nodes. Currently this includes: FIMC-LITE,
> +MIPI CSIS and FIMC-IS.
> +
> +The sub-subdevices are defined as child nodes of the common 'camera' node which
> +also includes common properties of the whole subsystem not really specific to
> +any single sub-device, like common camera port pins or the CAMCLK clock outputs
> +for external image sensors attached to an SoC.
> +
> +Common 'camera' node
> +--------------------
> +
> +Required properties:
> +
> +- compatible	: must be "samsung,exynos5-fimc", "simple-bus"
> +- clocks	: list of clock specifiers, corresponding to entries in
> +		  the clock-names property;
> +- clock-names	: must contain "sclk_cam0", "sclk_cam1" entries,
> +		  matching entries in the clocks property.
> +
> +The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be used
> +to define a required pinctrl state named "default" and optional pinctrl states:
> +"idle", "active-a", active-b". These optional states can be used to switch the
> +camera port pinmux at runtime. The "idle" state should configure both the camera
> +ports A and B into high impedance state, especially the CAMCLK clock output
> +should be inactive. For the "active-a" state the camera port A must be activated
> +and the port B deactivated and for the state "active-b" it should be the other
> +way around.
> +
> +The 'camera' node must include at least one 'fimc-lite' child node.

Why such a restriction ? Still you could have a valid video capture pipeline
using Gscaler, couldn't you ? 

> +'parallel-ports' node
> +---------------------
> +
> +This node should contain child 'port' nodes specifying active parallel video
> +input ports. It includes camera A and camera B inputs. 'reg' property in the
> +port nodes specifies data input - 0, 1 indicates input A, B respectively.
> +
> +Optional properties
> +
> +- samsung,camclk-out : specifies clock output for remote sensor,
> +		       0 - CAM_A_CLKOUT, 1 - CAM_B_CLKOUT;

I think with this driver we should try to start using the asynchronous subdev
registration API and the clock bindings right from the beginning, so the
above property would become unnecessary.

> +Image sensor nodes
> +------------------
> +
> +The sensor device nodes should be added to their control bus controller (e.g.
> +I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
> +using the common video interfaces bindings, defined in video-interfaces.txt.
> +The implementation of this bindings requires clock-frequency property to be
> +present in the sensor device nodes.
> +
> +Example:
> +
> +	aliases {
> +		fimc-lite0 = &fimc_lite_0
> +	};
> +
> +	/* Parallel bus IF sensor */
> +	i2c_0: i2c@13860000 {
> +		s5k6aa: sensor@3c {
> +			compatible = "samsung,s5k6aafx";
> +			reg = <0x3c>;
> +			vddio-supply = <...>;
> +
> +			clock-frequency = <24000000>;
> +			clocks = <...>;
> +			clock-names = "mclk";
> +
> +			port {
> +				s5k6aa_ep: endpoint {
> +					remote-endpoint = <&fimc0_ep>;
> +					bus-width = <8>;
> +					hsync-active = <0>;
> +					vsync-active = <1>;
> +					pclk-sample = <1>;
> +				};
> +			};
> +		};
> +	};
> +
> +	/* MIPI CSI-2 bus IF sensor */
> +	s5c73m3: sensor@0x1a {

This node should be off some I2C bus controller node, e.g. be child node of
the i2c@13860000 node. 

I realise a similar issue is in Documentation/devicetree/bindings/media/
samsung-fimc.txt. And nobody pointed it out... :P

> +		compatible = "samsung,s5c73m3";
> +		reg = <0x1a>;
> +		vddio-supply = <...>;
> +
> +		clock-frequency = <24000000>;
> +		clocks = <...>;
> +		clock-names = "mclk";
> +
> +		port {
> +			s5c73m3_1: endpoint {
> +				data-lanes = <1 2 3 4>;
> +				remote-endpoint = <&csis0_ep>;
> +			};
> +		};
> +	};

> diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.c b/drivers/media/platform/exynos5-is/exynos5-mdev.c
> new file mode 100644
> index 0000000..ac3e85e
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/exynos5-mdev.c
> @@ -0,0 +1,1131 @@
> +/*
> + * EXYNOS5 SoC series camera host interface media device driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Shaik Ameer Basha <shaik.ameer@samsung.com>
> + *
> + * This driver is based on exynos4-is media device driver developed by

s/developed/written ?

> + * Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */

> +static void fimc_md_unregister_entities(struct fimc_md *fmd)
> +{
> +	int i;
> +
> +	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
> +		if (fmd->fimc_lite[i] == NULL)
> +			continue;
> +		v4l2_device_unregister_subdev(&fmd->fimc_lite[i]->subdev);
> +		fmd->fimc_lite[i]->pipeline_ops = NULL;
> +		fmd->fimc_lite[i] = NULL;
> +	}
> +	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
> +		if (fmd->csis[i].sd == NULL)
> +			continue;
> +		v4l2_device_unregister_subdev(fmd->csis[i].sd);
> +		module_put(fmd->csis[i].sd->owner);

This module_put() call needs to be removed.

> +		fmd->csis[i].sd = NULL;
> +	}
> +	for (i = 0; i < fmd->num_sensors; i++) {
> +		if (fmd->sensor[i].subdev == NULL)
> +			continue;
> +		v4l2_device_unregister_subdev(fmd->sensor[i].subdev);
> +		fmd->sensor[i].subdev = NULL;
> +	}
> +	v4l2_info(&fmd->v4l2_dev, "Unregistered all entities\n");
> +}

> +static struct platform_device_id fimc_driver_ids[] __always_unused = {
> +	{ .name = "exynos5-fimc-md" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, fimc_driver_ids);

This table is not used, you can remove it.

> +static const struct of_device_id fimc_md_of_match[] = {
> +	{ .compatible = "samsung,exynos5-fimc" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, fimc_md_of_match);
> +
> +static struct platform_driver fimc_md_driver = {
> +	.probe		= fimc_md_probe,
> +	.remove		= fimc_md_remove,
> +	.driver = {
> +		.of_match_table = fimc_md_of_match,
> +		.name		= "exynos5-fimc-md",
> +		.owner		= THIS_MODULE,
> +	}
> +};

> +MODULE_AUTHOR("Shaik Ameer Basha <shaik.ameer@samsung.com>");
> +MODULE_DESCRIPTION("EXYNOS5 FIMC media device driver");

Perhaps "EXYNOS5 SoC camera subsystem media device driver" ?

> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.h b/drivers/media/platform/exynos5-is/exynos5-mdev.h
> new file mode 100644
> index 0000000..43621b6
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/exynos5-mdev.h
> @@ -0,0 +1,120 @@

> +#include <media/s5p_fimc.h>

> +/* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
> +#define GRP_ID_SENSOR		(1 << 8)
> +#define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
> +#define GRP_ID_WRITEBACK	(1 << 10)
> +#define GRP_ID_CSIS		(1 << 11)
> +#define GRP_ID_FLITE		(1 << 13)
> +#define GRP_ID_FIMC_IS		(1 << 14)

You are re-defining these constants third time now ;-)

> +struct exynos5_pipeline0 {

How is going struct exynos5_pipeline1 to look like ? Why do you need 
multiple video pipeline data structures ? Couldn't one be designed 
for exynos5 to cover all cases ?

> +	int is_init;
> +	struct fimc_md *fmd;
> +	struct v4l2_subdev *subdevs[IDX_MAX];
> +	void (*sensor_notify)(struct v4l2_subdev *sd,
> +			unsigned int notification, void *arg);
> +};

Regards,
Sylwester
