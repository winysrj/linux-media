Return-path: <linux-media-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:55043 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbZKQFXM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 00:23:12 -0500
Message-ID: <4B023340.90004@kernel.org>
Date: Tue, 17 Nov 2009 14:23:12 +0900
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
	jens.axboe@oracle.com, rusty@rustcorp.com.au,
	cl@linux-foundation.org, dhowells@redhat.com,
	arjan@linux.intel.com, torvalds@linux-foundation.org,
	avi@redhat.com, peterz@infradead.org, andi@firstfloor.org,
	fweisbec@gmail.com
Subject: Re: [PATCH 17/21] workqueue: simple reimplementation of SINGLE_THREAD
 workqueue
References: <1258391726-30264-1-git-send-email-tj@kernel.org>	 <1258391726-30264-18-git-send-email-tj@kernel.org> <1258418872.4096.28.camel@palomino.walls.org>
In-Reply-To: <1258418872.4096.28.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

11/17/2009 09:47 AM, Andy Walls wrote:
> An important property of the single threaded workqueue, upon which the
> cx18 driver relies, is that work objects will be processed strictly in
> the order in which they were queued.  The cx18 driver has a pool of
> "work orders" and multiple active work orders can be queued up on the
> workqueue especially if multiple streams are active.  If these work
> orders were to be processed out of order, video artifacts would result
> in video display applications.

That's an interesting use of single thread workqueue.  Most of single
thread workqueues seem to be made single thread just to save number of
threads.  Some seem to depend on single thread of execution but I
never knew there are ones which depend on the exact execution order.
Do you think that usage is wide-spread?  Implementing strict ordering
shouldn't be too difficult but I can't help but feeling that such
assumption is abuse of implementation detail.

Thanks.

-- 
tejun
