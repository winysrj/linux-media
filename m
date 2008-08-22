Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1KWZlo-0005Ii-O6
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 18:45:54 +0200
Received: from [10.11.11.138] (user-5446d4c3.lns5-c13.telh.dsl.pol.co.uk
	[84.70.212.195])
	by mail.youplala.net (Postfix) with ESMTP id 5029BD880A4
	for <linux-dvb@linuxtv.org>; Fri, 22 Aug 2008 18:44:52 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1219423326.29624.8.camel@youkaida>
References: <1219330331.15825.2.camel@dark>  <48ADF515.6080401@nafik.cz>
	<1219360304.6770.34.camel@youkaida> <1219423326.29624.8.camel@youkaida>
Date: Fri, 22 Aug 2008 17:44:53 +0100
Message-Id: <1219423493.29624.9.camel@youkaida>
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

On Fri, 2008-08-22 at 17:42 +0100, Nicolas Will wrote:
> On Fri, 2008-08-22 at 00:11 +0100, Nicolas Will wrote:
> > On Fri, 2008-08-22 at 01:07 +0200, gothic nafik wrote:
> > > i have just tried to load that new firmware and i don't have any 
> > > problems with that...
> > > no unexpected reboot and it mounts devices into /dev/dvb/*
> > 
> > Chances are that I've done my testing a bit too late in the night
> > considering the week I've had.
> > 
> > I've reverted to 1.10 and will redo the 1.20 from scratch tomorrow.
> > 
> 
> I've tried again, fully awake. With full power downs, soft link or
> full
> rename, etc...
> 
> Same thing. Self-reboot, no device, no message.
> 
> I downloaded the firmware again, same thing.
> 
> The md5sum I have is the following for the firmware file:
> f42f86e2971fd994003186a055813237  dvb-usb-dib0700-1.20.fw
> 
> Reverting to 1.10 fw makes it work again.
> 
> dmesg, lspci, lsusb, lsmod available here, more can be provided on
> demand:
> http://www.youplala.net/~will/htpc/Hardware/lsmod.txt
> 
> Ubuntu 8.04 box with security, backports, updates, medibuntu and
> mythbuntu-fixes, 64-bit. 2.6.24 kernel. NVIDIA blob. Nova-T 500 and
> KWorld DVB-S100 cards.
> 
> Full description of the system here:
> http://www.youplala.net/linux/home-theater-pc


In /etc/modprobe.d/options, I have:

# Load DVB-T before DVB-S
install cx88-dvb /sbin/modprobe dvb-usb-dib0700; /sbin/modprobe
--ignore-install cx88-dvb

# Hauppauge WinTV NOVA-T-500
options dvb-usb-dib0700 force_lna_activation=1
options usbcore autosuspend=-1

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
