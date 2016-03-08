Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35138 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbcCHIUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 03:20:23 -0500
MIME-Version: 1.0
In-Reply-To: <1457399038-14573-1-git-send-email-horms+renesas@verge.net.au>
References: <1457399038-14573-1-git-send-email-horms+renesas@verge.net.au>
Date: Tue, 8 Mar 2016 09:20:23 +0100
Message-ID: <CAMuHMdVY5uDkrV77D1H9QTGY_gwJsnA4MXy+HAmkW33qk-YkxQ@mail.gmail.com>
Subject: Re: [PATCH v2] media: sh_mobile_ceu_camera: Remove dependency on SUPERH
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 8, 2016 at 2:03 AM, Simon Horman <horms+renesas@verge.net.au> wrote:
> A dependency on ARCH_SHMOBILE seems to be the best option for
> sh_mobile_ceu_camera:
>
> * For Super H based SoCs: sh_mobile_ceu is used on SH_AP325RXA, SH_ECOVEC,
>   SH_KFR2R09, SH_MIGOR, and SH_7724_SOLUTION_ENGINE which depend on
>   CPU_SUBTYPE_SH7722, CPU_SUBTYPE_SH7723, or CPU_SUBTYPE_SH7724 which all
>   select ARCH_SHMOBILE.
>
> * For ARM Based SoCs: Since the removal of legacy (non-multiplatform)
>   support this driver has not been used by any Renesas ARM based SoCs.
>   The Renesas ARM based SoCs currently select ARCH_SHMOBILE, however,
>   it is planned that this will no longer be the case.
>
> This is part of an ongoing process to migrate from ARCH_SHMOBILE to
> ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
> appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.
>
> Thanks to Geert Uytterhoeven for analysis and portions of the
> change log text.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
