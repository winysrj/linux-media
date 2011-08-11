Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:39281 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750741Ab1HKOjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 10:39:15 -0400
Message-ID: <4E43E98F.9030808@gmx.net>
Date: Thu, 11 Aug 2011 16:39:11 +0200
From: "MadLoisae@gmx.net" <MadLoisae@gmx.net>
Reply-To: MadLoisae@gmx.net
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: saa7146 interrupt problems with "threadirqs" in kernel command line
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

if I define "threadirqs" in kernel command line my PCI-DVB-C card 
constantly logs interrupt problems in dmesg like this:
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
DVB: TDA10021(0): _tda10021_writereg, writereg error (reg == 0x03, val 
== 0x0a, ret == -5)
DVB: TDA10021: tda10021_readreg: readreg error (ret == -5)
tda10021: lock tuner fails
saa7146 (0) vpeirq: used 1 times >80% of buffer (1281972 bytes now)

The effect is a not working DVB-stream. :-/

I've already increased the buffer size of the budged_core module:
cat /etc/modprobe.d/budget_core.conf
options budget_core bufsize=1410

dmesg on initializing the DVB-card:
budget_av 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
saa7146: found saa7146 @ mem f8b00000 (revision 1, irq 16) (0x153b,0x1156).
saa7146 (0): dma buffer size 1347584
DVB: registering new adapter (Terratec Cinergy 1200 DVB-C)
adapter failed MAC signature check
encoded MAC from EEPROM was 
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
KNC1-0: MAC addr = 00:0a:ac:01:da:a5
TDA10021: i2c-addr = 0x0c, id = 0x7c
DVB: registering adapter 0 frontend 0 (Philips TDA10021 DVB-C)...
budget-av: ci interface initialised.

As soon as I remove the threadirqs statement from kernel command line 
the card works well.

Is the driver not yet ready for threadirqs? I am running latest stable 
linux kernel 3.0.1.

Thanks for any hints.

Alois
