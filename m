Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50149 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753541AbeABLpL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 06:45:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/9] dt-bindings: media: Add Renesas CEU bindings
Date: Tue, 02 Jan 2018 13:45:30 +0200
Message-ID: <6263435.xWGUCtEJC1@avalon>
In-Reply-To: <1514469681-15602-2-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1514469681-15602-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 28 December 2017 16:01:13 EET Jacopo Mondi wrote:
> Add bindings documentation for Renesas Capture Engine Unit (CEU).
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  .../devicetree/bindings/media/renesas,ceu.txt      | 85 +++++++++++++++++++
>  1 file changed, 85 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt
> b/Documentation/devicetree/bindings/media/renesas,ceu.txt new file mode
> 100644
> index 0000000..f45628e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> @@ -0,0 +1,85 @@
> +Renesas Capture Engine Unit (CEU)
> +----------------------------------------------
> +
> +The Capture Engine Unit is the image capture interface found on Renesas
> +RZ chip series and on SH Mobile ones.

"ones" sound a bit weird. How about "... found in the Renesas SH Mobil and RZ 
SoCs." ?

> +The interface supports a single parallel input with data bus width up to
> +8/16 bits.

What do you mean by "up to 8/16 bits" ?

> +Required properties:
> +- compatible
> +	Must be one of:
> +	- "renesas,ceu"
> +	- "renesas,r7s72100-ceu"

This is unclear, as Geert pointed out renesas,ceu sounds like a fallback. I 
think this could be clarified if you explained how you plan to support other 
SoCs (in particular the SH Mobile series, when/if it will receive DT support).

> +- reg
> +	Physical address base and size.

The standard practice, if I'm not mistaken, is to document properties with the 
description starting on the same line as the property name.

- reg: Physical address base and size.

And nitpicking again, I'd write "register" instead of "physical" to clarify 
what the properties contains (even if its name should make it clear).

> +- interrupts
> +	The interrupt specifier.
> +- pinctrl-names, pinctrl-0
> +	phandle of pin controller sub-node configuring pins for CEU operations.

pinctrl-names isn't a phandle. If you want to document those properties (not 
all DT bindings do, I'm not sure what is best) you should document them both, 
possibly on two separate lines. There are plenty of examples in the upstream 
DT bindings.

> +- remote-endpoint
> +	phandle to an 'endpoint' subnode of a remote device node.

As Geert pointed out this isn't a top-level property. I wouldn't document it 
as such, but instead reference Documentation/devicetree/bindings/media/video-
interfaces.txt (see Documentation/devicetree/bindings/display/renesas,du.txt 
or Documentation/devicetree/bindings/media/renesas,drif.txt for examples).

> +CEU supports a single parallel input and should contain a single 'port'

s/CEU/The CEU/

> subnode
> +with a single 'endpoint'. Optional endpoint properties applicable to
> parallel
> +input bus described in "video-interfaces.txt" supported by this driver are:
> +
> +- hsync-active
> +	active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
> +- vsync-active
> +	active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
> +
> +Example:
> +
> +The example describes the connection between the Capture Engine Unit and an
> +OV7670 image sensor sitting on bus i2c1.

Maybe s/sitting on/connected to/ ?

> +ceu: ceu@e8210000 {
> +	reg = <0xe8210000 0x209c>;
> +	compatible = "renesas,ceu";
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
