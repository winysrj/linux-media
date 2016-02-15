Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38495 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbcBOJpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 04:45:40 -0500
MIME-Version: 1.0
In-Reply-To: <1455242450-24493-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1455242450-24493-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Mon, 15 Feb 2016 10:45:39 +0100
Message-ID: <CAMuHMdWXdY0DS--sfOy83jixKyBzu5gFPAY2BQs5PBCDh0Fxdw@mail.gmail.com>
Subject: Re: [PATCH/RFC 6/9] ARM64: renesas: r8a7795: Add FCPV nodes
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
> The FCPs handle the interface between various IP cores and memory. Add
> the instances related to the VSP2s.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  arch/arm64/boot/dts/renesas/r8a7795.dtsi | 63 ++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/renesas/r8a7795.dtsi b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> index b5e46e4ff72a..f62d6fa28acc 100644
> --- a/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> +++ b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> @@ -960,5 +960,68 @@
>                         #dma-cells = <1>;
>                         dma-channels = <2>;
>                 };
> +
> +               fcpvb1: fcp@fe92f000 {
> +                       compatible = "renesas,fcpv";
> +                       reg = <0 0xfe92f000 0 0x200>;
> +                       clocks = <&cpg CPG_MOD 606>;
> +                       power-domains = <&cpg>;
> +               };

The FCP_V modules are located in the A3VP Power Area. But adding this
information to DT depends on the SYSC PM Domain driver.

I'll try to post my WIP PM Domain patchset for R-Car ASAP...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
