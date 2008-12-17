Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from saturn.adsl24.co.uk ([84.234.17.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <john@sager.me.uk>) id 1LCxsO-0001UU-8o
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 15:59:53 +0100
Received: from [78.32.116.227] (helo=gateway.wc)
	by saturn.adsl24.co.uk with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69) (envelope-from <john@sager.me.uk>) id 1LCxrn-0002zM-B9
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 14:59:15 +0000
Received: from [192.168.241.65] by gateway.wc with esmtp (Exim 4.60)
	(envelope-from <john@sager.me.uk>) id 1LCxrn-0005bx-Rq
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 14:59:15 +0000
Message-ID: <494913C4.9060704@sager.me.uk>
Date: Wed, 17 Dec 2008 14:59:16 +0000
From: John Sager <john@sager.me.uk>
MIME-Version: 1.0
To: LinuxTV-DVB <linux-dvb@linuxtv.org>
Subject: [linux-dvb] pci_abort messages from cx88 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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

This seems to have cropped up sporadically on mailing lists and fora,
with no real resolution indicated. I have just bought a Hauppauge
WinTV-NOVA-HD-S2 card (recognised as HVR4000(Lite)) which exhibits
this problem in my system. I'm running Mythbuntu 8.10 on a quad core
Intel-based system - P35/ICH9 chipset - with the v4l-dvb drivers
cloned on 16th December. I don't get the problem on first start-up,
but if I change channels it starts to appear. However it does seem to
stop sometimes on channel change. I suspect the problem is either some
kind of race condition between the Intel & Conexant PCI controllers, or
some kind of missed or wrong step in chip reconfiguration after a channel
change.

When this error occurs, the standard behaviour of the code in cx88-mpeg.c
is to stop the DMA current transfer & then restart the queue. This drops
data, leading to blocky visuals & sound glitches. As an experiment, I
changed the test for general errors in cx8802_mpeg_irq() to ignore the
pci_abort error (change 0x1f0100 to 0x170100), and this completely
eliminates the dropped data problem. This suggests that the pci transfers
complete properly and the pci_abort status is a spurious indication.
I also fixed the mask in the test for cx88_print_irqbits() to stop these
messages filling up the log (change ~0xff to ~0x800ff).

It may be worth fixing this in the main code to hide the problem for
unfortunate users of this & related cards until the real problem is
found. Unfortunately I doubt I can help there as a detailed knowledge
of the Conexant PCI interface device is probably required to pursue it.

regards,

John

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
