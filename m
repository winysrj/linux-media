Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:45838 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934882AbdKPNTf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 08:19:35 -0500
MIME-Version: 1.0
In-Reply-To: <1510834290-25434-2-git-send-email-fabrizio.castro@bp.renesas.com>
References: <1510834290-25434-1-git-send-email-fabrizio.castro@bp.renesas.com> <1510834290-25434-2-git-send-email-fabrizio.castro@bp.renesas.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Nov 2017 14:19:33 +0100
Message-ID: <CAMuHMdXVb9xE5toLGHnaFX9y+-qVzz2_NzK6qEebaDiXxAec7w@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: media: rcar_vin: add device tree support
 for r8a774[35]
To: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 16, 2017 at 1:11 PM, Fabrizio Castro
<fabrizio.castro@bp.renesas.com> wrote:
> Add compatible strings for r8a7743 and r8a7745. No driver change
> change is needed as "renesas,rcar-gen2-vin" will activate the right

double "change"

> code. However, it is good practice to document compatible strings
> for the specific SoC as this allows SoC specific changes to the
> driver if needed, in addition to document SoC support and therefore
> allow checkpatch.pl to validate compatible string values.
>
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
