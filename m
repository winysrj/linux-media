Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42638 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752557AbcK3Me7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 07:34:59 -0500
Date: Wed, 30 Nov 2016 15:33:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Sakari Alius <sakari.ailus@iki.fi>, wharms@bfs.de,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] uvcvideo: freeing an error pointer
Message-ID: <20161130123326.GH28558@mwanda>
References: <20161125102835.GA5856@mwanda>
 <20161128134358.GS6266@mwanda>
 <alpine.DEB.2.10.1611281453100.2967@hadrien>
 <13737175.iVr8OcoHqv@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13737175.iVr8OcoHqv@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 28, 2016 at 04:49:36PM +0200, Laurent Pinchart wrote:
> Hi Julia and Dan,
> 
> On Monday 28 Nov 2016 14:54:58 Julia Lawall wrote:
> > On Mon, 28 Nov 2016, Dan Carpenter wrote:
> > > I understand the comparison, but I just think it's better if people
> > > always keep track of what has been allocated and what has not.  I tried
> > > so hard to get Markus to stop sending those hundreds of patches where
> > > he's like "this function has a sanity check so we can pass pointers
> > > that weren't allocated"...  It's garbage code.
> > > 
> > > But I understand that other people don't agree.
> > 
> > In my opinion, it is good for code understanding to only do what is useful
> > to do.  It's not a hard and fast rule, but I think it is something to take
> > into account.
> 
> On the other hand it complicates the error handling code by increasing the 
> number of goto labels, and it then becomes pretty easy when reworking code to 
> goto the wrong label. This is even more of an issue when the rework doesn't 
> touch the error handling code, in which case the reviewers can easily miss the 
> issue if they don't open the original source file to check the goto labels.
> 

It's really not.  I've looked at a lot of error handling in the past
five years and sent hundreds of fixes for error paths, more than any
other kernel developer during that time.  Although it seems obvious in
retrospect, it took me years to realize this but the canonical way of
doing error handling is the least error prone.

Counting the labels is the wrong way to measure complexity.  That's like
counting the number of functions.  Code with lots of functions is not
necessarily more complicated than if it's just one big function.

Part of the key to unwinding correctly is using good label names.  It
should say what the label does.  Some people use come-from labels names
like "goto kmalloc_failed".  Those are totally useless.  It's like
naming your functions "called_from_foo()".  If there is only one goto
then come-from label names are useless and if there are more than one
goto which go to the same label then it's useless *and* misleading.

Functions should be written so you can read them from top to bottom
without scrolling back and forth.

	a = alloc();
	if (!a)
		return -ENOMEM;

	b = alloc();
	if (!b) {
		ret = -ENOMEM;
		goto free_a;
	}

That code tells a complete story without any scrolling.  It's future
proof too.  You can tell the goto is correct just from the name.  But
when it's:

	a = alloc();
	if (!a)
		goto out;
	b = alloc();
		goto out;

That code doesn't have enough information to be understandable on it's
own.  It's way more bug prone than the first sample.

regards,
dan carpenter
