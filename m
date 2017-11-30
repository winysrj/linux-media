Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56125 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753824AbdK3SGV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 13:06:21 -0500
Subject: Re: [PATCH v8 28/28] rcar-vin: enable support for r8a77970
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
 <20171129194342.26239-29-niklas.soderlund+renesas@ragnatech.se>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <849882b9-c7d1-0a04-29b1-2a11ffa6faf6@ideasonboard.com>
Date: Thu, 30 Nov 2017 18:06:16 +0000
MIME-Version: 1.0
In-Reply-To: <20171129194342.26239-29-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 29/11/17 19:43, Niklas Söderlund wrote:
> Add the SoC specific information for Renesas r8a77970.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Not going through the details on this one, as I don't know where to start yet
other than the cursory chip, width, and height all look correct ... but as this
has helped me capture video this evening this patch can at least have:

Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  .../devicetree/bindings/media/rcar_vin.txt         |  1 +
>  drivers/media/platform/rcar-vin/rcar-core.c        | 40 ++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 314743532bbb4523..6b98f8a3398fa493 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -21,6 +21,7 @@ on Gen3 to a CSI-2 receiver.
>     - "renesas,vin-r8a7794" for the R8A7794 device
>     - "renesas,vin-r8a7795" for the R8A7795 device
>     - "renesas,vin-r8a7796" for the R8A7796 device
> +   - "renesas,vin-r8a77970" for the R8A77970 device
>     - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
>       device.
>     - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 62eb89b36fbb2ee1..bbdf36b5c3c8178d 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1145,6 +1145,42 @@ static const struct rvin_info rcar_info_r8a7796 = {
>  	},
>  };
>  
> +static const struct rvin_info rcar_info_r8a77970 = {
> +	.chip = RCAR_GEN3,
> +	.use_mc = true,
> +	.max_width = 4096,
> +	.max_height = 4096,
> +
> +	.num_chsels = 5,
> +	.chsels = {
> +		{
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +		}, {
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +		}, {
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 2 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +		}, {
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 3 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +		},
> +	},
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] = {
>  	{
>  		.compatible = "renesas,vin-r8a7778",
> @@ -1182,6 +1218,10 @@ static const struct of_device_id rvin_of_id_table[] = {
>  		.compatible = "renesas,vin-r8a7796",
>  		.data = &rcar_info_r8a7796,
>  	},
> +	{
> +		.compatible = "renesas,vin-r8a77970",
> +		.data = &rcar_info_r8a77970,
> +	},
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> 
