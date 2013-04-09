Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39826 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934470Ab3DIV1a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 17:27:30 -0400
Received: from [82.128.187.254] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1UPg4f-0003r2-A4
	for linux-media@vger.kernel.org; Wed, 10 Apr 2013 00:27:29 +0300
Message-ID: <5164879A.70208@iki.fi>
Date: Wed, 10 Apr 2013 00:26:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: em28xx bug #2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That is another device. Just plug + unplug. Looks like I have to reboot 
now in order make more tests...

Apr 10 00:22:38 localhost kernel: [  412.203978] usb 2-2: new high-speed 
USB device number 3 using ehci-pci
Apr 10 00:22:38 localhost kernel: [  412.320325] usb 2-2: New USB device 
found, idVendor=2013, idProduct=0251
Apr 10 00:22:38 localhost kernel: [  412.320339] usb 2-2: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
Apr 10 00:22:38 localhost kernel: [  412.320348] usb 2-2: Product: PCTV 520e
Apr 10 00:22:38 localhost kernel: [  412.320354] usb 2-2: Manufacturer: 
PCTV Systems
Apr 10 00:22:38 localhost kernel: [  412.320360] usb 2-2: SerialNumber: 
000000000054
Apr 10 00:22:38 localhost kernel: [  412.322373] em28xx: New device PCTV 
Systems PCTV 520e @ 480 Mbps (2013:0251, interface 0, class 0)
Apr 10 00:22:38 localhost kernel: [  412.322384] em28xx: Audio interface 
0 found (Vendor Class)
Apr 10 00:22:38 localhost kernel: [  412.322391] em28xx: Video interface 
0 found: isoc
Apr 10 00:22:38 localhost kernel: [  412.322396] em28xx: DVB interface 0 
found: isoc
Apr 10 00:22:38 localhost kernel: [  412.322836] em28xx: chip ID is em2884
Apr 10 00:22:38 localhost kernel: [  412.625687] em2884 #0: i2c eeprom 
0000: 26 00 03 00 02 0b 0f e5 f5 64 01 60 09 e5 f5 64
Apr 10 00:22:38 localhost kernel: [  412.625726] em2884 #0: i2c eeprom 
0010: 09 60 03 c2 c6 22 e5 f7 b4 03 13 e5 f6 b4 87 03
Apr 10 00:22:38 localhost kernel: [  412.625760] em2884 #0: i2c eeprom 
0020: 02 0a b9 e5 f6 b4 93 03 02 09 46 c2 c6 22 c2 c6
Apr 10 00:22:38 localhost kernel: [  412.625792] em2884 #0: i2c eeprom 
0030: 22 00 60 00 ef 70 08 85 3d 82 85 3c 83 93 ff ef
Apr 10 00:22:38 localhost kernel: [  412.625823] em2884 #0: i2c eeprom 
0040: 60 19 85 3d 82 85 3c 83 e4 93 12 07 a3 12 0a fe
Apr 10 00:22:38 localhost kernel: [  412.625854] em2884 #0: i2c eeprom 
0050: 05 3d e5 3d 70 02 05 3c 1f 80 e4 22 12 0b 06 02
Apr 10 00:22:38 localhost kernel: [  412.625885] em2884 #0: i2c eeprom 
0060: 07 e2 01 00 1a eb 67 95 13 20 51 02 f0 93 6b 13
Apr 10 00:22:38 localhost kernel: [  412.625916] em2884 #0: i2c eeprom 
0070: a0 1a ba 14 ce 1a 39 57 4e 07 09 00 00 00 00 00
Apr 10 00:22:38 localhost kernel: [  412.625949] em2884 #0: i2c eeprom 
0080: 00 00 00 00 4e 36 13 00 f0 10 02 82 82 00 00 00
Apr 10 00:22:38 localhost kernel: [  412.625981] em2884 #0: i2c eeprom 
0090: 5b 53 c0 00 00 00 20 40 20 80 02 20 10 01 00 00
Apr 10 00:22:38 localhost kernel: [  412.626012] em2884 #0: i2c eeprom 
00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Apr 10 00:22:38 localhost kernel: [  412.626043] em2884 #0: i2c eeprom 
00b0: c6 40 00 00 00 00 a7 00 00 00 00 00 00 c2 00 00
Apr 10 00:22:38 localhost kernel: [  412.626074] em2884 #0: i2c eeprom 
00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 32
Apr 10 00:22:38 localhost kernel: [  412.626105] em2884 #0: i2c eeprom 
00d0: 34 31 30 31 31 36 36 30 31 37 31 30 34 32 30 30
Apr 10 00:22:38 localhost kernel: [  412.626136] em2884 #0: i2c eeprom 
00e0: 35 34 00 4f 53 49 30 30 33 30 38 44 30 31 30 30
Apr 10 00:22:38 localhost kernel: [  412.626168] em2884 #0: i2c eeprom 
00f0: 30 30 35 34 00 00 00 00 00 00 00 00 00 00 30 30
Apr 10 00:22:38 localhost kernel: [  412.626200] em2884 #0: i2c eeprom 
0100: ... (skipped)
Apr 10 00:22:38 localhost kernel: [  412.626210] em2884 #0: EEPROM ID = 
26 00 03 00, EEPROM hash = 0xcb7e25f9
Apr 10 00:22:38 localhost kernel: [  412.626215] em2884 #0: EEPROM info:
Apr 10 00:22:38 localhost kernel: [  412.626220] em2884 #0: 	microcode 
start address = 0x0004, boot configuration = 0x03
Apr 10 00:22:38 localhost kernel: [  412.634697] em2884 #0: 	No audio on 
board.
Apr 10 00:22:38 localhost kernel: [  412.634707] em2884 #0: 	500mA max power
Apr 10 00:22:38 localhost kernel: [  412.634713] em2884 #0: 	Table at 
offset 0x00, strings=0x0000, 0x0000, 0x0000
Apr 10 00:22:38 localhost kernel: [  412.634904] em2884 #0: Identified 
as PCTV QuatroStick nano (520e) (card=86)
Apr 10 00:22:38 localhost kernel: [  412.635077] em2884 #0: Config 
register raw data: 0xe9
Apr 10 00:22:38 localhost kernel: [  412.635083] em2884 #0: I2S Audio (3 
sample rates)
Apr 10 00:22:38 localhost kernel: [  412.635087] em2884 #0: No AC97 
audio processor
Apr 10 00:22:38 localhost kernel: [  412.651555] em2884 #0: v4l2 driver 
version 0.2.0
Apr 10 00:22:38 localhost kernel: [  412.674516] em2884 #0: V4L2 video 
device registered as video0
Apr 10 00:22:38 localhost kernel: [  412.674560] em2884 #0: analog set 
to isoc mode.
Apr 10 00:22:38 localhost kernel: [  412.674565] em2884 #0: dvb set to 
isoc mode.
Apr 10 00:22:39 localhost kernel: [  412.698774] drxk: status = 0x639260d9
Apr 10 00:22:39 localhost kernel: [  412.698788] drxk: detected a 
drx-3926k, spin A3, xtal 20.250 MHz
Apr 10 00:22:40 localhost kernel: [  413.944098] usb 2-2: USB 
disconnect, device number 3
Apr 10 00:22:40 localhost kernel: [  413.944595] em2884 #0: 
disconnecting em2884 #0 video
Apr 10 00:22:40 localhost kernel: [  413.951909] em2884 #0: writing to 
i2c device at 0x52 failed (error=-5)
Apr 10 00:22:40 localhost kernel: [  413.951916] drxk: i2c write error 
at addr 0x29
Apr 10 00:22:40 localhost kernel: [  413.951922] drxk: write_block: i2c 
write error at addr 0x830ded
Apr 10 00:22:40 localhost kernel: [  413.951926] drxk: Error -5 while 
loading firmware
Apr 10 00:22:40 localhost kernel: [  413.951932] drxk: Error -5 on init_drxk
Apr 10 00:22:40 localhost kernel: [  413.951936] drxk: frontend initialized.
Apr 10 00:22:40 localhost kernel: [  413.971923] tda18271 6-0060: 
creating new instance
Apr 10 00:22:40 localhost kernel: [  413.971931] em2884 #0: writing to 
i2c device at 0xc0 failed (error=-19)
Apr 10 00:22:40 localhost kernel: [  413.971934] tda18271_read_regs: 
[6-0060|M] ERROR: i2c_transfer returned: -19
Apr 10 00:22:40 localhost kernel: [  413.971936] Error reading device ID 
@ 6-0060, bailing out.
Apr 10 00:22:40 localhost kernel: [  413.971938] tda18271_attach: 
[6-0060|M] error -5 on line 1285
Apr 10 00:22:40 localhost kernel: [  413.971940] tda18271 6-0060: 
destroying instance
Apr 10 00:22:40 localhost kernel: [  413.972131] em2884 #0: V4L2 device 
video0 deregistered
Apr 10 00:22:40 localhost kernel: [  413.982461] em28xx-audio.c: probing 
for em28xx Audio Vendor Class
Apr 10 00:22:40 localhost kernel: [  413.982472] em28xx-audio.c: 
Copyright (C) 2006 Markus Rechberger
Apr 10 00:22:40 localhost kernel: [  413.982477] em28xx-audio.c: 
Copyright (C) 2007-2011 Mauro Carvalho Chehab
Apr 10 00:22:40 localhost kernel: [  413.982704] general protection 
fault: 0000 [#1] SMP
Apr 10 00:22:40 localhost kernel: [  413.982828] Modules linked in: 
em28xx_alsa(O+) tda18271(O) tcp_lp tda18271c2dd(O) drxk(O) em28xx_dvb(O) 
dvb_core(O) em28xx(O) videobuf2_vmalloc(O) videobuf2_memops(O) 
videobuf2_core(O) tveeprom(O) v4l2_common(O) videodev(O) media(O) fuse 
ip6t_REJECT rfcomm nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter 
ip6_tables bnep nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack 
ppdev btusb bluetooth snd_hda_codec_hdmi rfkill kvm microcode serio_raw 
pcspkr k10temp edac_core edac_mce_amd snd_hda_codec_via snd_hda_intel 
snd_hda_codec sp5100_tco snd_hwdep i2c_piix4 snd_seq snd_seq_device 
snd_pcm snd_page_alloc snd_timer snd soundcore r8169 mii shpchp 
parport_pc parport asus_atk0110 wmi binfmt_misc uinput dm_crypt 
hid_logitech_dj ata_generic pata_acpi pata_atiixp radeon i2c_algo_bit 
drm_kms_helper ttm drm i2c_core
Apr 10 00:22:40 localhost kernel: [  413.984601] CPU 2
Apr 10 00:22:40 localhost kernel: [  413.984649] Pid: 1801, comm: 
modprobe Tainted: G           O 3.9.0-rc5+ #39 System manufacturer 
System Product Name/M5A78L-M/USB3
Apr 10 00:22:40 localhost kernel: [  413.984873] RIP: 
0010:[<ffffffff81321200>]  [<ffffffff81321200>] kobject_get+0x10/0x40
Apr 10 00:22:40 localhost kernel: [  413.985040] RSP: 
0018:ffff8801d5953b38  EFLAGS: 00010282
Apr 10 00:22:40 localhost kernel: [  413.985145] RAX: 00012829302430a0 
RBX: ffff8801cf376800 RCX: 0000000000000000
Apr 10 00:22:40 localhost kernel: [  413.985282] RDX: ffff8802eaf6dae0 
RSI: ffffffff81a33f9b RDI: 00012829302430a0
Apr 10 00:22:40 localhost kernel: [  413.985419] RBP: ffff8801d5953b48 
R08: 0000000000000000 R09: 0000000000000000
Apr 10 00:22:40 localhost kernel: [  413.985556] R10: 0000000000000000 
R11: 0000000000000000 R12: ffff8801cf376800
Apr 10 00:22:40 localhost kernel: [  413.985693] R13: ffffffffa01e4cae 
R14: ffff8801cf376c50 R15: ffff8801cf376800
Apr 10 00:22:40 localhost kernel: [  413.985831] FS: 
00007f0e9b9c7740(0000) GS:ffff880312e00000(0000) knlGS:0000000000000000
Apr 10 00:22:40 localhost kernel: [  413.985986] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Apr 10 00:22:40 localhost kernel: [  413.986098] CR2: 00007f0e9b881000 
CR3: 00000002936a1000 CR4: 00000000000007e0
Apr 10 00:22:40 localhost kernel: [  413.986234] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Apr 10 00:22:40 localhost kernel: [  413.986372] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 10 00:22:40 localhost kernel: [  413.986509] Process modprobe (pid: 
1801, threadinfo ffff8801d5952000, task ffff8803089f0000)
Apr 10 00:22:40 localhost kernel: [  413.986669] Stack:
Apr 10 00:22:40 localhost kernel: [  413.986711]  ffff8801d5953b68 
ffff8801cf376ac8 ffff8801d5953b58 ffffffff81414357
Apr 10 00:22:40 localhost kernel: [  413.986877]  ffff8801d5953bd8 
ffffffff81415cc3 ffff8801d5953b98 ffffffff81088516
Apr 10 00:22:40 localhost kernel: [  413.987041]  ffff8801cf376800 
ffff8801cf376800 ffff8801cf376800 ffffffffa01e4cae
Apr 10 00:22:40 localhost kernel: [  413.987206] Call Trace:
Apr 10 00:22:40 localhost kernel: [  413.987265]  [<ffffffff81414357>] 
get_device+0x17/0x30
Apr 10 00:22:40 localhost kernel: [  413.987372]  [<ffffffff81415cc3>] 
device_add+0xd3/0x6f0
Apr 10 00:22:40 localhost kernel: [  413.987480]  [<ffffffff81088516>] ? 
__init_waitqueue_head+0x46/0x60
Apr 10 00:22:40 localhost kernel: [  413.987612]  [<ffffffff814162fe>] 
device_register+0x1e/0x30
Apr 10 00:22:40 localhost kernel: [  413.987725]  [<ffffffff8141640b>] 
device_create_vargs+0xfb/0x130
Apr 10 00:22:40 localhost kernel: [  413.987847]  [<ffffffff81416471>] 
device_create+0x31/0x40
Apr 10 00:22:40 localhost kernel: [  413.987960]  [<ffffffffa04b4030>] ? 
snd_em28xx_prepare+0x30/0x30 [em28xx_alsa]
Apr 10 00:22:40 localhost kernel: [  413.988114]  [<ffffffffa01db8cc>] 
snd_card_register+0x1fc/0x2b0 [snd]
Apr 10 00:22:40 localhost kernel: [  413.988246]  [<ffffffffa04b514a>] 
em28xx_audio_init+0x1ba/0x318 [em28xx_alsa]
Apr 10 00:22:40 localhost kernel: [  413.988394]  [<ffffffffa046f9d8>] 
em28xx_register_extension+0x58/0xa0 [em28xx]
Apr 10 00:22:40 localhost kernel: [  413.988540]  [<ffffffffa04db000>] ? 
0xffffffffa04dafff
Apr 10 00:22:40 localhost kernel: [  413.988647]  [<ffffffffa04db010>] 
em28xx_alsa_register+0x10/0x1000 [em28xx_alsa]
Apr 10 00:22:40 localhost kernel: [  413.988793]  [<ffffffff8100215a>] 
do_one_initcall+0x12a/0x180
Apr 10 00:22:40 localhost kernel: [  413.988910]  [<ffffffff810d72e6>] 
load_module+0x1c36/0x27f0
Apr 10 00:22:40 localhost kernel: [  413.989024]  [<ffffffff813401b0>] ? 
ddebug_proc_open+0xd0/0xd0
Apr 10 00:22:40 localhost kernel: [  413.989145]  [<ffffffff8132ca6e>] ? 
trace_hardirqs_on_thunk+0x3a/0x3f
Apr 10 00:22:40 localhost kernel: [  413.989273]  [<ffffffff810d7f77>] 
sys_init_module+0xd7/0x120
Apr 10 00:22:40 localhost kernel: [  413.989389]  [<ffffffff816acc99>] 
system_call_fastpath+0x16/0x1b
Apr 10 00:22:40 localhost kernel: [  413.989505] Code: 48 c7 c7 58 90 cf 
81 31 c0 e8 0d de 01 00 eb d0 66 66 2e 0f 1f 84 00 00 00 00 00 48 85 ff 
48 89 f8 74 14 55 48 89 e5 48 83 ec 10 <8b> 57 38 85 d2 74 07 f0 ff 40 
38 c9 f3 c3 be 2a 00 00 00 48 c7
Apr 10 00:22:40 localhost kernel: [  413.990259] RIP 
[<ffffffff81321200>] kobject_get+0x10/0x40
Apr 10 00:22:40 localhost kernel: [  413.990375]  RSP <ffff8801d5953b38>
Apr 10 00:22:40 localhost kernel: [  414.032230] ---[ end trace 
e5e33d0a967d772c ]---




-- 
http://palosaari.fi/
