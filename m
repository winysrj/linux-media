Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34011 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbcBOJ6h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 04:58:37 -0500
MIME-Version: 1.0
In-Reply-To: <1455242450-24493-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1455242450-24493-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Mon, 15 Feb 2016 10:58:36 +0100
Message-ID: <CAMuHMdXj9nLnqGCsSZb3c5X8KjU1ZZgoTBmHm0fTdps5=Jn4SQ@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/9] ARM64: renesas: r8a7795: Add VSP instances
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Feb 12, 2016 at 3:00 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> The r8a7795 has 9 VSP instances with various capabilities.
>
> Only the VSPD instances are currently enabled as the other 5 instances
> cause the following crash when reading the version register.
>
> [    5.284206] Bad mode in Error handler detected, code 0xbf000002 -- SError

Power Area A3VP seems to be powered down when Linux is started?

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  arch/arm64/boot/dts/renesas/r8a7795.dtsi | 128 +++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/renesas/r8a7795.dtsi b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> index f62d6fa28acc..3c49ba5ecfbb 100644
> --- a/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> +++ b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> @@ -961,6 +961,21 @@
>                         dma-channels = <2>;
>                 };
>
> +               vspbc: vsp@fe920000 {
> +                       compatible = "renesas,vsp2";
> +                       reg = <0 0xfe920000 0 0x8000>;
> +                       interrupts = <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>;

465, according to the Dec errata?

> +                       clocks = <&cpg CPG_MOD 624>;

The VSP2 modules are located in the A3VP Power Area. But adding this
information to DT depends on the SYSC PM Domain driver.

I'll try to post my WIP PM Domain patchset for R-Car ASAP...

> +
> +                       renesas,fcp = <&fcpvb1>;
> +
> +                       renesas,has-lut;
> +                       renesas,has-sru;
> +                       renesas,#rpf = <5>;
> +                       renesas,#wpf = <1>;
> +                       status = "disabled";
> +               };
> +
>                 fcpvb1: fcp@fe92f000 {
>                         compatible = "renesas,fcpv";
>                         reg = <0 0xfe92f000 0 0x200>;
> @@ -968,6 +983,19 @@
>                         power-domains = <&cpg>;
>                 };
>
> +               vspbd: vsp@fe960000 {
> +                       compatible = "renesas,vsp2";
> +                       reg = <0 0xfe960000 0 0x8000>;
> +                       interrupts = <GIC_SPI 465 IRQ_TYPE_LEVEL_HIGH>;

266, according to the Dec errata?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
