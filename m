Return-path: <linux-media-owner@vger.kernel.org>
Received: from pop.fonet.fi ([94.101.0.8]:59822 "EHLO pop.fonet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab0BFVD7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Feb 2010 16:03:59 -0500
Received: from localhost (localhost [127.0.0.1])
	by pop.fonet.fi (Postfix) with ESMTP id 7E766235835F
	for <linux-media@vger.kernel.org>; Sat,  6 Feb 2010 22:37:29 +0200 (EET)
Received: from pop.fonet.fi ([127.0.0.1])
	by localhost (pop.fonet.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GmFRtcvQaPnf for <linux-media@vger.kernel.org>;
	Sat,  6 Feb 2010 22:37:28 +0200 (EET)
Received: from [192.168.2.175] (host-94-101-5-242.igua.fi [94.101.5.242])
	by pop.fonet.fi (Postfix) with ESMTP id 29CFD2358330
	for <linux-media@vger.kernel.org>; Sat,  6 Feb 2010 22:37:27 +0200 (EET)
Message-ID: <4B6DD307.2000000@iki.fi>
Date: Sat, 06 Feb 2010 22:37:27 +0200
From: Jouni Karvo <Jouni.Karvo@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: problems with s2-liplianin mantis
Content-Type: multipart/mixed;
 boundary="------------070909010405070409020903"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070909010405070409020903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


hi,

I have some problem with S2-liplianin Mantis, version 41ce9532e338.

The driver sometimes does not produce data, and when I tried the
"typical to VDR driver reload"-thing, the kernel OOPSed, as in the
attached syslog.

kex@vdr:~$ uname -a
Linux vdr 2.6.32.3-jk #1 SMP PREEMPT Sat Jan 30 23:12:14 EET 2010 x86_64
GNU/Linux

kex@vdr:~$ gcc --version
gcc (Debian 4.3.4-6) 4.3.4
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

yours,
       Jouni




--------------070909010405070409020903
Content-Type: text/plain;
 name="syslog.mantis"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="syslog.mantis"

Feb  6 22:18:52 vdr vdr: [8249] emergency exit!
Feb  6 22:18:52 vdr vdr: [8249] exiting, exit code 1
Feb  6 22:18:52 vdr kernel: mantis_core_exit (1): DMA engine stopping
Feb  6 22:18:52 vdr kernel: mantis_dma_exit (1): DMA=0x69550000 cpu=0xffff880069550000 size=65536
Feb  6 22:18:52 vdr kernel: mantis_dma_exit (1): RISC=0x6d633000 cpu=0xffff88006d633000 size=1000
Feb  6 22:18:52 vdr kernel: mantis_hif_exit (1): Adapter(1) Exiting Mantis Host Interface
Feb  6 22:18:52 vdr kernel: mantis_ca_exit (1): Unregistering EN50221 device
Feb  6 22:18:52 vdr kernel: mantis_pci_remove (1): Removing -->Mantis irq: 17, latency: 64
Feb  6 22:18:52 vdr kernel: memory: 0xfbffe000, mmio: 0xffffc90010174000
Feb  6 22:18:52 vdr kernel: Mantis 0000:04:01.0: PCI INT A disabled
Feb  6 22:18:52 vdr kernel: mantis_core_exit (0): DMA engine stopping
Feb  6 22:18:52 vdr kernel: mantis_dma_exit (0): DMA=0x69640000 cpu=0xffff880069640000 size=65536
Feb  6 22:18:52 vdr kernel: mantis_dma_exit (0): RISC=0x69749000 cpu=0xffff880069749000 size=1000
Feb  6 22:18:52 vdr kernel: mantis_hif_exit (0): Adapter(0) Exiting Mantis Host Interface
Feb  6 22:18:52 vdr kernel: mantis_ca_exit (0): Unregistering EN50221 device
Feb  6 22:18:52 vdr kernel: mantis_pci_remove (0): Removing -->Mantis irq: 16, latency: 64
Feb  6 22:18:52 vdr kernel: memory: 0xfbfff000, mmio: 0xffffc9001014e000
Feb  6 22:18:52 vdr kernel: Mantis 0000:04:00.0: PCI INT A disabled
Feb  6 22:18:52 vdr kernel: saa7146: unregister extension 'budget dvb'.
Feb  6 22:18:52 vdr kernel: budget dvb 0000:04:02.0: PCI INT A disabled
Feb  6 22:18:53 vdr kernel: Mantis 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Feb  6 22:18:53 vdr kernel: irq: 16, latency: 64
Feb  6 22:18:53 vdr kernel: memory: 0xfbfff000, mmio: 0xffffc90010154000
Feb  6 22:18:53 vdr kernel: found a VP-2040 PCI DVB-C device on (04:00.0),
Feb  6 22:18:53 vdr kernel:    Mantis Rev 1 [153b:1178], irq: 16, latency: 64
Feb  6 22:18:53 vdr kernel:    memory: 0xfbfff000, mmio: 0xffffc90010154000
Feb  6 22:18:53 vdr kernel:    MAC Address=[00:08:ca:1d:3c:ca]
Feb  6 22:18:53 vdr kernel: mantis_alloc_buffers (0): DMA=0x69640000 cpu=0xffff880069640000 size=65536
Feb  6 22:18:53 vdr kernel: mantis_alloc_buffers (0): RISC=0x68f2d000 cpu=0xffff880068f2d000 size=1000
Feb  6 22:18:53 vdr kernel: DVB: registering new adapter (Mantis dvb adapter)
Feb  6 22:18:54 vdr kernel: mantis_frontend_init (0): Probing for CU1216 (DVB-C)
Feb  6 22:18:54 vdr kernel: TDA10023: i2c-addr = 0x0c, id = 0x7d
Feb  6 22:18:54 vdr kernel: mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
Feb  6 22:18:54 vdr kernel: mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
Feb  6 22:18:54 vdr kernel: DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
Feb  6 22:18:54 vdr kernel: mantis_ca_init (0): Registering EN50221 device
Feb  6 22:18:54 vdr kernel: mantis_ca_init (0): Registered EN50221 device
Feb  6 22:18:54 vdr kernel: mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
Feb  6 22:18:54 vdr kernel: input: Mantis VP-2040 IR Receiver as /devices/virtual/input/input69
Feb  6 22:18:54 vdr kernel: Creating IR device irrcv64
Feb  6 22:18:54 vdr kernel: Mantis 0000:04:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Feb  6 22:18:54 vdr kernel: irq: 17, latency: 64
Feb  6 22:18:54 vdr kernel: memory: 0xfbffe000, mmio: 0xffffc90010166000
Feb  6 22:18:54 vdr kernel: found a VP-2040 PCI DVB-C device on (04:01.0),
Feb  6 22:18:54 vdr kernel:    Mantis Rev 1 [153b:1178], irq: 17, latency: 64
Feb  6 22:18:54 vdr kernel:    memory: 0xfbffe000, mmio: 0xffffc90010166000
Feb  6 22:18:54 vdr kernel:    MAC Address=[00:08:ca:1c:82:56]
Feb  6 22:18:54 vdr kernel: mantis_alloc_buffers (1): DMA=0x69550000 cpu=0xffff880069550000 size=65536
Feb  6 22:18:54 vdr kernel: mantis_alloc_buffers (1): RISC=0x7ea6b000 cpu=0xffff88007ea6b000 size=1000
Feb  6 22:18:54 vdr kernel: DVB: registering new adapter (Mantis dvb adapter)
Feb  6 22:18:54 vdr kernel: Mantis VP-2040 IR Receiver: unknown key for scancode 0x0000
Feb  6 22:18:54 vdr kernel: Mantis VP-2040 IR Receiver: unknown key: key=0x00 down=1
Feb  6 22:18:54 vdr kernel: Mantis VP-2040 IR Receiver: unknown key: key=0x00 down=0
Feb  6 22:18:54 vdr kernel: mantis_frontend_init (1): Probing for CU1216 (DVB-C)
Feb  6 22:18:54 vdr kernel: TDA10023: i2c-addr = 0x0c, id = 0x7d
Feb  6 22:18:54 vdr kernel: mantis_frontend_init (1): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
Feb  6 22:18:54 vdr kernel: mantis_frontend_init (1): Mantis DVB-C Philips CU1216 frontend attach success
Feb  6 22:18:54 vdr kernel: DVB: registering adapter 1 frontend 0 (Philips TDA10023 DVB-C)...
Feb  6 22:18:54 vdr kernel: mantis_ca_init (1): Registering EN50221 device
Feb  6 22:18:54 vdr kernel: mantis_ca_init (1): Registered EN50221 device
Feb  6 22:18:54 vdr kernel: mantis_hif_init (1): Adapter(1) Initializing Mantis Host Interface
Feb  6 22:18:54 vdr kernel: input: Mantis VP-2040 IR Receiver as /devices/virtual/input/input70
Feb  6 22:18:54 vdr kernel: general protection fault: 0000 [#1] PREEMPT SMP 
Feb  6 22:18:54 vdr kernel: last sysfs file: /sys/devices/virtual/input/input69/capabilities/sw
Feb  6 22:18:54 vdr kernel: CPU 0 
Feb  6 22:18:54 vdr kernel: Modules linked in: mantis(+) nvidia(P) snd_seq_oss snd_seq_midi_event snd_pcm_oss snd_mixer_oss lm85 hwmon_vid snd_hda_codec_realtek snd_hda_intel snd_hda_codec lnbp21 mb86a16 snd_pcm ves1820 ir_common snd_seq snd_timer stb6100 snd_seq_device budget_core tda10021 lirc_imon tda10023 saa7146 joydev stb0899 lirc_dev ttpci_eeprom stv0299 snd usbhid soundcore dvb_core ir_core snd_page_alloc 8250_pnp i2c_i801 8250 i2c_core serial_core asus_atk0110 evdev dm_mod uhci_hcd atl1e intel_agp ehci_hcd usbcore [last unloaded: budget]
Feb  6 22:18:54 vdr kernel: Pid: 8358, comm: modprobe Tainted: P           2.6.32.3-jk #1 P5QL PRO
Feb  6 22:18:54 vdr kernel: RIP: 0010:[<ffffffff8134b534>]  [<ffffffff8134b534>] _spin_lock+0x18/0x29
Feb  6 22:18:54 vdr kernel: RSP: 0018:ffff880068c3fa08  EFLAGS: 00010202
Feb  6 22:18:54 vdr kernel: RAX: 0000000000000100 RBX: ffff88006e585400 RCX: 0000000000000000
Feb  6 22:18:54 vdr kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00ffff88007e212e
Feb  6 22:18:54 vdr kernel: RBP: ffff880068c3fa08 R08: 000000d0000000d0 R09: ffff88007d8bc6c1
Feb  6 22:18:54 vdr kernel: R10: 0000000000000000 R11: 0000000000018600 R12: ffff88006e585400
Feb  6 22:18:54 vdr kernel: R13: ffff88006e585400 R14: ffff88007f8c6640 R15: 0000000000000000
Feb  6 22:18:54 vdr kernel: FS:  00007fa35ac6e6f0(0000) GS:ffff880001600000(0000) knlGS:0000000000000000
Feb  6 22:18:54 vdr kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  6 22:18:54 vdr kernel: CR2: 00007f977dd976f0 CR3: 0000000068f72000 CR4: 00000000000406f0
Feb  6 22:18:54 vdr kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  6 22:18:54 vdr kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  6 22:18:54 vdr kernel: Process modprobe (pid: 8358, threadinfo ffff880068c3e000, task ffff88006d616db0)
Feb  6 22:18:54 vdr kernel: Stack:
Feb  6 22:18:54 vdr kernel: ffff880068c3fa38 ffffffff81222539 ffff88006e585400 ffff88006e585400
Feb  6 22:18:54 vdr kernel: <0> 00000000ffffffea ffff88007d8bc6c1 ffff880068c3faa8 ffffffff8122355e
Feb  6 22:18:54 vdr kernel: <0> ffff88006e585508 0000000000000000 ffff880068c3fa78 ffffffff81229d2c
Feb  6 22:18:54 vdr kernel: Call Trace:
Feb  6 22:18:54 vdr kernel: [<ffffffff81222539>] get_device_parent+0x82/0x150
Feb  6 22:18:54 vdr kernel: [<ffffffff8122355e>] device_add+0x90/0x51e
Feb  6 22:18:54 vdr kernel: [<ffffffff81229d2c>] ? pm_runtime_init+0xc8/0xcc
Feb  6 22:18:54 vdr kernel: [<ffffffff81223a05>] device_register+0x19/0x1d
Feb  6 22:18:54 vdr kernel: [<ffffffff81223b17>] device_create_vargs+0x10e/0x13b
Feb  6 22:18:54 vdr kernel: [<ffffffff81223b8f>] device_create+0x4b/0x4d
Feb  6 22:18:54 vdr kernel: [<ffffffff81290fc5>] ? input_register_handle+0x62/0x9b
Feb  6 22:18:54 vdr kernel: [<ffffffff81030168>] ? __wake_up+0x43/0x50
Feb  6 22:18:54 vdr kernel: [<ffffffffa00ce864>] ir_register_class+0x65/0xc9 [ir_core]
Feb  6 22:18:54 vdr kernel: [<ffffffffa00ce2f9>] ir_input_register+0x252/0x293 [ir_core]
Feb  6 22:18:54 vdr kernel: [<ffffffffa0024d89>] mantis_rc_init+0x16f/0x1c5 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffffa00253b5>] mantis_core_init+0x2f4/0x357 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffffa0025703>] mantis_pci_probe+0x2eb/0x405 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffff811b6ed7>] local_pci_probe+0x12/0x16
Feb  6 22:18:54 vdr kernel: [<ffffffff811b7b4a>] pci_device_probe+0x5c/0x86
Feb  6 22:18:54 vdr kernel: [<ffffffff81225914>] ? driver_sysfs_add+0x4c/0x72
Feb  6 22:18:54 vdr kernel: [<ffffffff81225a60>] driver_probe_device+0xad/0x15f
Feb  6 22:18:54 vdr kernel: [<ffffffff81225b6a>] __driver_attach+0x58/0x7b
Feb  6 22:18:54 vdr kernel: [<ffffffff81225b12>] ? __driver_attach+0x0/0x7b
Feb  6 22:18:54 vdr kernel: [<ffffffff81225249>] bus_for_each_dev+0x4e/0x84
Feb  6 22:18:54 vdr kernel: [<ffffffff812258c6>] driver_attach+0x1c/0x1e
Feb  6 22:18:54 vdr kernel: [<ffffffff81224bb3>] bus_add_driver+0x11e/0x26f
Feb  6 22:18:54 vdr kernel: [<ffffffff81225e5e>] driver_register+0xb3/0x121
Feb  6 22:18:54 vdr kernel: [<ffffffffa002581d>] ? mantis_pci_init+0x0/0x20 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffff811b7d8f>] __pci_register_driver+0x51/0xbc
Feb  6 22:18:54 vdr kernel: [<ffffffffa002581d>] ? mantis_pci_init+0x0/0x20 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffffa002583b>] mantis_pci_init+0x1e/0x20 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffff81009060>] do_one_initcall+0x5a/0x14a
Feb  6 22:18:54 vdr kernel: [<ffffffff81068e16>] sys_init_module+0xd0/0x229
Feb  6 22:18:54 vdr kernel: [<ffffffff8100afab>] system_call_fastpath+0x16/0x1b
Feb  6 22:18:54 vdr kernel: Code: e0 ff ff f0 81 2f 00 00 00 01 74 05 e8 16 de e5 ff c9 c3 55 48 89 e5 65 48 8b 04 25 08 b5 00 00 ff 80 44 e0 ff ff b8 00 01 00 00 <f0> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c9 c3 55 48 89 e5 
Feb  6 22:18:54 vdr kernel: RIP  [<ffffffff8134b534>] _spin_lock+0x18/0x29
Feb  6 22:18:54 vdr kernel: RSP <ffff880068c3fa08>
Feb  6 22:18:54 vdr kernel: ---[ end trace d188dad023999c91 ]---
Feb  6 22:18:54 vdr kernel: note: modprobe[8358] exited with preempt_count 1
Feb  6 22:18:54 vdr kernel: BUG: scheduling while atomic: modprobe/8358/0x10000002
Feb  6 22:18:54 vdr kernel: Modules linked in: mantis(+) nvidia(P) snd_seq_oss snd_seq_midi_event snd_pcm_oss snd_mixer_oss lm85 hwmon_vid snd_hda_codec_realtek snd_hda_intel snd_hda_codec lnbp21 mb86a16 snd_pcm ves1820 ir_common snd_seq snd_timer stb6100 snd_seq_device budget_core tda10021 lirc_imon tda10023 saa7146 joydev stb0899 lirc_dev ttpci_eeprom stv0299 snd usbhid soundcore dvb_core ir_core snd_page_alloc 8250_pnp i2c_i801 8250 i2c_core serial_core asus_atk0110 evdev dm_mod uhci_hcd atl1e intel_agp ehci_hcd usbcore [last unloaded: budget]
Feb  6 22:18:54 vdr kernel: Pid: 8358, comm: modprobe Tainted: P      D    2.6.32.3-jk #1
Feb  6 22:18:54 vdr kernel: Call Trace:
Feb  6 22:18:54 vdr kernel: [<ffffffff810337b7>] __schedule_bug+0x57/0x5c
Feb  6 22:18:54 vdr kernel: [<ffffffff81349400>] schedule+0x10d/0x8b1
Feb  6 22:18:54 vdr kernel: [<ffffffff81091994>] ? free_hot_cold_page+0x1cd/0x21e
Feb  6 22:18:54 vdr kernel: [<ffffffff81091a8f>] ? __pagevec_free+0xaa/0xc2
Feb  6 22:18:54 vdr kernel: [<ffffffff810341fa>] __cond_resched+0x25/0x30
Feb  6 22:18:54 vdr kernel: [<ffffffff81349d7d>] _cond_resched+0x24/0x2f
Feb  6 22:18:54 vdr kernel: [<ffffffff810a4519>] unmap_vmas+0x6e1/0x8ac
Feb  6 22:18:54 vdr kernel: [<ffffffff810a8aea>] exit_mmap+0xbe/0x15e
Feb  6 22:18:54 vdr kernel: [<ffffffff810392e6>] mmput+0x2b/0xc9
Feb  6 22:18:54 vdr kernel: [<ffffffff8103d0bc>] exit_mm+0x10b/0x117
Feb  6 22:18:54 vdr kernel: [<ffffffff8106e755>] ? acct_collect+0x169/0x172
Feb  6 22:18:54 vdr kernel: [<ffffffff8103e91b>] do_exit+0x1d6/0x69c
Feb  6 22:18:54 vdr kernel: [<ffffffff8100ee3a>] oops_end+0x89/0x8e
Feb  6 22:18:54 vdr kernel: [<ffffffff8100effe>] die+0x55/0x5e
Feb  6 22:18:54 vdr kernel: [<ffffffff8100cd58>] do_general_protection+0x123/0x12b
Feb  6 22:18:54 vdr kernel: [<ffffffff8134bbff>] general_protection+0x1f/0x30
Feb  6 22:18:54 vdr kernel: [<ffffffff8134b534>] ? _spin_lock+0x18/0x29
Feb  6 22:18:54 vdr kernel: [<ffffffff81222539>] get_device_parent+0x82/0x150
Feb  6 22:18:54 vdr kernel: [<ffffffff8122355e>] device_add+0x90/0x51e
Feb  6 22:18:54 vdr kernel: [<ffffffff81229d2c>] ? pm_runtime_init+0xc8/0xcc
Feb  6 22:18:54 vdr kernel: [<ffffffff81223a05>] device_register+0x19/0x1d
Feb  6 22:18:54 vdr kernel: [<ffffffff81223b17>] device_create_vargs+0x10e/0x13b
Feb  6 22:18:54 vdr kernel: [<ffffffff81223b8f>] device_create+0x4b/0x4d
Feb  6 22:18:54 vdr kernel: [<ffffffff81290fc5>] ? input_register_handle+0x62/0x9b
Feb  6 22:18:54 vdr kernel: [<ffffffff81030168>] ? __wake_up+0x43/0x50
Feb  6 22:18:54 vdr kernel: [<ffffffffa00ce864>] ir_register_class+0x65/0xc9 [ir_core]
Feb  6 22:18:54 vdr kernel: [<ffffffffa00ce2f9>] ir_input_register+0x252/0x293 [ir_core]
Feb  6 22:18:54 vdr kernel: [<ffffffffa0024d89>] mantis_rc_init+0x16f/0x1c5 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffffa00253b5>] mantis_core_init+0x2f4/0x357 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffffa0025703>] mantis_pci_probe+0x2eb/0x405 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffff811b6ed7>] local_pci_probe+0x12/0x16
Feb  6 22:18:54 vdr kernel: [<ffffffff811b7b4a>] pci_device_probe+0x5c/0x86
Feb  6 22:18:54 vdr kernel: [<ffffffff81225914>] ? driver_sysfs_add+0x4c/0x72
Feb  6 22:18:54 vdr kernel: [<ffffffff81225a60>] driver_probe_device+0xad/0x15f
Feb  6 22:18:54 vdr kernel: [<ffffffff81225b6a>] __driver_attach+0x58/0x7b
Feb  6 22:18:54 vdr kernel: [<ffffffff81225b12>] ? __driver_attach+0x0/0x7b
Feb  6 22:18:54 vdr kernel: [<ffffffff81225249>] bus_for_each_dev+0x4e/0x84
Feb  6 22:18:54 vdr kernel: [<ffffffff812258c6>] driver_attach+0x1c/0x1e
Feb  6 22:18:54 vdr kernel: [<ffffffff81224bb3>] bus_add_driver+0x11e/0x26f
Feb  6 22:18:54 vdr kernel: [<ffffffff81225e5e>] driver_register+0xb3/0x121
Feb  6 22:18:54 vdr kernel: [<ffffffffa002581d>] ? mantis_pci_init+0x0/0x20 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffff811b7d8f>] __pci_register_driver+0x51/0xbc
Feb  6 22:18:54 vdr kernel: [<ffffffffa002581d>] ? mantis_pci_init+0x0/0x20 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffffa002583b>] mantis_pci_init+0x1e/0x20 [mantis]
Feb  6 22:18:54 vdr kernel: [<ffffffff81009060>] do_one_initcall+0x5a/0x14a
Feb  6 22:18:54 vdr kernel: [<ffffffff81068e16>] sys_init_module+0xd0/0x229
Feb  6 22:18:54 vdr kernel: [<ffffffff8100afab>] system_call_fastpath+0x16/0x1b
Feb  6 22:18:54 vdr kernel: saa7146: register extension 'budget dvb'.

--------------070909010405070409020903--
