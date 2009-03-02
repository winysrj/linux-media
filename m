Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:57303 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbZCBVM1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 16:12:27 -0500
Date: Mon, 2 Mar 2009 13:12:24 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: General protection fault on rmmod cx8800
In-Reply-To: <20090302200513.7fc3568e@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0903021241380.24268@shell2.speakeasy.net>
References: <20090215214108.34f31c39@hyperion.delvare>
 <20090302133936.00899692@hyperion.delvare> <1236003365.3071.6.camel@palomino.walls.org>
 <20090302170349.18c8fd75@hyperion.delvare> <20090302200513.7fc3568e@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Mar 2009, Jean Delvare wrote:
> On Mon, 2 Mar 2009 17:03:49 +0100, Jean Delvare wrote:
> > As far as I can see the key difference between bttv-input and
> > cx88-input is that bttv-input only uses a simple self-rearming timer,
> > while cx88-input uses a timer and a separate workqueue. The timer runs
> > the workqueue, which rearms the timer, etc. When you flush the timer,
> > the separate workqueue can be still active. I presume this is what
> > happens on my system. I guess the reason for the separate workqueue is
> > that the processing may take some time and we don't want to hurt the
> > system's performance?
> >
> > So we need to flush both the event workqueue (with
> > flush_scheduled_work) and the separate workqueue (with
> > flush_workqueue), at the same time, otherwise the active one may rearm

What are the two work queues are you talking about?  I don't see any actual
work queues created.  Just one work function that is scheduled on the
system work queue.  The timer is a softirq and doesn't run on a work queue.

> Switching to delayed_work seems to do the trick (note this is a 2.6.28
> patch):

Makes the most sense to me.  I was just about to make a patch to do the
same thing when I got your email.  Though I was going to patch the v4l-dvb
sources to avoid porting work.
