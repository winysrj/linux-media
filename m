Return-path: <mchehab@pedra>
Received: from mail-bw0-f51.google.com ([209.85.214.51]:42886 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1BVMeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 07:34:22 -0500
Received: by bwz10 with SMTP id 10so3160797bwz.10
        for <linux-media@vger.kernel.org>; Tue, 22 Feb 2011 04:34:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikcQw8+Xb1zFr75zxuG9P4p14egw=9HeN7kswAN@mail.gmail.com>
References: <AANLkTik_PcJdKSE1+konisckfb-j05+yaUFuiG+CsRTQ@mail.gmail.com>
	<1297735794.2394.88.camel@localhost>
	<AANLkTikcQw8+Xb1zFr75zxuG9P4p14egw=9HeN7kswAN@mail.gmail.com>
Date: Tue, 22 Feb 2011 14:34:21 +0200
Message-ID: <AANLkTiko3nTvcaNr73LmUuvmnk0_tr7BoRh-zYJ2a-nQ@mail.gmail.com>
Subject: Re: No data from tuner over PCI bridge adapter (Cablestar HD 2 /
 mantis / PEX 8112)
From: Dennis Kurten <dennis.kurten@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Feb 15, 2011 at 4:23 PM, Dennis Kurten <dennis.kurten@gmail.com> wrote:
> Hello Andy, I've tried some of your suggestions, but no luck so far.
>
>
> On Tue, Feb 15, 2011 at 4:09 AM, Andy Walls <awalls@md.metrocast.net> wrote:
>> On Mon, 2011-02-14 at 13:35 +0200, Dennis Kurten wrote:
>>> Hello,
>>>
>>> This card (technisat cablestar hd 2 dvb-c) works fine when plugged
>>> into a native PCI slot. When I try it with a PCI-adapter I intend to use in
>>> mITX-builds there doesn't seem to be any data coming in through the
>>> tuner. The adapter is a transparent bridge (with a PEX 8112 chip) that
>>> goes into a 1xPCIe-slot and gets power through a 4-pin molex.
>>>
>>> [...]
>>>
>>> Kernel is 2.6.32 (+the compiled drivers)


I have upgraded my system to 2.6.35 so now I'm using "vanilla drivers" but
the problem remains: Works fine in PCI - doesn't in PCIE behind adapter.


>>> [...]
>>>
>>>         Latency: 32 (2000ns min, 63750ns max)
>>>         Interrupt: pin A routed to IRQ 16
>>>         Region 0: Memory at fdcff000 (32-bit, prefetchable) [size=4K]
>>                                                ^^^^^^^^^^^^
>>
>> Heh, I always find it curious when I/O peripherials claim their register
>> space is prefetchable (the CX23416 does this as well).  If the chip is
>> designed right, it is valid though AFAICT.
>>


And is there any point with prefetchable mechanisms if bus mastering
is employed? This is what the adapter reports:

        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fdd00000-fddfffff
        Prefetchable memory behind bridge: fdc00000-fdcfffff

I'd have thought that the memory behind the bridge would include any
prefetchable segment. The tuner card happens to registers within that
"0xfdc"-segment too.


> [...]
>
> from /cat/interrupts:
> -----------------------
>  16:       9751          0   IO-APIC-fasteoi   ahci, nvidia, Mantis
>
> [...]


The above shared interrupt assignment is the same for both cases. There
is however a difference how the interrupt link is set up:

Mantis 0000:05:06.0: PCI INT A -> Link[APC1] ... (<-- without bridge)
  vs.
Mantis 0000:04:00.0: PCI INT A -> Link[APC7] ... (<-- with bridge)

Don't know if the different APC# is of any significance here.


Regards,
Dennis
