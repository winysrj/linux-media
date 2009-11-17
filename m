Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbZKQPIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 10:08:48 -0500
Date: Tue, 17 Nov 2009 07:05:18 -0800 (PST)
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
In-Reply-To: <4B023340.90004@kernel.org>
Message-ID: <alpine.LFD.2.01.0911170701480.9384@localhost.localdomain>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>  <1258391726-30264-18-git-send-email-tj@kernel.org> <1258418872.4096.28.camel@palomino.walls.org> <4B023340.90004@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 17 Nov 2009, Tejun Heo wrote:
>
> Do you think that usage is wide-spread?  Implementing strict ordering
> shouldn't be too difficult but I can't help but feeling that such
> assumption is abuse of implementation detail.

I think it would be good if it were more than an implementation detail, 
and was something documented and known.

The less random and timing-dependent our interfaces are, the better off we 
are. Guaranteeing that a single-threaded workqueue is done in order seems 
to me to be a GoodThing(tm), regardless of whether much code depends on 
it.

Of course, if there is some fundamental reason why it wouldn't be the 
case, that's another thing. But if you think uit should be easy, and since 
there _are_ users, then it shouldn't be seen as an "implementation 
detail". It's a feature.

			Linus
