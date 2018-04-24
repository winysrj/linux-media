Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbeDXRsJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 13:48:09 -0400
Date: Tue, 24 Apr 2018 14:47:55 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
Message-ID: <20180424144755.1c2e2478@vento.lan>
In-Reply-To: <20180424103609.GD4064@hirez.programming.kicks-ass.net>
References: <cover.1524499368.git.gustavo@embeddedor.com>
        <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
        <20180423152455.363d285c@vento.lan>
        <20180424093500.xvpcm3ibcu7adke2@mwanda>
        <20180424103609.GD4064@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 24 Apr 2018 12:36:09 +0200
Peter Zijlstra <peterz@infradead.org> escreveu:

> On Tue, Apr 24, 2018 at 12:35:00PM +0300, Dan Carpenter wrote:
> > On Mon, Apr 23, 2018 at 03:24:55PM -0300, Mauro Carvalho Chehab wrote:  
> > > Em Mon, 23 Apr 2018 12:38:03 -0500
> > > "Gustavo A. R. Silva" <gustavo@embeddedor.com> escreveu:  
> 
> > > > @@ -875,6 +876,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
> > > >  	if (f->index >= ARRAY_SIZE(format))
> > > >  		return -EINVAL;
> > > >  
> > > > +	f->index = array_index_nospec(f->index, ARRAY_SIZE(format));  
> > >
> > > Please enlighten me: how do you think this could be exploited?  
> 
> TL;DR: read the papers [1] & [2]
> 
> I suspect you didn't get the gist of Spectre V1 [1], let me explain:
> 
> Suppose userspace provides f->index > ARRAY_SIZE(format), and we predict
> the branch to -EINVAL to not be taken.
> 
> Then the CPU _WILL_ load (out of bounds) format[f->index] into
> f->pixelformat and continue onwards to use this bogus value, all the way
> until it figures out the branch was mis-predicted.
> 
> Once it figures out the mispredict, it will throw away the state and
> start over at the condition site. So far, so basic.
> 
> The thing is, is will not (and cannot) throw away all state. Suppose our
> speculation continues into v4l_fill_fmtdesc() and that switch there is
> compiled as another array lookup, it will then feed our f->pixelformat
> (which contains random kernel memory) into that array to find the
> requested descr pointer.
> 
> Now, imagine userspace having flushed cache on the descr pointer array,
> having trained the branch predictor to mis-predict the branch (see
> branchscope paper [2]) and doing that out-of-bounds ioctl().
> 
> It can then speculative do the out-of-bounds array access, followed by
> the desc array load, then figure out it was wrong and redo.
> 
> Then usespace probes which part of the descr[] array is now in cache and
> from that it can infer the initial out-of-bound value.
> 
> So while format[] is static and bound, it can read random kernel memory
> up to format+4g, including your crypto keys.
> 
> As far as V1 goes, this is actually a fairly solid exploit candidate. No
> false positive about it.
> 
> Now kernel policy is to kill any and all speculation on user controlled
> array indexing such that we don't have to go look for subsequent side
> channels (the above cache side channel is the one described in the
> Spectre paper and by far the easiest, but there are other possible side
> channels) and we simply don't want to worry about it.
> 
> So even from that pov, the proposed patch is good.
> 
> 
> [1] https://spectreattack.com/spectre.pdf
> [2] www.cs.ucr.edu/~nael/pubs/asplos18.pdf

> On Tue, Apr 24, 2018 at 12:36:09PM +0200, Peter Zijlstra wrote:
> > 
> > Then usespace probes which part of the descr[] array is now in cache and
> > from that it can infer the initial out-of-bound value.  
> 
> Just had a better look at v4l_fill_fmtdesc() and actually read the
> comment. The code cannot be compiled as a array because it is big and
> sparse. But the log(n) condition tree is a prime candidate for the
> branchscope side-channel, which would be able to reconstruct a
> significant number of bits of the original value. A denser tree gives
> more bits etc.

Peter,

Thanks for a comprehensive explanation about that. It now makes more
sense to me.

Yeah, better to apply a fix to avoid the issue with VIDIOC_ENUM_FMT. 

Btw, on almost all media drivers, the implementation for enumerating
the supported formats are the same (and we have a few other VIDOC_ENUM_foo
ioctls that usually do similar stuff): the V4L2 core calls a driver,
with looks into an array, returning the results to the core.

So, a fix like that should likely go to almost all media drivers
(there are a lot of them!), and, for every new one, to take care
to avoid introducing it again during patch review process.

So, I'm wondering if are there any way to mitigate it inside the 
core itself, instead of doing it on every driver, e. g. changing
v4l_enum_fmt() implementation at v4l2-ioctl.

Ok, a "poor man" approach would be to pass the array directly to
the core and let the implementation there to implement the array
fetch logic, calling array_index_nospec() there, but I wonder if
are there any other way that won't require too much code churn.


Thanks,
Mauro
