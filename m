Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:53173 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdKMImC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 03:42:02 -0500
MIME-Version: 1.0
In-Reply-To: <20171111003835.4909-26-niklas.soderlund+renesas@ragnatech.se>
References: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se> <20171111003835.4909-26-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 13 Nov 2017 09:42:01 +0100
Message-ID: <CAMuHMdXP7jOK8LxMtUFkEn0ooPPuodomVr2sqkNX4idMzrmrpw@mail.gmail.com>
Subject: Re: [PATCH v7 25/25] rcar-vin: enable support for r8a7796
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CC DT

On Sat, Nov 11, 2017 at 1:38 AM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Add the SoC specific information for Renesas r8a7796.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../devicetree/bindings/media/rcar_vin.txt         |  1 +
>  drivers/media/platform/rcar-vin/rcar-core.c        | 64 ++++++++++++++++=
++++++
>  2 files changed, 65 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Docum=
entation/devicetree/bindings/media/rcar_vin.txt
> index df1abd0fb20386f8..ddf249c2276600d2 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -10,6 +10,7 @@ Depending on the instance the VIN input is connected to=
 external SoC pins, or
>  on Gen3 to a CSI-2 receiver.
>
>   - compatible: Must be one or more of the following
> +   - "renesas,vin-r8a7796" for the R8A7796 device
>     - "renesas,vin-r8a7795" for the R8A7795 device
>     - "renesas,vin-r8a7794" for the R8A7794 device
>     - "renesas,vin-r8a7793" for the R8A7793 device
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/=
platform/rcar-vin/rcar-core.c
> index b22f6596700d2479..e329de4ce0172e8d 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1084,6 +1084,66 @@ static const struct rvin_info rcar_info_r8a7795es1=
 =3D {
>         },
>  };
>
> +static const struct rvin_info rcar_info_r8a7796 =3D {
> +       .chip =3D RCAR_GEN3,
> +       .use_mc =3D true,
> +       .max_width =3D 4096,
> +       .max_height =3D 4096,
> +
> +       .num_chsels =3D 5,
> +       .chsels =3D {
> +               {
> +                       { .csi =3D RVIN_CSI40, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 0 },
> +                       { .csi =3D RVIN_NC, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 0 },
> +               }, {
> +                       { .csi =3D RVIN_CSI20, .chan =3D 0 },
> +                       { .csi =3D RVIN_NC, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 1 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 1 },
> +               }, {
> +                       { .csi =3D RVIN_NC, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 2 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 2 },
> +               }, {
> +                       { .csi =3D RVIN_CSI40, .chan =3D 1 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 1 },
> +                       { .csi =3D RVIN_NC, .chan =3D 1 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 3 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 3 },
> +               }, {
> +                       { .csi =3D RVIN_CSI40, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 0 },
> +                       { .csi =3D RVIN_NC, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 0 },
> +               }, {
> +                       { .csi =3D RVIN_CSI20, .chan =3D 0 },
> +                       { .csi =3D RVIN_NC, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 1 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 1 },
> +               }, {
> +                       { .csi =3D RVIN_NC, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 0 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 2 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 2 },
> +               }, {
> +                       { .csi =3D RVIN_CSI40, .chan =3D 1 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 1 },
> +                       { .csi =3D RVIN_NC, .chan =3D 1 },
> +                       { .csi =3D RVIN_CSI40, .chan =3D 3 },
> +                       { .csi =3D RVIN_CSI20, .chan =3D 3 },
> +               },
> +       },
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] =3D {
>         {
>                 .compatible =3D "renesas,vin-r8a7778",
> @@ -1117,6 +1177,10 @@ static const struct of_device_id rvin_of_id_table[=
] =3D {
>                 .compatible =3D "renesas,vin-r8a7795",
>                 .data =3D &rcar_info_r8a7795,
>         },
> +       {
> +               .compatible =3D "renesas,vin-r8a7796",
> +               .data =3D &rcar_info_r8a7796,
> +       },
>         { },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> --
> 2.15.0
