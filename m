Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD24C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A04B620989
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:02:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A04B620989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbeLEKCj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:02:39 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40333 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729072AbeLEJpe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 04:45:34 -0500
Received: by mail-ed1-f67.google.com with SMTP id d3so16431487edx.7;
        Wed, 05 Dec 2018 01:45:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TV1XO0Uved8LFFNzA4LL71DcJa0tScM4mubEOFV4mR0=;
        b=KroFkHR7ALGcBlw8163R8xnciUG6WPFtjqky3uiikrA/EN5XPUxRbdv2CyVViavt7w
         5LJ1LKjSeyIV4qFU9M2A52wuF10Nsc99aB3c7A6DMFPjBj9dpS4N6hOgf9amOW7pMdJ8
         ZURTVtI1mbzqvZRpaXY1EJpJhOIZFywh1ydbOOzu3FKZh++/T/Y5eLkH7zovA+PaYXLt
         c3b1WqVkQQuJtAPcisg/XVELyhgxTrSjZcoVEfzIHnvN8KFRDKvUU+r3J+2g+zdyJODb
         0pO4tDnM+zRSaUZ089c8QxsnIw+7oViODSXfnqmpkrlrB+LBN6BLOAPbwbaOPzT0h0iA
         JEZw==
X-Gm-Message-State: AA+aEWayT4w6+EolP/+xoZae2GJdrbnMaISYEjnXWMJUhKpoKQWsSn/D
        xi6fgyPEtblxXTL0jw/okV4YGJpu73g=
X-Google-Smtp-Source: AFSGD/Uv+7Q6Jef/bi4d+SascgkzjfEmLCGxmooTsf3roYegEsokS/4knjZwj50691todaY2EhcbAg==
X-Received: by 2002:a50:b0e5:: with SMTP id j92mr19431224edd.188.1544003131995;
        Wed, 05 Dec 2018 01:45:31 -0800 (PST)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id e53sm5424517ede.90.2018.12.05.01.45.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 01:45:31 -0800 (PST)
Received: by mail-wm1-f48.google.com with SMTP id m22so12185932wml.3;
        Wed, 05 Dec 2018 01:45:30 -0800 (PST)
X-Received: by 2002:a1c:c008:: with SMTP id q8mr13866947wmf.99.1544003130312;
 Wed, 05 Dec 2018 01:45:30 -0800 (PST)
MIME-Version: 1.0
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com> <20181205092444.29497-8-paul.kocialkowski@bootlin.com>
In-Reply-To: <20181205092444.29497-8-paul.kocialkowski@bootlin.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Wed, 5 Dec 2018 17:45:18 +0800
X-Gmail-Original-Message-ID: <CAGb2v66JwZ_RkEdk6sz-0Z7EJx7ieG3zBT6yr-95X6guxUkKTg@mail.gmail.com>
Message-ID: <CAGb2v66JwZ_RkEdk6sz-0Z7EJx7ieG3zBT6yr-95X6guxUkKTg@mail.gmail.com>
Subject: Re: [PATCH v2 07/15] arm64: dts: allwinner: h5: Add system-control
 node with SRAM C1
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 5, 2018 at 5:25 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Add the H5-specific system control node description to its device-tree
> with support for the SRAM C1 section, that will be used by the video
> codec node later on.
>
> The CPU-side SRAM address was obtained empirically while the size was
> taken from the documentation. They may not be entirely accurate.
>
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 22 ++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> index b41dc1aab67d..42bfb560b367 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> @@ -94,6 +94,28 @@
>         };
>
>         soc {
> +               system-control@1c00000 {
> +                       compatible = "allwinner,sun50i-h5-system-control";
> +                       reg = <0x01c00000 0x1000>;
> +                       #address-cells = <1>;
> +                       #size-cells = <1>;
> +                       ranges;
> +
> +                       sram_c1: sram@1d00000 {
> +                               compatible = "mmio-sram";
> +                               reg = <0x00018000 0x1c000>;

0x1d00000 or 0x18000?

> +                               #address-cells = <1>;
> +                               #size-cells = <1>;
> +                               ranges = <0 0x00018000 0x1c000>;

Same here.

> +
> +                               ve_sram: sram-section@0 {
> +                                       compatible = "allwinner,sun50i-h5-sram-c1",
> +                                                    "allwinner,sun4i-a10-sram-c1";
> +                                       reg = <0x000000 0x1c000>;
> +                               };
> +                       };
> +               };
> +
>                 mali: gpu@1e80000 {
>                         compatible = "allwinner,sun50i-h5-mali", "arm,mali-450";
>                         reg = <0x01e80000 0x30000>;
> --
> 2.19.2
>
