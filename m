Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:34400 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751967AbdKWJlX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 04:41:23 -0500
MIME-Version: 1.0
In-Reply-To: <1510743363-25798-5-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <1510743363-25798-5-git-send-email-jacopo+renesas@jmondi.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 23 Nov 2017 10:41:22 +0100
Message-ID: <CAMuHMdVvMvM8+yFwQVPvR+Sfei7OAEDCLfxX=V0qfdozmdQB6A@mail.gmail.com>
Subject: Re: [PATCH v1 04/10] ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
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
> Add Capture Engine Unit (CEU) node to device tree.
>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks for your patch!

> --- a/arch/arm/boot/dts/r7s72100.dtsi
> +++ b/arch/arm/boot/dts/r7s72100.dtsi
> @@ -136,8 +136,8 @@
>                         compatible = "renesas,r7s72100-mstp-clocks", "renesas,cpg-mstp-clocks";
>                         reg = <0xfcfe042c 4>;
>                         clocks = <&p0_clk>;

You forgot to add an entry to clocks.
The parent clock of the CEU module clock is b_clk.

> -                       clock-indices = <R7S72100_CLK_RTC>;
> -                       clock-output-names = "rtc";
> +                       clock-indices = <R7S72100_CLK_RTC R7S72100_CLK_CEU>;
> +                       clock-output-names = "rtc", "ceu";

Usually we follow the order from <dt-bindings/clock/r7s72100-clock.h>,
so CEU should come before RTC.

> @@ -666,4 +666,12 @@
>                 power-domains = <&cpg_clocks>;
>                 status = "disabled";
>         };
> +
> +       ceu: ceu@e8210000 {
> +               reg = <0xe8210000 0x209c>;
> +               compatible = "renesas,renesas-ceu";
> +               interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
> +               power-domains = <&cpg_clocks>;

if you describe the device to be part of the CPG clock domain, you should
provide a clocks property:

        clocks = <&mstp6_clks R7S72100_CLK_CEU>;

> +               status = "disabled";
> +       };
>  };

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
