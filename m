Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:56299 "EHLO
        relmlie4.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753035AbdBPLDD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 06:03:03 -0500
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Rob Herring <robh@kernel.org>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 6/7] dt-bindings: media: Add Renesas R-Car DRIF binding
Date: Thu, 16 Feb 2017 11:02:55 +0000
Message-ID: <HK2PR06MB0545DC72450687BA47610DA6C35A0@HK2PR06MB0545.apcprd06.prod.outlook.com>
References: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1486479757-32128-7-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <20170215170919.lxmqryjxdo3uxil2@rob-hp-laptop>
In-Reply-To: <20170215170919.lxmqryjxdo3uxil2@rob-hp-laptop>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Thank you for the review comments.

> Subject: Re: [PATCH v3 6/7] dt-bindings: media: Add Renesas R-Car DRIF
> binding
>=20
> On Tue, Feb 07, 2017 at 03:02:36PM +0000, Ramesh Shanmugasundaram wrote:
> > Add binding documentation for Renesas R-Car Digital Radio Interface
> > (DRIF) controller.
> >
> > Signed-off-by: Ramesh Shanmugasundaram
> > <ramesh.shanmugasundaram@bp.renesas.com>
> > ---
> >  .../devicetree/bindings/media/renesas,drif.txt     | 186
> +++++++++++++++++++++
> >  1 file changed, 186 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/media/renesas,drif.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt
> > b/Documentation/devicetree/bindings/media/renesas,drif.txt
> > new file mode 100644
> > index 0000000..6315609
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
> > @@ -0,0 +1,186 @@
> > +Renesas R-Car Gen3 Digital Radio Interface controller (DRIF)
> > +------------------------------------------------------------
> > +
> > +R-Car Gen3 DRIF is a SPI like receive only slave device. A general
> > +representation of DRIF interfacing with a master device is shown below=
.
> > +
> > ++---------------------+                +---------------------+
> > +|                     |-----SCK------->|CLK                  |
> > +|       Master        |-----SS-------->|SYNC  DRIFn (slave)  |
> > +|                     |-----SD0------->|D0                   |
> > +|                     |-----SD1------->|D1                   |
> > ++---------------------+                +---------------------+
> > +
> > +As per the datasheet, each DRIF channel (drifn) is made up of two
> > +internal channels (drifn0 & drifn1). These two internal channels
> > +share the common CLK & SYNC. Each internal channel has its own
> > +dedicated resources like irq, dma channels, address space & clock.
> > +This internal split is not visible to the external master device.
> > +
> > +The device tree model represents each internal channel as a separate
> node.
> > +The internal channels sharing the CLK & SYNC are tied together by
> > +their phandles using a new property called "renesas,bonding". For the
> > +rest of the documentation, unless explicitly stated, the word channel
> > +implies an internal channel.
> > +
> > +When both internal channels are enabled they need to be managed
> > +together as one (i.e.) they cannot operate alone as independent
> > +devices. Out of the two, one of them needs to act as a primary device
> > +that accepts common properties of both the internal channels. This
> > +channel is identified by a new property called "renesas,primary-bond".
> > +
> > +To summarize,
> > +   - When both the internal channels that are bonded together are
> enabled,
> > +     the zeroth channel is selected as primary-bond. This channels
> accepts
> > +     properties common to all the members of the bond.
> > +   - When only one of the bonded channels need to be enabled, the
> property
> > +     "renesas,bonding" or "renesas,primary-bond" will have no effect.
> That
> > +     enabled channel can act alone as any other independent device.
> > +
> > +Required properties of an internal channel:
> > +-------------------------------------------
> > +- compatible: "renesas,r8a7795-drif" if DRIF controller is a part of
> R8A7795 SoC.
> > +	      "renesas,rcar-gen3-drif" for a generic R-Car Gen3 compatible
> device.
> > +	      When compatible with the generic version, nodes must list the
> > +	      SoC-specific version corresponding to the platform first
> > +	      followed by the generic version.
> > +- reg: offset and length of that channel.
> > +- interrupts: associated with that channel.
> > +- clocks: phandle and clock specifier of that channel.
> > +- clock-names: clock input name string: "fck".
> > +- dmas: phandles to the DMA channels.
> > +- dma-names: names of the DMA channel: "rx".
> > +- renesas,bonding: phandle to the other channel.
> > +
> > +Optional properties of an internal channel:
> > +-------------------------------------------
> > +- power-domains: phandle to the respective power domain.
> > +
> > +Required properties of an internal channel when:
> > +	- It is the only enabled channel of the bond (or)
> > +	- If it acts as primary among enabled bonds
> > +--------------------------------------------------------
> > +- pinctrl-0: pin control group to be used for this channel.
> > +- pinctrl-names: must be "default".
> > +- renesas,primary-bond: empty property indicating the channel acts as
> primary
> > +			among the bonded channels.
> > +- port: child port node of a channel that defines the local and remote
> > +	endpoints. The remote endpoint is assumed to be a third party tuner
> > +	device endpoint.
> > +
> > +Optional endpoint property:
> > +---------------------------
> > +- renesas,sync-active  : Indicates sync signal polarity, 0/1 for
> low/high
> > +			 respectively. This property maps to SYNCAC bit in the
> > +			 hardware manual. The default is 1 (active high)
>=20
> Why does this belong in the endpoint? I'd prefer to not have vendor
> specific properties in endpoints. Is this a property of the tuner or DRIF=
?

This property is similar to the properties in Documentation/devicetree/bind=
ings/media/video-interfaces.txt (e.g. hsync-active, vsync-active).Hence, La=
urent & Hans suggested this to be defined as an endpoint property and try t=
o standardize it.

I think I see your point. As endpoint properties can be defined on both end=
points, having a vendor specific property is a problem with a third party t=
uner. We could remove the vendor tag and make it  a generic property "sync-=
active", if you are OK with it?=20

This property can be defined for both tuner and DRIF. However, it would mos=
tly be a constant in the case of tuner because as per I2S spec, transmitter=
 WS (sync) changes from high->low & low->high always. Only DRIF allows the =
option to latch when WS high->low or low->high - both cases.

In a traditional use case it is always WS high->low latching to get the fir=
st data. However, with DRIF & MAX2175 combo, our latest investigations reve=
al that latching when WS low->high provided better synchronization on all c=
ases. There is no loss of data by doing this. Hence, it would be nice to re=
tain this as a configurable property.

Please advice.


>=20
> > +
> > +Example
> > +--------
> > +
> > +SoC common dtsi file
> > +
> > +		drif00: rif@e6f40000 {
> > +			compatible =3D "renesas,r8a7795-drif",
> > +				     "renesas,rcar-gen3-drif";
> > +			reg =3D <0 0xe6f40000 0 0x64>;
> > +			interrupts =3D <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
> > +			clocks =3D <&cpg CPG_MOD 515>;
> > +			clock-names =3D "fck";
> > +			dmas =3D <&dmac1 0x20>, <&dmac2 0x20>;
> > +			dma-names =3D "rx", "rx";
> > +			power-domains =3D <&sysc R8A7795_PD_ALWAYS_ON>;
> > +			renesas,bonding =3D <&drif01>;
> > +			status =3D "disabled";
>=20
> Don't put "status" in examples.

OK. Will note this down for future patches. Will be corrected in the next v=
ersion.

>=20
> > +		};
> > +
> > +		drif01: rif@e6f50000 {
> > +			compatible =3D "renesas,r8a7795-drif",
> > +				     "renesas,rcar-gen3-drif";
> > +			reg =3D <0 0xe6f50000 0 0x64>;
> > +			interrupts =3D <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
> > +			clocks =3D <&cpg CPG_MOD 514>;
> > +			clock-names =3D "fck";
> > +			dmas =3D <&dmac1 0x22>, <&dmac2 0x22>;
> > +			dma-names =3D "rx", "rx";
> > +			power-domains =3D <&sysc R8A7795_PD_ALWAYS_ON>;
> > +			renesas,bonding =3D <&drif00>;
> > +			status =3D "disabled";
> > +		};
> > +
> > +
> > +Board specific dts file
>=20
> Chip vs. board in not relevant to the binding doc. Please combine them
> here in your example.

Will do.

Thanks,
Ramesh

>=20
> Rob
