Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:44260 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755203AbeDPN15 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 09:27:57 -0400
MIME-Version: 1.0
In-Reply-To: <20170804180402.795437602@cogentembedded.com>
References: <20170804180402.795437602@cogentembedded.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 16 Apr 2018 15:27:56 +0200
Message-ID: <CAMuHMdVu31PDTGXUxyWM_e1GAdT814ynTsiC_yCZiLYhg9aQjg@mail.gmail.com>
Subject: Re: [PATCH v7] media: platform: Renesas IMR driver
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Fri, Aug 4, 2017 at 8:03 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> The image renderer, or the distortion correction engine, is a drawing
> processor with a simple instruction system capable of referencing video
> capture data or data in an external memory as the 2D texture data and
> performing texture mapping and drawing with respect to any shape that is
> split into triangular objects.
>
> This V4L2 memory-to-memory device driver only supports image renderer light
> extended 4 (IMR-LX4) found in the R-Car gen3 SoCs; the R-Car gen2 support
> can be added later...
>
> Based on the original patch by Konstantin Kozhevnikov.
>
> Signed-off-by: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Acked-by: Rob Herring <robh@kernel.org>

>  Documentation/devicetree/bindings/media/rcar_imr.txt |   27
>  Documentation/media/v4l-drivers/index.rst            |    1
>  Documentation/media/v4l-drivers/rcar_imr.rst         |  372 +++
>  drivers/media/platform/Kconfig                       |   13
>  drivers/media/platform/Makefile                      |    1
>  drivers/media/platform/rcar_imr.c                    | 1832 +++++++++++++++++++
>  include/uapi/linux/rcar_imr.h                        |  182 +
>  7 files changed, 2428 insertions(+)

What's the status of this patch?
The compatible value "renesas,r8a7796-imr-lx4" has been in use since v4.14.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
