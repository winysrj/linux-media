Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51305 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751391AbeAPJtl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 04:49:41 -0500
Subject: Re: [PATCH v5 1/9] dt-bindings: media: Add Renesas CEU bindings
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515765849-10345-2-git-send-email-jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b053414f-3861-50ad-c672-68977a9f4cd4@xs4all.nl>
Date: Tue, 16 Jan 2018 10:49:36 +0100
MIME-Version: 1.0
In-Reply-To: <1515765849-10345-2-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/2018 03:04 PM, Jacopo Mondi wrote:
> Add bindings documentation for Renesas Capture Engine Unit (CEU).
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

        Hans

> ---
>  .../devicetree/bindings/media/renesas,ceu.txt      | 81 ++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> new file mode 100644
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
> +The interface supports a single parallel input with data bus width of 8 or 16
> +bits.
> +
> +Required properties:
> +- compatible: Shall be "renesas,r7s72100-ceu" for CEU units found in RZ/A1-H
> +  and RZ/A1-M SoCs.
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
> +- hsync-active: Active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
> +  If property is not present, default is active high.
> +- vsync-active: Active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
> +  If property is not present, default is active high.
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
> 
