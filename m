Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61957 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900AbcAKVNk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 16:13:40 -0500
Date: Mon, 11 Jan 2016 22:13:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
cc: linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/3 v2] media: soc_camera: rcar_vin: Add rcar fallback
 compatibility string
In-Reply-To: <1452539418-28480-2-git-send-email-ykaneko0929@gmail.com>
Message-ID: <Pine.LNX.4.64.1601112210040.31467@axis700.grange>
References: <1452539418-28480-1-git-send-email-ykaneko0929@gmail.com>
 <1452539418-28480-2-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Kaneko-san,

On Tue, 12 Jan 2016, Yoshihiro Kaneko wrote:

> Add fallback compatibility string for R-Car Gen2 and Gen3, This is
> in keeping with the fallback scheme being adopted wherever appropriate
> for drivers for Renesas SoCs.
> 
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---

Have you seen this patch:

http://git.linuxtv.org/gliakhovetski/v4l-dvb.git/commit/?h=for-4.6-1&id=8e7825d38bbfcf8af8b0422c88f5e22701d89786

that I pushed yesterday? Is it wrong then? Do we have to cancel it, if 
Mauro hasn't pulled it yet? Or would you like to rebase and work on top of 
it?

Thanks
Guennadi

> 
> v2 [Yoshihiro Kaneko]
> * As suggested by Geert Uytterhoeven
>   drivers/media/platform/soc_camera/rcar_vin.c:
>     - The generic compatibility values are listed at the end of the
>       rcar_vin_of_table[].
> 
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 8 +++++++-
>  drivers/media/platform/soc_camera/rcar_vin.c         | 3 +++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 9dafe6b..c13ec5a 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -6,12 +6,18 @@ family of devices. The current blocks are always slaves and suppot one input
>  channel which can be either RGB, YUYV or BT656.
>  
>   - compatible: Must be one of the following
> +   - "renesas,rcar-gen2-vin" for R-Car Gen2 Series
> +   - "renesas,rcar-gen3-vin" for R-Car Gen3 Series
>     - "renesas,vin-r8a7794" for the R8A7794 device
>     - "renesas,vin-r8a7793" for the R8A7793 device
>     - "renesas,vin-r8a7791" for the R8A7791 device
>     - "renesas,vin-r8a7790" for the R8A7790 device
>     - "renesas,vin-r8a7779" for the R8A7779 device
>     - "renesas,vin-r8a7778" for the R8A7778 device
> +
> +   When compatible with the generic version, nodes must list the SoC-specific
> +   version corresponding to the platform first followed by the generic version.
> +
>   - reg: the register base and size for the device registers
>   - interrupts: the interrupt for the device
>   - clocks: Reference to the parent clock
> @@ -36,7 +42,7 @@ Device node example
>  	};
>  
>          vin0: vin@0xe6ef0000 {
> -                compatible = "renesas,vin-r8a7790";
> +                compatible = "renesas,vin-r8a7790","renesas,rcar-gen2-vin";
>                  clocks = <&mstp8_clks R8A7790_CLK_VIN0>;
>                  reg = <0 0xe6ef0000 0 0x1000>;
>                  interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index b7fd695..f72de0b 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -143,6 +143,7 @@
>  #define RCAR_VIN_BT656			(1 << 3)
>  
>  enum chip_id {
> +	RCAR_GEN3,
>  	RCAR_GEN2,
>  	RCAR_H1,
>  	RCAR_M1,
> @@ -1824,6 +1825,8 @@ static const struct of_device_id rcar_vin_of_table[] = {
>  	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
>  	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> +	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
> +	{ .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
> -- 
> 1.9.1
> 
