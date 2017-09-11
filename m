Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:60430 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752017AbdIKC6l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Sep 2017 22:58:41 -0400
Date: Mon, 11 Sep 2017 11:58:43 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Ladislav Michl <ladis@linux-mips.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH v2 00/10] media: rc: gpio-ir-recv: driver update
Message-id: <20170911025843.GA31540@gangnam>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <20170908081630.oiypchglntemwba4@lenoch>
References: <CGME20170907233401epcas4p4424e892b32d469233705af5014e20604@epcas4p4.samsung.com>
        <20170907233355.bv3hsv3rfhcx52i3@lenoch> <20170908022110.GB14947@gangnam>
        <20170908081630.oiypchglntemwba4@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ladislav,

> > > Serie was rebased on top of current linux.git, but something
> > > happened there and my userspace decoder no longer works: driver
> > > reports completely bogus timing such as (rc-5):
> > > ^427, _1342, ^945, _183, ^1128, _671, ^1586, _91, ^1189, _1525,
> > > ^1738, _1433, ^915, _1159, ^1464, _1525, ^213, _1067, ^793, _0
> > > (^ used for pulse and _ for space)
> > > As it has nothing to do with my changes, I'm sending it anyway
> > > for review, which I do not expect to happen until merge window
> > > ends.
> > 
> > This means that your patch is anyway untested.
> 
> Previous version is pretty well tested. GPIO IR stopped working
> after pulling other changes from linux.git yesterday. And does not
> work even without this patch set. I'll try to bisect later as omiting
> linux-media merge did not fix it either.

OK

> > In any case I don't see much use if patch 1/10 as it doesn't
> > simplify much, but the rest (from 2 to 10) looks good to me.
> 
> Just look at patch 9 and imagine how it would look without this
> change. If you are still unconvinced I'll drop this change.

You don't need to, that's just my personal taste and I'm not
strong with it. Patch 1 is quite common and not a big deal anyway.
If you like it you like you can leave it :)

> > P.S. I don't see in this V2 the changelog from V1. Next time,
> > please add the changelog.
> 
> It was just a rebase with conflicts resolved. I do not see how
> to describe it better than I did.

You could write the above (i.e. V2 fixed rebase conflicts :) ).
The reason is that as no change is stated, I have to anyway, as
reviewer, compare side by side all patches to figure out if there
is any difference (even if small) that is not expected.

Thanks,
Andi
