Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42596 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725749AbeJIH15 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 03:27:57 -0400
Subject: Re: [PATCH 1/7] dt-bindings: mfd: ds90ux9xx: add description of TI
 DS90Ux9xx ICs
To: Vladimir Zapolskiy <vz@mleia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sandeep Jain <Sandeep_Jain@mentor.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-2-vz@mleia.com>
From: Marek Vasut <marek.vasut@gmail.com>
Message-ID: <5631ac17-a1c1-af12-8b30-314880af42df@gmail.com>
Date: Tue, 9 Oct 2018 02:13:38 +0200
MIME-Version: 1.0
In-Reply-To: <20181008211205.2900-2-vz@mleia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2018 11:11 PM, Vladimir Zapolskiy wrote:
> From: Sandeep Jain <Sandeep_Jain@mentor.com>
> 
> The change adds device tree binding description of TI DS90Ux9xx
> series of serializer and deserializer controllers which support video,
> audio and control data transmission over FPD-III Link connection.
> 
> Signed-off-by: Sandeep Jain <Sandeep_Jain@mentor.com>
> [vzapolskiy: various updates and corrections of secondary importance]
> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> ---
>  .../devicetree/bindings/mfd/ti,ds90ux9xx.txt  | 66 +++++++++++++++++++
>  1 file changed, 66 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt b/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt
> new file mode 100644
> index 000000000000..0733da88f7ef
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt
> @@ -0,0 +1,66 @@
> +Texas Instruments DS90Ux9xx de-/serializer controllers
> +
> +Required properties:
> +- compatible: Must contain a generic "ti,ds90ux9xx" value and
> +	may contain one more specific value from the list:
> +	"ti,ds90ub925q",
> +	"ti,ds90uh925q",
> +	"ti,ds90ub927q",
> +	"ti,ds90uh927q",
> +	"ti,ds90ub926q",
> +	"ti,ds90uh926q",

Keep the list sorted.

> +	"ti,ds90ub928q",
> +	"ti,ds90uh928q",
> +	"ti,ds90ub940q",
> +	"ti,ds90uh940q".
> +
> +Optional properties:
> +- reg : Specifies the I2C slave address of a local de-/serializer.
> +- power-gpios : GPIO line to control supplied power to the device.

Shouldn't this be regulator phandle ?

> +- ti,backward-compatible-mode : Overrides backward compatibility mode.
> +	Possible values are "<1>" or "<0>".

Make this bool , ie. present or not.

> +	If "ti,backward-compatible-mode" is not mentioned, the backward
> +	compatibility mode is not touched and given by hardware pin strapping.
> +- ti,low-frequency-mode : Overrides low frequency mode.
> +	Possible values are "<1>" or "<0>".
> +	If "ti,low-frequency-mode" is not mentioned, the low frequency mode
> +	is not touched and given by hardware pin strapping.
> +- ti,video-map-select-msb: Sets video bridge pins to MSB mode, if it is set
> +	MAPSEL pin value is ignored.
> +- ti,video-map-select-lsb: Sets video bridge pins to LSB mode, if it is set
> +	MAPSEL pin value is ignored.

This needs some additional explanation, what's this about ?

> +- ti,pixel-clock-edge : Selects Pixel Clock Edge.
> +	Possible values are "<1>" or "<0>".
> +	If "ti,pixel-clock-edge" is High <1>, output data is strobed on the
> +	Rising edge of the PCLK. If ti,pixel-clock-edge is Low <0>, data is
> +	strobed on the Falling edge of the PCLK.
> +	If "ti,pixel-clock-edge" is not mentioned, the pixel clock edge
> +	value is not touched and given by hardware pin strapping.
> +- ti,spread-spectrum-clock-generation : Spread Sprectrum Clock Generation.
> +	Possible values are from "<0>" to "<7>". The same value will be
> +	written to SSC register. If "ti,spread-spectrum-clock-gen" is not
> +	found, then SSCG will be disabled.
> +
> +TI DS90Ux9xx serializers and deserializer device nodes may contain a number
> +of children device nodes to describe and enable particular subcomponents
> +found on ICs.
> +
> +Example:
> +
> +serializer: serializer@c {
> +	compatible = "ti,ds90ub927q", "ti,ds90ux9xx";
> +	reg = <0xc>;
> +	power-gpios = <&gpio5 12 GPIO_ACTIVE_HIGH>;
> +	ti,backward-compatible-mode = <0>;
> +	ti,low-frequency-mode = <0>;
> +	ti,pixel-clock-edge = <0>;
> +	...
> +}
> +
> +deserializer: deserializer@3c {
> +	compatible = "ti,ds90ub940q", "ti,ds90ux9xx";
> +	reg = <0x3c>;
> +	power-gpios = <&gpio6 31 GPIO_ACTIVE_HIGH>;
> +	...
> +}
> +
> 


-- 
Best regards,
Marek Vasut
