Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:54279 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752826AbcJRPN4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 11:13:56 -0400
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
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [RFC 3/5] media: platform: rcar_drif: Add DRIF support
Date: Tue, 18 Oct 2016 15:13:47 +0000
Message-ID: <SG2PR06MB103827EE5421ADE589C45DEDC3D30@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1476281429-27603-4-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <20161018131314.gn6hpxwzevpcatll@rob-hp-laptop>
In-Reply-To: <20161018131314.gn6hpxwzevpcatll@rob-hp-laptop>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Thank you for the review comments.

> Subject: Re: [RFC 3/5] media: platform: rcar_drif: Add DRIF support
>=20
> On Wed, Oct 12, 2016 at 03:10:27PM +0100, Ramesh Shanmugasundaram wrote:
> > This patch adds Digital Radio Interface (DRIF) support to R-Car Gen3
> SoCs.
> > The driver exposes each instance of DRIF as a V4L2 SDR device. A DRIF
> > device represents a channel and each channel can have one or two
> > sub-channels respectively depending on the target board.
> >
> > DRIF supports only Rx functionality. It receives samples from a RF
> > frontend tuner chip it is interfaced with. The combination of DRIF and
> > the tuner device, which is registered as a sub-device, determines the
> > receive sample rate and format.
> >
> > In order to be compliant as a V4L2 SDR device, DRIF needs to bind with
> > the tuner device, which can be provided by a third party vendor. DRIF
> > acts as a slave device and the tuner device acts as a master
> > transmitting the samples. The driver allows asynchronous binding of a
> > tuner device that is registered as a v4l2 sub-device. The driver can
> > learn about the tuner it is interfaced with based on port endpoint
> > properties of the device in device tree. The V4L2 SDR device inherits
> > the controls exposed by the tuner device.
> >
> > The device can also be configured to use either one or both of the
> > data pins at runtime based on the master (tuner) configuration.
> >
> > Signed-off-by: Ramesh Shanmugasundaram
> > <ramesh.shanmugasundaram@bp.renesas.com>
> > ---
> >  .../devicetree/bindings/media/renesas,drif.txt     |  109 ++
> >  drivers/media/platform/Kconfig                     |   25 +
> >  drivers/media/platform/Makefile                    |    1 +
> >  drivers/media/platform/rcar_drif.c                 | 1534
> ++++++++++++++++++++
> >  4 files changed, 1669 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/media/renesas,drif.txt
> >  create mode 100644 drivers/media/platform/rcar_drif.c
> >
> > diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt
> > b/Documentation/devicetree/bindings/media/renesas,drif.txt
> > new file mode 100644
> > index 0000000..24239d9
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
> > @@ -0,0 +1,109 @@
> > +Renesas R-Car Gen3 DRIF controller (DRIF)
>=20
> Define what is DRIF here, not just in the commit text.

Agreed.

>=20
> > +-----------------------------------------
> > +
> > +Required properties:
> > +--------------------
> > +- compatible: "renesas,drif-r8a7795" if DRIF controller is a part of
> R8A7795 SoC.
>=20
> renesas,r8a7795-drif would be the normal ordering.

Agreed.

>=20
> > +	      "renesas,rcar-gen3-drif" for a generic R-Car Gen3 compatible
> device.
> > +	      When compatible with the generic version, nodes must list the
> > +	      SoC-specific version corresponding to the platform first
> > +	      followed by the generic version.
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
> > +- Each DRIF channel can have one or both of the sub-channels enabled
> > +in a
> > +  setup. The sub-channels are represented as a child node. The name
> > +of the
> > +  child nodes are "sub-channel0" and "sub-channel1" respectively.
> > +Each child
> > +  node supports the "status" property only, which is used to
> > +enable/disable
> > +  the respective sub-channel.
> > +
> > +Optional properties:
> > +--------------------
> > +- port: video interface child port node of a channel that defines the
> > +local
>=20
> This is an audio device, why does it have a video port?

Apologies for the wording. I intend to refer a regular port node like menti=
oned here - https://www.kernel.org/doc/Documentation/devicetree/bindings/gr=
aph.txt

>=20
> > +  and remote endpoints. The remote endpoint is assumed to a tuner
> > +subdevice
> > +  endpoint.
> > +- power-domains: phandle to respective power domain.
> > +- renesas,syncmd       : sync mode
> > +			 0 (Frame start sync pulse mode. 1-bit width pulse
> > +			    indicates start of a frame)
> > +			 1 (L/R sync or I2S mode) (default)
> > +- renesas,lsb-first    : empty property indicates lsb bit is received
> first.
> > +			 When not defined msb bit is received first (default)
> > +- renesas,syncac-pol-high  : empty property indicates sync signal
> polarity.
> > +			 When defined, active high or high->low sync signal.
> > +			 When not defined, active low or low->high sync signal
> > +			 (default)
> > +- renesas,dtdl         : delay between sync signal and start of
> reception.
> > +			 Must contain one of the following values:
> > +			 0   (no bit delay)
> > +			 50  (0.5-clock-cycle delay)
> > +			 100 (1-clock-cycle delay) (default)
> > +			 150 (1.5-clock-cycle delay)
> > +			 200 (2-clock-cycle delay)
> > +- renesas,syncdl       : delay between end of reception and sync signa=
l
> edge.
> > +			 Must contain one of the following values:
> > +			 0   (no bit delay) (default)
> > +			 50  (0.5-clock-cycle delay)
> > +			 100 (1-clock-cycle delay)
> > +			 150 (1.5-clock-cycle delay)
> > +			 200 (2-clock-cycle delay)
> > +			 300 (3-clock-cycle delay)
> > +
> > +Example
> > +--------
> > +
> > +SoC common dtsi file
> > +
> > +drif0: rif@e6f40000 {
> > +	compatible =3D "renesas,drif-r8a7795",
> > +		   "renesas,rcar-gen3-drif";
> > +	reg =3D <0 0xe6f40000 0 0x64>, <0 0xe6f50000 0 0x64>;
> > +	interrupts =3D <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
> > +		   <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
> > +	clocks =3D <&cpg CPG_MOD 515>, <&cpg CPG_MOD 514>;
> > +	clock-names =3D "fck0", "fck1";
> > +	dmas =3D <&dmac1 0x20>, <&dmac1 0x22>;
> > +	dma-names =3D "rx0", "rx1";
> > +	power-domains =3D <&sysc R8A7795_PD_ALWAYS_ON>;
> > +	status =3D "disabled";
> > +
> > +	sub-channel0 {
> > +		status =3D "disabled";
> > +	};
> > +
> > +	sub-channel1 {
> > +		status =3D "disabled";
> > +	};
> > +
> > +};
> > +
> > +Board specific dts file
> > +
> > +&drif0 {
> > +	pinctrl-0 =3D <&drif0_pins>;
> > +	pinctrl-names =3D "default";
> > +	status =3D "okay";
> > +
> > +	sub-channel0 {
> > +		status =3D "okay";
> > +	};
> > +
> > +	sub-channel1 {
> > +		status =3D "okay";
> > +	};
> > +
> > +	port {
> > +		drif0_ep: endpoint {
> > +		     remote-endpoint =3D <&tuner_subdev_ep>;
> > +		};
> > +	};
> > +};

Thanks,
Ramesh
