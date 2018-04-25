Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:40855 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbeDYHZ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 03:25:57 -0400
MIME-Version: 1.0
In-Reply-To: <20180424234506.22630-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180424234506.22630-1-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 25 Apr 2018 09:25:56 +0200
Message-ID: <CAMuHMdWqW7FGxA8akfS6X2C-3Hm7126+9E7xCpezXfUEwwFWUQ@mail.gmail.com>
Subject: Re: [PATCH] rcar-vin: fix null pointer dereference in rvin_group_get()
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 1:45 AM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Store the group pointer before disassociating the VIN from the group.

s/get/put/ in one-line summary?

> Fixes: 3bb4c3bc85bf77a7 ("media: rcar-vin: add group allocator functions"=
)
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/=
platform/rcar-vin/rcar-core.c
> index 7bc2774a11232362..d3072e166a1ca24f 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -338,19 +338,21 @@ static int rvin_group_get(struct rvin_dev *vin)
>
>  static void rvin_group_put(struct rvin_dev *vin)
>  {
> -       mutex_lock(&vin->group->lock);
> +       struct rvin_group *group =3D vin->group;

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
