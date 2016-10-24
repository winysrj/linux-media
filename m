Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35943 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936395AbcJXJOX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 05:14:23 -0400
MIME-Version: 1.0
In-Reply-To: <1477299818-31935-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1477299818-31935-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1477299818-31935-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 24 Oct 2016 11:14:11 +0200
Message-ID: <CAMuHMdUGy0+bv-t=8HXeQf0BpoMJMNP85cd2tubQzD4Zj8X9Gw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] dt-bindings: Add Renesas R-Car FDP1 bindings
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Kieran Bingham <kieran@ksquared.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 24, 2016 at 11:03 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,fdp1.txt
> @@ -0,0 +1,33 @@
> +Renesas R-Car Fine Display Processor (FDP1)
> +-------------------------------------------
> +
> +The FDP1 is a de-interlacing module which converts interlaced video to
> +progressive video. It is capable of performing pixel format conversion between
> +YCbCr/YUV formats and RGB formats. Only YCbCr/YUV formats are supported as
> +an input to the module.
> +
> + - compatible: Must be the following
> +
> +   - "renesas,fdp1" for generic compatible
> +
> + - reg: the register base and size for the device registers
> + - interrupts : interrupt specifier for the FDP1 instance
> + - clocks: reference to the functional clock
> + - renesas,fcp: reference to the FCPF connected to the FDP1
> +
> +Optional properties:
> + - power-domains : power-domain property defined with a power domain specifier

                      "power domain"?

> +                            to respective power domain.

Still, too many power domains in one sentence?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
