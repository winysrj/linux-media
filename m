Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34166 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755881AbcLSRiq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 12:38:46 -0500
Date: Mon, 19 Dec 2016 11:38:43 -0600
From: Rob Herring <robh@kernel.org>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: mark.rutland@arm.com, mchehab@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, geert+renesas@glider.be,
        akpm@linux-foundation.org, linux@roeck-us.net, hverkuil@xs4all.nl,
        laurent.pinchart+renesas@ideasonboard.com, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, tiffany.lin@mediatek.com,
        minghsiu.tsai@mediatek.com, jean-christophe.trotin@st.com,
        andrew-ct.chen@mediatek.com, simon.horman@netronome.com,
        songjun.wu@microchip.com, bparrot@ti.com,
        CARLOS.PALMINHA@synopsys.com
Subject: Re: [PATCH v2 1/2] Add Documentation for Media Device, Video Device,
 and Synopsys DW MIPI CSI-2 Host
Message-ID: <20161219173843.tpljazh365zp7i4z@rob-hp-laptop>
References: <cover.1481548484.git.roliveir@synopsys.com>
 <48a46d2d60fff723e322fdbfb29d533c2d0f5637.1481554324.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48a46d2d60fff723e322fdbfb29d533c2d0f5637.1481554324.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 12, 2016 at 03:00:35PM +0000, Ramiro Oliveira wrote:
> Create device tree bindings documentation for Media and Video Device, as well
> as the DW MIPI CSI-2 Host.
> 
> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> ---
>  .../devicetree/bindings/media/snps,dw-mipi-csi.txt |  37 ++++++++
>  .../devicetree/bindings/media/snps,plat-ipk.txt    | 105 +++++++++++++++++++++
>  2 files changed, 142 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
>  create mode 100644 Documentation/devicetree/bindings/media/snps,plat-ipk.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt b/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
> new file mode 100644
> index 0000000..1caa652
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
> @@ -0,0 +1,37 @@
> +Synopsys DesignWare CSI-2 Host controller
> +
> +Description
> +-----------
> +
> +This HW block is used to receive image coming from an MIPI CSI-2 compatible
> +camera.
> +
> +Required properties:
> +- compatible: shall be "snps,dw-mipi-csi"

You don't have to add them, but this will need SoC specific compatible 
strings. Please add a note to that effect.

> +- reg		: physical base address and size of the device memory mapped
> +  registers;
> +- interrupts	: CSI-2 Host interrupt
> +- data-lanes    : Number of lanes to be used
> +- output-type   : Core output to be used (IPI-> 0 or IDI->1 or BOTH->2) These
> +  values choose which of the Core outputs will be used, it can be Image Data
> +  Interface or Image Pixel Interface.

This is output to a parallel camera interface (e.g. an SoC camera 
subsystem)? 

> +- phys, phy-names: List of one PHY specifier and identifier string (as defined
> +  in Documentation/devicetree/bindings/phy/phy-bindings.txt). This PHY is a MIPI
> +  DPHY working in RX mode.

phy-names is pointless when there is only 1.

> +
> +Optional properties(if in IPI mode):
> +- ipi-mode 	: Mode to be used when in IPI(Camera -> 0 or Automatic -> 1)
> +  This property defines if the controller will use the video timings available
> +  in the video stream or if it will use pre-defined ones.

"pre-defined" doesn't sound like the same thing as "automatic"?

> +- ipi-color-mode: Bus depth to be used in IPI (48 bits -> 0 or 16 bits -> 1)
> +  This property defines the width of the IPI bus.
> +- ipi-auto-flush: Data auto-flush (1 -> Yes or 0 -> No). This property defines
> +  if the data is automatically flushed in each vsync or if this process is done
> +  manually
> +- virtual-channel: Virtual channel where data is present when in IPI mode. This
> +  property chooses the virtual channel which IPI will use to retrieve the video
> +  stream.

All these properties seem like they should be common properties or are 
these interfaces something Synopsys specific? Or perhaps the interface 
is Synopsys specific, but determined by the CSI2 mode?

I think you need to define graph ports for the IPI and IDI interfaces 
and the connections. Then perhaps these properties become endpoint 
properties.

> +
> +The per-board settings:
> + - port sub-node describing a single endpoint connected to the dw-mipi-csi

Wouldn't the port connect to the camera?

> +   as described in video-interfaces.txt[1].
> diff --git a/Documentation/devicetree/bindings/media/snps,plat-ipk.txt b/Documentation/devicetree/bindings/media/snps,plat-ipk.txt
> new file mode 100644
> index 0000000..50e9279
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/snps,plat-ipk.txt
> @@ -0,0 +1,105 @@
> +Synopsys DesignWare CSI-2 Host IPK Media Device
> +
> +The Synopsys DesignWare CSI-2 Host IPK subsystem comprises of multiple
> +sub-devices represented by separate device tree nodes. Currently this includes:
> +plat-ipk, video-device, and dw-mipi-csi.
> +
> +The sub-subdevices are defined as child nodes of the common 'camera' node which
> +also includes common properties of the whole subsystem not really specific to
> +any single sub-device.

But you don't have any properties defined for the camera node.

> +
> +Common 'camera' node
> +--------------------
> +
> +Required properties:
> +
> +- compatible: must be "snps,plat-ipk", "simple-bus"
> +
> +The 'camera' node must include at least one 'video-device' and one 'dw-mipi-csi'
> +child node.
> +
> +'video-device' device nodes
> +-------------------

Is this a separate block? DMA with no registers is strange. I'm having a 
hard time understanding a complete block diagram.

> +
> +Required properties:
> +
> +- compatible: "snps,video-device"

Kind of generic. The IP block is called just "video device"?

> +- dmas, dma-names: List of one DMA specifier and identifier string (as defined
> +  in Documentation/devicetree/bindings/dma/dma.txt) per port. Each port
> +  requires a DMA channel with the identifier string set to "port" followed by
> +  the port index.

port is not what you used in the example.

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
> +	i2c@0x02000 {
> +			compatible = "snps,designware-i2c";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0x02000 0x100>;
> +			clock-frequency = <400000>;
> +			clocks = <&i2cclk>;
> +			interrupts =<0>;
> +			ov: camera@0x36 {

Drop the '0x' on unit addresses.

> +				compatible = "ovti,ov5647";
> +				reg = <0x36>;
> +				port {
> +					camera_1: endpoint {
> +						remote-endpoint = <&csi1_ep1>;
> +						clock-lanes = <0>;
> +						data-lanes = <1 2 >;
> +					};
> +				};
> +			};
> +		};
> +
> +
> +	camera {
> +		compatible = "snps,plat-ipk", "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +			video_device: video-device@0x10000 {
> +				compatible = "snps,video-device";
> +				dmas = <&axi_vdma_0 0>;
> +				dma-names = "vdma0";
> +			};
> +
> +
> +			csi2_1: csi2@0x03000 {
> +				compatible = "snps,dw-mipi-csi";
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				reg = < 0x03000 0x7FF>;
> +				interrupts = <2>;
> +				data-lanes = <2>;
> +				output-type = <2>;
> +
> +				phys = <&mipi_phy_ctrl1 0>;
> +				phy-names = "csi2-dphy";
> +
> +				/*IPI Related Configurations*/
> +				ipi-mode = <0>;
> +				ipi-color-mode = <0>;
> +				ipi-auto-flush = <1>;
> +				virtual-channel = <0>;
> +
> +				/* Camera MIPI CSI-2 (CSI1) */
> +				port@1 {
> +					reg = <1>;
> +					csi1_ep1: endpoint {
> +						remote-endpoint = <&camera_1>;
> +						data-lanes = <1 2>;
> +						};
> +				};
> +			};
> +		};
> +	};
> +
> +The dw-mipi-csi device binding is defined in snps,dw-mipi-csi.txt.
> -- 
> 2.10.2
> 
> 
