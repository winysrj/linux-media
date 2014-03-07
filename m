Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57796 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaCHFa0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Mar 2014 00:30:26 -0500
Received: by mail-wg0-f46.google.com with SMTP id z12so6211822wgg.17
        for <linux-media@vger.kernel.org>; Fri, 07 Mar 2014 21:30:25 -0800 (PST)
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 5/8] [media] of: move common endpoint parsing to drivers/of
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
In-Reply-To: <1394011242-16783-6-git-send-email-p.zabel@pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> < 1394011242-16783-6-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 07 Mar 2014 18:32:00 +0000
Message-Id: <20140307183200.9C9E8C40C5C@trevor.secretlab.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed,  5 Mar 2014 10:20:39 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> This patch adds a new struct of_endpoint which is then embedded in struct
> v4l2_of_endpoint and contains the endpoint properties that are not V4L2
> (or even media) specific: the port number, endpoint id, local device tree
> node and remote endpoint phandle. of_graph_parse_endpoint parses those
> properties and is used by v4l2_of_parse_endpoint, which just adds the
> V4L2 MBUS information to the containing v4l2_of_endpoint structure.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Seems okay.

Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
> Changes since v5:
>  - Fixed documentation comment for of_graph_parse_endpoint
> ---
>  drivers/media/platform/exynos4-is/media-dev.c | 10 +++++-----
>  drivers/media/platform/exynos4-is/mipi-csis.c |  2 +-
>  drivers/media/v4l2-core/v4l2-of.c             | 16 +++------------
>  drivers/of/base.c                             | 28 +++++++++++++++++++++++++++
>  include/linux/of_graph.h                      | 20 +++++++++++++++++++
>  include/media/v4l2-of.h                       |  8 ++------
>  6 files changed, 59 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index d0f82da..04d6ecd 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -469,10 +469,10 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
>  		return 0;
>  
>  	v4l2_of_parse_endpoint(ep, &endpoint);
> -	if (WARN_ON(endpoint.port == 0) || index >= FIMC_MAX_SENSORS)
> +	if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS)
>  		return -EINVAL;
>  
> -	pd->mux_id = (endpoint.port - 1) & 0x1;
> +	pd->mux_id = (endpoint.base.port - 1) & 0x1;
>  
>  	rem = of_graph_get_remote_port_parent(ep);
>  	of_node_put(ep);
> @@ -494,13 +494,13 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
>  		return -EINVAL;
>  	}
>  
> -	if (fimc_input_is_parallel(endpoint.port)) {
> +	if (fimc_input_is_parallel(endpoint.base.port)) {
>  		if (endpoint.bus_type == V4L2_MBUS_PARALLEL)
>  			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_601;
>  		else
>  			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_656;
>  		pd->flags = endpoint.bus.parallel.flags;
> -	} else if (fimc_input_is_mipi_csi(endpoint.port)) {
> +	} else if (fimc_input_is_mipi_csi(endpoint.base.port)) {
>  		/*
>  		 * MIPI CSI-2: only input mux selection and
>  		 * the sensor's clock frequency is needed.
> @@ -508,7 +508,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
>  		pd->sensor_bus_type = FIMC_BUS_TYPE_MIPI_CSI2;
>  	} else {
>  		v4l2_err(&fmd->v4l2_dev, "Wrong port id (%u) at node %s\n",
> -			 endpoint.port, rem->full_name);
> +			 endpoint.base.port, rem->full_name);
>  	}
>  	/*
>  	 * For FIMC-IS handled sensors, that are placed under i2c-isp device
> diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
> index fd1ae65..3678ba5 100644
> --- a/drivers/media/platform/exynos4-is/mipi-csis.c
> +++ b/drivers/media/platform/exynos4-is/mipi-csis.c
> @@ -772,7 +772,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
>  	/* Get port node and validate MIPI-CSI channel id. */
>  	v4l2_of_parse_endpoint(node, &endpoint);
>  
> -	state->index = endpoint.port - FIMC_INPUT_MIPI_CSI2_0;
> +	state->index = endpoint.base.port - FIMC_INPUT_MIPI_CSI2_0;
>  	if (state->index < 0 || state->index >= CSIS_MAX_ENTITIES)
>  		return -ENXIO;
>  
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index f919db3..b4ed9a9 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -127,17 +127,9 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>  int v4l2_of_parse_endpoint(const struct device_node *node,
>  			   struct v4l2_of_endpoint *endpoint)
>  {
> -	struct device_node *port_node = of_get_parent(node);
> -
> -	memset(endpoint, 0, offsetof(struct v4l2_of_endpoint, head));
> -
> -	endpoint->local_node = node;
> -	/*
> -	 * It doesn't matter whether the two calls below succeed.
> -	 * If they don't then the default value 0 is used.
> -	 */
> -	of_property_read_u32(port_node, "reg", &endpoint->port);
> -	of_property_read_u32(node, "reg", &endpoint->id);
> +	of_graph_parse_endpoint(node, &endpoint->base);
> +	endpoint->bus_type = 0;
> +	memset(&endpoint->bus, 0, sizeof(endpoint->bus));
>  
>  	v4l2_of_parse_csi_bus(node, endpoint);
>  	/*
> @@ -147,8 +139,6 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
>  	if (endpoint->bus.mipi_csi2.flags == 0)
>  		v4l2_of_parse_parallel_bus(node, endpoint);
>  
> -	of_node_put(port_node);
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL(v4l2_of_parse_endpoint);
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index a8e47d3..715144af 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1985,6 +1985,34 @@ struct device_node *of_find_next_cache_node(const struct device_node *np)
>  }
>  
>  /**
> + * of_graph_parse_endpoint() - parse common endpoint node properties
> + * @node: pointer to endpoint device_node
> + * @endpoint: pointer to the OF endpoint data structure
> + *
> + * The caller should hold a reference to @node.
> + */
> +int of_graph_parse_endpoint(const struct device_node *node,
> +			    struct of_endpoint *endpoint)
> +{
> +	struct device_node *port_node = of_get_parent(node);
> +
> +	memset(endpoint, 0, sizeof(*endpoint));
> +
> +	endpoint->local_node = node;
> +	/*
> +	 * It doesn't matter whether the two calls below succeed.
> +	 * If they don't then the default value 0 is used.
> +	 */
> +	of_property_read_u32(port_node, "reg", &endpoint->port);
> +	of_property_read_u32(node, "reg", &endpoint->id);
> +
> +	of_node_put(port_node);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(of_graph_parse_endpoint);
> +
> +/**
>   * of_graph_get_next_endpoint() - get next endpoint node
>   * @parent: pointer to the parent device node
>   * @prev: previous endpoint node, or NULL to get first
> diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
> index 3bbeb60..2b233db 100644
> --- a/include/linux/of_graph.h
> +++ b/include/linux/of_graph.h
> @@ -14,7 +14,21 @@
>  #ifndef __LINUX_OF_GRAPH_H
>  #define __LINUX_OF_GRAPH_H
>  
> +/**
> + * struct of_endpoint - the OF graph endpoint data structure
> + * @port: identifier (value of reg property) of a port this endpoint belongs to
> + * @id: identifier (value of reg property) of this endpoint
> + * @local_node: pointer to device_node of this endpoint
> + */
> +struct of_endpoint {
> +	unsigned int port;
> +	unsigned int id;
> +	const struct device_node *local_node;
> +};
> +
>  #ifdef CONFIG_OF
> +int of_graph_parse_endpoint(const struct device_node *node,
> +				struct of_endpoint *endpoint);
>  struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
>  					struct device_node *previous);
>  struct device_node *of_graph_get_remote_port_parent(
> @@ -22,6 +36,12 @@ struct device_node *of_graph_get_remote_port_parent(
>  struct device_node *of_graph_get_remote_port(const struct device_node *node);
>  #else
>  
> +static inline int of_graph_parse_endpoint(const struct device_node *node,
> +					struct of_endpoint *endpoint);
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline struct device_node *of_graph_get_next_endpoint(
>  					const struct device_node *parent,
>  					struct device_node *previous)
> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index 3a49735..70fa7b7 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -51,17 +51,13 @@ struct v4l2_of_bus_parallel {
>  
>  /**
>   * struct v4l2_of_endpoint - the endpoint data structure
> - * @port: identifier (value of reg property) of a port this endpoint belongs to
> - * @id: identifier (value of reg property) of this endpoint
> - * @local_node: pointer to device_node of this endpoint
> + * @base: struct of_endpoint containing port, id, and local of_node
>   * @bus_type: bus type
>   * @bus: bus configuration data structure
>   * @head: list head for this structure
>   */
>  struct v4l2_of_endpoint {
> -	unsigned int port;
> -	unsigned int id;
> -	const struct device_node *local_node;
> +	struct of_endpoint base;
>  	enum v4l2_mbus_type bus_type;
>  	union {
>  		struct v4l2_of_bus_parallel parallel;
> -- 
> 1.9.0.rc3
> 

