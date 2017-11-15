Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:48128 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932193AbdKONHd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 08:07:33 -0500
MIME-Version: 1.0
In-Reply-To: <1510743363-25798-2-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <1510743363-25798-2-git-send-email-jacopo+renesas@jmondi.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 15 Nov 2017 14:07:31 +0100
Message-ID: <CAMuHMdUG6gAEyyC0ANBzmj3KA-940+C7e9Nv_rLkBSjtfeKR1g@mail.gmail.com>
Subject: Re: [PATCH v1 01/10] dt-bindings: media: Add Renesas CEU bindings
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

CC devicetree folks

On Wed, Nov 15, 2017 at 11:55 AM, Jacopo Mondi
<jacopo+renesas@jmondi.org> wrote:
> Add bindings documentation for Renesas Capture Engine Unit (CEU).
>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  .../devicetree/bindings/media/renesas,ceu.txt      | 87 ++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
>
> diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> new file mode 100644
> index 0000000..a88e9cb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> @@ -0,0 +1,87 @@
> +Renesas Capture Engine Unit (CEU)
> +----------------------------------------------
> +
> +The Capture Engine Unit is the image capture interface found on Renesas
> +RZ chip series and on SH Mobile ones.
> +
> +The interface supports a single parallel input with up 8/16bits data bus width.

... with data bus widths up to 8/16 bits?

> +
> +Required properties:
> +- compatible
> +       Must be "renesas,renesas-ceu".

The double "renesas" part looks odd to me. What about "renesas,ceu"?
Shouldn't you add SoC-specific compatible values like "renesas,r7s72100-ceu",
too?

> +- reg
> +       Physical address base and size.
> +- interrupts
> +       The interrupt line number.

interrupt specifier

> +- pinctrl-names, pinctrl-0
> +       phandle of pin controller sub-node configuring pins for CEU operations.
> +
> +CEU supports a single parallel input and should contain a single 'port' subnode
> +with a single 'endpoint'. Optional endpoint properties applicable to parallel
> +input bus are described in "video-interfaces.txt".
> +
> +Example:
> +
> +The example describes the connection between the Capture Engine Unit and a

... an

> +OV7670 image sensor sitting on bus i2c1 with an on-board 24Mhz clock.
> +
> +ceu: ceu@e8210000 {
> +       reg = <0xe8210000 0x209c>;
> +       compatible = "renesas,renesas-ceu";
> +       interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&vio_pins>;
> +
> +       status = "okay";
> +
> +       port {
> +               ceu_in: endpoint {
> +                       remote-endpoint = <&ov7670_out>;
> +
> +                       bus-width = <8>;
> +                       hsync-active = <1>;
> +                       vsync-active = <1>;
> +                       pclk-sample = <1>;
> +                       data-active = <1>;
> +               };
> +       };
> +};
> +
> +i2c1: i2c@fcfee400 {
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&i2c1_pins>;
> +
> +       status = "okay";
> +       clock-frequency = <100000>;
> +
> +       ov7670: camera@21 {
> +               compatible = "ovti,ov7670";
> +               reg = <0x21>;
> +
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&vio_pins>;
> +
> +               reset-gpios = <&port3 11 GPIO_ACTIVE_LOW>;
> +               powerdown-gpios = <&port3 12 GPIO_ACTIVE_HIGH>;
> +
> +               clocks = <&xclk>;
> +               clock-names = "xclk";
> +
> +               xclk: fixed_clk {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <24000000>;
> +               };
> +
> +               port {
> +                       ov7670_out: endpoint {
> +                               remote-endpoint = <&ceu_in>;
> +
> +                               bus-width = <8>;
> +                               hsync-active = <1>;
> +                               vsync-active = <1>;
> +                               pclk-sample = <1>;
> +                               data-active = <1>;
> +                       };
> +               };
> +       };
> --
> 2.7.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
