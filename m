Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37924 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751075AbeCGJxM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 04:53:12 -0500
Date: Wed, 7 Mar 2018 11:53:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Wen Nuan <leo.wen@rock-chips.com>
Cc: mchehab@kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rdunlap@infradead.org, jacob2.chen@rock-chips.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        eddie.cai@rock-chips.com
Subject: Re: [PATCH V2 2/2] dt-bindings: Document the Rockchip RK1608 bindings
Message-ID: <20180307095308.5eo4mthzx2oujszn@valkosipuli.retiisi.org.uk>
References: <1519633504-64357-1-git-send-email-leo.wen@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1519633504-64357-1-git-send-email-leo.wen@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wen,

On Mon, Feb 26, 2018 at 04:25:04PM +0800, Wen Nuan wrote:
> From: Leo Wen <leo.wen@rock-chips.com>
> 
> Add DT bindings documentation for Rockchip RK1608.
> 
> Changes V2:
> - Delete spi-min-frequency property.
> - Add the external sensor's control pin and clock properties.
> - Delete the '&pinctrl' node.
> 
> Signed-off-by: Leo Wen <leo.wen@rock-chips.com>
> ---
>  Documentation/devicetree/bindings/media/rk1608.txt | 97 ++++++++++++++++++++++
>  MAINTAINERS                                        |  1 +
>  2 files changed, 98 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rk1608.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/rk1608.txt b/Documentation/devicetree/bindings/media/rk1608.txt
> new file mode 100644
> index 0000000..a9721a8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rk1608.txt
> @@ -0,0 +1,97 @@
> +Rockchip RK1608 as a PreISP to link on Soc
> +------------------------------------------
> +
> +Required properties:
> +
> +- compatible		: "rockchip,rk1608";
> +- reg			: SPI slave address of the rk1608;
> +- clocks		: Must contain an entry for each entry in clock-names;
> +- clock-names		: Must contain "mclk" for the device's master clock;
> +- reset-gpio		: GPIO connected to reset pin;
> +- irq-gpio		: GPIO connected to irq pin;
> +- sleepst-gpio		: GPIO connected to sleepst pin;
> +- wakeup-gpio		: GPIO connected to wakeup pin;
> +- powerdown-gpio	: GPIO connected to powerdown pin;
> +- rockchip,powerdown0	: GPIO connected to the sensor0's powerdown pin;
> +- rockchip,reset0	: GPIO connected to the sensor0's reset pin;
> +- rockchip,powerdown1	: GPIO connected to the sensor1's powerdown pin;
> +- rockchip,reset1	: GPIO connected to the sensor1's reset pin;

Aren't these sensor's properties and not related to the ISP?

> +- pinctrl-names		: Should contain only one value - "default";
> +- pinctrl-0		: Pin control group to be used for this controller;
> +
> +Optional properties:
> +
> +- spi-max-frequency	: Maximum SPI clocking speed of the device;
> +
> +The device node should contain one 'port' child node with one child 'endpoint'
> +node, according to the bindings defined in Documentation/devicetree/bindings/
> +media/video-interfaces.txt. The following are properties specific to those
> +nodes.
> +
> +endpoint node
> +-------------
> +
> +- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
> +	       video-interfaces.txt. If present it should be <1> - the device
> +	       supports only one data lane without re-mapping.
> +
> +Note1: Since no data is generated in RK1608，so this is meaningful that you need
> +a extra sensor (such as a camera) mounted on RK1608. You need to use endpoint@x
> +to match these sensors.
> +
> +Note2:You must set the current value of the spi pins to be 8mA, if they are not.
> +
> +Example:
> +&spi0 {
> +	status = "okay";
> +	spi_rk1608@00 {
> +		compatible =  "rockchip,rk1608";
> +		status = "okay";
> +		reg = <0>;
> +		spi-max-frequency = <24000000>;
> +		link-freqs = /bits/ 64 <400000000>;
> +		clocks = <&cru SCLK_SPI0>, <&cru SCLK_VIP_OUT>,
> +		<&cru DCLK_VOP0>, <&cru ACLK_VIP>, <&cru HCLK_VIP>,
> +		<&cru PCLK_ISP_IN>, <&cru PCLK_ISP_IN>,
> +		<&cru PCLK_ISP_IN>, <&cru SCLK_MIPIDSI_24M>,
> +		<&cru PCLK_MIPI_CSI>;
> +		clock-names = "mclk", "mipi_clk",  "pd_cif", "aclk_cif",
> +			"hclk_cif", "cif0_in", "g_pclkin_cif",
> +			"cif0_out", "clk_mipi_24m", "hclk_mipiphy";
> +		reset-gpio = <&gpio6 0 GPIO_ACTIVE_HIGH>;
> +		irq-gpio = <&gpio6 2 GPIO_ACTIVE_HIGH>;
> +		sleepst-gpio = <&gpio6 1 GPIO_ACTIVE_HIGH>;
> +		wakeup-gpio = <&gpio6 4 GPIO_ACTIVE_HIGH>;
> +		powerdown-gpio = <&gpio8 0 GPIO_ACTIVE_HIGH>;
> +
> +		rockchip,powerdown1 = <&gpio5 9 GPIO_ACTIVE_HIGH>;
> +		rockchip,reset1 = <&gpio6 8 GPIO_ACTIVE_HIGH>;
> +
> +		rockchip,powerdown0 = <&gpio5 8 GPIO_ACTIVE_HIGH>;
> +		rockchip,reset0 = <&gpio6 7 GPIO_ACTIVE_HIGH>;
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&rk1608_irq_gpios &rk1608_wake_gpios
> +			     &rk1608_sleep_gpios>;
> +
> +		port@0 {
> +			mipi_dphy_out: endpoint {
> +				remote-endpoint = <&mipi_dphy_in>;
> +				clock-lanes = <0>;
> +				data-lanes = <1 2 3 4>;
> +				clock-noncontinuous;
> +				link-frequencies =
> +					/bits/ 64 <400000000>;
> +			};
> +		};
> +		/* Example: we have two cameras */

What determines which one is active? The documentation above states there
may only be a single endpoint per port. And a single port only, not two as
you have here.

> +		port@1 {
> +			sensor_in0: endpoint@0 {
> +				remote-endpoint = <&sensor_out0>;
> +			};
> +			sensor_in1: endpoint@1 {
> +				remote-endpoint = <&sensor_out1>;
> +			};
> +		};
> +	};
> +};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2a98e3..04d227b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -141,6 +141,7 @@ M:	Leo Wen <leo.wen@rock-chips.com>
>  S:	Maintained
>  F:	drivers/media/spi/rk1608.c
>  F:	drivers/media/spi/rk1608.h
> +F:	Documentation/devicetree/bindings/media/rk1608.txt
>  
>  3C59X NETWORK DRIVER
>  M:	Steffen Klassert <klassert@mathematik.tu-chemnitz.de>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
