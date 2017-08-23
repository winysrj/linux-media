Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55367 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753425AbdHWIO0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 04:14:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 01/25] rcar-vin: add Gen3 devicetree bindings documentation
Date: Wed, 23 Aug 2017 11:14:55 +0300
Message-ID: <9655432.1VZf2eld8h@avalon>
In-Reply-To: <20170822232640.26147-2-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se> <20170822232640.26147-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Wednesday, 23 August 2017 02:26:16 EEST Niklas S=F6derlund wrote:
> Document the devicetree bindings for the CSI-2 inputs available on Gen3.
>=20
> There is a need to add a custom property 'renesas,id' and to define
> which CSI-2 input is described in which endpoint under the port@1 node.
> This information is needed since there are a set of predefined routes
> between each VIN and CSI-2 block. This routing table will be kept
> inside the driver but in order for it to act on it it must know which
> VIN and CSI-2 is which.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  .../devicetree/bindings/media/rcar_vin.txt         | 106 +++++++++++++++=
+--
>  1 file changed, 96 insertions(+), 10 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt
> b/Documentation/devicetree/bindings/media/rcar_vin.txt index
> 6e4ef8caf759e5d3..be38ad89d71ad05d 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -2,8 +2,12 @@ Renesas R-Car Video Input driver (rcar_vin)
>  -------------------------------------------
>=20
>  The rcar_vin device provides video input capabilities for the Renesas R-=
Car
> -family of devices. The current blocks are always slaves and suppot one
> input -channel which can be either RGB, YUYV or BT656.
> +family of devices.
> +
> +On Gen2 the current blocks are always slaves and support one input chann=
el
> +which can be either RGB, YUYV or BT656.

What do you mean by "are always slaves" ?

> On Gen3 the current blocks are
> +always slaves and support multiple input channels which can be either RG=
B,
> +YUVU, BT656 or CSI-2.

Strictly speaking VIN on Gen3 doesn't handle CSI-2, the CSI-2 receiver=20
deserializes the video stream and produces a parallel input.

You could word this as follows.

Each VIN instance has a single parallel input that supports RGB and YUV vid=
eo,=20
with both external synchronization and BT.656 synchronization for the latte=
r.=20
Depending on the instance the VIN input is connected to external SoC pins, =
or=20
on Gen3 to a CSI-2 receiver.

>   - compatible: Must be one or more of the following
>     - "renesas,vin-r8a7795" for the R8A7795 device
> @@ -28,7 +32,7 @@ channel which can be either RGB, YUYV or BT656.
>  Additionally, an alias named vinX will need to be created to specify
>  which video input device this is.
>=20
> -The per-board settings:
> +The per-board settings Gen2:
>   - port sub-node describing a single endpoint connected to the vin
>     as described in video-interfaces.txt[1]. Only the first one will
>     be considered as each vin interface has one input port.
> @@ -36,13 +40,21 @@ The per-board settings:
>     These settings are used to work out video input format and widths
>     into the system.

Not related to this patch, but I don't understand how that sentence is rela=
ted=20
to the previous one.

> +The per-board settings Gen3:
> +- renesas,id - ID number of the VIN

You should define what the ID is.

> +- Port 0 - Digital video source (same as port node on Gen2)
> +- Port 1 - CSI-2 video sources
> +        - Endpoint 0 - sub-node describing the endpoint which is CSI20
> +        - Endpoint 1 - sub-node describing the endpoint which is CSI21
> +        - Endpoint 2 - sub-node describing the endpoint which is CSI40
> +        - Endpoint 3 - sub-node describing the endpoint which is CSI41

Given that the parallel input and CSI-2 input are mutually exclusive,=20
shouldn't the VIN have a single port ?

I think nodes and endpoints need slightly more detailed documentation.

> -Device node example
> --------------------
> +Device node example Gen2
> +------------------------
>=20
> -	aliases {
> -	       vin0 =3D &vin0;
> -	};
> +        aliases {
> +                vin0 =3D &vin0;
> +        };

Do we need the aliases ?

>          vin0: vin@0xe6ef0000 {
>                  compatible =3D "renesas,vin-r8a7790",
> "renesas,rcar-gen2-vin"; @@ -52,8 +64,8 @@ Device node example
>                  status =3D "disabled";
>          };
>=20
> -Board setup example (vin1 composite video input)
> -------------------------------------------------
> +Board setup example Gen2 (vin1 composite video input)
> +-----------------------------------------------------
>=20
>  &i2c2   {
>          status =3D "ok";
> @@ -92,6 +104,80 @@ Board setup example (vin1 composite video input)
>          };
>  };
>=20
> +Device node example Gen3
> +------------------------
> +
> +        vin0: video@e6ef0000 {
> +                compatible =3D "renesas,vin-r8a7795";
> +                reg =3D <0 0xe6ef0000 0 0x1000>;
> +                interrupts =3D <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks =3D <&cpg CPG_MOD 811>;
> +                power-domains =3D <&sysc R8A7795_PD_ALWAYS_ON>;
> +                status =3D "disabled";
> +
> +                renesas,id =3D <0>;
> +
> +                ports {
> +                        #address-cells =3D <1>;
> +                        #size-cells =3D <0>;
> +
> +                        port@1 {
> +                                #address-cells =3D <1>;
> +                                #size-cells =3D <0>;
> +
> +                                reg =3D <1>;
> +
> +                                vin0csi20: endpoint@0 {
> +                                        reg =3D <0>;
> +                                        remote-endpoint=3D <&csi20vin0>;
> +                                };
> +                                vin0csi21: endpoint@1 {
> +                                        reg =3D <1>;
> +                                        remote-endpoint=3D <&csi21vin0>;
> +                                };
> +                                vin0csi40: endpoint@2 {
> +                                        reg =3D <2>;
> +                                        remote-endpoint=3D <&csi40vin0>;
> +                                };
> +                        };
> +                };
> +        };
> +
> +        csi20: csi2@fea80000 {
> +                compatible =3D "renesas,r8a7795-csi2",
> "renesas,rcar-gen3-csi2"; +                reg =3D <0 0xfea80000 0 0x1000=
0>;
> +                interrupts =3D <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks =3D <&cpg CPG_MOD 714>;
> +                power-domains =3D <&sysc R8A7795_PD_ALWAYS_ON>;
> +                status =3D "disabled";
> +
> +                ports {
> +                        #address-cells =3D <1>;
> +                        #size-cells =3D <0>;
> +
> +                        port@0 {
> +                        #address-cells =3D <1>;
> +                        #size-cells =3D <0>;

Wrong indentation.

> +
> +                                reg =3D <0>;
> +                                csi20_in: endpoint@0 {

Do you need to number the endpoint ? If not you could omit the #address-cel=
ls=20
and #size-cells properties. Otherwise you need a reg property here.

> +                                        clock-lanes =3D <0>;
> +                                        data-lanes =3D <1>;
> +                                        remote-endpoint =3D <&adv7482_tx=
b>;
> +                                };
> +                        };
>=20
> +                        port@1 {
> +                                #address-cells =3D <1>;
> +                                #size-cells =3D <0>;
> +
> +                                reg =3D <1>;
> +
> +                                csi20vin0: endpoint@0 {

I assume this one needs to be numbered as will have multiple endpoints (one=
=20
per remote VIN).

> +                                        remote-endpoint =3D <&vin0csi20>;
> +                                };
> +                        };
> +                };
> +        };
>=20
>  [1] video-interfaces.txt common video media interface


=2D-=20
Regards,

Laurent Pinchart
