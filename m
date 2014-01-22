Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:45703 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbaAVNJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 08:09:25 -0500
Received: by mail-we0-f173.google.com with SMTP id t60so293413wes.18
        for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 05:09:24 -0800 (PST)
Received: from [192.168.0.104] (host86-170-10-210.range86-170.btcentralplus.com. [86.170.10.210])
        by mx.google.com with ESMTPSA id eg1sm16213575wib.0.2014.01.22.05.09.22
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 22 Jan 2014 05:09:23 -0800 (PST)
Message-ID: <52DFC300.8010508@googlemail.com>
Date: Wed, 22 Jan 2014 13:09:20 +0000
From: Robert Longbottom <rongblor@googlemail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
References: <52DD977E.3000907@googlemail.com> <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com> <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com> <20140121101950.GA13818@minime.bse> <52DECF44.1070609@googlemail.com> <52DEDFCB.6010802@googlemail.com> <20140122115334.GA14710@minime.bse>
In-Reply-To: <20140122115334.GA14710@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/01/14 11:53, Daniel Glöckner wrote:
> On Tue, Jan 21, 2014 at 08:59:55PM +0000, Robert Longbottom wrote:
>> On 21/01/2014 19:49, Robert Longbottom wrote:
>>> Here are some high-res pictures of both sides of the card.  Scanned at
>>> 600dpi (300dpi the tracks were very close).  Good idea to scan it by the
>>> way, I like that, much better result than with a digital camera.
>>>
>>> http://www.flickr.com/photos/astrofraggle/12073752546/sizes/l/
>>> http://www.flickr.com/photos/astrofraggle/12073651306/sizes/l/
>
>
> ok:
>   - The Atmel chip is an AT24C02 EEPROM. Does one of the 878As have a PCI
>     subsystem ID?

No, I don't see any PCI id's for the of the 878A's (relevant bit of 
lspci -vnn below)

>   - The 74HCT04 is used to drive the clock from the oscillator to the
>     878As.
>
>   - The 74HCT245 is a bus driver for four pins of the connector CN3.
>
>   - The unlabled chip is probably a CPLD/FGPA. It filters the PCI REQ#
>     lines from the 878As and has access to the GNT# and INT# lines,
>     as well as to the GPIOs you mentioned. The bypass caps have a layout
>     that fits to the Lattice ispMACH 4A.

Ah, ok, so this is something to do with interfacing to the PCI bus?

>   - There is no mux or gate between the BNC connectors and the 878As.
>     The BNCs are on MUX0. MUX1 is connected to the two unpopulated 2x5
>     Headers.
>
> So the UNKNOWN/GENERIC card entry should have the BNC connectors on its
> first V4L input.
>
> Have you tried passing pll=35,35,35,35 as module parameter?

I've just had a go at this, modprobe bttv pll=35,35,35,35, and using the 
composite0 input in xawtv (first in the list) and still no joy.  I just 
get the same timeout errors repeating in dmesg:

[63204.009013] bttv: 3: timeout: drop=0 irq=46/26548, risc=3085d000, 
bits: HSYNC OFLOW
[63204.513013] bttv: 3: timeout: drop=0 irq=84/26618, risc=3085d000, 
bits: HSYNC OFLOW
[63205.016045] bttv: 3: timeout: drop=0 irq=121/26689, risc=3085d000, 
bits: HSYNC OFLOW
[63205.519013] bttv: 3: timeout: drop=0 irq=158/26759, risc=3085d000, 
bits: HSYNC OFLOW
[63206.021022] bttv: 3: timeout: drop=0 irq=196/26829, risc=3085d000, 
bits: HSYNC OFLOW

I went through and tried each of the /dev/video[0-4] inputs in turn in 
the hope that one of them had been initialized, but just got the 
timeouts on them all.

I also went back and had another go with  modprobe bttv 
card=133,132,133,133, trying the "132" in each position and testing each 
of the video devices (/dev/video[0-4]) as well in the hope that one 
input got initialized, but no luck there either.

Any more ideas?

I can probably try the card in a Windows machine at the weekend if that 
will provide any helpful information, however I don't have a driver CD 
for it, so it may depend on me finding some drivers....

Thanks,
Rob.


$ lspci -vnn

02:0c.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
         Flags: bus master, medium devsel, latency 32, IRQ 16
         Memory at d5000000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

02:0c.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
         Flags: bus master, medium devsel, latency 32, IRQ 5
         Memory at d5001000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2

02:0d.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
         Flags: bus master, medium devsel, latency 32, IRQ 17
         Memory at d5002000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

02:0d.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
         Flags: bus master, medium devsel, latency 32, IRQ 10
         Memory at d5003000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2

02:0e.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
         Flags: bus master, medium devsel, latency 32, IRQ 18
         Memory at d5004000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

02:0e.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
         Flags: bus master, medium devsel, latency 32, IRQ 10
         Memory at d5005000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2

02:0f.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
         Flags: bus master, medium devsel, latency 32, IRQ 19
         Memory at d5006000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

02:0f.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
         Flags: bus master, medium devsel, latency 32, IRQ 11
         Memory at d5007000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2



