Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33601 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbeC2NG6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 09:06:58 -0400
Received: by mail-lf0-f65.google.com with SMTP id x70-v6so1491149lfa.0
        for <linux-media@vger.kernel.org>; Thu, 29 Mar 2018 06:06:58 -0700 (PDT)
Date: Thu, 29 Mar 2018 15:06:55 +0200
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
Subject: Re: [PATCH v8 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 RX
 Device Tree bindings
Message-ID: <20180329130655.GC26532@bigcity.dyn.berto.se>
References: <20180215133335.9335-1-maxime.ripard@bootlin.com>
 <20180215133335.9335-2-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180215133335.9335-2-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thanks for your patch.

On 2018-02-15 14:33:34 +0100, Maxime Ripard wrote:
> The Cadence MIPI-CSI2 RX controller is a CSI2RX bridge that supports up to
> 4 CSI-2 lanes, and can route the frames to up to 4 streams, depending on
> the hardware implementation.
> 
> It can operate with an external D-PHY, an internal one or no D-PHY at all
> in some configurations.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Benoit Parrot <bparrot@ti.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Shall this file be added to MAINTAINERS? This can be done in a follow up 
patch, but if you respin please consider it.

Reviewed-by: Niklas S�derlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  .../devicetree/bindings/media/cdns,csi2rx.txt      | 100 +++++++++++++++++++++
>  1 file changed, 100 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2rx.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/cdns,csi2rx.txt b/Documentation/devicetree/bindings/media/cdns,csi2rx.txt
> new file mode 100644
> index 000000000000..6b02a0657ad9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/cdns,csi2rx.txt
> @@ -0,0 +1,100 @@
> +Cadence MIPI-CSI2 RX controller
> +===============================
> +
> +The Cadence MIPI-CSI2 RX controller is a CSI-2 bridge supporting up to 4 CSI
> +lanes in input, and 4 different pixel streams in output.
> +
> +Required properties:
> +  - compatible: must be set to "cdns,csi2rx" and an SoC-specific compatible
> +  - reg: base address and size of the memory mapped region
> +  - clocks: phandles to the clocks driving the controller
> +  - clock-names: must contain:
> +    * sys_clk: main clock
> +    * p_clk: register bank clock
> +    * pixel_if[0-3]_clk: pixel stream output clock, one for each stream
> +                         implemented in hardware, between 0 and 3
> +
> +Optional properties:
> +  - phys: phandle to the external D-PHY, phy-names must be provided
> +  - phy-names: must contain "dphy", if the implementation uses an
> +               external D-PHY
> +
> +Required subnodes:
> +  - ports: A ports node with one port child node per device input and output
> +           port, in accordance with the video interface bindings defined in
> +           Documentation/devicetree/bindings/media/video-interfaces.txt. The
> +           port nodes are numbered as follows:
> +
> +           Port Description
> +           -----------------------------
> +           0    CSI-2 input
> +           1    Stream 0 output
> +           2    Stream 1 output
> +           3    Stream 2 output
> +           4    Stream 3 output
> +
> +           The stream output port nodes are optional if they are not
> +           connected to anything at the hardware level or implemented
> +           in the design.Since there is only one endpoint per port,
> +           the endpoints are not numbered.
> +
> +
> +Example:
> +
> +csi2rx: csi-bridge@0d060000 {
> +	compatible = "cdns,csi2rx";
> +	reg = <0x0d060000 0x1000>;
> +	clocks = <&byteclock>, <&byteclock>
> +		 <&coreclock>, <&coreclock>,
> +		 <&coreclock>, <&coreclock>;
> +	clock-names = "sys_clk", "p_clk",
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
> +			csi2rx_in_sensor: endpoint {
> +				remote-endpoint = <&sensor_out_csi2rx>;
> +				clock-lanes = <0>;
> +				data-lanes = <1 2>;
> +			};
> +		};
> +
> +		port@1 {
> +			reg = <1>;
> +
> +			csi2rx_out_grabber0: endpoint {
> +				remote-endpoint = <&grabber0_in_csi2rx>;
> +			};
> +		};
> +
> +		port@2 {
> +			reg = <2>;
> +
> +			csi2rx_out_grabber1: endpoint {
> +				remote-endpoint = <&grabber1_in_csi2rx>;
> +			};
> +		};
> +
> +		port@3 {
> +			reg = <3>;
> +
> +			csi2rx_out_grabber2: endpoint {
> +				remote-endpoint = <&grabber2_in_csi2rx>;
> +			};
> +		};
> +
> +		port@4 {
> +			reg = <4>;
> +
> +			csi2rx_out_grabber3: endpoint {
> +				remote-endpoint = <&grabber3_in_csi2rx>;
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
