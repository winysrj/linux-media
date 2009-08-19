Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.abo.fi ([130.232.213.77]:56320 "EHLO smtp2.abo.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZHSVeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 17:34:44 -0400
Received: from webmail1.abo.fi (webmail1.abo.fi [130.232.213.183])
	by smtp2.abo.fi (8.14.3/8.12.9) with ESMTP id n7JLAu2P011147
	for <linux-media@vger.kernel.org>; Thu, 20 Aug 2009 00:10:56 +0300
Message-ID: <20090820001056.ar4ux62tx0coo0gs@webmail1.abo.fi>
Date: Thu, 20 Aug 2009 00:10:56 +0300
From: dsjoblom@abo.fi
To: linux-media@vger.kernel.org
Subject: Terratec Cinergy C HD tuning problems
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm having some problems with my Terratec Cinergy C PCI DVB-C card. I
installed the mantis driver via DKMS, following the instructions at
http://www.linuxtv.org/wiki/index.php/Mantis_with_DKMS

The card is recognized, and it even works, but after a while
(typically 5 to 20 minutes) the card no longer tunes to any channels
and the scan command no longer works. If I modprobe -r and modprobe -i
the mantis module everything works again for a while, until the same
thing happens. So I assume this is something driver related? Any help
would be appreciated, I will be happy to provide any additional
information if needed.

Some information that may or may not be useful:

uname -a :

Linux ss-home-server 2.6.28-14-server #47-Ubuntu SMP Sat Jul 25
02:03:55 UTC 2009 x86_64 GNU/Linux

lsmod | grep mantis :

mantis                 53892  4
lnbp21                 11008  1 mantis
mb86a16                30464  1 mantis
stb6100                16388  1 mantis
tda10021               15364  1 mantis
tda10023               15748  1 mantis
ir_common              65924  1 mantis
stb0899                45060  1 mantis
stv0299                19720  1 mantis
dvb_core              111792  2 mantis,stv0299

dmesg (after reloading mantis module):

[50413.810181] mantis_core_exit (0): DMA engine stopping
[50413.810185] mantis_dma_exit (0): DMA=0x37940000  
cpu=0xffff880037940000 size=65536
[50413.810191] mantis_dma_exit (0): RISC=0x37953000  
cpu=0xffff880037953000 size=1000
[50413.810195] mantis_hif_exit (0): Adapter(0) Exiting Mantis Host Interface
[50413.810200] mantis_ca_exit (0): Unregistering EN50221 device
[50413.810712] mantis_pci_remove (0): Removing -->Mantis irq: 21, latency: 32
[50413.810714]  memory: 0xd0800000, mmio: 0xffffc200101ce000
[50413.810729] Mantis 0000:02:00.0: PCI INT A disabled
[50414.116512] Mantis 0000:02:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[50414.117498] irq: 21, latency: 32
[50414.117499]  memory: 0xd0800000, mmio: 0xffffc200104fe000
[50414.117502] found a VP-2040 PCI DVB-C device on (02:00.0),
[50414.117504]     Mantis Rev 1 [153b:1178], irq: 21, latency: 32
[50414.117507]     memory: 0xd0800000, mmio: 0xffffc200104fe000
[50414.120219]     MAC Address=[00:08:ca:1e:10:7a]
[50414.120238] mantis_alloc_buffers (0): DMA=0x37940000  
cpu=0xffff880037940000 size=65536
[50414.120245] mantis_alloc_buffers (0): RISC=0xb58a4000  
cpu=0xffff8800b58a4000 size=1000
[50414.120248] DVB: registering new adapter (Mantis dvb adapter)
[50414.670213] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[50414.673722] TDA10023: i2c-addr = 0x0c, id = 0x7d
[50414.673724] mantis_frontend_init (0): found Philips CU1216 DVB-C  
frontend (TDA10023) @ 0x0c
[50414.673727] mantis_frontend_init (0): Mantis DVB-C Philips CU1216  
frontend attach success
[50414.673731] DVB: registering adapter 0 frontend 0 (Philips TDA10023  
DVB-C)...
[50414.673789] mantis_ca_init (0): Registering EN50221 device
[50414.673865] mantis_ca_init (0): Registered EN50221 device
[50414.673874] mantis_hif_init (0): Adapter(0) Initializing Mantis  
Host Interface
[50414.673934] input: Mantis VP-2040 IR Receiver as  
/devices/virtual/input/input11
[50414.840123] Mantis VP-2040 IR Receiver: unknown key: key=0x00  
raw=0x00 down=1
[50414.940104] Mantis VP-2040 IR Receiver: unknown key: key=0x00  
raw=0x00 down=0

/var/log/syslog (when tuning stops working):

kernel: [55125.206428] mantis start feed & dma
kernel: [55125.206633] mantis stop feed and dma
kernel: [55125.206641] mantis start feed & dma
kernel: [55125.206719] mantis stop feed and dma
kernel: [55125.206736] mantis start feed & dma
vdr: [16282] frontend 0 lost lock on channel 80, tp 162
vdr: [16282] frontend 0 timed out while tuning to channel 80, tp 162
kernel: [55141.275154] mantis stop feed and dma
vdr: [16282] frontend 0 timed out while tuning to channel 70, tp 234
kernel: [55168.360122] mantis_ack_wait (0): Slave RACK Fail !
vdr: [16282] frontend 0 timed out while tuning to channel 84, tp 242
vdr: [16282] frontend 0 timed out while tuning to channel 90, tp 250
kernel: [55202.040188] mantis_ack_wait (0): Slave RACK Fail !

Regards,
Daniel Sjöblom

PS. The repository I checked out from
http://mercurial.intuxication.org/hg/s2-liplianin
was (and still is) broken. A bad merge in v4l/Kconfig, lines 3164-3168.


