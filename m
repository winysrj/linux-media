Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34170 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932199AbcKGPtf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 10:49:35 -0500
MIME-Version: 1.0
In-Reply-To: <20161102132329.436-32-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se> <20161102132329.436-32-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 7 Nov 2016 13:42:40 +0100
Message-ID: <CAMuHMdXKcX8XWncbPeb6yKOWZBZMM6m0V3TceczPTk_OEf647Q@mail.gmail.com>
Subject: Re: [PATCH 31/32] media: rcar-vin: enable support for r8a7795
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
> Add the SoC specific information for Renesas Salvator-X H3 (r8a7795)
> board.

Salvator-X is the board, while the support you add is purely SoC-specific.

> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/media/platform/rcar-vin/Kconfig     |  2 +-
>  drivers/media/platform/rcar-vin/rcar-core.c | 71 +++++++++++++++++++++++=
++++++
>  2 files changed, 72 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/plat=
form/rcar-vin/Kconfig
> index 111d2a1..e0e981c 100644
> --- a/drivers/media/platform/rcar-vin/Kconfig
> +++ b/drivers/media/platform/rcar-vin/Kconfig

> @@ -1138,6 +1205,10 @@ static const struct rvin_info rcar_info_gen2 =3D {
>
>  static const struct of_device_id rvin_of_id_table[] =3D {
>         {
> +               .compatible =3D "renesas,vin-r8a7795",
> +               .data =3D (void *)&rcar_info_r8a7795,

Cast not needed

> +       },

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
