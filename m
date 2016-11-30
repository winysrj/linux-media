Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37009 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756882AbcK3Nwu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 08:52:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Sakari Alius <sakari.ailus@iki.fi>, wharms@bfs.de,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] uvcvideo: freeing an error pointer
Date: Wed, 30 Nov 2016 15:53:03 +0200
Message-ID: <3099994.m2oKJeJMud@avalon>
In-Reply-To: <20161130123326.GH28558@mwanda>
References: <20161125102835.GA5856@mwanda> <13737175.iVr8OcoHqv@avalon> <20161130123326.GH28558@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Wednesday 30 Nov 2016 15:33:26 Dan Carpenter wrote:
> On Mon, Nov 28, 2016 at 04:49:36PM +0200, Laurent Pinchart wrote:
> > On Monday 28 Nov 2016 14:54:58 Julia Lawall wrote:
> >> On Mon, 28 Nov 2016, Dan Carpenter wrote:
> >>> I understand the comparison, but I just think it's better if people
> >>> always keep track of what has been allocated and what has not.  I
> >>> tried so hard to get Markus to stop sending those hundreds of patches
> >>> where he's like "this function has a sanity check so we can pass
> >>> pointers that weren't allocated"...  It's garbage code.
> >>> 
> >>> But I understand that other people don't agree.
> >> 
> >> In my opinion, it is good for code understanding to only do what is
> >> useful to do.  It's not a hard and fast rule, but I think it is
> >> something to take into account.
> > 
> > On the other hand it complicates the error handling code by increasing the
> > number of goto labels, and it then becomes pretty easy when reworking code
> > to goto the wrong label. This is even more of an issue when the rework
> > doesn't touch the error handling code, in which case the reviewers can
> > easily miss the issue if they don't open the original source file to
> > check the goto labels.
>
> It's really not.  I've looked at a lot of error handling in the past
> five years and sent hundreds of fixes for error paths, more than any
> other kernel developer during that time.  Although it seems obvious in
> retrospect, it took me years to realize this but the canonical way of
> doing error handling is the least error prone.
> 
> Counting the labels is the wrong way to measure complexity.  That's like
> counting the number of functions.  Code with lots of functions is not
> necessarily more complicated than if it's just one big function.
> 
> Part of the key to unwinding correctly is using good label names.  It
> should say what the label does.  Some people use come-from labels names
> like "goto kmalloc_failed".  Those are totally useless.  It's like
> naming your functions "called_from_foo()".  If there is only one goto
> then come-from label names are useless and if there are more than one
> goto which go to the same label then it's useless *and* misleading.

Yes, label naming is (or at least should be) largely agreed upon, they should 
name the unwinding action, not the cause of the failure.

> Functions should be written so you can read them from top to bottom
> without scrolling back and forth.
> 
> 	a = alloc();
> 	if (!a)
> 		return -ENOMEM;
> 
> 	b = alloc();
> 	if (!b) {
> 		ret = -ENOMEM;
> 		goto free_a;
> 	}

But then you get the following patch (which, apart from being totally made up, 
probably shows what I've watched yesterday evening).

@@ ... @@
 		return -ENOMEM;
 	}
 
+	ret = check_time_vortex();
+	if (ret < 0)
+		goto power_off_tardis;
+
	matt_smith = alloc_regeneration();
	if (math_smith->status != OK) {
		ret = -E_NEEDS_FISH_FINGERS_AND_CUSTARD;

>From that code only you can't tell whether the jump label is the right one. If 
a single jump label is used with an unwinding code block that supports non-
allocated resources, you don't have to ask yourself any question.

> That code tells a complete story without any scrolling.  It's future
> proof too.  You can tell the goto is correct just from the name.  But
> when it's:
> 
> 	a = alloc();
> 	if (!a)
> 		goto out;
> 	b = alloc();
> 		goto out;
> 
> That code doesn't have enough information to be understandable on it's
> own.  It's way more bug prone than the first sample.

-- 
Regards,

Laurent Pinchart

