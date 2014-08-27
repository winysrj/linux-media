Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2914 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbaH0NDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 09:03:50 -0400
Message-ID: <53FDD718.3020202@xs4all.nl>
Date: Wed, 27 Aug 2014 15:03:20 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: jean-michel.hautbois@vodalys.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for definition of register maps in DT in
 ADV7604
References: <1409143986-13990-1-git-send-email-jean-michel.hautbois@vodalys.com>
In-Reply-To: <1409143986-13990-1-git-send-email-jean-michel.hautbois@vodalys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/27/14 14:53, jean-michel.hautbois@vodalys.com wrote:
> From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> 
> This patch adds support for DT parsing of register maps adresses.
> This allows multiple adv76xx devices on the same bus.
> 
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> ---
>  .../devicetree/bindings/media/i2c/adv7604.txt      | 12 ++++
>  drivers/media/i2c/adv7604.c                        | 71 ++++++++++++++++++----
>  2 files changed, 71 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> index c27cede..33881fb 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -32,6 +32,18 @@ The digital output port node must contain at least one endpoint.
>  Optional Properties:
>  
>    - reset-gpios: Reference to the GPIO connected to the device's reset pin.
> +  - adv7604-page-avlink: Programmed address for avlink register map
> +  - adv7604-page-cec: Programmed address for cec register map
> +  - adv7604-page-infoframe: Programmed address for infoframe register map
> +  - adv7604-page-esdp: Programmed address for esdp register map
> +  - adv7604-page-dpp: Programmed address for dpp register map
> +  - adv7604-page-afe: Programmed address for afe register map
> +  - adv7604-page-rep: Programmed address for rep register map
> +  - adv7604-page-edid: Programmed address for edid register map
> +  - adv7604-page-hdmi: Programmed address for hdmi register map
> +  - adv7604-page-test: Programmed address for test register map
> +  - adv7604-page-cp: Programmed address for cp register map
> +  - adv7604-page-vdp: Programmed address for vdp register map

Might adv7604-addr-avlink be a better name? Other than that it looks good
to me.

	Hans

>  
>  Optional Endpoint Properties:
>  
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index d4fa213..89a7034 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2718,18 +2718,65 @@ static int adv7604_parse_dt(struct adv7604_state *state)
>  	state->pdata.int1_config = ADV7604_INT1_CONFIG_DISABLED;
>  
>  	/* Use the default I2C addresses. */
> -	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_CEC] = 0x40;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME] = 0x3e;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] = 0x38;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_DPP] = 0x3c;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_AFE] = 0x26;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_REP] = 0x32;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_EDID] = 0x36;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_HDMI] = 0x34;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_TEST] = 0x30;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_CP] = 0x22;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_VDP] = 0x24;
> +	of_property_read_u32(np, "adv7604-page-avlink",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
> +
> +	of_property_read_u32(np, "adv7604-page-cec",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_CEC]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_CEC])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_CEC] = 0x40;
> +
> +	of_property_read_u32(np, "adv7604-page-infoframe",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME] = 0x3e;
> +
> +	of_property_read_u32(np, "adv7604-page-esdp",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_ESDP]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_ESDP])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] = 0x38;
> +
> +	of_property_read_u32(np, "adv7604-page-dpp",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_DPP]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_DPP])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_DPP] = 0x3c;
> +
> +	of_property_read_u32(np, "adv7604-page-afe",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_AFE]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_AFE])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_AFE] = 0x26;
> +
> +	of_property_read_u32(np, "adv7604-page-rep",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_REP]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_REP])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_REP] = 0x32;
> +
> +	of_property_read_u32(np, "adv7604-page-edid",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_EDID]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_EDID])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_EDID] = 0x36;
> +
> +	of_property_read_u32(np, "adv7604-page-hdmi",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_HDMI]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_HDMI])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_HDMI] = 0x34;
> +
> +	of_property_read_u32(np, "adv7604-page-test",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_TEST]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_TEST])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_TEST] = 0x30;
> +
> +	of_property_read_u32(np, "adv7604-page-cp",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_CP]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_CP])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_CP] = 0x22;
> +
> +	of_property_read_u32(np, "adv7604-page-vdp",
> +			&state->pdata.i2c_addresses[ADV7604_PAGE_VDP]);
> +	if (!state->pdata.i2c_addresses[ADV7604_PAGE_VDP])
> +		state->pdata.i2c_addresses[ADV7604_PAGE_VDP] = 0x24;
>  
>  	/* Hardcode the remaining platform data fields. */
>  	state->pdata.disable_pwrdnb = 0;
> 

