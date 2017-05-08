Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36646 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbdEHQAc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 12:00:32 -0400
Date: Mon, 8 May 2017 11:00:26 -0500
From: Rob Herring <robh@kernel.org>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: mark.rutland@arm.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 6/7] dt-bindings: media: Add Renesas R-Car DRIF binding
Message-ID: <20170508160026.4qjr7voa3ovesecz@rob-hp-laptop>
References: <20170502132615.42134-1-ramesh.shanmugasundaram@bp.renesas.com>
 <20170502132615.42134-7-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170502132615.42134-7-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 02, 2017 at 02:26:14PM +0100, Ramesh Shanmugasundaram wrote:
> Add binding documentation for Renesas R-Car Digital Radio Interface
> (DRIF) controller.
> 
> Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> ---
> v4:
>  - port property description modified as suggested by Laurent.
>  - removed renesas vendor tag from sync-active end-point property (Rob)
> ---
>  .../devicetree/bindings/media/renesas,drif.txt     | 187 +++++++++++++++++++++
>  1 file changed, 187 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,drif.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt b/Documentation/devicetree/bindings/media/renesas,drif.txt
> new file mode 100644
> index 000000000000..12428f969958
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
> @@ -0,0 +1,187 @@
> +Renesas R-Car Gen3 Digital Radio Interface controller (DRIF)
> +------------------------------------------------------------
> +
> +R-Car Gen3 DRIF is a SPI like receive only slave device. A general
> +representation of DRIF interfacing with a master device is shown below.
> +
> ++---------------------+                +---------------------+
> +|                     |-----SCK------->|CLK                  |
> +|       Master        |-----SS-------->|SYNC  DRIFn (slave)  |
> +|                     |-----SD0------->|D0                   |
> +|                     |-----SD1------->|D1                   |
> ++---------------------+                +---------------------+
> +
> +As per datasheet, each DRIF channel (drifn) is made up of two internal
> +channels (drifn0 & drifn1). These two internal channels share the common
> +CLK & SYNC. Each internal channel has its own dedicated resources like
> +irq, dma channels, address space & clock. This internal split is not
> +visible to the external master device.
> +
> +The device tree model represents each internal channel as a separate node.
> +The internal channels sharing the CLK & SYNC are tied together by their
> +phandles using a new property called "renesas,bonding". For the rest of
> +the documentation, unless explicitly stated, the word channel implies an
> +internal channel.
> +
> +When both internal channels are enabled they need to be managed together
> +as one (i.e.) they cannot operate alone as independent devices. Out of the
> +two, one of them needs to act as a primary device that accepts common
> +properties of both the internal channels. This channel is identified by a
> +new property called "renesas,primary-bond".

s/new property/property/

> +
> +To summarize,
> +   - When both the internal channels that are bonded together are enabled,
> +     the zeroth channel is selected as primary-bond. This channels accepts
> +     properties common to all the members of the bond.
> +   - When only one of the bonded channels need to be enabled, the property
> +     "renesas,bonding" or "renesas,primary-bond" will have no effect. That
> +     enabled channel can act alone as any other independent device.
> +
> +Required properties of an internal channel:
> +-------------------------------------------
> +- compatible: "renesas,r8a7795-drif" if DRIF controller is a part of R8A7795 SoC.
> +	      "renesas,rcar-gen3-drif" for a generic R-Car Gen3 compatible device.
> +	      When compatible with the generic version, nodes must list the
> +	      SoC-specific version corresponding to the platform first
> +	      followed by the generic version.

Please format this such that it is easier to add the 2nd SoC with this 
block. 

> +- reg: offset and length of that channel.
> +- interrupts: associated with that channel.
> +- clocks: phandle and clock specifier of that channel.
> +- clock-names: clock input name string: "fck".
> +- dmas: phandles to the DMA channels.
> +- dma-names: names of the DMA channel: "rx".
> +- renesas,bonding: phandle to the other channel.
> +
> +Optional properties of an internal channel:
> +-------------------------------------------
> +- power-domains: phandle to the respective power domain.
> +
> +Required properties of an internal channel when:
> +	- It is the only enabled channel of the bond (or)
> +	- If it acts as primary among enabled bonds
> +--------------------------------------------------------
> +- pinctrl-0: pin control group to be used for this channel.
> +- pinctrl-names: must be "default".
> +- renesas,primary-bond: empty property indicating the channel acts as primary
> +			among the bonded channels.
> +- port: child port node corresponding to the data input, in accordance with
> +	the video interface bindings defined in
> +	Documentation/devicetree/bindings/media/video-interfaces.txt. The port
> +	node must contain at least one endpoint.
> +
> +Optional endpoint property:
> +---------------------------
> +- sync-active: Indicates sync signal polarity, 0/1 for low/high respectively.
> +	       This property maps to SYNCAC bit in the hardware manual. The
> +	       default is 1 (active high).
> +
> +Example
> +--------
> +
> +SoC common dtsi file

Don't split the example into SoC and board specific parts. That's purely 
convention and not part of the binding.

> +
> +		drif00: rif@e6f40000 {
> +			compatible = "renesas,r8a7795-drif",
> +				     "renesas,rcar-gen3-drif";
> +			reg = <0 0xe6f40000 0 0x64>;
> +			interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&cpg CPG_MOD 515>;
> +			clock-names = "fck";
> +			dmas = <&dmac1 0x20>, <&dmac2 0x20>;
> +			dma-names = "rx", "rx";
> +			power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
> +			renesas,bonding = <&drif01>;
> +			status = "disabled";

Don't need to show status in example.

> +		};
> +
> +		drif01: rif@e6f50000 {
> +			compatible = "renesas,r8a7795-drif",
> +				     "renesas,rcar-gen3-drif";
> +			reg = <0 0xe6f50000 0 0x64>;
> +			interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&cpg CPG_MOD 514>;
> +			clock-names = "fck";
> +			dmas = <&dmac1 0x22>, <&dmac2 0x22>;
> +			dma-names = "rx", "rx";
> +			power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
> +			renesas,bonding = <&drif00>;
> +			status = "disabled";
> +		};
> +
> +
> +Board specific dts file
> +
> +(1) Both internal channels enabled:
> +-----------------------------------
> +
> +When interfacing with a third party tuner device with two data pins as shown
> +below.
> +
> ++---------------------+                +---------------------+
> +|                     |-----SCK------->|CLK                  |
> +|       Master        |-----SS-------->|SYNC  DRIFn (slave)  |
> +|                     |-----SD0------->|D0                   |
> +|                     |-----SD1------->|D1                   |
> ++---------------------+                +---------------------+
> +
> +pfc {
> +	...
> +
> +	drif0_pins: drif0 {
> +		groups = "drif0_ctrl_a", "drif0_data0_a",
> +				 "drif0_data1_a";
> +		function = "drif0";
> +	};
> +	..

You don't need to show the pinctrl nodes.

> +}
> +
> +&drif00 {
> +	pinctrl-0 = <&drif0_pins>;
> +	pinctrl-names = "default";
> +	renesas,primary-bond;
> +	status = "okay";
> +	port {
> +		drif0_ep: endpoint {
> +		     remote-endpoint = <&tuner_ep>;
> +		};
> +	};
> +};
> +
> +&drif01 {
> +	status = "okay";
> +};
> +
> +(2) Internal channel 1 alone is enabled:
> +----------------------------------------
> +
> +When interfacing with a third party tuner device with one data pin as shown
> +below.
> +
> ++---------------------+                +---------------------+
> +|                     |-----SCK------->|CLK                  |
> +|       Master        |-----SS-------->|SYNC  DRIFn (slave)  |
> +|                     |                |D0 (unused)          |
> +|                     |-----SD-------->|D1                   |
> ++---------------------+                +---------------------+
> +
> +pfc {
> +	...
> +
> +	drif0_pins: drif0 {
> +		groups = "drif0_ctrl_a", "drif0_data1_a";
> +		function = "drif0";
> +	};
> +	...
> +}
> +
> +&drif01 {
> +	pinctrl-0 = <&drif0_pins>;
> +	pinctrl-names = "default";
> +	status = "okay";
> +	port {
> +		drif0_ep: endpoint {
> +		     remote-endpoint = <&tuner_ep>;
> +		     sync-active = <0>;
> +		};
> +	};
> +};
> -- 
> 2.12.2
> 
