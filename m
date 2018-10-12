Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45544 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbeJLT0U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 15:26:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: Re: [PATCH 2/7] dt-bindings: mfd: ds90ux9xx: add description of TI DS90Ux9xx I2C bridge
Date: Fri, 12 Oct 2018 14:54:16 +0300
Message-ID: <1728543.TWj8z2etku@avalon>
In-Reply-To: <20181008211205.2900-3-vz@mleia.com>
References: <20181008211205.2900-1-vz@mleia.com> <20181008211205.2900-3-vz@mleia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

Thank you for the patch.

On Tuesday, 9 October 2018 00:12:00 EEST Vladimir Zapolskiy wrote:
> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> 
> TI DS90Ux9xx de-/serializers are capable to route I2C messages to
> I2C slave devices connected to a remote de-/serializer in a pair,
> the change adds description of device tree bindings of the subcontroller
> to configure and enable this functionality.
> 
> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> ---
>  .../bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt  | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt
> 
> diff --git
> a/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt
> b/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt new
> file mode 100644
> index 000000000000..4169e382073a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt
> @@ -0,0 +1,61 @@
> +TI DS90Ux9xx de-/serializer I2C bridge subcontroller
> +
> +Required properties:
> +- compatible: Must contain a generic "ti,ds90ux9xx-i2c-bridge" value and
> +	may contain one more specific value from the list:
> +	"ti,ds90ux925-i2c-bridge",
> +	"ti,ds90ux926-i2c-bridge",
> +	"ti,ds90ux927-i2c-bridge",
> +	"ti,ds90ux928-i2c-bridge",
> +	"ti,ds90ux940-i2c-bridge".

I still don't think the I2C bridge should be modeled with a separate 
compatible string, as explained in my comments to the cover letter and patch 
1/7.

> +Required properties of a de-/serializer device connected to a local I2C
> bus:
> +- ti,i2c-bridges: List of phandles to remote de-/serializer devices with
> +	two arguments: id of a local de-/serializer FPD link and an assigned
> +	I2C address of a remote de-/serializer to be accessed on a local
> +	I2C bus.

Please don't. Just make the deserializer a child of the serializer. This is 
how DT works, devices are organized in a tree based on the main control bus. 
When the deserializer is controlled from the serializer through the FPD link, 
it should be a child of the serializer.

> +Optional properties of a de-/serializer device connected to a local I2C
> bus:
> +- ti,i2c-bridge-maps: List of 3-cell values:
> +	- the first argument is id of a local de-/serializer FPD link,
> +	- the second argument is an I2C address of a device connected to
> +	  a remote de-/serializer IC,
> +	- the third argument is an I2C address of the remote I2C device
> +	  for access on a local I2C bus.
> +- ti,i2c-bridge-auto-ack: Enables AUTO ACK mode.

>From my experience with GMSL this isn't something you can just enable or 
disable unconditionally, it needs to be handled at runtime, and doesn't belong 
to DT anyway.

> +- ti,i2c-bridge-pass-all: Enables PASS ALL mode, remote I2C slave devices
> +	are accessible on a local (host) I2C bus without I2C address
> +	remappings.

This property also doesn't seem like a hardware description. Please try to 
focus on what DT describes, not what the effect of the properties are. 
Bindings need to describe the model of the device, and that description then 
leads to effects. It shouldn't be the other way around.

> +Remote de-/serializer device may contain a list of device nodes, each
> +one represents an I2C device connected to that remote de-/serializer IC.
> +
> +Example (remote device is a deserializer with Atmel MXT touchscreen):
> +
> +serializer: serializer@c {
> +	compatible = "ti,ds90ub927q", "ti,ds90ux9xx";
> +	reg = <0xc>;
> +
> +	i2c-bridge {
> +		compatible = "ti,ds90ux927-i2c-bridge",
> +			     "ti,ds90ux9xx-i2c-bridge";
> +		ti,i2c-bridges = <&deserializer 0 0x3b>;
> +		ti,i2c-bridge-maps = <0 0x4b 0x64>;
> +	};
> +};
> +
> +deserializer: deserializer {
> +	compatible = "ti,ds90ub928q", "ti,ds90ux9xx";
> +
> +	i2c-bridge {
> +		compatible = "ti,ds90ux928-i2c-bridge",
> +			     "ti,ds90ux9xx-i2c-bridge";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		touchscreen@4b {
> +			compatible = "atmel,maxtouch";
> +			reg = <0x4b>;
> +		};
> +	};
> +};

-- 
Regards,

Laurent Pinchart
