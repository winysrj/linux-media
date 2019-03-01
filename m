Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93E1C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B324B20851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfCANNn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:13:43 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:45141 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfCANNn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:13:43 -0500
Received: by mail-ua1-f66.google.com with SMTP id u1so21642194uae.12;
        Fri, 01 Mar 2019 05:13:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bHDdbdBBw3bKkql+R/jNaI7u2bjY0PR+MHuUvblTS7g=;
        b=VDUxaoDMgJfg0Ov3ZzGCsTwpi728Y591d+e5FSN/3uqYqVukN1zKBxol5SS3gSBIaZ
         QW3OUNIw1sbyo3qGGeu3Y/xMdLUCguR8FWcVOomHcpODGfpc8yiOCMLJQvZnX8NVtgb5
         QECuIyQfyjW0nltnRmvW17kF872GZIbc0kkhC7EyEY3UCmRDNaV9791h596QpDI03vly
         XxQzNogoXE6z4hIxq3SX0l9auDiXyQ8ThOqskxl8PYTgXxIhe9t/gBMtg08P1/szpV/Y
         wyUOqUq0icysPpBb6glKvBWO+pp5sxVj56XRNSEW4jVZUjSBDchBM128gdleOOvJAyYw
         qaxQ==
X-Gm-Message-State: APjAAAWWwg0dmaoRO+MO5SDPzSkUK/s8J8KAiJgg3YiKIJjkU3E89kyz
        9GydPBTlQhgguSaYLXwytGKP3ltBSWsY+xAYFjU=
X-Google-Smtp-Source: APXvYqyGnsly+gIKJE+Tld2wFRWj0PE6qlVbNR5kSOI86JWzvyw/NxcIuLDKeskQ+qlbIzXIuVbfTQx004F3nCWS1JE=
X-Received: by 2002:ab0:6950:: with SMTP id c16mr2547409uas.0.1551446022017;
 Fri, 01 Mar 2019 05:13:42 -0800 (PST)
MIME-Version: 1.0
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
 <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl> <CAMuHMdXOcFaQiLUNiuUS_p5H0r3ZWMrWd09m5xZk4qitvLS25g@mail.gmail.com>
 <3b702231-8d50-8434-177c-716203dac7b2@xs4all.nl>
In-Reply-To: <3b702231-8d50-8434-177c-716203dac7b2@xs4all.nl>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 1 Mar 2019 14:13:29 +0100
Message-ID: <CAMuHMdUuyaryxPYydkSpEv5rxivrBybCjuJ4m5REygG+xQSyAg@mail.gmail.com>
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

On Fri, Mar 1, 2019 at 2:08 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 3/1/19 1:58 PM, Geert Uytterhoeven wrote:
> > On Fri, Mar 1, 2019 at 1:55 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> It looks like this series fell through the cracks.
> >>
> >> I looked at it and the main problem is that it is missing a Reviewed-by
> >> from Rob Herring (devicetree maintainer). It's a bit surprising since he
> >> is usually fairly prompt.
> >
> > He actually did provide his Rb on Sep 17.
>
> Hmm, I don't see anything about that in my linux-media archive, and patchwork
> didn't pick that up either.
>
> Was linux-media in the CC list of Rob's reply?

Yes it was, just like linux-renesas-soc. But lore.kernel.org also has
no evidence.
I have received it directly, as I was on CC.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
