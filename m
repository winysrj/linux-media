Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35524 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754512AbcKRRIC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 12:08:02 -0500
MIME-Version: 1.0
In-Reply-To: <20161118161621.798004-2-arnd@arndb.de>
References: <20161118161621.798004-1-arnd@arndb.de> <20161118161621.798004-2-arnd@arndb.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 18 Nov 2016 18:08:01 +0100
Message-ID: <CAMuHMdWj9_X-kgbJ4FHXMR2hnUzwKCkjXbOfu0kY6bk5rcVzfQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] v4l: rcar_fdp1: add FCP dependency
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Fri, Nov 18, 2016 at 5:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> drivers/media/platform/rcar_fdp1.o: In function `fdp1_pm_runtime_resume':
> rcar_fdp1.c:(.text.fdp1_pm_runtime_resume+0x78): undefined reference to `rcar_fcp_enable'
> drivers/media/platform/rcar_fdp1.o: In function `fdp1_pm_runtime_suspend':
> rcar_fdp1.c:(.text.fdp1_pm_runtime_suspend+0x14): undefined reference to `rcar_fcp_disable'
> drivers/media/platform/rcar_fdp1.o: In function `fdp1_probe':
> rcar_fdp1.c:(.text.fdp1_probe+0x15c): undefined reference to `rcar_fcp_get'
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 3c5a0b6b23a9..cd0cab6e0e31 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -311,6 +311,7 @@ config VIDEO_RENESAS_FDP1
>         tristate "Renesas Fine Display Processor"
>         depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
>         depends on ARCH_SHMOBILE || COMPILE_TEST
> +       depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP

Which tree and config is this? I don't have fdp1_pm_runtime_resume in my
renesas-drivers tree.

Why are the dummies for !CONFIG_VIDEO_RENESAS_FCP in include/media/rcar-fcp.h
not working?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
