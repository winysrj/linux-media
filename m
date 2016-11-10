Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51847 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754208AbcKJJWU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 04:22:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, geert+renesas@glider.be,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/5] media: platform: rcar_drif: Add DRIF support
Date: Thu, 10 Nov 2016 11:22:20 +0200
Message-ID: <2857106.83gIJRJqtY@avalon>
In-Reply-To: <1478706284-59134-6-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <1478706284-59134-6-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

Thank you for the patch.

On Wednesday 09 Nov 2016 15:44:44 Ramesh Shanmugasundaram wrote:
> This patch adds Digital Radio Interface (DRIF) support to R-Car Gen3 SoCs.
> The driver exposes each instance of DRIF as a V4L2 SDR device. A DRIF
> device represents a channel and each channel can have one or two
> sub-channels respectively depending on the target board.
> 
> DRIF supports only Rx functionality. It receives samples from a RF
> frontend tuner chip it is interfaced with. The combination of DRIF and the
> tuner device, which is registered as a sub-device, determines the receive
> sample rate and format.
> 
> In order to be compliant as a V4L2 SDR device, DRIF needs to bind with
> the tuner device, which can be provided by a third party vendor. DRIF acts
> as a slave device and the tuner device acts as a master transmitting the
> samples. The driver allows asynchronous binding of a tuner device that
> is registered as a v4l2 sub-device. The driver can learn about the tuner
> it is interfaced with based on port endpoint properties of the device in
> device tree. The V4L2 SDR device inherits the controls exposed by the
> tuner device.
> 
> The device can also be configured to use either one or both of the data
> pins at runtime based on the master (tuner) configuration.
> 
> Signed-off-by: Ramesh Shanmugasundaram
> <ramesh.shanmugasundaram@bp.renesas.com> ---
>  .../devicetree/bindings/media/renesas,drif.txt     |  136 ++
>  drivers/media/platform/Kconfig                     |   25 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/rcar_drif.c                 | 1574
> ++++++++++++++++++++ 4 files changed, 1736 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,drif.txt
> create mode 100644 drivers/media/platform/rcar_drif.c
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt
> b/Documentation/devicetree/bindings/media/renesas,drif.txt new file mode
> 100644
> index 0000000..d65368a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
> @@ -0,0 +1,136 @@
> +Renesas R-Car Gen3 Digital Radio Interface controller (DRIF)
> +------------------------------------------------------------
> +
> +R-Car Gen3 DRIF is a serial slave device. It interfaces with a master
> +device as shown below
> +
> ++---------------------+                +---------------------+
> +|                     |-----SCK------->|CLK                  |
> +|       Master        |-----SS-------->|SYNC  DRIFn (slave)  |
> +|                     |-----SD0------->|D0                   |
> +|                     |-----SD1------->|D1                   |
> ++---------------------+                +---------------------+
> +
> +Each DRIF channel (drifn) consists of two sub-channels (drifn0 & drifn1).
> +The sub-channels are like two individual channels in itself that share the
> +common CLK & SYNC. Each sub-channel has it's own dedicated resources like
> +irq, dma channels, address space & clock.
> +
> +The device tree model represents the channel and each of it's sub-channel
> +as a separate node. The parent channel ties the sub-channels together with
> +their phandles.
> +
> +Required properties of a sub-channel:
> +-------------------------------------
> +- compatible: "renesas,r8a7795-drif" if DRIF controller is a part of
> R8A7795 SoC.
> +	      "renesas,rcar-gen3-drif" for a generic R-Car Gen3 compatible
> device.
> +	      When compatible with the generic version, nodes must list the
> +	      SoC-specific version corresponding to the platform first
> +	      followed by the generic version.
> +- reg: offset and length of that sub-channel.
> +- interrupts: associated with that sub-channel.
> +- clocks: phandle and clock specifier of that sub-channel.
> +- clock-names: clock input name string: "fck".
> +- dmas: phandles to the DMA channel of that sub-channel.
> +- dma-names: names of the DMA channel: "rx".
> +
> +Optional properties of a sub-channel:
> +-------------------------------------
> +- power-domains: phandle to the respective power domain.
> +
> +Required properties of a channel:
> +---------------------------------
> +- pinctrl-0: pin control group to be used for this channel.
> +- pinctrl-names: must be "default".
> +- sub-channels : phandles to the two sub-channels.
> +
> +Optional properties of a channel:
> +---------------------------------
> +- port: child port node of a channel that defines the local and remote
> +        endpoints. The remote endpoint is assumed to be a tuner subdevice
> +	endpoint.
> +- renesas,syncmd       : sync mode
> +			 0 (Frame start sync pulse mode. 1-bit width pulse
> +			    indicates start of a frame)
> +			 1 (L/R sync or I2S mode) (default)
> +- renesas,lsb-first    : empty property indicates lsb bit is received
> first.
> +			 When not defined msb bit is received first (default)

Shouldn't those two properties be instead queried from the tuner at runtime 
through the V4L2 subdev API ?

> +- renesas,syncac-pol-high  : empty property indicates sync signal polarity.
> +			 When defined, active high or high->low sync signal.
> +			 When not defined, active low or low->high sync signal
> +			 (default)

This could be queried too, except that an inverter could be present on the 
board, so it has to be specified in DT. I would however try to standardize it 
the same way that hsync-active and vsync-active are standardized in 
Documentation/devicetree/bindings/media/video-interfaces.txt.

> +- renesas,dtdl         : delay between sync signal and start of reception.

Are this and the next property meant to account for PCB traces delays ?

> +			 Must contain one of the following values:
> +			 0   (no bit delay)
> +			 50  (0.5-clock-cycle delay)
> +			 100 (1-clock-cycle delay) (default)
> +			 150 (1.5-clock-cycle delay)
> +			 200 (2-clock-cycle delay)

How about specifying the property in half clock cycle units, from 0 to 4 ?

> +- renesas,syncdl       : delay between end of reception and sync signal
> edge.
> +			 Must contain one of the following values:
> +			 0   (no bit delay) (default)
> +			 50  (0.5-clock-cycle delay)
> +			 100 (1-clock-cycle delay)
> +			 150 (1.5-clock-cycle delay)
> +			 200 (2-clock-cycle delay)
> +			 300 (3-clock-cycle delay)
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
> +			status = "disabled";
> +		};
> +
> +		drif0: rif@0 {
> +			compatible = "renesas,r8a7795-drif",
> +				     "renesas,rcar-gen3-drif";
> +			sub-channels = <&drif00>, <&drif01>;
> +			status = "disabled";
> +		};

I'm afraid this really hurts my eyes, especially using the same compatible 
string for both the channel and sub-channel nodes.

We need to decide how to model the hardware in DT. Given that the two channels 
are mostly independent having separate DT nodes makes sense to me. However, as 
they share the clock and sync signals, somehow grouping them makes sense. I 
see three ways to do so, and there might be more.

1. Adding an extra DT node for the channels group, with phandles to the two 
channels. This is what you're proposing here.

2. Adding an extra DT node for the channels group, as a parent of the two 
channels.

3. Adding phandles to the channels, pointing to each other, or possibly a 
phandle from channel 0 pointing to channel 1.

Neither of these options seem perfect to me. I don't like option 1 as the 
group DT node really doesn't describe a hardware block. If we want to use a DT 
node to convey group information, option 2 seems better to me. However, it 
somehow abuses the DT parent-child model that is supposed to describe 
relationships from a control bus point of view. Option 3 has the drawback of 
not scaling properly, at least with phandles in both channels pointing to the 
other one.

Rob, Geert, tell me you have a fourth idea I haven't thought of that would 
solve all those problems :-)

> +Board specific dts file
> +
> +&drif00 {
> +	status = "okay";
> +};
> +
> +&drif01 {
> +	status = "okay";
> +};
> +
> +&drif0 {
> +	pinctrl-0 = <&drif0_pins>;
> +	pinctrl-names = "default";
> +	renesas,syncac-pol-high;
> +	status = "okay";
> +	port {
> +		drif0_ep: endpoint {
> +		     remote-endpoint = <&tuner_subdev_ep>;
> +		};
> +	};
> +};

[snip]

-- 
Regards,

Laurent Pinchart

