Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34640 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751204AbdCPIgE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Mar 2017 04:36:04 -0400
MIME-Version: 1.0
In-Reply-To: <20170314190308.25790-28-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se> <20170314190308.25790-28-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Mar 2017 09:36:01 +0100
Message-ID: <CAMuHMdUWeWoDHSqH5i_KT_LHhH2dhq29tQeranPNjG=UORdajA@mail.gmail.com>
Subject: Re: [PATCH v3 27/27] rcar-vin: enable support for r8a7796
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

Hi Niklas,

On Tue, Mar 14, 2017 at 8:03 PM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Add the SoC specific information for Renesas r8a7796.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  .../devicetree/bindings/media/rcar_vin.txt         |  1 +
>  drivers/media/platform/rcar-vin/rcar-core.c        | 64 ++++++++++++++++=
++++++
>  2 files changed, 65 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Docum=
entation/devicetree/bindings/media/rcar_vin.txt
> index ffdfa97ac37753f9..7e36ebe5c89b7dfd 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -10,6 +10,7 @@ always slaves and support multiple input channels which=
 can be either RGB,
>  YUVU, BT656 or CSI-2.
>
>   - compatible: Must be one or more of the following
> +   - "renesas,vin-r8a7796" for the R8A7796 device
>     - "renesas,vin-r8a7795" for the R8A7795 device
>     - "renesas,vin-r8a7794" for the R8A7794 device
>     - "renesas,vin-r8a7793" for the R8A7793 device
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/=
platform/rcar-vin/rcar-core.c
> index c30040c42ce588a9..8930189638473f37 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1119,6 +1119,66 @@ static const struct rvin_info rcar_info_r8a7795 =
=3D {
>         },
>  };
>
> +static const struct rvin_info rcar_info_r8a7796 =3D {
> +       .chip =3D RCAR_GEN3,

[...]

The R-Car Gen3 entries are inserted in between Gen1 and Gen2?

> +};
> +
>  static const struct rvin_info rcar_info_gen2 =3D {
>         .chip =3D RCAR_GEN2,
>         .use_mc =3D false,
> @@ -1132,6 +1192,10 @@ static const struct of_device_id rvin_of_id_table[=
] =3D {
>                 .data =3D &rcar_info_r8a7795,
>         },
>         {
> +               .compatible =3D "renesas,vin-r8a7796",
> +               .data =3D &rcar_info_r8a7796,
> +       },
> +       {

Shouldn't this be inserted above the r8a7795 entry?
All other entries in this table are sorted in reverse alphabetical order.

>                 .compatible =3D "renesas,vin-r8a7794",
>                 .data =3D &rcar_info_gen2,
>         },

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
