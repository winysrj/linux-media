Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with SMTP id m4DLNe1q010395
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 17:23:40 -0400
Received: from bay0-omc1-s33.bay0.hotmail.com (bay0-omc1-s33.bay0.hotmail.com
	[65.54.246.105])
	by mx2.redhat.com (8.13.8/8.13.8) with SMTP id m4DLNQlA027302
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 17:23:26 -0400
Message-ID: <BAY121-W5E32248F0E58BA960978CCDCF0@phx.gbl>
From: Marko Taponen <mtaponen@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Wed, 14 May 2008 00:23:09 +0300
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: HVR 1110 -  Unable to handle kernel NULL pointer dereference
Reply-To: marko.taponen@iki.fi
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

Can someone help me on installing Hauppauge HVR 1110 on AMD x64 running Ubuntu 7.10 - with 2.6.22-14-generic - kernel.

As the "built in drivers" failed I have followed the LinuxTV wiki instructions http://www.linuxtv.org/v4lwiki/index.php/How_to_build_from_Mercurial
I did a clean pull ( revision 7897)  of the v4l-dvb sources and - what I think - a successful make && make install.

Now after the boot dmesg says:
[   30.907126] Unable to handle kernel NULL pointer dereference at 00000000000000b0 RIP: 
[   30.907131]  [] :dvb_core:dvb_frontend_detach+0x9/0x90
(please find full dmesg flood at end)
And also there is only adapter0 present in /dev/dvb being the - always working - conexant based nova-T

Is there something that I'm missing here or is this something related to this setup? 
I had the same card functional in my old setup (being i386 running Ubuntu 7.04 - kernel 2.6.20(?) with v4l-dvb compiled from hg)
Also if there is some things I might try - I would be interested.

Thanks and regards
// Marko


[   29.813887] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   29.816766] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   30.181137] Linux video capture interface: v2.00
[   30.221870] saa7130/34: v4l2 driver version 0.2.14 loaded
[   30.222840] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 19
[   30.222851] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [LNKA] -> GSI 19 (level, low) -> IRQ 19
[   30.222859] saa7133[0]: found at 0000:01:06.0, rev: 209, irq: 19, latency: 64, mmio: 0xdffff800
[   30.222865] saa7133[0]: subsystem: 0070:6701, board: Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,autodetected]
[   30.222874] saa7133[0]: board init: gpio is 6400000
[   30.341426] input: HVR 1110 as /class/input/input3
[   30.341446] ir-kbd-i2c: HVR 1110 detected at i2c-0/0-0071/ir0 [saa7133[0]]
[   30.409261] saa7133[0]: i2c eeprom 00: 70 00 01 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   30.409270] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
[   30.409276] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 aa ff ff ff ff
[   30.409282] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.409287] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff
[   30.409293] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   30.409298] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   30.409303] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   30.409307] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 42 a2 37 f0 73 05 29 00
[   30.409313] saa7133[0]: i2c eeprom 90: 84 08 00 06 cb 05 01 00 94 48 89 72 07 70 73 09
[   30.409319] saa7133[0]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 0f 03 72
[   30.409324] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 79 23 00 00 00 00 00 00 00 00 00
[   30.409329] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   30.409334] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   30.409339] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   30.409344] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   30.458819] input: PC Speaker as /class/input/input4
[   30.484695] nvidia: module license 'NVIDIA' taints kernel.
[   30.740219] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   30.752809] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   30.782901] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 1 alt 0 proto 2 vid 0x04B8 pid 0x0811
[   30.782915] usbcore: registered new interface driver usblp
[   30.782918] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
[   30.797627] tveeprom 0-0050: Hauppauge model 67019, rev B4B4, serial# 3646018
[   30.797633] tveeprom 0-0050: MAC address is 00-0D-FE-37-A2-42
[   30.797635] tveeprom 0-0050: tuner model is Philips 8275A (idx 114, type 4)
[   30.797638] tveeprom 0-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[   30.797641] tveeprom 0-0050: audio processor is SAA7131 (idx 41)
[   30.797643] tveeprom 0-0050: decoder processor is SAA7131 (idx 35)
[   30.797645] tveeprom 0-0050: has radio, has IR receiver, has IR transmitter
[   30.797648] saa7133[0]: hauppauge eeprom: model=67019
[   30.798117] saa7133[0]: registered device video0 [v4l2]
[   30.798144] saa7133[0]: registered device vbi0
[   30.798179] saa7133[0]: registered device radio0
[   30.805807] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   30.805819] ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   30.805857] cx88[0]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=18,autodetected]
[   30.805859] cx88[0]: TV tuner type 4, Radio tuner type -1
[   30.810705] Bluetooth: Core ver 2.11
[   30.810753] NET: Registered protocol family 31
[   30.810755] Bluetooth: HCI device and connection manager initialized
[   30.810759] Bluetooth: HCI socket layer initialized
[   30.814863] parport_pc 00:04: reported by Plug and Play ACPI
[   30.814911] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   30.838046] Bluetooth: HCI USB driver ver 2.9
[   30.839998] usbcore: registered new interface driver hci_usb
[   30.884832] saa7134 ALSA driver for DMA sound loaded
[   30.884861] saa7133[0]/alsa: saa7133[0] at 0xdffff800 irq 19 registered as card -2
[   30.907126] Unable to handle kernel NULL pointer dereference at 00000000000000b0 RIP: 
[   30.907131]  [] :dvb_core:dvb_frontend_detach+0x9/0x90
[   30.907147] PGD 2ecd1067 PUD 2edeb067 PMD 0 
[   30.907151] Oops: 0000 [1] SMP 
[   30.907153] CPU 1 
[   30.907155] Modules linked in: tda1004x snd_hda_intel saa7134_alsa saa7134_dvb videobuf_dvb dvb_core snd_pcm_oss snd_mixer_oss snd_pcm hci_usb parport_pc bluetooth tuner usblp snd_seq_dummy parport cx8800 cx8802 nvidia(P) pcspkr snd_seq_oss serio_raw psmouse cx88xx snd_seq_midi i2c_algo_bit btcx_risc snd_rawmidi saa7134 compat_ioctl32 videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core ir_kbd_i2c ir_common tveeprom i2c_core k8temp snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc shpchp pci_hotplug evdev ext3 jbd mbcache sg usb_storage libusual sd_mod ide_cd cdrom usbhid hid amd74xx ide_core ahci ehci_hcd ata_generic libata scsi_mod forcedeth ohci_hcd usbcore thermal processor fan fuse apparmor commoncap
[   30.907190] Pid: 4165, comm: modprobe Tainted: P   M   2.6.22-14-generic #1
[   30.907193] RIP: 0010:[]  [] :dvb_core:dvb_frontend_detach+0x9/0x90
[   30.907201] RSP: 0018:ffff81002f813d78  EFLAGS: 00010296
[   30.907204] RAX: 00000000ffffffea RBX: 00000000ffffffff RCX: ffffffff88a669e0
[   30.907207] RDX: 00000000ffffffea RSI: 0000000000000292 RDI: 0000000000000000
[   30.907209] RBP: 0000000000000000 R08: ffff81002f812000 R09: 0000000000000000
[   30.907212] R10: 00000000fffffff9 R11: 0000000000000004 R12: ffff81002ed6c170
[   30.907215] R13: 0000000000000019 R14: ffffffff88a07b80 R15: ffffc20000607ce0
[   30.907218] FS:  00002b31bd55e6e0(0000) GS:ffff810037875280(0000) knlGS:0000000000000000
[   30.907221] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   30.907223] CR2: 00000000000000b0 CR3: 000000002edbc000 CR4: 00000000000006e0
[   30.907226] Process modprobe (pid: 4165, threadinfo ffff81002f812000, task ffff810035caadc0)
[   30.907228] Stack:  ffff81002ed6c000 00000000ffffffff ffff81002ed6c000 ffffffff88a0276e
[   30.907234]  ffff8100000000d8 ffff81002ed6c000 ffffffff8022f30c ffffffff80430812
[   30.907239]  ffff81002f813e08 ffff810030c6c000 0000000100000000 ffffffff88a07b80
[   30.907243] Call Trace:
[   30.907251]  [] :saa7134_dvb:dvb_init+0x16e/0x1580
[   30.907258]  [] try_to_wake_up+0x5c/0x3f0
[   30.907262]  [] cond_resched+0x32/0x40
[   30.907280]  [] :saa7134:mpeg_ops_attach+0x4e/0x60
[   30.907290]  [] :saa7134:saa7134_ts_register+0x3b/0x90
[   30.907296]  [] sys_init_module+0x19b/0x19b0
[   30.907310]  [] __up_write+0x21/0x130
[   30.907319]  [] system_call+0x7e/0x83
[   30.907327] 
[   30.907328] 
[   30.907329] Code: 48 8b 87 b0 00 00 00 48 85 c0 74 0e ff d0 48 8b bd b0 00 00 
[   30.907336] RIP  [] :dvb_core:dvb_frontend_detach+0x9/0x90
[   30.907344]  RSP 
[   30.907345] CR2: 00000000000000b0
[   30.958730] tveeprom 1-0050: Hauppauge model 90003, rev C2B0, serial# 3621363
[   30.958736] tveeprom 1-0050: MAC address is 00-0D-FE-37-41-F3
[   30.958739] tveeprom 1-0050: tuner model is Thompson DTT75105 (idx 110, type 4)
[   30.958742] tveeprom 1-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
[   30.958745] tveeprom 1-0050: audio processor is None (idx 0)
[   30.958747] tveeprom 1-0050: decoder processor is CX882 (idx 25)
[   30.958749] tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
[   30.958751] cx88[0]: hauppauge eeprom: model=90003
[   30.958827] input: cx88 IR (Hauppauge Nova-T DVB-T as /class/input/input5
[   30.958856] cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 18, latency: 64, mmio: 0xde000000
[   30.958906] cx88[0]/0: registered device video1 [v4l2]
[   30.958926] cx88[0]/0: registered device vbi1
[   30.959506] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[   30.959510] ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LAZA] -> GSI 21 (level, low) -> IRQ 21
[   30.959740] PCI: Setting latency timer of device 0000:00:07.0 to 64
[   31.176864] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   31.305131] cx88[0]/2: cx2388x 8802 Driver Manager
[   31.305153] ACPI: PCI Interrupt 0000:01:07.2[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   31.305161] cx88[0]/2: found at 0000:01:07.2, rev: 5, irq: 18, latency: 64, mmio: 0xdd000000
[   31.305712] ACPI: PCI Interrupt Link [SGRU] enabled at IRQ 20
[   31.305714] ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [SGRU] -> GSI 20 (level, low) -> IRQ 20
[   31.305719] PCI: Setting latency timer of device 0000:00:12.0 to 64
[   31.305914] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.19  Wed Sep 12 14:08:38 PDT 2007
[   31.326075] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   31.326081] cx88/2: registering cx8802 driver, type: dvb access: shared
[   31.326084] cx88[0]/2: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=18]
[   31.326087] cx88[0]/2: cx2388x based DVB/ATSC card
[   31.368825] DVB: registering new adapter (cx88[0])
[   31.368835] DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
[   32.069757] lp0: using parport0 (interrupt-driven).
[   32.130971] Adding 6554480k swap on /dev/sda5.  Priority:-1 extents:1 across:6554


_________________________________________________________________
Explore the seven wonders of the world
http://search.msn.com/results.aspx?q=7+wonders+world&mkt=en-US&form=QBRE

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
