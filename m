Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50868 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756855Ab1F1Ka3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 06:30:29 -0400
References: <1302267045.1749.38.camel@gagarin> <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com> <1302276147.1749.46.camel@gagarin> <B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com> <BANLkTimyT98dabuYsrwLrcm2wQFv2uQB9g@mail.gmail.com> <44DC1ED9-2697-4F92-A81A-CD024C913CCB@wilsonet.com> <BANLkTi=3Gq+8kXm40O55y55O6A6Q4-3g-g@mail.gmail.com> <CDB2A354-8564-447E-99A3-66502E83E4CB@wilsonet.com> <8f1c0f8a-e4cd-4e3b-8ad4-f58212dfd9d4@email.android.com> <099D978B-BC30-4527-870E-85ECEE74501D@wilsonet.com> <1302476895.2282.12.camel@localhost> <679F6706-8E38-4DF4-9F06-65EC3747339E@wilsonet.com>
In-Reply-To: <679F6706-8E38-4DF4-9F06-65EC3747339E@wilsonet.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: HVR-1250/CX23885 IR Rx
From: Andy Walls <awalls@md.metrocast.net>
Date: Tue, 28 Jun 2011 06:30:38 -0400
To: Jarod Wilson <jarod@wilsonet.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <444047a2-87a6-4823-a1cd-961493f6680f@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jarod Wilson <jarod@wilsonet.com> wrote:

>On Apr 10, 2011, at 7:08 PM, Andy Walls wrote:
>
>> On Sat, 2011-04-09 at 21:39 -0400, Jarod Wilson wrote:
>> 
>>>> Jarod,
>>>> 
>>>> The HVR-1850 uses a raw IR receiver in the CX23888 and older
>>> HVR-1250s use the raw IR receiver in the CX23885.  They both work
>for
>>> Rx (I need to tweak the Cx23885 rx watermark though), but I never
>>> found time to finish Tx (lack of kernel interface when I had time).
>>>> 
>>>> If you obtain one of these I can answer any driver questions.
>>> 
>>> Quite some time back, I bought an HVR-1800 and an HVR-1250. I know
>one of
>>> them came with an mceusb transceiver and remote, as was pretty sure
>it was
>>> the 1800. For some reason, I didn't recall the 1250 coming with
>anything at
>>> all, but looking at dmesg output for it:
>>> 
>>> cx23885 driver version 0.0.2 loaded
>>> cx23885 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>>> CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge
>WinTV-HVR1250 [card=3,autodetected]
>>> tveeprom 0-0050: Hauppauge model 79001, rev E3D9, serial# 4904656
>>> tveeprom 0-0050: MAC address is 00:0d:fe:4a:d6:d0
>>> tveeprom 0-0050: tuner model is Microtune MT2131 (idx 139, type 4)
>>> tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
>>> tveeprom 0-0050: audio processor is CX23885 (idx 39)
>>> tveeprom 0-0050: decoder processor is CX23885 (idx 33)
>>> tveeprom 0-0050: has no radio, has IR receiver, has no IR
>transmitter
>>> 
>>> So it seems I do have hardware. However, its one of the two tuner
>cards in
>>> my "production" mythtv backend right now, making it a bit hard to do
>any
>>> experimenting with. If I can get it out of there, it looks like I
>just add
>>> an enable_885_ir=1, and I should be able to poke at it...
>> 
>> Yeah.  Igor's TeVii S470 CX23885 based card had interrupt storms when
>> enabled, so IR for '885 chips is disabled by default.  To
>investigate, I
>> tried to by an HVR-1250 with a CX23885, but instead got an HVR-1275
>with
>> a CX23888.  dandel, on IRC, did a pretty decent job in testing
>HVR-1250
>> operation and finding it works, despite climbing kernel
>> build/development learning curve at the time.
>...
>
>Finally got some time to play with my 1250, dug out its rx cable, turns
>out to
>be the same one I special-ordered to work on the 1150 Devin sent me.
>Oops.
>Anyway. First impressions, not so good. Got a panic on boot, somewhere
>in
>cx23885_video_irq, iirc, when booting with enable_885_ir=1 set.
>However, dmesg
>was somewhere in the middle of cx18 init of the HVR-1600 in the box.
>Dunno if
>there's any way that's actually directly related, but I yanked the
>1600. After
>doing that, the box managed to boot fine, but then while testing
>w/ir-keytable
>and an RC-6 remote, I got what I think was the same panic -- definitely
>the
>cx23885_video_irq bit in the trace, something about sleeping while
>atomic, IP
>at mwait_idle. (On the plus side, IR did seem to be working before
>that).
>
>Note also that this is a 2.6.32-based kernel with a 2.6.38-era backport
>of the
>driver code, because that's what was on this box. Was about to put it
>back into
>"production" use, but hey, its summer, there's nothing really for it to
>record
>for another few months, so I'll keep it out and throw it into another
>box with
>a newer kernel and serial console, etc., so I can further debug...
>
>
>-- 
>Jarod Wilson
>jarod@wilsonet.com

In a very early version of the CX23885 IR changes I made the mistake of performing I2C transactions in an interrupt handler.  That has been fixed in cx23885 for quite some time though.  It also required some I2C fixes in cx25840-core.c IIRC, which again, has been fixed for some time.

Regards,
Andy
