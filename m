Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1KWa0F-0007A9-Ly
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 19:00:48 +0200
Received: from [10.11.11.138] (user-5446d4c3.lns5-c13.telh.dsl.pol.co.uk
	[84.70.212.195])
	by mail.youplala.net (Postfix) with ESMTP id 04D97D880A4
	for <linux-dvb@linuxtv.org>; Fri, 22 Aug 2008 18:59:44 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <412bdbff0808220952y16d36f3by646f0000991de4d3@mail.gmail.com>
References: <1219330331.15825.2.camel@dark> <48ADF515.6080401@nafik.cz>
	<1219360304.6770.34.camel@youkaida> <1219423326.29624.8.camel@youkaida>
	<1219423493.29624.9.camel@youkaida>
	<412bdbff0808220952y16d36f3by646f0000991de4d3@mail.gmail.com>
Date: Fri, 22 Aug 2008 17:59:46 +0100
Message-Id: <1219424386.29624.16.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] dib0700 and analog broadcasting
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

On Fri, 2008-08-22 at 12:52 -0400, Devin Heitmueller wrote:
> On Fri, Aug 22, 2008 at 12:44 PM, Nicolas Will <nico@youplala.net>
> wrote:
> > In /etc/modprobe.d/options, I have:
> > # Load DVB-T before DVB-S
> > install cx88-dvb /sbin/modprobe dvb-usb-dib0700; /sbin/modprobe
> > --ignore-install cx88-dvb
> >
> > # Hauppauge WinTV NOVA-T-500
> > options dvb-usb-dib0700 force_lna_activation=1
> > options usbcore autosuspend=-1
> 
> Interesting.  I installed the firmware, and although it hasn't helped
> my particular issue (and it's behaving identically to 1.10), it hasn't
> crashed my environment.  On the other hand, my failures occur fairly
> early in the initialization so the problem may be further into startup
> than I have gotten with my device.  I am running 8.04 with the latest
> kernel and v4l-dvb code.
> 
> Does it happen right after you plug the device in, or does it not
> occur until you start a video application?

Difficult to say.

The Nova-T 500 is a PCI card. It has a Via usb controller and the USB
dib0700 behing on the card.

As for the application, I do not think I have to enter X. I can check,
though.

I have my MythTV setup so that it doesn't grab the cards for good from
the get go. It will only get to them when it needs to record.


> 
> If it occurs immediately on connect, perhaps you could jump out of X11
> to the console before plugging it in, to see if there is any panic
> output prior to the reboot.

As it is a PCI card, that will be difficult.

> 
> Also, I can't think of why this would happen, but could you send the
> md5sum of your firmware file so we can make sure it wasn't corrupted?

I have though of that, hence the new download and the already provided
md5sum:

> The md5sum I have is the following for the firmware file:
> f42f86e2971fd994003186a055813237  dvb-usb-dib0700-1.20.fw

Nico



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
