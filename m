Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.sikkerhed.org ([78.109.215.82]:32897 "EHLO
	mail.sikkerhed.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0G0UvA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 16:51:00 -0400
Received: from localhost (mailscan.sikkerhed.org [78.109.215.84])
	by mail.sikkerhed.org (Postfix) with ESMTP id 31A75162EC
	for <linux-media@vger.kernel.org>; Tue, 27 Jul 2010 22:50:59 +0200 (CEST)
Received: from mail.sikkerhed.org ([78.109.215.82])
	by localhost (mailscan.sikkerhed.org [78.109.215.84]) (amavisd-new, port 10024)
	with LMTP id q1n2QXtKr+3o for <linux-media@vger.kernel.org>;
	Tue, 27 Jul 2010 22:50:55 +0200 (CEST)
Received: from [10.0.0.7] (boreas.sikkerhed.org [130.225.166.200])
	by mail.sikkerhed.org (Postfix) with ESMTPSA id 54C8E162BB
	for <linux-media@vger.kernel.org>; Tue, 27 Jul 2010 22:50:55 +0200 (CEST)
Message-ID: <4C4F46AF.8040804@iversen-net.dk>
Date: Tue, 27 Jul 2010 22:50:55 +0200
From: Christian Iversen <chrivers@iversen-net.dk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Unknown CX23885 device
References: <4C4F31A7.8060609@iversen-net.dk> <4C4F3D09.2060405@kernellabs.com>
In-Reply-To: <4C4F3D09.2060405@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	On 2010-07-27 22:09, Steven Toth wrote:
> On 7/27/10 3:21 PM, Christian Iversen wrote:
>> (please CC, I'm not subscribed yet)
>>
>> Hey Linux-DVB people
>>
>> I'm trying to make an as-of-yet unsupported CX23885 device work in Linux.
> 
> http://kernellabs.com/hg/~stoth/cx23885-mpx/
> 
> Try this and if necessary module option card=29.

Without card=29, nothing was found. This is with card=29, but still
no /dev/dvb nodes.

[ 6287.278003] ---- 2010-07-27 22:38:24 ----
[ 6288.248799] Linux video capture interface: v2.00
[ 6288.268106] cx23885 driver version 0.0.2 loaded
[ 6288.268273] cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 6288.268276] cx23885[0]: cx23885_dev_setup() Memory configured for PCIe bridge type 885
[ 6288.268396] CORE cx23885[0]: subsystem: 1461:c139, board: MPX-885 [card=29,insmod option]
[ 6288.268398] cx23885[0]: cx23885_pci_quirks()
[ 6288.268402] cx23885[0]: cx23885_dev_setup() tuner_type = 0x0 tuner_addr = 0x0
[ 6288.268404] cx23885[0]: cx23885_dev_setup() radio_type = 0x0 radio_addr = 0x0
[ 6288.268405] cx23885[0]: cx23885_reset()
[ 6288.368410] cx23885[0]: cx23885_sram_channel_setup() Configuring channel [VID A]
[ 6288.368421] cx23885[0]: cx23885_sram_channel_setup() Erasing channel [ch2]
[ 6288.368423] cx23885[0]: cx23885_sram_channel_setup() Configuring channel [TS1 B]
[ 6288.368436] cx23885[0]: cx23885_sram_channel_setup() Erasing channel [ch4]
[ 6288.368437] cx23885[0]: cx23885_sram_channel_setup() Erasing channel [ch5]
[ 6288.368439] cx23885[0]: cx23885_sram_channel_setup() Configuring channel [TS2 C]
[ 6288.368452] cx23885[0]: cx23885_sram_channel_setup() Configuring channel [TV Audio]
[ 6288.368467] cx23885[0]: cx23885_sram_channel_setup() Erasing channel [ch8]
[ 6288.368469] cx23885[0]: cx23885_sram_channel_setup() Erasing channel [ch9]
[ 6288.399900] cx25840 2-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
[ 6288.404410] cx25840 2-0044: firmware: requesting v4l-cx23885-avcore-01.fw
[ 6289.042011] cx25840 2-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
[ 6289.054227] cx23885[0]: registered device video0 [v4l2]
[ 6289.054244] cx23885[0]: registered device vbi0
[ 6289.054320] cx23885[0]: registered ALSA audio device
[ 6289.068837] cx23885_dev_checkrevision() Hardware revision = 0xb0
[ 6289.068845] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xd7a00000
[ 6289.068855] cx23885 0000:02:00.0: setting latency timer to 64
[ 6289.068859] IRQ 16/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs

What's the preferred method of pulling the source, btw?

I just downloaded a .tar.gz. It works, but updating is not pleasant :)

-- 
Med venlig hilsen
Christian Iversen
