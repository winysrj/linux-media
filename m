Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:45720 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbeABJgB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 04:36:01 -0500
MIME-Version: 1.0
In-Reply-To: <1514469681-15602-5-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1514469681-15602-5-git-send-email-jacopo+renesas@jmondi.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 2 Jan 2018 10:35:59 +0100
Message-ID: <CAMuHMdXuApVjg4Sq3tY+p6SAfCqRaJ_GmaC2koiX1ZzDPiXXcQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, Dec 28, 2017 at 3:01 PM, Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> Add Capture Engine Unit (CEU) node to device tree.

Thanks for your patch!

> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

With the issue below fixed:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/arch/arm/boot/dts/r7s72100.dtsi
> +++ b/arch/arm/boot/dts/r7s72100.dtsi

> @@ -667,4 +667,13 @@
>                 power-domains = <&cpg_clocks>;
>                 status = "disabled";
>         };
> +
> +       ceu: ceu@e8210000 {
> +               reg = <0xe8210000 0x209c>;

Given the last documented register is at offset 0x209C, the region above is too
small (also in the example in the DT bindings).
But due to MMU granularity, it will be accessible anyway.

reg = <0xe8210000 0x3000>;

I assume the mandatory "remote-endpoint" property will come with the board
(GR-Peach) DTS patch?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
