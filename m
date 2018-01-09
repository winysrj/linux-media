Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:42548 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbeAIR1q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 12:27:46 -0500
Received: by mail-wr0-f195.google.com with SMTP id w107so14907114wrb.9
        for <linux-media@vger.kernel.org>; Tue, 09 Jan 2018 09:27:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <trinity-920967ce-ab0f-4535-8557-f82a7e667a79-1515516669310@3c-app-gmx-bs24>
References: <20180107090336.03826df2@vento.lan> <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
 <20180108074324.3c153189@vento.lan> <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
 <20180108223109.66c91554@redhat.com> <20180108214427.GT29822@worktop.programming.kicks-ass.net>
 <20180108231656.3bbd1968@redhat.com> <trinity-920967ce-ab0f-4535-8557-f82a7e667a79-1515516669310@3c-app-gmx-bs24>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 Jan 2018 09:27:43 -0800
Message-ID: <CANn89iJqRH4uzFJVKyPxc8dN38z319C1O18nTJ-CCidtuOH2+g@mail.gmail.com>
Subject: Re: Re: dvb usb issues since kernel 4.9
To: Josef Griebichler <griebichler.josef@gmx.at>
Cc: Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 9, 2018 at 8:51 AM, Josef Griebichler
<griebichler.josef@gmx.at> wrote:
> Hi Linus,
>
> your patch works very good for me and others (please see https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=77006#post77006). No errors in recordings any more.
> The patch was also tested on x86_64 (Revo 3700) with positive effect.
> I agree with the forum poster, that there's still an issue when recording and watching livetv at same time. I also get audio dropouts and audio is out of sync.
> According to user smp kernel 4.9.73 with your patch on rpi and according to user jahutchi kernel 4.11.12 on x86_64 have no such issues.
> I don't know if this dropouts are related to this topic.
>
> If of any help I could provide perf output on raspberry with libreelec and tvheadend.
>

Sorry to come late to the party.

It seems problem comes from some piece of hardware/driver having some
precise timing prereq, and opportunistic use of softirq/tasklet
(instead maybe of hard irq handlers )

While it is true that softirq might do the job in most cases, we
already have cases where this can be easily defeated,
say if one cpu has suddenly to handle multiple sources of interrupts
for various devices.
NET_RX can easily lock the cpu for 10ms (on HZ=100 builds)

So yes, commit 4cd13c21b207 ("softirq: Let ksoftirqd do its job") has
shown up multiple times in various 'regressions'
simply because it could surface the problem more often.
But even if you revert it, you can still make the faulty
driver/subsystem misbehave by adding more stress to the cpu handling
the IRQ.

Note that networking lacks fine control of its softirq processing.
Some people found/complained that relying more on ksoftirqd was
potentially adding tail latencies.

Maybe the answer is to tune the kernel for small latencies at the
price of small throughput (situation before the patch)

1) Revert the patch
2) get rid of ksoftirqd since it adds unexpected latencies.
3) Let applications that expect to have high throughput make sure to
pin their threads on cpus that are not processing IRQ.
    (And make sure to not use irqbalance, and setup IRQ cpu affinities)
