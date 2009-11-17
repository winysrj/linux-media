Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbZKQTEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 14:04:15 -0500
Date: Tue, 17 Nov 2009 11:01:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
cc: Andy Walls <awalls@radix.net>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
	akpm@linux-foundation.org, jens.axboe@oracle.com,
	rusty@rustcorp.com.au, cl@linux-foundation.org,
	dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
	peterz@infradead.org, andi@firstfloor.org, fweisbec@gmail.com
Subject: Re: [PATCH 17/21] workqueue: simple reimplementation of SINGLE_THREAD
 workqueue
In-Reply-To: <4B02CB53.9020708@kernel.org>
Message-ID: <alpine.LFD.2.01.0911171056380.9384@localhost.localdomain>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>  <1258391726-30264-18-git-send-email-tj@kernel.org> <1258418872.4096.28.camel@palomino.walls.org> <4B023340.90004@kernel.org> <alpine.LFD.2.01.0911170701480.9384@localhost.localdomain>
 <4B02CB53.9020708@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 18 Nov 2009, Tejun Heo wrote:
> 
> I might have been too early with the 'easy' part but I definitely can
> give it a shot.  What do you think about the scheduler notifier
> implementation?  It seems we'll end up with three callbacks.  It can
> either be three hlist_heads in the struct_task linking each ops or
> single hilst_head links ops tables (like the current preempt
> notifiers).  Which one should I go with?

I have to say that I don't know. Will this eventually be something common? 
Is the cache footprint problem of 3 pointers that are usually empty worse 
than the cache problem of following a chain where you don't use half the 
entries? Who knows?

And when it actually _is_ used, is it going to be horrible to have a 
possibly upredictable indirect branch (and on some architectures, _all_ 
indirect branches are unpredictable) in a really hot path?

In general, "notifiers" are always horrible. If there's only one or two 
common cases, it's probably going to be better to hardcode those with 
flags to be tested instead of following function pointers. So I just don't 
know.

		Linus
