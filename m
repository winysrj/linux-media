Return-path: <linux-media-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:49271 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab2FSEi1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 00:38:27 -0400
Message-ID: <1340080702.24618.15.camel@obelisk.thedillows.org>
Subject: Re: [RFC] [media] cx231xx: restore tuner settings on first open
From: David Dillow <dave@thedillows.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Date: Tue, 19 Jun 2012 00:38:22 -0400
In-Reply-To: <CAGoCfix48wNUBRuUbehjSHpqV33D68AA7mBy_4zu22JWTkbcmQ@mail.gmail.com>
References: <1339994998.32360.61.camel@obelisk.thedillows.org>
	 <201206180929.48107.hverkuil@xs4all.nl>
	 <1340028940.32360.70.camel@obelisk.thedillows.org>
	 <CAGoCfize92S-8cR9f-RjQDcZARKiT84UtX-oH0EcPomCYFAyxQ@mail.gmail.com>
	 <1340029964.23706.4.camel@obelisk.thedillows.org>
	 <CAGoCfix48wNUBRuUbehjSHpqV33D68AA7mBy_4zu22JWTkbcmQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-06-18 at 10:36 -0400, Devin Heitmueller wrote:
> On Mon, Jun 18, 2012 at 10:32 AM, David Dillow <dave@thedillows.org> wrote:
> > Hmm, it sounds like perhaps changing the standby call in the tuner core
> > to asynchronously power down the tuner may be the way to go -- ie, when
> > we tell it to standby, it will do a schedule_work for some 10 seconds
> > later to really pull it down. If we get a resume call prior to then,
> > we'll just cancel the work, otherwise we wait for the work to finish and
> > then issue the resume.
> >
> > Does that sound reasonable?
> 
> At face value it sounds reasonable, except the approach breaks down as
> soon as you have hybrid tuners which support both analog and digital.
> Because the digital side of the tuner isn't tied into tuner-core,
> you'll break in the following situation:
> 
> Start using analog
> Stop using analog [schedule_work() call]
> Start using digital
> Timer pops and powers down the tuner even though it's in use for ATSC
> or ClearQAM
> 
> Again, I'm not proposing a solution, but just poking a fatal hole in
> your proposal (believe me, I had considered the same approach when
> first looking at the problem).

No worries, I just started looking at V4L stuff on Friday, so I expect
to make some mistakes...

It sounds like we want a solution that
      * lives in core code
      * doesn't require tuner drivers to save state
      * manages hybrid tuners appropriately
      * allows for gradual API change-over (no flag day for tuners or
        for capture devices)
      * has a reasonable grace period before putting tuner to standby

Aside from the entering standby issue, fixing the loss of mode/frequency
looks like it may be fixable by just having the capture cards explicitly
request the tuner become active -- the tuner core will already restore
those for us. It's just that few cards do that today.

Is it safe to say that the tuner core will know about all hybrid tuners,
even if it doesn't know if the digital side is still in use?

Can a single tuner be used for both digital and analog tuning at the
same time?

I'm wondering if just having a simple counter would work, with the
digital side calling for power just as the capture side should already
be doing. If the count is non-zero on a standby call, don't do anything.
If it goes to zero, then schedule the HW standby. The challenge would
seem to be getting the DVB system to call into the tuner-core (or other
proper place).

So much to learn... thank you for your patience,
Dave



