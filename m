Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34109 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdCCLYM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 06:24:12 -0500
MIME-Version: 1.0
In-Reply-To: <20170302210104.646782352@cogentembedded.com>
References: <20170302210104.646782352@cogentembedded.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 3 Mar 2017 12:24:00 +0100
Message-ID: <CAMuHMdVg5N82bu8fxRS=3iqF2MQmqoR0idb_x0t2RNn8eoedQg@mail.gmail.com>
Subject: Re: [PATCH] media: platform: Renesas IMR driver
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
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

Hi Sergei,

On Thu, Mar 2, 2017 at 10:00 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> --- /dev/null
> +++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt

> +- compatible: "renesas,imr-lx4-<soctype>", "renesas,imr-lx4" as a fallback for

"renesas,<soctype>-imr-lx4"

> +  the image renderer light extended 4 (IMR-LX4) found in the R-Car gen3 SoCs,
> +  where the examples with <soctype> are:
> +  - "renesas,imr-lx4-h3" for R-Car H3,

"renesas,r8a7795-imr-lx4"

> +  - "renesas,imr-lx4-m3-w" for R-Car M3-W,

"renesas,r8a7796-imr-lx4"

> +  - "renesas,imr-lx4-v3m" for R-Car V3M.

"renesas,-EPROBE_DEFER-imr-lx4"

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
