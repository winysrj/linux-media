Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1K3ZeB-0004k1-22
	for linux-dvb@linuxtv.org; Tue, 03 Jun 2008 18:46:07 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1139437fga.25
	for <linux-dvb@linuxtv.org>; Tue, 03 Jun 2008 09:46:02 -0700 (PDT)
Message-ID: <48457545.6060509@gmail.com>
Date: Tue, 03 Jun 2008 18:45:57 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
From: e9hack <e9hack@googlemail.com>
Subject: [linux-dvb] [BUG] Firmware loading of FF cards is broken
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

Hi,

changsets 7973/7958 break the firmware loading of the TT-C2300 card. I get the following 
message:

Linux video capture interface: v2.00
saa7146: register extension 'dvb'.
ACPI: PCI Interrupt 0000:04:06.0[A] -> Link [LNKA] -> GSI 18 (level, low) -> IRQ 21
saa7146: found saa7146 @ mem f98f6c00 (revision 1, irq 21) (0x13c2,0x000a).
dvb-ttpci: crc32 of dpram file does not match.
ACPI: PCI interrupt for device 0000:04:06.0 disabled

It seems, that get_unaligned_be32() is broken. The definition in compat.h is:

#define get_unaligned_be32(a)                                   \
         be32_to_cpu(get_unaligned((unsigned short *)(a)))

'unsigned short *' is wrong. It should be 'unsigned long *'.

put_unaligned_be32(), get_unaligned_le32() and put_unaligned_le32() are also wrong.

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
