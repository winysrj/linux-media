Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:39284 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbeEPHkK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 03:40:10 -0400
MIME-Version: 1.0
In-Reply-To: <1524767083-19862-3-git-send-email-jacopo+renesas@jmondi.org>
References: <1524767083-19862-1-git-send-email-jacopo+renesas@jmondi.org> <1524767083-19862-3-git-send-email-jacopo+renesas@jmondi.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 16 May 2018 09:40:09 +0200
Message-ID: <CAMuHMdWSasm9PfurphB5wrgrhkO8v7YBpSZNnnC+mS_Vs4AJ5Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: dts: r8a7740: Add CEU0
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Simon Horman <horms@verge.net.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, Apr 26, 2018 at 8:24 PM, Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> Describe CEU0 peripheral for Renesas R-Mobile A1 R8A7740 Soc.
>
> Reported-by: Geert Uytterhoeven <geert@glider.be>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks for your patch!

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Minor question below.

> --- a/arch/arm/boot/dts/r8a7740.dtsi
> +++ b/arch/arm/boot/dts/r8a7740.dtsi
> @@ -67,6 +67,16 @@
>                 power-domains = <&pd_d4>;
>         };
>
> +       ceu0: ceu@fe910000 {
> +               reg = <0xfe910000 0x3000>;
> +               compatible = "renesas,r8a7740-ceu";
> +               interrupts = <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
> +               clocks = <&mstp1_clks R8A7740_CLK_CEU20>;
> +               clock-names = "ceu20";

Why the "clock-names" property? It's not mentioned in the DT bindings, and
may cause issues if the bindings are ever amended.

> +               power-domains = <&pd_a4r>;
> +               status = "disabled";
> +       };
> +

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
