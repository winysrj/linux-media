Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34622 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752721AbcKGMro (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 07:47:44 -0500
MIME-Version: 1.0
In-Reply-To: <20161102132329.436-31-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se> <20161102132329.436-31-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 7 Nov 2016 13:47:42 +0100
Message-ID: <CAMuHMdUa4hnAZDD-yUk=+=eYdutHoALQhfAj4wcNd90ocX+vMw@mail.gmail.com>
Subject: Re: [PATCH 30/32] media: rcar-vin: add Gen3 devicetree bindings documentation
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 2, 2016 at 2:23 PM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Document the Gen3 devicetree bindings. The new bindings are all handled
> in the port@1 node, if a endpoint is described as on Gen2 in port@0 the

an endpoint

> driver will work in Gen2 mode and this is supported on Gen3. The new
> CSI-2 video sources are only supported on Gen3.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  .../devicetree/bindings/media/rcar_vin.txt         | 116 +++++++++++++++=
++++--
>  1 file changed, 106 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Docum=
entation/devicetree/bindings/media/rcar_vin.txt
> index 6a4e61c..a51cf70 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -2,8 +2,12 @@ Renesas RCar Video Input driver (rcar_vin)
>  ------------------------------------------
>
>  The rcar_vin device provides video input capabilities for the Renesas R-=
Car
> -family of devices. The current blocks are always slaves and suppot one i=
nput
> -channel which can be either RGB, YUYV or BT656.
> +family of devices.
> +
> +On Gen2 the current blocks are always slaves and support one input chann=
el
> +which can be either RGB, YUYV or BT656. On Gen3 the current blocks are
> +always slaves and support multiple input channels which can be ether RGB=
,

either

> +YUVU, BT656 or CSI-2.

> @@ -92,6 +105,89 @@ Board setup example (vin1 composite video input)
>          };
>  };
>
> +Device node example Gen3
> +------------------------
> +
> +        aliases {
> +                vin0 =3D &vin0;
> +        };
> +
> +        vin1: video@e6ef1000 {
> +                compatible =3D "renesas,vin-r8a7796";
> +                reg =3D  <0 0xe6ef1000 0 0x1000>;
> +                interrupts =3D <0 189 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks =3D <&cpg CPG_MOD 810>;
> +                power-domains =3D <&cpg>;

Please update the power-domains property to match reality.

> +                status =3D "disabled";
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
> +                                vin1csi20: endpoint@0 {
> +                                        reg =3D <0>;
> +                                        remote-endpoint=3D <&csi20vin1>;
> +                                };
> +                        };
> +                };
> +        };
> +
> +        csi20: csi2@fea80000 {
> +                compatible =3D "renesas,r8a7796-csi2";
> +                reg =3D <0 0xfea80000 0 0x10000>;
> +                interrupts =3D <0 184 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks =3D <&cpg CPG_MOD 714>;
> +                power-domains =3D <&cpg>;

Likewise.

> +                status =3D "disabled";
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
> +                                csi20vin1: endpoint@1 {
> +                                        reg =3D <1>;
> +                                        remote-endpoint =3D <&vin1csi20>=
;
> +                                };
> +                        };
> +                };
> +        };




--=20
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
