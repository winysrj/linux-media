Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:52184 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754135AbdIHIQc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 04:16:32 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23992800AbdIHIQbBKhsZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 10:16:31 +0200
Date: Fri, 8 Sep 2017 10:16:30 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH v2 00/10] media: rc: gpio-ir-recv: driver update
Message-ID: <20170908081630.oiypchglntemwba4@lenoch>
References: <CGME20170907233401epcas4p4424e892b32d469233705af5014e20604@epcas4p4.samsung.com>
 <20170907233355.bv3hsv3rfhcx52i3@lenoch>
 <20170908022110.GB14947@gangnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908022110.GB14947@gangnam>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andi,

On Fri, Sep 08, 2017 at 11:21:10AM +0900, Andi Shyti wrote:
> Hi Ladislav,
> 
> > Serie was rebased on top of current linux.git, but something
> > happened there and my userspace decoder no longer works: driver
> > reports completely bogus timing such as (rc-5):
> > ^427, _1342, ^945, _183, ^1128, _671, ^1586, _91, ^1189, _1525,
> > ^1738, _1433, ^915, _1159, ^1464, _1525, ^213, _1067, ^793, _0
> > (^ used for pulse and _ for space)
> > As it has nothing to do with my changes, I'm sending it anyway
> > for review, which I do not expect to happen until merge window
> > ends.
> 
> This means that your patch is anyway untested.

Previous version is pretty well tested. GPIO IR stopped working
after pulling other changes from linux.git yesterday. And does not
work even without this patch set. I'll try to bisect later as omiting
linux-media merge did not fix it either.

> In any case I don't see much use if patch 1/10 as it doesn't
> simplify much, but the rest (from 2 to 10) looks good to me.

Just look at patch 9 and imagine how it would look without this
change. If you are still unconvinced I'll drop this change.

> Once it's tested you can add
> 
> Acked-by: Andi Shyti <andi.shyti@samsung.com>
> 
> Andi
> 
> P.S. I don't see in this V2 the changelog from V1. Next time,
> please add the changelog.

It was just a rebase with conflicts resolved. I do not see how
to describe it better than I did.

	ladis
