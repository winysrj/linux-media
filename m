Return-Path: <SRS0=PrKG=PU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF81C43387
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 01:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09D8320870
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 01:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfALB41 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 20:56:27 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37567 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfALB40 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 20:56:26 -0500
Received: by mail-ed1-f66.google.com with SMTP id h15so14534820edb.4;
        Fri, 11 Jan 2019 17:56:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9WCLRL4nc+FIeUAVSUDQFW8YoU/sIv0w+O0XhmejYKw=;
        b=j5bAGEDuUCaQKTWq8rqeK3bOXUGNbhnqDVu1mltA5xdGI+W1NqcN2M2Yuu3+Uzvxf4
         hNRlIFzX/95FLO7xiUQYdp//fiUL4tdKSjpMR6RVL6J1zoyjxC7wcmY5Ovl9W5ju71cC
         hI6vBF5LO+4TGpdPT92XL7iQN3ymVsMFoS21IZ9UphpFYhmtxnE9b5IiNb4Q0+dnhwz4
         dhaeVUI3BpfLQfgvrtbHXWvMsjtdRxyb3hWYpR2feATcbGz4bcO/3DICPEa7GfFI0TwM
         J9sLQSa3NHpNImfoB7p3hTbuQ+GbNXXq0NDCRw0JBTaWRc9JUJTj676oSK32cuwG402i
         CMHg==
X-Gm-Message-State: AJcUukcV9TPtWwnrOimbIgwRc4D9jtf20r/a8J1Gm97BvUiB6BnlFHbw
        RAqd3E75GakHij+LGryoVF5+g7Bt+hQ=
X-Google-Smtp-Source: ALg8bN4h/0AZS41Xlqx+Nt8TBishApFfCozT2Bv4mSzO36opItZ0nYBGi4VSnxrCP9kPZwEX0mnqXQ==
X-Received: by 2002:a17:906:33d9:: with SMTP id w25-v6mr13574877eja.190.1547258184384;
        Fri, 11 Jan 2019 17:56:24 -0800 (PST)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id g40sm2651327edg.39.2019.01.11.17.56.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Jan 2019 17:56:24 -0800 (PST)
Received: by mail-wr1-f54.google.com with SMTP id 96so17121802wrb.2;
        Fri, 11 Jan 2019 17:56:23 -0800 (PST)
X-Received: by 2002:adf:a1d2:: with SMTP id v18mr14898494wrv.87.1547258183588;
 Fri, 11 Jan 2019 17:56:23 -0800 (PST)
MIME-Version: 1.0
References: <20190111173015.12119-1-jernej.skrabec@siol.net> <20190111173015.12119-2-jernej.skrabec@siol.net>
In-Reply-To: <20190111173015.12119-2-jernej.skrabec@siol.net>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Sat, 12 Jan 2019 09:56:11 +0800
X-Gmail-Original-Message-ID: <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
Message-ID: <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: dt: bindings: sunxi-ir: Add A64 compatible
To:     Jernej Skrabec <jernej.skrabec@siol.net>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@siol.net> wrote:
>
> A64 IR is compatible with A13, so add A64 compatible with A13 as a
> fallback.

We ask people to add the SoC-specific compatible as a contigency,
in case things turn out to be not so "compatible".

To be consistent with all the other SoCs and other peripherals,
unless you already spotted a "compatible" difference in the
hardware, i.e. the hardware isn't completely the same, this
patch isn't needed. On the other hand, if you did, please mention
the differences in the commit log.

ChenYu

> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> ---
>  Documentation/devicetree/bindings/media/sunxi-ir.txt | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> index 278098987edb..ecac6964b69b 100644
> --- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
> +++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> @@ -1,7 +1,10 @@
>  Device-Tree bindings for SUNXI IR controller found in sunXi SoC family
>
>  Required properties:
> -- compatible       : "allwinner,sun4i-a10-ir" or "allwinner,sun5i-a13-ir"
> +- compatible       : value must be one of:
> +  * "allwinner,sun4i-a10-ir"
> +  * "allwinner,sun5i-a13-ir"
> +  * "allwinner,sun50i-a64-ir", "allwinner,sun5i-a13-ir"
>  - clocks           : list of clock specifiers, corresponding to
>                       entries in clock-names property;
>  - clock-names      : should contain "apb" and "ir" entries;
> --
> 2.20.1
>
