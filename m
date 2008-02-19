Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JRbLP-0003Qe-2W
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 23:53:47 +0100
From: Nicolas Will <nico@youplala.net>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <Pine.LNX.4.64.0802192327000.13027@pub6.ifh.de>
References: <1203434275.6870.25.camel@tux>
	<Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
	<1203457264.8019.6.camel@anden.nu> <1203459408.28796.19.camel@youkaida>
	<Pine.LNX.4.64.0802192327000.13027@pub6.ifh.de>
Date: Tue, 19 Feb 2008 22:52:40 +0000
Message-Id: <1203461560.28796.31.camel@youkaida>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700
	ir	receiver
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


On Tue, 2008-02-19 at 23:29 +0100, Patrick Boettcher wrote:
> On Tue, 19 Feb 2008, Nicolas Will wrote:
> >> I would suggest creating a netlink device which lircd (or similar)
> can
> >> read from.
> >
> > Be ready to discount my opinion, I'm not too good at those things.
> >
> > Wouldn't going away from an event interface kill a possible direct
> link
> > between the remote and X?
> >
> > The way I see it, LIRC is an additional layer that may be one too
> many
> > in most cases. From my point of view, it is a relative pain I could
> do
> > without. But I may have tunnel vision by lack of knowledge.
> 
> I agree with you. I'm more looking for a solution with existing
> things. 
> LIRC is not in kernel. I don't think we should do something specific,
> new. 
> If there is nothing which can be done with the event system I think
> we 
> should either extend it or just drop this idea.
> 
> What about HID?

<ding>

That's the sound I made when you've pushed me to the limit of my
competencies and clever remarks...

Others should jump in.

Nico



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
