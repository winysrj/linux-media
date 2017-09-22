Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43608 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751931AbdIVLf1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 07:35:27 -0400
Date: Fri, 22 Sep 2017 14:35:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com
Subject: Re: [PATCH v4 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 RX
 Device Tree bindings
Message-ID: <20170922113522.4nbls3bb3sglsu55@valkosipuli.retiisi.org.uk>
References: <20170922100823.18184-1-maxime.ripard@free-electrons.com>
 <20170922100823.18184-2-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922100823.18184-2-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Fri, Sep 22, 2017 at 12:08:22PM +0200, Maxime Ripard wrote:
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
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  .../devicetree/bindings/media/cdns,csi2rx.txt      | 97 ++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2rx.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/cdns,csi2rx.txt b/Documentation/devicetree/bindings/media/cdns,csi2rx.txt
> new file mode 100644
> index 000000000000..e9c30f964a96
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/cdns,csi2rx.txt
> @@ -0,0 +1,97 @@
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
> +  - phy-names: must contain dphy, if the implementation uses an
> +               external D-PHY
> +
> +Required subnodes:
> +  - ports: A ports node with one port child node per device input and output
> +           port, in accordance with the video interface bindings defined in
> +           Documentation/devicetree/bindings/media/video-interfaces.txt. The
> +           port nodes numbered as follows.
> +
> +           Port Description
> +           -----------------------------
> +           0    CSI-2 input
> +           1    Stream 0 output
> +           2    Stream 1 output
> +           3    Stream 2 output
> +           4    Stream 3 output
> +
> +           The stream output port nodes are optional if they are not connected
> +           to anything at the hardware level or implemented in the design.

Could you add supported endpoint numbers, please?

<URL:https://patchwork.linuxtv.org/patch/44409/>

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
> 2.13.5
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
