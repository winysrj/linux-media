Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57486 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1DJBj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Apr 2011 21:39:58 -0400
Received: by vxi39 with SMTP id 39so3496366vxi.19
        for <linux-media@vger.kernel.org>; Sat, 09 Apr 2011 18:39:58 -0700 (PDT)
Subject: Re: [PATCH] Fix cx88 remote control input
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <8f1c0f8a-e4cd-4e3b-8ad4-f58212dfd9d4@email.android.com>
Date: Sat, 9 Apr 2011 21:39:54 -0400
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Lawrence Rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <099D978B-BC30-4527-870E-85ECEE74501D@wilsonet.com>
References: <1302267045.1749.38.camel@gagarin> <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com> <1302276147.1749.46.camel@gagarin> <B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com> <BANLkTimyT98dabuYsrwLrcm2wQFv2uQB9g@mail.gmail.com> <44DC1ED9-2697-4F92-A81A-CD024C913CCB@wilsonet.com> <BANLkTi=3Gq+8kXm40O55y55O6A6Q4-3g-g@mail.gmail.com> <CDB2A354-8564-447E-99A3-66502E83E4CB@wilsonet.com> <8f1c0f8a-e4cd-4e3b-8ad4-f58212dfd9d4@email.android.com>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Apr 8, 2011, at 4:50 PM, Andy Walls wrote:

> Jarod Wilson <jarod@wilsonet.com> wrote:
...
>>>> I have quite a few pieces of Hauppauge hardware, several with IR
>>>> receivers and remotes, but all of which use ir-kbd-i2c (or
>>>> lirc_zilog), i.e., none of which pass along raw IR.
>>> 
>>> You don't have an HVR-950 or some other stick which announces RC5
>>> codes?  If not, let me know and I will send you something.  It's kind
>>> of silly for someone doing that sort of work to not have at least one
>>> product in each category of receiver.
>> 
>> I don't think I even fully realized before today that there was
>> Hauppauge hardware shipping with the grey remotes and a raw IR
>> receiver. All the Hauppauge stuff I've got is either i2c IR
>> (PVR-250, PVR-350, HVR-1950, HD-PVR) or came with a bundled mceusb
>> transceiver (HVR-1500Q, HVR-1800, HVR-950Q -- model 72241, iirc),
>> and its all working these days (modulo some quirks with the HD-PVR
>> that still need sorting, but they're not regressions, its actually
>> better now than it used to be).
>> 
>> So yeah, I guess I have a gap in my IR hardware collection here,
>> and would be happy to have something to fill it.
>> 
> 
> Jarod,
> 
> The HVR-1850 uses a raw IR receiver in the CX23888 and older HVR-1250s use the raw IR receiver in the CX23885.  They both work for Rx (I need to tweak the Cx23885 rx watermark though), but I never found time to finish Tx (lack of kernel interface when I had time).
> 
> If you obtain one of these I can answer any driver questions.

Quite some time back, I bought an HVR-1800 and an HVR-1250. I know one of
them came with an mceusb transceiver and remote, as was pretty sure it was
the 1800. For some reason, I didn't recall the 1250 coming with anything at
all, but looking at dmesg output for it:

cx23885 driver version 0.0.2 loaded
cx23885 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250 [card=3,autodetected]
tveeprom 0-0050: Hauppauge model 79001, rev E3D9, serial# 4904656
tveeprom 0-0050: MAC address is 00:0d:fe:4a:d6:d0
tveeprom 0-0050: tuner model is Microtune MT2131 (idx 139, type 4)
tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
tveeprom 0-0050: audio processor is CX23885 (idx 39)
tveeprom 0-0050: decoder processor is CX23885 (idx 33)
tveeprom 0-0050: has no radio, has IR receiver, has no IR transmitter

So it seems I do have hardware. However, its one of the two tuner cards in
my "production" mythtv backend right now, making it a bit hard to do any
experimenting with. If I can get it out of there, it looks like I just add
an enable_885_ir=1, and I should be able to poke at it...

-- 
Jarod Wilson
jarod@wilsonet.com



