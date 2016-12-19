Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36800 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932401AbcLSRsz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 12:48:55 -0500
Date: Mon, 19 Dec 2016 11:48:52 -0600
From: Rob Herring <robh@kernel.org>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        geert+renesas@glider.be, akpm@linux-foundation.org,
        linux@roeck-us.net, hverkuil@xs4all.nl,
        dheitmueller@kernellabs.com, slongerbeam@gmail.com,
        lars@metafoo.de, robert.jarzmik@free.fr, pavel@ucw.cz,
        pali.rohar@gmail.com, sakari.ailus@linux.intel.com,
        mark.rutland@arm.com, CARLOS.PALMINHA@synopsys.com
Subject: Re: [PATCH v6 1/2] Add OV5647 device tree documentation
Message-ID: <20161219174852.bmeocz7g4i5k26i4@rob-hp-laptop>
References: <cover.1481639091.git.roliveir@synopsys.com>
 <c47834c1c9c2a8e23f41a12c8717601f4a901506.1481639091.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c47834c1c9c2a8e23f41a12c8717601f4a901506.1481639091.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 13, 2016 at 02:32:36PM +0000, Ramiro Oliveira wrote:
> Create device tree bindings documentation.
> 
> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> ---
>  .../devicetree/bindings/media/i2c/ov5647.txt       | 35 ++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> new file mode 100644
> index 0000000..46e5e30
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> @@ -0,0 +1,35 @@
> +Omnivision OV5647 raw image sensor
> +---------------------------------
> +
> +OV5647 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
> +and CCI (I2C compatible) control bus.
> +
> +Required properties:
> +
> +- compatible	: "ovti,ov5647";
> +- reg		: I2C slave address of the sensor;
> +- clocks	: Reference to the xclk clock.
> +- clock-names	: Should be "xclk".
> +- clock-frequency: Frequency of the xclk clock
> +
> +The common video interfaces bindings (see video-interfaces.txt) should be
> +used to specify link to the image data receiver. The OV5647 device
> +node should contain one 'port' child node with an 'endpoint' subnode.

Would be good to add optional regulator supply properties, but that can 
come later.

> +
> +Example:
> +
> +	i2c@0x02000 {

No '0x' or leading 0s on unit addresses.

> +		...
> +		ov: camera@0x36 {

ditto.

> +			compatible = "ovti,ov5647";
> +			reg = <0x36>;
> +			clocks = <&camera_clk>;
> +			clock-names = "xclk";
> +			clock-frequency = <30000000>;
> +			port {
> +				camera_1: endpoint {
> +					remote-endpoint = <&csi1_ep1>;
> +				};
> +			};
> +		};
> +	};
> -- 
> 2.10.2
> 
> 
