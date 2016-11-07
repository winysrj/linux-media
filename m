Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35417 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752280AbcKGMkm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 07:40:42 -0500
MIME-Version: 1.0
In-Reply-To: <20161102132329.436-15-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se> <20161102132329.436-15-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 7 Nov 2016 13:40:39 +0100
Message-ID: <CAMuHMdUkLsewwpujNR9d8wahRZibrK+b5Zme2RoyVBZ2wMFi5A@mail.gmail.com>
Subject: Re: [PATCH 14/32] media: rcar-vin: move chip information to own struct
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
> When Gen3 support is added to the driver more then chip id will be
> different for the different Soc. To avoid a lot of if statements in the
> code create a struct chip_info to contain this information.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 49 +++++++++++++++++++++++=
+-----
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  3 +-
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 12 +++++--
>  3 files changed, 53 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/=
platform/rcar-vin/rcar-core.c
> index 5807d8d..372443e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -253,14 +253,47 @@ static int rvin_digital_graph_init(struct rvin_dev =
*vin)
>   * Platform Device Driver
>   */
>
> +static const struct rvin_info rcar_info_h1 =3D {
> +       .chip =3D RCAR_H1,
> +};
> +
> +static const struct rvin_info rcar_info_m1 =3D {
> +       .chip =3D RCAR_M1,
> +};
> +
> +static const struct rvin_info rcar_info_gen2 =3D {
> +       .chip =3D RCAR_GEN2,
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] =3D {
> -       { .compatible =3D "renesas,vin-r8a7794", .data =3D (void *)RCAR_G=
EN2 },
> -       { .compatible =3D "renesas,vin-r8a7793", .data =3D (void *)RCAR_G=
EN2 },
> -       { .compatible =3D "renesas,vin-r8a7791", .data =3D (void *)RCAR_G=
EN2 },
> -       { .compatible =3D "renesas,vin-r8a7790", .data =3D (void *)RCAR_G=
EN2 },
> -       { .compatible =3D "renesas,vin-r8a7779", .data =3D (void *)RCAR_H=
1 },
> -       { .compatible =3D "renesas,vin-r8a7778", .data =3D (void *)RCAR_M=
1 },
> -       { .compatible =3D "renesas,rcar-gen2-vin", .data =3D (void *)RCAR=
_GEN2 },
> +       {
> +               .compatible =3D "renesas,vin-r8a7794",
> +               .data =3D (void *)&rcar_info_gen2,

These casts are not needed.

> +       },
> +       {
> +               .compatible =3D "renesas,vin-r8a7793",
> +               .data =3D (void *)&rcar_info_gen2,
> +       },
> +       {
> +               .compatible =3D "renesas,vin-r8a7791",
> +               .data =3D (void *)&rcar_info_gen2,
> +       },
> +       {
> +               .compatible =3D "renesas,vin-r8a7790",
> +               .data =3D (void *)&rcar_info_gen2,
> +       },
> +       {
> +               .compatible =3D "renesas,vin-r8a7779",
> +               .data =3D (void *)&rcar_info_h1,
> +       },
> +       {
> +               .compatible =3D "renesas,vin-r8a7778",
> +               .data =3D (void *)&rcar_info_m1,
> +       },
> +       {
> +               .compatible =3D "renesas,rcar-gen2-vin",
> +               .data =3D (void *)&rcar_info_gen2,
> +       },
>         { },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> @@ -281,7 +314,7 @@ static int rcar_vin_probe(struct platform_device *pde=
v)
>                 return -ENODEV;
>
>         vin->dev =3D &pdev->dev;
> -       vin->chip =3D (enum chip_id)match->data;
> +       vin->info =3D (const struct rvin_info *)match->data;

This cast is not needed.

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
