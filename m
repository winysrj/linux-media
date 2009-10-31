Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:42295 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZJaHGI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 03:06:08 -0400
Received: by pxi9 with SMTP id 9so2251243pxi.4
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 00:06:13 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 31 Oct 2009 18:06:13 +1100
Message-ID: <ef52a95d0910310006u49a29347x1d0184a1ead75016@mail.gmail.com>
Subject: Can't insert saa7134 module compiled from dtv1000s testing repository
From: Michael Obst <m.obst@ugrad.unimelb.edu.au>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using http://kernellabs.com/hg/~mkrufky/dtv1000s I have previously
been able to compile and insert this module and the tv card has worked
very well. A few days ago the repository was updated and I now receive
the error below in dmesg after a successful compilation when I try to
insert the module. This is using kernel 2.6.28-16 (ubuntu 9.04) and
2.6.31-14 (ubuntu9.10)

Thanks

[   56.264719] Linux video capture interface: v2.00
[   56.274919] saa7130/34: v4l2 driver version 0.2.15 loaded
[   56.274951] saa7134 0000:04:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   56.274955] saa7130[0]: found at 0000:04:01.0, rev: 1, irq: 17,
latency: 64, mmio: 0xfebffc00
[   56.274969] BUG: unable to handle kernel paging request at 04131210
[   56.274969] IP: [<c03186d9>] strnlen+0x9/0x20
[   56.274972] *pde = 00000000
[   56.274974] Oops: 0000 [#1] SMP
[   56.274975] last sysfs file: /sys/module/ir_common/initstate
[   56.274977] Modules linked in: saa7134(+) ir_common v4l2_common
videodev v4l1_compat videobuf_dma_sg videobuf_core tveeprom
binfmt_misc ppdev arc4 ecb snd_hda_codec_realtek b43 snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi bridge stp snd_rawmidi
snd_seq_midi_event snd_seq bnep mac80211 snd_timer usblp
snd_seq_device nvidia(P) cfg80211 psmouse lp snd parport led_class
serio_raw asus_atk0110 btusb soundcore joydev snd_page_alloc
iptable_filter ip_tables x_tables hid_pl ff_memless dm_raid45 xor
usbhid floppy atl1e ohci1394 ieee1394 ssb intel_agp agpgart
[   56.275002]
[   56.275004] Pid: 2832, comm: modprobe Tainted: P
(2.6.31-14-generic #48-Ubuntu) System Product Name
[   56.275005] EIP: 0060:[<c03186d9>] EFLAGS: 00010097 CPU: 1
[   56.275006] EIP is at strnlen+0x9/0x20
[   56.275007] EAX: 04131210 EBX: c084b340 ECX: 04131210 EDX: fffffffe
[   56.275009] ESI: 04131210 EDI: c084af6c EBP: f4f4bce0 ESP: f4f4bce0
[   56.275010]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   56.275011] Process modprobe (pid: 2832, ti=f4f4a000 task=f601d7f0
task.ti=f4f4a000)
[   56.275012] Stack:
[   56.275013]  f4f4bd00 c0317012 00000000 fffffffe ffffffff c084af6c
f833d39c f4f4be14
[   56.275016] <0> f4f4bd60 c0317d96 00000004 00000000 ffffffff
0000000a ffffffff ffffffff
[   56.275020] <0> ffffffff ffffffff 00000009 00000400 c084af40
c084b340 f833d39e 00000004
[   56.275023] Call Trace:
[   56.275025]  [<c0317012>] ? string+0x32/0xe0
[   56.275027]  [<c0317d96>] ? vsnprintf+0x206/0x400
[   56.275029]  [<c0318036>] ? vscnprintf+0x16/0x30
[   56.275031]  [<c0145b54>] ? vprintk+0x84/0x3b0
[   56.275033]  [<c048b42f>] ? pci_read+0x2f/0x40
[   56.275036]  [<c032219b>] ? pci_bus_read_config_byte+0x5b/0x70
[   56.275038]  [<c0488d84>] ? pcibios_set_master+0x24/0xb0
[   56.275040]  [<c056e41c>] ? printk+0x18/0x1c
[   56.275045]  [<f833a237>] ? saa7134_initdev+0x47c/0xaf7 [saa7134]
[   56.275047]  [<c032821e>] ? pci_match_device+0xbe/0xd0
[   56.275049]  [<c032804e>] ? local_pci_probe+0xe/0x10
[   56.275051]  [<c0328dd0>] ? pci_device_probe+0x60/0x80
[   56.275053]  [<c03a2960>] ? really_probe+0x50/0x140
[   56.275055]  [<c05707da>] ? _spin_lock_irqsave+0x2a/0x40
[   56.275057]  [<c03a2a69>] ? driver_probe_device+0x19/0x20
[   56.275059]  [<c03a2ae9>] ? __driver_attach+0x79/0x80
[   56.275061]  [<c03a1fb8>] ? bus_for_each_dev+0x48/0x70
[   56.275062]  [<c03a2829>] ? driver_attach+0x19/0x20
[   56.275064]  [<c03a2a70>] ? __driver_attach+0x0/0x80
[   56.275066]  [<c03a220f>] ? bus_add_driver+0xbf/0x2a0
[   56.275067]  [<c0328d10>] ? pci_device_remove+0x0/0x40
[   56.275069]  [<c03a2d75>] ? driver_register+0x65/0x120
[   56.275071]  [<c056f684>] ? mutex_lock+0x14/0x40
[   56.275072]  [<c0328ff0>] ? __pci_register_driver+0x40/0xb0
[   56.275077]  [<f83305f2>] ? saa7134_init+0x52/0x60 [saa7134]
[   56.275079]  [<c010112c>] ? do_one_initcall+0x2c/0x190
[   56.275083]  [<f83305a0>] ? saa7134_init+0x0/0x60 [saa7134]
[   56.275085]  [<c0173751>] ? sys_init_module+0xb1/0x1f0
[   56.275087]  [<c010336c>] ? syscall_call+0x7/0xb
[   56.275088] Code: 76 00 55 85 c9 89 e5 57 89 c7 74 07 89 d0 f2 ae
75 01 4f 89 f8 5f 5d c3 8d 76 00 8d bc 27 00 00 00 00 55 89 c1 89 e5
89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 5d c3 90 90 90
90 90
[   56.275107] EIP: [<c03186d9>] strnlen+0x9/0x20 SS:ESP 0068:f4f4bce0
[   56.275110] CR2: 0000000004131210
[   56.275111] ---[ end trace a948e79e59e92dc1 ]---
