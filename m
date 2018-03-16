Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:38881 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbeCPAlE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 20:41:04 -0400
Received: by mail-lf0-f67.google.com with SMTP id y2-v6so10748583lfc.5
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2018 17:41:03 -0700 (PDT)
Date: Fri, 16 Mar 2018 01:41:00 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v6 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 TX
 Device Tree bindings
Message-ID: <20180316004100.GE3432@bigcity.dyn.berto.se>
References: <20180314131602.1531-1-maxime.ripard@bootlin.com>
 <20180314131602.1531-2-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180314131602.1531-2-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thanks for your patch,

On 2018-03-14 14:16:01 +0100, Maxime Ripard wrote:
> The Cadence MIPI-CSI2 TX controller is a CSI2 bridge that supports up to 4
> video streams and can output on up to 4 CSI-2 lanes, depending on the
> hardware implementation.
> 
> It can operate with an external D-PHY, an internal one or no D-PHY at all
> in some configurations.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Reviewed-by: Niklas S�derlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  .../devicetree/bindings/media/cdns,csi2tx.txt      | 98 ++++++++++++++++++++++
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
> 2.14.3
> 

-- 
Regards,
Niklas S�derlund
