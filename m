Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEC4C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A036E2084F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfCAM6g (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 07:58:36 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:42583 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfCAM6g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 07:58:36 -0500
Received: by mail-ua1-f65.google.com with SMTP id s26so11678644uao.9;
        Fri, 01 Mar 2019 04:58:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LIV7jgvplFoXjxFwM7fMQDRTfuDaqaDZMno/qvgOPHY=;
        b=sYs89zLn/TnRRCSpjgUNqjnNCygUEQ7C7Yx8g2Z71lgzzuO3AFvqXDv5lAtuqjCyK9
         SogQDIFC74+jS9sB5c2lzG+B+kLmnV4o9Ea6cU8NRcIk0BNDvWcvA1qMGDCldcfiidYM
         /lKZJ1Py2chCwyaZyVHt4OSmUu8p2qGaN8zm44/v4wIp+09dEEff3ngja5j5AA9KB6Wm
         u9wV1jmilNwnzJuXyrAwwpgmzX/NfERZlAruxEF9Ton1AEhzvE3ygj/uQGunFc2qE5Jf
         zEUZWcGxaMxRKm3+MMKClQxCseGYkn+plOpWtdChDJ43loRdNr/ZyLQJofWDj6rM13CA
         tfUQ==
X-Gm-Message-State: APjAAAWDWvz1AAVE74gjnb44q/hTRV3ZpFmk7sQvu0v7bQPbPQI2lSnE
        YdZQ78Y5oJ7PUuO0NhMrHtizze6QSoAQQRrsoJs=
X-Google-Smtp-Source: APXvYqwK3suBL6Qw9L2wIymA0WNCsUwXqi7YfqAZi9CdCqK2rqGek78uvwaSsicltbz1ylW8GNPhXB2XbbGuiAxg22c=
X-Received: by 2002:a9f:30dc:: with SMTP id k28mr2515863uab.75.1551445115439;
 Fri, 01 Mar 2019 04:58:35 -0800 (PST)
MIME-Version: 1.0
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
 <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl>
In-Reply-To: <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 1 Mar 2019 13:58:23 +0100
Message-ID: <CAMuHMdXOcFaQiLUNiuUS_p5H0r3ZWMrWd09m5xZk4qitvLS25g@mail.gmail.com>
Subject: Re: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1 support
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Biju Das <biju.das@bp.renesas.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Fri, Mar 1, 2019 at 1:55 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> It looks like this series fell through the cracks.
>
> I looked at it and the main problem is that it is missing a Reviewed-by
> from Rob Herring (devicetree maintainer). It's a bit surprising since he
> is usually fairly prompt.

He actually did provide his Rb on Sep 17.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
