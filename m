Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58580 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab2HBUyu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 16:54:50 -0400
Message-ID: <501AE90E.2020201@iki.fi>
Date: Thu, 02 Aug 2012 23:54:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: dvb_usb_lmedm04 crash Kernel
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi Malcolm,
Any idea why this seems to crash Kernel just when device is plugged?


[crope@localhost linux]$ uname -a
Linux localhost.localdomain 3.4.6-2.fc17.x86_64 #1 SMP Thu Jul 19 
22:54:16 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
[crope@localhost linux]$ modinfo dvb_usb_lmedm04
filename: 
/lib/modules/3.4.6-2.fc17.x86_64/kernel/drivers/media/dvb/dvb-usb/dvb-usb-lmedm04.ko
license:        GPL
version:        1.99
description:    LME2510(C) DVB-S USB2.0
author:         Malcolm Priestley <tvboxspy@gmail.com>
srcversion:     59949851F3132870B974EE7
alias:          usb:v3344p22F0d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v3344p1120d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v3344p1122d*dc*dsc*dp*ic*isc*ip*
depends:        dvb-usb,dvb-core,rc-core
intree:         Y
vermagic:       3.4.6-2.fc17.x86_64 SMP mod_unload
parm:           debug:set debugging level (1=info (or-able)). (debugging 
is not enabled) (int)
parm:           firmware:set default firmware 0=Sharp7395 1=LG (int)
parm:           pid:set default 0=default 1=off 2=on (int)
parm:           adapter_nr:DVB adapter numbers (array of short)
[crope@localhost linux]$


Aug  2 23:46:19 localhost kernel: [  211.527886] usb 1-2.2: new 
high-speed USB device number 7 using ehci_hcd
Aug  2 23:46:19 localhost kernel: [  211.601817] usb 1-2.2: config 1 
interface 0 altsetting 1 bulk endpoint 0x81 has invalid maxpacket 64
Aug  2 23:46:19 localhost kernel: [  211.601829] usb 1-2.2: config 1 
interface 0 altsetting 1 bulk endpoint 0x1 has invalid maxpacket 64
Aug  2 23:46:19 localhost kernel: [  211.601837] usb 1-2.2: config 1 
interface 0 altsetting 1 bulk endpoint 0x2 has invalid maxpacket 64
Aug  2 23:46:19 localhost kernel: [  211.601845] usb 1-2.2: config 1 
interface 0 altsetting 1 bulk endpoint 0x8A has invalid maxpacket 64
Aug  2 23:46:19 localhost kernel: [  211.602073] usb 1-2.2: New USB 
device found, idVendor=3344, idProduct=22f0
Aug  2 23:46:19 localhost kernel: [  211.602083] usb 1-2.2: New USB 
device strings: Mfr=0, Product=0, SerialNumber=3
Aug  2 23:46:19 localhost kernel: [  211.602093] usb 1-2.2: 
SerialNumber: 䥈児
Aug  2 23:46:19 localhost mtp-probe: checking bus 1, device 7: 
"/sys/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2"
Aug  2 23:46:19 localhost mtp-probe: bus: 1, device: 7 was not an MTP device
Aug  2 23:46:19 localhost kernel: [  211.628508] LME2510(C): Firmware 
Status: 6 (44)
Aug  2 23:46:19 localhost kernel: [  211.629545] LME2510(C): FRM Loading 
dvb-usb-lme2510c-rs2000.fw file
Aug  2 23:46:19 localhost kernel: [  211.629551] LME2510(C): FRM 
Starting Firmware Download
Aug  2 23:46:19 localhost kernel: [  211.629574] BUG: unable to handle 
kernel NULL pointer dereference at 0000000000000008
Aug  2 23:46:19 localhost kernel: [  211.629739] IP: 
[<ffffffffa03ac116>] lme_firmware_switch+0x526/0x800 [dvb_usb_lmedm04]
Aug  2 23:46:19 localhost kernel: [  211.629900] PGD 0
Aug  2 23:46:19 localhost kernel: [  211.629947] Oops: 0000 [#1] SMP
Aug  2 23:46:19 localhost kernel: [  211.630019] CPU 3
Aug  2 23:46:19 localhost kernel: [  211.630058] Modules linked in: 
dvb_usb_lmedm04(+) dvb_usb fuse tpm_bios rfcomm bnep ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 
xt_state nf_conntrack ip6table_filter ip6_tables snd_hda_codec_hdmi 
ppdev sp5100_tco snd_hda_codec_via btusb bluetooth i2c_piix4 8139too 
microcode 8139cp serio_raw snd_hda_intel edac_core edac_mce_amd k10temp 
snd_hda_codec snd_hwdep rfkill r8169 mii cx23885 altera_ci tda18271 
altera_stapl cx2341x btcx_risc videobuf_dvb dvb_core snd_pcm 
snd_page_alloc snd_timer snd soundcore tveeprom videobuf_dma_sg 
videobuf_core v4l2_common videodev media rc_core shpchp parport_pc 
parport asus_atk0110 uinput xts gf128mul hid_logitech_dj ata_generic 
pata_acpi dm_crypt pata_atiixp wmi radeon i2c_algo_bit drm_kms_helper 
ttm drm i2c_core [last unloaded: scsi_wait_scan]
Aug  2 23:46:19 localhost kernel: [  211.631729]
Aug  2 23:46:19 localhost kernel: [  211.631762] Pid: 528, comm: udevd 
Not tainted 3.4.6-2.fc17.x86_64 #1 System manufacturer System Product 
Name/M5A78L-M/USB3
Aug  2 23:46:19 localhost kernel: [  211.631981] RIP: 
0010:[<ffffffffa03ac116>]  [<ffffffffa03ac116>] 
lme_firmware_switch+0x526/0x800 [dvb_usb_lmedm04]
Aug  2 23:46:19 localhost kernel: [  211.632183] RSP: 
0018:ffff88030b097ae8  EFLAGS: 00010286
Aug  2 23:46:19 localhost kernel: [  211.632282] RAX: 0000000000000000 
RBX: 0000000000000000 RCX: 0000000000000000
Aug  2 23:46:19 localhost kernel: [  211.632414] RDX: 0000000000000008 
RSI: 0000000000000046 RDI: 0000000000000246
Aug  2 23:46:19 localhost kernel: [  211.632552] RBP: ffff88030b097c28 
R08: 000000000000000a R09: 0000000000000000
Aug  2 23:46:19 localhost kernel: [  211.632702] R10: 0000000000000000 
R11: ffff8802f8255c02 R12: 0000000000000000
Aug  2 23:46:19 localhost kernel: [  211.632833] R13: ffff8802f8255c00 
R14: ffff8802f8255c02 R15: 00000000ffffffff
Aug  2 23:46:19 localhost kernel: [  211.632967] FS: 
00007f023fe01840(0000) GS:ffff88031fcc0000(0000) knlGS:0000000000000000
Aug  2 23:46:19 localhost kernel: [  211.633115] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Aug  2 23:46:19 localhost kernel: [  211.633222] CR2: 0000000000000008 
CR3: 000000030b092000 CR4: 00000000000007e0
Aug  2 23:46:19 localhost kernel: [  211.633353] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Aug  2 23:46:19 localhost kernel: [  211.633484] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  2 23:46:19 localhost kernel: [  211.633616] Process udevd (pid: 
528, threadinfo ffff88030b096000, task ffff88030b072e20)
Aug  2 23:46:19 localhost kernel: [  211.633763] Stack:
Aug  2 23:46:19 localhost kernel: [  211.633803]  0000000000000000 
ffffffff81e69c63 ffffffff81e69c87 ffff88030b097b6d
Aug  2 23:46:19 localhost kernel: [  211.633960]  ffff88030b097b6d 
0000000000000003 ffff88030b097bd5 0000000000000000
Aug  2 23:46:19 localhost kernel: [  211.634115]  0000020000000000 
0000000000000008 0200018100000000 ffff88030c228000
Aug  2 23:46:19 localhost kernel: [  211.634269] Call Trace:
Aug  2 23:46:19 localhost kernel: [  211.634327]  [<ffffffffa03ad843>] 
lme2510_probe+0x173/0x1c8 [dvb_usb_lmedm04]
Aug  2 23:46:19 localhost kernel: [  211.634466]  [<ffffffff8141e987>] 
usb_probe_interface+0x107/0x240
Aug  2 23:46:19 localhost kernel: [  211.634584]  [<ffffffff811f1fe3>] ? 
sysfs_create_link+0x13/0x20
Aug  2 23:46:19 localhost kernel: [  211.634698]  [<ffffffff813a3f32>] 
driver_probe_device+0x92/0x390
Aug  2 23:46:19 localhost kernel: [  211.634811]  [<ffffffff813a42db>] 
__driver_attach+0xab/0xb0
Aug  2 23:46:19 localhost kernel: [  211.634919]  [<ffffffff813a4230>] ? 
driver_probe_device+0x390/0x390
Aug  2 23:46:19 localhost kernel: [  211.635039]  [<ffffffff813a1fb5>] 
bus_for_each_dev+0x55/0x90
Aug  2 23:46:19 localhost kernel: [  211.635146]  [<ffffffff813a37ce>] 
driver_attach+0x1e/0x20
Aug  2 23:46:19 localhost kernel: [  211.635249]  [<ffffffff813a34d8>] 
bus_add_driver+0x1a8/0x2a0
Aug  2 23:46:19 localhost kernel: [  211.635357]  [<ffffffff813a49a7>] 
driver_register+0x77/0x150
Aug  2 23:46:19 localhost kernel: [  211.635466]  [<ffffffff8141d46d>] 
usb_register_driver+0x8d/0x160
Aug  2 23:46:19 localhost kernel: [  211.635586]  [<ffffffffa03b4000>] ? 
0xffffffffa03b3fff
Aug  2 23:46:19 localhost kernel: [  211.635689]  [<ffffffffa03b401e>] 
lme2510_driver_init+0x1e/0x1000 [dvb_usb_lmedm04]
Aug  2 23:46:19 localhost kernel: [  211.635835]  [<ffffffff8100212a>] 
do_one_initcall+0x12a/0x180
Aug  2 23:46:19 localhost kernel: [  211.635946]  [<ffffffff810b6d36>] 
sys_init_module+0x10f6/0x20c0
Aug  2 23:46:19 localhost kernel: [  211.636062]  [<ffffffff815fcce9>] 
system_call_fastpath+0x16/0x1b
Aug  2 23:46:19 localhost kernel: [  211.636174] Code: 15 ff ff ff 83 ea 
01 41 89 d4 41 29 dc 45 89 e7 41 89 dc 83 c8 80 88 85 14 ff ff ff 48 8b 
95 08 ff ff ff 41 0f b7 cc 41 0f b7 c4 <48> 03 0a 8b 95 04 ff ff ff 29 
c2 83 fa 31 0f 8e b6 01 00 00 0f
Aug  2 23:46:19 localhost kernel: [  211.636858] RIP 
[<ffffffffa03ac116>] lme_firmware_switch+0x526/0x800 [dvb_usb_lmedm04]
Aug  2 23:46:19 localhost kernel: [  211.637021]  RSP <ffff88030b097ae8>
Aug  2 23:46:19 localhost kernel: [  211.637089] CR2: 0000000000000008
Aug  2 23:46:19 localhost kernel: [  211.678968] ---[ end trace 
043f228f268ca25f ]---
Aug  2 23:46:19 localhost udevd[429]: worker [528] terminated by signal 
9 (Killed)
Aug  2 23:46:19 localhost udevd[429]: worker [528] failed while handling 
'/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0'
Aug  2 23:46:20 localhost sh[674]: abrt-dump-oops: Found oopses: 1
Aug  2 23:46:20 localhost sh[674]: abrt-dump-oops: Creating dump directories
Aug  2 23:46:20 localhost abrtd: Directory 
'oops-2012-08-02-23:46:20-1452-0' creation detected
Aug  2 23:46:20 localhost abrt-dump-oops: Reported 1 kernel oopses to Abrt
Aug  2 23:46:20 localhost abrtd: Can't open file 
'/var/spool/abrt/oops-2012-08-02-23:46:20-1452-0/uid': No such file or 
directory
Aug  2 23:46:20 localhost abrtd: Duplicate: UUID
Aug  2 23:46:20 localhost abrtd: DUP_OF_DIR: 
/var/spool/abrt/oops-2012-06-06-05:16:05-594-0
Aug  2 23:46:20 localhost abrtd: Problem directory is a duplicate of 
/var/spool/abrt/oops-2012-06-06-05:16:05-594-0
Aug  2 23:46:20 localhost abrtd: Deleting problem directory 
oops-2012-08-02-23:46:20-1452-0 (dup of oops-2012-06-06-05:16:05-594-0)
Aug  2 23:46:20 localhost abrtd: Can't open file 
'/var/spool/abrt/oops-2012-06-06-05:16:05-594-0/uid': No such file or 
directory



regards
Antti

-- 
http://palosaari.fi/
