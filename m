Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:45677 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755000AbeAHSdA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 13:33:00 -0500
MIME-Version: 1.0
In-Reply-To: <20180108175551.wp6thxmiozrz4yp2@gmail.com>
References: <trinity-35b3a044-b548-4a31-9646-ed9bc83e6846-1513505978471@3c-app-gmx-bs03>
 <20171217120634.pmmuhdqyqmbkxrvl@gofer.mess.org> <20171217112738.4f3a4f9b@recife.lan>
 <trinity-1fa14556-8596-44b1-95cb-b8919d94d2d4-1515251056328@3c-app-gmx-bs15>
 <20180106175420.275e24e7@recife.lan> <CA+55aFzHPYuxg3LwhqcxwJD2fuKzg6wU5ypfMvrpRoioiQHDFg@mail.gmail.com>
 <20180108175551.wp6thxmiozrz4yp2@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 8 Jan 2018 10:32:58 -0800
Message-ID: <CA+55aFx90oOU-3R8pCeM0ESTDYhmugD5znA9LrGj1zhazWBtcg@mail.gmail.com>
Subject: Re: dvb usb issues since kernel 4.9
To: Ingo Molnar <mingo@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 8, 2018 at 9:55 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> as I doubt we have enough time to root-case this properly.

Well, it's not like this is a new issue, and we don't have to get it
fixed for 4.15. It's been around since 4.9, it's not a "have to
suddenly fix it this week" issue.

I just think that people should plan on having to maybe revert it and
mark the revert for stable.

But if the USB or DVB layers can instead just make the packet queue a
bit deeper and not react so badly to the latency of a single softirq,
that would obviously be a good thing in general, and maybe fix this
issue. So I'm not saying that the revert is inevitable either.

But I have to say that that commit 4cd13c21b207 ("softirq: Let
ksoftirqd do its job") was a pretty damn big hammer, and entirely
ignored the "softirqs can have latency concerns" issue.

So I do feel like the UDP packet storm thing might want a somewhat
more directed fix than that huge hammer of trying to move softirqs
aggressively into the softirq thread.

This is not that different from threaded irqs. And while you can set
the "thread every irq" flag, that would be largely insane to do by
default and in general. So instead, people do it either for specific
irqs (ie "request_threaded_irq()") or they have a way to opt out of it
(IRQF_NO_THREAD).

I _suspect_ that the softirq thing really just wants the same thing.
Have the networking case maybe set the "prefer threaded" flag just for
networking, if it's less latency-sensitive for softirq handling than

In fact, even for networking, there are separate TX/RX softirqs, maybe
networking would only set it for the RX case? Or maybe even trigger it
only for cases where things queue up and it goes into a "polling mode"
(like NAPI already does).

Of course, I don't even know _which_ softirq it is that the DVB case
has issues with. Maybe it's the same NET_RX case?

But looking at that offending commit, I do note (for example), that we
literally have things like tasklet[_hi]_schedule() that might have
been explicitly expected to just run the tasklet at a fairly low
latency (maybe instead of a workqueue exactly because it doesn't need
to sleep and wants lower latency).

So saying "just because softirqd is possibly already woken up, let's
delay all those tasklets etc" does really seem very wrong to me.

Can somebody tell which softirq it is that dvb/usb cares about?

             Linus
