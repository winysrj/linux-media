Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41703 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab2K3J06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Nov 2012 04:26:58 -0500
Subject: Re: [RFC v2 2/5] video: panel: Add DPI panel support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Inki Dae <inki.dae@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Tom Gall <tom.gall@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
In-Reply-To: <1353620736-6517-3-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1353620736-6517-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Nov 2012 10:26:51 +0100
Message-ID: <1354267611.2568.83.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Donnerstag, den 22.11.2012, 22:45 +0100 schrieb Laurent Pinchart:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/video/display/Kconfig     |   13 +++
>  drivers/video/display/Makefile    |    1 +
>  drivers/video/display/panel-dpi.c |  147 +++++++++++++++++++++++++++++++++++++
>  include/video/panel-dpi.h         |   24 ++++++
>  4 files changed, 185 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/video/display/panel-dpi.c
>  create mode 100644 include/video/panel-dpi.h
> 
> diff --git a/drivers/video/display/Kconfig b/drivers/video/display/Kconfig
> index 1d533e7..0f9b990 100644
> --- a/drivers/video/display/Kconfig
> +++ b/drivers/video/display/Kconfig
> @@ -2,3 +2,16 @@ menuconfig DISPLAY_CORE
>  	tristate "Display Core"
>  	---help---
>  	  Support common display framework for graphics devices.
> +
> +if DISPLAY_CORE
> +
> +config DISPLAY_PANEL_DPI
> +	tristate "DPI (Parallel) Display Panels"
> +	---help---
> +	  Support for simple digital (parallel) pixel interface panels. Those
> +	  panels receive pixel data through a parallel bus and have no control
> +	  bus.

I have tried this driver together with the imx parallel-display with the
added patch below for device tree support.

> +	  If you are in doubt, say N.
> +
> +endif # DISPLAY_CORE
> diff --git a/drivers/video/display/Makefile b/drivers/video/display/Makefile
> index bd93496..47978d4 100644
> --- a/drivers/video/display/Makefile
> +++ b/drivers/video/display/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_DISPLAY_CORE) += display-core.o
> +obj-$(CONFIG_DISPLAY_PANEL_DPI) += panel-dpi.o
> diff --git a/drivers/video/display/panel-dpi.c b/drivers/video/display/panel-dpi.c
> new file mode 100644
> index 0000000..c56197a
> --- /dev/null
> +++ b/drivers/video/display/panel-dpi.c
> @@ -0,0 +1,147 @@
> +/*
> + * DPI Display Panel
> + *
> + * Copyright (C) 2012 Renesas Solutions Corp.
> + *
> + * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +#include <video/display.h>
> +#include <video/panel-dpi.h>
> +
> +struct panel_dpi {
> +	struct display_entity entity;
> +	const struct panel_dpi_platform_data *pdata;
> +};
> +
> +#define to_panel_dpi(p)		container_of(p, struct panel_dpi, entity)
> +
> +static const struct display_entity_interface_params panel_dpi_params = {
> +	.type = DISPLAY_ENTITY_INTERFACE_DPI,
> +};
> +
> +static int panel_dpi_set_state(struct display_entity *entity,
> +			       enum display_entity_state state)
> +{
> +	switch (state) {
> +	case DISPLAY_ENTITY_STATE_OFF:
> +	case DISPLAY_ENTITY_STATE_STANDBY:
> +		display_entity_set_stream(entity->source,
> +					  DISPLAY_ENTITY_STREAM_STOPPED);
> +		break;
> +
> +	case DISPLAY_ENTITY_STATE_ON:
> +		display_entity_set_stream(entity->source,
> +					  DISPLAY_ENTITY_STREAM_CONTINUOUS);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int panel_dpi_get_modes(struct display_entity *entity,
> +			       const struct videomode **modes)
> +{
> +	struct panel_dpi *panel = to_panel_dpi(entity);
> +
> +	*modes = panel->pdata->mode;
> +	return 1;
> +}
> +
> +static int panel_dpi_get_size(struct display_entity *entity,
> +			      unsigned int *width, unsigned int *height)
> +{
> +	struct panel_dpi *panel = to_panel_dpi(entity);
> +
> +	*width = panel->pdata->width;
> +	*height = panel->pdata->height;
> +	return 0;
> +}
> +
> +static int panel_dpi_get_params(struct display_entity *entity,
> +				struct display_entity_interface_params *params)
> +{
> +	*params = panel_dpi_params;
> +	return 0;
> +}
> +
> +static const struct display_entity_control_ops panel_dpi_control_ops = {
> +	.set_state = panel_dpi_set_state,
> +	.get_modes = panel_dpi_get_modes,
> +	.get_size = panel_dpi_get_size,
> +	.get_params = panel_dpi_get_params,
> +};
> +
> +static void panel_dpi_release(struct display_entity *entity)
> +{
> +	struct panel_dpi *panel = to_panel_dpi(entity);
> +
> +	kfree(panel);
> +}
> +
> +static int panel_dpi_remove(struct platform_device *pdev)
> +{
> +	struct panel_dpi *panel = platform_get_drvdata(pdev);
> +
> +	platform_set_drvdata(pdev, NULL);
> +	display_entity_unregister(&panel->entity);
> +
> +	return 0;
> +}
> +
> +static int __devinit panel_dpi_probe(struct platform_device *pdev)
> +{
> +	const struct panel_dpi_platform_data *pdata = pdev->dev.platform_data;
> +	struct panel_dpi *panel;
> +	int ret;
> +
> +	if (pdata == NULL)
> +		return -ENODEV;
> +
> +	panel = kzalloc(sizeof(*panel), GFP_KERNEL);
> +	if (panel == NULL)
> +		return -ENOMEM;
> +
> +	panel->pdata = pdata;
> +	panel->entity.dev = &pdev->dev;
> +	panel->entity.release = panel_dpi_release;

I don't understand this. Shouldn't the panel be allocated with
devm_kzalloc and display_entity_register make sure that this driver
cannot be unbound instead?

What if we call in sequence on this device's entity:
	display_entity_get(entity);
	display_entity_release(entity); /* here struct panel_dpi gets freed */
	display_entity_get(entity);
	display_entity_release(entity);

> +	panel->entity.ops.ctrl = &panel_dpi_control_ops;
> +
> +	ret = display_entity_register(&panel->entity);
> +	if (ret < 0) {
> +		kfree(panel);
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, panel);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops panel_dpi_dev_pm_ops = {
> +};
> +
> +static struct platform_driver panel_dpi_driver = {
> +	.probe = panel_dpi_probe,
> +	.remove = panel_dpi_remove,
> +	.driver = {
> +		.name = "panel_dpi",
> +		.owner = THIS_MODULE,
> +		.pm = &panel_dpi_dev_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(panel_dpi_driver);
> +
> +MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
> +MODULE_DESCRIPTION("DPI Display Panel");
> +MODULE_LICENSE("GPL");
> diff --git a/include/video/panel-dpi.h b/include/video/panel-dpi.h
> new file mode 100644
> index 0000000..0547b4a
> --- /dev/null
> +++ b/include/video/panel-dpi.h
> @@ -0,0 +1,24 @@
> +/*
> + * DPI Display Panel
> + *
> + * Copyright (C) 2012 Renesas Solutions Corp.
> + *
> + * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __PANEL_DPI_H__
> +#define __PANEL_DPI_H__
> +
> +#include <linux/videomode.h>
> +
> +struct panel_dpi_platform_data {
> +	unsigned long width;		/* Panel width in mm */
> +	unsigned long height;		/* Panel height in mm */
> +	const struct videomode *mode;
> +};
> +
> +#endif /* __PANEL_DPI_H__ */

From: Philipp Zabel <p.zabel@pengutronix.de>
Date: Thu, 29 Nov 2012 19:18:30 +0100
Subject: [PATCH] video: panel: Add device tree support to the DPI panel
 driver

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/video/display/panel-dpi.c |   56 ++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/video/display/panel-dpi.c b/drivers/video/display/panel-dpi.c
index c56197a..5a7dd8e 100644
--- a/drivers/video/display/panel-dpi.c
+++ b/drivers/video/display/panel-dpi.c
@@ -14,6 +14,8 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_videomode.h>
 
 #include <video/display.h>
 #include <video/panel-dpi.h>
@@ -98,20 +100,60 @@ static int panel_dpi_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devinit panel_dpi_probe(struct platform_device *pdev)
+static int __devinit panel_dpi_parse_dt(struct device *dev,
+					struct panel_dpi *panel)
 {
-	const struct panel_dpi_platform_data *pdata = pdev->dev.platform_data;
-	struct panel_dpi *panel;
+	struct device_node *np = dev->of_node;
+	struct panel_dpi_platform_data *pdata;
+	struct videomode *vm;
+	u32 width, height;
 	int ret;
 
+	if (!np)
+		return -ENODEV;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (pdata == NULL)
+		return -ENOMEM;
+
+	vm = devm_kzalloc(dev, sizeof(*vm), GFP_KERNEL);
+	if (vm == NULL)
+		return -ENOMEM;
+
+	ret = of_get_videomode(np, vm, 0);
+	if (ret < 0)
 		return -ENODEV;
 
+	of_property_read_u32(np, "width", &width);
+	of_property_read_u32(np, "height", &height);
+
+	pdata->mode = vm;
+	pdata->width = width;
+	pdata->height = height;
+	panel->pdata = pdata;
+
+	return 0;
+}
+
+static int __devinit panel_dpi_probe(struct platform_device *pdev)
+{
+	const struct panel_dpi_platform_data *pdata = pdev->dev.platform_data;
+	struct panel_dpi *panel;
+	int ret;
+
 	panel = kzalloc(sizeof(*panel), GFP_KERNEL);
 	if (panel == NULL)
 		return -ENOMEM;
 
-	panel->pdata = pdata;
+	if (pdata) {
+		panel->pdata = pdata;
+	} else {
+		ret = panel_dpi_parse_dt(&pdev->dev, panel);
+		if (ret < 0) {
+			kfree(panel);
+			return ret;
+		}
+	}
 	panel->entity.dev = &pdev->dev;
 	panel->entity.release = panel_dpi_release;
 	panel->entity.ops.ctrl = &panel_dpi_control_ops;
@@ -130,11 +172,17 @@ static int __devinit panel_dpi_probe(struct platform_device *pdev)
 static const struct dev_pm_ops panel_dpi_dev_pm_ops = {
 };
 
+static const struct of_device_id panel_dpi_dt_ids[] = {
+	{ .compatible = "dpi-panel", },
+	{ }
+};
+
 static struct platform_driver panel_dpi_driver = {
 	.probe = panel_dpi_probe,
 	.remove = panel_dpi_remove,
 	.driver = {
 		.name = "panel_dpi",
+		.of_match_table = panel_dpi_dt_ids,
 		.owner = THIS_MODULE,
 		.pm = &panel_dpi_dev_pm_ops,
 	},
-- 
1.7.10.4

regards
Philipp

