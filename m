Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44078 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964869AbeBMPYS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 10:24:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 01/30] rcar-vin: add Gen3 devicetree bindings documentation
Date: Tue, 13 Feb 2018 17:24:48 +0200
Message-ID: <46039812.JCXGEBrsCi@avalon>
In-Reply-To: <20180129163435.24936-2-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:06 EET Niklas S=F6derlund wrote:
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

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  .../devicetree/bindings/media/rcar_vin.txt         | 118 +++++++++++++++=
=2D--
>  1 file changed, 106 insertions(+), 12 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt
> b/Documentation/devicetree/bindings/media/rcar_vin.txt index
> c60e6b0a89b67a8c..90d92836284b7f68 100644
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
> +Each VIN instance has a single parallel input that supports RGB and YUV
> video, +with both external synchronization and BT.656 synchronization for
> the latter. +Depending on the instance the VIN input is connected to
> external SoC pins, or +on Gen3 platforms to a CSI-2 receiver.
>=20
>   - compatible: Must be one or more of the following
>     - "renesas,vin-r8a7743" for the R8A7743 device
> @@ -16,6 +20,8 @@ channel which can be either RGB, YUYV or BT656.
>     - "renesas,vin-r8a7793" for the R8A7793 device
>     - "renesas,vin-r8a7794" for the R8A7794 device
>     - "renesas,vin-r8a7795" for the R8A7795 device
> +   - "renesas,vin-r8a7796" for the R8A7796 device
> +   - "renesas,vin-r8a77970" for the R8A77970 device
>     - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
>       device.
>     - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
> @@ -31,21 +37,38 @@ channel which can be either RGB, YUYV or BT656.
>  Additionally, an alias named vinX will need to be created to specify
>  which video input device this is.
>=20
> -The per-board settings:
> +The per-board settings Gen2 platforms:
>   - port sub-node describing a single endpoint connected to the vin
>     as described in video-interfaces.txt[1]. Only the first one will
>     be considered as each vin interface has one input port.
>=20
> -   These settings are used to work out video input format and widths
> -   into the system.
> +The per-board settings Gen3 platforms:
>=20
> +Gen3 platforms can support both a single connected parallel input source
> +from external SoC pins (port0) and/or multiple parallel input sources
> +from local SoC CSI-2 receivers (port1) depending on SoC.
>=20
> -Device node example
> --------------------
> +- renesas,id - ID number of the VIN, VINx in the documentation.
> +- ports
> +    - port 0 - sub-node describing a single endpoint connected to the VIN
> +      from external SoC pins described in video-interfaces.txt[1].
> +      Describing more then one endpoint in port 0 is invalid. Only VIN
> +      instances that are connected to external pins should have port 0.
> +    - port 1 - sub-nodes describing one or more endpoints connected to
> +      the VIN from local SoC CSI-2 receivers. The endpoint numbers must
> +      use the following schema.
>=20
> -	aliases {
> -	       vin0 =3D &vin0;
> -	};
> +        - Endpoint 0 - sub-node describing the endpoint connected to CSI=
20
> +        - Endpoint 1 - sub-node describing the endpoint connected to CSI=
21
> +        - Endpoint 2 - sub-node describing the endpoint connected to CSI=
40
> +        - Endpoint 3 - sub-node describing the endpoint connected to CSI=
41
> +
> +Device node example for Gen2 platforms
> +--------------------------------------
> +
> +        aliases {
> +                vin0 =3D &vin0;
> +        };
>=20
>          vin0: vin@e6ef0000 {
>                  compatible =3D "renesas,vin-r8a7790",
> "renesas,rcar-gen2-vin"; @@ -55,8 +78,8 @@ Device node example
>                  status =3D "disabled";
>          };
>=20
> -Board setup example (vin1 composite video input)
> -------------------------------------------------
> +Board setup example for Gen2 platforms (vin1 composite video input)
> +-------------------------------------------------------------------
>=20
>  &i2c2   {
>          status =3D "ok";
> @@ -95,6 +118,77 @@ Board setup example (vin1 composite video input)
>          };
>  };
>=20
> +Device node example for Gen3 platforms
> +--------------------------------------
>=20
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
> +
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
