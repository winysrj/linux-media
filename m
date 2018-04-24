Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:33183 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756905AbeDXJvJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 05:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <1524230914-10175-8-git-send-email-geert+renesas@glider.be>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be> <1524230914-10175-8-git-send-email-geert+renesas@glider.be>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 24 Apr 2018 11:51:07 +0200
Message-ID: <CAMuHMdXyEGY71v6EFDjBhFva_VRtO4p2BdG=HC5zfrwBXLXK0g@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/8] ARM: shmobile: Remove the ARCH_SHMOBILE Kconfig symbol
To: Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Reducing/enhancing CC list)

On Fri, Apr 20, 2018 at 3:28 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> All drivers for Renesas ARM SoCs have gained proper ARCH_RENESAS
> platform dependencies.  Hence finish the conversion from ARCH_SHMOBILE
> to ARCH_RENESAS for Renesas 32-bit ARM SoCs, as started by commit
> 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS").
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> This depends on the previous patches in this series, hence the RFC.
>
> JFTR, after this, the following symbols for drivers supporting only
> Renesas SuperH "SH-Mobile" SoCs can no longer be selected:
>   - CONFIG_KEYBOARD_SH_KEYSC,
>   - CONFIG_VIDEO_SH_VOU,
>   - CONFIG_VIDEO_SH_MOBILE_CEU,
>   - CONFIG_DRM_SHMOBILE[*],
>   - CONFIG_FB_SH_MOBILE_MERAM.
> (changes for a shmobile_defconfig .config)

Apparently CONFIG_VIDEO_SH_MOBILE_CEU was set in the old
armadillo800eva_defconfig, and used by the old board code.

While DT bindings do exist [1], some DT support has been added to the
driver [2], and this even ended up as the example in [3], this was never
enabled in the corresponding board DTS.

Nevertheless, I understand that soc_camera-based driver is obsolete, and
has been replaced by [4], but bindings for r8a7740 are lacking [5].

[1] Documentation/devicetree/bindings/media/sh_mobile_ceu.txt
[2] drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
[3] Documentation/devicetree/bindings/media/video-interfaces.txt
[4] drivers/media/platform/renesas-ceu.c
[5] Documentation/devicetree/bindings/media/renesas,ceu.txt

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
