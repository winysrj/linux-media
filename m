Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37238 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S934922AbeAHQZd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 11:25:33 -0500
Date: Mon, 8 Jan 2018 11:25:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
cc: Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>
Subject: Re: dvb usb issues since kernel 4.9
In-Reply-To: <20180108105331.758fc2f4@vento.lan>
Message-ID: <Pine.LNX.4.44L0.1801081054360.1908-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Jan 2018, Mauro Carvalho Chehab wrote:

> > Let find the root-cause of this before reverting, as this will hurt the
> > networking use-case.
> > 
> > I want to see if the increase buffer will solve the issue (the current
> > buffer of 0.63 ms seem too small).
> 
> For TV, high latency has mainly two practical consequences:
> 
> 1) it increases the time to switch channels. MPEG-TS based transmissions
>    usually takes some time to start showing the channel contents. Adding
>    more buffers make it worse;
> 
> 2) specially when watching sports, a higher latency means that you'll know
>    that your favorite team made a score when your neighbors start
>    celebrating... seeing the actual event only after them.
> 
> So, the lower, the merrier, but I think that 5 ms would be acceptable.

That value 65 for the number of buffers was calculated based on a
misunderstanding of the actual bandwidth requirement.  Still increasing
the number of buffers shouldn't hurt, and it's worth trying.

But there is another misunderstanding here which needs to be cleared 
up.  Adding more buffers does _not_ increase latency; it increases 
capacity.  Making each buffer larger _would_ increase latency, but 
that's not what I proposed.

Going through this more explicitly...  Suppose you receive 8 KB of data
every ms, and suppose you have four 8-KB buffers.  Then the latency is
1 ms, because that's how long you have to wait for the first buffer to
be filled up after you submit an I/O request.  (The driver does _not_
need to wait for all four buffers to be filled before it can start
displaying the data in the first buffer.)  The capacity would be 4 ms,
because that's how much data your buffers can store.  If you end up
waiting longer than 4 ms before ksoftirqd gets around to processing any
of the data, then some data will inevitably get lost.

That's why the way to deal with the delays caused by deferring softirqs
to ksoftirqd is to add more buffers (and not make the buffers larger
than they already are).

> > I would also like to see experiments with adjusting adjust the sched
> > priority of the kthread's and/or the userspace prog. (e.g use command
> > like 'sudo chrt --fifo -p 10 $(pgrep udp_sink)' ).
> 
> If this fixes the issue, we'll need to do something inside the Kernel
> to change the priority, as TV userspace apps should not run as root. Not
> sure where such change should be done (USB? media?).

It would be interesting to try this, but I agree that it's not likely 
to be a practical solution.  Anyway, shouldn't ksoftirqd already be 
running with very high priority?

> > Are we really sure that the regression is cause by 4cd13c21b207
> > ("softirq: Let ksoftirqd do its job"), the forum thread also report
> > that the problem is almost gone after commit 34f41c0316ed ("timers: Fix
> > overflow in get_next_timer_interrupt")
> >  https://git.kernel.org/torvalds/c/34f41c0316ed

That is a good point.  It's hard to see how the issues in the two 
commits could be related, but who knows?

> I'll see if I can mount a test scenario here in order to try reproduce
> the reported bug. I suspect that I won't be able to reproduce it on my
> "standard" i7core-based test machine, even with KPTI enabled.

If you're using the same sort of hardware as Josef, under similar 
circumstances, the buggy bahavior should be the same.  If not, there 
must be something else going on that we're not aware of.

> > It makes me suspicious that this fix changes things...
> > After this fix, I suspect that changing the sched priorities, will fix
> > the remaining glitches.
> > 
> > 
> > > It is hard to foresee the consequences of the softirq changes for other
> > > devices, though.  
> > 
> > Yes, it is hard to foresee, I can only cover networking.
> > 
> > For networking, if reverting this, we will (again) open the kernel for
> > an easy DDoS vector with UDP packets.  As mentioned in the commit desc,
> > before you could easily cause softirq to take all the CPU time from the
> > application, resulting in very low "good-put" in the UDP-app. (That's why
> > it was so easy to DDoS DNS servers before...)
> > 
> > With the softirqd patch in place, ksoftirqd is scheduled fairly between
> > other applications running on the same CPU.  But in some cases this is
> > not what you want, so as the also commit mentions, the admin can now
> > more easily tune process scheduling parameters if needed, to adjust for
> > such use-cases (it was not really an admin choice before).
> 
> Can't the ksoftirq patch be modified to only apply to the networking
> IRQ handling? That sounds less risky of affecting unrelated subsystems[1].

That might work.  Or more generally, allow drivers to specify which 
softirq sources should be deferred to ksoftirqd and which should not.

Alan Stern

> [1] Actually, DVB drivers can also implement networking for satellite
> based Internet, but, in this case, the top half is implemented inside
> the DVB core, as the IP traffic should be filtered out of an MPEG-TS
> stream. Not sure if the UDP DDoS attack you're mentioning would affect
> DVB net, but I guess not. AFAIKT, there aren't many users using DVB net
> nowadays. I don't have any easy way to test DVB net here.
> 
> Thanks,
> Mauro
