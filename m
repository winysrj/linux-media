Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:40476 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752191AbeAIRst (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 12:48:49 -0500
MIME-Version: 1.0
In-Reply-To: <CANn89iJqRH4uzFJVKyPxc8dN38z319C1O18nTJ-CCidtuOH2+g@mail.gmail.com>
References: <20180107090336.03826df2@vento.lan> <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
 <20180108074324.3c153189@vento.lan> <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
 <20180108223109.66c91554@redhat.com> <20180108214427.GT29822@worktop.programming.kicks-ass.net>
 <20180108231656.3bbd1968@redhat.com> <trinity-920967ce-ab0f-4535-8557-f82a7e667a79-1515516669310@3c-app-gmx-bs24>
 <CANn89iJqRH4uzFJVKyPxc8dN38z319C1O18nTJ-CCidtuOH2+g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Jan 2018 09:48:47 -0800
Message-ID: <CA+55aFzcoNEpnRp0R3fLYQKdfzS5mLj3z_v=1A1NfyrybQ__4A@mail.gmail.com>
Subject: Re: Re: dvb usb issues since kernel 4.9
To: Eric Dumazet <edumazet@google.com>
Cc: Josef Griebichler <griebichler.josef@gmx.at>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 9, 2018 at 9:27 AM, Eric Dumazet <edumazet@google.com> wrote:
>
> So yes, commit 4cd13c21b207 ("softirq: Let ksoftirqd do its job") has
> shown up multiple times in various 'regressions'
> simply because it could surface the problem more often.
> But even if you revert it, you can still make the faulty
> driver/subsystem misbehave by adding more stress to the cpu handling
> the IRQ.

..but that's always true. People sometimes live on the edge - often by
design (ie hardware has been designed/selected to be the crappiest
possible that still work).

That doesn't change anything. A patch that takes "bad things can
happen" to "bad things DO happen" is a bad patch.

> Maybe the answer is to tune the kernel for small latencies at the
> price of small throughput (situation before the patch)

Generally we always want to tune for latency. Throughput is "easy",
but almost never interesting.

Sure, people do batch jobs. And yes, people often _benchmark_
throughput, because it's easy to benchmark. It's much harder to
benchmark latency, even when it's often much more important.

A prime example is the SSD benchmarks in the last few years - they
improved _dramatically_ when people noticed that the real problem was
latency, not the idiotic maximum big-block bandwidth numbers that have
almost zero impact on most people.

Put another way: we already have a very strong implicit bias towards
bandwidth just because it's easier to see and measure.

That means that we generally should strive to have a explicit bias
towards optimizing for latency when that choice comes up.  Just to
balance things out (and just to not take the easy way out: bandwidth
can often be improved by adding more layers of buffering and bigger
buffers, and that often ends up really hurting latency).

> 1) Revert the patch

Well, we can revert it only partially - limiting it to just networking
for example.

Just saying "act the way you used to for tasklets" already seems to
have fixed the issue in DVB.

> 2) get rid of ksoftirqd since it adds unexpected latencies.

We can't get rid of it entirely, since the synchronous softirq code
can cause problems too. It's why we have that "maximum of ten
synchronous events" in __do_softirq().

And we don't *want* to get rid of it.

We've _always_ had that small-scale "at some point we can't do it
synchronously any more".

That is a small-scale "don't have horrible latency for _other_ things"
protection. So it's about latency too, it's just about protecting
latency of the rest of the system.

The problem with commit 4cd13c21b207 is that it turns the small-scale
latency issues in softirq handling (they get larger latencies for lots
of hardware interrupts or even from non-preemptible kernel code) into
the _huge_ scale latency of scheduling, and does so in a racy way too.

> 3) Let applications that expect to have high throughput make sure to
> pin their threads on cpus that are not processing IRQ.
>     (And make sure to not use irqbalance, and setup IRQ cpu affinities)

The only people that really deal in "thoughput only" tend to be the
HPC people, and they already do things like this.

(The other end of the spectrum is the realtime people that have
extreme latency requirements, who do things like that for the reverse
reason: keeping one or more CPU's reserved for the particular
low-latency realtime job).

                   Linus
