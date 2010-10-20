Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:64732 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0JTKbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 06:31:50 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Unloading cx8802 results in crash of ir_core:ir_unregister_class
Date: Wed, 20 Oct 2010 12:31:23 +0200
Cc: linux-media@vger.kernel.org, opensuse-kernel@opensuse.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201010201231.24173.hpj@urpla.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

since you got your fingers dirty with ir, I would like to direct this 
issue towards you. 

One of my servers acts as a vdr with 3 video cards:

07:01.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: medium devsel, IRQ 20
        Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
        Kernel modules: cx8800

07:01.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: medium devsel, IRQ 20
        Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel modules: cx88-alsa

07:01.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: medium devsel, IRQ 20
        Memory at f8000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel modules: cx8802

07:01.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [IR Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: bus master, medium devsel, latency 64, IRQ 10
        Memory at f7000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2

07:02.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: medium devsel, IRQ 21
        Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
        Kernel modules: cx8800

07:02.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: medium devsel, IRQ 21
        Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel modules: cx88-alsa

07:02.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: medium devsel, IRQ 21
        Memory at f4000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel modules: cx8802

07:02.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [IR Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: bus master, medium devsel, latency 64, IRQ 3
        Memory at f3000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2

07:03.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH Technotrend/Hauppauge DVB card rev2.3
        Flags: bus master, medium devsel, latency 64, IRQ 22
        Memory at f2fff000 (32-bit, non-prefetchable) [size=512]
        Kernel driver in use: dvb
        Kernel modules: dvb-ttpci

The Technotrend ff-dvb card is used with a cam and Alphacrypt CI, that
seem to need regular driver module unloads to keep working properly.

Unfortunately, unloading all the dvb drivers is not possible, because
unloading cx8802 leads to this oops:

Welcome to openSUSE 11.1 - Kernel 2.6.34.7-4-pae (ttyS0)
[111047.940641] BUG: unable to handle kernel paging request at 313a3030
[111047.953710] IP: [<c03654fe>] sysfs_remove_group+0x7e/0xd0
[111047.964838] *pdpt = 0000000029f53001 *pde = 0000000000000000 
[111047.976687] Oops: 0000 [#1] SMP 
[111047.983453] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[111047.999559] Modules linked in: ip6t_LOG ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp ipt_LOG xt_limit iptable_nat ]
[111048.204691] 
[111048.207843] Pid: 10029, comm: rmmod Not tainted 2.6.34.7-4-pae #1 P7F-E/System Product Name
[111048.224918] EIP: 0060:[<c03654fe>] EFLAGS: 00210206 CPU: 0
[111048.236201] EIP is at sysfs_remove_group+0x7e/0xd0
[111048.246007] EAX: ef4ff008 EBX: 313a3030 ECX: f0600000 EDX: 00000000
[111048.258879] ESI: 00000000 EDI: efb7e71c EBP: ef4ff008 ESP: e3ee7e64
[111048.271716]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[111048.282668] Process rmmod (pid: 10029, ti=e3ee6000 task=eaf00e00 task.ti=e3ee6000)
[111048.298133] Stack:
[111048.302319]  f02cabe0 00000041 ef5208c0 ef49ac00 00200286 efb7e700 ef3f0000 00000000
[111048.318132] <0> ef329800 f8f84932 efb7e700 ef3f0000 f8f84044 00000000 f8ffffff f015f1c0
[111048.334811] <0> ef329800 f917c655 00000000 f8000000 f9178dd9 01000000 00000000 f8ffffff
[111048.351939] Call Trace:
[111048.357213]  [<f8f84932>] ir_unregister_class+0x32/0x60 [ir_core]
[111048.369821]  [<f8f84044>] ir_input_unregister+0x44/0x90 [ir_core]
[111048.382338]  [<f917c655>] cx88_ir_fini+0x25/0x50 [cx88xx]
[111048.393437]  [<f9178dd9>] cx88_core_put+0xb9/0x140 [cx88xx]
[111048.404834]  [<f91e8795>] cx8802_remove+0x82/0x169 [cx8802]
[111048.416319]  [<c041d966>] pci_device_remove+0x16/0x40
[111048.426610]  [<c04b214d>] __device_release_driver+0x6d/0xd0
[111048.437993]  [<c04b222f>] driver_detach+0x7f/0x90
[111048.447872]  [<c04b11fa>] bus_remove_driver+0x7a/0x100
[111048.458687]  [<c041db6e>] pci_unregister_driver+0x2e/0x80
[111048.469658]  [<c0279669>] sys_delete_module+0x179/0x240
[111048.480262]  [<c020320c>] sysenter_do_call+0x12/0x22
[111048.490357]  [<ffffe424>] 0xffffe424
[111048.497680] Code: f0 ff 0e 0f 94 c0 84 c0 75 0b 83 c4 14 5b 5e 5f 5d c3 8d 76 00 83 c4 14 89 f0 5b 5e 5f 5d e9 ca e 
[111048.537852] EIP: [<c03654fe>] sysfs_remove_group+0x7e/0xd0 SS:ESP 0068:e3ee7e64
[111048.552782] CR2: 00000000313a3030
[111048.559854] ---[ end trace d7231a8e672c4adc ]---

Any ideas, what's going wrong here?

Pete
