Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:6047 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbZCCMQo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 07:16:44 -0500
Date: Tue, 3 Mar 2009 13:16:33 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: General protection fault on rmmod cx8800
Message-ID: <20090303131633.52dbb472@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0903030107110.24268@shell2.speakeasy.net>
References: <20090215214108.34f31c39@hyperion.delvare>
	<20090302133936.00899692@hyperion.delvare>
	<1236003365.3071.6.camel@palomino.walls.org>
	<20090302170349.18c8fd75@hyperion.delvare>
	<20090302200513.7fc3568e@hyperion.delvare>
	<Pine.LNX.4.58.0903021241380.24268@shell2.speakeasy.net>
	<20090302225235.5d6d47ce@hyperion.delvare>
	<Pine.LNX.4.58.0903030107110.24268@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Mar 2009 01:40:00 -0800 (PST), Trent Piepho wrote:
> On Mon, 2 Mar 2009, Jean Delvare wrote:
> > > Makes the most sense to me.  I was just about to make a patch to do the
> > > same thing when I got your email.  Though I was going to patch the v4l-dvb
> > > sources to avoid porting work.
> >
> > It was easier for me to test on an upstream kernel. The porting should
> > be fairly easy, I can take care of it. The difficult part will be to
> > handle the compatibility with kernels < 2.6.20 because delayed_work was
> > introduced in 2.6.20. Probably "compatibility" here will simply mean
> > that the bug I've hit will only be fixed for kernels >= 2.6.20. Which
> > once again raises the question of whether we really want to keep
> > supporting these old kernels.
> 
> cancel_delayed_work_sync() was renamed from cancel_rearming_delayed_work()
> in 2.6.23.  A compat.h patch can handle that one.
> 
> In 2.6.22, cancel_delayed_work_sync(work) was created from
> cancel_rearming_delayed_workqueue(wq, work).  The kernel has a compat
> function to turn cancel_rearming_delayed_workqueue() into the
> cancel_delayed_work_sync() call.  cancel_rearming_delayed_workqueue() has
> been around since 2.6.13.  Apparently it was un-exported for a while
> because it had no users, see commit v2.6.12-rc2-8-g81ddef7.  Isn't it nice
> that there a commit message other than "export
> cancel_rearming_delayed_workqueue"?  Let me again express my dislike for
> commit with no description.
> 
> In 2.6.20 delayed_work was split from work_struct.  The concept of delayed
> work was already there and schedule_delayed_work() hasn't changed.  I think
> this can also be handled with a compat.h change that defines delayed_work
> to work_struct.  That will only be a problem on pre 2.6.20 kernels if some
> code decides to define identifiers named work_struct and delayed_work in
> the same scope.  There are currently no identifier named delayed_work in
> any driver and one driver (sq905) has a structure member named
> work_struct.  So I think it'll be ok.

Wow, I didn't expect that many different compatibility issues. This
goes beyond the time I am ready to spend on it, I'm afraid.

-- 
Jean Delvare
