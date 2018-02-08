Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49899 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeBHS7v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 13:59:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 TX Device Tree bindings
Date: Thu, 08 Feb 2018 21:00:19 +0200
Message-ID: <2476247.yR0nrT2UBg@avalon>
In-Reply-To: <20180207142643.15746-2-maxime.ripard@bootlin.com>
References: <20180207142643.15746-1-maxime.ripard@bootlin.com> <20180207142643.15746-2-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thank you for the patch.

On Wednesday, 7 February 2018 16:26:42 EET Maxime Ripard wrote:
> The Cadence MIPI-CSI2 TX controller is a CSI2 bridge that supports up to 4
> video streams and can output on up to 4 CSI-2 lanes, depending on the
> hardware implementation.
> 
> It can operate with an external D-PHY, an internal one or no D-PHY at all
> in some configurations.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  .../devicetree/bindings/media/cdns,csi2tx.txt      | 98 +++++++++++++++++++
>  1 file changed, 98 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2tx.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/cdns,csi2tx.txt
> b/Documentation/devicetree/bindings/media/cdns,csi2tx.txt new file mode
> 100644
> index 000000000000..acbbd625a75f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/cdns,csi2tx.txt
> @@ -0,0 +1,98 @@
> +Cadence MIPI-CSI2 TX controller
> +===============================
> +
> +The Cadence MIPI-CSI2 TX controller is a CSI-2 bridge supporting up to
> +4 CSI lanes in output, and up to 4 different pixel streams in input.
> +
> +Required properties:
> +  - compatible: must be set to "cdns,csi2tx"
> +  - reg: base address and size of the memory mapped region
> +  - clocks: phandles to the clocks driving the controller
> +  - clock-names: must contain:
> +    * esc_clk: escape mode clock
> +    * p_clk: register bank clock
> +    * pixel_if[0-3]_clk: pixel stream output clock, one for each stream
> +                         implemented in hardware, between 0 and 3
> +
> +Optional properties
> +  - phys: phandle to the D-PHY. If it is set, phy-names need to be set
> +  - phy-names: must contain dphy

Nitpicking, I'd write "dphy" with double quotes.

> +Required subnodes:
> +  - ports: A ports node with one port child node per device input and
> output
> +           port, in accordance with the video interface bindings defined in
> +           Documentation/devicetree/bindings/media/video-interfaces.txt.
> The
> +           port nodes numbered as follows.

s/numbered/are numbered/

> +
> +           Port Description
> +           -----------------------------
> +           0    CSI-2 output
> +           1    Stream 0 input
> +           2    Stream 1 input
> +           3    Stream 2 input
> +           4    Stream 3 input
> +
> +           The stream input port nodes are optional if they are not
> +           connected to anything at the hardware level or implemented
> +           in the design.

Are they optional (and thus valid if present), or should they be forbidden in 
case they're not implemented in the hardware ? I'd go for the latter and write

"One stream input port node is required per implemented hardware input, and no 
stream input port node can be present for unimplemented inputs."

> Since there is only one endpoint per port,
> +           the endpoints are not numbered.

I think it would be valid to number endpoints even if not required. I think 
that what you should document is that at most one endpoint is supported per 
port.

> +
> +Example:
> +
> +csi2tx: csi-bridge@0d0e1000 {
> +	compatible = "cdns,csi2tx";
> +	reg = <0x0d0e1000 0x1000>;
> +	clocks = <&byteclock>, <&byteclock>,
> +		 <&coreclock>, <&coreclock>,
> +		 <&coreclock>, <&coreclock>;
> +	clock-names = "p_clk", "esc_clk",
> +		      "pixel_if0_clk", "pixel_if1_clk",
> +		      "pixel_if2_clk", "pixel_if3_clk";
> +
> +	ports {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		port@0 {
> +			reg = <0>;
> +
> +			csi2tx_out: endpoint {
> +				remote-endpoint = <&remote_in>;
> +				clock-lanes = <0>;
> +				data-lanes = <1 2>;
> +			};
> +		};
> +
> +		port@1 {
> +			reg = <1>;
> +
> +			csi2tx_in_stream0: endpoint {
> +				remote-endpoint = <&stream0_out>;
> +			};
> +		};
> +
> +		port@2 {
> +			reg = <2>;
> +
> +			csi2tx_in_stream1: endpoint {
> +				remote-endpoint = <&stream1_out>;
> +			};
> +		};
> +
> +		port@3 {
> +			reg = <3>;
> +
> +			csi2tx_in_stream2: endpoint {
> +				remote-endpoint = <&stream2_out>;
> +			};
> +		};
> +
> +		port@4 {
> +			reg = <4>;
> +
> +			csi2tx_in_stream3: endpoint {
> +				remote-endpoint = <&stream3_out>;
> +			};
> +		};
> +	};
> +};

-- 
Regards,

Laurent Pinchart
