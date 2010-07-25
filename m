Return-path: <linux-media-owner@vger.kernel.org>
Received: from fb2.tech.numericable.fr ([82.216.111.50]:41251 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0GYV5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jul 2010 17:57:37 -0400
Received: from smtp2.tech.numericable.fr (smtp2.nc.sdv.fr [10.0.0.36])
	by fb2.tech.numericable.fr (Postfix) with ESMTP id 897F119460
	for <linux-media@vger.kernel.org>; Sun, 25 Jul 2010 23:57:36 +0200 (CEST)
Received: from rubedo.localnet (89-156-199-138.rev.numericable.fr [89.156.199.138])
	by smtp2.tech.numericable.fr (Postfix) with ESMTP id 5556818D80D
	for <linux-media@vger.kernel.org>; Sun, 25 Jul 2010 23:56:46 +0200 (CEST)
To: linux-media@vger.kernel.org
Subject: 2 problems with HVR-1300
From: Robert Grasso <robert.grasso@modulonet.fr>
Date: Sun, 25 Jul 2010 23:56:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201007252356.44996.robert.grasso@modulonet.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, 

I am not a developer - this is a support request about (probably) the cx88* driver - if I am mistaking, please can somebody point me toward the correct list ?

I have an Asus P5K MB, architecture x86_64, under Ubuntu 10.04, but I just tested my hardware with a Fedora 13 Live CD, I have the same problems; I bought some months ago an HVR-1300, in order to use the mpeg encoder on the board.

>From the moment I installed the card, I use to have two problems :
- the boot stalls often, at some moment around the local disk mount; and a simple Reset or Power off/Power on, often are not sufficient. Now it's getting pretty annoying, especially because it's a random issue, BUT a frequent one; it makes me think of a race condition into the new Upstart parallel structure for the services startup at boot. But with the HVR-1300 unplugged the boot performs correctly !

- I have a TV decoder shipped by my TV provider, so I don't change the channels on the HVR-1300 but on the decoder; thus I use to watch TV in this simple way :

mplayer -vc mpeg12 -nocache /dev/video2 (mplayer /dev/video2 works as well, but with some glitches)

BUT : just after booting, /dev/video2 does not output any TV image; so I found a workaround : I start :

xawtv  -c  /dev/video1

then stop it, and restart mplayer again : and THEN the TV image is pretty good.

I noticed these two problems with Ubuntu 10.04, AND a Fedora 13 Live CD (both for x86_64)

I installed Windows 7 in a small partition, and I had none of my problems with w7, after having installed the HVR-1300  driver for w7

Browsing the forums and mailing-lists, I found that my problem could be an interruption problem : actually, I noticed many such messages these days in the logs :

kernel: [   16.191887] IRQ 18/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs

=> The  board is sharing interruptions with the usb controller :

I dumped my /proc/interrupts below.

I tried to plug the HVR-1300 into another PCI connecteor, unsuccessfully - just the IRQ changed from 18 to 17 ....

And I did not find many cx88* options I could tune.

Does anybody have a hint ?

Best regards

-- 
Robert Grasso
@home
---
UNIX was not designed to stop you from doing stupid things, because 
  that would also stop you from doing clever things. -- Doug Gwyn


root@power4:/var/log# cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
  0:         34          0          3          7   IO-APIC-edge      timer
  1:       2665        382       3605       2603   IO-APIC-edge      i8042
  3:          0          1          1          0   IO-APIC-edge    
  6:          3          1          1          0   IO-APIC-edge      floppy
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 16:         99         33       8038       5178   IO-APIC-fasteoi   uhci_hcd:usb3, ahci, ohci1394, nvidia
 17:          0          0          0          0   IO-APIC-fasteoi   pata_jmicron
 18:       1778       1451     267154     574840   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb5, uhci_hcd:usb8, cx88[0], cx88[0], cx88[0]
 19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb7
 21:       3138        733      12459       8031   IO-APIC-fasteoi   uhci_hcd:usb4
 22:       2472       2492     375325     281407   IO-APIC-fasteoi   ata_piix, ata_piix, HDA Intel
 23:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
 28:         45    3070681         36         30   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:    1632911     483726    1571132     439543   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
PND:          0          0          0          0   Performance pending work
RES:     139483     197008     137355     218213   Rescheduling interrupts
CAL:     365176       3436       6505       4918   Function call interrupts
TLB:      91270     115813      94117     185414   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:         16         16         16         16   Machine check polls
ERR:          3
MIS:          0

