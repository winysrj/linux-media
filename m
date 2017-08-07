Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42483 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751860AbdHGURt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 16:17:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 RX Device Tree bindings
Date: Mon, 07 Aug 2017 23:18:03 +0300
Message-ID: <2362756.VjbdGaYBzu@avalon>
In-Reply-To: <20170720092302.2982-2-maxime.ripard@free-electrons.com>
References: <20170720092302.2982-1-maxime.ripard@free-electrons.com> <20170720092302.2982-2-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thank you for the patch.

On Thursday 20 Jul 2017 11:23:01 Maxime Ripard wrote:
> The Cadence MIPI-CSI2 RX controller is a CSI2RX bridge that supports up to
> 4 CSI-2 lanes, and can route the frames to up to 4 streams, depending on
> the hardware implementation.
> 
> It can operate with an external D-PHY, an internal one or no D-PHY at all
> in some configurations.

Without any PHY ? I'm curious, how does that work ?

> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  .../devicetree/bindings/media/cdns-csi2rx.txt      | 87 ++++++++++++++++++
>  1 file changed, 87 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt new file mode
> 100644
> index 000000000000..e08547abe885
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> @@ -0,0 +1,87 @@
> +Cadence MIPI-CSI2 RX controller
> +===============================
> +
> +The Cadence MIPI-CSI2 RX controller is a CSI-2 bridge supporting up to 4
> CSI
> +lanes in input, and 4 different pixel streams in output.
> +
> +Required properties:
> +  - compatible: must be set to "cdns,csi2rx" and an SoC-specific compatible
> +  - reg: base address and size of the memory mapped region
> +  - clocks: phandles to the clocks driving the controller
> +  - clock-names: must contain:
> +    * sys_clk: main clock
> +    * p_clk: register bank clock
> +    * p_free_clk: free running register bank clock
> +    * pixel_ifX_clk: pixel stream output clock, one for each stream
> +                     implemented in hardware, between 0 and 3

Nitpicking, I would write the name is pixel_if[0-3]_clk, it took me a few 
seconds to see that the X was a placeholder.

> +    * dphy_rx_clk: D-PHY byte clock, if implemented in hardware
> +  - phys: phandle to the external D-PHY
> +  - phy-names: must contain dphy, if the implementation uses an
> +               external D-PHY

I would move the last two properties in an optional category as they're 
effectively optional. I think you should also explain a bit more clearly that 
the phys property must not be present if the phy-names property is not 
present.

> +
> +Required subnodes:
> +  - ports: A ports node with endpoint definitions as defined in
> +           Documentation/devicetree/bindings/media/video-interfaces.txt.
> The
> +           first port subnode should be the input endpoint, the second one
> the
> +           outputs
> +
> +  The output port should have as many endpoints as stream supported by
> +  the hardware implementation, between 1 and 4, their ID being the
> +  stream output number used in the implementation.

I don't think that's correct. The IP has four independent outputs, it should 
have 4 output ports for a total for 5 ports. Multiple endpoints per port would 
describe multiple connections from the same output to different sinks.

> +Example:
> +
> +csi2rx: csi-bridge@0d060000 {
> +	compatible = "cdns,csi2rx";
> +	reg = <0x0d060000 0x1000>;
> +	clocks = <&byteclock>, <&byteclock>, <&byteclock>,
> +		 <&coreclock>, <&coreclock>,
> +		 <&coreclock>, <&coreclock>;
> +	clock-names = "sys_clk", "p_clk", "p_free_clk",
> +		      "pixel_if0_clk", "pixel_if1_clk",
> +		      "pixel_if2_clk", "pixel_if3_clk";
> +
> +	ports {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		port@0 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0>;
> +
> +			csi2rx_in_sensor: endpoint@0 {
> +				reg = <0>;
> +				remote-endpoint = <&sensor_out_csi2rx>;
> +				clock-lanes = <0>;
> +				data-lanes = <1 2>;
> +			};
> +		};
> +
> +		port@1 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <1>;
> +
> +			csi2rx_out_grabber0: endpoint@0 {
> +				reg = <0>;
> +				remote-endpoint = <&grabber0_in_csi2rx>;
> +			};
> +
> +			csi2rx_out_grabber1: endpoint@1 {
> +				reg = <1>;
> +				remote-endpoint = <&grabber1_in_csi2rx>;
> +			};
> +
> +			csi2rx_out_grabber2: endpoint@2 {
> +				reg = <2>;
> +				remote-endpoint = <&grabber2_in_csi2rx>;
> +			};
> +
> +			csi2rx_out_grabber3: endpoint@3 {
> +				reg = <3>;
> +				remote-endpoint = <&grabber3_in_csi2rx>;
> +			};
> +		};
> +	};
> +};

-- 
Regards,

Laurent Pinchart
