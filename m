Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54456 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbeIRPvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 11:51:38 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 1/3] i2c: adv748x: store number of CSI-2 lanes described
 in device tree
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <20180918014509.6394-2-niklas.soderlund+renesas@ragnatech.se>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <3a43804e-322c-a326-dd9a-c26dec5700b4@ideasonboard.com>
Date: Tue, 18 Sep 2018 11:19:39 +0100
MIME-Version: 1.0
In-Reply-To: <20180918014509.6394-2-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch,

On 18/09/18 02:45, Niklas Söderlund wrote:
> The adv748x CSI-2 transmitters TXA and TXB can use different number of
> lines to transmit data on. In order to be able configure the device
> correctly this information need to be parsed from device tree and stored
> in each TX private data structure.
> 
> TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.
> 

Am I right in assuming that it is the CSI device which specifies the
number of lanes in their DT?

Could we make this clear in the commit log (and possibly an extra
comment in the code). At first I was assuming we would have to declare
the number of lanes in the ADV748x TX DT node, but I don't think that's
the case.

> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 49 ++++++++++++++++++++++++
>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
>  2 files changed, 50 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 85c027bdcd56748d..a93f8ea89a228474 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -23,6 +23,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-ioctl.h>
>  
>  #include "adv748x.h"
> @@ -561,11 +562,54 @@ void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
>  	sd->entity.ops = &adv748x_media_ops;
>  }
>  
> +static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
> +				    unsigned int port,
> +				    struct device_node *ep)
> +{
> +	struct v4l2_fwnode_endpoint vep;
> +	unsigned int num_lanes;
> +	int ret;
> +
> +	if (port != ADV748X_PORT_TXA && port != ADV748X_PORT_TXB)
> +		return 0;
> +
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &vep);
> +	if (ret)
> +		return ret;
> +
> +	num_lanes = vep.bus.mipi_csi2.num_data_lanes;
> +

If I'm not mistaken we are parsing /someone elses/ DT node here (the CSI
receiver or such).

Is it now guaranteed on the mipi_csi2 bus to have the (correct) lanes
defined?

Do we need to fall back to some safe defaults at all (1 lane?) ?
Actually - perhaps there is no safe default. I guess if the lanes aren't
configured correctly we're not going to get a good signal at the other end.

> +	if (vep.base.port == ADV748X_PORT_TXA) {
> +		if (num_lanes != 1 && num_lanes != 2 && num_lanes != 4) {
> +			adv_err(state, "TXA: Invalid number (%d) of lanes\n",
> +				num_lanes);
> +			return -EINVAL;
> +		}
> +
> +		state->txa.num_lanes = num_lanes;
> +		adv_dbg(state, "TXA: using %d lanes\n", state->txa.num_lanes);
> +	}
> +
> +	if (vep.base.port == ADV748X_PORT_TXB) {
> +		if (num_lanes != 1) {
> +			adv_err(state, "TXB: Invalid number (%d) of lanes\n",
> +				num_lanes);
> +			return -EINVAL;
> +		}
> +
> +		state->txb.num_lanes = num_lanes;
> +		adv_dbg(state, "TXB: using %d lanes\n", state->txb.num_lanes);
> +	}
> +
> +	return 0;
> +}
> +
>  static int adv748x_parse_dt(struct adv748x_state *state)
>  {
>  	struct device_node *ep_np = NULL;
>  	struct of_endpoint ep;
>  	bool found = false;
> +	int ret;
>  
>  	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
>  		of_graph_parse_endpoint(ep_np, &ep);
> @@ -589,6 +633,11 @@ static int adv748x_parse_dt(struct adv748x_state *state)
>  		state->endpoints[ep.port] = ep_np;
>  
>  		found = true;
> +
> +		/* Store number of CSI-2 lanes used for TXA and TXB. */
> +		ret = adv748x_parse_csi2_lanes(state, ep.port, ep_np);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	return found ? 0 : -ENODEV;
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index c9016acaba34aff2..88ad06a3045c5427 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -78,6 +78,7 @@ struct adv748x_csi2 {
>  	struct adv748x_state *state;
>  	struct v4l2_mbus_framefmt format;
>  	unsigned int page;
> +	unsigned int num_lanes;
>  
>  	struct media_pad pads[ADV748X_CSI2_NR_PADS];
>  	struct v4l2_ctrl_handler ctrl_hdl;
> 

-- 
Regards
--
Kieran
