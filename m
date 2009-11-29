Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50416 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZK2UTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 15:19:14 -0500
Message-ID: <4B12D745.8050804@martin-kittel.de>
Date: Sun, 29 Nov 2009 21:19:17 +0100
From: Martin Kittel <linux@martin-kittel.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: HVR-1300: kernel NULL pointer dereference in ir_common
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

since I've been having problems with not seeing my IR remote in recent 
kernelsx any more (starting at least with 2.6.30) I tried the current 
version of the v4l-dvb tree (revision 13538) and 2.6.32-rc7 on my amd64 
with a Hauppauge HVR1300.
With that version I get a kernel bug upon module load.
Here's the relevant section of dmesg:

[    3.701212] ohci_hcd 0000:00:04.0: suspend root hub
[    4.015041] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[    4.015577] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[    4.015583]   alloc irq_desc for 18 on node 0
[    4.015586]   alloc kstat_irqs on node 0
[    4.015597] cx8800 0000:01:07.0: PCI INT A -> Link[LNKB] -> GSI 18 
(level, low) -> IRQ 18
[    4.016130] cx88[0]: subsystem: 0070:9601, board: Hauppauge 
WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56,autodetected], 
frontend(s): 1
[    4.016133] cx88[0]: TV tuner type 63, Radio tuner type -1
[    4.016569] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[    4.019290] cx2388x alsa driver version 0.0.7 loaded
[    4.130200] cx88[0]: i2c init: enabling analog demod on 
HVR1300/3000/4000 tuner
[    4.182512] tuner 0-0043: chip found @ 0x86 (cx88[0])
[    4.186181] tda9887 0-0043: creating new instance
[    4.186185] tda9887 0-0043: tda988[5/6/7] found
[    4.189759] tuner 0-0061: chip found @ 0xc2 (cx88[0])
[    4.228066] tveeprom 0-0050: Hauppauge model 96019, rev D6D3, serial# 
3106328
[    4.228070] tveeprom 0-0050: MAC address is 00-0D-FE-2F-66-18
[    4.228073] tveeprom 0-0050: tuner model is Philips FMD1216MEX (idx 
133, type 78)
[    4.228078] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    4.228082] tveeprom 0-0050: audio processor is CX882 (idx 33)
[    4.228084] tveeprom 0-0050: decoder processor is CX882 (idx 25)
[    4.228087] tveeprom 0-0050: has radio, has IR receiver, has IR 
transmitter
[    4.228090] cx88[0]: hauppauge eeprom: model=96019
[    4.233553] tuner-simple 0-0061: creating new instance
[    4.233559] tuner-simple 0-0061: type set to 78 (Philips FMD1216MEX 
MK3 Hybrid Tuner)
[    4.237571] BUG: unable to handle kernel NULL pointer dereference at 
(null)
[    4.237646] IP: [<ffffffffa00326df>] ir_input_free+0x2f/0x49 [ir_common]
[    4.237707] PGD 76319067 PUD 762f5067 PMD 0
[    4.237796] Oops: 0000 [#1] SMP
[    4.237863] last sysfs file: /sys/module/tuner/initstate
[    4.237892] CPU 0
[    4.237936] Modules linked in: tuner_simple tuner_types tda9887 
tda8290 tuner cx88_alsa(+) cx8802(+) cx8800(+) cx88xx v4l2_common 
videodev ir_common tveeprom v4l1_compat v4l2_compat_ioctl32 
videobuf_dma_sg videobuf_core btcx_risc
[    4.238004] Pid: 2445, comm: work_for_cpu Not tainted 2.6.32-rc7 #5 
System Product Name
[    4.238004] RIP: 0010:[<ffffffffa00326df>]  [<ffffffffa00326df>] 
ir_input_free+0x2f/0x49 [ir_common]
[    4.238004] RSP: 0018:ffff880075ffbce0  EFLAGS: 00010246
[    4.238004] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
0000000000000000
[    4.238004] RDX: ffff880074f64000 RSI: ffffffff8171a170 RDI: 
ffff880074c0b828
[    4.238004] RBP: ffff880075ffbcf0 R08: ffffffffa00b68e9 R09: 
ffff880074f64018
[    4.238004] R10: ffff88007616dde8 R11: ffff880074f64000 R12: 
00000000ffffffed
[    4.238004] R13: 0000000000000200 R14: ffff880074c0b000 R15: 
ffff880075ffbdd0
[    4.238004] FS:  00007f9e7b5a2760(0000) GS:ffff880001a00000(0000) 
knlGS:0000000000000000
[    4.238004] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    4.238004] CR2: 0000000000000000 CR3: 00000000763cf000 CR4: 
00000000000006f0
[    4.238004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[    4.238004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[    4.238004] Process work_for_cpu (pid: 2445, threadinfo 
ffff880075ffa000, task ffff880077bbf260)
[    4.238004] Stack:
[    4.238004]  ffff880074f64000 ffff880076b26000 ffff880075ffbd40 
ffffffffa006401e
[    4.238004] <0> ffff880077158800 ffff880074f64000 ffff880075ffbd20 
ffff880074f64428
[    4.238004] <0> ffff880074f64000 ffff880074f64428 ffff880074f64018 
ffff880075ffbdd0
[    4.238004] Call Trace:
[    4.238004]  [<ffffffffa006401e>] cx88_ir_init+0x4a0/0x532 [cx88xx]
[    4.238004]  [<ffffffffa006082b>] cx88_core_create+0x106c/0x1085 [cx88xx]
[    4.238004]  [<ffffffffa005f000>] ? cx88_tuner_callback+0x0/0x507 
[cx88xx]
[    4.238004]  [<ffffffffa0060b6c>] cx88_core_get+0x89/0xc7 [cx88xx]
[    4.238004]  [<ffffffffa007bed7>] cx8800_initdev+0x5e/0x5ad [cx8800]
[    4.238004]  [<ffffffff810343cb>] ? __wake_up_common+0x46/0x75
[    4.238004]  [<ffffffff81059a79>] ? do_work_for_cpu+0x0/0x25
[    4.238004]  [<ffffffff811f4617>] local_pci_probe+0x12/0x16
[    4.238004]  [<ffffffff81059a8c>] do_work_for_cpu+0x13/0x25
[    4.238004]  [<ffffffff81059a79>] ? do_work_for_cpu+0x0/0x25
[    4.238004]  [<ffffffff8105cdc2>] kthread+0x7d/0x85
[    4.238004]  [<ffffffff8100ca9a>] child_rip+0xa/0x20
[    4.238004]  [<ffffffff8105cd45>] ? kthread+0x0/0x85
[    4.238004]  [<ffffffff8100ca90>] ? child_rip+0x0/0x20
[    4.238004] Code: 28 08 00 00 48 89 e5 53 48 83 ec 08 e8 d5 e8 27 e1 
83 3d fc 5c 00 00 00 48 89 c3 7e 0e 48 c7 c7 ba 2b 03 a0 31 c0 e8 e7 95 
4e e1 <48> 8b 3b c7 43 08 00 00 00 00 e8 e9 a2 0a e1 48 c7 03 00 00 00
[    4.238004] RIP  [<ffffffffa00326df>] ir_input_free+0x2f/0x49 [ir_common]
[    4.238004]  RSP <ffff880075ffbce0>
[    4.238004] CR2: 0000000000000000
[    4.249764] ---[ end trace 9df503d7504588a3 ]---
[  185.300723] date used greatest stack depth: 4296 bytes left

I did a clean recompile (make clean on kernel side, make distclean on 
v4l-dvb), but the problem is still there.

Thanks for any pointers,

Martin.
