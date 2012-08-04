Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59079 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab2HDBsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Aug 2012 21:48:16 -0400
Subject: Re: Asus PVR-416
From: Andy Walls <awalls@md.metrocast.net>
To: Jerry Haggard <xen2xen1@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Fri, 03 Aug 2012 21:48:13 -0400
In-Reply-To: <CAK4QoGu=uTn_YQoPZq2+jMD+JEmvREhgCYkfLoVfD8TxiMxFvg@mail.gmail.com>
References: <501668B2.3050107@gmail.com>
	 <1343686247.2486.8.camel@palomino.walls.org>
	 <CAK4QoGtQnwug=65j8ZxyUhVBKoXhdb7YAV6g9rMPP06NhVSCeQ@mail.gmail.com>
	 <CAK4QoGtiN7jRnT2MzUAwogukvpnmdVdk9OrxpfOVAGBYR+v7Wg@mail.gmail.com>
	 <CAK4QoGu=uTn_YQoPZq2+jMD+JEmvREhgCYkfLoVfD8TxiMxFvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1344044894.2574.17.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-08-01 at 07:40 -0400, Jerry Haggard wrote:
> I swapped PCI slots (there's 2), blew it and no change.  I put it back
> to the firmware from atrpms, and nothing has changed.  Is the checksum
> mismatch from what's loaded onto the card or is it the checksum of
> what's on the disk?  I've been obsessed with getting the right
> firmware since I assume the checksum was from what's on the disc.  Is
> that wrong? 
> 
> 
> And again, thanks for the help.

The MPEG encoder firmware used for the blackbird designs (GPIO connected
CX23416 or CX23417) should be the same one used with ivtv (PCI connected
CX23415 or CX23416) - it's the same hardware.

The firmware I happen to have on my machine:
$ ls -al /lib/firmware/v4l-cx2341x-enc.fw 
-rwxr-xr-x. 1 root root 376836 Feb 17  2007 /lib/firmware/v4l-cx2341x-enc.fw

$ sha256sum -b /lib/firmware/v4l-cx2341x-enc.fw
56530c3884feaf587500d42fce47099f9f3af222e3c18f1a9f3d7f0fa916630a */lib/firmware/v4l-cx2341x-enc.fw


Which has a size that agrees with the cx88 driver here:
http://git.linuxtv.org/media_tree.git/blob/staging/for_v3.6:/drivers/media/video/cx88/cx88-blackbird.c#l62


The checksum being done by the cx88 driver is here:
http://git.linuxtv.org/media_tree.git/blob/staging/for_v3.6:/drivers/media/video/cx88/cx88-blackbird.c#l471
A 2's complement sum of the 1's complement of the data in the file, is
compared to the sum of the data read back from the device.

If you have a *single* PCI bus error in the memory_read() or
memory_write() functions, you're done/dead:
http://git.linuxtv.org/media_tree.git/blob/staging/for_v3.6:/drivers/media/video/cx88/cx88-blackbird.c#l250

A failed PCI read will return 0xFFFFFFFF according to the PCI
specifications.

I hope that helps you understand what might be going on, and where you
might need to ivestiagte further.

Regards,
Andy

> On Wed, Aug 1, 2012 at 7:16 AM, Jerry Haggard <xen2xen1@gmail.com>
> wrote:
>         I've played with it a bit more.  I cut the firmware out of the
>         driver as suggested here:
>         
>         
>         http://www.mythtv.org/wiki/AVerMedia_M150-D 
>         
>         
>         What I get is:
>         
>         
>         cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized
>         or corrupted
>         cx88-mpeg driver manager 0000:01:01.2: firmware: requesting
>         v4l-cx2341x-enc.fw
>         cx88[0]/2-bb: ERROR: Firmware size mismatch (have 262144,
>         expected 376836)
>         
>         
>         What I always got before was:
>         
>         
>         cx88[0]: subsystem: 1043:4823, board: ASUS PVR-416
>         [card=12,autodetected], frontend(s): 0
>         cx88[0]: TV tuner type 43, Radio tuner type -1
>         IR RC5(x) protocol handler initialized
>         IR RC6 protocol handler initialized
>         All bytes are equal. It is not a TEA5767
>         tuner 15-0060: Tuner -1 found with type(s) Radio TV.
>         IR JVC protocol handler initialized
>         IR Sony protocol handler initialized
>         tda9887 15-0043: creating new instance
>         tda9887 15-0043: tda988[5/6/7] found
>         tuner 15-0043: Tuner 74 found with type(s) Radio TV.
>         IR SANYO protocol handler initialized
>         IR MCE Keyboard/mouse protocol handler initialized
>         lirc_dev: IR Remote Control driver registered, major 248
>         IR LIRC bridge handler initialized
>         tuner-simple 15-0060: creating new instance
>         tuner-simple 15-0060: type set to 43 (Philips NTSC MK3
>         (FM1236MK3 or FM1236/F))
>         cx88[0]/0: found at 0000:01:01.0, rev: 5, irq: 21, latency:
>         64, mmio: 0xdd000000
>         IRQ 21/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
>         cx88[0]/0: registered device video0 [v4l2]
>         cx88[0]/0: registered device vbi0
>         cx88[0]/0: registered device radio0
>         cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
>         cx88[0]/2: cx2388x 8802 Driver Manager
>         cx88-mpeg driver manager 0000:01:01.2: PCI INT A -> GSI 21
>         (level, low) -> IRQ 21
>         cx88[0]/2: found at 0000:01:01.2, rev: 5, irq: 21, latency:
>         64, mmio: 0xde000000
>         IRQ 21/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
>         cx2388x blackbird driver version 0.0.9 loaded
>         cx88/2: registering cx8802 driver, type: blackbird access:
>         shared
>         cx88[0]/2: subsystem: 1043:4823, board: ASUS PVR-416 [card=12]
>         cx88[0]/2: cx23416 based mpeg encoder (blackbird reference
>         design)
>         cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized
>         or corrupted
>         cx88-mpeg driver manager 0000:01:01.2: firmware: requesting
>         v4l-cx2341x-enc.fw
>         parport_pc 00:06: reported by Plug and Play ACPI
>         parport0: PC-style at 0x378 (0x778), irq 7
>         [PCSPP,TRISTATE,EPP]
>         ppdev: user-space parallel port driver
>         cx88[0]/2-bb: ERROR: Firmware load failed (checksum mismatch).
>         cx88[0]/2: registered device video1 [mpeg]
>         cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized
>         or corrupted
>         cx88-mpeg driver manager 0000:01:01.2: firmware: requesting
>         v4l-cx2341x-enc.fw
>         cx88[0]/2-bb: ERROR: Firmware load failed (checksum mismatch).
>         
>         
>         It appears that when I give it the correct firmware it
>         complains?
>         



>                 
>                 
>                 On Mon, Jul 30, 2012 at 6:10 PM, Andy Walls
>                 <awalls@md.metrocast.net> wrote:
>                         On Mon, 2012-07-30 at 06:57 -0400, Jerry
>                         Haggard wrote:
>                         > I've been trying to get an ASUS PVR-416 card
>                         to work with MythTV .25 on
>                         > Scientific Linux 6.  I have a bttv card
>                         working, my setup works in
>                         > general, etc, and the driver attempts to
>                         load.  But when I check dmesg,
>                         > I keep getting firmware load errors and
>                         checksum errors. I've tried
>                         > every firmware I could find.  I've used the
>                         one from Atrpms, I've
>                         > downloaded the correctly named firmware from
>                         ivtv, but no luck.  Anyone
>                         > know anything about this card?  I've tried
>                         cutting the drivers myself
>                         > like it says in the direcitons at
>                         mythtv.org. This is supposed to be a
>                         > supported card, does anyone have any
>                         experience with it?
>                         
>                         
>                         No experience with it.  It is supposedly a
>                         Blackbird design supported by
>                         the cx88 driver.
>                         
>                         My standard response for legacy PCI cards that
>                         are responding somewhat,
>                         but aren't working properly, is to
>                         
>                         1. remove all the legacy PCI cards from all
>                         the slots
>                         2. blow the dust out of all the slots
>                         3. if feasible, reseat only the 1 card and
>                         test again
>                         4. reseat all the cards and test again
>                         
>                         Since legacy PCI uses reflected wave
>                         switching, dust in any one slot can
>                         cause problems.  It's a troubleshooting step
>                         that's easy enough to do.
>                         
>                         If that doesn't work, we would need to see the
>                         output of dmesg
>                         and/or /var/log/messages when the module is
>                         being loaded and the
>                         firmware loaded.  If providing logs, please
>                         don't just grep on the
>                         'cx88' lines, since other modules are involved
>                         in getting the card
>                         working.





