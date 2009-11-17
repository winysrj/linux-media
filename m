Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42014 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbZKQMH2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 07:07:28 -0500
Subject: Re: [PATCH 17/21] workqueue: simple reimplementation of
 SINGLE_THREAD workqueue
From: Andy Walls <awalls@radix.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
	jens.axboe@oracle.com, rusty@rustcorp.com.au,
	cl@linux-foundation.org, dhowells@redhat.com,
	arjan@linux.intel.com, torvalds@linux-foundation.org,
	avi@redhat.com, peterz@infradead.org, andi@firstfloor.org,
	fweisbec@gmail.com
In-Reply-To: <4B023340.90004@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
	 <1258391726-30264-18-git-send-email-tj@kernel.org>
	 <1258418872.4096.28.camel@palomino.walls.org>  <4B023340.90004@kernel.org>
Content-Type: text/plain
Date: Tue, 17 Nov 2009 07:05:25 -0500
Message-Id: <1258459525.3214.17.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-11-17 at 14:23 +0900, Tejun Heo wrote:
> Hello,
> 
> 11/17/2009 09:47 AM, Andy Walls wrote:
> > An important property of the single threaded workqueue, upon which the
> > cx18 driver relies, is that work objects will be processed strictly in
> > the order in which they were queued.  The cx18 driver has a pool of
> > "work orders" and multiple active work orders can be queued up on the
> > workqueue especially if multiple streams are active.  If these work
> > orders were to be processed out of order, video artifacts would result
> > in video display applications.
> 
> That's an interesting use of single thread workqueue.  Most of single
> thread workqueues seem to be made single thread just to save number of
> threads.  Some seem to depend on single thread of execution but I
> never knew there are ones which depend on the exact execution order.
> Do you think that usage is wide-spread?

I doubt it.

Most that I have seen use the singlethreaded workqueue object with a
queue depth of essentially 1 for syncronization - as you have noted.


>   Implementing strict ordering
> shouldn't be too difficult but I can't help but feeling that such
> assumption is abuse of implementation detail.

Hmmm, does not the "queue" in workqueue mean "FIFO"?

If not for strict ordering, why else would a driver absolutely need a
singlethreaded workqueue object?  It seems to me the strict ording is
the driving requirement for a singlethreaded workqueue at all.  Your
patch series indicates to me that the performance and synchronization
use cases are not driving requirements for a singlethreaded workqueue.

Thanks for your consideration.

Regards,
Andy

> Thanks.


