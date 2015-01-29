Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52313 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbbA2QvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:51:23 -0500
Received: by mail-lb0-f171.google.com with SMTP id u14so30131928lbd.2
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 08:51:22 -0800 (PST)
Message-ID: <54CA6507.7090302@cogentembedded.com>
Date: Thu, 29 Jan 2015 19:51:19 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 8/8] WmT: dts/i vin0/adv7612 (HDMI)
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <1422548388-28861-9-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1422548388-28861-9-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 01/29/2015 07:19 PM, William Towle wrote:

    No signed off? Although, looking at the patch, I'm not very surprised...

> ---
>   arch/arm/boot/dts/r8a7790-lager.dts |   51 +++++++++++++++++++++++------------
>   1 file changed, 34 insertions(+), 17 deletions(-)
>
> diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
> index be44493..c20b6cb 100644
> --- a/arch/arm/boot/dts/r8a7790-lager.dts
> +++ b/arch/arm/boot/dts/r8a7790-lager.dts
> @@ -249,9 +249,9 @@
>   		renesas,function = "usb2";
>   	};
>
> -	vin1_pins: vin {
> -		renesas,groups = "vin1_data8", "vin1_clk";
> -		renesas,function = "vin1";

    I'm not sure why are you removing the VIN1 pins while adding VIN0 pins.

> +	vin0_pins: vin0 {
> +		renesas,groups = "vin0_data24", "vin0_sync", "vin0_field", "vin0_clkenb", "vin0_clk";
> +		renesas,function = "vin0";
>   	};
>   };
>
> @@ -391,15 +391,15 @@
>   	pinctrl-0 = <&iic2_pins>;
>   	pinctrl-names = "default";
>
> -	composite-in@20 {
> -		compatible = "adi,adv7180";
> -		reg = <0x20>;
> -		remote = <&vin1>;

     Why remove it?

> +	adv7612: adv7612@0x4c {

    We don't call the nodes with chip names. According to the ePAPR standard 
section 2.2.2, node names should reflect the general function of the device.
And drop "0x" prefix from <unit-address> prt of the name please.

> +		compatible = "adi,adv7612";
> +		reg = <0x4c>;
> +		remote = <&vin0>;
>
>   		port {
> -			adv7180: endpoint {
> -				bus-width = <8>;
> -				remote-endpoint = <&vin1ep0>;
> +			adv7612_1: endpoint {
> +				remote-endpoint = <&vin0ep0>;
> +				default-input = <0>;
>   			};
>   		};
>   	};
> @@ -419,6 +419,19 @@
>   		i2c-gpio,delay-us = <1>;	/* ~100 kHz */
>   		#address-cells = <1>;
>   		#size-cells = <0>;
> +
> +		adv7612: adv7612@0x4c {

    Two identical labels? Do we really have 2 ADV7162 chips on the board?
    And the same comments on the node name...

> +			compatible = "adi,adv7612";
> +			reg = <0x4c>;
> +			remote = <&vin0>;
> +
> +			port {
> +				adv7612_1: endpoint {

    Two identical labels?

> +					remote-endpoint = <&vin0ep0>;
> +					default-input = <0>;
> +				};
> +			};
> +		};
>   	};
>   };
>   #endif
> @@ -457,9 +470,9 @@
>   	pinctrl-names = "default";
>   };
>
> -/* composite video input */
> -&vin1 {
> -	pinctrl-0 = <&vin1_pins>;

    Why remove it?

> +/* HDMI video input */
> +&vin0 {
> +	pinctrl-0 = <&vin0_pins>;
>   	pinctrl-names = "default";
>
>   	status = "ok";
> @@ -468,9 +481,13 @@
>   		#address-cells = <1>;
>   		#size-cells = <0>;
>
> -		vin1ep0: endpoint {
> -			remote-endpoint = <&adv7180>;
> -			bus-width = <8>;
> +		vin0ep0: endpoint {
> +			remote-endpoint = <&adv7612_1>;
> +			bus-width = <24>;
> +			hsync-active = <0>;
> +			vsync-active = <0>;
> +			pclk-sample = <1>;
> +			data-active = <1>;
>   		};
>   	};
[...]

WBR, Sergei

