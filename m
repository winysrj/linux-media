Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab2J2L61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 07:58:27 -0400
Date: Mon, 29 Oct 2012 09:58:17 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] saa7134: Add pm_qos_request to fix video corruption
Message-ID: <20121029095817.0bad37b3@infradead.org>
In-Reply-To: <3124636.sEoNQbeq5Q@f17simon>
References: <1350906611-17498-1-git-send-email-simon.farnsworth@onelan.co.uk>
	<3124636.sEoNQbeq5Q@f17simon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Oct 2012 11:25:38 +0000
Simon Farnsworth <simon.farnsworth@onelan.co.uk> escreveu:

> On Monday 22 October 2012 12:50:11 Simon Farnsworth wrote:
> > The SAA7134 appears to have trouble buffering more than one line of video
> > when doing DMA. Rather than try to fix the driver to cope (as has been done
> > by Andy Walls for the cx18 driver), put in a pm_qos_request to limit deep
> > sleep exit latencies.
> > 
> > The visible effect of not having this is that seemingly random lines are
> > only partly transferred - if you feed in a static image, you see a portion
> > of the image "flicker" into place.
> > 
> > Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> 
> Hello Mauro,
> 
> I've just noticed that I forgot to CC you in on this patch I sent last week - 
> Patchwork grabbed it at https://patchwork.kernel.org/patch/1625311/ but if you 
> want me to resend it so that you've got it in a mailbox for consideration, 
> just let me know.

I prefer if you don't c/c me on that ;) Patchwork is the main source that I use
on my patch reviews.

Btw, I saw your patch yesterday (and skipped it, for now), as I never played
with those pm QoS stuff before, nor I ever noticed anything like what you
reported on saa7134 (but I can't even remember the last time I tested something
on a saa7134 board ;) - so, it can be some new bug).

So, I'll postpone its review to when I have some time to actually test it
especially as the same issue might also be happening on other drivers.

Cheers,
Mauro
