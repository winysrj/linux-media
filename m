Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34387 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbdCOSfT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 14:35:19 -0400
Date: Wed, 15 Mar 2017 13:35:15 -0500
From: Rob Herring <robh@kernel.org>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, CARLOS.PALMINHA@synopsys.com,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Benoit Parrot <bparrot@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Kamil Debski <k.debski@samsung.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Peter Griffin <peter.griffin@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Simon Horman <simon.horman@netronome.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: Re: [PATCH 3/4] Documentation: dt: Add bindings documentation for
 CSI-2 Host Video Platform
Message-ID: <20170315183515.qnai3fwrdqobn6ky@rob-hp-laptop>
References: <cover.1488885081.git.roliveir@synopsys.com>
 <95825021f5eae29a118ce0a2570c5c1886023110.1488885081.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95825021f5eae29a118ce0a2570c5c1886023110.1488885081.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 07, 2017 at 02:37:50PM +0000, Ramiro Oliveira wrote:
> Create device tree bindings documentation for the CSI-2 Host Video
>  platform.
> 
> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> ---
>  .../devicetree/bindings/media/snps,plat-csi2.txt   | 77 ++++++++++++++++++++++
>  1 file changed, 77 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/snps,plat-csi2.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/snps,plat-csi2.txt b/Documentation/devicetree/bindings/media/snps,plat-csi2.txt
> new file mode 100644
> index 000000000000..f559257a0a44
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/snps,plat-csi2.txt
> @@ -0,0 +1,77 @@
> +Synopsys DesignWare CSI-2 Host Video Platform
> +
> +The Synopsys DesignWare CSI-2 Host Video Device subsystem comprises of multiple
> +sub-devices represented by separate device tree nodes. Currently this includes:
> +plat-csi2, video-device, and dw-mipi-csi.
> +
> +The sub-subdevices are defined as child nodes of the common 'camera'.
> +
> +Common 'camera' node
> +--------------------
> +
> +Required properties:
> +
> +- compatible: must be "snps,plat-csi2", "simple-bus"
> +
> +The 'camera' node must include at least one 'video-device' and one 'dw-mipi-csi'
> +child node.
> +
> +'video-device' device nodes
> +-------------------
> +
> +Required properties:
> +
> +- compatible: "snps,video-device"
> +- dmas, dma-names: List of one DMA specifier and identifier string (as defined
> +  in Documentation/devicetree/bindings/dma/dma.txt) per port. Each port
> +  requires a DMA channel with the identifier string set to "vdma" followed by
> +  the port index.
> +
> +Image sensor nodes
> +------------------
> +
> +The sensor device nodes should be added to their control bus controller (e.g.
> +I2C0) nodes and linked to a port node in the dw-mipi-csi,using the common video
> +interfaces bindings, defined in video-interfaces.txt.
> +
> +Example:
> +
> +
> +	camera {
> +		compatible = "snps,plat-csi2", "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +			video_device: video-device@0x10000 {

Drop the '0x' and any leading 0s on unit addresses.

> +				compatible = "snps,video-device";
> +				dmas = <&axi_vdma_0 0>;
> +				dma-names = "vdma0";
> +			};

If video-device is not a real device, then you shouldn't need a DT node. 
I need a better explanation or diagram of what the h/w blocks and 
connections look like here.

>From the looks of this, you can just move dmas to the csi2 node. But I 
don't think that is right, because you can't generally just use an 
external DMA controller with camera data (maybe for validation, but it's 
not something you see in SoCs).

> +
> +			csi2:	csi2@0x03000 {
> +				compatible = "snps,dw-mipi-csi";
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				reg = < 0x03000 0x7FF>;
> +				interrupts = <2>;
> +				phys = <&mipi_phy_ctrl1 0>;
> +				resets = <&csi2_rst 1>;
> +
> +				output-type = <2>;
> +				ipi-mode = <0>;
> +				ipi-color-mode = <0>;
> +				ipi-auto-flush = <1>;
> +				virtual-channel = <0>;
> +
> +				port@1 {
> +					reg = <1>;
> +					csi1_ep1: endpoint {
> +						remote-endpoint = <&camera>;
> +						data-lanes = <1 2>;
> +					};
> +				};
> +			};
> +		};
> +	};
> +
> +The dw-mipi-csi device binding is defined in snps,dw-mipi-csi.txt.
> -- 
> 2.11.0
> 
> 
