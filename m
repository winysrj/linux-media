Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42115 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932145AbaBUPnP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Feb 2014 10:43:15 -0500
Date: Fri, 21 Feb 2014 15:42:41 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"kgene.kim@samsung.com" <kgene.kim@samsung.com>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>
Subject: Re: [PATCH v4 02/10] Documentation: dt: Add DT binding
 documentation for S5C73M3 camera
Message-ID: <20140221154240.GE20449@e106331-lin.cambridge.arm.com>
References: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
 <1392925237-31394-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392925237-31394-4-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 20, 2014 at 07:40:29PM +0000, Sylwester Nawrocki wrote:
> This adds DT binding documentation for Samsung S5C73M3 camera sensor
> with an embedded ISP.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes since v3:
>  - DT binding documentation separated into this patch;
> 
> Changes since v2:
>  - rephrased 'clocks' and 'clock-names' properties' description;
> ---
>  .../devicetree/bindings/media/samsung-s5c73m3.txt  |   97 ++++++++++++++++++++
>  1 file changed, 97 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt b/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
> new file mode 100644
> index 0000000..4dd3776
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
> @@ -0,0 +1,97 @@
> +Samsung S5C73M3 8Mp camera ISP
> +------------------------------
> +
> +The S5C73M3 camera ISP supports MIPI CSI-2 and parallel (ITU-R BT.656) video
> +data busses. The I2C bus is the main control bus and additionally the SPI bus
> +is used, mostly for transferring the firmware to and from the device. Two
> +slave device nodes corresponding to these control bus interfaces are required
> +and should be placed under respective bus controller nodes.

So this has both an I2C interface and an SPI interface that are used at
the same time?

> +
> +I2C slave device node
> +---------------------
> +
> +Required properties:
> +
> +- compatible	    : "samsung,s5c73m3";
> +- reg		    : I2C slave address of the sensor;
> +- vdd-int-supply    : digital power supply (1.2V);
> +- vdda-supply	    : analog power supply (1.2V);
> +- vdd-reg-supply    : regulator input power supply (2.8V);
> +- vddio-host-supply : host I/O power supply (1.8V to 2.8V);
> +- vddio-cis-supply  : CIS I/O power supply (1.2V to 1.8V);
> +- vdd-af-supply     : lens power supply (2.8V);
> +- xshutdown-gpios   : specifier of GPIO connected to the XSHUTDOWN pin;
> +- standby-gpios     : specifier of GPIO connected to the STANDBY pin;
> +- clocks	    : should contain list of phandle and clock specifier pairs
> +		      according to common clock bindings for the clocks described
> +		      in the clock-names property;
> +- clock-names	    : should contain "cis_extclk" entry for the CIS_EXTCLK clock;
> +
> +Optional properties:
> +
> +- clock-frequency   : the frequency at which the "cis_extclk" clock should be
> +		      configured to operate, in Hz; if this property is not
> +		      specified default 24 MHz value will be used.
> +
> +The common video interfaces bindings (see video-interfaces.txt) should be used
> +to specify link from the S5C73M3 to an external image data receiver. The S5C73M3
> +device node should contain one 'port' child node with an 'endpoint' subnode for
> +this purpose. The data link from a raw image sensor to the S5C73M3 can be
> +similarly specified, but it is optional since the S5C73M3 ISP and a raw image
> +sensor are usually inseparable and form a hybrid module.
> +
> +Following properties are valid for the endpoint node(s):
> +
> +endpoint subnode
> +----------------
> +
> +- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
> +  video-interfaces.txt. This sensor doesn't support data lane remapping
> +  and physical lane indexes in subsequent elements of the array should
> +  be only consecutive ascending values.
> +
> +SPI device node
> +---------------
> +
> +Required properties:
> +
> +- compatible	    : "samsung,s5c73m3";

It might make sense to explicitly link these two nodes somehow, in case
multiple instances appear somewhere. However, that can come later in the
case of a multi-instance device, and isn't necessary now.

> +
> +For more details see description of the SPI busses bindings
> +(../spi/spi-bus.txt) and bindings of a specific bus controller.
> +
> +Example:
> +
> +i2c@138A000000 {
> +	...
> +	s5c73m3@3c {
> +		compatible = "samsung,s5c73m3";
> +		reg = <0x3c>;
> +		vdd-int-supply = <&buck9_reg>;
> +		vdda-supply = <&ldo17_reg>;
> +		vdd-reg-supply = <&cam_io_reg>;
> +		vddio-host-supply = <&ldo18_reg>;
> +		vddio-cis-supply = <&ldo9_reg>;
> +		vdd-af-supply = <&cam_af_reg>;
> +		clock-frequency = <24000000>;
> +		clocks = <&clk 0>;
> +		clock-names = "cis_extclk";
> +		reset-gpios = <&gpf1 3 1>;
> +		standby-gpios = <&gpm0 1 1>;
> +		port {
> +			s5c73m3_ep: endpoint {
> +				remote-endpoint = <&csis0_ep>;
> +				data-lanes = <1 2 3 4>;
> +			};
> +		};
> +	};
> +};
> +
> +spi@1392000 {
> +	...
> +	s5c73m3_spi: s5c73m3 {

Nit: this should have a 0 unit-address to match the reg.

> +		compatible = "samsung,s5c73m3";
> +		reg = <0>;
> +		...
> +	};
> +};

Otherwise I don't see anything problematic about the binding.

Acked-by: Mark Rutland <mark.rutland@arm.com>

Cheers,
Mark.
