Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.masin.eu ([80.188.199.19]:57470 "EHLO mail.masin.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab2GRMwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 08:52:41 -0400
From: =?utf-8?Q?Radek_Ma=C5=A1=C3=ADn?= <radek@masin.eu>
Date: Wed, 18 Jul 2012 14:52:38 +0200
To: linux-media@vger.kernel.org
Message-ID: <1342615958949547500@masin.eu>
Subject: CX25821 driver in kernel 3.4.4 problem
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   Hello,
I have upgraded my testing system with cx25821 based video capture card to system (OpenSuSE 12.1)
with kernel 3.4.4 and driver for cx25821 doesn't work. Previous system was with kernel 2.6.37 (OpenSuSE 11.4)
with this patch http://patchwork.linuxtv.org/patch/10056/ and manualy compiled module. With kernel 2.6.37
driver works properly.

Now I can see, that driver is loaded, but no device in /dev/ are created. Please take a look for attached 
outputs:

lspci -v
02:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8210
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at f7c00000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express Endpoint, MSI 00
        Capabilities: [80] Power Management version 3
        Capabilities: [90] Vital Product Data
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [200] Virtual Channel
        Kernel driver in use: cx25821

lsmod | grep cx
cx25821               102052  1
videodev               95422  1 cx25821
videobuf_dma_sg        18786  1 cx25821
videobuf_core          29505  2 cx25821,videobuf_dma_sg
btcx_risc              13400  1 cx25821
tveeprom               17009  1 cx25821

ls /dev/vi*
ls: cannot access /dev/vi*: No such file or directory

dmesg
[   10.033013] Linux video capture interface: v2.00
[   10.033637] cx25821: driver version 0.0.106 loaded
[   10.033667] cx25821: Athena pci enable !
[   10.033668] cx25821:
[   10.033669] ***********************************
[   10.033670] cx25821: cx25821 set up
[   10.033671] cx25821: ***********************************
[   10.033672]
[   10.033678] BUG: unable to handle kernel paging request at f7bc1d94
[   10.034398] IP: [<c048a9a1>] strcpy+0x11/0x30
[   10.034894] *pdpt = 0000000000b5e001 *pde = 0000000033c3f067 *pte = 800000011c129161
[   10.035799] Oops: 0003 [#1] PREEMPT SMP
[   10.036282] Modules linked in: cx25821(+) videodev eeepc_wmi asus_wmi sparse_keymap rfkill hid_picolcd lcd fb_sys_fops sysimgblt sysfillrect videobuf_dma_sg videobuf_core btcx_risc acpi_cpufreq mperf coretemp syscopyarea tveeprom iTCO_wdt iTCO_vendor_support r8169 pci_hotplug serio_raw pcspkr edd mei(C) wmi sg i2c_i801 crc32c_intel microcode autofs4 i915 drm_kms_helper drm i2c_algo_bit button video fan processor thermal thermal_sys
[   10.041267]
[   10.041430] Pid: 403, comm: modprobe Tainted: G         C   3.4.4-32-desktop #1 System manufacturer System Product Name/P8H61-M LX
[   10.042754] EIP: 0060:[<c048a9a1>] EFLAGS: 00010282 CPU: 0
[   10.043347] EIP is at strcpy+0x11/0x30
[   10.043752] EAX: f7bc1d75 EBX: f2dd2000 ECX: f7bc1d94 EDX: f7bc1bf0
[   10.044428] ESI: f7bc1bf1 EDI: f7bc1d94 EBP: f2dd200c ESP: f2d79da4
[   10.045103]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   10.045686] CR0: 8005003b CR2: f7bc1d94 CR3: 337e8000 CR4: 000407f0
[   10.046364] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   10.047041] DR6: ffff0ff0 DR7: 00000400
[   10.047456] Process modprobe (pid: 403, ti=f2d78000 task=f2d6e470 task.ti=f2d78000)
[   10.048279] Stack:
[   10.048498]  f2dd34bc f3db7000 f7bc02ec f2dd34bc f7bc1be4 00000001 00000300 00000000
[   10.049490]  f2dd2000 f3db7000 00000000 f2dd2000 f3db7000 f2dd200c f7bc076f f7bc28b8
[   10.050481]  f2e83e48 f2e83e48 f2d79e3c f3dc2848 c03947cc c03945f2 00000246 00000246
[   10.051473] Call Trace:
[   10.051748]  [<f7bc02ec>] cx25821_dev_setup+0xaa/0x438 [cx25821]
[   10.052405]  [<f7bc076f>] cx25821_initdev+0x7f/0x204 [cx25821]
[   10.053039]  [<c04a5c22>] local_pci_probe+0x42/0xb0
[   10.053569]  [<c04a70c9>] __pci_device_probe+0xd9/0xe0
[   10.054127]  [<c04a70f3>] pci_device_probe+0x23/0x40
[   10.054667]  [<c0541d96>] really_probe+0x56/0x2e0
[   10.055177]  [<c0542184>] driver_probe_device+0x44/0xa0
[   10.055743]  [<c0542259>] __driver_attach+0x79/0x80
[   10.056271]  [<c054063a>] bus_for_each_dev+0x3a/0x60
[   10.056809]  [<c0541a39>] driver_attach+0x19/0x20
[   10.057320]  [<c0541627>] bus_add_driver+0x187/0x280
[   10.057859]  [<c05426df>] driver_register+0x5f/0x100
[   10.058396]  [<c04a6e4c>] __pci_register_driver+0x3c/0xa0
[   10.058981]  [<c0201112>] do_one_initcall+0x32/0x170
[   10.059520]  [<c028f597>] sys_init_module+0xa7/0x210
[   10.060059]  [<c070ee2d>] syscall_call+0x7/0xb
[   10.060541]  [<b770662e>] 0xb770662d
[   10.060926] Code: 75 07 51 e8 12 b8 ff ff 59 c3 51 52 e8 b9 b7 ff ff 5a 59 c3 90 90 90 90 90 90 83 ec 08 89 c1 89 34 24 89 d6 89 7c 24 04 89 c7 ac <aa> 84 c0 75 fa 89 c8 8b 34 24 8b 7c 24 04 83 c4 08 c3 8d b6 00
[   10.064231] EIP: [<c048a9a1>] strcpy+0x11/0x30 SS:ESP 0068:f2d79da4
[   10.064947] CR2: 00000000f7bc1d94
[   10.065308] ---[ end trace 31c669691362927a ]---
[   10.066063] udevd[341]: '/sbin/modprobe -bv pci:v000014F1d00008210sv00000000sd00000000bc04sc00i00' [403] terminated by signal 9 (Killed)

Regards
Radek Masin
radek@masin.eu

