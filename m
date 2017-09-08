Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:32811 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752372AbdIHCVK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 22:21:10 -0400
Date: Fri, 08 Sep 2017 11:21:10 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Ladislav Michl <ladis@linux-mips.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH v2 00/10] media: rc: gpio-ir-recv: driver update
Message-id: <20170908022110.GB14947@gangnam>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
References: <CGME20170907233401epcas4p4424e892b32d469233705af5014e20604@epcas4p4.samsung.com>
        <20170907233355.bv3hsv3rfhcx52i3@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ladislav,

> Serie was rebased on top of current linux.git, but something
> happened there and my userspace decoder no longer works: driver
> reports completely bogus timing such as (rc-5):
> ^427, _1342, ^945, _183, ^1128, _671, ^1586, _91, ^1189, _1525,
> ^1738, _1433, ^915, _1159, ^1464, _1525, ^213, _1067, ^793, _0
> (^ used for pulse and _ for space)
> As it has nothing to do with my changes, I'm sending it anyway
> for review, which I do not expect to happen until merge window
> ends.

This means that your patch is anyway untested.

In any case I don't see much use if patch 1/10 as it doesn't
simplify much, but the rest (from 2 to 10) looks good to me.

Once it's tested you can add

Acked-by: Andi Shyti <andi.shyti@samsung.com>

Andi

P.S. I don't see in this V2 the changelog from V1. Next time,
please add the changelog.
