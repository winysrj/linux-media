Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37379 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbaIXNeu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 09:34:50 -0400
Date: Wed, 24 Sep 2014 10:34:45 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] qm1d1c0042: fix compilation on 32 bits
Message-ID: <20140924103445.31aeca91@recife.lan>
In-Reply-To: <5422B8CD.8050302@gmail.com>
References: <aee9cf18e96ed8384a04bd3eda69c7b9e888ee5b.1411522264.git.mchehab@osg.samsung.com>
	<5422B8CD.8050302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 24 Sep 2014 21:27:57 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> > -	b = (((s64) freq) << 20) / state->cfg.xtal_freq - (((s64) a) << 20);
> > +	b = (s32)div64_s64(((s64) freq) << 20,
> > +			   state->cfg.xtal_freq - (((s64) a) << 20));
> > +
> 
> I'm afraid it should be like the following.
> > +	b = (s32)(div64_s64(((s64) freq) << 20, state->cfg.xtal_freq)
> > +			- (((s64) a) << 20));

Are you talking about coding style?

Instead of using something like:

	var = foo_func(a, c 
		- b);

We generally use:
	var = foo_func(a,
		       c - b);

As it is quicker for reviewers to read.

> 
> regads,
> akihiro
> 
