Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37498 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932707AbcI3MmS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 08:42:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: horms@verge.net.au, geert@linux-m68k.org, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com
Subject: Re: [PATCH 3/3] ARM: dts: gose: add composite video input
Date: Fri, 30 Sep 2016 15:42:13 +0300
Message-ID: <1677956.ZyVUIhWy2M@avalon>
In-Reply-To: <20160916130935.21292-4-ulrich.hecht+renesas@gmail.com>
References: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com> <20160916130935.21292-4-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patch.

On Friday 16 Sep 2016 15:09:35 Ulrich Hecht wrote:
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  arch/arm/boot/dts/r8a7793-gose.dts | 36 ++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7793-gose.dts
> b/arch/arm/boot/dts/r8a7793-gose.dts index e22d63c..981f0fe 100644
> --- a/arch/arm/boot/dts/r8a7793-gose.dts
> +++ b/arch/arm/boot/dts/r8a7793-gose.dts
> @@ -379,6 +379,11 @@
>  		groups = "vin0_data24", "vin0_sync", "vin0_clkenb", 
"vin0_clk";
>  		function = "vin0";
>  	};
> +
> +	vin1_pins: vin1 {
> +		groups = "vin1_data8", "vin1_clk";
> +		function = "vin1";
> +	};
>  };
> 
>  &ether {
> @@ -504,6 +509,19 @@
>  		reg = <0x12>;
>  	};
> 
> +	composite-in@20 {
> +		compatible = "adi,adv7180";
> +		reg = <0x20>;
> +		remote = <&vin1>;
> +
> +		port {
> +			adv7180: endpoint {
> +				bus-width = <8>;

Is this needed ?

> +				remote-endpoint = <&vin1ep>;
> +			};
> +		};

The ADV7180 DT bindings need to be updated with port nodes (that will be quite 
a challenge).

> +	};
> +
>  	hdmi@39 {
>  		compatible = "adi,adv7511w";
>  		reg = <0x39>;
> @@ -599,3 +617,21 @@
>  		};
>  	};
>  };
> +
> +/* composite video input */
> +&vin1 {
> +	pinctrl-0 = <&vin1_pins>;
> +	pinctrl-names = "default";
> +
> +	status = "okay";
> +
> +	port {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		vin1ep: endpoint {
> +			remote-endpoint = <&adv7180>;
> +			bus-width = <8>;
> +		};
> +	};
> +};

-- 
Regards,

Laurent Pinchart

