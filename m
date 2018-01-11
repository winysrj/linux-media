Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59424 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933341AbeAKWuo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 17:50:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, festevam@gmail.com, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/9] dt-bindings: media: Add Renesas CEU bindings
Date: Fri, 12 Jan 2018 00:50:41 +0200
Message-ID: <3717276.fcpQzKB3PM@avalon>
In-Reply-To: <1515515131-13760-2-git-send-email-jacopo+renesas@jmondi.org>
References: <1515515131-13760-1-git-send-email-jacopo+renesas@jmondi.org> <1515515131-13760-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Tuesday, 9 January 2018 18:25:23 EET Jacopo Mondi wrote:
> Add bindings documentation for Renesas Capture Engine Unit (CEU).
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  .../devicetree/bindings/media/renesas,ceu.txt      | 81
> ++++++++++++++++++++++ 1 file changed, 81 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt
> b/Documentation/devicetree/bindings/media/renesas,ceu.txt new file mode
> 100644
> index 0000000..590ee27
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> @@ -0,0 +1,81 @@
> +Renesas Capture Engine Unit (CEU)
> +----------------------------------------------
> +
> +The Capture Engine Unit is the image capture interface found in the Renesas
> +SH Mobile and RZ SoCs.
> +
> +The interface supports a single parallel input with data bus width of 8 or
> 16 +bits.
> +
> +Required properties:
> +- compatible: Shall be "renesas,r7s72100-ceu" for CEU units found in
> RZ/A1-H +  and RZ/A1-M SoCs.
> +- reg: Registers address base and size.
> +- interrupts: The interrupt specifier.
> +
> +The CEU supports a single parallel input and should contain a single 'port'
> +subnode with a single 'endpoint'. Connection to input devices are modeled
> +according to the video interfaces OF bindings specified in:
> +Documentation/devicetree/bindings/media/video-interfaces.txt
> +
> +Optional endpoint properties applicable to parallel input bus described in
> +the above mentioned "video-interfaces.txt" file are supported.
> +
> +- hsync-active: Active state of the HSYNC signal, 0/1 for LOW/HIGH
> respectively. +  If property is not present, default is active high.
> +- vsync-active: Active state of the VSYNC signal, 0/1 for LOW/HIGH
> respectively. +  If property is not present, default is active high.
> +
> +Example:
> +
> +The example describes the connection between the Capture Engine Unit and an
> +OV7670 image sensor connected to i2c1 interface.
> +
> +ceu: ceu@e8210000 {
> +	reg = <0xe8210000 0x209c>;
> +	compatible = "renesas,r7s72100-ceu";
> +	interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
> +
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&vio_pins>;
> +
> +	status = "okay";
> +
> +	port {
> +		ceu_in: endpoint {
> +			remote-endpoint = <&ov7670_out>;
> +
> +			hsync-active = <1>;
> +			vsync-active = <0>;
> +		};
> +	};
> +};
> +
> +i2c1: i2c@fcfee400 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&i2c1_pins>;
> +
> +	status = "okay";
> +
> +	clock-frequency = <100000>;
> +
> +	ov7670: camera@21 {
> +		compatible = "ovti,ov7670";
> +		reg = <0x21>;
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&vio_pins>;
> +
> +		reset-gpios = <&port3 11 GPIO_ACTIVE_LOW>;
> +		powerdown-gpios = <&port3 12 GPIO_ACTIVE_HIGH>;
> +
> +		port {
> +			ov7670_out: endpoint {
> +				remote-endpoint = <&ceu_in>;
> +
> +				hsync-active = <1>;
> +				vsync-active = <0>;
> +			};
> +		};
> +	};
> +};


-- 
Regards,

Laurent Pinchart
