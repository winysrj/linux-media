Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39606 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbeHFUVO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 16:21:14 -0400
Received: by mail-lj1-f194.google.com with SMTP id l15-v6so11342042lji.6
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 11:10:58 -0700 (PDT)
Date: Mon, 6 Aug 2018 20:10:56 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] rcar-vin: add R8A77980 support
Message-ID: <20180806181056.GE1635@bigcity.dyn.berto.se>
References: <e7afb623-799b-17b6-cb6b-8fd839ea660a@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7afb623-799b-17b6-cb6b-8fd839ea660a@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

Thanks for your work.

On 2018-08-06 20:45:01 +0300, Sergei Shtylyov wrote:
> Add the R8A77980 SoC support to the R-Car VIN driver.
> 
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.
> 
>  Documentation/devicetree/bindings/media/rcar_vin.txt |    1 
>  drivers/media/platform/rcar-vin/rcar-core.c          |   32 +++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> Index: media_tree/Documentation/devicetree/bindings/media/rcar_vin.txt
> ===================================================================
> --- media_tree.orig/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ media_tree/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -23,6 +23,7 @@ on Gen3 platforms to a CSI-2 receiver.
>     - "renesas,vin-r8a7796" for the R8A7796 device
>     - "renesas,vin-r8a77965" for the R8A77965 device
>     - "renesas,vin-r8a77970" for the R8A77970 device
> +   - "renesas,vin-r8a77980" for the R8A77980 device
>     - "renesas,vin-r8a77995" for the R8A77995 device
>     - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
>       device.
> Index: media_tree/drivers/media/platform/rcar-vin/rcar-core.c
> ===================================================================
> --- media_tree.orig/drivers/media/platform/rcar-vin/rcar-core.c
> +++ media_tree/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1097,6 +1097,34 @@ static const struct rvin_info rcar_info_
>  	.routes = rcar_info_r8a77995_routes,
>  };
>  
> +static const struct rvin_group_route rcar_info_r8a77980_routes[] = {
> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 0, .mask = BIT(0) | BIT(3) },
> +	{ .csi = RVIN_CSI40, .channel = 1, .vin = 0, .mask = BIT(2) },
> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 1, .mask = BIT(2) },
> +	{ .csi = RVIN_CSI40, .channel = 1, .vin = 1, .mask = BIT(1) | BIT(3) },
> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 2, .mask = BIT(1) },
> +	{ .csi = RVIN_CSI40, .channel = 2, .vin = 2, .mask = BIT(3) },
> +	{ .csi = RVIN_CSI40, .channel = 1, .vin = 3, .mask = BIT(0) },
> +	{ .csi = RVIN_CSI40, .channel = 3, .vin = 3, .mask = BIT(3) },
> +	{ .csi = RVIN_CSI41, .channel = 0, .vin = 4, .mask = BIT(0) | BIT(3) },
> +	{ .csi = RVIN_CSI41, .channel = 1, .vin = 4, .mask = BIT(2) },
> +	{ .csi = RVIN_CSI41, .channel = 0, .vin = 5, .mask = BIT(2) },
> +	{ .csi = RVIN_CSI41, .channel = 1, .vin = 5, .mask = BIT(1) | BIT(3) },
> +	{ .csi = RVIN_CSI41, .channel = 0, .vin = 6, .mask = BIT(1) },
> +	{ .csi = RVIN_CSI41, .channel = 2, .vin = 6, .mask = BIT(3) },
> +	{ .csi = RVIN_CSI41, .channel = 1, .vin = 7, .mask = BIT(0) },
> +	{ .csi = RVIN_CSI41, .channel = 3, .vin = 7, .mask = BIT(3) },
> +	{ /* Sentinel */ }
> +};
> +
> +static const struct rvin_info rcar_info_r8a77980 = {
> +	.model = RCAR_GEN3,
> +	.use_mc = true,
> +	.max_width = 4096,
> +	.max_height = 4096,
> +	.routes = rcar_info_r8a77980_routes,
> +};
> +

Could you move this chunk so it fits the numerical sorting order of this 
part of the code? That is move the chunk between the r8a77970 and 
r8a77995 structs :-) With that fixed feel free to add

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

>  static const struct of_device_id rvin_of_id_table[] = {
>  	{
>  		.compatible = "renesas,vin-r8a7778",
> @@ -1143,6 +1171,10 @@ static const struct of_device_id rvin_of
>  		.data = &rcar_info_r8a77970,
>  	},
>  	{
> +		.compatible = "renesas,vin-r8a77980",
> +		.data = &rcar_info_r8a77980,
> +	},
> +	{
>  		.compatible = "renesas,vin-r8a77995",
>  		.data = &rcar_info_r8a77995,
>  	},

-- 
Regards,
Niklas Söderlund
