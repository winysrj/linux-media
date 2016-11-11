Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51976 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932857AbcKKPgW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 10:36:22 -0500
Subject: Re: [RFC PATCH 6/6] [media] davinci: vpif_capture: get subdevs from
 DT
To: Kevin Hilman <khilman@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20161025235536.7342-1-khilman@baylibre.com>
 <20161025235536.7342-7-khilman@baylibre.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?Q?Bartosz_Go=c5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        linux-arm-kernel@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dad6e38b-093b-bd36-3e0d-a0c10bddea58@xs4all.nl>
Date: Fri, 11 Nov 2016 16:36:16 +0100
MIME-Version: 1.0
In-Reply-To: <20161025235536.7342-7-khilman@baylibre.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/26/2016 01:55 AM, Kevin Hilman wrote:
> First pass at getting subdevs from DT ports and endpoints.
> 
> The _get_pdata() function was larely inspired by (i.e. stolen from)
> am437x-vpfe.c
> 
> Questions:
> - Legacy board file passes subdev input & output routes via pdata
>   (e.g. tvp514x svideo or composite selection.)  How is this supposed
>   to be done via DT?

We have plans to model connectors as well in the device tree, but no
implementation exists yet. I think Laurent has some code in progress for this,
but I may be mistaken.

Anyway, hard-coding it like you do now is for now the only way.

	Hans

> 
> Not-Yet-Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 132 +++++++++++++++++++++++++-
>  include/media/davinci/vpif_types.h            |   9 +-
>  2 files changed, 134 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index becc3e63b472..df2af5cda37a 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -26,6 +26,8 @@
>  #include <linux/slab.h>
>  
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-of.h>
> +#include <media/i2c/tvp514x.h> /* FIXME: how to pass the INPUT_* OUTPUT* fields? */
>  
>  #include "vpif.h"
>  #include "vpif_capture.h"
> @@ -651,6 +653,10 @@ static int vpif_input_to_subdev(
>  
>  	vpif_dbg(2, debug, "vpif_input_to_subdev\n");
>  
> +	if (!chan_cfg)
> +		return -1;
> +	if (input_index >= chan_cfg->input_count)
> +		return -1;
>  	subdev_name = chan_cfg->inputs[input_index].subdev_name;
>  	if (subdev_name == NULL)
>  		return -1;
> @@ -658,7 +664,7 @@ static int vpif_input_to_subdev(
>  	/* loop through the sub device list to get the sub device info */
>  	for (i = 0; i < vpif_cfg->subdev_count; i++) {
>  		subdev_info = &vpif_cfg->subdev_info[i];
> -		if (!strcmp(subdev_info->name, subdev_name))
> +		if (subdev_info && !strcmp(subdev_info->name, subdev_name))
>  			return i;
>  	}
>  	return -1;
> @@ -1328,13 +1334,25 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
>  {
>  	int i;
>  
> +	for (i = 0; i < vpif_obj.config->asd_sizes[0]; i++) {
> +		const struct device_node *node = vpif_obj.config->asd[i]->match.of.node;
> +
> +		if (node == subdev->of_node) {
> +			vpif_obj.sd[i] = subdev;
> +			vpif_obj.config->chan_config->inputs[i].subdev_name = subdev->of_node->full_name;
> +			vpif_dbg(2, debug, "%s: setting input %d subdev_name = %s\n", __func__,
> +				 i, subdev->of_node->full_name);
> +			return 0;
> +		}
> +	}
> +
>  	for (i = 0; i < vpif_obj.config->subdev_count; i++)
>  		if (!strcmp(vpif_obj.config->subdev_info[i].name,
>  			    subdev->name)) {
>  			vpif_obj.sd[i] = subdev;
>  			return 0;
>  		}
> -
> +	
>  	return -EINVAL;
>  }
>  
> @@ -1423,6 +1441,113 @@ static int vpif_async_complete(struct v4l2_async_notifier *notifier)
>  	return vpif_probe_complete();
>  }
>  
> +static struct vpif_capture_config *
> +vpif_capture_get_pdata(struct platform_device *pdev)
> +{
> +	struct device_node *endpoint = NULL;
> +	struct v4l2_of_endpoint bus_cfg;
> +	struct vpif_capture_config *pdata;
> +	struct vpif_subdev_info *sdinfo;
> +	struct vpif_capture_chan_config *chan;
> +	unsigned int i;
> +
> +	dev_dbg(&pdev->dev, "vpif_get_pdata\n");
> +
> +	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
> +		return pdev->dev.platform_data;
> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return NULL;
> +	pdata->subdev_info = devm_kzalloc(&pdev->dev,
> +					  sizeof(*pdata->subdev_info) *
> +					  VPIF_CAPTURE_MAX_CHANNELS, GFP_KERNEL);
> +	if (!pdata->subdev_info)
> +		return NULL;
> +	dev_dbg(&pdev->dev, "%s\n", __func__);
> +
> +	for (i = 0; ; i++) {
> +		struct device_node *rem;
> +		unsigned int flags;
> +		int err;
> +		
> +		endpoint = of_graph_get_next_endpoint(pdev->dev.of_node,
> +						      endpoint);
> +		if (!endpoint)
> +			break;
> +
> +		dev_dbg(&pdev->dev, "found endpoint %s, %s\n",
> +			endpoint->name, endpoint->full_name);
> +
> +		sdinfo = &pdata->subdev_info[i];
> +		chan = &pdata->chan_config[i];
> +		chan->inputs = devm_kzalloc(&pdev->dev,
> +					    sizeof(*chan->inputs) *
> +					    VPIF_DISPLAY_MAX_CHANNELS,
> +					    GFP_KERNEL);
> +		
> +		/* sdinfo->name = devm_kzalloc(&pdev->dev, 16, GFP_KERNEL); */
> +		/* snprintf(sdinfo->name, 16, "VPIF input %d", i); */
> +		chan->input_count++;
> +		chan->inputs[i].input.type = V4L2_INPUT_TYPE_CAMERA;
> +		chan->inputs[i].input.std = V4L2_STD_ALL;
> +		chan->inputs[i].input.capabilities = V4L2_IN_CAP_STD;
> +		
> +		/* FIXME: need a new property? ch0:composite ch1: s-video */
> +		if (i == 0)
> +			chan->inputs[i].input_route = INPUT_CVBS_VI2B;
> +		else
> +			chan->inputs[i].input_route = INPUT_SVIDEO_VI2C_VI1C;
> +		chan->inputs[i].output_route = OUTPUT_10BIT_422_EMBEDDED_SYNC;
> +				
> +		err = v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> +		if (err) {
> +			dev_err(&pdev->dev, "Could not parse the endpoint\n");
> +			goto done;
> +		}
> +		dev_dbg(&pdev->dev, "Endpoint %s, bus_width = %d\n",
> +			endpoint->full_name, bus_cfg.bus.parallel.bus_width);
> +		flags = bus_cfg.bus.parallel.flags;
> +
> +		if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +			chan->vpif_if.hd_pol = 1;
> +
> +		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +			chan->vpif_if.vd_pol = 1;
> +
> +		chan->vpif_if.if_type = VPIF_IF_BT656;
> +		rem = of_graph_get_remote_port_parent(endpoint);
> +		if (!rem) {
> +			dev_dbg(&pdev->dev, "Remote device at %s not found\n",
> +				endpoint->full_name);
> +			goto done;
> +		}
> +
> +		dev_dbg(&pdev->dev, "Remote device %s, %s found\n", rem->name, rem->full_name);
> +		sdinfo->name = rem->full_name;
> +
> +		pdata->asd[i] = devm_kzalloc(&pdev->dev,
> +					     sizeof(struct v4l2_async_subdev),
> +					     GFP_KERNEL);
> +		if (!pdata->asd[i]) {
> +			of_node_put(rem);
> +			pdata = NULL;
> +			goto done;
> +		}
> +
> +		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_OF;
> +		pdata->asd[i]->match.of.node = rem;
> +		of_node_put(rem);
> +	}
> +
> +done:
> +	pdata->asd_sizes[0] = i;
> +	pdata->subdev_count = i;
> +	pdata->card_name = "DA850/OMAP-L138 Video Capture";
> +
> +	return pdata;
> +}
> +
>  /**
>   * vpif_probe : This function probes the vpif capture driver
>   * @pdev: platform device pointer
> @@ -1439,6 +1564,7 @@ static __init int vpif_probe(struct platform_device *pdev)
>  	int res_idx = 0;
>  	int i, err;
>  
> +	pdev->dev.platform_data = vpif_capture_get_pdata(pdev);;
>  	if (!pdev->dev.platform_data) {
>  		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
>  		return -EINVAL;
> @@ -1481,7 +1607,7 @@ static __init int vpif_probe(struct platform_device *pdev)
>  		goto vpif_unregister;
>  	}
>  
> -	if (!vpif_obj.config->asd_sizes) {
> +	if (!vpif_obj.config->asd_sizes[0]) {
>  		i2c_adap = i2c_get_adapter(1);
>  		for (i = 0; i < subdev_count; i++) {
>  			subdevdata = &vpif_obj.config->subdev_info[i];
> diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
> index 3cb1704a0650..4ee3b41975db 100644
> --- a/include/media/davinci/vpif_types.h
> +++ b/include/media/davinci/vpif_types.h
> @@ -65,14 +65,14 @@ struct vpif_display_config {
>  
>  struct vpif_input {
>  	struct v4l2_input input;
> -	const char *subdev_name;
> +	char *subdev_name;
>  	u32 input_route;
>  	u32 output_route;
>  };
>  
>  struct vpif_capture_chan_config {
>  	struct vpif_interface vpif_if;
> -	const struct vpif_input *inputs;
> +	struct vpif_input *inputs;
>  	int input_count;
>  };
>  
> @@ -83,7 +83,8 @@ struct vpif_capture_config {
>  	struct vpif_subdev_info *subdev_info;
>  	int subdev_count;
>  	const char *card_name;
> -	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
> -	int *asd_sizes;		/* 0-terminated array of asd group sizes */
> +
> +	struct v4l2_async_subdev *asd[VPIF_CAPTURE_MAX_CHANNELS];
> +	int asd_sizes[VPIF_CAPTURE_MAX_CHANNELS];
>  };
>  #endif /* _VPIF_TYPES_H */
> 
