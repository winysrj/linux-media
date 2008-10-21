Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fortimail.matc.edu ([148.8.129.21] helo=matc.edu)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <johnsonn@matc.edu>) id 1Ks931-0002CE-Jo
	for linux-dvb@linuxtv.org; Tue, 21 Oct 2008 06:40:54 +0200
Received: from GWISE1.matc.edu (gwise1.matc.edu [148.8.29.22])
	by Fortimail2000-1.fortimail.matc.edu  with ESMTP id m9L4eAkT028754
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 23:40:10 -0500
Message-Id: <48FD16D4020000560001A8B0@GWISE1.matc.edu>
Date: Mon, 20 Oct 2008 23:40:04 -0500
From: "Jonathan Johnson" <johnsonn@matc.edu>
To: <linux-dvb@linuxtv.org>
Mime-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] unresolved symbols
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

Hello all,

     Well, I am using kernel 2.6.27.2.  I when into the kernel and disabled "Video for Linux" and associated modules.
Then I did a make and all other kernel makes and installs.  Rebooted.
Then I re-maked v4l-dvb and got this:
=============================
Kernel build directory is /lib/modules/2.6.27-git8-default/build
make -C /lib/modules/2.6.27-git8-default/build SUBDIRS=/root/svn/v4l-dvb/v4l  modules
make[1]: Entering directory `/usr/src/linux-2.6.27'
  CC [M]  /root/svn/v4l-dvb/v4l/dvbdev.o
/root/svn/v4l-dvb/v4l/dvbdev.c: In function 'dvb_register_device':
/root/svn/v4l-dvb/v4l/dvbdev.c:246: error: implicit declaration of function 'device_create_drvdata'
/root/svn/v4l-dvb/v4l/dvbdev.c:248: warning: assignment makes pointer from integer without a cast
make[2]: *** [/root/svn/v4l-dvb/v4l/dvbdev.o] Error 1
make[1]: *** [_module_/root/svn/v4l-dvb/v4l] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.27'
make: *** [default] Error 2
======================
I went in with an editor and look at line 246 in dvbdev.c and did not know what do to.  However,
I seen a reference to 2.6.26 and change it to 2.6.27 and then it compiled.
Probably horribly wrong this to do but it work sort of.................

I then rebooted and did a "make insmod"
The script loaded them(shotgun like) where it loaded everything even thought it didn't need it.
The process froze at cx88--???? (something) 
did a dmesg and caught a crash
as follows:
========================================================
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
Linux video capture interface: v2.00
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
EMU10K1_Audigy 0000:01:06.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
ALSA sound/pci/emu10k1/emufx.c:1546: Installing spdif_bug patch: Audigy 4 PRO [SB0380]
cx23885 driver version 0.0.1 loaded
cx23885 0000:06:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
xc5000 2-0064: creating new instance
xc5000: Successfully identified at address 0x64
xc5000: Firmware has not been loaded previously
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 1851880034 (Samsung S5H1411 QAM/8VSB Frontend)...
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8035c71d>] vsnprintf+0x3d/0x7f0
PGD 7e4b0067 PUD 7e4b8067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:02.0/modalias
CPU 0 
Modules linked in: xc5000 s5h1411 s5h1409 cx23885(+) snd_emu10k1 compat_ioctl32 videodev snd_rawmidi snd_ac97_codec v4l1_compat ac97_bus cx2341x videobuf_dma_sg snd_pcm cfi_cmdset_0002 snd_seq_device cfi_util videobuf_dvb snd_timer jedec_probe dvb_core videobuf_core snd_page_alloc cfi_probe gen_probe v4l2_common snd_util_mem ohci1394 btcx_risc tveeprom snd_hwdep ck804xrom k8temp snd mtd i2c_nforce2 sr_mod serio_raw ieee1394 hwmon chipreg usbhid soundcore map_funcs i2c_core cdrom button floppy sg sd_mod ehci_hcd ohci_hcd amd74xx ide_core edd reiserfs fan pata_amd sata_nv libata dock aacraid scsi_mod thermal processor
Pid: 2220, comm: modprobe Not tainted 2.6.27-git8-default #5
RIP: 0010:[<ffffffff8035c71d>]  [<ffffffff8035c71d>] vsnprintf+0x3d/0x7f0
RSP: 0018:ffff88007e4f7978  EFLAGS: 00010286
RAX: 0000000000000014 RBX: 0000000000000000 RCX: ffff88007e4f7b38
RDX: 0000000000000000 RSI: 0000000000000014 RDI: ffff88007e5d0530
RBP: fffffffffffffff4 R08: ffff88007e4f7b38 R09: ffff88007e5d0400
R10: ffff88007e5d0544 R11: 0000000000000002 R12: ffff88007e4ae940
R13: 000000000d400003 R14: ffff88007f1b0080 R15: ffff88007e4f7b38
FS:  00007f84e0a7e6f0(0000) GS:ffffffff8073e980(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000007e4ba000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 2220, threadinfo ffff88007e4f6000, task ffff88007ded4090)
Stack:
 0000000000000000 ffffffff80384b00 ffffffff8086fbc0 0000000000000744
 0000000000000040 0000000000000014 ffff88007e5d0530 ffff88007ef29800
 0000000000000000 ffff880001035a80 0000000000000720 0000000000000001
Call Trace:
 [<ffffffff80384b00>] ? fbcon_scroll+0x240/0xdc0
 [<ffffffff80381b99>] ? fbcon_cursor+0x1d9/0x360
 [<ffffffff803878c0>] ? bit_cursor+0x0/0x620
 [<ffffffff803ca698>] ? vt_console_print+0x288/0x390
 [<ffffffff803e2742>] ? device_create_vargs+0xf2/0x110
 [<ffffffff803e279a>] ? device_create+0x3a/0x50
 [<ffffffff802b342c>] ? kmem_cache_alloc+0xac/0x180
 [<ffffffffa02897f8>] ? dvb_register_device+0x1f8/0x290 [dvb_core]
 [<ffffffffa0291db5>] ? dvb_register_frontend+0x145/0x160 [dvb_core]
 [<ffffffffa02bb33c>] ? videobuf_dvb_register_bus+0xcc/0x3a0 [videobuf_dvb]
 [<ffffffffa03923bf>] ? cx23885_dvb_register+0x1ef/0xea0 [cx23885]
 [<ffffffffa03963de>] ? cx23885_initdev+0x9be/0xaca [cx23885]
 [<ffffffff8036dcd4>] ? pci_device_probe+0xf4/0x150
 [<ffffffff803e485e>] ? driver_probe_device+0x9e/0x1d0
 [<ffffffff803e4a33>] ? __driver_attach+0xa3/0xb0
 [<ffffffffa038fb30>] ? cx23885_init+0x0/0x40 [cx23885]
 [<ffffffff803e4990>] ? __driver_attach+0x0/0xb0
 [<ffffffff803e401b>] ? bus_for_each_dev+0x5b/0x80
 [<ffffffffa038fb30>] ? cx23885_init+0x0/0x40 [cx23885]
 [<ffffffff803e3898>] ? bus_add_driver+0x208/0x280
 [<ffffffffa038fb30>] ? cx23885_init+0x0/0x40 [cx23885]
 [<ffffffff803e4c19>] ? driver_register+0x69/0x150
 [<ffffffffa038fb30>] ? cx23885_init+0x0/0x40 [cx23885]
 [<ffffffff8036dfbb>] ? __pci_register_driver+0x6b/0xc0
 [<ffffffffa038fb30>] ? cx23885_init+0x0/0x40 [cx23885]
 [<ffffffff8020903b>] ? _stext+0x3b/0x180
 [<ffffffff8026ada5>] ? sys_init_module+0xb5/0x1e0
 [<ffffffff8020c2db>] ? system_call_fastpath+0x16/0x1b
Code: ec 38 01 00 00 48 89 74 24 28 8b 44 24 28 48 89 7c 24 30 85 c0 0f 88 8a 07 00 00 4c 8b 54 24 30 4c 03 54 24 28 0f 82 a3 03 00 00 <0f> b6 0b 8b 44 24 30 4c 8b 74 24 30 89 44 24 3c 84 c9 4c 89 f7 
RIP  [<ffffffff8035c71d>] vsnprintf+0x3d/0x7f0
 RSP <ffff88007e4f7978>
CR2: 0000000000000000
---[ end trace 1cbc216a9642aab5 ]---

========================================================
beats me what this means besides doom as disaster.
So I was hoping the problem was related to all of those modules I didn't need.
so I went into ........../v4l-dvb
make "menuconfig"
I stripped it down to 55 modules.
Went into /lib/modules/2.6.27.............
rm -r *
/usr/src/linux-2.6.27
make modules
make modules_install
---
reboot
go back to v4l-dvb
make insmod
Another Crash as follows:
===============================================================

Linux video capture interface: v2.00
btaudio: driver version 0.7 loaded [digital+analog]
cx18:  Start initialization, version 1.0.1
cx18:  End initialization
cx23885 driver version 0.0.1 loaded
cx23885 0000:06:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]
input: i2c IR (FusionHDTV) as /class/input/input6
ir-kbd-i2c: i2c IR (FusionHDTV) detected at i2c-2/2-006b/ir0 [cx23885[0]]
tuner' 2-0064: chip found @ 0xc8 (cx23885[0])
tuner' 3-0064: chip found @ 0xc8 (cx23885[0])
cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
xc5000 2-0064: creating new instance
xc5000: Successfully identified at address 0x64
xc5000: Firmware has not been loaded previously
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8035c71d>] vsnprintf+0x3d/0x7f0
PGD 505ad067 PUD 50cbe067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/class/input/input6/capabilities/sw
CPU 1 
Modules linked in: cx23885(+) tuner cx18 videobuf_dvb or51132 cx2341x tuner_simple compat_ioctl32 wm8775 cx25840 videobuf_dma_sg tda8290 cs5345 lgdt330x dib7000p stv0299 ir_kbd_i2c nxt200x mxl5005s tda18271 tda827x v4l2_common stv0288 dvb_pll cx22702 stb6000 v4l2_int_device mt352 btaudio s5h1409 videodev cx24116 dibx000_common cx24123 mt2131 dvb_core videobuf_core snd_bt87x tda10048 tuner_types tveeprom xc5000 tuner_xc2028 tda9887 isl6421 cx88_vp3054_i2c ir_common btcx_risc s5h1411 zl10353 i2c_algo_bit iptable_filter ip_tables ip6table_filter ip6_tables x_tables af_packet ipv6 snd_pcm_oss snd_mixer_oss snd_seq_midi snd_emu10k1_synth raw snd_emux_synth it87 snd_seq_virmidi hwmon_vid snd_seq_midi_event snd_seq_midi_emul snd_seq binfmt_misc fuse dm_crypt udf crc_itu_t ext3 jbd mbcache loop dm_mod snd_emu10k1 snd_rawmidi snd_ac97_codec cfi_cmdset_0002 ac97_bus cfi_util snd_pcm snd_seq_device jedec_probe snd_timer snd_page_alloc cfi_probe gen_probe snd_util_mem snd_hwdep ck804xrom snd mtd k8temp sr_mod chipreg i2c_nforce2 ohci1394 ieee1394 usbhid cdrom button map_funcs i2c_core soundcore serio_raw hwmon sg floppy sd_mod ehci_hcd ohci_hcd amd74xx ide_core edd reiserfs fan pata_amd sata_nv libata dock aacraid scsi_mod thermal processor [last unloaded: zl10353]
Pid: 9530, comm: insmod Not tainted 2.6.27-git8-default #5
RIP: 0010:[<ffffffff8035c71d>]  [<ffffffff8035c71d>] vsnprintf+0x3d/0x7f0
RSP: 0018:ffff8800505fb978  EFLAGS: 00010286
RAX: 0000000000000014 RBX: 0000000000000000 RCX: ffff8800505fbb38
RDX: 0000000000000000 RSI: 0000000000000014 RDI: ffff880066d9f530
RBP: fffffffffffffff4 R08: ffff8800505fbb38 R09: ffff880066d9f400
R10: ffff880066d9f544 R11: 000000008086f7c0 R12: ffff88007d9f6bc0
R13: 000000000d400003 R14: ffff88007f1af880 R15: ffff8800505fbb38
FS:  00002aafc670d6f0(0000) GS:ffff88007fb9c940(0000) knlGS:00000000f7e516c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000505aa000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process insmod (pid: 9530, threadinfo ffff8800505fa000, task ffff88005dd7ed90)
Stack:
 ffffffff8086f7c0 8086f7c08086f7c0 ffffffff8086fbc0 0000000000000400
 ffffffff8086f7c0 0000000000000014 ffff880066d9f530 ffffffff8035c634
 ffffffffa06c557c 000000008086f7c0 ffffffff8086fbc0 0000000000000400
Call Trace:
 [<ffffffff8035c634>] ? string+0x34/0xe0
 [<ffffffffa06bcab2>] ? i2c_sendbytes+0x2f2/0x3d0 [cx23885]
 [<ffffffff802939ad>] ? zone_statistics+0x7d/0x80
 [<ffffffff8025caa6>] ? up+0x16/0x50
 [<ffffffff8025caa6>] ? up+0x16/0x50
 [<ffffffff803e2742>] ? device_create_vargs+0xf2/0x110
 [<ffffffff803e279a>] ? device_create+0x3a/0x50
 [<ffffffff802b342c>] ? kmem_cache_alloc+0xac/0x180
 [<ffffffffa05517f8>] ? dvb_register_device+0x1f8/0x290 [dvb_core]
 [<ffffffffa0559d85>] ? dvb_register_frontend+0x145/0x160 [dvb_core]
 [<ffffffffa068033c>] ? videobuf_dvb_register_bus+0xcc/0x3a0 [videobuf_dvb]
 [<ffffffffa06bd25d>] ? cx23885_dvb_register+0x1ed/0x6d0 [cx23885]
 [<ffffffffa06c0aae>] ? cx23885_initdev+0x9be/0xaca [cx23885]
 [<ffffffff8036dcd4>] ? pci_device_probe+0xf4/0x150
 [<ffffffff803e485e>] ? driver_probe_device+0x9e/0x1d0
 [<ffffffff803e4a33>] ? __driver_attach+0xa3/0xb0
 [<ffffffffa06ba9d0>] ? cx23885_init+0x0/0x40 [cx23885]
 [<ffffffff803e4990>] ? __driver_attach+0x0/0xb0
 [<ffffffff803e401b>] ? bus_for_each_dev+0x5b/0x80
 [<ffffffffa06ba9d0>] ? cx23885_init+0x0/0x40 [cx23885]
 [<ffffffff803e3898>] ? bus_add_driver+0x208/0x280
 [<ffffffffa06ba9d0>] ? cx23885_init+0x0/0x40 [cx23885]
 [<ffffffff803e4c19>] ? driver_register+0x69/0x150
 [<ffffffffa06ba9d0>] ? cx23885_init+0x0/0x40 [cx23885]
 [<ffffffff8036dfbb>] ? __pci_register_driver+0x6b/0xc0
 [<ffffffffa06ba9d0>] ? cx23885_init+0x0/0x40 [cx23885]
 [<ffffffff8020903b>] ? _stext+0x3b/0x180
 [<ffffffff8026ada5>] ? sys_init_module+0xb5/0x1e0
 [<ffffffff8020c2db>] ? system_call_fastpath+0x16/0x1b
Code: ec 38 01 00 00 48 89 74 24 28 8b 44 24 28 48 89 7c 24 30 85 c0 0f 88 8a 07 00 00 4c 8b 54 24 30 4c 03 54 24 28 0f 82 a3 03 00 00 <0f> b6 0b 8b 44 24 30 4c 8b 74 24 30 89 44 24 3c 84 c9 4c 89 f7 
RIP  [<ffffffff8035c71d>] vsnprintf+0x3d/0x7f0
 RSP <ffff8800505fb978>
CR2: 0000000000000000
---[ end trace 3848328628b7b75a ]---
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]: subsystem: 1002:a101, board: ATI HDTV Wonder [card=34,autodetected], frontend(s): 1
cx88[0]: TV tuner type 68, Radio tuner type -1
cx88[0]: Test OK
tuner' 5-0043: chip found @ 0x86 (cx88[0])
tda9887 5-0043: creating new instance
tda9887 5-0043: tda988[5/6/7] found
tuner' 5-0061: chip found @ 0xc2 (cx88[0])
tuner-simple 5-0061: creating new instance
tuner-simple 5-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:01:07.2: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
cx88[0]/2: found at 0000:01:07.2, rev: 5, irq: 17, latency: 32, mmio: 0xf9000000
cx8802_probe() allocating 1 frontend(s)
cx88[1]: subsystem: 1002:a101, board: ATI HDTV Wonder [card=34,autodetected], frontend(s): 1
cx88[1]: TV tuner type 68, Radio tuner type -1
cx88[1]: Test OK
tuner' 6-0043: chip found @ 0x86 (cx88[1])
tda9887 6-0043: creating new instance
tda9887 6-0043: tda988[5/6/7] found
tuner' 6-0061: chip found @ 0xc2 (cx88[1])
tuner-simple 6-0061: creating new instance
tuner-simple 6-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
cx88[1]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
cx88-mpeg driver manager 0000:01:08.2: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
cx88[1]/2: found at 0000:01:08.2, rev: 5, irq: 18, latency: 32, mmio: 0xf6000000
cx8802_probe() allocating 1 frontend(s)
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx8800 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 17, latency: 32, mmio: 0xfb000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi1
cx8800 0000:01:08.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
cx88[1]/0: found at 0000:01:08.0, rev: 5, irq: 18, latency: 32, mmio: 0xf8000000
cx88[1]/0: registered device video2 [v4l2]
cx88[1]/0: registered device vbi3
cx2388x alsa driver version 0.0.6 loaded
cx88_audio 0000:01:07.1: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88_audio 0000:01:08.1: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
cx88[1]/1: CX88x/1: ALSA support for cx2388x boards
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 1002:a101, board: ATI HDTV Wonder [card=34]
cx88[0]/2: cx2388x based DVB/ATSC card
nxt200x: NXT2004 Detected
tuner-simple 5-0061: attaching existing instance
tuner-simple 5-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
DVB: registering new adapter (cx88[0])

===============================================================

Well at least the other tuner loaded.
As far as decoding the crash dump, I didn't get a secret decoder ring so I don't know what to do.
I need some one to decode this mess and either apply the patch to the main code, or email
me a fix to test.

Thanks in advance,
Jonathan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
