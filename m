Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:58411 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3CJW2N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 18:28:13 -0400
Message-ID: <513D08F2.2040908@gmail.com>
Date: Sun, 10 Mar 2013 23:28:02 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com,
	shaik.samsung@gmail.com
Subject: Re: [RFC 07/12] media: exynos5-is: Adding media device driver for
 exynos5
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com> <1362570838-4737-8-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-8-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2013 12:53 PM, Shaik Ameer Basha wrote:
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
> G-Scaler will be added later to the current media device.
>
> * Gscaler: general scaler
>    Support memory to memory interface
>    Support output interface from memory to display device(LCD, TV)
>    Support capture interface from device(FIMC-LITE, FIMD) to memory
>
> -->  media 0
>    Camera Capture path consists of MIPI-CSIS, FIMC-LITE and G-Scaler
>    +--------+     +-----------+     +-----------------+
>    | Sensor | -->  | FIMC-LITE | -->  | G-Scaler-capture |
>    +--------+     +-----------+     +-----------------+
>
>    +--------+     +-----------+     +-----------+     +-----------------+
>    | Sensor | -->  | MIPI-CSIS | -->  | FIMC-LITE | -->  | G-Scaler-capture |
>    +--------+     +-----------+     +-----------+     +-----------------+
>
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> ---
>   drivers/media/platform/Kconfig                   |    1 +
>   drivers/media/platform/Makefile                  |    1 +
>   drivers/media/platform/exynos5-is/Kconfig        |    7 +
>   drivers/media/platform/exynos5-is/Makefile       |    4 +
>   drivers/media/platform/exynos5-is/exynos5-mdev.c | 1309 ++++++++++++++++++++++
>   drivers/media/platform/exynos5-is/exynos5-mdev.h |  107 ++
>   6 files changed, 1429 insertions(+)
>   create mode 100644 drivers/media/platform/exynos5-is/Kconfig
>   create mode 100644 drivers/media/platform/exynos5-is/Makefile
>   create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
>   create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h
>
...
> diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.c b/drivers/media/platform/exynos5-is/exynos5-mdev.c
> new file mode 100644
> index 0000000..1158696
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/exynos5-mdev.c
> @@ -0,0 +1,1309 @@
> +/*
> + * S5P/EXYNOS4 SoC series camera host interface media device driver

EXYNOS5

> + * Copyright (C) 2011 - 2012 Samsung Electronics Co., Ltd.
> + * Sylwester Nawrocki<s.nawrocki@samsung.com>

This is incorrect too, you should add your authorship and a note it
is based on other code, with a proper copyright notice.

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */
> +
> +#include<linux/bug.h>
> +#include<linux/device.h>
> +#include<linux/errno.h>
> +#include<linux/i2c.h>
> +#include<linux/kernel.h>
> +#include<linux/list.h>
> +#include<linux/module.h>
> +#include<linux/of.h>
> +#include<linux/of_platform.h>
> +#include<linux/of_device.h>
> +#include<linux/of_i2c.h>
> +#include<linux/pinctrl/consumer.h>
> +#include<linux/platform_device.h>
> +#include<linux/pm_runtime.h>
> +#include<linux/types.h>
> +#include<linux/slab.h>
> +#include<media/v4l2-ctrls.h>
> +#include<media/v4l2-of.h>
> +#include<media/media-device.h>
> +
> +#include "exynos5-mdev.h"
> +
> +#define dbg(fmt, args...) \
> +	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
> +
> +static struct fimc_md *g_exynos_mdev;
> +
> +static int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
> +static int __fimc_md_set_camclk(struct fimc_md *fmd,
> +				struct fimc_sensor_info *s_info,
> +				bool on);
> +/**
> + * fimc_pipeline_prepare - update pipeline information with subdevice pointers
> + * @fimc: fimc device terminating the pipeline
> + *
> + * Caller holds the graph mutex.
> + */
> +static void fimc_pipeline_prepare(struct exynos5_pipeline0 *p,
> +				  struct media_entity *me)
> +{
> +	struct media_pad *pad =&me->pads[0];

This will need to be changed to support subdevs with more than 2 pads.
I should post relevant patch this week.

> +	struct v4l2_subdev *sd;
> +	int i;
> +
> +	for (i = 0; i<  IDX_MAX; i++)
> +		p->subdevs[i] = NULL;
> +
> +	while (1) {
> +
> +		if (!(pad->flags&  MEDIA_PAD_FL_SINK))
> +			break;
> +
> +		/* source pad */
> +		pad = media_entity_remote_source(pad);
> +
> +		if (pad != NULL)
> +			pr_err("entity type: %d, entity name: %s\n",
> +			    media_entity_type(pad->entity), pad->entity->name);
> +
> +		if (pad == NULL ||
> +		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +			break;
> +
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
> +
> +		/* sink pad */
> +		pad =&sd->entity.pads[0];
> +	}
> +}
...
> +/*
> + * Sensor subdevice helper functions
> + */
> +static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
> +				   struct fimc_sensor_info *s_info)
> +{
> +	struct i2c_adapter *adapter;
> +	struct v4l2_subdev *sd = NULL;
> +
> +	if (!s_info || !fmd)
> +		return NULL;
> +
> +	adapter = i2c_get_adapter(s_info->pdata.i2c_bus_num);
> +	if (!adapter) {
> +		v4l2_warn(&fmd->v4l2_dev,
> +			  "Failed to get I2C adapter %d, deferring probe\n",
> +			  s_info->pdata.i2c_bus_num);
> +		return ERR_PTR(-EPROBE_DEFER);
> +	}
> +	sd = v4l2_i2c_new_subdev_board(&fmd->v4l2_dev, adapter,
> +				       s_info->pdata.board_info, NULL);
> +	if (IS_ERR_OR_NULL(sd)) {
> +		i2c_put_adapter(adapter);
> +		v4l2_warn(&fmd->v4l2_dev,
> +			  "Failed to acquire subdev %s, deferring probe\n",
> +			  s_info->pdata.board_info->type);
> +		return ERR_PTR(-EPROBE_DEFER);
> +	}
> +	v4l2_set_subdev_hostdata(sd, s_info);
> +	sd->grp_id = GRP_ID_SENSOR;
> +
> +	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice %s\n",
> +		  sd->name);
> +	return sd;
> +}
> +
> +static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct i2c_adapter *adapter;
> +
> +	if (!client)
> +		return;
> +	v4l2_device_unregister_subdev(sd);
> +
> +	if (!client->dev.of_node) {
> +		adapter = client->adapter;
> +		i2c_unregister_device(client);
> +		if (adapter)
> +			i2c_put_adapter(adapter);
> +	}
> +}

You don't need the above code which is for !CONFIG_OF only.

> +#ifdef CONFIG_OF

Just add "depends on OF" in Kconfig for the whole driver and
you can drop all #ifdef CONFIG_OF.

> +/* Register I2C client subdev associated with @node. */
> +static int fimc_md_of_add_sensor(struct fimc_md *fmd,
> +				 struct device_node *node, int index)
> +{
> +	struct fimc_sensor_info *si;
> +	struct i2c_client *client;
> +	struct v4l2_subdev *sd;
> +	int ret;
> +
> +	if (WARN_ON(index>= ARRAY_SIZE(fmd->sensor)))
> +		return -EINVAL;
> +
> +	si =&fmd->sensor[index];
> +
> +	client = of_find_i2c_device_by_node(node);
> +	if (!client)
> +		return -EPROBE_DEFER;
> +
> +	device_lock(&client->dev);
> +
> +	if (!client->driver ||
> +	    !try_module_get(client->driver->driver.owner)) {
> +		ret = -EPROBE_DEFER;
> +		goto dev_put;
> +	}
> +
> +	/* Enable sensor's master clock */
> +	ret = __fimc_md_set_camclk(fmd, si, true);
> +	if (ret<  0)
> +		goto mod_put;
> +
> +	sd = i2c_get_clientdata(client);
> +
> +	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
> +	__fimc_md_set_camclk(fmd, si, false);
> +	if (ret<  0)
> +		goto mod_put;
> +
> +	v4l2_set_subdev_hostdata(sd, si);
> +	sd->grp_id = GRP_ID_SENSOR;
> +	si->subdev = sd;
> +	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice: %s (%d)\n",
> +		  sd->name, fmd->num_sensors);
> +	fmd->num_sensors++;
> +
> +mod_put:
> +	module_put(client->driver->driver.owner);
> +dev_put:
> +	device_unlock(&client->dev);
> +	put_device(&client->dev);
> +	return ret;
> +}
...
> +#else
> +#define fimc_md_of_sensors_register(fmd, np) (-ENOSYS)

This would never be used since Exynos5 is a dt-only platform.

> +#endif
> +
> +static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
> +{
> +	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
> +	struct device_node *of_node = fmd->pdev->dev.of_node;
> +	int num_clients = 0;
> +	int ret, i;
> +
> +	if (of_node) {
> +		fmd->num_sensors = 0;
> +		ret = fimc_md_of_sensors_register(fmd, of_node);
> +	} else if (pdata) {

The code below is for !CONFIG_OF only, no need to repeat it for Exynos5.

> +		WARN_ON(pdata->num_clients>  ARRAY_SIZE(fmd->sensor));
> +		num_clients = min_t(u32, pdata->num_clients,
> +				    ARRAY_SIZE(fmd->sensor));
> +		fmd->num_sensors = num_clients;
> +
> +		fmd->num_sensors = num_clients;
> +		for (i = 0; i<  num_clients; i++) {
> +			struct v4l2_subdev *sd;
> +
> +			fmd->sensor[i].pdata = pdata->source_info[i];
> +			ret = __fimc_md_set_camclk(fmd,&fmd->sensor[i], true);
> +			if (ret)
> +				break;
> +			sd = fimc_md_register_sensor(fmd,&fmd->sensor[i]);
> +			ret = __fimc_md_set_camclk(fmd,&fmd->sensor[i], false);
> +
> +			if (IS_ERR(sd)) {
> +				fmd->sensor[i].subdev = NULL;
> +				ret = PTR_ERR(sd);
> +				break;
> +			}
> +			fmd->sensor[i].subdev = sd;
> +			if (ret)
> +				break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * MIPI-CSIS, FIMC and FIMC-LITE platform devices registration.
> + */
> +
> +static int register_fimc_lite_entity(struct fimc_md *fmd,
> +				     struct fimc_lite *fimc_lite)
> +{
> +	struct v4l2_subdev *sd;
> +	int ret;
> +
> +	if (WARN_ON(fimc_lite->index>= FIMC_LITE_MAX_DEVS ||
> +		    fmd->fimc_lite[fimc_lite->index]))
> +		return -EBUSY;
> +
> +	sd =&fimc_lite->subdev;
> +	sd->grp_id = GRP_ID_FLITE;
> +	v4l2_set_subdev_hostdata(sd, (void *)&exynos5_pipeline0_ops);
> +
> +	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
> +	if (!ret)
> +		fmd->fimc_lite[fimc_lite->index] = fimc_lite;
> +	else
> +		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.LITE%d\n",
> +			 fimc_lite->index);
> +	return ret;
> +}
> +
> +static int register_csis_entity(struct fimc_md *fmd,
> +				struct platform_device *pdev,
> +				struct v4l2_subdev *sd)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	int id, ret;
> +
> +	id = node ? of_alias_get_id(node, "csis") : max(0, pdev->id);
> +
> +	if (WARN_ON(id>= CSIS_MAX_ENTITIES || fmd->csis[id].sd))
> +		return -EBUSY;
> +
> +	if (WARN_ON(id>= CSIS_MAX_ENTITIES))
> +		return 0;
> +
> +	sd->grp_id = GRP_ID_CSIS;
> +	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
> +	if (!ret)
> +		fmd->csis[id].sd = sd;
> +	else
> +		v4l2_err(&fmd->v4l2_dev,
> +			 "Failed to register MIPI-CSIS.%d (%d)\n", id, ret);
> +
> +	return ret;
> +}
> +
> +static int fimc_md_register_platform_entity(struct fimc_md *fmd,
> +					    struct platform_device *pdev,
> +					    int plat_entity)
> +{
> +	struct device *dev =&pdev->dev;
> +	int ret = -EPROBE_DEFER;
> +	void *drvdata;
> +
> +	/* Lock to ensure dev->driver won't change. */
> +	device_lock(dev);
> +
> +	if (!dev->driver || !try_module_get(dev->driver->owner))
> +		goto dev_unlock;
> +
> +	drvdata = dev_get_drvdata(dev);
> +	/* Some subdev didn't probe succesfully id drvdata is NULL */
> +	if (drvdata) {
> +		switch (plat_entity) {
> +		case IDX_FLITE:
> +			ret = register_fimc_lite_entity(fmd, drvdata);
> +			break;
> +		case IDX_CSIS:
> +			ret = register_csis_entity(fmd, pdev, drvdata);
> +			break;
> +		default:
> +			ret = -ENODEV;
> +		}
> +	}
> +
> +	module_put(dev->driver->owner);
> +dev_unlock:
> +	device_unlock(dev);
> +	if (ret == -EPROBE_DEFER)
> +		dev_info(&fmd->pdev->dev, "deferring %s device registration\n",
> +			dev_name(dev));
> +	else if (ret<  0)
> +		dev_err(&fmd->pdev->dev, "%s device registration failed (%d)\n",
> +			dev_name(dev), ret);
> +	return ret;
> +}
> +
> +static int fimc_md_pdev_match(struct device *dev, void *data)

This function is also useless in your case.

> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	int plat_entity = -1;
> +	int ret;
> +
> +	if (!get_device(dev))
> +		return -ENODEV;
> +
> +	if (!strcmp(pdev->name, CSIS_DRIVER_NAME))
> +		plat_entity = IDX_CSIS;
> +	else if (!strcmp(pdev->name, FIMC_LITE_DRV_NAME))
> +		plat_entity = IDX_FLITE;
> +
> +	if (plat_entity>= 0)
> +		ret = fimc_md_register_platform_entity(data, pdev,
> +						       plat_entity);
> +	put_device(dev);
> +	return 0;
> +}
> +
> +/* Register FIMC, FIMC-LITE and CSIS media entities */
> +#ifdef CONFIG_OF
> +static int fimc_md_register_of_platform_entities(struct fimc_md *fmd,
> +						 struct device_node *parent)
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
> +		/* If driver of any entity isn't ready try all again later. */
> +		if (!strcmp(node->name, CSIS_OF_NODE_NAME))
> +			plat_entity = IDX_CSIS;
> +		else if (!strcmp(node->name, FIMC_LITE_OF_NODE_NAME))
> +			plat_entity = IDX_FLITE;
> +
> +		if (plat_entity>= 0)
> +			ret = fimc_md_register_platform_entity(fmd, pdev,
> +							plat_entity);
> +		put_device(&pdev->dev);
> +		if (ret<  0)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +#else
> +#define fimc_md_register_platform_entities(fmd) (-ENOSYS)
> +#endif
...
> +static int fimc_md_link_notify(struct media_pad *source,
> +			       struct media_pad *sink, u32 flags)
> +{
> +	struct fimc_lite *fimc_lite = NULL;
> +	struct exynos_pipeline *pipeline;
> +	struct exynos5_pipeline0 *p;
> +	struct v4l2_subdev *sd;
> +	struct mutex *lock;
> +	int ret = 0;
> +	int ref_count;
> +
> +	if (media_entity_type(sink->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		return 0;
> +
> +	sd = media_entity_to_v4l2_subdev(sink->entity);
> +
> +	switch (sd->grp_id) {
> +	case GRP_ID_FLITE:
> +		fimc_lite = v4l2_get_subdevdata(sd);
> +		if (WARN_ON(fimc_lite == NULL))
> +			return 0;
> +		pipeline =&fimc_lite->pipeline;
> +		lock =&fimc_lite->lock;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	p = (struct exynos5_pipeline0 *)pipeline->priv;
> +	if (!p || !p->is_init)
> +		return -EINVAL;
> +
> +	if (!(flags&  MEDIA_LNK_FL_ENABLED)) {
> +		int i;
> +		mutex_lock(lock);

ref_count needs to be checked here as well.

> +		ret = __fimc_pipeline_close(pipeline);
> +		for (i = 0; i<  IDX_MAX; i++)
> +			p->subdevs[i] = NULL;
> +		mutex_unlock(lock);
> +		return ret;
> +	}
> +	/*
> +	 * Link activation. Enable power of pipeline elements only if the
> +	 * pipeline is already in use, i.e. its video node is opened.
> +	 * Recreate the controls destroyed during the link deactivation.

I think this line should be deleted.

> +	 */
> +	mutex_lock(lock);
> +
> +	ref_count = fimc_lite->ref_count;
> +	if (ref_count>  0)
> +		ret = __fimc_pipeline_open(pipeline, source->entity, true);
> +
> +	mutex_unlock(lock);
> +	return ret ? -EPIPE : ret;
> +}
> +
> +static ssize_t fimc_md_sysfs_show(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct fimc_md *fmd = platform_get_drvdata(pdev);
> +
> +	if (fmd->user_subdev_api)
> +		return strlcpy(buf, "Sub-device API (sub-dev)\n", PAGE_SIZE);
> +
> +	return strlcpy(buf, "V4L2 video node only API (vid-dev)\n", PAGE_SIZE);
> +}
> +
> +static ssize_t fimc_md_sysfs_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct fimc_md *fmd = platform_get_drvdata(pdev);
> +	bool subdev_api;
> +	int i;
> +
> +	if (!strcmp(buf, "vid-dev\n"))
> +		subdev_api = false;
> +	else if (!strcmp(buf, "sub-dev\n"))
> +		subdev_api = true;
> +	else
> +		return count;
> +
> +	fmd->user_subdev_api = subdev_api;
> +	for (i = 0; i<  FIMC_LITE_MAX_DEVS; i++)
> +		if (fmd->fimc_lite[i])
> +			fmd->fimc_lite[i]->user_subdev_api = subdev_api;
> +
> +	return count;
> +}
> +/*
> + * This device attribute is to select video pipeline configuration method.
> + * There are following valid values:
> + *  vid-dev - for V4L2 video node API only, subdevice will be configured
> + *  by the host driver.
> + *  sub-dev - for media controller API, subdevs must be configured in user
> + *  space before starting streaming.
> + */
> +static DEVICE_ATTR(subdev_conf_mode, S_IWUSR | S_IRUGO,
> +		   fimc_md_sysfs_show, fimc_md_sysfs_store);

Please don't copy that. It is a not standard attribute that you should not
need in this driver anyway.

> +/**
> + * fimc_md_sensor_notify - v4l2_device notification from a sensor subdev
> + * @sd: pointer to a subdev generating the notification
> + * @notification: the notification type, must be S5P_FIMC_TX_END_NOTIFY
> + * @arg: pointer to an u32 type integer that stores the frame payload value
> + *
> + * Passes the sensor notification to the capture device
> + */
> +static void fimc_md_sensor_notify(struct v4l2_subdev *sd,
> +				unsigned int notification, void *arg)
> +{
> +	struct fimc_md *fmd;
> +	struct exynos_pipeline *ep;
> +	struct exynos5_pipeline0 *p;
> +	unsigned long flags;
> +
> +	if (sd == NULL)
> +		return;
> +
> +	ep = media_pipe_to_exynos_pipeline(sd->entity.pipe);
> +	p = (struct exynos5_pipeline0 *)ep->priv;
> +
> +	spin_lock_irqsave(&fmd->slock, flags);
> +
> +	if (p->sensor_notify)
> +		p->sensor_notify(sd, notification, arg);
> +
> +	spin_unlock_irqrestore(&fmd->slock, flags);
> +}
> +
> +static int fimc_md_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =&pdev->dev;
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
> +
> +	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",

Please change this to "SAMSUNG EXYNOS5 IS" or something similar.
This could confuse user space!

> +		sizeof(fmd->media_dev.model));
> +	fmd->media_dev.link_notify = fimc_md_link_notify;
> +	fmd->media_dev.dev = dev;
> +
> +	v4l2_dev =&fmd->v4l2_dev;
> +	v4l2_dev->mdev =&fmd->media_dev;
> +	v4l2_dev->notify = fimc_md_sensor_notify;
> +	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));

exynos-fimc-md ?

> +
> +	ret = v4l2_device_register(dev,&fmd->v4l2_dev);
> +	if (ret<  0) {
> +		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
> +
> +		return ret;
> +
> +	}
> +	ret = media_device_register(&fmd->media_dev);
> +	if (ret<  0) {
> +		v4l2_err(v4l2_dev, "Failed to register media dev: %d\n", ret);
> +		goto err_md;
> +	}
> +	ret = fimc_md_get_clocks(fmd);
> +	if (ret)
> +		goto err_clk;
> +
> +	fmd->user_subdev_api = (dev->of_node != NULL);
> +	g_exynos_mdev = fmd;
> +
> +	/* Protect the media graph while we're registering entities */
> +	mutex_lock(&fmd->media_dev.graph_mutex);
> +
> +	if (fmd->pdev->dev.of_node)
> +		ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
> +	else
> +		ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
> +						fimc_md_pdev_match);
> +
> +	if (ret)
> +		goto err_unlock;
> +
> +	if (dev->platform_data || dev->of_node) {

platform_data will never be used, and dev->of_node would be always not NULL.

> +		ret = fimc_md_register_sensor_entities(fmd);
> +		if (ret)
> +			goto err_unlock;
> +	}
> +
> +	ret = fimc_md_create_links(fmd);
> +	if (ret)
> +		goto err_unlock;
> +
> +	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
> +	if (ret)
> +		goto err_unlock;
> +
> +	ret = device_create_file(&pdev->dev,&dev_attr_subdev_conf_mode);
> +	if (ret)
> +		goto err_unlock;
> +
> +	platform_set_drvdata(pdev, fmd);
> +	mutex_unlock(&fmd->media_dev.graph_mutex);
> +	return 0;
> +
> +err_unlock:
> +	mutex_unlock(&fmd->media_dev.graph_mutex);
> +err_clk:
> +	media_device_unregister(&fmd->media_dev);
> +	fimc_md_put_clocks(fmd);
> +	fimc_md_unregister_entities(fmd);
> +err_md:
> +	v4l2_device_unregister(&fmd->v4l2_dev);
> +	return ret;
> +}
> +
...
> +static struct platform_device_id fimc_driver_ids[] __always_unused = {
> +	{ .name = "exynos-fimc-md" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
> +
> +static const struct of_device_id fimc_md_of_match[] __initconst = {

The attribute is wrong. I would remove that "__initconst".

> +	{ .compatible = "samsung,exynos5-fimc" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, fimc_md_of_match);
> +

--

Regards,
Sylwester
