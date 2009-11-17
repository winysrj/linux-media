Return-path: <linux-media-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:51191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbZKQQNp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 11:13:45 -0500
Message-ID: <4B02CB53.9020708@kernel.org>
Date: Wed, 18 Nov 2009 01:12:03 +0900
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andy Walls <awalls@radix.net>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
	akpm@linux-foundation.org, jens.axboe@oracle.com,
	rusty@rustcorp.com.au, cl@linux-foundation.org,
	dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
	peterz@infradead.org, andi@firstfloor.org, fweisbec@gmail.com
Subject: Re: [PATCH 17/21] workqueue: simple reimplementation of SINGLE_THREAD
 workqueue
References: <1258391726-30264-1-git-send-email-tj@kernel.org>  <1258391726-30264-18-git-send-email-tj@kernel.org> <1258418872.4096.28.camel@palomino.walls.org> <4B023340.90004@kernel.org> <alpine.LFD.2.01.0911170701480.9384@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911170701480.9384@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Linus.

11/18/2009 12:05 AM, Linus Torvalds wrote:
>> Do you think that usage is wide-spread?  Implementing strict ordering
>> shouldn't be too difficult but I can't help but feeling that such
>> assumption is abuse of implementation detail.
> 
> I think it would be good if it were more than an implementation detail, 
> and was something documented and known.
> 
> The less random and timing-dependent our interfaces are, the better off we 
> are. Guaranteeing that a single-threaded workqueue is done in order seems 
> to me to be a GoodThing(tm), regardless of whether much code depends on 
> it.
> 
> Of course, if there is some fundamental reason why it wouldn't be the 
> case, that's another thing. But if you think uit should be easy, and since 
> there _are_ users, then it shouldn't be seen as an "implementation 
> detail". It's a feature.

I might have been too early with the 'easy' part but I definitely can
give it a shot.  What do you think about the scheduler notifier
implementation?  It seems we'll end up with three callbacks.  It can
either be three hlist_heads in the struct_task linking each ops or
single hilst_head links ops tables (like the current preempt
notifiers).  Which one should I go with?

Thanks.

-- 
tejun
