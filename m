Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D6FC10F03
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 18:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35D502087C
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 18:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbfCYSfC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:35:02 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:43931 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbfCYSfC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 14:35:02 -0400
Received: by mail-ua1-f66.google.com with SMTP id g1so3341893uae.10;
        Mon, 25 Mar 2019 11:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qoedbogiIzRAT9qJqPDHpzgekqVxVg+VJy/0Qt37Bks=;
        b=Gmv43iMVEq2D+/2lyFvvtpw+NI0Rdt0T8SlhVkHhZAmJOG32r4g5E/CsdqC/kUSah6
         pfLywPxUvr+7laocLHXF38RzjllDPidkDw0BKJNPR+ZCJjfkly7j8EUz9Dp/nWqfTnNi
         5WtO9ducv4I3Qw9kVWbrs2xAd7QA0jB1cWmoZtvOhHG6kEuhGDXEO2k07KxCjoS4Nr+x
         +kMHrO8T1kTEL+IgffHRH4ne7UAuvIIEgeh59agMfR0FJtjeHzm5l5Q88SHuFzo9kTkd
         FVSGmmY/KOv2r/KQSwPmQTUJj0XwZdhAN44uRH3t9gCdlWhIHdz1CJIpfksDfzWtoOnC
         tsDg==
X-Gm-Message-State: APjAAAVwMdaNJSiCjDFZe8Pm7rkbQPCEeTBVRdyoOhezhtJ9aAexMn/N
        los75Iisq+jyxxzkv90hNKxqeyyGqTrspjsYPUZ7+Q==
X-Google-Smtp-Source: APXvYqyM88OeB5zGrVKSuAgyMXGaWbdTKRH9/iefCVaBoqME4SLeaRjEGoQJtZTFKaFPc6UJYjUbQGEeWWjda52nusc=
X-Received: by 2002:ab0:7797:: with SMTP id x23mr3882993uar.28.1553538901114;
 Mon, 25 Mar 2019 11:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <b2964da9-4389-b277-0e6f-df41f39326b7@cogentembedded.com>
In-Reply-To: <b2964da9-4389-b277-0e6f-df41f39326b7@cogentembedded.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 25 Mar 2019 19:34:49 +0100
Message-ID: <CAMuHMdVr4EcgNdBSnAb2zPCopVCyCWNF8ebcWJzzx=FvrVc0QQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: media: Renesas R-Car IMR bindings
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kbingham@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

CC Laurent, Kieran

On Mon, Mar 25, 2019 at 7:14 PM Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> The image renderer (IMR), or the distortion correction engine, is a
> drawing processor with a simple instruction system capable of referencing
> video capture data or data in an external memory as the 2D texture data
> and performing texture mapping and drawing with respect to any shape that
> is split into triangular objects.
>
> Document  the device tree bindings for the image renderer light extended 4
> (IMR-LX4) found in the R-Car gen3 SoCs...
>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Acked-by: Rob Herring <robh@kernel.org>
>
> ---
> This patch is against the 'master' branch of the 'media_tree.git' repo.
>
> This patch has been split from the large IMR driver patch (which would need
> much more work), it fixes checkpatch.pl's warnings on the SoC .dtsi files
> which have been already merged (the bindings didn't change since v1 of the
> driver patch).
>
> Documentation/devicetree/bindings/media/rcar_imr.txt |   27 +++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> Index: media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
> ===================================================================
> --- /dev/null
> +++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
> @@ -0,0 +1,27 @@
> +Renesas R-Car Image Renderer (Distortion Correction Engine)
> +-----------------------------------------------------------
> +
> +The image renderer, or the distortion correction engine, is a drawing processor
> +with a simple instruction system capable of referencing video capture data or
> +data in an external memory as 2D texture data and performing texture mapping
> +and drawing with respect to any shape that is split into triangular objects.
> +
> +Required properties:
> +
> +- compatible: "renesas,<soctype>-imr-lx4", "renesas,imr-lx4" as a fallback for
> +  the image renderer light extended 4 (IMR-LX4) found in the R-Car gen3 SoCs,
> +  where the examples with <soctype> are:
> +  - "renesas,r8a7795-imr-lx4" for R-Car H3,
> +  - "renesas,r8a7796-imr-lx4" for R-Car M3-W.
> +- reg: offset and length of the register block;
> +- interrupts: single interrupt specifier;
> +- clocks: single clock phandle/specifier pair.

power-domains? (they're usually not in the always-on area on R-Car Gen3)
resets?

> +
> +Example:
> +
> +       imr-lx4@fe860000 {
> +               compatible = "renesas,r8a7795-imr-lx4", "renesas,imr-lx4";
> +               reg = <0 0xfe860000 0 0x2000>;
> +               interrupts = <GIC_SPI 192 IRQ_TYPE_LEVEL_HIGH>;
> +               clocks = <&cpg CPG_MOD 823>;
> +       };

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
