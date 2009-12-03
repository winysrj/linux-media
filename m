Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:38194 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbZLCK5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 05:57:42 -0500
Received: by fxm21 with SMTP id 21so1265617fxm.1
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2009 02:57:48 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 3 Dec 2009 21:57:48 +1100
Message-ID: <d88f39950912030257n3a86c728mcaa0a79b15f938b3@mail.gmail.com>
Subject: cx2388x driver appears broken
From: Shaun Amy <shaun.amy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have successfully been running Ubuntu 9.10 on an old Pentium4
test-box.  The machine has two PCI cards, both of which worked with
stock 9.10 and with a slightly upgraded kernel (2.6.31-14-generic-pae
and 2.6.31-15-generic-pae).  These cards, have, in the past also
worked on Ubuntu 6.10 so have been supported for a long time.  The
output on the 2.6.31-15-generic-pae gives:

[    6.173285] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[    6.173349] cx8800 0000:02:0b.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.174531] cx88[0]: subsystem: 18ac:db10, board: DViCO FusionHDTV
DVB-T Plus [card=21,insmod option], frontend(s): 1
[    6.174537] cx88[0]: TV tuner type 4, Radio tuner type -1
[    6.183548] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[    6.340041] cx88[0]/0: found at 0000:02:0b.0, rev: 5, irq: 23,
latency: 32, mmio: 0xef000000
[    6.340065] IRQ 23/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    6.340191] cx88[0]/0: registered device video0 [v4l2]
[    6.340237] cx88[0]/0: registered device vbi0
[    6.340313] cx88[0]/2: cx2388x 8802 Driver Manager
[    6.340335] cx88-mpeg driver manager 0000:02:0b.2: PCI INT A -> GSI
23 (level, low) -> IRQ 23
[    6.340349] cx88[0]/2: found at 0000:02:0b.2, rev: 5, irq: 23,
latency: 32, mmio: 0xee000000
[    6.340358] IRQ 23/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    6.340395] cx8800 0000:02:0c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.341628] cx88[1]: subsystem: 17de:a8a6, board: Conexant DVB-T
reference design [card=19,insmod option], frontend(s): 1
[    6.341635] cx88[1]: TV tuner type 4, Radio tuner type -1
[    6.504094] cx88[1]/0: found at 0000:02:0c.0, rev: 5, irq: 20,
latency: 32, mmio: 0xed000000
[    6.504166] IRQ 20/cx88[1]: IRQF_DISABLED is not guaranteed on shared IRQs
[    6.504294] cx88[1]/0: registered device video1 [v4l2]
[    6.504342] cx88[1]/0: registered device vbi1
[    6.506583] cx88[1]/2: cx2388x 8802 Driver Manager
[    6.506609] cx88-mpeg driver manager 0000:02:0c.2: PCI INT A -> GSI
20 (level, low) -> IRQ 20
[    6.506625] cx88[1]/2: found at 0000:02:0c.2, rev: 5, irq: 20,
latency: 32, mmio: 0xec000000
[    6.506638] IRQ 20/cx88[1]: IRQF_DISABLED is not guaranteed on shared IRQs
[    6.609088]   alloc irq_desc for 18 on node -1
[    6.609095]   alloc kstat_irqs on node -1
[    6.609108] C-Media PCI 0000:02:0d.0: PCI INT A -> GSI 18 (level,
low) -> IRQ 18
[    6.873923] EXT4-fs (sda11): internal journal on sda11:8
[    7.011870] cx88/2: cx2388x dvb driver version 0.0.7 loaded
[    7.011877] cx88/2: registering cx8802 driver, type: dvb access: shared
[    7.011884] cx88[0]/2: subsystem: 18ac:db10, board: DViCO
FusionHDTV DVB-T Plus [card=21]
[    7.011889] cx88[0]/2: cx2388x based DVB/ATSC card
[    7.011893] cx8802_alloc_frontends() allocating 1 frontend(s)
[    7.092877] ip_tables: (C) 2000-2006 Netfilter Core Team
[    7.397447] DVB: registering new adapter (cx88[0])
[    7.397457] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[    7.398038] cx88[1]/2: subsystem: 17de:a8a6, board: Conexant DVB-T
reference design [card=19]
[    7.398046] cx88[1]/2: cx2388x based DVB/ATSC card
[    7.398050] cx8802_alloc_frontends() allocating 1 frontend(s)
[    7.434445] DVB: registering new adapter (cx88[1])
[    7.434456] DVB: registering adapter 1 frontend 0 (Conexant CX22702 DVB-T)...

In order to debug a problem with a new dual tuner USB module, I
grabbed the latest v4l-dvb and built all the modules from source (sans
FireTV) and installed them using the provided makefile targets.  This
results in the following:

[    5.831860] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[    5.833100] cx88[0]: subsystem: 18ac:db10, board: DViCO FusionHDTV
DVB-T Plus [card=21,insmod option], frontend(s): 1
[    5.833107] cx88[0]: TV tuner type 4, Radio tuner type -1
[    5.846548] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[    5.884782] EXT4-fs (sda11): internal journal on sda11:8
[    6.012069] BUG: unable to handle kernel NULL pointer dereference at (null)
[    6.012313] IP: [<e0db9aa6>] ir_input_free+0x16/0x40 [ir_common]
[    6.012490] *pdpt = 000000001e550001 *pde = 0000000000000000
[    6.012725] Oops: 0000 [#1] SMP
[    6.012957] last sysfs file: /sys/devices/virtual/dmi/id/sys_vendor
[    6.013048] Modules linked in: snd_opl3_lib snd_timer x_tables
snd_hwdep cx8800(+) cx8802(+) snd_mpu401_uart cx88xx ir_common
i2c_algo_bit snd_rawmidi v4l2_common snd_seq_device tveeprom videodev
v4l1_compat videobuf_dma_sg btcx_risc snd videobuf_core soundcore
ppdev parport_pc shpchp lp intel_agp parport agpgart psmouse serio_raw
e100 mii natsemi floppy
[    6.015697]
[    6.015784] Pid: 534, comm: modprobe Not tainted
(2.6.31-15-generic-pae #50-Ubuntu) System Name
[    6.015886] EIP: 0060:[<e0db9aa6>] EFLAGS: 00010246 CPU: 0
[    6.015983] EIP is at ir_input_free+0x16/0x40 [ir_common]
[    6.016013] EAX: 00000000 EBX: 00000000 ECX: ffffffed EDX: de08778c
[    6.016013] ESI: de087000 EDI: d7c60800 EBP: d81a5d38 ESP: d81a5d30
[    6.016013]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    6.016013] Process modprobe (pid: 534, ti=d81a4000 task=decab240
task.ti=d81a4000)
[    6.016013] Stack:
[    6.016013]  00000200 de540400 d81a5d70 e0e14787 00000000 00000000
00000000 ffffffff
[    6.016013] <0> ffffffed d7c60800 d7c60800 d7c60800 df8a7000
d7c60800 d7c60a84 d7c60a84
[    6.016013] <0> d81a5dfc e0e1018a e0e1cd7c d7c60810 00000004
ffffffff e0e1bd84 00000015
[    6.016013] Call Trace:
[    6.016013]  [<e0e14787>] ? cx88_ir_init+0x77/0x5c3 [cx88xx]
[    6.016013]  [<e0e1018a>] ? cx88_core_create+0x84a/0x1130 [cx88xx]
[    6.016013]  [<c03151e4>] ? ida_get_new_above+0x104/0x1a0
[    6.016013]  [<c023eb3f>] ? __sysfs_add_one+0x1f/0xc0
[    6.016013]  [<e0e10de5>] ? cx88_core_get+0x85/0xd0 [cx88xx]
[    6.016013]  [<e0e8a6ed>] ? cx8802_probe+0x15/0x2cd [cx8802]
[    6.016013]  [<c023e13b>] ? sysfs_addrm_start+0x5b/0xa0
[    6.016013]  [<c032c57e>] ? pci_match_device+0xbe/0xd0
[    6.016013]  [<c032c3ae>] ? local_pci_probe+0xe/0x10
[    6.016013]  [<c032d130>] ? pci_device_probe+0x60/0x80
[    6.016013]  [<c03a7a70>] ? really_probe+0x50/0x140
[    6.016013]  [<c0576b6a>] ? _spin_lock_irqsave+0x2a/0x40
[    6.016013]  [<c03a7b79>] ? driver_probe_device+0x19/0x20
[    6.016013]  [<c03a7bf9>] ? __driver_attach+0x79/0x80
[    6.016013]  [<c03a70c8>] ? bus_for_each_dev+0x48/0x70
[    6.016013]  [<c03a7939>] ? driver_attach+0x19/0x20
[    6.016013]  [<c03a7b80>] ? __driver_attach+0x0/0x80
[    6.016013]  [<c03a731f>] ? bus_add_driver+0xbf/0x2a0
[    6.016013]  [<c032d070>] ? pci_device_remove+0x0/0x40
[    6.016013]  [<c03a7e85>] ? driver_register+0x65/0x120
[    6.016013]  [<c0575a14>] ? mutex_lock+0x14/0x40
[    6.016013]  [<c032d350>] ? __pci_register_driver+0x40/0xb0
[    6.016013]  [<e0e8f03e>] ? cx8802_init+0x3e/0x40 [cx8802]
[    6.016013]  [<c010112c>] ? do_one_initcall+0x2c/0x190
[    6.016013]  [<e0e8f000>] ? cx8802_init+0x0/0x40 [cx8802]
[    6.016013]  [<c0175671>] ? sys_init_module+0xb1/0x1f0
[    6.016013]  [<c010336c>] ? syscall_call+0x7/0xb
[    6.016013] Code: 89 7c 24 04 c7 04 24 dc 9d db e0 e8 0b ad 7b df
eb e4 8d 76 00 55 89 e5 53 83 ec 04 8b 98 ec 07 00 00 a1 dc 46 dc e0
85 c0 7f 1a <8b> 03 c7 43 04 00 00 00 00 e8 ec 90 42 df c7 03 00 00 00
00 83
[    6.016013] EIP: [<e0db9aa6>] ir_input_free+0x16/0x40 [ir_common]
SS:ESP 0068:d81a5d30
[    6.016013] CR2: 0000000000000000
[    6.026493] ---[ end trace 8926730ffc0a686f ]---

which is seen without any modifications to the v4l-dvb tree.  I am
using the standard build tools (e.g. gcc (Ubuntu 4.4.1-4ubuntu8)
4.4.1).

hg identify gives:

e0cd9a337600 tip

and there are no available updates.

Assuming we can fix this problem and my minor driver addition actually
works then I will submit patches to support the variant of the USB
tuner I wish to get functioning.

Hopefully this is something that people with far more knowledge and
skill in this area than myself can resolve.

Thanks in advance.

Shaun.
