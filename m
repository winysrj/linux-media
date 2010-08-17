Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36016 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab0HQJ5k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Aug 2010 05:57:40 -0400
Received: by qwh6 with SMTP id 6so5862447qwh.19
        for <linux-media@vger.kernel.org>; Tue, 17 Aug 2010 02:57:40 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 Aug 2010 14:27:39 +0430
Message-ID: <AANLkTi=OTqzA41=H-=M7Vmrq=uY=Av-bjVNDHpQ=LRv1@mail.gmail.com>
Subject: SkyStar S2 on an embedded Linux
From: Nima Mohammadi <nima.irt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi there,
I've got a TechniSat SkyStar S2 card. The Linux driver provided at
vendor's website isn't suitable for recent kernels (2.6.34, in my
case). So I use s2-liplianin which works fine and I don't have any
problem with it.

Well, I'm building a Linux embedded system using Busybox and Linux
kernel 2.6.34 to capture a satellite transponder. Normally when we
want a device to work, we identify the kernel modules needed for it
and then we copy them to the target system's filesystem. But it
doesn't work. I even desperately copied all the modules located in the
/lib/modules/2.6.34/ directory to the target system, but nothing
changed.

# modprobe b2c2-flexcop-pci
[  289.593984] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV
receiver chip loaded successfully
[  289.608068] flexcop-pci: will use the HW PID filter.
[  289.613148] flexcop-pci: card revision 2
[  289.617965] b2c2_flexcop_pci 0000:02:03.0: PCI INT A -> GSI 19
(level, low) -> IRQ 19
[  289.625985] ------------[ cut here ]------------
[  289.630712] WARNING: at fs/proc/generic.c:317 __xlate_proc_name+0xb3/0xd0()
[  289.637788] Hardware name: MS-6788
[  289.641282] name 'Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver'
[  289.648498] Modules linked in: b2c2_flexcop_pci(+) b2c2_flexcop
cx24123 cx24113 dvb_core s5h1420
[  289.657859] Pid: 58, comm: modprobe Not tainted 2.6.34 #1
[  289.663374] Call Trace:
[  289.665998]  [<c0149472>] warn_slowpath_common+0x72/0xa0
[  289.671525]  [<c024fd73>] ? __xlate_proc_name+0xb3/0xd0
[  289.677009]  [<c024fd73>] ? __xlate_proc_name+0xb3/0xd0
[  289.682488]  [<c01494eb>] warn_slowpath_fmt+0x2b/0x30
[  289.687780]  [<c024fd73>] __xlate_proc_name+0xb3/0xd0
[  289.693076]  [<c02509ec>] __proc_create+0x5c/0x100
[  289.698102]  [<c0250c68>] proc_mkdir_mode+0x28/0x60
[  289.703233]  [<c0250cb4>] proc_mkdir+0x14/0x20
[  289.707930]  [<c01a143b>] register_handler_proc+0xeb/0x110
[  289.713727]  [<c019ef27>] __setup_irq+0x197/0x2e0
[  289.718668]  [<c01fc7d1>] ? kmem_cache_alloc_notrace+0x91/0xb0
[  289.724761]  [<c0389e1c>] ? __pci_request_region+0x7c/0x130
[  289.730621]  [<f08a01b0>] ? flexcop_pci_isr+0x0/0x330 [b2c2_flexcop_pci]
[  289.737638]  [<c019f7a4>] request_threaded_irq+0xd4/0x190
[  289.743316]  [<f08a0648>] flexcop_pci_probe+0x168/0x2c0 [b2c2_flexcop_pci]
[  289.750485]  [<c038c473>] local_pci_probe+0x13/0x20
[  289.755584]  [<c038d428>] pci_device_probe+0x68/0x90
[  289.760830]  [<c040c2bf>] driver_probe_device+0x7f/0x170
[  289.766419]  [<c040c431>] __driver_attach+0x81/0x90
[  289.771531]  [<c040b8a3>] bus_for_each_dev+0x53/0x80
[  289.776755]  [<c040c15e>] driver_attach+0x1e/0x20
[  289.781713]  [<c040c3b0>] ? __driver_attach+0x0/0x90
[  289.786946]  [<c040bb25>] bus_add_driver+0xd5/0x280
[  289.792044]  [<c038d360>] ? pci_device_remove+0x0/0x40
[  289.797417]  [<c040c72a>] driver_register+0x6a/0x130
[  289.802598]  [<c038d665>] __pci_register_driver+0x45/0xb0
[  289.808295]  [<f08a4017>] flexcop_pci_module_init+0x17/0x19
[b2c2_flexcop_pci]
[  289.815836]  [<c0101131>] do_one_initcall+0x31/0x190
[  289.821053]  [<f08a4000>] ? flexcop_pci_module_init+0x0/0x19
[b2c2_flexcop_pci]
[  289.828682]  [<c017fa11>] sys_init_module+0xb1/0x220
[  289.833867]  [<c0205a65>] ? sys_close+0x75/0xc0
[  289.838623]  [<c0103023>] sysenter_do_call+0x12/0x28
[  289.843804] ---[ end trace 48ba8660c9a13b4f ]---
[  289.864137] DVB: registering new adapter (FlexCop Digital TV device)
[  289.872945] b2c2-flexcop: MAC address = 00:08:c9:e0:bd:92
[  289.917328] CX24120: cx24120_attach: -> Conexant cx24120/cx24118 -
DVBS/S2 Satellite demod/tuner
[  289.926341] CX24120: cx24120_attach: -> Driver version: 'SVT -
0.0.3 - 06.09.2009 13:16:39'
[  289.935045] CX24120: cx24120_attach: -> Demod CX24120 rev. 0x07 detected.
[  289.942023] CX24120: cx24120_attach: -> Conexant cx24120/cx24118 -
DVBS/S2 Satellite demod/tuner ATTACHED.
[  289.986637] b2c2-flexcop: ISL6421 successfully attached.
[  289.992081] b2c2-flexcop: found 'Conexant CX24120/CX24118' .
[  289.997856] DVB: registering adapter 0 frontend 0 (Conexant
CX24120/CX24118)...
[  290.005522] b2c2-flexcop: initialization of 'Sky2PC/SkyStar S2
DVB-S/S2 rev 3.3' at the 'PCI' bus controlled by a 'FlexCopIIb'
complete


Actually after getting these strange messages, the /dev/dvb/adapter0/
gets populated, but running the "scan" program output these messages:

[  502.189814] b2c2_flexcop_pci 0000:02:03.0: firmware: requesting
dvb-fe-cx24120-1.20.58.2.fw
[  562.196696] CX24120: cx24120_init: ### ERROR: Could not load
firmware (dvb-fe-cx24120-1.20.58.2.fw): 254
[  570.216014] CX24120: cx24120_message_send: ### ERROR: Too long
waiting 'done' state from reg(0x1F). :(
[  578.276011] CX24120: cx24120_message_send: ### ERROR: Too long
waiting 'done' state from reg(0x1F). :(

Well, it seems that it nags about the firmware, even though I copied
the /lib/firmware/ directory to the target system.
One other issue is that neither b2c2-flexcop-pci nor the modules it
depends on don't need the cx24120 module to be loaded, but it does get
loaded!

On target system:
# lsmod
isl6421 1353 1 - Live 0xf09fa000
cx24120 20683 1 - Live 0xf09eb000
b2c2_flexcop_pci 5239 0 - Live 0xf08a0000
b2c2_flexcop 27440 1 b2c2_flexcop_pci, Live 0xf088c000
cx24123 12630 1 b2c2_flexcop, Live 0xf0876000
cx24113 6965 1 b2c2_flexcop, Live 0xf0868000
dvb_core 86360 1 b2c2_flexcop, Live 0xf0843000
s5h1420 10592 1 b2c2_flexcop, Live 0xf0805000

On my working system:
root@nima-pc:~# lsmod
b2c2_flexcop_pci        5239  0
b2c2_flexcop           27440  1 b2c2_flexcop_pci
dvb_core               86360  1 b2c2_flexcop
cx24123                12630  1 b2c2_flexcop
cx24113                 6965  1 b2c2_flexcop
s5h1420                10592  1 b2c2_flexcop
...

-- Nima Mohammadi
