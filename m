Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37247 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab2JLQ1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 12:27:08 -0400
Date: Fri, 12 Oct 2012 17:32:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20121012173205.49844867@pyramind.ukuu.org.uk>
In-Reply-To: <CAPM=9txkSXAOu5Q_H3LWuMrJ+Q_paLPrORtRuHNg6qvsukNdyw@mail.gmail.com>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
	<CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
	<201210110857.15660.hverkuil@xs4all.nl>
	<20121011123407.63b5ecbe@pyramind.ukuu.org.uk>
	<CAPM=9txkSXAOu5Q_H3LWuMrJ+Q_paLPrORtRuHNg6qvsukNdyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > Then they can accept the risk of ignoring EXPORT_SYMBOL_GPL and
> > calling into it anyway can't they. Your argument makes no rational sense
> > of any kind.
> 
> But then why object to the change, your objection makes sense, naking
> the patch makes none, if you believe in your objection.

[l/k added as I imagine a few other peopel will want to see this who
 don't read driver specific lists, Greg especially I guess]

'estoppel' and because my legal advice is specifically to do so. If you
don't understand why it matters then please get qualified legal advice.

I'm also objecting to the failure to follow proper process. If this does
make a difference as Nvidia seem to think then it is a clear requirement
that you gain permission from every rightsholder affected, as with any
other licensing change.

So I would suggest Nvidia start by going through the call tree and all
potential rightsholders and negotiating with all their corporate
attorneys to get each of them to provide a Signed-off-by: line for that
change and perhaps charge them for a license in the process.

Now as it happens lots of other people have objected to this last time it
was posted, and this time, so maybe they should just recognize the clear
will of the rightsholders concerned and give up on it.

It's very clear how most rights holders involved see the Nvidia
situation. What was it Linus said..

http://www.youtube.com/watch?v=IVpOyKCNZYw

so right from the top the opinion seems to be fairly clear.

> Also really its just bullshit handwaving all of it, your objection,
> _GPL etc. until someone grows a pair and sues someone, instead of
> hiding behind their employment status. If you really believed you were
> right, you could retire on the settlement payout.

Unlikely as most of the code I've written belongs to Intel or Red Hat. I
also have better things to do with life than sue Nvidia and start an all
out copyright and patent war in Linuxspace.

It's simple enough

If Nvidia think their code is not derivative then why do they care about
the _GPL being significant ?

Nouveau can call the DMA buf methods.

Alan
