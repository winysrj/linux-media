Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38378 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdJCIaK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 04:30:10 -0400
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-25-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se> <20170822232640.26147-25-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 3 Oct 2017 10:30:08 +0200
Message-ID: <CAMuHMdUih6ymX+Hv0C0AH3o5pTGWaEQq4kXXxoKYv-grNkcsgw@mail.gmail.com>
Subject: Re: [PATCH v6 24/25] rcar-vin: enable support for r8a7795
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 23, 2017 at 1:26 AM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Add the SoC specific information for Renesas r8a7795.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>

> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c

> @@ -1038,6 +1176,13 @@ static int rcar_vin_probe(struct platform_device *=
pdev)
>         vin->dev =3D &pdev->dev;
>         vin->info =3D match->data;
>
> +       /*
> +        * Special care is needed on r8a7795 ES1.x since it
> +        * uses different routing then r8a7795 ES2.0.

than

> +        */
> +       if (vin->info =3D=3D &rcar_info_r8a7795 && soc_device_match(r8a77=
95es1))
> +               vin->info =3D &rcar_info_r8a7795es1;
> +
>         mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (mem =3D=3D NULL)
>                 return -EINVAL;

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
