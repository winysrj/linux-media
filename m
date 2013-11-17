Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:35870 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3KQMD3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 07:03:29 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWE00H62PHRLU40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 17 Nov 2013 07:03:27 -0500 (EST)
Date: Sun, 17 Nov 2013 10:03:21 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: staging: media: Use dev_err() instead of pr_err()
Message-id: <20131117100321.18ed7be8@samsung.com>
In-reply-to: <20131115062939.GC28137@kroah.com>
References: <20131114110814.6b13f62b@samsung.com>
 <20131115062939.GC28137@kroah.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 15 Nov 2013 15:29:39 +0900
Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:

> On Thu, Nov 14, 2013 at 11:08:14AM -0200, Mauro Carvalho Chehab wrote:
> > Hi,
> > 
> > I'm not sure how this patch got applied upstream:
> > 
> > 	commit b6ea5ef80aa7fd6f4b18ff2e4174930e8772e812
> > 	Author: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
> > 	Date:   Sun Oct 20 22:58:28 2013 +0530
> > 	
> > 	    staging:media: Use dev_dbg() instead of pr_debug()
> > 	    
> > 	    Use dev_dbg() instead of pr_debug() in go7007-usb.c.
> >     
> > 	    Signed-off-by: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
> > 	    Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > 	    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > But, from the custody chain, it seems it was not C/C to linux-media ML,
> > doesn't have the driver maintainer's ack[1] and didn't went via my tree.
> 
> It came in through my tree as part of the OPW intern application
> process.

Ah, OK.

I don't mind if you apply those directly, but what makes me a little
worried is that at least the final version of the patchset should be
c/c to driver/subsystem maintainers for their review and for them to 
know that the patch will be merged via some other tree, as it might
be causing conflicts with their trees.

> And yes, sorry, it's broken, I have some follow-on patches to fix this,
> but you are right, it should just be reverted for now, very sorry about
> that.

No problem.

> Do you want to do that, or should I?

I prefer if you could do it, as I'm still waiting the merge from my tree,
and I don't want to cascade another pull request before the original
pull requests get handled. In any case, they won't conflict with this,
as I don't have any patch for this driver on my tree for 3.13.

Thanks!
Mauro
