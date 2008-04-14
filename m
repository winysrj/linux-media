Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hs-out-0708.google.com ([64.233.178.247])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rvm3000@gmail.com>) id 1JlMKN-0001tS-82
	for linux-dvb@linuxtv.org; Mon, 14 Apr 2008 12:54:28 +0200
Received: by hs-out-0708.google.com with SMTP id 4so389646hsl.1
	for <linux-dvb@linuxtv.org>; Mon, 14 Apr 2008 03:54:18 -0700 (PDT)
Message-ID: <f474f5b70804140354o4e8a9ee5he60cbb1206412227@mail.gmail.com>
Date: Mon, 14 Apr 2008 12:54:17 +0200
From: rvm <rvm3000@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] What could happened to my TV card?
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

This happened to me some time ago (more than a year), but I was
wondering if you could help me to know what happened to my TV card.

This was an analog TV card (bt878) connected to a PCI slot. It worked
ok until one day it stopped working.

This is from /var/log/messages when it worked ok:

kernel: Linux video capture interface: v1.00
kernel: bttv: driver version 0.9.15 loaded
kernel: bttv: using 8 buffers with 2080k (520 pages) each for capture
kernel: bttv: Host bridge needs ETBF enabled.
kernel: bttv: Host bridge needs VSFX enabled.
kernel: bttv: Bt8xx card found (0).
kernel: ACPI: PCI interrupt 0000:00:0c.0[A] -> GSI 10 (level, low) -> IRQ 10
kernel: bttv0: Bt878 (rev 17) at 0000:00:0c.0, irq: 10, latency: 64,
mmio: 0xdbe00000
bttv0: using: Askey CPH061/ BESTBUY Easy TV (bt878) [card=62,insmod option]

One day, it seems after I connected a USB bluetooth adapter to the
computer, a lot of error messages appeared in the log:

kernel: Bluetooth: HCI USB driver ver 2.7
kernel: usbcore: registered new driver hci_usb
hcid[5403]: HCI dev 0 registered
hcid[5403]: HCI dev 0 up
hcid[5403]: Starting security manager 0
sdpd[9918]: init_server: binding L2CAP socket: Address already in use
sdpd[9918]: main: Server initialization failed
kernel: Bluetooth: RFCOMM ver 1.3
kernel: Bluetooth: RFCOMM socket layer initialized
kernel: Bluetooth: RFCOMM TTY layer initialized
kernel: bttv0: IRQ lockup, cleared int mask [bits: HSYNC* PPERR]
last message repeated 776 times
kernel: bttv0: IRQ lockup, cleared int mask [bits: HSYNC* PPERR]
last message repeated 2820 times
kernel: bttv0: IRQ lockup, cleared int mask [bits: VSYNC HSYNC* PPERR]
kernel: bttv0: IRQ lockup, cleared int mask [bits: HSYNC* PPERR]
last message repeated 986 times
kernel: bttv0: IRQ lockup, cleared int mask [bits: HSYNC* PPERR]
last message repeated 2302 times
kernel: bttv0: IRQ lockup, cleared int mask [bits: HSYNC* PPERR]
last message repeated 769 times
kernel: bttv0: IRQ lockup, cleared int mask [bits: HSYNC* PPERR]
last message repeated 578 times

After a reboot this appeared in /var/log/messages:

kernel: Linux video capture interface: v1.00
kernel: bttv: driver version 0.9.15 loaded
kernel: bttv: using 8 buffers with 2080k (520 pages) each for capture
kernel: bttv: Host bridge needs ETBF enabled.
kernel: bttv: Host bridge needs VSFX enabled.
kernel: bttv: Bt8xx card found (0).
kernel: PCI: Device 0000:00:0c.0 not available because of resource collisions
kernel: bttv0: Can't enable device.
kernel: bttv: probe of 0000:00:0c.0 failed with error -5

After that the card is not recognized anymore:

kernel: Linux video capture interface: v1.00
kernel: bttv: driver version 0.9.15 loaded
kernel: bttv: using 8 buffers with 2080k (520 pages) each for capture
kernel: bttv: Host bridge needs ETBF enabled.
kernel: bttv: Host bridge needs VSFX enabled.

On the other hand, Windows on startup detected new hardware (a
multimedia device) but it wasn't able to configure it. (So in the end
I removed the card from the computer)

What could happen? Did it break? Maybe the bios disabled for some reason?

Another strange thing: my computer has two free PCI slots. In the
first one (originally used by a soft modem) this TV card never worked,
it wasn't recognized at all (by both linux and windows). In the 2nd
slot it worked, until the day it stopped working.

-- 
RVM

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
