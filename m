Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JacuD-0002in-9O
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 21:23:02 +0100
Received: from [11.11.11.138] (user-5af0e527.wfd96.dsl.pol.co.uk
	[90.240.229.39])
	by mail.youplala.net (Postfix) with ESMTP id 9B7D9D88130
	for <linux-dvb@linuxtv.org>; Sat, 15 Mar 2008 21:22:04 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <47DC26C0.2050609@ivor.org>
References: <20080314164100.GA3470@mythbackend.home.ivor.org>
	<8ad9209c0803151138v45edf1e1p27f12aa4faa32d23@mail.gmail.com>
	<47DC26C0.2050609@ivor.org>
Date: Sat, 15 Mar 2008 20:22:03 +0000
Message-Id: <1205612523.17548.15.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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


On Sat, 2008-03-15 at 19:42 +0000, Ivor Hewitt wrote:
> 
> Patrik Hansson wrote:
> > I tried changing to 2.6.22-19 on my ubuntu 7.10 with autosuspend=-1
> > but i still lost one tuner.
> >
> > Have reverted back to 2.6.22-14-generic now and have disabled the
> > remote-pulling...and i just lost a tuner, restarting my cardclient
> and
> > mythbackend got it back.
> >
> > Did you have remote-pulling disabled in -19 ?
> >
> >   
> Still ticking along nicely here.
> 
> I have options:
> options dvb-usb-dib0700 force_lna_activation=1
> options dvb-usb disable_rc_polling=1
> (since I have no remote)

I only have the lna option.


> 
> Is the ubuntu kernel completely generic?

Really not, if you mean straight out of kernel.org.


> 
> I still see an mt2060 write failed error every now and then (four in
> the 
> past 24 hours), but that doesn't appear to break anything. Do you
> have 
> complete tuner loss as soon as you get a write error?


I do get some of those errors, never a tuner drop.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
