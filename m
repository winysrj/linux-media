Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33188 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965050AbeALVN5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 16:13:57 -0500
Date: Fri, 12 Jan 2018 19:13:43 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>
Cc: Josef Griebichler <griebichler.josef@gmx.at>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180112191343.3083b70e@vento.lan>
In-Reply-To: <CA+55aFzcoNEpnRp0R3fLYQKdfzS5mLj3z_v=1A1NfyrybQ__4A@mail.gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 9 Jan 2018 09:48:47 -0800
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Tue, Jan 9, 2018 at 9:27 AM, Eric Dumazet <edumazet@google.com> wrote:
> >
> > So yes, commit 4cd13c21b207 ("softirq: Let ksoftirqd do its job") has
> > shown up multiple times in various 'regressions'
> > simply because it could surface the problem more often.
> > But even if you revert it, you can still make the faulty
> > driver/subsystem misbehave by adding more stress to the cpu handling
> > the IRQ.  
> 
> ..but that's always true. People sometimes live on the edge - often by
> design (ie hardware has been designed/selected to be the crappiest
> possible that still work).
> 
> That doesn't change anything. A patch that takes "bad things can
> happen" to "bad things DO happen" is a bad patch.
> 
> > Maybe the answer is to tune the kernel for small latencies at the
> > price of small throughput (situation before the patch)  
> 
> Generally we always want to tune for latency. Throughput is "easy",
> but almost never interesting.
> 
> Sure, people do batch jobs. And yes, people often _benchmark_
> throughput, because it's easy to benchmark. It's much harder to
> benchmark latency, even when it's often much more important.
> 
> A prime example is the SSD benchmarks in the last few years - they
> improved _dramatically_ when people noticed that the real problem was
> latency, not the idiotic maximum big-block bandwidth numbers that have
> almost zero impact on most people.
> 
> Put another way: we already have a very strong implicit bias towards
> bandwidth just because it's easier to see and measure.
> 
> That means that we generally should strive to have a explicit bias
> towards optimizing for latency when that choice comes up.  Just to
> balance things out (and just to not take the easy way out: bandwidth
> can often be improved by adding more layers of buffering and bigger
> buffers, and that often ends up really hurting latency).
> 
> > 1) Revert the patch  
> 
> Well, we can revert it only partially - limiting it to just networking
> for example.
> 
> Just saying "act the way you used to for tasklets" already seems to
> have fixed the issue in DVB.
> 
> > 2) get rid of ksoftirqd since it adds unexpected latencies.  
> 
> We can't get rid of it entirely, since the synchronous softirq code
> can cause problems too. It's why we have that "maximum of ten
> synchronous events" in __do_softirq().
> 
> And we don't *want* to get rid of it.
> 
> We've _always_ had that small-scale "at some point we can't do it
> synchronously any more".
> 
> That is a small-scale "don't have horrible latency for _other_ things"
> protection. So it's about latency too, it's just about protecting
> latency of the rest of the system.
> 
> The problem with commit 4cd13c21b207 is that it turns the small-scale
> latency issues in softirq handling (they get larger latencies for lots
> of hardware interrupts or even from non-preemptible kernel code) into
> the _huge_ scale latency of scheduling, and does so in a racy way too.
> 
> > 3) Let applications that expect to have high throughput make sure to
> > pin their threads on cpus that are not processing IRQ.
> >     (And make sure to not use irqbalance, and setup IRQ cpu affinities)  
> 
> The only people that really deal in "thoughput only" tend to be the
> HPC people, and they already do things like this.
> 
> (The other end of the spectrum is the realtime people that have
> extreme latency requirements, who do things like that for the reverse
> reason: keeping one or more CPU's reserved for the particular
> low-latency realtime job).

Ok, it took me some time - and a faster microSD - in order to be sure that
the data loss weren't due to bad storage performance, but I have now some
test results.

In summary, indeed the ksoftirq commit 4cd13c21b207 ("softirq: Let ksoftirqd
do its job") is causing data losses. On my tests, it generate at least one
continuity error on every 1-5 minutes.

Either reverting it or applying Linus proposal of partially reverting
it fixes the issues. Increasing the number of URBs doesn't seem to
help.

I'm enclosing the dirty details below.

Linus/Eric,

Now that I have an environment setup, I can test whatever other alternative
that would fix the UDP packet flow attack while won't break the softirq
handling code.

Regards,
Mauro

---

All tests below were done on a Raspberry Pi3 with a SanDisk Extreme U3 microSD
card with 32GB and a DVBSky S960C DVB-S2 tuner with an external power supply,
connected to a TCP/IP network via Ethernet (with uses USB on RPi). It also
have a serial cable connected to it.

It was installed with LibreELEC 8.2.2, using tvheadend backend.

I'm recording one MPEG-TS service/"channel" composed of one audio and
one video stream, The total traffic collected by tvheadend was about 
4 Mbits/s (audio+video+EPG tables). It is part of a 58 mbits/s MPEG
Transport stream, with 23 TV service/"channels" on it.

While handling this issue, I found one unrelated bug, fixed on this patch:
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=softirq_fixup&id=afb6c749c9da6e661335bc059f2b117421c09f77

This bug has no effect on DVB streaming. It only causes the signal
strength to be reported wrongly on 32 bit Kernels. On all tests below I
had this patch applied.

Test 1
======

Kernel (e. g. Raspbian Kernel), recording and watching the video at the same
time on Kodi, plus one VLC client, on an interval of time of 5 minutes,
it had 4 MPEG continuity errors on video (and one on audio):

Jan 12 15:05:39 rpi3 tvheadend[285]: TS: DVB-S Network/12090H/TV Senado: H264 @ #1601 Continuity counter error (total 1)
Jan 12 15:06:20 rpi3 tvheadend[285]: TS: DVB-S Network/12090H/TV Senado: H264 @ #1601 Continuity counter error (total 2)
Jan 12 15:07:36 rpi3 tvheadend[285]: TS: DVB-S Network/12090H/TV Senado: H264 @ #1601 Continuity counter error (total 3)
Jan 12 15:07:36 rpi3 tvheadend[285]: TS: DVB-S Network/12090H/TV Senado: MPEG2AUDIO @ #1602 Continuity counter error (total 1)
Jan 12 15:10:28 rpi3 tvheadend[285]: TS: DVB-S Network/12090H/TV Senado: H264 @ #1601 Continuity counter error (total 4)

With upstream Kernels, Kodi stops working (it depends on Raspbian video
driver). So, I opened two VLC players, on separate machines, in order
to also have 2 clients watching, plus the record task. That increased
the network and USB traffic as well. All the next tests were on such
scenario.

Test 2
======

With Kernel 4.14.12 vanilla with just one extra patch increasing the 
number of URB buffers from 8 to 16, it got 2 video errors on a 6 minutes
interval:

Jan 12 15:56:09 rpi3 tvheadend[222]: TS: DVB-S Network/12090H/TV Senado: H264 @ #1601 Continuity counter error (total 2)
Jan 12 15:56:09 rpi3 tvheadend[222]: TS: DVB-S Network/12090H/TV Senado: MPEG2AUDIO @ #1602 Continuity counter error (total 1)
Jan 12 16:03:05 rpi3 tvheadend[222]: TS: DVB-S Network/12090H/TV Senado: H264 @ #1601 Continuity counter error (total 3)
Jan 12 16:03:05 rpi3 tvheadend[222]: TS: DVB-S Network/12090H/TV Senado: MPEG2AUDIO @ #1602 Continuity counter error (total 2)


Test 3
======

With upstream Kernel 4.14.12 + 16 buffers patch + commit 4cd13c21b207 reverted,
I kept it running for about 15-30 mins. No continuity errors.

Test 4
======

With upstream Kernel 4.14.12 with the partial softirq revert made by
Linus test patch[1], running for about 20 mins, it got just one
continuity error:

Jan 12 16:51:31 rpi3 tvheadend[237]: TS: DVB-S Network/12090H/TV Senado: H264 @ #1601 Continuity counter error (total 1)
Jan 12 16:51:31 rpi3 tvheadend[237]: TS: DVB-S Network/12090H/TV Senado: MPEG2AUDIO @ #1602 Continuity counter error (total 1)

[1] https://git.linuxtv.org/mchehab/experimental.git/commit/?h=softirq_fixup&id=7996c39af87d329f64e6b1b2af120d6ce11ede29

Test 5
======

I then moved to Kernel 4.15-rc7. In this case, I had to add an extra patch,
as the USB controller is currently broken upstream:
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=softirq_fixup&id=6bcc57ea8a84e9d5fed9f5ebf13d63fd28ef181c

The .config file used to build the Kernel is at:
	https://pastebin.com/wpZghann


With upstream Kernel 4.15-rc7 - with Linus patch applied[2], I kept the
record + 2 VLC clients running for about one hour. It got just one
continuity error:

Jan 12 20:06:26 rpi3 tvheadend[226]: TS: DVB-S Network/12090H/TV Senado: H264 @ #1601 Continuity counter error (total 1)
Jan 12 20:06:26 rpi3 tvheadend[226]: TS: DVB-S Network/12090H/TV Senado: MPEG2AUDIO @ #1602 Continuity counter error (total 1)

[2] The test Kernel is this one:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=softirq_fixup

It is hard to tell if this one continuity error is due to some Kernel issue,
or if it is simply due to some PES packet with bad CRC that got discarded,
but it seems a normal condition to me.


Thanks,
Mauro
