Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60353 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbcJRS0o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 14:26:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antti Palosaari <crope@iki.fi>,
        Chris Paterson <chris.paterson2@renesas.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [RFC 3/5] media: platform: rcar_drif: Add DRIF support
Date: Tue, 18 Oct 2016 21:26:40 +0300
Message-ID: <6004562.7prnSznmMM@avalon>
In-Reply-To: <CAMuHMdXvGEm3bdNOsa6Q1FLB9yMSTAzO4nHcCb-pnYYwg6f6Cg@mail.gmail.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <1476281429-27603-4-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <CAMuHMdXvGEm3bdNOsa6Q1FLB9yMSTAzO4nHcCb-pnYYwg6f6Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday 18 Oct 2016 16:29:24 Geert Uytterhoeven wrote:
> On Wed, Oct 12, 2016 at 4:10 PM, Ramesh Shanmugasundaram wrote:
> > This patch adds Digital Radio Interface (DRIF) support to R-Car Gen3 SoCs.
> > The driver exposes each instance of DRIF as a V4L2 SDR device. A DRIF
> > device represents a channel and each channel can have one or two
> > sub-channels respectively depending on the target board.
> > 
> > DRIF supports only Rx functionality. It receives samples from a RF
> > frontend tuner chip it is interfaced with. The combination of DRIF and the
> > tuner device, which is registered as a sub-device, determines the receive
> > sample rate and format.
> > 
> > In order to be compliant as a V4L2 SDR device, DRIF needs to bind with
> > the tuner device, which can be provided by a third party vendor. DRIF acts
> > as a slave device and the tuner device acts as a master transmitting the
> > samples. The driver allows asynchronous binding of a tuner device that
> > is registered as a v4l2 sub-device. The driver can learn about the tuner
> > it is interfaced with based on port endpoint properties of the device in
> > device tree. The V4L2 SDR device inherits the controls exposed by the
> > tuner device.
> > 
> > The device can also be configured to use either one or both of the data
> > pins at runtime based on the master (tuner) configuration.
> 
> Thanks for your patch!
> 
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
> > @@ -0,0 +1,109 @@
> > +Renesas R-Car Gen3 DRIF controller (DRIF)
> > +-----------------------------------------
> > +
> > +Required properties:
> > +--------------------
> > +- compatible: "renesas,drif-r8a7795" if DRIF controller is a part of
> > R8A7795 SoC.
>
> "renesas,r8a7795-drif", as Rob already pointed out.
> 
> > +             "renesas,rcar-gen3-drif" for a generic R-Car Gen3 compatible
> > device.
> > +             When compatible with the generic version, nodes must list
> > the
> > +             SoC-specific version corresponding to the platform first
> > +             followed by the generic version.
> > +
> > +- reg: offset and length of each sub-channel.
> > +- interrupts: associated with each sub-channel.
> > +- clocks: phandles and clock specifiers for each sub-channel.
> > +- clock-names: clock input name strings: "fck0", "fck1".
> > +- pinctrl-0: pin control group to be used for this controller.
> > +- pinctrl-names: must be "default".
> > +- dmas: phandles to the DMA channels for each sub-channel.
> > +- dma-names: names for the DMA channels: "rx0", "rx1".
> > +
> > +Required child nodes:
> > +---------------------
> > +- Each DRIF channel can have one or both of the sub-channels enabled in a
> > +  setup. The sub-channels are represented as a child node. The name of
> > the
> > +  child nodes are "sub-channel0" and "sub-channel1" respectively. Each
> > child
> > +  node supports the "status" property only, which is used to
> > enable/disable
> > +  the respective sub-channel.
> > 
> > +Example
> > +--------
> > +
> > +SoC common dtsi file
> > +
> > +drif0: rif@e6f40000 {
> > +       compatible = "renesas,drif-r8a7795",
> > +                  "renesas,rcar-gen3-drif";
> > +       reg = <0 0xe6f40000 0 0x64>, <0 0xe6f50000 0 0x64>;
> > +       interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
> > +                  <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
> > +       clocks = <&cpg CPG_MOD 515>, <&cpg CPG_MOD 514>;
> > +       clock-names = "fck0", "fck1";
> > +       dmas = <&dmac1 0x20>, <&dmac1 0x22>;
> > +       dma-names = "rx0", "rx1";
> 
> I could not find the DMAC channels in the datasheet?
> Most modules are either tied to dmac0, or two both dmac1 and dmac2.
> In the latter case, you want to list two sets of dmas, one for each DMAC.
> 
> > +       power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
> > +       status = "disabled";
> > +
> > +       sub-channel0 {
> > +               status = "disabled";
> > +       };
> > +
> > +       sub-channel1 {
> > +               status = "disabled";
> > +       };
> > +
> > +};
> 
> As you're modelling this in DT under a single device node, this means you
> cannot use runtime PM to manage the module clocks of the individual
> channels.
> 
> An alternative could be to have two separate nodes for each channel,
> and tie them together using a phandle.

A quick glance at the documentation shows no dependency between the two 
channels at a software level. They both share the same clock and 
synchronization input pins, but from a hardware point of view that seems to be 
it. It thus looks like we could indeed model the two channels as separate 
nodes, without tying them together.

-- 
Regards,

Laurent Pinchart

