Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.orange.fr ([80.12.242.46]:45436 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbZBYPyw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 10:54:52 -0500
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2103.orange.fr (SMTP Server) with ESMTP id 25F511C000A3
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2009 16:54:47 +0100 (CET)
Received: from [192.168.0.1] (AVelizy-151-1-45-38.w82-124.abo.wanadoo.fr [82.124.123.38])
	by mwinf2103.orange.fr (SMTP Server) with ESMTP id C7DE91C00097
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2009 16:54:46 +0100 (CET)
Message-ID: <49A569C6.2060603@libertysurf.fr>
Date: Wed, 25 Feb 2009 16:54:46 +0100
From: Catimimi <catimimi@libertysurf.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [linux-media] Pinnacle PCTV 310i Resource conflict 
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently switched to openSUSE 11.1 and kernel 2.6.27.7. From that time
I get the following warning at boot.
I didn't get the problem with openSUSE 11.0 and kernel 2.6.25.20
It occurs in 64 bits and 32 bits.

Bestbregards.
Michel.

____________________________________________________________________________________________


<6>saa7130/34: v4l2 driver version 0.2.14 loaded
<6>vendor=8086 device=244e
<6>saa7134 0000:01:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
<6>saa7133[0]: found at 0000:01:02.0, rev: 208, irq: 23, latency: 64,
mmio: 0xddcfb000
<6>saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i
[card=101,autodetected]
<4>resource map sanity check conflict  0xddcfb000 0xddcfbfff 0xddcfb000
0xddcfb7ff 0000:01:02.0
<4>------------[ cut here ]------------
<4>WARNING: at arch/x86/mm/ioremap.c:156 __ioremap_caller+0xc8/0x369()
<4>Modules linked in: saa7134(N+) ir_common(N) snd_hda_intel(N)
stir4200(N+) usbhid(N+) snd_pcm(N) btusb(N+) v4l2_common(N)
gspca_zc3xx(N+) hid(N) ircomm_tty(N) ircomm(N) gspca_main(N)
snd_timer(N) videobuf_dma_sg(N) cdc_acm(N) osst(N) ff_memless(N)
snd_page_alloc(N) iTCO_wdt(N) rtc_cmos(N) ppdev(N) irda(N) snd_hwdep(N)
bluetooth(N) nvidia(PN) compat_ioctl32(N) videobuf_core(N) rtc_core(N)
ohci1394(N) crc_ccitt(N) snd(N) sr_mod(N) tveeprom(N) parport_pc(N)
videodev(N) i2c_i801(N) iTCO_vendor_support(N) usb_storage(N) rtc_lib(N)
pcspkr(N) skge(N) button(N) cdrom(N) ieee1394(N) st(N) i2c_core(N)
parport(N) e1000e(N) soundcore(N) v4l1_compat(N) sg(N) uhci_hcd(N)
ehci_hcd(N) sd_mod(N) crc_t10dif(N) usbcore(N) aic7xxx(N)
scsi_transport_spi(N) sata_sil24(N) edd(N) ext3(N) mbcache(N) jbd(N)
fan(N) ide_pci_generic(N) piix(N) ide_core(N) ata_generic(N) ata_piix(N)
thermal(N) processor(N) thermal_sys(N) hwmon(N) ahci(N) libata(N)
scsi_mod(N) dock(N)
<4>Supported: No
<4>Pid: 1158, comm: modprobe Tainted: P          2.6.27.7-9-default #1
<4>
<4>Call Trace:
<4> [<ffffffff8020e3fe>] show_trace_log_lvl+0x41/0x58
<4> [<ffffffff8049f48d>] dump_stack+0x69/0x6f
<4> [<ffffffff802405e2>] warn_on_slowpath+0x51/0x77
<4> [<ffffffff802284d4>] __ioremap_caller+0xc8/0x369
<4> [<ffffffffa0bb04f9>] saa7134_initdev+0x429/0x964 [saa7134]
<4> [<ffffffff803782ff>] pci_device_probe+0xb8/0x105
<4> [<ffffffff803ead7a>] driver_probe_device+0x164/0x26c
<4> [<ffffffff803eaec8>] __driver_attach+0x46/0x6d
<4> [<ffffffff803ea485>] bus_for_each_dev+0x44/0x78
<4> [<ffffffff803e9d6b>] bus_add_driver+0xef/0x235
<4> [<ffffffff803eb08c>] driver_register+0xa2/0x11f
<4> [<ffffffff803785a7>] __pci_register_driver+0x5d/0x8e
<4> [<ffffffff80209041>] _stext+0x41/0x11d
<4> [<ffffffff80264cad>] sys_init_module+0xa0/0x1ba
<4> [<ffffffff8020c34a>] system_call_fastpath+0x16/0x1b
<4> [<00007fe1f2f9f76a>] 0x7fe1f2f9f76a
<4>
<4>---[ end trace baec8626d451a75c ]---
<6>saa7133[0]: board init: gpio is 600e000
<6>saa7133[0]: i2c eeprom 00: bd 11 2f 00 54 20 1c 00 43 43 a9 1c 55 d2
b2 92
<6>saa7133[0]: i2c eeprom 10: ff e0 60 06 ff 20 ff ff 00 30 8d 2c 5d b4
ff ff
<6>saa7133[0]: i2c eeprom 20: 01 2c 01 02 02 01 04 30 98 ff 00 a5 ff 21
00 c2
<6>saa7133[0]: i2c eeprom 30: 96 10 03 32 15 20 ff ff 0c 22 17 88 03 2a
57 bf
<6>saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
<6>saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff

_________________________________________________________________________________________________


