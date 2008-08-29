Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nikolai.lusan@gmail.com>) id 1KZ6rt-0003S4-6c
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 18:30:38 +0200
Received: from [10.10.10.3] (donetsk.home.lusan.id.au [10.10.10.3])
	by kiev.lusan.id.au (Postfix) with ESMTPS id BCC7A7056E1
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 02:30:27 +1000 (EST)
From: Nikolai Lusan <nikolai.lusan@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 30 Aug 2008 02:30:26 +1000
Message-Id: <1220027427.3263.4.camel@donetsk.home.lusan.id.au>
Mime-Version: 1.0
Subject: [linux-dvb] Crashing the EHCI bus
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

Greetings,

I just had an MSI Mega Sky 580 delivered (usbID="0db0:5581" with a gl861
chipset). My research shows this to be supported, how ever when I plug
the thing in to any USB port the bus just dies and takes out all EHCI
devices with it.

The error it puts into to the logs on my backend box is:

[  106.508027] usb 2-6: new high speed USB device using ehci_hcd and address 4
[  106.707185] usb 2-6: configuration #1 chosen from 1 choice
[  106.728881] input: PC-DTV Receiver PC-DTV Receiver as /class/input/input6
[  106.745882] ehci_hcd 0000:00:02.1: HC died; cleaning up
[  106.752086] input,hidraw1: USB HID v1.01 Keyboard [PC-DTV Receiver PC-DTV Receiver] on usb-0000:00:02.1-6
[  106.752230] usb 2-6: New USB device found, idVendor=0db0, idProduct=5581
[  106.752233] usb 2-6: New USB device strings: Mfr=2, Product=3, SerialNumber=4
[  106.752236] usb 2-6: Product: PC-DTV Receiver
[  106.752238] usb 2-6: Manufacturer: PC-DTV Receiver
[  106.752240] usb 2-6: SerialNumber: 00000001
[  106.752245] usb 2-2: USB disconnect, address 2
[  106.940509] usb 2-6: USB disconnect, address 4
[  106.985158] usbcore: registered new interface driver dvb_usb_gl861
[  107.053254] irq 22: nobody cared (try booting with the "irqpoll" option)
[  107.053262] Pid: 2898, comm: modprobe Not tainted 2.6.26-1-amd64 #1
[  107.053264] 
[  107.053265] Call Trace:
[  107.053267]  <IRQ>  [<ffffffff8026c487>] __report_bad_irq+0x30/0x72
[  107.053289]  [<ffffffff8026c6c6>] note_interrupt+0x1fd/0x23b
[  107.053297]  [<ffffffff8026cf4f>] handle_fasteoi_irq+0xa5/0xc8
[  107.053304]  [<ffffffff8020f590>] do_IRQ+0x6d/0xd9
[  107.053308]  [<ffffffff8020c43d>] ret_from_intr+0x0/0x19
[  107.053310]  <EOI> 
[  107.053321] handlers:
[  107.053322] [<ffffffff8038e6b3>] (usb_hcd_irq+0x0/0x78)
[  107.053327] Disabling IRQ #22


I have tried this with all variants of the 2.6.26 kernel series, plus
the DVB drivers from the http://linuxtv.org/hg/~mkrufky mercurial
repository (which my research tells me is where things that should work
might live) and get the same outcome. During this procedure all the
kernel modules get loaded and remain loaded, even though the USB2
interfaces disappear (taking all the other USB2.0 devices with it).

Anyone have any ideas on what might cause this and how to fix it?

Alternately does anyone know of a way to get the damn thing working?

-- 
Nikolai Lusan <nikolai.lusan@gmail.com>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
