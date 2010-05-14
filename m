Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:35170 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719Ab0ENVXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 May 2010 17:23:54 -0400
Subject: Re: Mercurial x git tree sync - was: Re: Remote control at Zolid
	Hybrid TV Tuner
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Sander Pientka <cumulus0007@gmail.com>,
	linux-media@vger.kernel.org, Douglas Landgraf <dougsland@gmail.com>
In-Reply-To: <4BEC48DF.8060900@gmail.com>
References: <db09c9681002161116k52278916ob68884ddc989044@mail.gmail.com>
	 <1266375385.3176.5.camel@pc07.localdom.local>
	 <db09c9681002170838tdb15cbbu67cd45a518c11b4b@mail.gmail.com>
	 <1266445236.7202.17.camel@pc07.localdom.local>
	 <AANLkTin6b9JT1j0iNBmrp0UIhN9Z2Y-V6xdrEy7g5NQb@mail.gmail.com>
	 <4BEAFA76.5070809@redhat.com>
	 <1273721312.10695.12.camel@pc07.localdom.local>
	 <4BEB84F5.5030506@redhat.com>
	 <1273736253.3197.71.camel@pc07.localdom.local>
	 <4BEBF165.4070603@redhat.com>
	 <1273772767.3195.21.camel@pc07.localdom.local>
	 <4BEC432D.5010501@redhat.com>  <4BEC48DF.8060900@gmail.com>
Content-Type: text/plain
Date: Fri, 14 May 2010 23:09:47 +0200
Message-Id: <1273871388.19421.25.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Donnerstag, den 13.05.2010, 15:45 -0300 schrieb Mauro Carvalho
Chehab:
> Mauro Carvalho Chehab wrote:
> > hermann pitton wrote:
> > 
> >>> My view is that the backport tree is very useful to have a broader number
> >>> of people testing V4L/DVB code, as it can be applied against legacy kernels.
> >>> Of course, for this to work, people should quickly fix broken backports
> >>> (that means that not only Douglas should work on it, but other developers
> >>> are welcomed to contribute with backport fixes).
> >> For now, if not using git, Sander needs a 2.6.33 with recent v4l-dvb
> >> then to provide relevant debug output and eventually patches.
> > 
> > Until Douglas or someone fix the breakages with older kernels, yes.
> 
> As the fix patch is really trivial, I found a couple of minutes to write a patch
> for fixing this issue. I haven't test the patch, but, as it uses the same backport
> logic as found at cx2355-ir, I don't expect much troubles on it.

Mauro, fine, it is a start.

Compiles down to to 2.6.30, but has some __check_debug warnings for
three static bool insmod options there. (build cron job of today)

To replace them with some int seems ok, but since no such warnings on
higher kernels for bool, likely some compat issue.

IR oopses on 2.6.30 with Pinnacle 310i on a first try.

Thanks for all explanations of the current sync procedures, Douglas does
well and four weeks without in depth backward compat are hard to avoid
either way.

Did not try on 2.6.33.4 yet, but should be OK. The rest we can fix after
the merge window.

Cheers,
Hermann

saa7133[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 5-004b: chip found @ 0x96 (saa7133[1])
tda829x 5-004b: setting tuner address to 61
tda829x 5-004b: type set to tda8290+75a
saa7133[1]: registered device video1 [v4l2]
saa7133[1]: registered device vbi1
saa7133[1]: registered device radio1
saa7133[2]: setting pci latency timer to 64
saa7133[2]: found at 0000:02:09.0, rev: 208, irq: 19, latency: 64, mmio: 0xfdefd000
saa7133[2]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i [card=101,autodetected]
saa7133[2]: board init: gpio is 600c000
IRQ 19/saa7133[2]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[2]: i2c eeprom 00: bd 11 2f 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[2]: i2c eeprom 10: ff e0 60 06 ff 20 ff ff 00 30 8d 2c b0 22 ff ff
saa7133[2]: i2c eeprom 20: 01 2c 01 02 02 01 04 30 98 ff 00 a5 ff 21 00 c2
saa7133[2]: i2c eeprom 30: 96 10 03 32 15 20 ff ff 0c 22 17 88 03 44 31 f9
saa7133[2]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 6-004b: chip found @ 0x96 (saa7133[2])
tda829x 6-004b: setting tuner address to 61
tda829x 6-004b: type set to tda8290+75a
Registered IR keymap rc-pinnacle-color
input: i2c IR (Pinnacle PCTV) as /devices/virtual/input/input8
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffffa00e97c7>] __ir_input_register+0x26d/0x2fd [ir_core]
PGD 3ecbd067 PUD 2006b067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/module/saa7134/initstate
CPU 0 
Modules linked in: rc_pinnacle_color ir_kbd_i2c(+) tda827x tda8290 tuner saa7134(+) v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core ir_common ir_core tveeprom sit tunnel4 fuse bridge stp llc bnep sco l2cap bluetooth sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath uinput snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm snd_timer r8169 ppdev snd mii soundcore snd_page_alloc parport_pc shpchp k8temp parport hwmon joydev floppy serio_raw pcspkr i2c_nforce2 ata_generic pata_acpi pata_amd radeon drm i2c_algo_bit i2c_core [last unloaded: v4l1_compat]
Pid: 3399, comm: modprobe Not tainted 2.6.30.10-105.2.16.fc11.x86_64 #1  
RIP: 0010:[<ffffffffa00e97c7>]  [<ffffffffa00e97c7>] __ir_input_register+0x26d/0x2fd [ir_core]
RSP: 0018:ffff88003b459cb8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880025921400 RCX: ffff880036127000
RDX: ffffffff81621420 RSI: 0000000000000282 RDI: ffffffff816213f0
RBP: ffff88003b459d08 R08: 0000000000000000 R09: ffffffff81557ea4
R10: ffff88003e944500 R11: ffff88003b459b00 R12: ffff880036127000
R13: ffffffffa00ff3f0 R14: 000000000000002a R15: ffffffffa00f2dbd
FS:  00007f404f9f16f0(0000) GS:ffff88000100a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000003c40d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 3399, threadinfo ffff88003b458000, task ffff880025949700)
Stack:
 ffff880000000000 ffff880025921560 0000000000000286 ffff880025921588
 0000000000000286 ffff880024ce0300 0000000080000000 ffffffffa00ff3f0
 ffff880036127000 ffff88003daaf800 ffff88003b459d68 ffffffffa00f298c
Call Trace:
 [<ffffffffa00f298c>] ir_probe+0x3e7/0x4b3 [ir_kbd_i2c]
 [<ffffffffa00f25a5>] ? ir_probe+0x0/0x4b3 [ir_kbd_i2c]
 [<ffffffffa0000387>] i2c_device_probe+0xc0/0x101 [i2c_core]
 [<ffffffff81272da1>] driver_probe_device+0xdb/0x1fb
 [<ffffffff81272f1e>] __driver_attach+0x5d/0x81
 [<ffffffff81272ec1>] ? __driver_attach+0x0/0x81
 [<ffffffff81272264>] bus_for_each_dev+0x53/0x88
 [<ffffffff81272b40>] driver_attach+0x1e/0x20
 [<ffffffff81272822>] bus_add_driver+0xf7/0x259
 [<ffffffff81273208>] driver_register+0x9d/0x10e
 [<ffffffffa00f8000>] ? ir_init+0x0/0x19 [ir_kbd_i2c]
 [<ffffffffa0001ee2>] i2c_register_driver+0x91/0x116 [i2c_core]
 [<ffffffffa00f8000>] ? ir_init+0x0/0x19 [ir_kbd_i2c]
 [<ffffffffa00f8017>] ir_init+0x17/0x19 [ir_kbd_i2c]
 [<ffffffff8100a069>] do_one_initcall+0x5e/0x162
 [<ffffffff8107028d>] sys_init_module+0xaa/0x1d5
 [<ffffffff81010cc2>] system_call_fastpath+0x16/0x1b
Code: 48 8b 7d c8 89 55 b0 e8 0a 1c 2f e1 8b 55 b0 b8 f4 ff ff ff 85 d2 75 5b 4c 89 e7 e8 72 e1 1f e1 85 c0 78 4f 48 8b 83 98 01 00 00 <83> 38 01 75 0c 4c 89 e7 e8 50 07 00 00 85 c0 78 29 31 c0 83 3d 
RIP  [<ffffffffa00e97c7>] __ir_input_register+0x26d/0x2fd [ir_core]
 RSP <ffff88003b459cb8>
CR2: 0000000000000000
---[ end trace 2cb06ca615ef014b ]---
saa7133[2]: registered device video2 [v4l2]
saa7133[2]: registered device vbi2
saa7133[2]: registered device radio2
saa7133[3]: setting pci latency timer to 64
saa7133[3]: found at 0000:02:0a.0, rev: 209, irq: 17, latency: 64, mmio: 0xfdefc000
saa7133[3]: subsystem: 16be:0007, board: Medion Md8800 Quadro [card=96,autodetected]
saa7133[3]: board init: gpio is 0




