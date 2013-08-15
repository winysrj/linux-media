Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43841 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3HOLc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 07:32:59 -0400
Message-ID: <520CBC6B.1000606@gmail.com>
Date: Thu, 15 Aug 2013 13:32:59 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, swarren@wwwdotorg.org, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 01/13] [media] exynos5-is: Adding media device driver
 for exynos5
References: <1376455574-15560-1-git-send-email-arun.kk@samsung.com> <1376455574-15560-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1376455574-15560-2-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the update. I'd like to possibly queue it for 3.12
once the review comments are addressed and the DT maintainers
are OK with that.

W dniu 2013-08-14 06:46, Arun Kumar K pisze:
> From: Shaik Ameer Basha <shaik.ameer@samsung.com>
>
> This patch adds support for media device for EXYNOS5 SoCs.
> The current media device supports the following ips to connect
> through the media controller framework.
>
> * MIPI-CSIS
>    Support interconnection(subdev interface) between devices
>
> * FIMC-LITE
>    Support capture interface from device(Sensor, MIPI-CSIS) to memory
>    Support interconnection(subdev interface) between devices
>
> * FIMC-IS
>    Camera post-processing IP having multiple sub-nodes.
>
> G-Scaler will be added later to the current media device.
>
> The media device creates two kinds of pipelines for connecting
> the above mentioned IPs.
> The pipeline0 is uses Sensor, MIPI-CSIS and FIMC-LITE which captures
> image data and dumps to memory.
> Pipeline1 uses FIMC-IS components for doing post-processing
> operations on the captured image and give scaled YUV output.
>
> Pipeline0
>    +--------+     +-----------+     +-----------+     +--------+
>    | Sensor | --> | MIPI-CSIS | --> | FIMC-LITE | --> | Memory |
>    +--------+     +-----------+     +-----------+     +--------+
>
> Pipeline1
>   +--------+      +--------+     +-----------+     +-----------+
>   | Memory | -->  |  ISP   | --> |    SCC    | --> |    SCP    |
>   +--------+      +--------+     +-----------+     +-----------+
>
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>   .../devicetree/bindings/media/exynos5-mdev.txt     |  130 +++
>   drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1218 ++++++++++++++++++++
>   drivers/media/platform/exynos5-is/exynos5-mdev.h   |  160 +++
>   3 files changed, 1508 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/exynos5-mdev.txt
>   create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
>   create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h
>
> diff --git a/Documentation/devicetree/bindings/media/exynos5-mdev.txt b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
> new file mode 100644
> index 0000000..007ce21
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
> @@ -0,0 +1,130 @@
> +Samsung EXYNOS5 SoC Camera Subsystem
> +------------------------------------
> +
> +The Exynos5 SoC Camera subsystem comprises of multiple sub-devices
> +represented by separate device tree nodes. Currently this includes: FIMC-LITE,
> +MIPI CSIS and FIMC-IS.
> +
> +The sub-subdevices are defined as child nodes of the common 'camera' node which

That statement is not true any more, the sub-devices are now referenced
by phandles.

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

s/exynos5/exynos5250. And "simple-bus" is not needed.

> +- clocks	: list of clock specifiers, corresponding to entries in
> +		  the clock-names property;
> +- clock-names	: must contain "sclk_bayer" entry

> +- csis		: list of phandles to the mipi-csis device nodes
> +- fimc-lite	: list of phandles to the fimc-lite device nodes
> +- fimc-is	: phandle to the fimc-is device node

These properties should be prefixed with "samsung,".

> +The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be used
> +to define a required pinctrl state named "default".
> +
> +'parallel-ports' node
> +---------------------
> +
> +This node should contain child 'port' nodes specifying active parallel video
> +input ports. It includes camera A, camera B, MIPI-CSI2 and RGB bay inputs.

MIPI CSI-2 is a serial bus, it doesn't belong to the parallel-ports
node. Thus only 1,2,5 should be listed in this section. My apologies
if I wasn't clear enough in my previous comments.

> +'reg' property in the port nodes specifies the input type:
> + 1 - parallel camport A
> + 2 - parallel camport B
> + 3 - serial MIPI CSI-2 port 0
> + 4 - serial MIPI CSI-2 port 1
> + 5 - RGB camera bay
> +
> +3, 4 are already described in samsung-mipi-csis.txt
> +
> +Image sensor nodes
> +------------------
> +
> +The sensor device nodes should be added to their control bus controller (e.g.
> +I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
> +using the common video interfaces bindings, defined in video-interfaces.txt.

> +The implementation of this bindings requires clock-frequency property to be
> +present in the sensor device nodes.

That statement is not valid any more. The clock is now handled by
the sensor drivers and if clock-frequency property is not present
a default value will be used. So you need to drop this sentence.

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
> +	s5c73m3: sensor@1a {
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
> +
> +	camera {
> +		compatible = "samsung,exynos5-fimc", "simple-bus";

s/"samsung,exynos5-fimc"/"samsung,exynos5250-fimc"

> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		status = "okay";
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&cam_port_a_clk_active>;
> +
> +		csis = <&csis_0>, <&csis_1>;

s/csis =/samsung,csis =

> +		fimc-lite = <&fimc_lite_0>,  <&fimc_lite_1>, <&fimc_lite_2>;

s/fimc-lite =/samsung,fimc-lite =

nit: Superfluos space after "<&fimc_lite_0>," ?

> +		fimc-is = <&fimc_is>;

s/fimc-is =/samsung,fimc-is =

> +		/* parallel camera ports */
> +		parallel-ports {
> +			/* camera A input */
> +			port@0 {
> +				reg = <0>;
> +				fimc0_ep: endpoint {

fimc0_ep seems an incorrect name, perhaps cam_a_ep or camport_a_ep ?

> +					remote-endpoint = <&s5k6aa_ep>;
> +					bus-width = <8>;
> +					hsync-active = <0>;
> +					vsync-active = <1>;
> +					pclk-sample = <1>;
> +				};
> +			};
> +		};
> +	};
> +
> +MIPI-CSIS device binding is defined in samsung-mipi-csis.txt, FIMC-LITE
> +device binding is defined in exynos-fimc-lite.txt and FIMC-IS binding
> +is defined in exynos5-fimc-is.txt.
> diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.c b/drivers/media/platform/exynos5-is/exynos5-mdev.c
> new file mode 100644
> index 0000000..0def7c4
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/exynos5-mdev.c
> @@ -0,0 +1,1218 @@
> +/*
> + * EXYNOS5 SoC series camera host interface media device driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Shaik Ameer Basha <shaik.ameer@samsung.com>
> + * Arun Kumar K <arun.kk@samsung.com>
> + *
> + * This driver is based on exynos4-is media device driver written by
> + * Sylwester Nawrocki <s.nawrocki@samsung.com>.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */
> +
> +#include <linux/bug.h>
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/device.h>
> +#include <linux/errno.h>
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_device.h>
> +#include <linux/of_i2c.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>

nit: slab.h should be before types.h

> +#include <media/v4l2-async.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-of.h>

> +#include <media/media-device.h>
> +#include <media/s5p_fimc.h>

nit: not in alphabetical order

> +#include "exynos5-mdev.h"
> +#include "fimc-is.h"
> +
> +#define dbg(fmt, args...) \
> +	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)

Please remove this unused macro.

> +#define BAYER_CLK_NAME "sclk_bayer"
> +
> +/**
> + * fimc_pipeline_prepare - update pipeline information with subdevice pointers
> + * @me: media entity terminating the pipeline
> + *
> + * Caller holds the graph mutex.
> + */
> +static void fimc_pipeline_prepare(struct fimc_pipeline *p,
> +				  struct media_entity *me)
> +{
> +	struct v4l2_subdev *sd;
> +	int i;
> +
> +	for (i = 0; i < IDX_MAX; i++)
> +		p->subdevs[i] = NULL;
> +
> +	while (1) {
> +		struct media_pad *pad = NULL;
> +
> +		/* Find remote source pad */
> +		for (i = 0; i < me->num_pads; i++) {
> +			struct media_pad *spad = &me->pads[i];
> +			if (!(spad->flags & MEDIA_PAD_FL_SINK))
> +				continue;
> +			pad = media_entity_remote_pad(spad);
> +			if (pad)
> +				break;
> +		}
> +
> +		if (pad == NULL ||
> +		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV) {
> +			break;
> +		}
> +		sd = media_entity_to_v4l2_subdev(pad->entity);
> +
> +		switch (sd->grp_id) {
> +		case GRP_ID_FIMC_IS_SENSOR:
> +		case GRP_ID_SENSOR:
> +			p->subdevs[IDX_SENSOR] = sd;
> +			break;
> +		case GRP_ID_CSIS:
> +			p->subdevs[IDX_CSIS] = sd;
> +			break;
> +		case GRP_ID_FLITE:
> +			p->subdevs[IDX_FLITE] = sd;
> +			break;
> +		default:
> +			pr_warn("%s: Unknown subdev grp_id: %#x\n",
> +				__func__, sd->grp_id);
> +		}
> +		me = &sd->entity;
> +		if (me->num_pads == 1)
> +			break;
> +	}
> +
> +	/*
> +	 * For using FIMC-IS firmware controlled sensors, ISP subdev
> +	 * has to be initialized along with pipeline0 devices.
> +	 * So an ISP subdev from a free ISP pipeline is assigned to
> +	 * this pipeline

nit: missing dot.

> +	 */
> +	if (p->subdevs[IDX_SENSOR]->grp_id == GRP_ID_FIMC_IS_SENSOR) {
> +		struct fimc_pipeline_isp *p_isp;
> +
> +		list_for_each_entry(p_isp, p->isp_pipelines, list) {
> +			if (!p_isp->in_use) {
> +				p->subdevs[IDX_FIMC_IS] =
> +					p_isp->subdevs[IDX_ISP];
> +				p_isp->in_use = true;
> +				break;
> +			}
> +		}
> +	}
> +}
> +
[...]
> +/* Register FIMC-LITE, CSIS and FIMC-IS media entities */
> +static int fimc_md_register_of_platform_entities(struct fimc_md *fmd,
> +						struct device_node *camera)
> +{
> +	struct device_node *node;
> +	struct platform_device *pdev;
> +	int ret = 0;
> +	int i;
> +
> +	/* Register MIPI-CSIS entities */
> +	for (i = 0; i < FIMC_NUM_MIPI_CSIS; i++) {
> +
> +		node = of_parse_phandle(camera, "csis", i);
> +		if (!node || !of_device_is_compatible(node,
> +					CSIS_OF_COMPATIBLE_NAME))

Not sure if you need checking against the value of the compatible
property. Perhaps it is enough to say in the binding what compatible
values are supported for each phandle ? If you want to keep that
than I would say it is an error in the device tree structure
to have an incorrect device pointed by this phandle, which deserves
to be signalled with, e.g. WARN_ON().

For sure inactive device should be skipped, so you should also
have of_device_is_available() check here.

> +			continue;
> +
> +		pdev = of_find_device_by_node(node);
> +		if (!pdev)
> +			continue;
> +
> +		ret = fimc_md_register_platform_entity(fmd, pdev, IDX_CSIS);
> +		put_device(&pdev->dev);
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	/* Register FIMC-LITE entities */
> +	for (i = 0; i < FIMC_NUM_FIMC_LITE; i++) {
> +
> +		node = of_parse_phandle(camera, "fimc-lite", i);
> +		if (!node || !of_device_is_compatible(node,
> +					FIMC_LITE_OF_COMPATIBLE_NAME))

Ditto.

> +			continue;
> +
> +		pdev = of_find_device_by_node(node);
> +		if (!pdev)
> +			continue;
> +
> +		ret = fimc_md_register_platform_entity(fmd, pdev, IDX_FLITE);
> +		put_device(&pdev->dev);
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	/* Register fimc-is entity */
> +	node = of_parse_phandle(camera, "fimc-is", 0);
> +	if (!node || !of_device_is_compatible(node,
> +				FIMC_IS_OF_COMPATIBLE_NAME))

Ditto.

> +		goto exit;
> +
> +	pdev = of_find_device_by_node(node);
> +	if (!pdev)
> +		goto exit;
> +
> +	ret = fimc_md_register_platform_entity(fmd, pdev, IDX_FIMC_IS);
> +
> +	put_device(&pdev->dev);
> +exit:
> +	return ret;
> +}
[...]
> +static int fimc_md_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct v4l2_device *v4l2_dev;
> +	struct fimc_md *fmd;
> +	int ret;
> +
> +	fmd = devm_kzalloc(dev, sizeof(*fmd), GFP_KERNEL);
> +	if (!fmd)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&fmd->slock);
> +	fmd->pdev = pdev;
> +	INIT_LIST_HEAD(&fmd->pipelines);
> +	INIT_LIST_HEAD(&fmd->isp_pipelines);
> +
> +	strlcpy(fmd->media_dev.model, "SAMSUNG EXYNOS5 IS",
> +		sizeof(fmd->media_dev.model));
> +	fmd->media_dev.link_notify = fimc_md_link_notify;
> +	fmd->media_dev.dev = dev;
> +
> +	v4l2_dev = &fmd->v4l2_dev;
> +	v4l2_dev->mdev = &fmd->media_dev;
> +	strlcpy(v4l2_dev->name, "exynos5-fimc-md", sizeof(v4l2_dev->name));
> +
> +	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
> +	if (ret < 0) {
> +		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = media_device_register(&fmd->media_dev);
> +	if (ret < 0) {
> +		v4l2_err(v4l2_dev, "Failed to register media dev: %d\n", ret);
> +		goto err_md;
> +	}
> +
> +	fmd->clk_bayer = ERR_PTR(-EINVAL);

This assignment is meaningless, could be just removed.

> +	fmd->clk_bayer = clk_get(dev, BAYER_CLK_NAME);
> +	if (IS_ERR(fmd->clk_bayer)) {
> +		v4l2_err(v4l2_dev, "Failed to get clk: %s\n", BAYER_CLK_NAME);
> +		goto err_md;
> +	}
> +
> +	platform_set_drvdata(pdev, fmd);
> +
> +	/* Protect the media graph while we're registering entities */
> +	mutex_lock(&fmd->media_dev.graph_mutex);
> +
> +	ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
> +	if (ret)
> +		goto err_unlock;
> +
> +	fmd->num_sensors = 0;
> +	ret = fimc_md_of_sensors_register(fmd, dev->of_node);
> +	if (ret)
> +		goto err_unlock;
> +
> +	mutex_unlock(&fmd->media_dev.graph_mutex);
> +
> +	fmd->subdev_notifier.subdevs = fmd->async_subdevs;
> +	fmd->subdev_notifier.num_subdevs = fmd->num_sensors;
> +	fmd->subdev_notifier.bound = subdev_notifier_bound;
> +	fmd->subdev_notifier.complete = subdev_notifier_complete;
> +	fmd->num_sensors = 0;
> +
> +	ret = v4l2_async_notifier_register(&fmd->v4l2_dev,
> +					   &fmd->subdev_notifier);
> +	if (ret)
> +		goto err_clk;
> +
> +	return 0;
> +
> +err_unlock:
> +	mutex_unlock(&fmd->media_dev.graph_mutex);
> +err_clk:
> +	clk_put(fmd->clk_bayer);
> +	fimc_md_unregister_entities(fmd);
> +	media_device_unregister(&fmd->media_dev);
> +err_md:
> +	v4l2_device_unregister(&fmd->v4l2_dev);
> +	return ret;
> +}
[...]

> +MODULE_AUTHOR("Shaik Ameer Basha <shaik.ameer@samsung.com>");
> +MODULE_DESCRIPTION("EXYNOS5 FIMC media device driver");

s/FIMC/camera subsystem ?

> +MODULE_LICENSE("GPL");

s/GPL/GPL v2 ?

> diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.h b/drivers/media/platform/exynos5-is/exynos5-mdev.h
> new file mode 100644
> index 0000000..8563a21
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/exynos5-mdev.h
> @@ -0,0 +1,160 @@
[...]
> +/**
> + * struct fimc_md - fimc media device information
> + * @csis: MIPI CSIS subdevs data
> + * @sensor: array of registered sensor subdevs
> + * @num_sensors: actual number of registered sensors
> + * @bayer_clk: bus clk for external sensors

s/bayer_clk/clk_bayer

> + * @fimc: array of registered fimc devices

s/fimc/fimc_lite

> + * @is: fimc-is data structure
> + * @media_dev: top level media device
> + * @v4l2_dev: top level v4l2_device holding up the subdevs
> + * @pdev: platform device this media device is hooked up into

> + * @user_subdev_api: true if subdevs are not configured by the host driver

> + * @slock: spinlock protecting @sensor array
> + */
> +struct fimc_md {
> +	struct fimc_csis_info csis[CSIS_MAX_ENTITIES];
> +	struct fimc_sensor_info sensor[FIMC_MAX_SENSORS];
> +	int num_sensors;
> +	struct clk *clk_bayer;
> +	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
> +	struct fimc_is *is;
> +	struct media_device media_dev;
> +	struct v4l2_device v4l2_dev;
> +	struct platform_device *pdev;
> +	struct v4l2_async_notifier subdev_notifier;
> +	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_SENSORS];
> +
> +	bool user_subdev_api;

This field is unused, please remove.

> +	spinlock_t slock;
> +	struct list_head pipelines;
> +	struct list_head isp_pipelines;
> +};

> +#define is_subdev_pad(pad) (pad == NULL || \
> +	media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
> +
> +#define me_subtype(me) \
> +	((me->type) & (MEDIA_ENT_TYPE_MASK | MEDIA_ENT_SUBTYPE_MASK))
> +
> +#define subdev_has_devnode(__sd) (__sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE)

And these three macros as well.

> +#define to_fimc_pipeline(_ep) container_of(_ep, struct fimc_pipeline, ep)
> +#define to_fimc_isp_pipeline(_ep) \
> +	container_of(_ep, struct fimc_pipeline_isp, ep)
> +
> +static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
> +{
> +	return me->parent == NULL ? NULL :
> +		container_of(me->parent, struct fimc_md, media_dev);
> +}
> +
> +static inline struct fimc_md *notifier_to_fimc_md(struct v4l2_async_notifier *n)
> +{
> +	return container_of(n, struct fimc_md, subdev_notifier);
> +}

> +static inline void fimc_md_graph_lock(struct exynos_video_entity *ve)
> +{
> +	mutex_lock(&ve->vdev.entity.parent->graph_mutex);
> +}
> +
> +static inline void fimc_md_graph_unlock(struct exynos_video_entity *ve)
> +{
> +	mutex_unlock(&ve->vdev.entity.parent->graph_mutex);
> +}

These two functions are unused, should be safe to remove them.

> +static inline struct v4l2_subdev *__fimc_md_get_subdev(
> +				struct exynos_media_pipeline *ep,
> +				unsigned int index)
> +{
> +	struct fimc_pipeline *p = to_fimc_pipeline(ep);
> +
> +	if (!p || index >= IDX_MAX)
> +		return NULL;
> +	else
> +		return p->subdevs[index];
> +}

Unused function ?

--
Thanks,
Sylwester
