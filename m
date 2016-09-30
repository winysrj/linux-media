Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37485 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932865AbcI3MkY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 08:40:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: horms@verge.net.au, geert@linux-m68k.org, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com
Subject: Re: [PATCH 2/3] ARM: dts: gose: add HDMI input
Date: Fri, 30 Sep 2016 15:40:17 +0300
Message-ID: <1951325.PMIbTHqE2x@avalon>
In-Reply-To: <20160916130935.21292-3-ulrich.hecht+renesas@gmail.com>
References: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com> <20160916130935.21292-3-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patch.

On Friday 16 Sep 2016 15:09:34 Ulrich Hecht wrote:
> Identical to the setup on Lager.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  arch/arm/boot/dts/r8a7793-gose.dts | 41 +++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7793-gose.dts
> b/arch/arm/boot/dts/r8a7793-gose.dts index 90af186..e22d63c 100644
> --- a/arch/arm/boot/dts/r8a7793-gose.dts
> +++ b/arch/arm/boot/dts/r8a7793-gose.dts
> @@ -374,6 +374,11 @@
>  		groups = "audio_clk_a";
>  		function = "audio_clk";
>  	};
> +
> +	vin0_pins: vin0 {
> +		groups = "vin0_data24", "vin0_sync", "vin0_clkenb", 
"vin0_clk";
> +		function = "vin0";
> +	};
>  };
> 
>  &ether {
> @@ -531,6 +536,21 @@
>  		};
>  	};
> 
> +	hdmi-in@4c {
> +		compatible = "adi,adv7612";
> +		reg = <0x4c>;
> +		interrupt-parent = <&gpio1>;
> +		interrupts = <20 IRQ_TYPE_LEVEL_LOW>;

Isn't the interrupt signal connected to GP4_2 ?

> +		remote = <&vin0>;

What is this for ?

> +		default-input = <0>;
> +
> +		port {
> +			adv7612: endpoint {
> +				remote-endpoint = <&vin0ep>;
> +			};
> +		};

The ADV7612 has three ports. Ports 0 and 1 correspond to the HDMI inputs, and 
port 2 to the digital output. You can leave port 1 out as it's not used on the 
board, but you should specify both ports 0 and 2, and add an HDMI connector DT 
node connected to port 0 of the ADV7612.

> +	};
> +
>  	eeprom@50 {
>  		compatible = "renesas,r1ex24002", "atmel,24c02";
>  		reg = <0x50>;
> @@ -558,3 +578,24 @@
>  &ssi1 {
>  	shared-pin;
>  };
> +
> +/* HDMI video input */
> +&vin0 {
> +	status = "okay";
> +	pinctrl-0 = <&vin0_pins>;
> +	pinctrl-names = "default";
> +
> +	port {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		vin0ep: endpoint {
> +			remote-endpoint = <&adv7612>;
> +			bus-width = <24>;
> +			hsync-active = <0>;
> +			vsync-active = <0>;
> +			pclk-sample = <1>;
> +			data-active = <1>;
> +		};
> +	};
> +};

-- 
Regards,

Laurent Pinchart

