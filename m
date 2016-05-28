Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:36466 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbcE1TGM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2016 15:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <1464369565-12259-4-git-send-email-kieran@bingham.xyz>
References: <1464369565-12259-1-git-send-email-kieran@bingham.xyz>
	<1464369565-12259-4-git-send-email-kieran@bingham.xyz>
Date: Sat, 28 May 2016 21:06:10 +0200
Message-ID: <CAMuHMdUhv24QWE44k-nHTAkfy_EnDv76toUuOoD46pKNNR3r3w@mail.gmail.com>
Subject: Re: [PATCH 2/4] dt-bindings: Update Renesas R-Car FCP DT binding
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
> The FCP driver, can also support the FCPF variant for FDP1 compatible
> processing.
>
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>

Thanks for your patch!

> ---
>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Cc: devicetree@vger.kernel.org
>
> diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> index 6a12960609d8..1c0718b501ef 100644
> --- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> @@ -7,11 +7,12 @@ conversion of AXI transactions in order to reduce the memory bandwidth.
>
>  There are three types of FCP: FCP for Codec (FCPC), FCP for VSP (FCPV) and FCP
>  for FDP (FCPF). Their configuration and behaviour depend on the module they
> -are paired with. These DT bindings currently support the FCPV only.
> +are paired with. These DT bindings currently support the FCPV and FCPF.
>
>   - compatible: Must be one or more of the following
>
>     - "renesas,r8a7795-fcpv" for R8A7795 (R-Car H3) compatible 'FCP for VSP'
> +   - "renesas,r8a7795-fcpf" for R8A7795 (R-Car H3) compatible 'FCP for FDP'
>     - "renesas,fcpv" for generic compatible 'FCP for VSP'

I guess checkpatch complained about your dtsi additions because you forgot
to add  "renesas,fcpf" here?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
