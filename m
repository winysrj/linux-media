Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47165 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbbFLG3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 02:29:22 -0400
Message-ID: <557A7C36.9050102@xs4all.nl>
Date: Fri, 12 Jun 2015 08:29:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 06/15] media: adv7604: ability to read default input port
 from DT
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk> <1433340002-1691-7-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-7-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 03:59 PM, William Towle wrote:
> From: Ian Molton <ian.molton@codethink.co.uk>
> 
> Adds support to the adv7604 driver for specifying the default input
> port in the Device tree. If no value is provided, the driver will be
> unable to select an input without help from userspace.
> 
> Tested-by: William Towle <william.towle@codethink.co.uk>
> Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  Documentation/devicetree/bindings/media/i2c/adv7604.txt |    3 +++
>  drivers/media/i2c/adv7604.c                             |    8 +++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> index 7eafdbc..8337f75 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -47,6 +47,7 @@ Optional Endpoint Properties:
>    If none of hsync-active, vsync-active and pclk-sample is specified the
>    endpoint will use embedded BT.656 synchronization.
>  
> +  - default-input: Select which input is selected after reset.
>  
>  Example:
>  
> @@ -60,6 +61,8 @@ Example:
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  
> +		default-input = <0>;
> +
>  		port@0 {
>  			reg = <0>;
>  		};
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 16646517..5b6ac8e 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2745,6 +2745,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
>  	struct device_node *endpoint;
>  	struct device_node *np;
>  	unsigned int flags;
> +	u32 v;
>  
>  	np = state->i2c_clients[ADV76XX_PAGE_IO]->dev.of_node;
>  
> @@ -2754,6 +2755,12 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
>  		return -EINVAL;
>  
>  	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> +
> +	if (!of_property_read_u32(endpoint, "default-input", &v))
> +		state->pdata.default_input = v;
> +	else
> +		state->pdata.default_input = -1;
> +
>  	of_node_put(endpoint);
>  
>  	flags = bus_cfg.bus.parallel.flags;
> @@ -2792,7 +2799,6 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
>  	/* Hardcode the remaining platform data fields. */
>  	state->pdata.disable_pwrdnb = 0;
>  	state->pdata.disable_cable_det_rst = 0;
> -	state->pdata.default_input = -1;
>  	state->pdata.blank_data = 1;
>  	state->pdata.alt_data_sat = 1;
>  	state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
> 

