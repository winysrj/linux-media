Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34441 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755307AbcLVREq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 12:04:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, geert+renesas@glider.be,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 6/7] dt-bindings: media: Add Renesas R-Car DRIF binding
Date: Thu, 22 Dec 2016 19:05:14 +0200
Message-ID: <11494368.ZdobxT7gGY@avalon>
In-Reply-To: <1482307838-47415-7-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <1482307838-47415-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <1482307838-47415-7-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

Thank you for the patch.

On Wednesday 21 Dec 2016 08:10:37 Ramesh Shanmugasundaram wrote:
> Add binding documentation for Renesas R-Car Digital Radio Interface
> (DRIF) controller.
> 
> Signed-off-by: Ramesh Shanmugasundaram
> <ramesh.shanmugasundaram@bp.renesas.com> ---
>  .../devicetree/bindings/media/renesas,drif.txt     | 202 ++++++++++++++++++
>  1 file changed, 202 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,drif.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt
> b/Documentation/devicetree/bindings/media/renesas,drif.txt new file mode
> 100644
> index 0000000..1f3feaf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
> @@ -0,0 +1,202 @@
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
> +- compatible: "renesas,r8a7795-drif" if DRIF controller is a part of
> R8A7795 SoC.
> +	      "renesas,rcar-gen3-drif" for a generic R-Car Gen3 compatible
> device.
> +	      When compatible with the generic version, nodes must list the
> +	      SoC-specific version corresponding to the platform first
> +	      followed by the generic version.
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
> +- renesas,primary-bond: empty property indicating the channel acts as
> primary
> +			among the bonded channels.
> +- port: child port node of a channel that defines the local and remote
> +	endpoints. The remote endpoint is assumed to be a third party tuner
> +	device endpoint.
> +
> +Optional properties of an internal channel when:
> +	- It is the only enabled channel of the bond (or)
> +	- If it acts as primary among enabled bonds
> +--------------------------------------------------------
> +- renesas,syncmd       : sync mode
> +			 0 (Frame start sync pulse mode. 1-bit width pulse
> +			    indicates start of a frame)
> +			 1 (L/R sync or I2S mode) (default)
> +- renesas,lsb-first    : empty property indicates lsb bit is received
> first.
> +			 When not defined msb bit is received first (default)
> +- renesas,syncac-active: Indicates sync signal polarity, 0/1 for low/high
> +			 respectively. The default is 1 (active high)
> +- renesas,dtdl         : delay between sync signal and start of reception.
> +			 The possible values are represented in 0.5 clock
> +			 cycle units and the range is 0 to 4. The default
> +			 value is 2 (i.e.) 1 clock cycle delay.
> +- renesas,syncdl       : delay between end of reception and sync signal
> edge.
> +			 The possible values are represented in 0.5 clock
> +			 cycle units and the range is 0 to 4 & 6. The default
> +			 value is 0 (i.e.) no delay.

Most of these properties are pretty similar to the video bus properties 
defined at the endpoint level in 
Documentation/devicetree/bindings/media/video-interfaces.txt. I believe it 
would make sense to use OF graph and try to standardize these properties 
similarly.

> +
> +Example
> +--------
> +
> +SoC common dtsi file
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
> +(1) Both internal channels enabled, primary-bond = 0
> +-----------------------------------------------------
> +
> +When interfacing with a third party tuner device with two data pins as
> shown +below.
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
> +	...
> +}
> +
> +&drif00 {
> +	pinctrl-0 = <&drif0_pins>;
> +	pinctrl-names = "default";
> +	renesas,syncac-active = <1>;
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
> +	renesas,syncac-active = <0>;
> +	status = "okay";
> +	port {
> +		drif0_ep: endpoint {
> +		     remote-endpoint = <&tuner_ep>;
> +		};
> +	};
> +};

-- 
Regards,

Laurent Pinchart

