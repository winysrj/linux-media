Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43724 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050AbaLAKmN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 05:42:13 -0500
Date: Mon, 1 Dec 2014 10:42:01 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [REVIEW PATCH v2.1 08/11] of: smiapp: Add documentation
Message-ID: <20141201104200.GC17070@leverpostej>
References: <1416289426-804-9-git-send-email-sakari.ailus@iki.fi>
 <1417364809-4693-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417364809-4693-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 30, 2014 at 04:26:48PM +0000, Sakari Ailus wrote:
> Document the smiapp device tree properties.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> since v2:
> - Cleanups
> - Removed clock-names property documentation
> - Port node documentation was really endpoint node documentation
> - Added remote-endpoint as mandatory endpoint node properties
> 
>  .../devicetree/bindings/media/i2c/nokia,smia.txt   |   64 ++++++++++++++++++++
>  MAINTAINERS                                        |    1 +
>  2 files changed, 65 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> new file mode 100644
> index 0000000..2114a4d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> @@ -0,0 +1,64 @@
> +SMIA/SMIA++ sensor
> +
> +SMIA (Standard Mobile Imaging Architecture) is an image sensor standard
> +defined jointly by Nokia and ST. SMIA++, defined by Nokia, is an extension
> +of that. These definitions are valid for both types of sensors.
> +
> +More detailed documentation can be found in
> +Documentation/devicetree/bindings/media/video-interfaces.txt .
> +
> +
> +Mandatory properties
> +--------------------
> +
> +- compatible: "nokia,smia"
> +- reg: I2C address (0x10, or an alternative address)
> +- vana-supply: Analogue voltage supply (VANA), typically 2,8 volts (sensor
> +  dependent).
> +- clocks: External clock phandle

Not just a phandle, there's a clock-specifier too.

Just describe what the clock logically is, don't bother with describing
the format of the property (whcih is standardised elsewhere).

> +- clock-frequency: Frequency of the external clock to the sensor

Is this the preferred frequency to operate the device at? Is there not a
standard frequency to use? We can query the rate from the clock
otherwise.

> +- link-frequency: List of allowed data link frequencies. An array of 64-bit
> +  elements.

Something like 'allowed-link-frequencies' might be better, unlesss this
is derived from another binding?

> +
> +
> +Optional properties
> +-------------------
> +
> +- nokia,nvm-size: The size of the NVM, in bytes. If the size is not given,
> +  the NVM contents will not be read.

Where 'NVM' standas for what?

What is this used for?

> +- reset-gpios: XSHUTDOWN GPIO
> +
> +
> +Endpoint node mandatory properties
> +----------------------------------
> +
> +- clock-lanes: <0>
> +- data-lanes: <1..n>
> +- remote-endpoint: A phandle to the bus receiver's endpoint node.
> +
> +
> +Example
> +-------
> +
> +&i2c2 {
> +	clock-frequency = <400000>;
> +
> +	smiapp_1: camera@10 {
> +		compatible = "nokia,smia";
> +		reg = <0x10>;
> +		reset-gpios = <&gpio3 20 0>;
> +		vana-supply = <&vaux3>;
> +		clocks = <&omap3_isp 0>;
> +		clock-names = "ext_clk";

This wasn't described above. Either mandate it in the binding (and
define clock in terms of clock-names) or drop it.

Thanks,
Mark.

> +		clock-frequency = <9600000>;
> +		nokia,nvm-size = <512>; /* 8 * 64 */
> +		link-frequency = /bits/ 64 <199200000 210000000 499200000>;
> +		port {
> +			smiapp_1_1: endpoint {
> +				clock-lanes = <0>;
> +				data-lanes = <1 2>;
> +				remote-endpoint = <&csi2a_ep>;
> +			};
> +		};
> +	};
> +};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2378a5f..285c1ba 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8619,6 +8619,7 @@ F:	include/media/smiapp.h
>  F:	drivers/media/i2c/smiapp-pll.c
>  F:	drivers/media/i2c/smiapp-pll.h
>  F:	include/uapi/linux/smiapp.h
> +F:	Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
>  
>  SMM665 HARDWARE MONITOR DRIVER
>  M:	Guenter Roeck <linux@roeck-us.net>
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
