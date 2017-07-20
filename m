Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:38692 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934862AbdGTSZx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 14:25:53 -0400
Received: by mail-wr0-f180.google.com with SMTP id f21so17586157wrf.5
        for <linux-media@vger.kernel.org>; Thu, 20 Jul 2017 11:25:53 -0700 (PDT)
Date: Thu, 20 Jul 2017 20:25:49 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Ralph Metzler <rjkm@metzlerbros.de>, linux-media@vger.kernel.org,
        mchehab@kernel.org, jasmin@anw.at, d_spingler@gmx.de
Subject: Re: [PATCH 00/14] ddbridge: bump to ddbridge-0.9.29
Message-ID: <20170720202549.6d77b8d2@audiostation.wuest.de>
In-Reply-To: <20170720122412.0aaefcfe@vento.lan>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
        <22883.13973.46880.749847@morden.metzler>
        <20170710173124.653286e7@audiostation.wuest.de>
        <22884.38463.374508.270284@morden.metzler>
        <20170711173013.25741b86@audiostation.wuest.de>
        <20170720122412.0aaefcfe@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am Thu, 20 Jul 2017 12:24:12 -0300
schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Tue, 11 Jul 2017 17:30:13 +0200
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> 
> > Am Tue, 11 Jul 2017 11:11:27 +0200
> > schrieb Ralph Metzler <rjkm@metzlerbros.de>:
> >   
> > > Daniel Scheller writes:    
> > >  > 
> > >  > IIRC this was -main.c, and basically the code split, but no
> > >  > specific file. However, each of the additionals (hw, io, irq)
> > >  > were done with a reason (please also see their commit messages
> > >  > at patches 4-6):
> > >  > [...]    
> > > 
> > > As I wrote before, changes like this will break other things like
> > > the OctopusNet build tree. So, I cannot use them like this or
> > > without changes at other places. And even if I wanted to, I
> > > cannot pull anything into the public dddvb repository.    
> > 
> > Ok, you probably have seen the PRs I created against dddvb, as they
> > apply basically the same as is contained in this patchset, and even
> > fixes a few minors. Thus, lets not declare this as merge-blocker for
> > this patches, please.  
> 
> I would prefer if we could spend more time trying to find a way where
> we can proceed without increasing the discrepancies between upstream
> and DD tree, but, instead to reduce. 
> 
> I mean, if we know that some change won't be accepted at DD tree,
> better to change our approach to another one that it is acceptable
> on both upstream and DD trees.

(hopefully not too much language barrier coming up...)

First and foremost (to everyone involved) - I appeal at you all, in
the name of all DD hardware owners, for like six approaches to get the
patches in shape and over 1.5 years of spare time spent, to not make
this a reason to block the patches. And yes, Mauro, I understand
what you're up to.

Rather, this closes the gap between the current dddvb drivers and what
we have in mainline by at least 24 (!!) (plus some minor revisions and
other intermediate versions I couldn't get tar archives for) software
releases. Plus, the only real difference we have after these patches is
support for the DVB-C modulator cards and the OctoNET box support (with
that, support for the aforementioned GTL links, which I even already
have a patch for to add that back), and both are features that are
removed *for now* only due to the API changes involved, which simply is
a tad too much for me right now to add them in and provide reasoning
why they're needed and what exactly they do. Speaking of the modulator
card support, things are even quite simple, see [1] and [2] what I
gathered from the package to have all things API in place. In
addition, the parts in ddbridge can be added back quite easily (some
output-dma things, PCI IDs plus ddbridge-mod[ulator].c). If these two
simple things are acceptable in DVB core, I can even prepare patches
for getting the modulator support back in.

As Ralph mentioned the three additional files -irq, -io and -hw, I do
not insist on them, but rather thought it'd be a good way to further
make things cleaner, by separating things more.

So, again, please do not make this a blocker, but lets rather make this
a start to get things closer to each other, and continue in doing so by
finding agreements in parallel. And: I _WILL_ care about keeping the
mainline version in sync with upstream and NOT diverge further; this is
what the MAINTAINERS entry is meant for at last!

[1]
https://github.com/herrnst/dddvb-linux-kernel/commit/c586db283ef51f43ecb1d1c9e49230184ea02714
[2]
https://github.com/herrnst/dddvb-linux-kernel/commit/f448a8485a24acec7b44ac418ef57b59eb8369cd

All the best,
Daniel Scheller
-- 
https://github.com/herrnst
