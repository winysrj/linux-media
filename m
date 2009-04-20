Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:62286 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZDTQzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 12:55:13 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KIE00DQ4SBI1SE0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 20 Apr 2009 12:54:55 -0400 (EDT)
Date: Mon, 20 Apr 2009 12:54:53 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
In-reply-to: <1240245715.5388.126.camel@mountainboyzlinux0>
To: linux-media@vger.kernel.org
Message-id: <49ECA8DD.9090708@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <23cedc300904170207w74f50fc1v3858b663de61094c@mail.gmail.com>
 <BAY102-W34E8EA79DEE83E18177655CF7B0@phx.gbl> <49E9C4EA.30706@linuxtv.org>
 <loom.20090420T150829-849@post.gmane.org> <49EC9A08.50603@linuxtv.org>
 <1240245715.5388.126.camel@mountainboyzlinux0>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Benster & Jeremy wrote:
> Here is the relevant part of dmesg output:
> ....snip....
> [   18.088998] Linux video capture interface: v2.00
> ....snip....
> [   18.455776] cx23885 driver version 0.0.1 loaded
> [   18.459188] ACPI: PCI Interrupt Link [LK2E] enabled at IRQ 17
> [   18.459205] cx23885 0000:01:00.0: PCI INT A -> Link[LK2E] -> GSI 17 
> (level, high) -> IRQ 17
> [   18.461662] CORE cx23885[0]: subsystem: 0070:7717, board: Hauppauge 
> WinTV-HVR1500 [card=6,autodetected]
> [   18.570050] cx23885[0]: i2c bus 0 registered
> [   18.570196] cx23885[0]: i2c bus 1 registered
> [   18.570252] cx23885[0]: i2c bus 2 registered
> [   18.596795] tveeprom 2-0050: Hauppauge model 77001, rev D3C0, serial# 
> 1624435
> [   18.596800] tveeprom 2-0050: MAC address is 00-0D-FE-18-C9-73
> [   18.596803] tveeprom 2-0050: tuner model is Xceive XC3028 (idx 120, 
> type 71)
> [   18.596807] tveeprom 2-0050: TV standards NTSC(M) ATSC/DVB Digital 
> (eeprom 0x88)
> [   18.596810] tveeprom 2-0050: audio processor is CX23885 (idx 39)
> [   18.596813] tveeprom 2-0050: decoder processor is CX23885 (idx 33)
> [   18.596816] tveeprom 2-0050: has no radio
> [   18.596818] cx23885[0]: hauppauge eeprom: model=77001
> [   18.596822] cx23885[0]: cx23885 based dvb card
> ....snip....
> [   18.765151] phy0: Selected rate control algorithm 'pid'
> [   18.801503] xc2028 3-0061: creating new instance
> [   18.801509] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
> [   18.801517] DVB: registering new adapter (cx23885[0])
> [   18.801522] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB 
> Frontend)...
> [   18.802148] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [   18.802157] cx23885[0]/0: found at 0000:01:00.0, rev: 2, irq: 17, 
> latency: 0, mmio: 0xc4000000
> [   19.802164] cx23885 0000:01:00.0: setting latency timer to 64
> 
> and lspci:
> 
> ....snip....
> #I'm leaving this in since it mentions i2c
> 00:0a.1 0c05: 10de:0264 (rev a3)
> Subsystem: 103c:30b7
> Flags: 66MHz, fast devsel, IRQ 10
> I/O ports at 3040 [size=64]
> I/O ports at 3000 [size=64]
> Capabilities: [44] Power Management version 2
> Kernel driver in use: nForce2_smbus
> Kernel modules: i2c-nforce2
> ....snip....
> 01:00.0 0400: 14f1:8852 (rev 02)
> Subsystem: 0070:7717
> Flags: bus master, fast devsel, latency 0, IRQ 17
> Memory at c4000000 (64-bit, non-prefetchable) [size=2M]
> Capabilities: [40] Express Endpoint, MSI 00
> Capabilities: [80] Power Management version 2
> Capabilities: [90] Vital Product Data <?>
> Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 
> Enable-
> Capabilities: [100] Advanced Error Reporting <?>
> Capabilities: [200] Virtual Channel <?>
> Kernel driver in use: cx23885
> Kernel modules: cx23885
> ....snip....
> 07:05.4 0880: 1180:0852 (rev ff) (prog-if ff)
> !!! Unknown header type 7f
> ....snip....
> 
> I think I may not have the debug=1 options turned on right now. I will 
> turn them on and re-post if that would help you.
> 
> Ben
> 
> On Mon, 2009-04-20 at 11:51 -0400, Steven Toth wrote:
>> Ben Heggy wrote:
>> > I'm having the same issues (recognized - but won't turn on) with the same card
>> > and would be delighted to join the open discussion and to try to help to provide
>> > any information necessary to debug this issue. 
>> > 
>> > To this point, I have enabled debug options on what I think are the related
>> > modules and have seen nothing that appears to be an error, but am also noticing
>> > that there should be some messages about loading firmware for the various chips
>> > and they don't appear (I did put the firmware files in /lib/firmware but I
>> > cannot find references to their correct md5sums to verify they are correct)
>> > 
>> > I'm a newbie to linux, but was once (20 years ago) a system manager on a
>> > vax/unix system, so I can find my way around a bit better than average.
>> > 
>> > Tell me what info you want to see or what actions to try and I will gladly act
>> > immediately.
>>
>> Connect the card.
>>
>> Cold boot the system, boot linux, use the dmesg command.
>>
>> Do you see any evidence of the cx23885 driver recognizing your card?
>>
>> Use the lspci -vn command to display attached PCI(e) devices, is the card present?
>>
>> - Steve

(A minor thing, please don't top post. Replies go under the previous messages - 
that's mailing list protocol)

Thanks, initialization looks good.

Step 2. What happens when you try to use azap and what does syslog subsequently 
look like?

- Steve
