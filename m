Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752649AbeAJJpb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 04:45:31 -0500
Date: Wed, 10 Jan 2018 10:45:14 +0100
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <edumazet@google.com>,
        Josef Griebichler <griebichler.josef@gmx.at>,
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
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180110104514.4cd0e94a@redhat.com>
In-Reply-To: <CA+55aFwq42Nzq47csw=ME8zbHYiw2rPN_Zp+=+Bu+Ruq9XquhQ@mail.gmail.com>
References: <20180107090336.03826df2@vento.lan>
        <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
        <20180108074324.3c153189@vento.lan>
        <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
        <20180108223109.66c91554@redhat.com>
        <20180108214427.GT29822@worktop.programming.kicks-ass.net>
        <20180108231656.3bbd1968@redhat.com>
        <trinity-920967ce-ab0f-4535-8557-f82a7e667a79-1515516669310@3c-app-gmx-bs24>
        <CANn89iJqRH4uzFJVKyPxc8dN38z319C1O18nTJ-CCidtuOH2+g@mail.gmail.com>
        <CA+55aFzcoNEpnRp0R3fLYQKdfzS5mLj3z_v=1A1NfyrybQ__4A@mail.gmail.com>
        <CANn89iLo9WsFq-cvL63zD6hOXFRs97hDifksNsAHTegNQqXzZw@mail.gmail.com>
        <CA+55aFwq42Nzq47csw=ME8zbHYiw2rPN_Zp+=+Bu+Ruq9XquhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Tue, 9 Jan 2018 10:58:30 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I really think "you can use up 90% of CPU time with a UDP packet
> flood from the same network" is very very very different - and
> honestly not at all as important - as "you want to be able to use a
> USB DVB receiver and watch/record TV".
> 
> Because that whole "UDP packet flood from the same network" really is
> something you _fundamentally_ have other mitigations for.
> 
> I bet that whole commit was introduced because of a benchmark test,
> rather than real life. No?

I believe this have happened in real-life.  In the form of DNS servers
not being able to recover after long outage, where DNS-TTL had timeout
causing legitimate traffic to overload their DNS servers.  The goodput
answers/sec from their DNS servers were too low, when bringing them
online again. (Based on talk over beer at NetDevConf from a guy
claiming they ran DNS for AWS).


The commit 4cd13c21b207 ("softirq: Let ksoftirqd do its job") tries to
address a fundamental problem that the network stack have when
interacting with softirq in overload situations.
(Maybe we can come up with a better solution?)

Before this commit, when application run on same CPU as softirq, the
kernel have a bad "drop off cliff" behavior, when reaching above the
saturation point.

This is confirmed in CloudFlare blogpost[1], which used a kernel that
predates this commit. From[1] section: "A note on NUMA performance"
Quote:"
  1. Run receiver on another CPU, but on the same NUMA node as the RX
     queue. The performance as we saw above is around 360kpps.

  2. With receiver on exactly same CPU as the RX queue we can get up to
     ~430kpps. But it creates high variability. The performance drops down
     to zero if the NIC is overwhelmed with packets."

The behavior problem here is "performance drops down to zero if the NIC
is overwhelmed with packets".  That is a bad way to handle overload.
Not only when attacked, but also when bringing a service online after
an outage.

What essentially happens is that:
 1. softirq NAPI enqueue 64 packets into socket. 
 2. application dequeue 1 packet and invoke local_bh_enable()
 3. causing softirq to run in app-timeslice, again enq 64 packets
 4. app only see goodput of 1/128 of packets

That is essentially what Eric solved with his commit, avoiding (3)
local_bh_enable() to invoke softirq if ksoftirqd is already running.

Maybe we can come up with a better solution?
(as I do agree this was a too big-hammer affecting other use-cases)


[1] https://blog.cloudflare.com/how-to-receive-a-million-packets/

p.s. Regarding quote[1] point "1.", after Paolo Abeni optimized the UDP
code, that statement is no longer true.  It now (significantly) faster to
run/pin your UDP application to another CPU than the RX-CPU.
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
