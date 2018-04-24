Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:11936 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933839AbeDXNSU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 09:18:20 -0400
Date: Tue, 24 Apr 2018 08:18:03 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, <nm@ti.com>,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v11 3/4] dt-bindings: media: Add Cadence MIPI-CSI2 TX
 Device Tree bindings
Message-ID: <20180424131802.GH3629@ti.com>
References: <20180424122700.5387-1-maxime.ripard@bootlin.com>
 <20180424122700.5387-4-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180424122700.5387-4-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Benoit Parrot <bparrot@ti.com>

Maxime Ripard <maxime.ripard@bootlin.com> wrote on Tue [2018-Apr-24 14:26:59 +0200]:
> The Cadence MIPI-CSI2 TX controller is a CSI2 bridge that supports up to 4
> video streams and can output on up to 4 CSI-2 lanes, depending on the
> hardware implementation.
> 
> It can operate with an external D-PHY, an internal one or no D-PHY at all
> in some configurations.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  .../devicetree/bindings/media/cdns,csi2tx.txt | 98 +++++++++++++++++++
>  1 file changed, 98 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2tx.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/cdns,csi2tx.txt b/Documentation/devicetree/bindings/media/cdns,csi2tx.txt
> new file mode 100644
> index 000000000000..459c6e332f52
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
> +  - phy-names: must contain "dphy"
> +
> +Required subnodes:
> +  - ports: A ports node with one port child node per device input and output
> +           port, in accordance with the video interface bindings defined in
> +           Documentation/devicetree/bindings/media/video-interfaces.txt. The
> +           port nodes are numbered as follows.
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
> +           in the design. Since there is only one endpoint per port,
> +           the endpoints are not numbered.
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
> -- 
> 2.17.0
> 
