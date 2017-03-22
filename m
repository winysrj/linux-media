Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33697 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758912AbdCVJeT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 05:34:19 -0400
MIME-Version: 1.0
In-Reply-To: <20170309200818.786255823@cogentembedded.com>
References: <20170309200818.786255823@cogentembedded.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 22 Mar 2017 10:34:16 +0100
Message-ID: <CAMuHMdV5-aMx4KuqShm47XtORJK8rMKzw6FUs2Hjsxia+jPfxg@mail.gmail.com>
Subject: Re: [PATCH v5] media: platform: Renesas IMR driver
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 9, 2017 at 9:08 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> --- /dev/null
> +++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
> @@ -0,0 +1,27 @@
> +Renesas R-Car Image Renderer (Distortion Correction Engine)
> +-----------------------------------------------------------
> +
> +The image renderer, or the distortion correction engine, is a drawing processor
> +with a simple instruction system capable of referencing video capture data or
> +data in an external memory as 2D texture data and performing texture mapping
> +and drawing with respect to any shape that is split into triangular objects.
> +
> +Required properties:
> +
> +- compatible: "renesas,<soctype>-imr-lx4", "renesas,imr-lx4" as a fallback for
> +  the image renderer light extended 4 (IMR-LX4) found in the R-Car gen3 SoCs,
> +  where the examples with <soctype> are:
> +  - "renesas,r8a7795-imr-lx4" for R-Car H3,
> +  - "renesas,r8a7796-imr-lx4" for R-Car M3-W.

Laurent: what do you think about the need for SoC-specific compatible
values for the various IM* blocks?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
