Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1KWaiA-0002Ba-L5
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 19:46:11 +0200
Received: from [10.11.11.138] (user-5446d4c3.lns5-c13.telh.dsl.pol.co.uk
	[84.70.212.195])
	by mail.youplala.net (Postfix) with ESMTP id 90E22D880A4
	for <linux-dvb@linuxtv.org>; Fri, 22 Aug 2008 19:45:16 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1219424386.29624.16.camel@youkaida>
References: <1219330331.15825.2.camel@dark> <48ADF515.6080401@nafik.cz>
	<1219360304.6770.34.camel@youkaida> <1219423326.29624.8.camel@youkaida>
	<1219423493.29624.9.camel@youkaida>
	<412bdbff0808220952y16d36f3by646f0000991de4d3@mail.gmail.com>
	<1219424386.29624.16.camel@youkaida>
Date: Fri, 22 Aug 2008 18:45:17 +0100
Message-Id: <1219427117.29624.33.camel@youkaida>
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

On Fri, 2008-08-22 at 17:59 +0100, Nicolas Will wrote:
> > Does it happen right after you plug the device in, or does it not
> > occur until you start a video application?
> 
> Difficult to say.
> 
> The Nova-T 500 is a PCI card. It has a Via usb controller and the USB
> dib0700 behing on the card.
> 
> As for the application, I do not think I have to enter X. I can check,
> though.
> 

Sure, it happens when X starts. But it could also be bad timing. The
MythTV backend, the app that really uses the DVB stuff, starts right
before X.


I have asked for debug info from the dib0700 module.

Aug 22 18:05:23 favia kernel: [   33.238864] dib0700: loaded with support for 7 different device-types
Aug 22 18:05:23 favia kernel: [   33.239009] FW GET_VERSION length: -32
Aug 22 18:05:23 favia kernel: [   33.239011] cold: 1
Aug 22 18:05:23 favia kernel: [   33.239012] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold state, will try to load a firmware

And then nothing with 1.20 fw.

What is interesting, is that at each self-reboot, that are warm reboots,
the card is in cold state and needs a firmware. So can I conclude that
it never got loaded? Or that the self reboot is a cold reboot?


I have tried to boot without a firmware file, and it goes all the way to
MythTV without reboot.

Nico




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
