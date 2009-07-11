Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:63905 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZGKNAL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jul 2009 09:00:11 -0400
Subject: Re: [linux-dvb] problems with Terratec Cinergy 1200 DVB-C MK3
 after mainboard switch
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <4A58893E.4060508@networkhell.de>
References: <4A58893E.4060508@networkhell.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Jul 2009 09:02:02 -0400
Message-Id: <1247317322.3149.8.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-07-11 at 14:44 +0200, Matthias Müller wrote:
> Hi,
> 
> I use two Cinergy 1200 DVB-C MK3 for quite a long time and had no 
> problems so far. Now I switched to a new mainboard (Asus m4n78 pro) and 
> after some time, the dvb-c cards aren't usable anymore. This can be 
> triggered by heavy IO.
> On both mainboards I use Ubuntu 9.04 with the same kernel version 
> (2.6.28-13-generic, also tested with 2.6.28-14-server). While running 
> vdr I see the following in syslog:
> 
> Jul 11 12:29:52 bowser vdr: [4678] frontend 0 lost lock on channel 6, tp 121
> Jul 11 12:29:52 bowser kernel: [ 1235.601266] DVB: TDA10023(0): 
> tda10023_readreg: readreg error (reg == 0x11, ret == -1)
> Jul 11 12:29:52 bowser vdr: [4682] frontend 1 lost lock on channel 40, 
> tp 730
> Jul 11 12:29:52 bowser kernel: [ 1235.631263] DVB: TDA10023(1): 
> tda10023_readreg: readreg error (reg == 0x11, ret == -1)
> Jul 11 12:29:52 bowser kernel: [ 1235.701265] DVB: TDA10023(0): 
> tda10023_readreg: readreg error (reg == 0x11, ret == -1)
> Jul 11 12:29:52 bowser kernel: [ 1235.741264] DVB: TDA10023(1): 
> tda10023_readreg: readreg error (reg == 0x11, ret == -1)
> Jul 11 12:29:52 bowser kernel: [ 1235.801262] tda10023: lock tuner fails
> Jul 11 12:29:52 bowser kernel: [ 1235.851263] DVB: TDA10023(1): 
> tda10023_readreg: readreg error (reg == 0x11, ret == -1)
> Jul 11 12:29:52 bowser kernel: [ 1235.951264] DVB: TDA10023(1): 
> tda10023_readreg: readreg error (reg == 0x11, ret == -1)
> Jul 11 12:29:52 bowser kernel: [ 1236.001263] tda10023: unlock tuner fails
> Jul 11 12:29:52 bowser kernel: [ 1236.051271] tda10023: lock tuner fails
> Jul 11 12:29:52 bowser kernel: [ 1236.101271] DVB: TDA10023(0): 
> tda10023_readreg: readreg error (reg == 0x03, ret == -1)
> Jul 11 12:29:53 bowser kernel: [ 1236.200557] DVB: TDA10023(0): 
> tda10023_writereg, writereg error (reg == 0x03, val == 0x00, ret == -1)
> 
> Using lspci I see the following:
> 
> 01:05.0 Multimedia controller: Philips Semiconductors SAA7146 (rev ff) 
> (prog-if ff)
>         !!! Unknown header type 7f
>         Kernel driver in use: budget_av
> 
> 01:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev ff) 
> (prog-if ff)
>         !!! Unknown header type 7f
>         Kernel driver in use: budget_av

This is not a PCI latency problem.

You appear to be experiencing PCI bus errors.  Read errors on the PCI
bus return 0xffffffff and it looks like that's happening on your system:

	(rev ff) (prog-if ff)

PCI bus error are usually caused by the PCI bridge chips on your
motherboard being overwhelmed or by bus signals of marginal quality or,
of course, by actually defective hardware.

As something simple and easy to try, I would suggest:

1. Remove *all* your PCI cards
2. Blow the dust out of *all* the slots.
3. Reseat the cards.

That will hopefully improve the signal quality on the bus.

You may also want to test with only 1 video capture card installed at
first.

Regards,
Andy

> Before the problem the lspci output looked like this:
> 
> 01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: TERRATEC Electronic GmbH Device 1176
>         Flags: bus master, medium devsel, latency 32, IRQ 16
>         Memory at faeffc00 (32-bit, non-prefetchable) [size=512]
>         Kernel driver in use: budget_av
>         Kernel modules: budget-av
> 
> 01:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: TERRATEC Electronic GmbH Device 1176
>         Flags: bus master, medium devsel, latency 32, IRQ 19
>         Memory at faeff800 (32-bit, non-prefetchable) [size=512]
>         Kernel driver in use: budget_av
>         Kernel modules: budget-av
> 
> Searching on google I found something about adjusting pci-latencies to 
> 64, I already tried that, but it didn't help. I updated the BIOS to the 
> latest version, but that didn't help either.
> 
> Any ideas?
> 
> Matthias


