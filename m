Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:33774 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933052AbcJUNTA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 09:19:00 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Antti Palosaari" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: RE: [RFC 3/5] media: platform: rcar_drif: Add DRIF support
Date: Fri, 21 Oct 2016 13:17:37 +0000
Message-ID: <SG2PR06MB103890A126B60A9D3939B0A1C3D40@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1476281429-27603-4-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <CAMuHMdXvGEm3bdNOsa6Q1FLB9yMSTAzO4nHcCb-pnYYwg6f6Cg@mail.gmail.com>
 <6004562.7prnSznmMM@avalon>
In-Reply-To: <6004562.7prnSznmMM@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the review comments.

> On Tuesday 18 Oct 2016 16:29:24 Geert Uytterhoeven wrote:
> > On Wed, Oct 12, 2016 at 4:10 PM, Ramesh Shanmugasundaram wrote:
> > > This patch adds Digital Radio Interface (DRIF) support to R-Car Gen3
> SoCs.
> > > The driver exposes each instance of DRIF as a V4L2 SDR device. A
> > > DRIF device represents a channel and each channel can have one or
> > > two sub-channels respectively depending on the target board.
> > >
> > > DRIF supports only Rx functionality. It receives samples from a RF
> > > frontend tuner chip it is interfaced with. The combination of DRIF
> > > and the tuner device, which is registered as a sub-device,
> > > determines the receive sample rate and format.
> > >
> > > In order to be compliant as a V4L2 SDR device, DRIF needs to bind
> > > with the tuner device, which can be provided by a third party
> > > vendor. DRIF acts as a slave device and the tuner device acts as a
> > > master transmitting the samples. The driver allows asynchronous
> > > binding of a tuner device that is registered as a v4l2 sub-device.
> > > The driver can learn about the tuner it is interfaced with based on
> > > port endpoint properties of the device in device tree. The V4L2 SDR
> > > device inherits the controls exposed by the tuner device.
> > >
> > > The device can also be configured to use either one or both of the
> > > data pins at runtime based on the master (tuner) configuration.
> >
> > Thanks for your patch!
> >
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
> > > @@ -0,0 +1,109 @@
> > > +Renesas R-Car Gen3 DRIF controller (DRIF)
> > > +-----------------------------------------
> > > +
> > > +Required properties:
> > > +--------------------
> > > +- compatible: "renesas,drif-r8a7795" if DRIF controller is a part
> > > +of
> > > R8A7795 SoC.
> >
> > "renesas,r8a7795-drif", as Rob already pointed out.
> >
> > > +             "renesas,rcar-gen3-drif" for a generic R-Car Gen3
> > > + compatible
> > > device.
> > > +             When compatible with the generic version, nodes must
> > > + list
> > > the
> > > +             SoC-specific version corresponding to the platform firs=
t
> > > +             followed by the generic version.
> > > +
> > > +- reg: offset and length of each sub-channel.
> > > +- interrupts: associated with each sub-channel.
> > > +- clocks: phandles and clock specifiers for each sub-channel.
> > > +- clock-names: clock input name strings: "fck0", "fck1".
> > > +- pinctrl-0: pin control group to be used for this controller.
> > > +- pinctrl-names: must be "default".
> > > +- dmas: phandles to the DMA channels for each sub-channel.
> > > +- dma-names: names for the DMA channels: "rx0", "rx1".
> > > +
> > > +Required child nodes:
> > > +---------------------
> > > +- Each DRIF channel can have one or both of the sub-channels
> > > +enabled in a
> > > +  setup. The sub-channels are represented as a child node. The name
> > > +of
> > > the
> > > +  child nodes are "sub-channel0" and "sub-channel1" respectively.
> > > + Each
> > > child
> > > +  node supports the "status" property only, which is used to
> > > enable/disable
> > > +  the respective sub-channel.
> > >
> > > +Example
> > > +--------
> > > +
> > > +SoC common dtsi file
> > > +
> > > +drif0: rif@e6f40000 {
> > > +       compatible =3D "renesas,drif-r8a7795",
> > > +                  "renesas,rcar-gen3-drif";
> > > +       reg =3D <0 0xe6f40000 0 0x64>, <0 0xe6f50000 0 0x64>;
> > > +       interrupts =3D <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
> > > +                  <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
> > > +       clocks =3D <&cpg CPG_MOD 515>, <&cpg CPG_MOD 514>;
> > > +       clock-names =3D "fck0", "fck1";
> > > +       dmas =3D <&dmac1 0x20>, <&dmac1 0x22>;
> > > +       dma-names =3D "rx0", "rx1";
> >
> > I could not find the DMAC channels in the datasheet?
> > Most modules are either tied to dmac0, or two both dmac1 and dmac2.
> > In the latter case, you want to list two sets of dmas, one for each
> DMAC.
> >
> > > +       power-domains =3D <&sysc R8A7795_PD_ALWAYS_ON>;
> > > +       status =3D "disabled";
> > > +
> > > +       sub-channel0 {
> > > +               status =3D "disabled";
> > > +       };
> > > +
> > > +       sub-channel1 {
> > > +               status =3D "disabled";
> > > +       };
> > > +
> > > +};
> >
> > As you're modelling this in DT under a single device node, this means
> > you cannot use runtime PM to manage the module clocks of the
> > individual channels.
> >
> > An alternative could be to have two separate nodes for each channel,
> > and tie them together using a phandle.
>=20
> A quick glance at the documentation shows no dependency between the two
> channels at a software level. They both share the same clock and
> synchronization input pins, but from a hardware point of view that seems
> to be it. It thus looks like we could indeed model the two channels as
> separate nodes, without tying them together.

Thanks & I agree with your suggestion to keep each DRIF sub-channels as sep=
arate node. However, I would still like to tie them as Geert pointed out be=
cause

1) DRIF, as you may know, is a botched MSIOF slave. H/W manual states there=
 are 4 channels each having SCK, WS & two data lines D0 & D1) but in realit=
y each sub-channel (SCK,WS & Dx) can indeed act alone (they have their own =
resources) except that they share SCK & WS as you pointed out. It is not cl=
ean design but it tries to market a radio interface use case - I & Q data f=
rom master received on D0 & D1 and this data is relational. For the master =
and the end user application, this internal split is not visible.

2) If you look at PFC, when a DRIF channel is selected using MOD_SEL it ena=
bles both the sub-channels. This shows the intended use case. Ofcourse the =
imperfection cannot be hidden - you could still configure one of the D0/D1 =
pins as GPIO even after PFC selects them both :-(.=20

3) Manual states "When setting to registers, it needs to set the same value=
s to two register sets located per channel" - This driver is doing that by =
accessing each sub-channel based on DT setup. This way driver exposes one i=
nterface per channel and provides user the data from two data pins as if it=
 comes from one device interface.

Thanks,
Ramesh
