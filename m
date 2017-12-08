Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46657 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbdLHHqG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 02:46:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 01/28] rcar-vin: add Gen3 devicetree bindings documentation
Date: Fri, 08 Dec 2017 09:46:24 +0200
Message-ID: <1516159.4MxLsDy55H@avalon>
In-Reply-To: <20171208010842.20047-2-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:15 EET Niklas S=F6derlund wrote:
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
> Acked-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/media/rcar_vin.txt         | 116 +++++++++++++++=
=2D--
>  1 file changed, 104 insertions(+), 12 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt
> b/Documentation/devicetree/bindings/media/rcar_vin.txt index
> ff9697ed81396e64..5a95d9668d2c7dfd 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -2,8 +2,12 @@ Renesas R-Car Video Input driver (rcar_vin)
>  -------------------------------------------
>=20
>  The rcar_vin device provides video input capabilities for the Renesas R-=
Car
> -family of devices. The current blocks are always slaves and suppot one
> input
> -channel which can be either RGB, YUYV or BT656.
> +family of devices.
> +
> +Each VIN instance has a single parallel input that supports RGB and YUV
> video,
> +with both external synchronization and BT.656 synchronization for the
> latter.
> +Depending on the instance the VIN input is connected to external SoC pin=
s,
> or
> +on Gen3 to a CSI-2 receiver.
>=20
>   - compatible: Must be one or more of the following
>     - "renesas,vin-r8a7743" for the R8A7743 device
> @@ -31,21 +35,38 @@ channel which can be either RGB, YUYV or BT656.
>  Additionally, an alias named vinX will need to be created to specify
>  which video input device this is.
>=20
> -The per-board settings:
> +The per-board settings Gen2:

Nitpicking, s/Gen2/for Gen2 platforms/

(or Gen2 hardware, or Gen2 systems, pick the one you like best)

>   - port sub-node describing a single endpoint connected to the vin
>     as described in video-interfaces.txt[1]. Only the first one will
>     be considered as each vin interface has one input port.
>=20
> -   These settings are used to work out video input format and widths
> -   into the system.
> +The per-board settings Gen3:

Ditto.

> +
> +Gen3 can support both a single connected parallel input source from
> +external SoC pins (port0) and/or multiple parallel input sources from
> +local SoC CSI-2 receivers (port1) depending on SoC.
>=20
> +- renesas,id - ID number of the VIN, VINx in the documentation.
> +- ports
> +    - port0 - sub-node describing a single endpoint connected to the VIN
> +      from external SoC pins described in video-interfaces.txt[1]. Only
> +      the first one will be considered as each VIN interface has at most
> +      one set of SoC external input pins.

s/port0/port 0/ or s/port0/port@0/

I'd go further than that and make it invalid to have multiple endpoints=20
instead of ignoring all but the first one.

I would also explicitly state that VIN instances not connected to external=
=20
pins shall have no port 0.

> +    - port1 - sub-nodes describing one or more endpoints connected to
> +      the VIN from local SoC CSI-2 receivers. The endpoint numbers must
> +      use the following schema.

Nitpicking again, the Gen2-specific properties are indented above while the=
=20
Gen3 properties are not indented here. Pick the one you prefer :-)

> -Device node example
> --------------------
> +        - Endpoint 0 - sub-node describing the endpoint which is CSI20
> +        - Endpoint 1 - sub-node describing the endpoint which is CSI21
> +        - Endpoint 2 - sub-node describing the endpoint which is CSI40
> +        - Endpoint 3 - sub-node describing the endpoint which is CSI41

How about s/which is/connected to/ ?

> -	aliases {
> -	       vin0 =3D &vin0;
> -	};
> +Device node example Gen2

s/Gen2/for Gen2 platforms/

and same in a few places below.

> +------------------------
> +
> +        aliases {
> +                vin0 =3D &vin0;
> +        };

This is unrelated, but do we need aliases ?

>          vin0: vin@0xe6ef0000 {
>                  compatible =3D "renesas,vin-r8a7790",
> "renesas,rcar-gen2-vin"; @@ -55,8 +76,8 @@ Device node example
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
> @@ -95,6 +116,77 @@ Board setup example (vin1 composite video input)
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
> +                resets =3D <&cpg 811>;
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
> +                compatible =3D "renesas,r8a7795-csi2";
> +                reg =3D <0 0xfea80000 0 0x10000>;
> +                interrupts =3D <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks =3D <&cpg CPG_MOD 714>;
> +                power-domains =3D <&sysc R8A7795_PD_ALWAYS_ON>;
> +                resets =3D <&cpg 714>;
> +
> +                ports {
> +                        #address-cells =3D <1>;
> +                        #size-cells =3D <0>;
> +
> +                        port@0 {
> +                                reg =3D <0>;
> +                                csi20_in: endpoint {
> +                                        clock-lanes =3D <0>;
> +                                        data-lanes =3D <1>;
> +                                        remote-endpoint =3D <&adv7482_tx=
b>;
> +                                };
> +                        };
> +
> +                        port@1 {
> +                                #address-cells =3D <1>;
> +                                #size-cells =3D <0>;
>=20
> +                                reg =3D <1>;
> +
> +                                csi20vin0: endpoint@0 {
> +                                        reg =3D <0>;
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
