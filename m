Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:37986 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754016AbeDWH6O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 03:58:14 -0400
MIME-Version: 1.0
In-Reply-To: <20180422102849.2481-3-laurent.pinchart+renesas@ideasonboard.com>
References: <20180422102849.2481-1-laurent.pinchart+renesas@ideasonboard.com> <20180422102849.2481-3-laurent.pinchart+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 23 Apr 2018 09:58:13 +0200
Message-ID: <CAMuHMdWiFa4_wyQpOHbb9r-55o_gjvQUKOVVbkuYGEbHRsrEuQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] v4l: rcar_fdp1: Enable compilation on Gen2 platforms
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Apr 22, 2018 at 12:28 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> Commit 1d3897143815 ("[media] v4l: rcar_fdp1: add FCP dependency") fixed
> a compilation breakage when the optional VIDEO_RENESAS_FCP dependency is
> compiled as a module while the rcar_fdp1 driver is built in. As a side
> effect it disabled compilation on Gen2 by disallowing the valid
> combination ARCH_RENESAS && !VIDEO_RENESAS_FCP. Fix it by handling the
> dependency the same way the vsp1 driver did in commit 199946731fa4
> ("[media] vsp1: clarify FCP dependency").
>
> Fixes: 1d3897143815 ("[media] v4l: rcar_fdp1: add FCP dependency")
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 621d63b2001d..81c3ab95c050 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -397,7 +397,7 @@ config VIDEO_RENESAS_FDP1
>         tristate "Renesas Fine Display Processor"
>         depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
>         depends on ARCH_RENESAS || COMPILE_TEST
> -       depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
> +       depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP

s/!ARM64/ARCH_RCAR_GEN2/?

>         select VIDEOBUF2_DMA_CONTIG
>         select V4L2_MEM2MEM_DEV

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
