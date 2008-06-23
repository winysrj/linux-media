Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from kelvin.aketzu.net ([81.22.244.161] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <akolehma@aketzu.net>) id 1KAsnF-0008Fo-RB
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 22:37:43 +0200
Date: Mon, 23 Jun 2008 23:37:37 +0300
From: Anssi Kolehmainen <anssi@aketzu.net>
To: linux-dvb@linuxtv.org
Message-ID: <20080623203737.GA19557@aketzu.net>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Terratec Cinergy C PCI (mantis) doesn't work with CAM
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

I have Terratec Cinergy PCI DVB-C (1822:4e35) with CI addon card. Card
works fine with latest mantis drivers from http://jusst.de/hg/mantis
(tip, 7348:0b04be0c088a). Problems start when I plug in Conax CAM and
load mantis module. Sometimes it just hangs the computer and when it
works it cannot tune to channels.

Getting good logs is a bit hard since mantis with verbose=3 hangs
machine when loading module.

Any ideas how to debug/fix this? Why en50221 (?) breaks i2c for
frontend?

$ uname -a
Linux ampere.aketzu.net 2.6.24-1-686 #1 SMP Thu May 8 02:16:39 UTC 2008
i686 GNU/Linux

Kernel logs with CAM inserted:

Jun 23 21:30:07 ampere kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 20
Jun 23 21:30:07 ampere kernel: irq: 20, latency: 32
Jun 23 21:30:07 ampere kernel:  memory: 0xdf000000, mmio: 0xf888e000
Jun 23 21:30:07 ampere kernel: found a VP-2040 PCI DVB-C device on (02:09.0),
Jun 23 21:30:07 ampere kernel:     Mantis Rev 1 [153b:1178], irq: 20, latency: 32
Jun 23 21:30:07 ampere kernel:     memory: 0xdf000000, mmio: 0xf888e000
Jun 23 21:30:07 ampere kernel:     MAC Address=[00:08:ca:1c:87:ea]
Jun 23 21:30:07 ampere kernel: mantis_alloc_buffers (0): DMA=0x306e0000 cpu=0xf06e0000 size=65536
Jun 23 21:30:07 ampere kernel: mantis_alloc_buffers (0): RISC=0x305ae000 cpu=0xf05ae000 size=1000
Jun 23 21:30:07 ampere kernel: DVB: registering new adapter (Mantis dvb adapter)
Jun 23 21:30:07 ampere kernel: mantis_frontend_init (0): Probing for CU1216 (DVB-C)
Jun 23 21:30:07 ampere kernel: mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
Jun 23 21:30:07 ampere kernel: mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
Jun 23 21:30:07 ampere kernel: DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
Jun 23 21:30:07 ampere kernel: mantis_ca_init (0): Registering EN50221 device
Jun 23 21:30:07 ampere kernel: mantis_ca_init (0): Registered EN50221 device
Jun 23 21:30:07 ampere kernel: mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
Jun 23 21:30:12 ampere kernel: dvb_ca adapter 0: DVB CAM detected and initialised successfully
$ scan dvb-c/fi-HTV
Jun 23 21:34:21 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:34:21 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x2a, val == 0x02, ret == -121)
Jun 23 21:34:27 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:34:27 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x2a, val == 0x03, ret == -121)
Jun 23 21:34:33 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:34:33 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x28, val == 0x07, ret == -121)
Jun 23 21:34:39 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:34:39 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x29, val == 0xc0, ret == -121)
Jun 23 21:34:45 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:34:45 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x00, val == 0x23, ret == -121)
Jun 23 21:34:51 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:34:51 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x2a, val == 0x08, ret == -121)
Jun 23 21:34:57 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:34:57 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x1f, val == 0x00, ret == -121)
Jun 23 21:35:03 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:35:03 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:35:09 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:35:09 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0xe6, val == 0x04, ret == -121)
Jun 23 21:35:16 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:35:16 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:35:22 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:35:22 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x10, val == 0x80, ret == -121)
Jun 23 21:35:28 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:35:28 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x0e, val == 0x82, ret == -121)
Jun 23 21:35:34 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:35:34 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:35:40 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:35:40 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x03, val == 0x08, ret == -121)
Jun 23 21:35:46 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:35:46 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:35:52 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:35:52 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x2e, val == 0x30, ret == -121)
Jun 23 21:35:58 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:35:58 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x01, val == 0x30, ret == -121)
Jun 23 21:36:04 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:36:04 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:36:10 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:36:10 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x1e, val == 0x84, ret == -121)
Jun 23 21:36:16 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:36:16 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x1b, val == 0xc8, ret == -121)
Jun 23 21:36:22 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:36:22 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x3b, val == 0xff, ret == -121)
Jun 23 21:36:28 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:36:28 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x3c, val == 0x00, ret == -121)
Jun 23 21:36:34 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:36:34 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x34, val == 0x00, ret == -121)
Jun 23 21:36:40 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:36:40 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x35, val == 0xff, ret == -121)
Jun 23 21:36:46 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:36:46 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x36, val == 0x00, ret == -121)
Jun 23 21:36:52 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:36:52 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x06, val == 0x7f, ret == -121)
Jun 23 21:36:58 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:36:58 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:37:04 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:37:04 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x1c, val == 0x30, ret == -121)
Jun 23 21:37:10 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:37:10 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x37, val == 0xf6, ret == -121)
Jun 23 21:37:15 ampere kernel: mantis_core_exit (0): DMA engine stopping
[Hit ctrl-c]
# rmmod mantis
Jun 23 21:37:15 ampere kernel: mantis_dma_exit (0): DMA=0x306e0000 cpu=0xf06e0000 size=65536
Jun 23 21:37:15 ampere kernel: mantis_dma_exit (0): RISC=0x305ae000 cpu=0xf05ae000 size=1000
Jun 23 21:37:15 ampere kernel: mantis_hif_exit (0): Adapter(0) Exiting Mantis Host Interface
Jun 23 21:37:15 ampere kernel: mantis_ca_exit (0): Unregistering EN50221 device
Jun 23 21:37:16 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:37:16 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x38, val == 0xff, ret == -121)
Jun 23 21:37:22 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:37:22 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x02, val == 0x93, ret == -121)
Jun 23 21:37:28 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:37:28 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x2d, val == 0xf6, ret == -121)
Jun 23 21:37:34 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:37:34 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:37:40 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:37:40 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x04, val == 0x00, ret == -121)
Jun 23 21:37:46 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:37:46 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x12, val == 0xa1, ret == -121)
Jun 23 21:37:52 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:37:52 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:37:58 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:37:58 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x2b, val == 0x01, ret == -121)
Jun 23 21:38:04 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:38:04 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x20, val == 0x04, ret == -121)
Jun 23 21:38:10 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:38:10 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x2c, val == 0x0d, ret == -121)
Jun 23 21:38:16 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:38:16 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0xc4, val == 0x00, ret == -121)
Jun 23 21:38:22 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:38:22 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:38:28 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:38:28 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0xc3, val == 0x00, ret == -121)
Jun 23 21:38:34 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:38:34 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0xb5, val == 0x19, ret == -121)
Jun 23 21:38:40 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:38:40 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:38:46 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:38:46 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x00, val == 0x01, ret == -121)
Jun 23 21:38:52 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:38:52 ampere kernel: DVB: TDA10023: tda10023_readreg: readreg error (ret == -121)
Jun 23 21:38:58 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:38:58 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x00, val == 0x03, ret == -121)
Jun 23 21:39:04 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:39:04 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x1b, val == 0x02, ret == -121)
Jun 23 21:39:10 ampere kernel: mantis_ack_wait (0): Slave RACK Fail !
Jun 23 21:39:10 ampere kernel: DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x00, val == 0x80, ret == -121)
Jun 23 21:39:10 ampere kernel: mantis_pci_remove (0): Removing -->Mantis irq: 20, latency: 32
Jun 23 21:39:10 ampere kernel:  memory: 0xdf000000, mmio: 0xf888e000
Jun 23 21:39:10 ampere kernel: ACPI: PCI interrupt for device 0000:02:09.0 disabled

Without CAM inserted logs are same (but no "CAM detected" and error
messages).

-- 
Anssi Kolehmainen
anssi.kolehmainen@iki.fi
040-5085390

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
