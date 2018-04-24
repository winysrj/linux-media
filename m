Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36806 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932545AbeDXKgU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 06:36:20 -0400
Date: Tue, 24 Apr 2018 12:36:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
Message-ID: <20180424103609.GD4064@hirez.programming.kicks-ass.net>
References: <cover.1524499368.git.gustavo@embeddedor.com>
 <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
 <20180423152455.363d285c@vento.lan>
 <20180424093500.xvpcm3ibcu7adke2@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424093500.xvpcm3ibcu7adke2@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 24, 2018 at 12:35:00PM +0300, Dan Carpenter wrote:
> On Mon, Apr 23, 2018 at 03:24:55PM -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 23 Apr 2018 12:38:03 -0500
> > "Gustavo A. R. Silva" <gustavo@embeddedor.com> escreveu:

> > > @@ -875,6 +876,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
> > >  	if (f->index >= ARRAY_SIZE(format))
> > >  		return -EINVAL;
> > >  
> > > +	f->index = array_index_nospec(f->index, ARRAY_SIZE(format));
> >
> > Please enlighten me: how do you think this could be exploited?

TL;DR: read the papers [1] & [2]

I suspect you didn't get the gist of Spectre V1 [1], let me explain:

Suppose userspace provides f->index > ARRAY_SIZE(format), and we predict
the branch to -EINVAL to not be taken.

Then the CPU _WILL_ load (out of bounds) format[f->index] into
f->pixelformat and continue onwards to use this bogus value, all the way
until it figures out the branch was mis-predicted.

Once it figures out the mispredict, it will throw away the state and
start over at the condition site. So far, so basic.

The thing is, is will not (and cannot) throw away all state. Suppose our
speculation continues into v4l_fill_fmtdesc() and that switch there is
compiled as another array lookup, it will then feed our f->pixelformat
(which contains random kernel memory) into that array to find the
requested descr pointer.

Now, imagine userspace having flushed cache on the descr pointer array,
having trained the branch predictor to mis-predict the branch (see
branchscope paper [2]) and doing that out-of-bounds ioctl().

It can then speculative do the out-of-bounds array access, followed by
the desc array load, then figure out it was wrong and redo.

Then usespace probes which part of the descr[] array is now in cache and
from that it can infer the initial out-of-bound value.

So while format[] is static and bound, it can read random kernel memory
up to format+4g, including your crypto keys.

As far as V1 goes, this is actually a fairly solid exploit candidate. No
false positive about it.

Now kernel policy is to kill any and all speculation on user controlled
array indexing such that we don't have to go look for subsequent side
channels (the above cache side channel is the one described in the
Spectre paper and by far the easiest, but there are other possible side
channels) and we simply don't want to worry about it.

So even from that pov, the proposed patch is good.


[1] https://spectreattack.com/spectre.pdf
[2] www.cs.ucr.edu/~nael/pubs/asplos18.pdf
