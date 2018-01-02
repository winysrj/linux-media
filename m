Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35625 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbeABJex (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 04:34:53 -0500
MIME-Version: 1.0
In-Reply-To: <1514469681-15602-2-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1514469681-15602-2-git-send-email-jacopo+renesas@jmondi.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 2 Jan 2018 10:34:51 +0100
Message-ID: <CAMuHMdXCLtx218EJ=ZPPkb0PcG26=r6QiJA9V+T3=LT=E+UQ5g@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] dt-bindings: media: Add Renesas CEU bindings
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
> Add bindings documentation for Renesas Capture Engine Unit (CEU).

Thanks for your patch!

> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> @@ -0,0 +1,85 @@
> +Renesas Capture Engine Unit (CEU)
> +----------------------------------------------
> +
> +The Capture Engine Unit is the image capture interface found on Renesas
> +RZ chip series and on SH Mobile ones.
> +
> +The interface supports a single parallel input with data bus width up to
> +8/16 bits.
> +
> +Required properties:
> +- compatible
> +       Must be one of:
> +       - "renesas,ceu"

Isn't "renesas,ceu" the generic fallback?

> +       - "renesas,r7s72100-ceu"

> +- reg
> +       Physical address base and size.
> +- interrupts
> +       The interrupt specifier.
> +- pinctrl-names, pinctrl-0
> +       phandle of pin controller sub-node configuring pins for CEU operations.
> +- remote-endpoint
> +       phandle to an 'endpoint' subnode of a remote device node.

"remote-endpoint" is not a direct property, but must be part of nested "ports"
and "endpoint" subnodes, like in the example?

> +Example:
> +
> +The example describes the connection between the Capture Engine Unit and an
> +OV7670 image sensor sitting on bus i2c1.
> +
> +ceu: ceu@e8210000 {
> +       reg = <0xe8210000 0x209c>;
> +       compatible = "renesas,ceu";
> +       interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
> +
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&vio_pins>;
> +
> +       status = "okay";
> +
> +       port {
> +               ceu_in: endpoint {
> +                       remote-endpoint = <&ov7670_out>;
> +
> +                       hsync-active = <1>;
> +                       vsync-active = <0>;
> +               };
> +       };
> +};

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
