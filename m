Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33190 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753669AbdCTQmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 12:42:32 -0400
Date: Mon, 20 Mar 2017 11:41:19 -0500
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv5 06/16] atmel-isi: document device tree bindings
Message-ID: <20170320164119.cxmson67wdyoww2k@rob-hp-laptop>
References: <20170311112328.11802-1-hverkuil@xs4all.nl>
 <20170311112328.11802-7-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170311112328.11802-7-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 11, 2017 at 12:23:18PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the device tree bindings for this hardware.
> 
> Mostly copied from the atmel-isc bindings.

This commit message doesn't really reflect what you are doing and the 
reformatting and fixes really make this a PIA to review.

>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  .../devicetree/bindings/media/atmel-isi.txt        | 96 +++++++++++++---------
>  1 file changed, 58 insertions(+), 38 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/atmel-isi.txt b/Documentation/devicetree/bindings/media/atmel-isi.txt
> index 251f008f220c..65249bbd5c00 100644
> --- a/Documentation/devicetree/bindings/media/atmel-isi.txt
> +++ b/Documentation/devicetree/bindings/media/atmel-isi.txt
> @@ -1,51 +1,71 @@
> -Atmel Image Sensor Interface (ISI) SoC Camera Subsystem
> -----------------------------------------------
> -
> -Required properties:
> -- compatible: must be "atmel,at91sam9g45-isi"
> -- reg: physical base address and length of the registers set for the device;
> -- interrupts: should contain IRQ line for the ISI;
> -- clocks: list of clock specifiers, corresponding to entries in
> -          the clock-names property;
> -- clock-names: must contain "isi_clk", which is the isi peripherial clock.
> -
> -ISI supports a single port node with parallel bus. It should contain one
> +Atmel Image Sensor Interface (ISI)
> +----------------------------------
> +
> +Required properties for ISI:
> +- compatible: must be "atmel,at91sam9g45-isi".
> +- reg: physical base address and length of the registers set for the device.
> +- interrupts: should contain IRQ line for the ISI.
> +- clocks: list of clock specifiers, corresponding to entries in the clock-names
> +	property; please refer to clock-bindings.txt.
> +- clock-names: required elements: "isi_clk".
> +- pinctrl-names, pinctrl-0: please refer to pinctrl-bindings.txt.
> +
> +ISI supports a single port node with parallel bus. It shall contain one
>  'port' child node with child 'endpoint' node. Please refer to the bindings
>  defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
>  
> -Example:
> -	isi: isi@f0034000 {
> -		compatible = "atmel,at91sam9g45-isi";
> -		reg = <0xf0034000 0x4000>;
> -		interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
> +Endpoint node properties
> +------------------------
>  
> -		clocks = <&isi_clk>;
> -		clock-names = "isi_clk";
> +- bus-width: <8> or <10> (mandatory)
> +- hsync-active (default: active high)
> +- vsync-active (default: active high)
> +- pclk-sample (default: sample on falling edge)
> +- remote-endpoint: A phandle to the bus receiver's endpoint node (mandatory).
>  
> -		pinctrl-names = "default";
> -		pinctrl-0 = <&pinctrl_isi>;
> -
> -		port {
> -			#address-cells = <1>;
> -			#size-cells = <0>;
> +Example:
>  
> -			isi_0: endpoint {
> -				remote-endpoint = <&ov2640_0>;
> -				bus-width = <8>;
> -			};
> +isi: isi@f0034000 {
> +	compatible = "atmel,at91sam9g45-isi";
> +	reg = <0xf0034000 0x4000>;
> +	interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_isi_data_0_7>;
> +	clocks = <&isi_clk>;
> +	clock-names = "isi_clk";
> +	status = "ok";

Don't put status in examples.

> +	port {
> +		#address-cells = <1>;
> +		#size-cells = <0>;

These can be dropped.

> +		isi_0: endpoint {
> +			remote-endpoint = <&ov2640_0>;
> +			bus-width = <8>;
> +			vsync-active = <1>;
> +			hsync-active = <1>;
>  		};
>  	};
> +};
> +
> +i2c1: i2c@f0018000 {
> +	status = "okay";
>  
> -	i2c1: i2c@f0018000 {
> -		ov2640: camera@0x30 {
> -			compatible = "ovti,ov2640";
> -			reg = <0x30>;
> +	ov2640: camera@30 {
> +		compatible = "ovti,ov2640";
> +		reg = <0x30>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
> +		resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;

reset-gpios?

> +		pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;

powerdown-gpios?

> +		clocks = <&pck0>;
> +		clock-names = "xvclk";
> +		assigned-clocks = <&pck0>;
> +		assigned-clock-rates = <25000000>;
>  
> -			port {
> -				ov2640_0: endpoint {
> -					remote-endpoint = <&isi_0>;
> -					bus-width = <8>;
> -				};
> +		port {
> +			ov2640_0: endpoint {
> +				remote-endpoint = <&isi_0>;
> +				bus-width = <8>;
>  			};
>  		};
>  	};
> +};
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
