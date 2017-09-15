Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:48484 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdIOV4I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 17:56:08 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23992036AbdIOV4GreuEZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 23:56:06 +0200
Date: Fri, 15 Sep 2017 23:56:05 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH v2 00/10] media: rc: gpio-ir-recv: driver update
Message-ID: <20170915215605.zqfs73g575ctqhsp@lenoch>
References: <CGME20170907233401epcas4p4424e892b32d469233705af5014e20604@epcas4p4.samsung.com>
 <20170907233355.bv3hsv3rfhcx52i3@lenoch>
 <20170908022110.GB14947@gangnam>
 <20170908081630.oiypchglntemwba4@lenoch>
 <20170911025843.GA31540@gangnam>
 <20170911071332.r47nt5m26l6tsrpw@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911071332.r47nt5m26l6tsrpw@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 11, 2017 at 09:13:32AM +0200, Ladislav Michl wrote:
> On Mon, Sep 11, 2017 at 11:58:43AM +0900, Andi Shyti wrote:
> > Hi Ladislav,
> > 
> > > > > Serie was rebased on top of current linux.git, but something
> > > > > happened there and my userspace decoder no longer works: driver
> > > > > reports completely bogus timing such as (rc-5):
> > > > > ^427, _1342, ^945, _183, ^1128, _671, ^1586, _91, ^1189, _1525,
> > > > > ^1738, _1433, ^915, _1159, ^1464, _1525, ^213, _1067, ^793, _0
> > > > > (^ used for pulse and _ for space)
> > > > > As it has nothing to do with my changes, I'm sending it anyway
> > > > > for review, which I do not expect to happen until merge window
> > > > > ends.
> > > > 
> > > > This means that your patch is anyway untested.
> > > 
> > > Previous version is pretty well tested. GPIO IR stopped working
> > > after pulling other changes from linux.git yesterday. And does not
> > > work even without this patch set. I'll try to bisect later as omiting
> > > linux-media merge did not fix it either.
> > 
> > OK
> 
> In all truth, changes were developed on top of 4.9.40, testing was done at
> customer's site and for generally usefull changes usual attempt for merge
> was done :-) I tried unmodified driver over weekend:
> 4.9.0: Not OK
> 4.9.40: OK
> 4.9.13: Not OK
> linux.git: Not OK
> Tested on IGEPv2 board based on DM3730, so something went wrong again.
> Based on driver principle I suspect either ktime_get returning "strange"
> values or interrupts are broken again (but that does not explain those
> short pulses and spaces):
> https://www.spinics.net/lists/linux-omap/msg135915.html
> Verifying that would require some test setup with signal generator and
> scope, as described in said email thread; or combine that test driver
> with this one and look what is really happening. Unfortunately I'm not
> able to do this any time soon, so if someone has hardware reliably working
> with current mainline and is willing to test this patch serie I would
> be very happy to see it happen.

So, turns out to be GPIO edge interrupt handling bug on OMAPs.
Proper fix still needs to be investigated, but it does not affect
this patch serie.

> > > > In any case I don't see much use if patch 1/10 as it doesn't
> > > > simplify much, but the rest (from 2 to 10) looks good to me.
> > > 
> > > Just look at patch 9 and imagine how it would look without this
> > > change. If you are still unconvinced I'll drop this change.
> > 
> > You don't need to, that's just my personal taste and I'm not
> > strong with it. Patch 1 is quite common and not a big deal anyway.
> > If you like it you like you can leave it :)
> > 
> > > > P.S. I don't see in this V2 the changelog from V1. Next time,
> > > > please add the changelog.
> > > 
> > > It was just a rebase with conflicts resolved. I do not see how
> > > to describe it better than I did.
> > 
> > You could write the above (i.e. V2 fixed rebase conflicts :) ).
> > The reason is that as no change is stated, I have to anyway, as
> > reviewer, compare side by side all patches to figure out if there
> > is any difference (even if small) that is not expected.
> 
> Fair enough. Let's wait if there will any more comments and I'll do
> better in V3.
> 
> > Thanks,
> > Andi
> 
> Best regards,
> 	ladis
