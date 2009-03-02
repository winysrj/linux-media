Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:6721 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbZCBVws (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 16:52:48 -0500
Date: Mon, 2 Mar 2009 22:52:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: General protection fault on rmmod cx8800
Message-ID: <20090302225235.5d6d47ce@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0903021241380.24268@shell2.speakeasy.net>
References: <20090215214108.34f31c39@hyperion.delvare>
	<20090302133936.00899692@hyperion.delvare>
	<1236003365.3071.6.camel@palomino.walls.org>
	<20090302170349.18c8fd75@hyperion.delvare>
	<20090302200513.7fc3568e@hyperion.delvare>
	<Pine.LNX.4.58.0903021241380.24268@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trent,

On Mon, 2 Mar 2009 13:12:24 -0800 (PST), Trent Piepho wrote:
> On Mon, 2 Mar 2009, Jean Delvare wrote:
> > On Mon, 2 Mar 2009 17:03:49 +0100, Jean Delvare wrote:
> > > As far as I can see the key difference between bttv-input and
> > > cx88-input is that bttv-input only uses a simple self-rearming timer,
> > > while cx88-input uses a timer and a separate workqueue. The timer runs
> > > the workqueue, which rearms the timer, etc. When you flush the timer,
> > > the separate workqueue can be still active. I presume this is what
> > > happens on my system. I guess the reason for the separate workqueue is
> > > that the processing may take some time and we don't want to hurt the
> > > system's performance?
> > >
> > > So we need to flush both the event workqueue (with
> > > flush_scheduled_work) and the separate workqueue (with
> > > flush_workqueue), at the same time, otherwise the active one may rearm
> 
> What are the two work queues are you talking about?  I don't see any actual
> work queues created.  Just one work function that is scheduled on the
> system work queue.  The timer is a softirq and doesn't run on a work queue.

Sorry, I misread the code. There's only one work queue involved (the
system one). Reading the timer code again now, I admit I am curious how
I managed to misread it to that degree...

The key point remains though: we'd need to delete the timer and flush
the system workqueue at the exact same time, which is not possible, or
to add some sort of signaling between the work and the timer. Or use
delayed_work.

> > Switching to delayed_work seems to do the trick (note this is a 2.6.28
> > patch):
> 
> Makes the most sense to me.  I was just about to make a patch to do the
> same thing when I got your email.  Though I was going to patch the v4l-dvb
> sources to avoid porting work.

It was easier for me to test on an upstream kernel. The porting should
be fairly easy, I can take care of it. The difficult part will be to
handle the compatibility with kernels < 2.6.20 because delayed_work was
introduced in 2.6.20. Probably "compatibility" here will simply mean
that the bug I've hit will only be fixed for kernels >= 2.6.20. Which
once again raises the question of whether we really want to keep
supporting these old kernels.

-- 
Jean Delvare
