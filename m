Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0C8C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 08:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27D6E21736
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 08:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="jdAsyQ90"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfBKIWv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 03:22:51 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:37947 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfBKIWv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 03:22:51 -0500
Received: by mail-it1-f196.google.com with SMTP id z20so24047942itc.3
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2019 00:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvY2/yBGMwbngNDLa66cM3Z3OvAxuwsm6ud86Xu01mE=;
        b=jdAsyQ90mli/1X4feqFov2FjxbYBaMp8oZXHDFKZAWdO1k84n+XBqCwxjtSJ8VoJM9
         lFJCACs/k+wKAao0f9jIyuZozeIDbrBMETX3xuOOUCzseOUdxq3r8S3hsyqwQpGUgtNl
         ern03whpopTdNC/7JyKsxVGGZJZy2bZm6hI00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvY2/yBGMwbngNDLa66cM3Z3OvAxuwsm6ud86Xu01mE=;
        b=Y6VpJSM1ppr/ivhZZM4uB8UQ6sD+7DF+mYaE0iHHo6WzffHNfL1QR2uLnM9ocULK4H
         L48vGddxqbWYFbF+iZTrUw57pmwdqbX2SQUAGXBI4G4QUootjquxfQdr/OppfsqKS5UZ
         f6toec94ztJ3EACA0Nt9yRcpKLI8GH5pNUmXnUjKu85SfkUZmu4gjFUMP1LfmRZWRZJD
         kWlLiPb9wUKohKtAZyCpUdDf/edHAN+xOCIRDfToCpHeb6RCrKOKcx95g17YEcra08+D
         HHOqShVbGtHMmHlclrlRAguHKvg4ODfjKJLUyeuZehvXN+nqKjvVk48apnIpRrh+bni8
         HhSQ==
X-Gm-Message-State: AHQUAua1HX+Mysr4KZ3A86S6eC1wsZIZuKLvjh4oHLSCryhSvYdcUkc9
        XxunBoRWEwjeBFV8GcMWK+P2hBiQzJz9Z8/JlUC1Qw==
X-Google-Smtp-Source: AHgI3IaFcZZL/2rH9QTpGunyScGyRTXN776wXOAZSs3378quUqLuNmzuocgC1Zo1SMOQDR5v96EwagPe0Xwc0kqbyPg=
X-Received: by 2002:a6b:b790:: with SMTP id h138mr14110911iof.114.1549873370645;
 Mon, 11 Feb 2019 00:22:50 -0800 (PST)
MIME-Version: 1.0
References: <20190128085847.7217-1-jagan@amarulasolutions.com>
In-Reply-To: <20190128085847.7217-1-jagan@amarulasolutions.com>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Mon, 11 Feb 2019 13:52:39 +0530
Message-ID: <CAMty3ZCdm_RoVxoHy9u2-Xhg4_tf7Mr0Gedcrz-jVhc5ceL0CQ@mail.gmail.com>
Subject: Re: [PATCH v8 0/5] media/sun6i: Allwinner A64 CSI support
To:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com,
        devicetree <devicetree@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Mauro and Maxime,

On Mon, Jan 28, 2019 at 2:29 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
>
> Add CSI support for Allwinner A64. Here is previous series[1]
>
> Changes for v8:
> - update proper enable and disable sequnce for clk_mod
> - fix warning for patch "media: sun6i: Add A64 CSI block support"
> - collect Maxime Acked-by
> Changes for v7:
> - Drop quirk change, and add as suggusted by Maxime
> - Use csi instead csi0 in pinctrl function
> Changes for v6:
> - set the mod rate in seett_power instead of probe
> Changes for v5:
> - Add mod_rate quirk for better handling clk_set code
> Changes for v4:
> - update the compatible string order
> - add proper commit message
> - included BPI-M64 patch
> - skipped amarula-a64 patch
> Changes for v3:
> - update dt-bindings for A64
> - set mod clock via csi driver
> - remove assign clocks from dtsi
> - remove i2c-gpio opendrian
> - fix avdd and dovdd supplies
> - remove vcc-csi pin group supply
>
> [1] https://patchwork.kernel.org/cover/10779831/
>
> Jagan Teki (5):
>   dt-bindings: media: sun6i: Add A64 CSI compatible
>   media: sun6i: Add A64 CSI block support
>   arm64: dts: allwinner: a64: Add A64 CSI controller
>   arm64: dts: allwinner: a64: Add pinmux setting for CSI MCLK on PE1

Any chance to apply this patches? dtsi patch is already been merged
and all been Acked as well.
