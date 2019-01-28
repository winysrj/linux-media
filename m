Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF158C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 16:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DFF62147A
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548694610;
	bh=l644JXd3NOUX2dUGbeApzXMy9qq3K2AgIt3Ppvs/Aoo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ZcJkfKiScFgTPESNy4jWq079++0bOLImQdNZYG2Z4S1abvmMioVG4ZunR32GnI+yg
	 0BtTon/rRtk9gZq6hpJRv+qQ2gkHtpvM0WPCFrKnhzGZ0J8T0FwpuEMPPw3aoXyRMW
	 xfpfzSjssCt7FCHmfTadCr+uffS4t+JZsTuPFA08=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388208AbfA1QRY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732451AbfA1QRX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 11:17:23 -0500
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2020921741;
        Mon, 28 Jan 2019 16:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548692242;
        bh=l644JXd3NOUX2dUGbeApzXMy9qq3K2AgIt3Ppvs/Aoo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pRT/sqLNIzGBTR6mG7stPyKDW8agesa+KR/kuTJtS4UncpCimBb1P/rU3UeCHOHdW
         5sp1oEnxtj95pBQmWFopx6/5dm60V7R7rhLm1vvUbvjacPBQ1gCOH1H2MFWyO9SHEc
         aWngiv4DxS0jimivqCpWxbYcJ3XWHE86wxloaiEA=
Received: by mail-qk1-f181.google.com with SMTP id c21so9688862qkl.6;
        Mon, 28 Jan 2019 08:17:22 -0800 (PST)
X-Gm-Message-State: AJcUukdFM56T8vZMzzlRLmdsNsbYm0Nn4Kc4oqs9F076/WVidzreCeke
        gg0tcOrZxkOPVR08KxDc+ohbNUj3wykfjqVbAw==
X-Google-Smtp-Source: ALg8bN5XcP+boaJr0aIBN7CN+8meZI8yn2IkC5Nvgo+5QMSV5wZmJSuh00bE6swT6HqLay+gEtqaz1sUM6G0BACqXe0=
X-Received: by 2002:a37:7682:: with SMTP id r124mr20140647qkc.79.1548692241275;
 Mon, 28 Jan 2019 08:17:21 -0800 (PST)
MIME-Version: 1.0
References: <cover.ba7411f0c7155d0292b38d3dec698e26b5cc813b.1548687041.git-series.maxime.ripard@bootlin.com>
 <f6b6adf84c58e0de605d0a23dd559fee011f380c.1548687041.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <f6b6adf84c58e0de605d0a23dd559fee011f380c.1548687041.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 28 Jan 2019 10:17:09 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKOyr3nbXozTqBsEAQGw2bPsBGvFpJ_X7S-izdjTWxK=g@mail.gmail.com>
Message-ID: <CAL_JsqKOyr3nbXozTqBsEAQGw2bPsBGvFpJ_X7S-izdjTWxK=g@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] dt-bindings: media: Add Allwinner A10 CSI binding
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
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

On Mon, Jan 28, 2019 at 8:52 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> The Allwinner A10 CMOS Sensor Interface is a camera capture interface also
> used in later (A10s, A13, A20, R8 and GR8) SoCs.
>
> On some SoCs, like the A10, there's multiple instances of that controller,
> with one instance supporting more channels and having an ISP.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 73 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
>
> diff --git a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
> new file mode 100644
> index 000000000000..f550fefa074f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
> @@ -0,0 +1,73 @@
> +# SPDX-License-Identifier: (GPL-2.0+ OR X11)

X11 is generally wrong because it is specific to X Consortium. MIT is
what you want.

The core bindings are using 'GPL-2.0 OR BSD-2-Clause'. I don't think
it really matters whether we have a mixture of MIT and BSD, but if you
don't have a reason to deviate, I wouldn't.

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
> +      - description: Allwinner A10 CSI0 Controller
> +        items:
> +        - const: allwinner,sun4i-a10-csi0
> +
> +      - description: Allwinner A20 CSI0 Controller
> +        items:
> +        - const: allwinner,sun7i-a20-csi0

You may want to use 'enum' here if you will have more to add later.

> +        - const: allwinner,sun4i-a10-csi0
> +
> +  reg:
> +    description: The base address and size of the memory-mapped region

IMO, we don't need to define what 'reg' is everywhere.

> +    maxItems: 1
> +
> +  interrupts:
> +    description: The interrupt associated to this IP

Same here.

> +    maxItems: 1
> +
> +  clocks:
> +    minItems: 4
> +    maxItems: 4

No need for these. We count 'items' and add them automatically. You
only need them if the size is variable.

> +    items:
> +      - description: The CSI interface clock
> +      - description: The CSI module clock
> +      - description: The CSI ISP clock
> +      - description: The CSI DRAM clock
> +
> +  clock-names:
> +    minItems: 4
> +    maxItems: 4

Same here.

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
> +  pinctrl-0: true

No defined length? I guess we generally allow a variable number of entries.

> +
> +  pinctrl-names:
> +    description:
> +      When present, must have one state named "default" that sets up
> +      pins for ordinary operations.
> +    minItems: 1
> +    maxItems: 1
> +    items:
> +      - const: default

A single entry can be simplified to just 'const: default' under pinctrl-names.

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +
> +# The media OF-graph binding hasn't been described yet
> +# additionalProperties: false
> --
> git-series 0.9.1
