Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <niemi.jarkko@gmail.com>) id 1KeUw8-0002E8-1r
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 15:13:19 +0200
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id C78238C3C8
	for <linux-dvb@linuxtv.org>; Sat, 13 Sep 2008 16:13:11 +0300 (EEST)
Received: from [81.197.70.192] (e81-197-70-192.elisa-laajakaista.fi
	[81.197.70.192])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id B41054BBB3
	for <linux-dvb@linuxtv.org>; Sat, 13 Sep 2008 16:13:10 +0300 (EEST)
Message-ID: <48CBBC67.8060004@gmail.com>
Date: Sat, 13 Sep 2008 16:13:11 +0300
From: Jarkko Niemi <niemi.jarkko@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] How to change linux kernel module frontend?
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

Card: Azurewave / Twinhan DVB-C AD-CP300 (Mantis 2033) CI PCI
Driver from: http://jusst.de/hg/mantis/

Compiles and installs, after reboot, it can be found as (dmesg extract)

mantis_core_exit (0): DMA engine stopping
mantis_dma_exit (0): DMA=0x7d6c0000 cpu=0xffff81007d6c0000 size=65536
mantis_dma_exit (0): RISC=0x7c346000 cpu=0xffff81007c346000 size=1000
mantis_hif_exit (0): Adapter(0) Exiting Mantis Host Interface
mantis_ca_exit (0): Unregistering EN50221 device
mantis_pci_remove (0): Removing -->Mantis irq: 23, latency: 64
 memory: 0xfd6ff000, mmio: 0xffffc200008ca000
ACPI: PCI interrupt for device 0000:07:06.0 disabled
ACPI: PCI Interrupt 0000:07:06.0[A] -> GSI 23 (level, low) -> IRQ 23
irq: 23, latency: 64
memory: 0xfd6ff000, mmio: 0xffffc200008cc000
found a VP-2033 PCI DVB-C device on (07:06.0),
    Mantis Rev 1 [1822:0008], irq: 23, latency: 64
    memory: 0xfd6ff000, mmio: 0xffffc200008cc000
    MAC Address=[00:08:ca:1c:2c:ba]
mantis_alloc_buffers (0): DMA=0x7d6c0000 cpu=0xffff81007d6c0000 size=65536
mantis_alloc_buffers (0): RISC=0x7d192000 cpu=0xffff81007d192000 size=1000
DVB: registering new adapter (Mantis dvb adapter)
mantis_frontend_init (0): Probing for CU1216 (DVB-C)
TDA10021: i2c-addr = 0x0c, id = 0x7d
mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10021) 
@ 0x0c
mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach 
success
DVB: registering frontend 0 (Philips TDA10021 DVB-C)...
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface

Most propably problem is exactly same than in here
http://www.spinics.net/lists/linux-dvb/msg24184.html

mantis loads wrong frontend (tda10021 instead of tda10023)

> The chip ID is 0x7d. Probably, your card uses a CU1216-3 with a TDA10023. There are 
> differences between the TDA10021 and the TDA10023.

 > Changed the tuner to TDA10023 and it worked like a charm!

main question is:
How to do that change?

Jarkko

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
