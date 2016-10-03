Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43160 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbcJCKPT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2016 06:15:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: horms@verge.net.au, geert@linux-m68k.org, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        william.towle@codethink.co.uk, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 2/2] ARM: dts: koelsch: add HDMI input
Date: Mon, 03 Oct 2016 13:15:15 +0300
Message-ID: <1629189.brlfT13tJD@avalon>
In-Reply-To: <20160916130909.21225-3-ulrich.hecht+renesas@gmail.com>
References: <20160916130909.21225-1-ulrich.hecht+renesas@gmail.com> <20160916130909.21225-3-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patch.

On Friday 16 Sep 2016 15:09:09 Ulrich Hecht wrote:
> From: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Add support in the dts for the HDMI input. Based on the Lager dts
> patch from Ulrich Hecht.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> [uli: removed "renesas," prefixes from pfc nodes]
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  arch/arm/boot/dts/r8a7791-koelsch.dts | 41 ++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts
> b/arch/arm/boot/dts/r8a7791-koelsch.dts index f8a7d09..45b8b5f 100644
> --- a/arch/arm/boot/dts/r8a7791-koelsch.dts
> +++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
> @@ -393,6 +393,11 @@
>  		function = "usb1";
>  	};
> 
> +	vin0_pins: vin0 {
> +		groups = "vin0_data24", "vin0_sync", "vin0_clkenb", 
"vin0_clk";
> +		function = "vin0";
> +	};
> +
>  	vin1_pins: vin1 {
>  		groups = "vin1_data8", "vin1_clk";
>  		function = "vin1";
> @@ -596,6 +601,21 @@
>  		};
>  	};
> 
> +	hdmi-in@4c {
> +		compatible = "adi,adv7612";
> +		reg = <0x4c>;
> +		interrupt-parent = <&gpio1>;
> +		interrupts = <20 IRQ_TYPE_LEVEL_LOW>;

This should be GP4_2.

> +		remote = <&vin0>;

Is this needed ?

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
>  		compatible = "renesas,24c02";
>  		reg = <0x50>;
> @@ -672,6 +692,27 @@
>  	cpu0-supply = <&vdd_dvfs>;
>  };
> 
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
> +
>  /* composite video input */
>  &vin1 {
>  	status = "okay";

-- 
Regards,

Laurent Pinchart

