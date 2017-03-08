Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37166 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753318AbdCHN1W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 08:27:22 -0500
Date: Wed, 8 Mar 2017 15:18:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
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
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: Re: [PATCH 3/4] Documentation: dt: Add bindings documentation for
 CSI-2 Host Video Platform
Message-ID: <20170308131824.GK3220@valkosipuli.retiisi.org.uk>
References: <cover.1488885081.git.roliveir@synopsys.com>
 <95825021f5eae29a118ce0a2570c5c1886023110.1488885081.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95825021f5eae29a118ce0a2570c5c1886023110.1488885081.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On Tue, Mar 07, 2017 at 02:37:50PM +0000, Ramiro Oliveira wrote:
> Create device tree bindings documentation for the CSI-2 Host Video
>  platform.

Extra space here.

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

You should defined which properties you explicitly support on endpoints and
elsewhere. There are some optional ones for CSI-2, for instance.

> +
> +Example:
> +
> +
> +	camera {
> +		compatible = "snps,plat-csi2", "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;

Is there something missing here?

> +			video_device: video-device@0x10000 {
> +				compatible = "snps,video-device";
> +				dmas = <&axi_vdma_0 0>;
> +				dma-names = "vdma0";
> +			};
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

What are the valid ports for this device?

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

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
