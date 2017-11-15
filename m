Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44707 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754719AbdKONNp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 08:13:45 -0500
MIME-Version: 1.0
In-Reply-To: <1510743363-25798-7-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <1510743363-25798-7-git-send-email-jacopo+renesas@jmondi.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 15 Nov 2017 14:13:43 +0100
Message-ID: <CAMuHMdVTQpkXLEk9NvG6gEAfo5whiLBjUrRL0X0Y924tcy7OVw@mail.gmail.com>
Subject: Re: [PATCH v1 06/10] sh: sh7722: Rename CEU clock
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Nov 15, 2017 at 11:55 AM, Jacopo Mondi
<jacopo+renesas@jmondi.org> wrote:
> Rename CEU clock to match the new platform driver name used in Migo-R.
>
> There are no other sh7722 based devices Migo-R apart, so we can safely
> rename this.
>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  arch/sh/kernel/cpu/sh4a/clock-sh7722.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7722.c b/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
> index 8f07a1a..d85091e 100644
> --- a/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
> +++ b/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
> @@ -223,7 +223,7 @@ static struct clk_lookup lookups[] = {
>         CLKDEV_DEV_ID("sh-vou.0", &mstp_clks[HWBLK_VOU]),
>         CLKDEV_CON_ID("jpu0", &mstp_clks[HWBLK_JPU]),
>         CLKDEV_CON_ID("beu0", &mstp_clks[HWBLK_BEU]),
> -       CLKDEV_DEV_ID("sh_mobile_ceu.0", &mstp_clks[HWBLK_CEU]),
> +       CLKDEV_DEV_ID("renesas-ceu.0", &mstp_clks[HWBLK_CEU]),
>         CLKDEV_CON_ID("veu0", &mstp_clks[HWBLK_VEU]),
>         CLKDEV_CON_ID("vpu0", &mstp_clks[HWBLK_VPU]),
>         CLKDEV_DEV_ID("sh_mobile_lcdc_fb.0", &mstp_clks[HWBLK_LCDC]),

Shouldn't this be merged with "[PATCH v1 05/10] arch: sh: migor: Use new
renesas-ceu camera driver", to avoid breaking bisection?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
