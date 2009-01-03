Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from as3.mail.mho.net ([64.58.4.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mlnx@mho.com>) id 1LJ950-0005oV-DM
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 17:10:29 +0100
Received: from smtp.mho.com (localhost [127.0.0.1])
	by as3.mail.mho.net (Spam Firewall) with SMTP id 31DF722E552D
	for <linux-dvb@linuxtv.org>; Sat,  3 Jan 2009 09:10:20 -0700 (MST)
Received: from smtp.mho.com (a.smtp.mho.net [64.58.4.6]) by as3.mail.mho.net
	with SMTP id l5Xg4p3lT9spQRPs for <linux-dvb@linuxtv.org>;
	Sat, 03 Jan 2009 09:10:20 -0700 (MST)
Message-ID: <495F8DEB.9040100@mho.com>
Date: Sat, 03 Jan 2009 09:10:19 -0700
From: Mike Adolf <mlnx@mho.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] cx88[0] irq loop problem
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

Hi

cx88[0] is causing the following dmesg errors. Is this because cx88[0] appears 3 times for irq 17?

----------------------------------------
dmesg is full of this:

   38.529786] cx88[0]: irq aud [0x1001] dn_risci1* dn_sync*
[   38.529794] cx88[0]: irq aud [0x1001] dn_risci1* dn_sync*
[   38.529803] cx88[0]: irq aud [0x1001] dn_risci1* dn_sync*
[   38.529808] cx88[0]/1: IRQ loop detected, disabling interrupts
[   38.531168] cx88[0]: irq aud [0x1001] dn_risci1* dn_sync*
[   38.541064] cx88[0]: irq aud [0x1001] dn_risci1* dn_sync*
---------------------------------------
My irq assignments are:

          CPU0       CPU1       0:        164          0   
IO-APIC-edge      timer
 1:          2          0   IO-APIC-edge      i8042
 8:         46          0   IO-APIC-edge      rtc0
 9:          0          0   IO-APIC-fasteoi   acpi
12:          4          0   IO-APIC-edge      i8042
16:      54478          0   IO-APIC-fasteoi   uhci_hcd:usb1, nvidia
17:      91099          0   IO-APIC-fasteoi   uhci_hcd:usb2, 
uhci_hcd:usb5, cx88[0], cx88[0], cx88[0]
18:       1778          0   IO-APIC-fasteoi   uhci_hcd:usb6
19:       1277          0   IO-APIC-fasteoi   CMI8738-MC6
22:          2          0   IO-APIC-fasteoi   ehci_hcd:usb3
23:      13510          0   IO-APIC-fasteoi   uhci_hcd:usb4, ehci_hcd:usb7
219:       1665          0   PCI-MSI-edge      eth0
220:      21571          0   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:      30119      26028   Local timer interrupts
RES:       2397       1806   Rescheduling interrupts
CAL:       3743       3190   function call interrupts
TLB:        424        811   TLB shootdowns
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

-------------------------------------------

Mike



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
