Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:32875 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdBOP3e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 10:29:34 -0500
Subject: Re: [PATCH v2 1/2] Add Documentation for Media Device, Video Device,
 and Synopsys DW MIPI CSI-2 Host
To: Rob Herring <robh@kernel.org>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
References: <cover.1481548484.git.roliveir@synopsys.com>
 <48a46d2d60fff723e322fdbfb29d533c2d0f5637.1481554324.git.roliveir@synopsys.com>
 <20161219173843.tpljazh365zp7i4z@rob-hp-laptop>
CC: <mark.rutland@arm.com>, <mchehab@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <geert+renesas@glider.be>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <hverkuil@xs4all.nl>, <laurent.pinchart+renesas@ideasonboard.com>,
        <arnd@arndb.de>, <sudipm.mukherjee@gmail.com>,
        <tiffany.lin@mediatek.com>, <minghsiu.tsai@mediatek.com>,
        <jean-christophe.trotin@st.com>, <andrew-ct.chen@mediatek.com>,
        <simon.horman@netronome.com>, <songjun.wu@microchip.com>,
        <bparrot@ti.com>, <CARLOS.PALMINHA@synopsys.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <6cb562d7-3bc3-8ac5-e30a-fce03b5dc3eb@synopsys.com>
Date: Wed, 15 Feb 2017 15:29:21 +0000
MIME-Version: 1.0
In-Reply-To: <20161219173843.tpljazh365zp7i4z@rob-hp-laptop>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Sorry for the late reply, but I just now found your reply.

Thanks for your feedback.

On 12/19/2016 5:38 PM, Rob Herring wrote:
> On Mon, Dec 12, 2016 at 03:00:35PM +0000, Ramiro Oliveira wrote:
>> Create device tree bindings documentation for Media and Video Device, as well
>> as the DW MIPI CSI-2 Host.
>>
>> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
>> ---
>>  .../devicetree/bindings/media/snps,dw-mipi-csi.txt |  37 ++++++++
>>  .../devicetree/bindings/media/snps,plat-ipk.txt    | 105 +++++++++++++++++++++
>>  2 files changed, 142 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
>>  create mode 100644 Documentation/devicetree/bindings/media/snps,plat-ipk.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt b/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
>> new file mode 100644
>> index 0000000..1caa652
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
>> @@ -0,0 +1,37 @@
>> +Synopsys DesignWare CSI-2 Host controller
>> +
>> +Description
>> +-----------
>> +
>> +This HW block is used to receive image coming from an MIPI CSI-2 compatible
>> +camera.
>> +
>> +Required properties:
>> +- compatible: shall be "snps,dw-mipi-csi"
> 
> You don't have to add them, but this will need SoC specific compatible 
> strings. Please add a note to that effect.
> 

I'm not sure what you mean with this, can you give me an example?

>> +- reg		: physical base address and size of the device memory mapped
>> +  registers;
>> +- interrupts	: CSI-2 Host interrupt
>> +- data-lanes    : Number of lanes to be used
>> +- output-type   : Core output to be used (IPI-> 0 or IDI->1 or BOTH->2) These
>> +  values choose which of the Core outputs will be used, it can be Image Data
>> +  Interface or Image Pixel Interface.
> 
> This is output to a parallel camera interface (e.g. an SoC camera 
> subsystem)? 
> 

These are the outpus of the Synopsys CSI-2 Host controller, both parallel like
you said, one (IDI) formatted as the MIPI CSI-2 recommends and the other is a
video stream.

>> +- phys, phy-names: List of one PHY specifier and identifier string (as defined
>> +  in Documentation/devicetree/bindings/phy/phy-bindings.txt). This PHY is a MIPI
>> +  DPHY working in RX mode.
> 
> phy-names is pointless when there is only 1.
> 

Ok. I'll remove it

>> +
>> +Optional properties(if in IPI mode):
>> +- ipi-mode 	: Mode to be used when in IPI(Camera -> 0 or Automatic -> 1)
>> +  This property defines if the controller will use the video timings available
>> +  in the video stream or if it will use pre-defined ones.
> 
> "pre-defined" doesn't sound like the same thing as "automatic"?
> 

It shouldn't be automatic, but Controller instead. I'll correct it.

>> +- ipi-color-mode: Bus depth to be used in IPI (48 bits -> 0 or 16 bits -> 1)
>> +  This property defines the width of the IPI bus.
>> +- ipi-auto-flush: Data auto-flush (1 -> Yes or 0 -> No). This property defines
>> +  if the data is automatically flushed in each vsync or if this process is done
>> +  manually
>> +- virtual-channel: Virtual channel where data is present when in IPI mode. This
>> +  property chooses the virtual channel which IPI will use to retrieve the video
>> +  stream.
> 
> All these properties seem like they should be common properties or are 
> these interfaces something Synopsys specific? Or perhaps the interface 
> is Synopsys specific, but determined by the CSI2 mode?
> 
> I think you need to define graph ports for the IPI and IDI interfaces 
> and the connections. Then perhaps these properties become endpoint 
> properties.
> 

Like I said above, IDI is formatted as recommend by the CSI-2 spec, and IPI is a
video stream, with the standard video signals.

Although you can use both outputs simultaneously, the majority of the setups
will only use one, so I'm not sure that creating graph ports for both is
necessary, but I can do it if you think it's best.

>> +
>> +The per-board settings:
>> + - port sub-node describing a single endpoint connected to the dw-mipi-csi
> 
> Wouldn't the port connect to the camera?
> 

Yes, it should be camera instead

>> +   as described in video-interfaces.txt[1].
>> diff --git a/Documentation/devicetree/bindings/media/snps,plat-ipk.txt b/Documentation/devicetree/bindings/media/snps,plat-ipk.txt
>> new file mode 100644
>> index 0000000..50e9279
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/snps,plat-ipk.txt
>> @@ -0,0 +1,105 @@
>> +Synopsys DesignWare CSI-2 Host IPK Media Device
>> +
>> +The Synopsys DesignWare CSI-2 Host IPK subsystem comprises of multiple
>> +sub-devices represented by separate device tree nodes. Currently this includes:
>> +plat-ipk, video-device, and dw-mipi-csi.
>> +
>> +The sub-subdevices are defined as child nodes of the common 'camera' node which
>> +also includes common properties of the whole subsystem not really specific to
>> +any single sub-device.
> 
> But you don't have any properties defined for the camera node.
> 

Yes, you're right, this is leftover from a previous version

>> +
>> +Common 'camera' node
>> +--------------------
>> +
>> +Required properties:
>> +
>> +- compatible: must be "snps,plat-ipk", "simple-bus"
>> +
>> +The 'camera' node must include at least one 'video-device' and one 'dw-mipi-csi'
>> +child node.
>> +
>> +'video-device' device nodes
>> +-------------------
> 
> Is this a separate block? DMA with no registers is strange. I'm having a 
> hard time understanding a complete block diagram.
> 

This block is what interacts with the DMA and registers as a video device.

>> +
>> +Required properties:
>> +
>> +- compatible: "snps,video-device"
> 
> Kind of generic. The IP block is called just "video device"?
> 

Like I said above it's not really an HW block.

>> +- dmas, dma-names: List of one DMA specifier and identifier string (as defined
>> +  in Documentation/devicetree/bindings/dma/dma.txt) per port. Each port
>> +  requires a DMA channel with the identifier string set to "port" followed by
>> +  the port index.
> 
> port is not what you used in the example.
> 

You're right, I'll change it.

>> +
>> +Image sensor nodes
>> +------------------
>> +
>> +The sensor device nodes should be added to their control bus controller (e.g.
>> +I2C0) nodes and linked to a port node in the dw-mipi-csi,using the common video
>> +interfaces bindings, defined in video-interfaces.txt.
>> +
>> +Example:
>> +
>> +	i2c@0x02000 {
>> +			compatible = "snps,designware-i2c";
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			reg = <0x02000 0x100>;
>> +			clock-frequency = <400000>;
>> +			clocks = <&i2cclk>;
>> +			interrupts =<0>;
>> +			ov: camera@0x36 {
> 
> Drop the '0x' on unit addresses.
> 

I'll do that.

>> +				compatible = "ovti,ov5647";
>> +				reg = <0x36>;
>> +				port {
>> +					camera_1: endpoint {
>> +						remote-endpoint = <&csi1_ep1>;
>> +						clock-lanes = <0>;
>> +						data-lanes = <1 2 >;
>> +					};
>> +				};
>> +			};
>> +		};
>> +
>> +
>> +	camera {
>> +		compatible = "snps,plat-ipk", "simple-bus";
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		ranges;
>> +			video_device: video-device@0x10000 {
>> +				compatible = "snps,video-device";
>> +				dmas = <&axi_vdma_0 0>;
>> +				dma-names = "vdma0";
>> +			};
>> +
>> +
>> +			csi2_1: csi2@0x03000 {
>> +				compatible = "snps,dw-mipi-csi";
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				reg = < 0x03000 0x7FF>;
>> +				interrupts = <2>;
>> +				data-lanes = <2>;
>> +				output-type = <2>;
>> +
>> +				phys = <&mipi_phy_ctrl1 0>;
>> +				phy-names = "csi2-dphy";
>> +
>> +				/*IPI Related Configurations*/
>> +				ipi-mode = <0>;
>> +				ipi-color-mode = <0>;
>> +				ipi-auto-flush = <1>;
>> +				virtual-channel = <0>;
>> +
>> +				/* Camera MIPI CSI-2 (CSI1) */
>> +				port@1 {
>> +					reg = <1>;
>> +					csi1_ep1: endpoint {
>> +						remote-endpoint = <&camera_1>;
>> +						data-lanes = <1 2>;
>> +						};
>> +				};
>> +			};
>> +		};
>> +	};
>> +
>> +The dw-mipi-csi device binding is defined in snps,dw-mipi-csi.txt.
>> -- 
>> 2.10.2
>>
>>

-- 
Best Regards

Ramiro Oliveira
Ramiro.Oliveira@synopsys.com
