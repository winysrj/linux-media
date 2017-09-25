Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:43964 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934750AbdIYKr6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 06:47:58 -0400
Subject: Re: [PATCH v6 25/25] rcar-vin: enable support for r8a7796
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-26-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e36ddd1e-6809-fc09-9b1c-a0b5c85e5c4a@xs4all.nl>
Date: Mon, 25 Sep 2017 12:47:56 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-26-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> Add the SoC specific information for Renesas r8a7796.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  .../devicetree/bindings/media/rcar_vin.txt         |  1 +
>  drivers/media/platform/rcar-vin/rcar-core.c        | 64 ++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index be38ad89d71ad05d..767358f39512aa17 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -10,6 +10,7 @@ always slaves and support multiple input channels which can be either RGB,
>  YUVU, BT656 or CSI-2.
>  
>   - compatible: Must be one or more of the following
> +   - "renesas,vin-r8a7796" for the R8A7796 device
>     - "renesas,vin-r8a7795" for the R8A7795 device
>     - "renesas,vin-r8a7794" for the R8A7794 device
>     - "renesas,vin-r8a7793" for the R8A7793 device
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 58d903ab9fb83faf..e01edd5f5925d26c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1116,7 +1116,71 @@ static const struct rvin_info rcar_info_r8a7795es1 = {
>  	},
>  };
>  
> +static const struct rvin_info rcar_info_r8a7796 = {
> +	.chip = RCAR_GEN3,
> +	.use_mc = true,
> +	.max_width = 4096,
> +	.max_height = 4096,
> +
> +	.num_chsels = 5,
> +	.chsels = {
> +		{
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +		}, {
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +		}, {
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 2 },
> +			{ .csi = RVIN_CSI20, .chan = 2 },
> +		}, {
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_NC, .chan = 1 },
> +			{ .csi = RVIN_CSI40, .chan = 3 },
> +			{ .csi = RVIN_CSI20, .chan = 3 },
> +		}, {
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +		}, {
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +		}, {
> +			{ .csi = RVIN_NC, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 2 },
> +			{ .csi = RVIN_CSI20, .chan = 2 },
> +		}, {
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_NC, .chan = 1 },
> +			{ .csi = RVIN_CSI40, .chan = 3 },
> +			{ .csi = RVIN_CSI20, .chan = 3 },
> +		},
> +	},
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] = {
> +	{
> +		.compatible = "renesas,vin-r8a7796",
> +		.data = &rcar_info_r8a7796,
> +	},
>  	{
>  		.compatible = "renesas,vin-r8a7795",
>  		.data = &rcar_info_r8a7795,
> 
