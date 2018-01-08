Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33504 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757439AbeAHMxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 07:53:44 -0500
Date: Mon, 8 Jan 2018 10:53:31 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
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
Message-ID: <20180108105331.758fc2f4@vento.lan>
In-Reply-To: <20180108125910.4fa6c4ff@redhat.com>
References: <trinity-35b3a044-b548-4a31-9646-ed9bc83e6846-1513505978471@3c-app-gmx-bs03>
        <20171217120634.pmmuhdqyqmbkxrvl@gofer.mess.org>
        <20171217112738.4f3a4f9b@recife.lan>
        <trinity-1fa14556-8596-44b1-95cb-b8919d94d2d4-1515251056328@3c-app-gmx-bs15>
        <20180106175420.275e24e7@recife.lan>
        <CA+55aFzHPYuxg3LwhqcxwJD2fuKzg6wU5ypfMvrpRoioiQHDFg@mail.gmail.com>
        <20180108080200.77d374c2@vento.lan>
        <20180108125910.4fa6c4ff@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 8 Jan 2018 12:59:10 +0100
Jesper Dangaard Brouer <jbrouer@redhat.com> escreveu:

> On Mon, 8 Jan 2018 08:02:00 -0200
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > Hi Linus,
> > 
> > Em Sun, 7 Jan 2018 13:23:39 -0800
> > Linus Torvalds <torvalds@linux-foundation.org> escreveu:
> >   
> > > On Sat, Jan 6, 2018 at 11:54 AM, Mauro Carvalho Chehab
> > > <mchehab@s-opensource.com> wrote:    
> > > >
> > > > Em Sat, 6 Jan 2018 16:04:16 +0100
> > > > "Josef Griebichler" <griebichler.josef@gmx.at> escreveu:      
> > > >>
> > > >> the causing commit has been identified.
> > > >> After reverting commit https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4cd13c21b207e80ddb1144c576500098f2d5f882
> > > >> its working again.      
> > > >
> > > > Just replying to me won't magically fix this. The ones that were involved on
> > > > this patch should also be c/c, plus USB people. Just added them.      
> > > 
> > > Actually, you seem to have added an odd subset of the people involved.
> > > 
> > > For example, Ingo - who actually committed that patch - wasn't on the cc.    
> > 
> > Sorry, my fault. I forgot to add him to it.
> >   
> > > I do think we need to simply revert that patch. It's very simple: it
> > > has been reported to lead to actual problems for people, and we don't
> > > fix one problem and then say "well, it fixed something else" when
> > > something breaks.
> > > 
> > > When something breaks, we either unbreak it, or we revert the change
> > > that caused the breakage.
> > > 
> > > It's really that simple. That's what "no regressions" means.  We don't
> > > accept changes that cause regressions. This one did.    
> > 
> > Yeah, we should either unbreak or revert it. In the specific case of
> > media devices, Alan came with a proposal of increasing the number of
> > buffers. This is an one line change, and increase a capture delay from
> > 0.63 ms to 5 ms on this specific case (Digital TV) shouldn't make much
> > harm. So, I guess it would worth trying it before reverting the patch.  
> 
> Let find the root-cause of this before reverting, as this will hurt the
> networking use-case.
> 
> I want to see if the increase buffer will solve the issue (the current
> buffer of 0.63 ms seem too small).

For TV, high latency has mainly two practical consequences:

1) it increases the time to switch channels. MPEG-TS based transmissions
   usually takes some time to start showing the channel contents. Adding
   more buffers make it worse;

2) specially when watching sports, a higher latency means that you'll know
   that your favorite team made a score when your neighbors start
   celebrating... seeing the actual event only after them.

So, the lower, the merrier, but I think that 5 ms would be acceptable.
 
> I would also like to see experiments with adjusting adjust the sched
> priority of the kthread's and/or the userspace prog. (e.g use command
> like 'sudo chrt --fifo -p 10 $(pgrep udp_sink)' ).

If this fixes the issue, we'll need to do something inside the Kernel
to change the priority, as TV userspace apps should not run as root. Not
sure where such change should be done (USB? media?).

> Are we really sure that the regression is cause by 4cd13c21b207
> ("softirq: Let ksoftirqd do its job"), the forum thread also report
> that the problem is almost gone after commit 34f41c0316ed ("timers: Fix
> overflow in get_next_timer_interrupt")
>  https://git.kernel.org/torvalds/c/34f41c0316ed

I'll see if I can mount a test scenario here in order to try reproduce
the reported bug. I suspect that I won't be able to reproduce it on my
"standard" i7core-based test machine, even with KPTI enabled.

> It makes me suspicious that this fix changes things...
> After this fix, I suspect that changing the sched priorities, will fix
> the remaining glitches.
> 
> 
> > It is hard to foresee the consequences of the softirq changes for other
> > devices, though.  
> 
> Yes, it is hard to foresee, I can only cover networking.
> 
> For networking, if reverting this, we will (again) open the kernel for
> an easy DDoS vector with UDP packets.  As mentioned in the commit desc,
> before you could easily cause softirq to take all the CPU time from the
> application, resulting in very low "good-put" in the UDP-app. (That's why
> it was so easy to DDoS DNS servers before...)
> 
> With the softirqd patch in place, ksoftirqd is scheduled fairly between
> other applications running on the same CPU.  But in some cases this is
> not what you want, so as the also commit mentions, the admin can now
> more easily tune process scheduling parameters if needed, to adjust for
> such use-cases (it was not really an admin choice before).

Can't the ksoftirq patch be modified to only apply to the networking
IRQ handling? That sounds less risky of affecting unrelated subsystems[1].

[1] Actually, DVB drivers can also implement networking for satellite
based Internet, but, in this case, the top half is implemented inside
the DVB core, as the IP traffic should be filtered out of an MPEG-TS
stream. Not sure if the UDP DDoS attack you're mentioning would affect
DVB net, but I guess not. AFAIKT, there aren't many users using DVB net
nowadays. I don't have any easy way to test DVB net here.

Thanks,
Mauro
