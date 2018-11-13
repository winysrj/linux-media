Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:39423 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730736AbeKMSgL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 13:36:11 -0500
Date: Tue, 13 Nov 2018 10:38:55 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH 1/5] dt-bindings: media: Add Allwinner A10 CSI binding
Message-ID: <20181113083855.s5jxrb32ru3myu3t@kekkonen.localdomain>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <60494dd4245ab01473d074dc5cd46198a2181614.1542097288.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60494dd4245ab01473d074dc5cd46198a2181614.1542097288.git-series.maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Tue, Nov 13, 2018 at 09:24:13AM +0100, Maxime Ripard wrote:
> The Allwinner A10 CMOS Sensor Interface is a camera capture interface also
> used in later (A10s, A13, A20, R8 and GR8) SoCs.
> 
> On some SoCs, like the A10, there's multiple instances of that controller,
> with one instance supporting more channels and having an ISP.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/media/sun4i-csi.txt | 71 ++++++++++++-
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/sun4i-csi.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/sun4i-csi.txt b/Documentation/devicetree/bindings/media/sun4i-csi.txt
> new file mode 100644
> index 000000000000..3d96bcbef9d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/sun4i-csi.txt
> @@ -0,0 +1,71 @@
> +Allwinner A10 CMOS Sensor Interface
> +-------------------------------------
> +
> +The Allwinner A10 SoC features two camera capture interfaces, one
> +featuring an ISP and the other without. Later SoCs built upon that
> +design and used similar SoCs.
> +
> +Required properties:
> +  - compatible: value must be one of:
> +    * allwinner,sun4i-a10-csi
> +    * allwinner,sun5i-a13-csi, allwinner,sun4i-a10-csi
> +    * allwinner,sun7i-a20-csi, allwinner,sun4i-a10-csi
> +  - reg: base address and size of the memory-mapped region.
> +  - interrupts: interrupt associated to this IP
> +  - clocks: phandles to the clocks feeding the CSI
> +    * ahb: the CSI interface clock
> +    * mod: the CSI module clock
> +    * ram: the CSI DRAM clock
> +  - clock-names: the clock names mentioned above
> +  - resets: phandles to the reset line driving the CSI
> +
> +Optional properties:
> +  - allwinner,csi-channels: Number of channels available in the CSI
> +                            controller. If not present, the default
> +                            will be 1.
> +  - allwinner,has-isp: Whether the CSI controller has an ISP
> +                       associated to it or not

Is the ISP a part of the same device? It sounds like that this is actually
a different device if it contains an ISP as well, and that should be
apparent from the compatible string. What do you think?

> +
> +If allwinner,has-isp is set, an additional "isp" clock is needed,
> +being a phandle to the clock driving the ISP.
> +
> +The CSI node should contain one 'port' child node with one child
> +'endpoint' node, according to the bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt. The
> +endpoint's bus type must be parallel or BT656.
> +
> +Endpoint node properties for CSI
> +---------------------------------
> +
> +- remote-endpoint	: (required) a phandle to the bus receiver's endpoint
> +			   node

Rob's opinion has been (AFAIU) that this is not needed as it's already a
part of the graph bindings. Unless you want to say that it's required, that
is --- the graph bindings document it as optional.

> +- bus-width:		: (required) must be 8

If this is the only value the hardware supports, I don't see why you should
specify it here.

> +- pclk-sample		: (optional) (default: sample on falling edge)
> +- hsync-active		: (only required for parallel)
> +- vsync-active		: (only required for parallel)
> +
> +Example:
> +
> +csi0: csi@1c09000 {
> +	compatible = "allwinner,sun7i-a20-csi",
> +		     "allwinner,sun4i-a10-csi";
> +	reg = <0x01c09000 0x1000>;
> +	interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
> +	clocks = <&ccu CLK_AHB_CSI0>, <&ccu CLK_CSI0>,
> +		 <&ccu CLK_CSI_SCLK>, <&ccu CLK_DRAM_CSI0>;
> +	clock-names = "ahb", "mod", "isp", "ram";
> +	resets = <&ccu RST_CSI0>;
> +	allwinner,csi-channels = <4>;
> +	allwinner,has-isp;
> +	
> +	port {
> +		csi_from_ov5640: endpoint {
> +                        remote-endpoint = <&ov5640_to_csi>;
> +                        bus-width = <8>;
> +                        data-shift = <2>;

data-shift needs to be documented above if it's relevant for the device.

> +                        hsync-active = <1>; /* Active high */
> +                        vsync-active = <0>; /* Active low */
> +                        pclk-sample = <1>;  /* Rising */
> +                };
> +	};
> +};

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
