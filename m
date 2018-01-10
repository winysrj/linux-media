Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58950 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751564AbeAJDDc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 22:03:32 -0500
Message-ID: <1515553368.8252.5.camel@gmx.de>
Subject: Re: dvb usb issues since kernel 4.9
From: Mike Galbraith <efault@gmx.de>
To: Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
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
        David Miller <davem@davemloft.net>
Date: Wed, 10 Jan 2018 04:02:48 +0100
In-Reply-To: <20180109222604.64d4377c@redhat.com>
References: <CA+55aFx90oOU-3R8pCeM0ESTDYhmugD5znA9LrGj1zhazWBtcg@mail.gmail.com>
         <Pine.LNX.4.44L0.1801081354450.1908-100000@iolanthe.rowland.org>
         <CA+55aFwuAojr7vAfiRO-2je-wDs7pu+avQZNhX_k9NN=D7_zVQ@mail.gmail.com>
         <20180109154235.2a42f0a0@vento.lan> <20180109222604.64d4377c@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-01-09 at 22:26 +0100, Jesper Dangaard Brouer wrote:
> 
> I've previously experienced that you can be affected by the scheduler
> granularity, which is adjustable (with CONFIG_SCHED_DEBUG=y):
> 
>  $ grep -H . /proc/sys/kernel/sched_*_granularity_ns
>  /proc/sys/kernel/sched_min_granularity_ns:2250000
>  /proc/sys/kernel/sched_wakeup_granularity_ns:3000000
> 
> The above numbers were confirmed on the RPi2 (see[2]). With commit
> 4cd13c21b207 ("softirq: Let ksoftirqd do its job"), I expect/assume that
> softirq processing latency is bounded by the sched_wakeup_granularity_ns,
> which with 3 ms is not good enough for their use-case.

Note of caution wrt twiddling sched_wakeup_granularity_ns: it must
remain < sched_latency_ns/2 else you effectively disable wakeup
preemption completely, turning CFS into a tick granularity scheduler.

	-Mike
