Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E52C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 14:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A9F8218AC
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552661200;
	bh=CQQ1zyvRtxQefHP7cpK0C7nBWNKKQWbaMPqPaMCJ2n8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=REZobhSIiyElUFFb/ZPTRyBKFe9TitIT2iOp+bdcvVxucO7F3WR52bZkdvpaz0EdH
	 N1CFp+fSdenjV2wYIlb/ihFGBUHXoxhDTdPtTIyVDEJ5igmwTxm4d5oBuqeZmN0ZMr
	 UCKyJCTDEeBzV/kIf2ApDBUH8K5ryvOCOrZim9T0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfCOOqf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 10:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727518AbfCOOqe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 10:46:34 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A245218D3;
        Fri, 15 Mar 2019 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552661193;
        bh=CQQ1zyvRtxQefHP7cpK0C7nBWNKKQWbaMPqPaMCJ2n8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=p7a6s2/8Q9IlFyABaOhAF7CUIG6a2HOtVy0XqbTIRzCPdfjz4Dgs44wAJqrUEaAvd
         RjRd3/GjrMsBXLlSNT6BkY0ULslWPSjFzlvYULfB9SXXCe6VqhDqZ9BX/xZ0PpWLlG
         AxuowyGFkuuEk058savfcAM5u2f1ioJHEN3KJszY=
Received: by mail-qt1-f182.google.com with SMTP id f11so10319195qti.7;
        Fri, 15 Mar 2019 07:46:32 -0700 (PDT)
X-Gm-Message-State: APjAAAUEt8m4+rVzPPZfPz4qvOdfzW+DxStNEzVQYq6yP9HrcsPD/jx/
        hzwW38uIiYRBnbmiGa8ZkaoxpXrtVmcYDFjFOg==
X-Google-Smtp-Source: APXvYqwmfaPaWDnYZM5ZlafszvIWz9WqS5oNWEqNYNPxyNj6l44DhJGJCK8kD90YTZ3c7QcEI+YZaZsyjNtgQbpZknA=
X-Received: by 2002:ac8:7647:: with SMTP id i7mr696021qtr.38.1552661192168;
 Fri, 15 Mar 2019 07:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.f6227e6c3d38ac887e358a1f54c5581c254da1bd.1552598161.git-series.maxime.ripard@bootlin.com>
 <6d73b7f5688e9e8424f09e11f12302268939d917.1552598161.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <6d73b7f5688e9e8424f09e11f12302268939d917.1552598161.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 15 Mar 2019 09:46:20 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+DR=m2zo8aZ5F-aKxjRwViOMvg2RwR757WL9K6+pS-oQ@mail.gmail.com>
Message-ID: <CAL_Jsq+DR=m2zo8aZ5F-aKxjRwViOMvg2RwR757WL9K6+pS-oQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] dt-bindings: media: Add Allwinner A10 CSI binding
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Mar 14, 2019 at 4:17 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> The Allwinner A10 CMOS Sensor Interface is a camera capture interface also
> used in later (A10s, A13, A20, R8 and GR8) SoCs.
>
> On some SoCs, like the A10, there's multiple instances of that controller,
> with one instance supporting more channels and having an ISP.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 115 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
>
> diff --git a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
> new file mode 100644
> index 000000000000..30c5dc1406cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
> @@ -0,0 +1,115 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/arm/allwinner,sun4i-a10-csi.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Allwinner A10 CMOS Sensor Interface (CSI) Device Tree Bindings
> +
> +maintainers:
> +  - Chen-Yu Tsai <wens@csie.org>
> +  - Maxime Ripard <maxime.ripard@bootlin.com>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +        - enum:

The 'standard' formatting is 2 more spaces of indentation here. IOW,
the '-' goes under the 'e' in items. yaml-format in the yaml-bindings
repo should reformat this correctly for you.

Both ways are valid, but the main advantage to that I see is it makes
it a bit more obvious when you have a list. It's easy to look at a
schema and miss the '-'.

> +          - allwinner,sun7i-a20-csi0
> +        - const: allwinner,sun4i-a10-csi0
> +
> +      - items:
> +        - const: allwinner,sun4i-a10-csi0
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    items:
> +      - description: The CSI interface clock
> +      - description: The CSI module clock
> +      - description: The CSI ISP clock
> +      - description: The CSI DRAM clock
> +
> +  clock-names:
> +    items:
> +      - const: bus
> +      - const: mod
> +      - const: isp
> +      - const: ram
> +
> +  resets:
> +    description: The reset line driver this IP
> +    maxItems: 1
> +
> +  pinctrl-0:
> +    minItems: 1
> +
> +  pinctrl-names:
> +    const: default
> +
> +  port:
> +    additionalProperties: false

Nodes should have a 'type: object'.

I'm adding a meta-schema to check this.

> +
> +    properties:
> +      endpoint:
> +        properties:
> +          bus-width:
> +            const: 8
> +            description:
> +              Number of data lines actively used.
> +

> +          data-active:
> +            description: Polarity of the data lines, 0 for active low,
> +              1 for active high.
> +            allOf:
> +              - $ref: /schemas/types.yaml#/definitions/uint32
> +              - enum: [0, 1]
> +
> +          hsync-active:
> +            description: Active state of the HSYNC signal, 0 for
> +              active low, 1 for active high.
> +            allOf:
> +              - $ref: /schemas/types.yaml#/definitions/uint32
> +              - enum: [0, 1]
> +
> +          pclk-sample:
> +            description: Sample data on the rising (1) or falling (0)
> +              edge of the pixel clock signal
> +            allOf:
> +              - $ref: /schemas/types.yaml#/definitions/uint32
> +              - enum: [0, 1]
> +
> +          remote-endpoint:
> +            $ref: '/schemas/types.yaml#/definitions/phandle'
> +            description: Phandle to an endpoint subnode of a remote
> +              device node.
> +
> +          vsync-active:
> +            description: Active state of the VSYNC signal, 0 for
> +              active low, 1 for active high.
> +            allOf:
> +              - $ref: /schemas/types.yaml#/definitions/uint32
> +              - enum: [0, 1]

These are all common properties, so we shouldn't be defining the type
here. And since you don't have any further constraints, just
'vsync-sample: true' would suffice.

> +
> +        required:
> +          - bus-width
> +          - data-active
> +          - hsync-active
> +          - pclk-sample
> +          - remote-endpoint
> +          - vsync-active
> +
> +    required:
> +      - endpoint
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +
> +additionalProperties: false
> --
> git-series 0.9.1
