Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256E5C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 21:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC34C2082D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 21:22:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VU3A93J6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC34C2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbeLGVWh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 16:22:37 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35395 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeLGVWg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 16:22:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id 96so5086646wrb.2;
        Fri, 07 Dec 2018 13:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qs4uDAGcVXL97ifLvnitOFApRux8uziSKhY2nP1qpWc=;
        b=VU3A93J68rWpAPYozx/PVjnAe3XghKxITuFmzcejLzJRHNhPkktl4eu56D22Qd4TfW
         GViKca2HLQSQbpZn+x2dlVhgGBQvKT9lPj9KVNfhtqPudziXI7zAHkezNocyM2dgE4vP
         42ZM0Wh2hU8LoIEM0oi+ndVz5mr0BUXMRkSKRBYZqk5fhamw4iKXwWPYh/QQLW7CfUCF
         lw0rrN19eCK0OcXgR3WD7Nocb0GvCMJPIAQzwJ7gKJKjKus+Vo/zdrvq6drNpdfduh2x
         SHpxQeL2/W+PJ8McIQbWSaLBhMsIeGWuhK4XQL1zPeuAY8NBYqnCGhJOQzQ9Un11YsdR
         rlIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qs4uDAGcVXL97ifLvnitOFApRux8uziSKhY2nP1qpWc=;
        b=Y2Hy/iB/10TRloclFLoct17tR7udnM87QK3rL0kVAiwSyOvGRJfl3X495v7s3l9hnF
         XwY+JOsfvCVnE9XKZMEPgOGv5psaay0PQvaiAGEB09ClsZgJE83fkggZVbak/Ns8/+3x
         kgRN8HJNRW5MbOI1z/ZFESVkXPiADP/itAsNxJHEVWHfUbBRvZTmBfq2jvpIjCJ7obCj
         LHoXEuS/3v/kKwUvZyY7SR7iJyHZILOn/GTGNyaDmdL7rHG5AHiv6Fh1RiHRleLqJMVy
         TtqWnckBEzgssBVIhXEo0rVas610/XLjLkIwFWualUuNombFKKcNS8JZAsFkygxAJjI0
         6n9g==
X-Gm-Message-State: AA+aEWZnhT/xaxXVw8GUMYlIewKMyX3OE48hrX1A2kJ9kYKKUtnapEZx
        DEEwwjZ4m3yzmnDekAcUtHJ+tg15AJo=
X-Google-Smtp-Source: AFSGD/UScrJZm0/2RXrpeiTJBgzH+jsN0vo+gqEJW14qD4dGjknTWP7X3DNH7JojVDTLGKc/vGQxzQ==
X-Received: by 2002:a5d:5089:: with SMTP id a9mr3174445wrt.327.1544217753940;
        Fri, 07 Dec 2018 13:22:33 -0800 (PST)
Received: from jernej-laptop.localnet (cpe1-8-82.cable.triera.net. [213.161.8.82])
        by smtp.gmail.com with ESMTPSA id b129sm3109832wmd.24.2018.12.07.13.22.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Dec 2018 13:22:32 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     linux-sunxi@googlegroups.com, paul.kocialkowski@bootlin.com
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [linux-sunxi] [PATCH v2 15/15] arm64: dts: allwinner: a64: Add Video Engine node
Date:   Fri, 07 Dec 2018 22:22:30 +0100
Message-ID: <2823800.C4zEU5jiS7@jernej-laptop>
In-Reply-To: <20181205092444.29497-16-paul.kocialkowski@bootlin.com>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com> <20181205092444.29497-16-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi!

Dne sreda, 05. december 2018 ob 10:24:44 CET je Paul Kocialkowski napisal(a):
> This adds the Video Engine node for the A64. Since it can map the whole
> DRAM range, there is no particular need for a reserved memory node
> (unlike platforms preceding the A33).
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi index
> 8557d52c7c99..8d024c10d7cb 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> @@ -397,6 +397,17 @@
>  			};
>  		};
> 
> +		video-codec@1c0e000 {
> +			compatible = "allwinner,sun50i-h5-video-engine";

You meant A64 instead of H5, right?

Best regards,
Jernej

> +			reg = <0x01c0e000 0x1000>;
> +			clocks = <&ccu CLK_BUS_VE>, <&ccu CLK_VE>,
> +				 <&ccu CLK_DRAM_VE>;
> +			clock-names = "ahb", "mod", "ram";
> +			resets = <&ccu RST_BUS_VE>;
> +			interrupts = <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
> +			allwinner,sram = <&ve_sram 1>;
> +		};
> +
>  		mmc0: mmc@1c0f000 {
>  			compatible = "allwinner,sun50i-a64-mmc";
>  			reg = <0x01c0f000 0x1000>;




