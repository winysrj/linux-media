Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40266 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750777AbdFONAE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 09:00:04 -0400
Date: Thu, 15 Jun 2017 15:59:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [RFC 1/2] [media] dt-bindings: Document BCM283x CSI2/CCP2
 receiver
Message-ID: <20170615125958.GE12407@valkosipuli.retiisi.org.uk>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <888a28269a8a7c22feb2a126db699b1259d1b457.1497452006.git.dave.stevenson@raspberrypi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <888a28269a8a7c22feb2a126db699b1259d1b457.1497452006.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

Thanks for the set!

On Wed, Jun 14, 2017 at 04:15:46PM +0100, Dave Stevenson wrote:
> Document the DT bindings for the CSI2/CCP2 receiver peripheral
> (known as Unicam) on BCM283x SoCs.
> 
> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
> ---
>  .../devicetree/bindings/media/bcm2835-unicam.txt   | 76 ++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/bcm2835-unicam.txt b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
> new file mode 100644
> index 0000000..cc5a451
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
> @@ -0,0 +1,76 @@
> +Broadcom BCM283x Camera Interface (Unicam)
> +------------------------------------------
> +
> +The Unicam block on BCM283x SoCs is the receiver for either
> +CSI-2 or CCP2 data from image sensors or similar devices.
> +
> +Required properties:
> +===================
> +- compatible	: must be "brcm,bcm2835-unicam".
> +- reg		: physical base address and length of the register sets for the
> +		  device.
> +- interrupts	: should contain the IRQ line for this Unicam instance.
> +- clocks	: list of clock specifiers, corresponding to entries in
> +		  clock-names property.
> +- clock-names	: must contain an "lp_clock" entry, matching entries
> +		  in the clocks property.
> +
> +Optional properties
> +===================
> +- max-data-lanes: the hardware can support varying numbers of clock lanes.
> +		  This value is the maximum number supported by this instance.
> +		  Known values of 2 or 4. Default is 2.

Please use "data-lanes" endpoint property instead. This is the number of
connected physical lanes and specific to the hardware.

Could you also document which endpoint properties are mandatory and which
ones optional?

> +
> +
> +Unicam supports a single port node. It should contain one 'port' child node
> +with child 'endpoint' node. Please refer to the bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +	csi1: csi@7e801000 {
> +		compatible = "brcm,bcm2835-unicam";
> +		reg = <0x7e801000 0x800>,
> +		      <0x7e802004 0x4>;
> +		interrupts = <2 7>;
> +		clocks = <&clocks BCM2835_CLOCK_CAM1>;
> +		clock-names = "lp_clock";
> +
> +		port {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			endpoint {
> +				remote-endpoint = <&tc358743_0>;
> +

Extra newline. Don't you need any other properties here?

> +			};
> +		};
> +	};
> +
> +	i2c0: i2c@7e205000 {
> +
> +		tc358743: tc358743@0f {
> +			compatible = "toshiba,tc358743";
> +			reg = <0x0f>;
> +			status = "okay";
> +
> +			clocks = <&tc358743_clk>;
> +			clock-names = "refclk";
> +
> +			tc358743_clk: bridge-clk {
> +				compatible = "fixed-clock";
> +				#clock-cells = <0>;
> +				clock-frequency = <27000000>;
> +			};
> +
> +			port {
> +				tc358743_0: endpoint {
> +					remote-endpoint = <&csi1>;

This one needs to refer to the endpoint, just as the one in the CSI-2
receiver does.

> +					clock-lanes = <0>;
> +					data-lanes = <1 2 3 4>;
> +					clock-noncontinuous;
> +					link-frequencies =
> +						/bits/ 64 <297000000>;
> +				};
> +			};
> +		};
> +	};

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
