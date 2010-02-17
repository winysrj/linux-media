Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <peter@preacher.se>) id 1NhgWB-00082Y-QJ
	for linux-dvb@linuxtv.org; Wed, 17 Feb 2010 10:48:28 +0100
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1NhgW8-0005T4-0u; Wed, 17 Feb 2010 10:48:24 +0100
Received: from c83-248-128-49.bredband.comhem.se ([83.248.128.49]:40310
	helo=mail.preacher.se)
	by ch-smtp01.sth.basefarm.net with esmtp (Exim 4.68)
	(envelope-from <peter@preacher.se>) id 1NhgVD-0005zP-3y
	for linux-dvb@linuxtv.org; Wed, 17 Feb 2010 10:47:29 +0100
Received: from [130.241.27.49] (ltsp-vir-1.it.gu.se [130.241.27.49])
	(using SSLv3 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.preacher.se (Postfix) with ESMTP id 8C8C6B3716
	for <linux-dvb@linuxtv.org>; Wed, 17 Feb 2010 10:47:12 +0100 (CET)
From: Peter <peter@preacher.se>
To: linux-dvb@linuxtv.org
Date: Wed, 17 Feb 2010 10:47:09 +0100
Message-ID: <1266400029.15203.29.camel@ltsp-vir-1.it.gu.se>
Mime-Version: 1.0
Subject: [linux-dvb] Problem with two pci Technotrend C-2300
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi,

I have two Technotrend C-2300 cards which uses the dvb-ttpci driver.
Both cards have been working fine until I recently switched motherboard
from a regular ATX-board to a micro-ATX ASUS M4A785D-M PRO.

After this only one of the cards is working properly, the other has no
entries in /dev/dvb and is thus unusable.

When trying to load the module I get a bunch of these errors in my log:

> dvb-ttpci: adac type set to 0 @ card 0
> saa7146_vv: saa7146 (0): registered device video0 [v4l2]
> saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
> saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> stv0297_readreg: readreg error (reg == 0x80, ret == -5)
> dvb-ttpci: A frontend driver was not found for device [1131:7146] subsystem [13c2:000a]
> dvb 0000:03:05.0: PCI INT A disabled
> dvb 0000:03:06.0: PCI INT A -> Link[LNKF] -> GSI 10 (level, low) -> IRQ 10


lspci -vv gives this (notice driver in use is only active for one of the cards):

> 03:05.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: Technotrend Systemtechnik GmbH Octal/Technotrend DVB-C for iTV
>         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at febffc00 (32-bit, non-prefetchable) [size=512]
>         Kernel modules: dvb-ttpci
> 
> 03:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: Technotrend Systemtechnik GmbH Octal/Technotrend DVB-C for iTV
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64 (3750ns min, 9500ns max)
>         Interrupt: pin A routed to IRQ 10
>         Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=512]
>         Kernel driver in use: dvb
>         Kernel modules: dvb-ttpci

I have tried to permute the cards in the slots, but the problem remains.
I have also switched my PSU to a brand new one without any difference.

I have updated the bios for the motherboard to the latest one without
any difference.

Googling for errors like these I came across an old thread, specifically
this message:
http://www.mail-archive.com/linux-dvb@linuxtv.org/msg25731.html

Could it be the case that this motherboard cannot supply enough power to
both pci-buses? Or could it (hopefully) be some other error that may be
fixed?

What can I do to solve or diagnose this further? Load some of the
dvb-modules with debug or try any other special options?

Grateful for any help!
Thanks,
Peter Hall


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
