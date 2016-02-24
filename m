Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33735 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730AbcBXHqc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 02:46:32 -0500
MIME-Version: 1.0
In-Reply-To: <1456280542-13113-1-git-send-email-horms+renesas@verge.net.au>
References: <1456280542-13113-1-git-send-email-horms+renesas@verge.net.au>
Date: Wed, 24 Feb 2016 08:46:31 +0100
Message-ID: <CAMuHMdUwvgaLtLLSk7jdg1N7mafpGz0VsikhbcFsuGQDHAunVw@mail.gmail.com>
Subject: Re: [PATCH] media: platform: rcar_jpu, sh_vou, vsp1: Use ARCH_RENESAS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On Wed, Feb 24, 2016 at 3:22 AM, Simon Horman
<horms+renesas@verge.net.au> wrote:
> Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.
>
> This is part of an ongoing process to migrate from ARCH_SHMOBILE to
> ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
> appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.
>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> ---
>  drivers/media/platform/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
>  Based on media_tree/master
>
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 201f5c296a95..662c029400de 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -37,7 +37,7 @@ config VIDEO_SH_VOU
>         tristate "SuperH VOU video output driver"
>         depends on MEDIA_CAMERA_SUPPORT
>         depends on VIDEO_DEV && I2C && HAS_DMA
> -       depends on ARCH_SHMOBILE || COMPILE_TEST
> +       depends on ARCH_RENESAS || COMPILE_TEST

This driver is used on sh7722/sh7723/sh7724 only.
While these are Renesas parts, ARCH_RENESAS isn't set for SuperH SoCs,
making this driver unavailable where needed.

>         select VIDEOBUF2_DMA_CONTIG
>         help
>           Support for the Video Output Unit (VOU) on SuperH SoCs.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
