Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58DPmRF014550
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 09:25:48 -0400
Received: from web27606.mail.ukl.yahoo.com (web27606.mail.ukl.yahoo.com
	[217.146.177.225])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m58DPTAd026729
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 09:25:30 -0400
Date: Sun, 8 Jun 2008 13:25:23 +0000 (GMT)
From: gsembox-v4l@yahoo.it
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <493332.13184.qm@web27606.mail.ukl.yahoo.com>
Content-Transfer-Encoding: 8bit
Subject: Problems with UCC4 Diginet video card (bt878 based)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I have two UCC4 Diginet card based on an BT878 chip on a Ubuntu 8.04 server linux box (Kernel 2.6.24-16-server)

This card is listed in the http://bttv-gallery.de/ gallery (search UCC4 Ver. 2.0)

The problem is that it recognize my card as *** UNKNOWN/GENERIC ***  [card=0,autodetected]

I see that it is similar to the ProVideo PV143 [card=105,insmod option]
and I append the following line in the modprobe.conf file:

options bttv card=105

I reboot and I see that the first card is good configured, the second is loaded as generic card,
and it loose time to autodetect the type of card.

# dmesg
[   36.326166] bttv: driver version 0.9.17 loaded
[   36.326173] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   36.326275] bttv: Bt8xx card found (0).
[   36.326309] ACPI: PCI Interrupt 0000:01:0e.0[A] -> GSI 18 (level, low) -> IRQ 18
[   36.326324] bttv0: Bt878 (rev 17) at 0000:01:0e.0, irq: 18, latency: 32, mmio: 0xec100000
[   36.326431] bttv0: using: ProVideo PV143 [card=105,insmod option]
[   36.326471] bttv0: gpio: en=00000000, out=00000000 in=00f360ff [init]
[   52.299006] bttv0: tuner absent
[   52.299101] bttv0: registered device video0
[   52.299143] bttv0: registered device vbi0
[   52.299167] bttv0: PLL: 28636363 => 35468950 .. ok
[   52.338970] bttv: Bt8xx card found (1).
[   52.339002] ACPI: PCI Interrupt 0000:01:0f.0[A] -> GSI 17 (level, low) -> IRQ 21
[   52.339018] bttv1: Bt878 (rev 17) at 0000:01:0f.0, irq: 21, latency: 32, mmio: 0xec102000
[   52.339041] bttv1: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[   52.339079] bttv1: gpio: en=00000000, out=00000000 in=00f360ff [init]
[   84.285624] tveeprom 3-0050: Huh, no eeprom present (err=-121)?
[   84.285631] bttv1: tuner type unset
[   84.285635] bttv1: i2c: checking for MSP34xx @ 0x80... not found
[  100.258962] bttv1: i2c: checking for TDA9875 @ 0xb0... not found
[  116.232305] bttv1: i2c: checking for TDA7432 @ 0x8a... not found
[  132.205720] bttv1: registered device video1
[  132.205769] bttv1: registered device vbi1

As you can see it looses 80 sec to autodetect the card. 
How can I see to speed the card recognition ?

May you add this card to bttv-cards.c file ?
Here you are pci data:

# lspci -v

01:0e.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
        Flags: bus master, medium devsel, latency 32, IRQ 18
        Memory at ec100000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

01:0e.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
        Flags: medium devsel, IRQ 18
        Memory at ec101000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

# lspci -vn

01:0e.0 0400: 109e:036e (rev 11)
        Flags: bus master, medium devsel, latency 32, IRQ 18
        Memory at ec100000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

01:0e.1 0480: 109e:0878 (rev 11)
        Flags: medium devsel, IRQ 18
        Memory at ec101000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2


      ___________________________________ 
Scopri il Blog di Yahoo! Mail: trucchi, novità, consigli... e la tua opinione!
http://www.ymailblogit.com/blog/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
