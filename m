Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827E3C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CBB62063F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731641AbfCANIx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:08:53 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:58805 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728305AbfCANIw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 08:08:52 -0500
Received: from [IPv6:2001:983:e9a7:1:e06f:53e3:ca47:5e48] ([IPv6:2001:983:e9a7:1:e06f:53e3:ca47:5e48])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zhuDgNzLwLMwIzhuEgiilX; Fri, 01 Mar 2019 14:08:50 +0100
Subject: Re: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Biju Das <biju.das@bp.renesas.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
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
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
 <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl>
 <CAMuHMdXOcFaQiLUNiuUS_p5H0r3ZWMrWd09m5xZk4qitvLS25g@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3b702231-8d50-8434-177c-716203dac7b2@xs4all.nl>
Date:   Fri, 1 Mar 2019 14:08:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXOcFaQiLUNiuUS_p5H0r3ZWMrWd09m5xZk4qitvLS25g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPTYzrui5bWkYcPfOrU4WaGbYermkjVG3yeqkcCmbXOMrnDD4GDU2NmpxfS6Xrp7rQ9c1ql/kgpCGvP5PQGE/GjEWpFjwO0ayKt+KeL3uhmj396ET68n
 jExtJfK6kjNTXGwmv7uZM6iAGGiPOwlF9FjLVdajxvS9B/fedT2OQuGA5jfhy1d5Vy94Ijs2wQf0h1fU6XUAzphBr2odRlA59f/JkGU3aHMkqg3oevvtaFWM
 FydzbVs4RnstlxYUBpuYSV53BVwSJlpla708vyTfK2K0m0+t1mUk5ITuQbGFa2yhbFWHrHZzJzX8fq72wD0Ogy5F3l9Du9JIVfJ5K9QS7d7NhRXcLzq3qqPb
 ZdH95Vh0hvnJSDNdpoJMYRiPkuXre46ezTbzHlne6L71vmaga3RgeNOwG2fNqhF2+m0+dkH+YjB9W7PtYGnM8GU790xYlZurEnzgYDoPfawWCd9Z9vC309O0
 qGvk2VmUjRFZ+Qam86gfJsK/BztvJSTCNxUwUo3KGu0nwujPcAURzEEwIERcqL4x3gKVZtKvoaYwLF+zSflyek7dJNXKm/Pz6treqzQ9tWLRjoHK9794Qvk5
 bEBuMaUCxnNxaBqfzrFYoXhX3geyBaEJun3FCUm/q80Mdl9XpHLzIBTp7UYskwDY2HOr1PPf9Opi51o1updIzvdNa4HovHUYyZK4b3lO1Dj+N+6rGqaHN78B
 bqcS2jV3QFVURXLj3YKc2+4gqG/Amxy+kfY5F8x4iNKPtGBeIIjaevNjQRT1tGTPSusUdN+EsKU=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/1/19 1:58 PM, Geert Uytterhoeven wrote:
> Hi Hans,
> 
> On Fri, Mar 1, 2019 at 1:55 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> It looks like this series fell through the cracks.
>>
>> I looked at it and the main problem is that it is missing a Reviewed-by
>> from Rob Herring (devicetree maintainer). It's a bit surprising since he
>> is usually fairly prompt.
> 
> He actually did provide his Rb on Sep 17.

Hmm, I don't see anything about that in my linux-media archive, and patchwork
didn't pick that up either.

Was linux-media in the CC list of Rob's reply?

Regards,

	Hans

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 

