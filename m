Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m451ME1V011916
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 21:22:14 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m451M28a011346
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 21:22:02 -0400
Received: by ug-out-1314.google.com with SMTP id s2so298uge.6
	for <video4linux-list@redhat.com>; Sun, 04 May 2008 18:22:01 -0700 (PDT)
Date: Mon, 5 May 2008 11:22:09 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080505112209.1cfb2602@glory.loctelecom.ru>
In-Reply-To: <Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080414172821.3966dfbf@areia>
	<20080415125059.3e065997@glory.loctelecom.ru>
	<20080415000611.610af5c6@gaivota>
	<20080415135455.76d18419@glory.loctelecom.ru>
	<20080415122524.3455e060@gaivota>
	<20080422175422.3d7e4448@glory.loctelecom.ru>
	<20080422130644.7bfe3b2d@gaivota>
	<20080423124157.1a8eda0a@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804222254350.20809@bombadil.infradead.org>
	<20080423160505.36064bf7@glory.loctelecom.ru>
	<20080423113739.7f314663@gaivota>
	<20080424093259.7880795b@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Beholder TV/FM cards
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

Hi

A few days modules crashed after I installed Columbus PCMCIA card.
kernel 2.6.24
v4l last

It happens after update 2 week a go.

dmesg:

pccard: CardBus card inserted into slot 0
tveeprom: no version for "struct_module" found: kernel tainted.
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
PCI: Enabling device 0000:07:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 17 (level, low) -> IRQ 16
saa7133[0]: found at 0000:07:00.0, rev: 209, irq: 16, latency: 0, mmio: 0x38000000
PCI: Setting latency timer of device 0000:07:00.0 to 64
saa7133[0]: subsystem: 0000:5201, board: Beholder BeholdTV Columbus TVFM [card=128,autodetected]
saa7133[0]: board init: gpio is 8000
input: saa7134 IR (Beholder BeholdTV C as /class/input/input8
saa7133[0]: i2c eeprom 00: 00 00 01 52 54 20 00 00 00 00 00 00 00 00 00 01
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: 42 54 56 30 35 30 30 ff ff ff ff ff ff ff ff ff
TUNER: Unable to find symbol tda829x_probe()
------------[ cut here ]------------
kernel BUG at kernel/module.c:761!
invalid opcode: 0000 [#1] SMP 
Modules linked in: tuner(F) saa7134(F) videodev(F) v4l1_compat(F) compat_ioctl32(F) v4l2_common(F) videobuf_dma_sg(F) videobuf_core(F) ir_kbd_i2c(F) ir_common(F) tveeprom(F) xt_tcpudp i915 rfcomm l2cap bluetooth irtty_sir sir_dev iptable_filter ip_tables x_tables lp arc4 ecb blkcipher ieee80211_crypt_wep nls_utf8 nls_cp437 vfat fat drm ppdev sr_mod scsi_mod snd_intel8x0m snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event ipw2200 snd_seq snd_timer snd_seq_device ieee80211 ieee80211_crypt container video output i2c_i801 yenta_socket rsrc_nonstatic snd battery asus_acpi intel_agp ac button irda parport_pc i2c_core pcspkr psmouse soundcore evdev agpgart crc_ccitt parport snd_page_alloc rtc ext3 jbd mbcache ide_cd cdrom ide_disk usbhid piix b44 generic ide_core ssb pcmcia pcmcia_core firmware_class mii ehci_hcd uhci_hcd usbcore thermal processor fan

Pid: 4396, comm: modprobe Tainted: GF       (2.6.24 #1)
EIP: 0060:[<c013a052>] EFLAGS: 00010246 CPU: 0
EIP is at __symbol_put+0x1b/0x2c
EAX: 00000000 EBX: cb1d8a00 ECX: 00000000 EDX: 00000000
ESI: cb278800 EDI: e04f9640 EBP: cb1d8a00 ESP: cd845dd4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 4396, ti=cd844000 task=cb0c5000 task.ti=cd844000)
Stack: 00000001 cd845de8 e0024060 e04f5c3c e04f7ef6 df3b3cc0 cd845e34 c0321424 
       00001b20 df00ca00 c0193377 c144cc90 df00ca00 dcaa8610 c016f1ce dcaa8610 
       00000014 cb1d8a00 00000042 e04f9640 de56d140 e04b12d9 00000042 de56d170 
Call Trace:
 [<e04f5c3c>] tuner_probe+0x23b/0x4ac [tuner]
 [<c0193377>] sysfs_ilookup_test+0x0/0xd
 [<c016f1ce>] ifind+0x28/0x7b
 [<e04b12d9>] v4l2_i2c_attach+0x40/0x69 [v4l2_common]
 [<e04f5654>] v4l2_i2c_drv_attach_legacy+0x1e/0x21 [tuner]
 [<e04f5a01>] tuner_probe+0x0/0x4ac [tuner]
 [<e015899a>] i2c_probe_address+0xe3/0x126 [i2c_core]
 [<e0159740>] i2c_probe+0x14f/0x15b [i2c_core]
 [<e04f5636>] v4l2_i2c_drv_attach_legacy+0x0/0x21 [tuner]
 [<c021c60e>] bus_add_driver+0x133/0x197
 [<e04f5636>] v4l2_i2c_drv_attach_legacy+0x0/0x21 [tuner]
 [<e01593ed>] i2c_register_driver+0x9b/0xcb [i2c_core]
 [<e035106a>] v4l2_i2c_drv_init+0x6a/0xc5 [tuner]
 [<c013b771>] sys_init_module+0x15db/0x16f3
 [<c014d8fa>] vma_prio_tree_insert+0x17/0x2a
 [<e015817e>] i2c_master_send+0x0/0x41 [i2c_core]
 [<c0103d62>] sysenter_past_esp+0x5f/0x85
 [<c012007b>] vprintk+0x182/0x2c4
 =======================
Code: 3a 02 75 0b 8b 82 08 02 00 00 e9 76 0a fe ff c3 83 ec 0c 8d 4c 24 04 8d 54 24 08 c7 04 24 01 00 00 00 e8 a0 f8 ff ff 85 c0 75 04 <0f> 0b eb fe 8b 44 24 08 e8 b1 ff ff ff 83 c4 0c c3 57 89 c7 56 
EIP: [<c013a052>] __symbol_put+0x1b/0x2c SS:ESP 0068:cd845dd4
---[ end trace 3c34494d3738b35a ]---
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0

I think saa7134 can`t found tda8290.ko module for loading.
TUNER: Unable to find symbol tda829x_probe()

in .myconfig
CONFIG_MEDIA_TUNER_TDA8290	:= m

But this module didn`t build after make.

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
