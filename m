Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751749AbeAIV0V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 16:26:21 -0500
Date: Tue, 9 Jan 2018 22:26:04 +0100
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180109222604.64d4377c@redhat.com>
In-Reply-To: <20180109154235.2a42f0a0@vento.lan>
References: <CA+55aFx90oOU-3R8pCeM0ESTDYhmugD5znA9LrGj1zhazWBtcg@mail.gmail.com>
        <Pine.LNX.4.44L0.1801081354450.1908-100000@iolanthe.rowland.org>
        <CA+55aFwuAojr7vAfiRO-2je-wDs7pu+avQZNhX_k9NN=D7_zVQ@mail.gmail.com>
        <20180109154235.2a42f0a0@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Tue, 9 Jan 2018 15:42:35 -0200 Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> Em Mon, 8 Jan 2018 11:51:04 -0800 Linus Torvalds <torvalds@linux-foundation.org> escreveu:
> 
[...]
> Patch makes sense to me, although I was not able to test it myself.
 
The patch also make sense to me.  I've done some basic testing with it
on my high-end Broadwell system (that I use for 100Gbit/s testing). As
expected the network overload case still works, as NET_RX_SOFTIRQ is
not matched. 

> I set a RPi3 machine here with vanilla Kernel 4.14.11 running a
> standard raspbian distribution (with elevator=deadline).

I found a Raspberry Pi Model B+ (I think, BCM2835), that I loaded the
LibreELEC distro on.  One of the guys even created an image for me with
a specific kernel[1] (that I just upgraded the system with).

[1] https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=77031#post77031
 
> My plan is to do more tests along this week, and try to tweak a little
> bit both userspace and kernelspace, in order to see if I can get
> better results.
 
I've previously experienced that you can be affected by the scheduler
granularity, which is adjustable (with CONFIG_SCHED_DEBUG=y):

 $ grep -H . /proc/sys/kernel/sched_*_granularity_ns
 /proc/sys/kernel/sched_min_granularity_ns:2250000
 /proc/sys/kernel/sched_wakeup_granularity_ns:3000000

The above numbers were confirmed on the RPi2 (see[2]). With commit
4cd13c21b207 ("softirq: Let ksoftirqd do its job"), I expect/assume that
softirq processing latency is bounded by the sched_wakeup_granularity_ns,
which with 3 ms is not good enough for their use-case.

Thus, if you manage to reproduce the case, try to see if adjusting this
can mitigate the issue...


Their system have non-preempt kernel, should they use PREEMPT?

 LibreELEC:~ # uname -a
 Linux LibreELEC 4.14.10 #1 SMP Tue Jan 9 17:35:03 GMT 2018 armv7l GNU/Linux

[2] https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=76999#post76999
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
