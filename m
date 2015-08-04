Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34200 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933767AbbHDMA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 08:00:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: William Towle <william.towle@codethink.co.uk>
Cc: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: shmobile: lager dts: Add entries for VIN HDMI input support
Date: Tue, 04 Aug 2015 15:01:41 +0300
Message-ID: <3911852.kuPGHSpHNa@avalon>
In-Reply-To: <1438100264-17280-2-git-send-email-william.towle@codethink.co.uk>
References: <1438100264-17280-1-git-send-email-william.towle@codethink.co.uk> <1438100264-17280-2-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

Thank you for the patch.

On Tuesday 28 July 2015 17:17:43 William Towle wrote:
> Add DT entries for vin0, vin0_pins, and adv7612
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> ---
>  arch/arm/boot/dts/r8a7790-lager.dts |   41 +++++++++++++++++++++++++++++++-
>  1 file changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/r8a7790-lager.dts
> b/arch/arm/boot/dts/r8a7790-lager.dts index e02b523..aec7db6 100644
> --- a/arch/arm/boot/dts/r8a7790-lager.dts
> +++ b/arch/arm/boot/dts/r8a7790-lager.dts
> @@ -378,7 +378,12 @@
>  		renesas,function = "usb2";
>  	};
> 
> -	vin1_pins: vin {
> +	vin0_pins: vin0 {
> +		renesas,groups = "vin0_data24", "vin0_sync", "vin0_field", 
"vin0_clkenb", "vin0_clk";

If I'm not mistaken the VI0_FIELD pin isn't used on Lager.

> +		renesas,function = "vin0";
> +	};
> +
> +	vin1_pins: vin1 {
>  		renesas,groups = "vin1_data8", "vin1_clk";
>  		renesas,function = "vin1";
>  	};
> @@ -539,6 +544,18 @@
>  		reg = <0x12>;
>  	};
> 
> +	hdmi-in@4c {
> +		compatible = "adi,adv7612";
> +		reg = <0x4c>;
> +		remote = <&vin0>;

There's no remote property documented in the adv7612 bindings as far as I 
know. And that's good, I don't think there should be one :-)

> +
> +		port {
> +			hdmi_in_ep: endpoint {
> +				remote-endpoint = <&vin0ep0>;
> +			};
> +		};
> +	};
> +
>  	composite-in@20 {
>  		compatible = "adi,adv7180";
>  		reg = <0x20>;
> @@ -654,6 +671,28 @@
>  	status = "okay";
>  };
> 
> +/* HDMI video input */
> +&vin0 {
> +	pinctrl-0 = <&vin0_pins>;
> +	pinctrl-names = "default";
> +
> +	status = "ok";
> +
> +	port {
> +		#address-cells = <1>;
> +		#size-cells = <0>;

If there's a single endpoint I don't think you need those two properties.

> +
> +		vin0ep0: endpoint {
> +			remote-endpoint = <&hdmi_in_ep>;
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
>  	pinctrl-0 = <&vin1_pins>;

-- 
Regards,

Laurent Pinchart

