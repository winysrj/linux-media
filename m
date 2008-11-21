Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L3aa6-0008MK-Sj
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 19:18:17 +0100
Received: by ug-out-1314.google.com with SMTP id x30so189812ugc.16
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 10:18:11 -0800 (PST)
Date: Fri, 21 Nov 2008 19:17:50 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811210928n204dd6a3hdc7d20bcacdfe7bd@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0811211837000.6304@ybpnyubfg.ybpnyqbznva>
References: <412bdbff0811210928n204dd6a3hdc7d20bcacdfe7bd@mail.gmail.com>
MIME-Version: 1.0
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Hardware pid filters: are they worth it?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Fri, 21 Nov 2008, Devin Heitmueller wrote:

> hardware pid filter support.

> Does anyone have any experience with hardware pid filters, and have
> they provided any signficant/visible benefit over the kernel pid
> filter (either from a performance perspective or power consumption)?

My opinion:  Yes.  But then, I've just unearthed a 20-year
old `portable' PC, and my `production' machine is somewhat
long in the tooth (if you, well, not *you*, but someone in my
area, throws away a machine faster than 200MHz Pentium, and
with more than 5 PCI-or-greater slots, I'll happily upgrade)

My software-filtering cards also speak USB, and on my slow
machine, the added load both from sending a complete transport
stream over USB, then filtering it, takes a noticeable amount
of CPU.  I can come close to maxing it out with a DVB-T full
stream, an internal PCI HD-H.264 stream, and two additional USB 
multi-radio streams.  And at times I've experienced packet loss.


Interestingly, on a faster notebook, a full-TS satellite
tuner card via USB does not always give error-free results,
for reasons I've not deduced -- but could be related to its
use as an end-user machine, while my slow workhorse pretty
much exists as a server.  Oh, that server has only got 32MB
RAM too.  Too cheap to upgrade.  I am.  Yeah.



> It's probably a good thing to implement in general for completeness,

I have a device which according to what I've read, requires
a simple register flip to enable internal PID filtering, or
not.  As it's valuable to me, I'm willing to see if I can
add part of the code needed to enable hardware filtering
too.  Not that I can code, but I'm willing.  To see.  If.

Also, the streams of interest to me do not necessarily fit
into USB1 bandwidth -- I'm thinking an 8MHz 256QAM carrier
with five or six high-quality SD MPEG-2 videos of dynamic
bandwidth, which exceed my USB1 device capabilities.


> but if there isn't any power or performance savings then I'm not sure
> it's worth my time.

Power savings -- some, as the CPU itself doesn't have to be
bogged down tossing bits.  Performance savings, for me,
significant.  Also, for me, can mean the difference between
a flawless data stream, and a garbled packet-loss mess.

Also, I experience ``oddness'' in data transfer over USB
when I'm trying to do several things at once, so in case of
weaknesses of the Linux USB stack, it's good to allow the
end-user to avoid stressing it until it's as reliable as,
well, um, I dunno, floppy support or something, my opinion...


> Opinions welcome,

Sorted.
please ignore.  after all, i should've left my current server
machine in the pile of e-waste from which I recovered it...

thanks!
barry bouwsma
opinion!  i mean, mine!  opinion!  ignore!  mine!  drink!  girls!  fe

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
