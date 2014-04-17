Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40550 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDQOoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:44:46 -0400
Message-id: <534FE8D8.3070700@samsung.com>
Date: Thu, 17 Apr 2014 16:44:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 47/49] adv7604: Add endpoint properties to DT bindings
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1397744000-23967-48-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1397744000-23967-48-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/04/14 16:13, Laurent Pinchart wrote:
> Add support for the hsync-active, vsync-active and pclk-sample
> properties to the DT bindings and control BT.656 mode implicitly.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks, the patch looks good to me.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  .../devicetree/bindings/media/i2c/adv7604.txt      | 13 +++++++++
>  drivers/media/i2c/adv7604.c                        | 34 ++++++++++++++++++++--
>  2 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> index 2efb48f..c27cede 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -33,6 +33,19 @@ Optional Properties:
>  
>    - reset-gpios: Reference to the GPIO connected to the device's reset pin.
>  
> +Optional Endpoint Properties:
> +
> +  The following three properties are defined in video-interfaces.txt and are
> +  valid for source endpoints only.
> +
> +  - hsync-active: Horizontal synchronization polarity. Defaults to active low.
> +  - vsync-active: Vertical synchronization polarity. Defaults to active low.
> +  - pclk-sample: Pixel clock polarity. Defaults to output on the falling edge.
> +
> +  If none of hsync-active, vsync-active and pclk-sample is specified the
> +  endpoint will use embedded BT.656 synchronization.
> +
> +
>  Example:
>  
>  	hdmi_receiver@4c {
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index fd0c646..63f036f 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -41,6 +41,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-of.h>
>  
>  static int debug;
>  module_param(debug, int, 0644);
> @@ -2679,6 +2680,37 @@ MODULE_DEVICE_TABLE(of, adv7604_of_id);
>  
>  static int adv7604_parse_dt(struct adv7604_state *state)
>  {
> +	struct v4l2_of_endpoint bus_cfg;
> +	struct device_node *endpoint;
> +	struct device_node *np;
> +	unsigned int flags;
> +
> +	np = state->i2c_clients[ADV7604_PAGE_IO]->dev.of_node;
> +
> +	/* Parse the endpoint. */
> +	endpoint = of_graph_get_next_endpoint(np, NULL);
> +	if (!endpoint)
> +		return -EINVAL;
> +
> +	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> +	of_node_put(endpoint);
> +
> +	flags = bus_cfg.bus.parallel.flags;
> +
> +	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +		state->pdata.inv_hs_pol = 1;
> +
> +	if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +		state->pdata.inv_vs_pol = 1;
> +
> +	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> +		state->pdata.inv_llc_pol = 1;
> +
> +	if (bus_cfg.bus_type == V4L2_MBUS_BT656) {
> +		state->pdata.insert_av_codes = 1;
> +		state->pdata.op_656_range = 1;
> +	}
> +
>  	/* Disable the interrupt for now as no DT-based board uses it. */
>  	state->pdata.int1_config = ADV7604_INT1_CONFIG_DISABLED;
>  
> @@ -2701,9 +2733,7 @@ static int adv7604_parse_dt(struct adv7604_state *state)
>  	state->pdata.disable_cable_det_rst = 0;
>  	state->pdata.default_input = -1;
>  	state->pdata.blank_data = 1;
> -	state->pdata.op_656_range = 1;
>  	state->pdata.alt_data_sat = 1;
> -	state->pdata.insert_av_codes = 1;
>  	state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
>  	state->pdata.bus_order = ADV7604_BUS_ORDER_RGB;
>  

-- 
Regards,
Sylwester
