Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33396 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752842AbdBAQvB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 11:51:01 -0500
Date: Wed, 1 Feb 2017 10:50:59 -0600
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 08/16] atmel-isi: document device tree bindings
Message-ID: <20170201165059.2qw3gnuyornvfl46@rob-hp-laptop>
References: <20170130140628.18088-1-hverkuil@xs4all.nl>
 <20170130140628.18088-9-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170130140628.18088-9-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 30, 2017 at 03:06:20PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the device tree bindings for this driver.

Bindings document h/w not drivers.

> 
> Mostly copied from the atmel-isc bindings.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../devicetree/bindings/media/atmel-isi.txt        | 91 +++++++++++++---------
>  1 file changed, 56 insertions(+), 35 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/atmel-isi.txt b/Documentation/devicetree/bindings/media/atmel-isi.txt
> index 251f008..d1934b4 100644
> --- a/Documentation/devicetree/bindings/media/atmel-isi.txt
> +++ b/Documentation/devicetree/bindings/media/atmel-isi.txt
> @@ -1,51 +1,72 @@
> -Atmel Image Sensor Interface (ISI) SoC Camera Subsystem
> -----------------------------------------------
> +Atmel Image Sensor Interface (ISI)
> +----------------------------------
>  
> -Required properties:
> -- compatible: must be "atmel,at91sam9g45-isi"
> -- reg: physical base address and length of the registers set for the device;
> -- interrupts: should contain IRQ line for the ISI;
> -- clocks: list of clock specifiers, corresponding to entries in
> -          the clock-names property;
> -- clock-names: must contain "isi_clk", which is the isi peripherial clock.
> +Required properties for ISI:
> +- compatible
> +	Must be "atmel,at91sam9g45-isi".
> +- reg
> +	Physical base address and length of the registers set for the device.
> +- interrupts
> +	Should contain IRQ line for the ISI.
> +- clocks
> +	List of clock specifiers, corresponding to entries in
> +	the clock-names property;
> +	Please refer to clock-bindings.txt.
> +- clock-names
> +	Required elements: "isi_clk".
> +- #clock-cells
> +	Should be 0.

This reformatting is unrelated and the old form was more standard for 
bindings (not that we have any real standard).

> +- pinctrl-names, pinctrl-0
> +	Please refer to pinctrl-bindings.txt.
>  
>  ISI supports a single port node with parallel bus. It should contain one
>  'port' child node with child 'endpoint' node. Please refer to the bindings
>  defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
>  
>  Example:
> -	isi: isi@f0034000 {
> -		compatible = "atmel,at91sam9g45-isi";
> -		reg = <0xf0034000 0x4000>;
> -		interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
>  
> -		clocks = <&isi_clk>;
> -		clock-names = "isi_clk";
> +isi: isi@f0034000 {
> +	compatible = "atmel,at91sam9g45-isi";
> +	reg = <0xf0034000 0x4000>;
> +	interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_isi_data_0_7>;
> +	clocks = <&isi_clk>;
> +	clock-names = "isi_clk";
> +	status = "ok";
> +	port {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		isi_0: endpoint {
> +			reg = <0>;

Drop reg.

> +			remote-endpoint = <&ov2640_0>;
> +			bus-width = <8>;
> +			vsync-active = <1>;
> +			hsync-active = <1>;

Which side of the connect is supposed to define these?

> +		};
> +	};
> +};
> +
> +i2c1: i2c@f0018000 {
> +	status = "okay";
>  
> +	ov2640: camera@0x30 {

Drop the '0x'.

> +		compatible = "ovti,ov2640";
> +		reg = <0x30>;
>  		pinctrl-names = "default";
> -		pinctrl-0 = <&pinctrl_isi>;
> +		pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
> +		resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
> +		pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
> +		clocks = <&pck0>;
> +		clock-names = "xvclk";
> +		assigned-clocks = <&pck0>;
> +		assigned-clock-rates = <25000000>;
>  
>  		port {
> -			#address-cells = <1>;
> -			#size-cells = <0>;
> -
> -			isi_0: endpoint {
> -				remote-endpoint = <&ov2640_0>;
> +			ov2640_0: endpoint {
> +				remote-endpoint = <&isi_0>;
>  				bus-width = <8>;

It is pointless to define bus-width at both ends.

>  			};
>  		};
>  	};
> -
> -	i2c1: i2c@f0018000 {
> -		ov2640: camera@0x30 {
> -			compatible = "ovti,ov2640";
> -			reg = <0x30>;
> -
> -			port {
> -				ov2640_0: endpoint {
> -					remote-endpoint = <&isi_0>;
> -					bus-width = <8>;
> -				};
> -			};
> -		};
> -	};
> +};
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
