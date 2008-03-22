Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1Jd3Ff-0002pa-07
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 13:55:11 +0100
Received: from [11.11.11.138] (user-514f84eb.l1.c4.dsl.pol.co.uk
	[81.79.132.235])
	by mail.youplala.net (Postfix) with ESMTP id 2E45ED88130
	for <linux-dvb@linuxtv.org>; Sat, 22 Mar 2008 13:54:18 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1206185051.22131.5.camel@tux>
References: <1206139910.12138.34.camel@youkaida> <1206185051.22131.5.camel@tux>
Date: Sat, 22 Mar 2008 12:54:15 +0000
Message-Id: <1206190455.6285.20.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Nova-T-500 disconnects - They are back!
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


On Sat, 2008-03-22 at 12:24 +0100, Filippo Argiolas wrote:
> Il giorno ven, 21/03/2008 alle 22.51 +0000, Nicolas Will ha scritto:
> > Guys,
> > 
> > I have upgraded my system to the new Ubuntu (8.04 Hardy), using
> 2.6.24,
> > 64-bit.
> > 
> > And the disconnects are back.
> > 
> > I was using a rather ancient v4l-dvb tree, so I grabbed a new one,
> and
> > saw no improvement.
> > 
> > It may be very well linked to the remote, I was recording anything
> when
> > this one struck, just using the remote.
> 
> Hi Nico, did you apply my patch? If so could you please try it with a
> clean unpatched tree? I'd like to know if this is someway related to
> my
> patch or to dib0700_rc_setup calls.

I would doubt it, but why not.

I'll give it a try.


> BTW, I'm evaluating too an early switch from gusty to hardy, did you
> experienced any problem?


None, it went nicely, as usual, the package management system is nice,
as well as the processes around it.

Just be aware that the kernel upgrade will make your nova-t-500 unstable
like mine. But if you are willing to look into the code, go ahead!

>  Is it usable?

Very as a mythtv system. For a desktop, I would wait a bit more, FF3 is
not there yet, Compiz sees a lot of breakage too. I have a couple of
machines on Hardy.

>  I've heard something about libc6
> failures.. has it been fixed?


A long time ago, that was only a matter of hours until the fix was out.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
