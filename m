Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:39312 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752857AbeBVJSF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 04:18:05 -0500
MIME-Version: 1.0
In-Reply-To: <20180221232108.10139-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180221232108.10139-1-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 22 Feb 2018 10:18:03 +0100
Message-ID: <CAMuHMdUny0_mFgNOUd-Gw2G_UxUvpsjm0qOEc3gJ53s04LfuFA@mail.gmail.com>
Subject: Re: [PATCH] i2c: adv748x: afe: fix sparse warning
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Thu, Feb 22, 2018 at 12:21 AM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> This fixes the following sparse warning:
>
> drivers/media/i2c/adv748x/adv748x-afe.c:294:34:    expected unsigned int =
[usertype] *signal
> drivers/media/i2c/adv748x/adv748x-afe.c:294:34:    got int *<noident>
> drivers/media/i2c/adv748x/adv748x-afe.c:294:34: warning: incorrect type i=
n argument 2 (different signedness)
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/=
adv748x/adv748x-afe.c
> index 5188178588c9067d..39a9996d0db08c31 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -275,7 +275,8 @@ static int adv748x_afe_s_stream(struct v4l2_subdev *s=
d, int enable)
>  {
>         struct adv748x_afe *afe =3D adv748x_sd_to_afe(sd);
>         struct adv748x_state *state =3D adv748x_afe_to_state(afe);
> -       int ret, signal =3D V4L2_IN_ST_NO_SIGNAL;
> +       unsigned int signal =3D V4L2_IN_ST_NO_SIGNAL;

u32, as adv748x_afe_status() takes an u32 signal pointer?

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
