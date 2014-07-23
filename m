Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:58107 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbaGWILI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 04:11:08 -0400
Date: Wed, 23 Jul 2014 10:11:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ben Dooks <ben.dooks@codethink.co.uk>
cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	magnus.damm@opensource.se, horms@verge.net.au,
	linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 6/6] [PATCH v2] ARM: lager: add vin1 node
In-Reply-To: <1404599185-12353-7-git-send-email-ben.dooks@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1407231010350.30243@axis700.grange>
References: <1404599185-12353-1-git-send-email-ben.dooks@codethink.co.uk>
 <1404599185-12353-7-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Same for this one - who takes it and is CC sufficient?

Thanks
Guennadi

On Sat, 5 Jul 2014, Ben Dooks wrote:

> Add device-tree for vin1 (composite video in) on the
> lager board.
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
> 
> Fixes since v1:
> 	- Whitespace fixes as suggested by Sergei
> ---
>  arch/arm/boot/dts/r8a7790-lager.dts | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
> index 4805c9f..e00543b 100644
> --- a/arch/arm/boot/dts/r8a7790-lager.dts
> +++ b/arch/arm/boot/dts/r8a7790-lager.dts
> @@ -214,6 +214,11 @@
>  		renesas,groups = "i2c2";
>  		renesas,function = "i2c2";
>  	};
> +
> +	vin1_pins: vin {
> +		renesas,groups = "vin1_data8", "vin1_clk";
> +		renesas,function = "vin1";
> +	};
>  };
>  
>  &ether {
> @@ -342,8 +347,39 @@
>  	status = "ok";
>  	pinctrl-0 = <&i2c2_pins>;
>  	pinctrl-names = "default";
> +
> +	composite-in@20 {
> +		compatible = "adi,adv7180";
> +		reg = <0x20>;
> +		remote = <&vin1>;
> +
> +		port {
> +			adv7180: endpoint {
> +				bus-width = <8>;
> +				remote-endpoint = <&vin1ep0>;
> +			};
> +		};
> +	};
>  };
>  
>  &i2c3	{
>  	status = "ok";
>  };
> +
> +/* composite video input */
> +&vin1 {
> +	pinctrl-0 = <&vin1_pins>;
> +	pinctrl-names = "default";
> +
> +	status = "ok";
> +
> +	port {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		vin1ep0: endpoint {
> +			remote-endpoint = <&adv7180>;
> +			bus-width = <8>;
> +		};
> +	};
> +};
> -- 
> 2.0.0
> 
