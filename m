Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:35952 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbcE1TD4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2016 15:03:56 -0400
MIME-Version: 1.0
In-Reply-To: <1464369565-12259-5-git-send-email-kieran@bingham.xyz>
References: <1464369565-12259-1-git-send-email-kieran@bingham.xyz>
	<1464369565-12259-5-git-send-email-kieran@bingham.xyz>
Date: Sat, 28 May 2016 21:03:55 +0200
Message-ID: <CAMuHMdUvRN2ysYJ9g0daOD8sD7O5XcrZkKbWr0X_L7mG25Ocww@mail.gmail.com>
Subject: Re: [PATCH 3/4] dt-bindings: Document Renesas R-Car FCP power-domains usage
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-renesas-soc@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Fri, May 27, 2016 at 7:19 PM, Kieran Bingham <kieran@ksquared.org.uk> wrote:
> The example misses the power-domains usage, and documentation that the
> property is used by the node.
>
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>

Thanks for your patch!

> ---
>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> index 1c0718b501ef..464bb7ae4b92 100644
> --- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> @@ -21,6 +21,8 @@ are paired with. These DT bindings currently support the FCPV and FCPF.
>
>   - reg: the register base and size for the device registers
>   - clocks: Reference to the functional clock
> + - power-domains : power-domain property defined with a phandle
> +                           to respective power domain.

I'd write "power domain specifier" instead of "phandle". While SYSC on R-Car
Gen3 uses #power-domain-cells = 0, the FCP module may show up on another
SoC that uses a different value, needing more than just a phandle.

In fact I'm inclined to leave out the power-domains property completely:
it's not a feature of the FCP, but of the SoC the FCP is part of.
power-domains properties may appear in any device node where needed.

>  Device node example
> @@ -30,4 +32,5 @@ Device node example
>                 compatible = "renesas,r8a7795-fcpv", "renesas,fcpv";
>                 reg = <0 0xfea2f000 0 0x200>;
>                 clocks = <&cpg CPG_MOD 602>;
> +               power-domains = <&sysc R8A7795_PD_A3VP>;

Adding it to the example doesn't hurt, though.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
