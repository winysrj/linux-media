Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59741 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934255AbcJRP0B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 11:26:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: horms@verge.net.au, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        geert@linux-m68k.org, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v2 2/3] ARM: dts: gose: add HDMI input
Date: Tue, 18 Oct 2016 18:25:57 +0300
Message-ID: <2926937.gvkf1yHYyt@avalon>
In-Reply-To: <1476802943-5189-3-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1476802943-5189-1-git-send-email-ulrich.hecht+renesas@gmail.com> <1476802943-5189-3-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patch.

On Tuesday 18 Oct 2016 17:02:22 Ulrich Hecht wrote:
> Identical to the setup on Lager.

You probably mean on Koelsch ?

> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  arch/arm/boot/dts/r8a7793-gose.dts | 64 +++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7793-gose.dts
> b/arch/arm/boot/dts/r8a7793-gose.dts index dc311eb..a47ea4b 100644
> --- a/arch/arm/boot/dts/r8a7793-gose.dts
> +++ b/arch/arm/boot/dts/r8a7793-gose.dts
> @@ -253,6 +253,17 @@
>  		};
>  	};
> 
> +	hdmi-in {
> +		compatible = "hdmi-connector";
> +		type = "a";
> +
> +		port {
> +			hdmi_con_in: endpoint {
> +				remote-endpoint = <&adv7612_in>;
> +			};
> +		};
> +	};
> +
>  	hdmi-out {
>  		compatible = "hdmi-connector";
>  		type = "a";

For consistency you might want to rename the hdmi-out endpoint like you did 
for Lager and Koelsch.

With that fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> @@ -374,6 +385,11 @@
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
> @@ -531,6 +547,33 @@
>  		};
>  	};
> 
> +	hdmi-in@4c {
> +		compatible = "adi,adv7612";
> +		reg = <0x4c>;
> +		interrupt-parent = <&gpio4>;
> +		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
> +		default-input = <0>;
> +
> +		port {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			port@0 {
> +				reg = <0>;
> +				adv7612_in: endpoint {
> +					remote-endpoint = <&hdmi_con_in>;
> +				};
> +			};
> +
> +			port@2 {
> +				reg = <2>;
> +				adv7612_out: endpoint {
> +					remote-endpoint = <&vin0ep2>;
> +				};
> +			};
> +		};
> +	};
> +
>  	eeprom@50 {
>  		compatible = "renesas,r1ex24002", "atmel,24c02";
>  		reg = <0x50>;
> @@ -558,3 +601,24 @@
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
> +		vin0ep2: endpoint {
> +			remote-endpoint = <&adv7612_out>;
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

