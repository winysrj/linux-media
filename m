Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35218 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752049AbdAZNbI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jan 2017 08:31:08 -0500
MIME-Version: 1.0
In-Reply-To: <20170126131259.5621-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170126131259.5621-1-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 26 Jan 2017 14:31:06 +0100
Message-ID: <CAMuHMdVQQaWd3QWccrun=MpG671FviiOEjxqnrgmyhsHa0PNFQ@mail.gmail.com>
Subject: Re: [PATCH] v4l: of: check for unique lanes in data-lanes and clock-lanes
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Thu, Jan 26, 2017 at 2:12 PM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/=
v4l2-of.c
> index 93b33681776c..1042db6bb996 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -32,12 +32,19 @@ static int v4l2_of_parse_csi_bus(const struct device_=
node *node,
>         prop =3D of_find_property(node, "data-lanes", NULL);
>         if (prop) {
>                 const __be32 *lane =3D NULL;
> -               unsigned int i;
> +               unsigned int i, n;

Not "j"?

>                 for (i =3D 0; i < ARRAY_SIZE(bus->data_lanes); i++) {
>                         lane =3D of_prop_next_u32(prop, lane, &v);
>                         if (!lane)
>                                 break;
> +                       for (n =3D 0; n < i; n++) {

I'm not used seeing for loops with an index named "n", and limit named "i" =
;-)

> +                               if (bus->data_lanes[n] =3D=3D v) {
> +                                       pr_warn("%s: duplicated lane %u i=
n data-lanes\n",
> +                                               node->full_name, v);
> +                                       return -EINVAL;
> +                               }
> +                       }
>                         bus->data_lanes[i] =3D v;
>                 }
>                 bus->num_data_lanes =3D i;
> @@ -63,6 +70,15 @@ static int v4l2_of_parse_csi_bus(const struct device_n=
ode *node,
>         }
>
>         if (!of_property_read_u32(node, "clock-lanes", &v)) {
> +               unsigned int n;

Likewise.

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
